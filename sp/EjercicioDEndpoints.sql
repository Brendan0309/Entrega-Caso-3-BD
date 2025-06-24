CREATE OR ALTER PROCEDURE [dbo].[repartirDividendos]
    -- Parámetros de entrada
    @propuestaId INT,                 -- ID de la propuesta/proyecto
    @montoTotal DECIMAL(15, 2),       -- Monto total a distribuir
    @fechaDistribucion DATE,          -- Fecha de distribución
    @userIdEjecutor INT,              -- ID del usuario que ejecuta la distribución
    
    -- Parámetros de salida
    @resultado BIT OUTPUT,            -- Resultado de la operación (1=éxito, 0=fallo)
    @mensaje VARCHAR(500) OUTPUT      -- Mensaje descriptivo del resultado
AS
BEGIN
    SET NOCOUNT ON;  -- Evita que se envíen mensajes de conteo de filas
    
    BEGIN TRY
        BEGIN TRANSACTION;  -- Inicia transacción atómica
        
        -- Variables de control
        DECLARE @estadoPropuestaValido BIT = 0;
        DECLARE @fiscalizacionesAprobadas BIT = 1;
        DECLARE @inversionistasValidos BIT = 1;
        
        -- Variables para cálculo y registro
        DECLARE @transaccionId INT;
        DECLARE @inversionId INT;
        DECLARE @inversionistaId INT;
        DECLARE @montoInversion DECIMAL(15, 2);
        DECLARE @montoTotalInvertido DECIMAL(15, 2);
        DECLARE @porcentajeParticipacion DECIMAL(10, 6);
        DECLARE @montoDistribuir DECIMAL(15, 2);
        DECLARE @distributionId INT;
        DECLARE @pagoId INT;
        DECLARE @scheduleId INT;
        
        /* ==================== SECCIÓN DE VALIDACIONES ==================== */
        -- Endpoint: Validar que el proyecto esté en estado ejecutando
        
        -- 1. Validar estado del proyecto (debe estar "Publicada")
        SELECT @estadoPropuestaValido = 1
        FROM [dbo].[voto_Propuestas] p
        JOIN [dbo].[voto_Estado] e ON p.estadoId = e.estadoId
        WHERE p.propuestaId = @propuestaId
        AND e.name = 'Publicada';
        
        -- Validación 1: Estado del proyecto
        IF @estadoPropuestaValido = 0
        BEGIN
            SET @resultado = 0;
            SET @mensaje = 'Error: El proyecto no está en estado "Publicada"';
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        
        -- Endpoint: Validar fiscalizaciones aprobadas
        
        -- 2. Verificar que todas las fiscalizaciones estén aprobadas
        IF EXISTS (
            SELECT 1 
            FROM [dbo].[voto_Fiscalizaciones] 
            WHERE propuestaId = @propuestaId 
            AND estado <> 'Aprobado'
        )
        BEGIN
            SET @fiscalizacionesAprobadas = 0;
        END;
        
        -- Validación 2: Fiscalizaciones aprobadas
        IF @fiscalizacionesAprobadas = 0
        BEGIN
            SET @resultado = 0;
            SET @mensaje = 'Error: Existen fiscalizaciones pendientes o no aprobadas';
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        
        -- Endpoint: Recibir y verificar reporte de ganancias y disponibilidad de fondos
        
        -- 3. Validación implícita: El monto total viene como parámetro ya validado
        -- (En una implementación real se podría verificar contra saldos disponibles)
        
        -- Endpoint: Consultar los inversionistas y sus porcentajes de participación
        
        -- 4. Calcular el monto total invertido en el proyecto
        SELECT @montoTotalInvertido = SUM(monto)
        FROM [dbo].[voto_Inversiones]
        WHERE propuestaId = @propuestaId
        AND estado = 'Aprobado';
        
        -- Validación 3: Existencia de inversiones aprobadas
        IF @montoTotalInvertido IS NULL OR @montoTotalInvertido <= 0
        BEGIN
            SET @resultado = 0;
            SET @mensaje = 'Error: No hay inversiones aprobadas para este proyecto';
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        
        -- Endpoint: Verificar medios de depósito válidos
        
        -- 5. Verificar que todos los inversionistas tengan cuentas bancarias válidas
        IF EXISTS (
            SELECT 1
            FROM [dbo].[voto_Inversiones] i
            JOIN [dbo].[voto_Inversionistas] inv ON i.userId = inv.inversionistaId
            LEFT JOIN [dbo].[voto_contactInfoInversionistas] ci ON inv.inversionistaId = ci.inversionistaId
            LEFT JOIN [dbo].[voto_ContactInfoTypes] cit ON ci.contactInfoTypeId = cit.contactInfoTypeId
            WHERE i.propuestaId = @propuestaId
            AND i.estado = 'Aprobado'
            AND cit.name = 'CuentaBancaria'
            AND (ci.value IS NULL OR ci.enabled = 0)
        )
        BEGIN
            SET @inversionistasValidos = 0;
        END;
        
        -- Validación 4: Medios de pago válidos
        IF @inversionistasValidos = 0
        BEGIN
            SET @resultado = 0;
            SET @mensaje = 'Error: Uno o más inversionistas no tienen medios de depósito válidos';
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        
        /* ==================== SECCIÓN DE OPERACIONES ==================== */
        -- Endpoint: Calcular montos a distribuir
        
        -- 1. Registrar encabezado de distribución
        INSERT INTO [dbo].[voto_Distribuciones] (
            propuestaId, montoTotal, fechaDistribucion, userIdEjecutor
        )
        VALUES (
            @propuestaId, @montoTotal, @fechaDistribucion, @userIdEjecutor
        );
        
        SET @distributionId = SCOPE_IDENTITY();
        
        -- 2. Procesar cada inversión aprobada
        DECLARE inversion_cursor CURSOR FOR
        SELECT 
            i.inversionId, 
            i.userId, 
            i.monto
        FROM [dbo].[voto_Inversiones] i
        WHERE i.propuestaId = @propuestaId
        AND i.estado = 'Aprobado';
        
        OPEN inversion_cursor;
        FETCH NEXT FROM inversion_cursor INTO @inversionId, @inversionistaId, @montoInversion;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Calcular porcentaje de participación y monto a distribuir
            SET @porcentajeParticipacion = (@montoInversion / @montoTotalInvertido);
            SET @montoDistribuir = @montoTotal * @porcentajeParticipacion;
            
            -- Endpoint: Generar transacciones de pago
            
            -- 3. Registrar transacción de pago (simplificado)
            INSERT INTO [dbo].[voto_Pagos] (
                pagoMedioId, propuestaId, inversionistaId, monto,
                fecha, result, estado
            )
            VALUES (
                2, -- ID para transferencia bancaria
                @propuestaId,
                @inversionistaId,
                @montoDistribuir,
                GETDATE(),
                1, -- Éxito
                'Completado'
            );
            
            SET @pagoId = SCOPE_IDENTITY();
            
            -- Endpoint: Registrar ciclo de distribución
            
            -- 4. Registrar detalle de distribución
            INSERT INTO [dbo].[voto_DistribucionDetalle] (
                distributionId, inversionId, inversionistaId,
                montoInversion, porcentajeParticipacion, montoDistribuido,
                pagoId, fechaRegistro
            )
            VALUES (
                @distributionId, @inversionId, @inversionistaId,
                @montoInversion, @porcentajeParticipacion, @montoDistribuir,
                @pagoId, GETDATE()
            );
            
            FETCH NEXT FROM inversion_cursor INTO @inversionId, @inversionistaId, @montoInversion;
        END;
        
        CLOSE inversion_cursor;
        DEALLOCATE inversion_cursor;
        
        -- Confirmar transacción si todo fue exitoso
        COMMIT TRANSACTION;
        
        -- Retornar resultado exitoso
        SET @resultado = 1;
        SET @mensaje = 'Distribución de dividendos completada exitosamente para el proyecto ' + 
                      CAST(@propuestaId AS VARCHAR);
        
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;  -- Revertir cambios en caso de error
            
        SET @resultado = 0;
        SET @mensaje = 'Error: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

drop procedure [repartirDividendos]

DECLARE @resultado BIT;
DECLARE @mensaje VARCHAR(500);

EXEC [dbo].[repartirDividendos]
    @propuestaId = 1,  -- Usar un ID de propuesta existente
    @montoTotal = 10000.00,
    @fechaDistribucion = '2025-06-15',
    @userIdEjecutor = 1,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

SELECT @resultado AS Resultado, @mensaje AS Mensaje;

select * from voto_Propuestas

SELECT * FROM [dbo].[voto_Estado];

UPDATE [dbo].[voto_Propuestas]
SET estadoId = (SELECT estadoId FROM [dbo].[voto_Estado] WHERE name = 'Publicada')
WHERE propuestaId = 1;

SELECT p.propuestaId, e.name AS estado
FROM [dbo].[voto_Propuestas] p
JOIN [dbo].[voto_Estado] e ON p.estadoId = e.estadoId
WHERE p.propuestaId = 1;
