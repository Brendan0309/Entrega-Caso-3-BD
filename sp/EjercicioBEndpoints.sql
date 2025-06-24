create PROCEDURE [dbo].[revisarPropuesta]
    @tituloPropuesta VARCHAR(100),  -- T�tulo de la propuesta a revisar (en lugar de ID)
    @usernameRevisor VARCHAR(50),   -- Nombre de usuario del revisor (en lugar de ID)
    @mensajeSalida VARCHAR(500) OUTPUT  -- Mensaje de salida con el resultado del proceso
AS
BEGIN
    -- Evitar mensajes de conteo de filas para mejorar rendimiento
    SET NOCOUNT ON;
    
    /* =====================================================
       DECLARACI�N DE VARIABLES
       ===================================================== */
    -- Variables para almacenar IDs clave
    DECLARE @propuestaId INT, @userIdRevisor INT, @tipoPropuestaId INT;
    
    -- Variables para estados
    DECLARE @estadoActual VARCHAR(50), @estadoEnRevisionId INT;
    
    -- Variables de control del proceso
    DECLARE @workflowCount INT = 0, @cursorExists BIT = 0;
    DECLARE @transactionName VARCHAR(32) = 'revisarPropuesta';
    DECLARE @fechaActual DATETIME = GETDATE();
    
    -- Variables para registros
    DECLARE @newBitacoraId INT, @resultadoRandom BIT;

    /* =====================================================
       OBTENER DATOS NECESARIOS (FUERA DE TRANSACCI�N)
       ===================================================== */
    -- Obtener informaci�n principal de la propuesta en una sola consulta
    SELECT 
        @propuestaId = p.propuestaId,               -- ID de la propuesta
        @tipoPropuestaId = p.proposalTypeId,        -- Tipo de propuesta
        @estadoActual = e.name,                     -- Estado actual (nombre)
        @estadoEnRevisionId = (SELECT estadoId FROM voto_Estado WHERE name = 'En revisi�n')  -- ID del estado "En revisi�n"
    FROM voto_Propuestas p
    JOIN voto_Estado e ON p.estadoId = e.estadoId
    WHERE p.titulo = @tituloPropuesta;  -- Buscar por t�tulo en lugar de ID
    
    -- Obtener ID del usuario revisor
    SELECT @userIdRevisor = userId 
    FROM voto_Users 
    WHERE username = @usernameRevisor;  -- Buscar por nombre de usuario
    
    /* =====================================================
       VALIDACIONES INICIALES
       ===================================================== */
    -- Validar que la propuesta existe
    IF @propuestaId IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Propuesta no encontrada';
        RETURN;
    END
    
    -- Validar que el usuario revisor existe
    IF @userIdRevisor IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Usuario no v�lido';
        RETURN;
    END
    
    -- Validar que la propuesta est� en estado v�lido para revisi�n
    IF @estadoActual NOT IN ('Pendiente de validaci�n', 'En revisi�n')
    BEGIN
        SET @mensajeSalida = 'Error: Estado no v�lido para revisi�n';
        RETURN;
    END
    
    -- Validar que existe el estado "En revisi�n" configurado
    IF @estadoEnRevisionId IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Estado "En revisi�n" no configurado';
        RETURN;
    END
    
    /* =====================================================
       OBTENER WORKFLOWS CONFIGURADOS
       ===================================================== */
    -- Tabla temporal para almacenar los workflows asociados al tipo de propuesta
    DECLARE @Workflows TABLE (
        workflow_id INT,           -- ID del workflow
        nombre VARCHAR(100),       -- Nombre del workflow
        orderIndex INT,            -- Orden de ejecuci�n
        configWork VARCHAR(1500)   -- Configuraci�n espec�fica del workflow
    );
    
    -- Obtener todos los workflows activos asociados al tipo de propuesta
    INSERT INTO @Workflows
    SELECT 
        w.workflow_id,
        w.nombre,
        wtp.orderIndex,  -- Respetar el orden definido en la configuraci�n
        w.configWork     -- Usar la configuraci�n almacenada en el workflow
    FROM voto_WorkTipoPropuesta wtp
    JOIN wk_workflow w ON wtp.workflowId = w.workflow_id
    WHERE wtp.tipoPropuestaId = @tipoPropuestaId  -- Filtrar por tipo de propuesta
    AND wtp.enabled = 1       -- Solo workflows habilitados
    AND w.activo = 1          -- Solo workflows activos
    ORDER BY wtp.orderIndex;  -- Ordenar seg�n la secuencia definida
    
    -- Validar que hay workflows configurados para este tipo de propuesta
    IF NOT EXISTS (SELECT 1 FROM @Workflows)
    BEGIN
        SET @mensajeSalida = 'Error: No hay workflows configurados';
        RETURN;
    END
    
    /* =====================================================
       INICIAR TRANSACCI�N (OPERACIONES CR�TICAS)
       ===================================================== */
    BEGIN TRY
        -- Marcar inicio de transacci�n at�mica
        BEGIN TRANSACTION @transactionName;
        
        /* -----------------------------------------------------
           1. ACTUALIZAR ESTADO DE LA PROPUESTA
           ----------------------------------------------------- */
        -- Cambiar estado a "En revisi�n"
        UPDATE voto_Propuestas
        SET estadoId = @estadoEnRevisionId
        WHERE propuestaId = @propuestaId;
        
        /* -----------------------------------------------------
           2. EJECUTAR WORKFLOWS EN ORDEN CONFIGURADO
           ----------------------------------------------------- */
        -- Variables para el cursor
        DECLARE @workflow_id INT, @workflow_nombre VARCHAR(100), @configWork VARCHAR(1500);
        DECLARE @run_id UNIQUEIDENTIFIER;  -- Identificador �nico para cada ejecuci�n
        
        -- Crear cursor para procesar cada workflow en el orden definido
        DECLARE workflow_cursor CURSOR LOCAL FOR
        SELECT workflow_id, nombre, configWork FROM @Workflows ORDER BY orderIndex;
        
        -- Abrir cursor y procesar cada workflow
        OPEN workflow_cursor;
        SET @cursorExists = 1;  -- Marcar que el cursor est� abierto
        FETCH NEXT FROM workflow_cursor INTO @workflow_id, @workflow_nombre, @configWork;
        
        -- Procesar cada workflow secuencialmente
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Generar identificador �nico para esta ejecuci�n
            SET @run_id = NEWID();
            
            -- Registrar la ejecuci�n del workflow usando su configuraci�n espec�fica
            INSERT INTO wk_workflow_run (
                run_id,         -- Identificador �nico de ejecuci�n
                workflow_id,    -- ID del workflow
                estadoId,       -- Estado inicial (1 = Pendiente)
                fecha_inicio,   -- Marca de tiempo
                parametros      -- Configuraci�n espec�fica del workflow
            ) VALUES (
                @run_id, 
                @workflow_id, 
                1, 
                @fechaActual, 
                @configWork  -- Usar la configuraci�n almacenada en el workflow
            );
            
            -- Obtener pr�ximo ID para la bit�cora
            SELECT @newBitacoraId = ISNULL(MAX(bitacoraId), 0) + 1 FROM wk_bitacora;
            
            -- Registrar en bit�cora el inicio del workflow
            INSERT INTO wk_bitacora (
                bitacoraId,     -- ID �nico
                wkLogTypeId,    -- Tipo de registro (1 = Inicio)
                fecha,          -- Marca de tiempo
                resultado,      -- Mensaje descriptivo
                estadoId,       -- Estado del registro
                workflow_Id,    -- ID del workflow relacionado
                parametros      -- Informaci�n adicional
            ) VALUES (
                @newBitacoraId, 
                1, 
                @fechaActual,
                'Ejecutado workflow: ' + @workflow_nombre,
                1, 
                @workflow_id, 
                'PropuestaID: ' + CAST(@propuestaId AS VARCHAR)
            );
            
            -- Incrementar contador de workflows procesados
            SET @workflowCount = @workflowCount + 1;
            
            -- Pasar al siguiente workflow
            FETCH NEXT FROM workflow_cursor INTO @workflow_id, @workflow_nombre, @configWork;
        END
        
        /* -----------------------------------------------------
           CERRAR CURSOR (BUENA PR�CTICA)
           ----------------------------------------------------- */
        IF @cursorExists = 1
        BEGIN
            CLOSE workflow_cursor;
            DEALLOCATE workflow_cursor;
        END
        
        /* -----------------------------------------------------
           3. SIMULAR RESULTADO FINAL (80% APROBADO, 20% RECHAZADO)
           ----------------------------------------------------- */
        SET @resultadoRandom = CASE WHEN RAND() <= 0.8 THEN 1 ELSE 0 END;
        
        /* -----------------------------------------------------
           4. REGISTRAR EN LOG DEL SISTEMA
           ----------------------------------------------------- */
        INSERT INTO voto_Log (
            description,     -- Descripci�n del evento
            postTime,       -- Fecha/hora
            computer,       -- Equipo donde se ejecut�
            username,       -- Usuario que ejecut�
            trace,          -- Informaci�n de traza
            reference1,     -- Referencia 1 (ID propuesta)
            reference2,     -- Referencia 2 (ID usuario)
            value1,         -- Valor 1 (Tipo propuesta)
            value2,         -- Valor 2 (Resultado simulado)
            checksum        -- Hash para integridad
        ) VALUES (
            'Revisi�n iniciada | Workflows: ' + CAST(@workflowCount AS VARCHAR) + 
            CASE WHEN @resultadoRandom = 1 THEN ' | Simulaci�n: Aprobada' ELSE ' | Simulaci�n: Rechazada' END,
            @fechaActual, 
            HOST_NAME(), 
            @usernameRevisor,
            'Configuraci�n: ' + CAST(@tipoPropuestaId AS VARCHAR),
            @propuestaId, 
            @userIdRevisor, 
            @tipoPropuestaId, 
            @resultadoRandom,
            HASHBYTES('SHA2_256', CONVERT(VARCHAR(50), @propuestaId) + 
            CONVERT(VARCHAR(50), @userIdRevisor) + 
            CONVERT(VARCHAR(50), @fechaActual, 121))
        );
        
        -- Confirmar transacci�n si todo fue exitoso
        COMMIT TRANSACTION @transactionName;
        
        -- Mensaje de �xito gen�rico (proceso as�ncrono)
        SET @mensajeSalida = 'Proceso de revisi�n iniciado correctamente';
    END TRY
    BEGIN CATCH
        /* =====================================================
           MANEJO DE ERRORES
           ===================================================== */
        -- Obtener mensaje de error
        DECLARE @errorMsg VARCHAR(2000) = ERROR_MESSAGE();
        
        -- Cerrar cursor si est� abierto (limpieza de recursos)
        IF @cursorExists = 1 AND CURSOR_STATUS('global', 'workflow_cursor') >= 0
        BEGIN
            CLOSE workflow_cursor;
            DEALLOCATE workflow_cursor;
        END
        
        -- Revertir transacci�n si est� activa
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName;
            
        -- Mensaje de error espec�fico
        SET @mensajeSalida = 'Error: ' + @errorMsg;
        
        -- Registrar error en bit�cora
        INSERT INTO wk_bitacora (
            bitacoraId,
            wkLogTypeId,    -- 3 = Error
            fecha,
            resultado,
            estadoId,       -- 4 = Error
            workflow_Id,
            parametros
        ) VALUES (
            (SELECT ISNULL(MAX(bitacoraId), 0) + 1 FROM wk_bitacora),
            3, 
            GETDATE(), 
            'Error en revisi�n: ' + @errorMsg,
            4, 
            ISNULL(@workflow_id, 0), 
            'Propuesta: ' + @tituloPropuesta
        );
    END CATCH
END

drop procedure [revisarPropuesta]


-- 1. Ejecutar scripts de llenado (arriba)



-- 2. Ejecutar el stored procedure con datos de prueba
DECLARE @mensaje VARCHAR(500);
EXEC [dbo].[revisarPropuesta] 
    @tituloPropuesta = 'Arreglos para la piscina',
    @usernameRevisor = 'admin',
    @mensajeSalida = @mensaje OUTPUT;
    
PRINT @mensaje;

-- Verificar resultados
SELECT * FROM wk_workflow_run ORDER BY fecha_inicio DESC;
SELECT * FROM wk_bitacora ORDER BY fecha DESC;
SELECT * FROM voto_Log ORDER BY postTime DESC;
select * from voto_Propuestas
