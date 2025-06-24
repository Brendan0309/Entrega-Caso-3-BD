ALTER PROCEDURE [dbo].[repartirDividendos]
    -- Par�metros de entrada del procedimiento almacenado
    @tituloPropuesta VARCHAR(100),            -- T�tulo de la propuesta/proyecto a la que se distribuir�n los dividendos.
    @montoTotalDistribuir DECIMAL(15, 2),     -- Monto total de ganancias netas a distribuir entre los inversionistas para este ciclo.
    @fechaDistribucion DATE,                  -- Fecha efectiva en la que se planifica esta distribuci�n de dividendos.
    @usernameEjecutor VARCHAR(50),            -- Nombre de usuario de la persona (administrador, contable, etc.) que inicia la distribuci�n.
    @hashReporteGanancias VARBINARY(256),     -- Hash criptogr�fico del reporte financiero que justifica y avala la disponibilidad de estos fondos.
    
    -- Par�metros de salida para comunicar el resultado de la ejecuci�n del procedimiento
    @resultado BIT OUTPUT,                    -- Indicador booleano: 1 si la operaci�n de distribuci�n fue exitosa, 0 si hubo alg�n fallo.
    @mensaje VARCHAR(500) OUTPUT              -- Mensaje descriptivo que proporciona informaci�n detallada sobre el �xito o el error de la operaci�n.
AS
BEGIN
    SET NOCOUNT ON; -- Previene que SQL Server env�e mensajes de conteo de filas afectadas por las sentencias. Esto puede mejorar el rendimiento, especialmente en aplicaciones cliente-servidor.
    
    /* =====================================================
        DECLARACI�N DE VARIABLES
        Se declaran todas las variables locales que se utilizar�n para almacenar IDs, montos,
        fechas, estados y otros datos intermedios necesarios a lo largo del procedimiento.
    ===================================================== */
    DECLARE @propuestaId INT;               -- Almacena el ID interno de la propuesta (obtenido a partir de @tituloPropuesta).
    DECLARE @userIdEjecutor INT;            -- Almacena el ID del usuario que ejecuta este procedimiento (obtenido a partir de @usernameEjecutor).
    DECLARE @estadoPropuestaId INT;         -- Almacena el ID del estado actual de la propuesta.
    DECLARE @estadoEjecutandoId INT;        -- Almacena el ID del estado que corresponde a 'Ejecutando' para validaci�n.
    DECLARE @montoTotalInvertido DECIMAL(15, 2); -- Almacena la suma total de todos los montos de inversi�n aprobados en esta propuesta, de todos los inversionistas.
    DECLARE @transTypeIdDividendos INT;     -- Almacena el ID del tipo de transacci�n que corresponde a 'Dividendo'.
    DECLARE @fundIdPrincipal INT;           -- Almacena el ID del fondo principal al cual se asocian los balances de los inversionistas.
    DECLARE @pagoMedioIdWeb INT;            -- Almacena el ID del medio de pago 'Web' (obtenido de voto_MediosDisponibles), que representa el canal de pago.
    DECLARE @metodoPagoIdTransferenciaBancaria INT; -- Almacena el ID del m�todo de pago 'Transferencia Bancaria' (obtenido de voto_MetodosDePago), que representa la forma espec�fica de pago.
    DECLARE @dividendCycleId INT;           -- Almacena el ID del registro principal creado en voto_DividendDistributionCycle para este ciclo de distribuci�n.
    DECLARE @currencyId INT;                -- Almacena el ID de la moneda utilizada para los pagos de dividendos.
    DECLARE @exchangeRate FLOAT;            -- Almacena la tasa de cambio de la moneda para los pagos de dividendos.
    
    -- Variables espec�ficas para el cursor (utilizadas durante la iteraci�n sobre cada inversionista)
    DECLARE @inversionIdCursor INT;         -- Almacena el ID de una inversi�n individual mientras el cursor itera.
    DECLARE @userIdInversionistaCursor INT; -- Almacena el ID del usuario del inversionista para la inversi�n actual del cursor.
    DECLARE @montoInversionCursor DECIMAL(15, 2); -- Almacena el monto de la inversi�n individual actual del cursor.
    DECLARE @inversionistaIdCursor INT;     -- Almacena el ID del perfil de inversionista correspondiente a la inversi�n actual del cursor.
    DECLARE @montoDistribuirAInversionista DECIMAL(15, 2); -- Almacena el monto de dividendo calculado para ser distribuido al inversionista actual del cursor.
    DECLARE @saldoActualInversionista DECIMAL(15, 2); -- Almacena el saldo actual del inversionista antes de sumar los dividendos.
    DECLARE @inversionistaBalanceIdCursor INT; -- Almacena el ID del registro de balance del inversionista actual del cursor.
    DECLARE @pagoId INT;                    -- Almacena el ID del registro de pago generado para el dividendo del inversionista actual.
    DECLARE @transaccionId INT;             -- Almacena el ID de la transacci�n generada para el ingreso de dividendo al inversionista actual.

    /* =====================================================
        OBTENER IDs Y DATOS NECESARIOS (FUERA DE TRANSACCI�N)
        Esta secci�n se encarga de recopilar todos los datos de referencia y IDs de configuraci�n
        necesarios para la ejecuci�n del procedimiento. Se realizan estas consultas ANTES de
        iniciar el bloque de transacci�n principal para minimizar el tiempo que la transacci�n
        permanece abierta, lo que reduce la contenci�n de bloqueos y mejora la concurrencia y el rendimiento general.
    ===================================================== */
    -- Obtiene el ID de la propuesta y su estado actual buscando por el t�tulo de la propuesta.
    SELECT @propuestaId = propuestaId, @estadoPropuestaId = estadoId
    FROM [dbo].[voto_Propuestas]
    WHERE titulo = @tituloPropuesta;

    -- Obtiene el ID del usuario que est� ejecutando este procedimiento a partir de su nombre de usuario.
    SELECT @userIdEjecutor = userId
    FROM [dbo].[voto_Users]
    WHERE username = @usernameEjecutor;

    -- Obtiene el ID del estado 'Ejecutando' de la tabla de estados, el cual es necesario para validar la propuesta.
    SELECT @estadoEjecutandoId = estadoId
    FROM [dbo].[voto_Estado]
    WHERE name = 'Ejecutando';

    -- Obtiene el ID del tipo de transacci�n 'Dividendo' de la tabla de tipos de transacciones.
    -- Es crucial que este tipo de transacci�n exista y est� configurado correctamente.
    SELECT @transTypeIdDividendos = transTypeId
    FROM [dbo].[voto_transTypes]
    WHERE name = 'Dividendo';

    -- Obtiene el ID del fondo principal de la tabla de fondos. Este fondo es donde se gestionan los balances de los inversionistas.
    SELECT @fundIdPrincipal = fundId
    FROM [dbo].[voto_funds]
    WHERE name = 'Fondo Principal';

    -- Obtiene el ID del medio de pago 'Web' de la tabla voto_MediosDisponibles. Esto define el canal por el cual se procesa el pago.
    SELECT @pagoMedioIdWeb = pagoMedioId
    FROM [dbo].[voto_MediosDisponibles]
    WHERE name = 'Web' AND enabled = 1;

    -- Obtiene el ID del m�todo de pago 'Transferencia Bancaria' de la tabla voto_MetodosDePago. Esto define la forma espec�fica del pago.
    SELECT @metodoPagoIdTransferenciaBancaria = metodoPagoId
    FROM [dbo].[voto_MetodosDePago]
    WHERE name = 'Transferencia Bancaria' AND enabled = 1;

    -- Obtiene la informaci�n de la moneda base y su tasa de cambio.
    -- Se asume que existe una entrada donde 'currentExchangeRate' es 1 y 'enabled' es 1, lo que indica la moneda principal.
    SELECT TOP 1 
        @currencyId = c.currencyId,
        @exchangeRate = cc.exchangeRate
    FROM [dbo].[voto_Currencies] c
    JOIN [dbo].[voto_CurrencyConvertions] cc ON c.currencyId = cc.currencyId_destiny
    WHERE cc.currentExchangeRate = 1 AND cc.enabled = 1
    ORDER BY cc.startdate DESC; -- Prioriza la tasa de cambio m�s reciente.

    /* =====================================================
        VALIDACIONES INICIALES
        Esta secci�n realiza una serie de validaciones cr�ticas sobre los datos obtenidos
        y las condiciones de negocio requeridas para la distribuci�n de dividendos.
        Cualquier fallo en estas validaciones resultar� en la terminaci�n temprana del
        procedimiento almacenado, devolviendo un mensaje de error descriptivo.
    ===================================================== */
    -- Validaci�n 1: Verifica que la propuesta especificada por el t�tulo exista en la base de datos.
    IF @propuestaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: La propuesta especificada no fue encontrada.';
        RETURN;
    END

    -- Validaci�n 2: Verifica que el usuario que intenta ejecutar el procedimiento exista.
    IF @userIdEjecutor IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El usuario ejecutor no es v�lido o no existe.';
        RETURN;
    END

    -- Validaci�n 3: Verifica que el tipo de transacci�n 'Dividendo' est� correctamente configurado en la tabla voto_transTypes.
    IF @transTypeIdDividendos IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de transacci�n "Dividendo" no est� configurado en voto_transTypes.';
        RETURN;
    END

    -- Validaci�n 4: Verifica que el fondo principal est� configurado en la tabla voto_funds.
    IF @fundIdPrincipal IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El fondo "Fondo Principal" no est� configurado.';
        RETURN;
    END

    -- Validaci�n 5: Verifica que el medio de pago 'Web' est� configurado y habilitado en voto_MediosDisponibles.
    IF @pagoMedioIdWeb IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El medio de pago "Web" no est� configurado o habilitado en voto_MediosDisponibles.';
        RETURN;
    END

    -- Validaci�n 6: Verifica que el m�todo de pago 'Transferencia Bancaria' est� configurado y habilitado en voto_MetodosDePago.
    IF @metodoPagoIdTransferenciaBancaria IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El m�todo de pago "Transferencia Bancaria" no est� configurado o habilitado en voto_MetodosDePago.';
        RETURN;
    END

    -- Validaci�n 7: Verifica que la configuraci�n de moneda y su tasa de cambio est�n disponibles.
    IF @currencyId IS NULL OR @exchangeRate IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No se pudo obtener la configuraci�n de moneda y/o tipo de cambio para los pagos.';
        RETURN;
    END

    -- Validaci�n 8: Verifica que el monto total a distribuir sea un valor positivo.
    IF @montoTotalDistribuir <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto total a distribuir debe ser mayor que cero.';
        RETURN;
    END

    -- Validaci�n 9: Verifica que el proyecto est� en el estado 'Ejecutando'. Los dividendos solo deben distribuirse para proyectos en ejecuci�n.
    IF @estadoPropuestaId IS NULL OR @estadoPropuestaId <> @estadoEjecutandoId
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El proyecto no est� en estado "Ejecutando".';
        RETURN;
    END;
    
    -- Validaci�n 10: Verifica que todas las fiscalizaciones asociadas a la propuesta est�n aprobadas.
    -- Esto es crucial para asegurar que los reportes financieros han sido validados.
    IF EXISTS (
        SELECT 1 
        FROM [dbo].[voto_Fiscalizaciones] 
        WHERE propuestaId = @propuestaId 
        AND estado <> 'Aprobado' -- Se asume que el campo 'estado' de fiscalizaciones almacena el string 'Aprobado'.
    )
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Existen fiscalizaciones pendientes o no aprobadas para este proyecto.';
        RETURN;
    END;
    
    -- Validaci�n 11: Verifica la validez del hash del reporte de ganancias y asume la disponibilidad de fondos.
    -- En una implementaci�n real m�s compleja, aqu� se verificar�a el reporte contra un registro contable.
    IF @hashReporteGanancias IS NULL OR DATALENGTH(@hashReporteGanancias) = 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El hash del reporte de ganancias no es v�lido. Se requiere un reporte verificado que respalde la distribuci�n.';
        RETURN;
    END

    -- Consulta el monto total invertido por todos los inversionistas en esta propuesta.
    -- Este valor es fundamental para calcular el porcentaje de participaci�n de cada inversor.
    SELECT @montoTotalInvertido = ISNULL(SUM(monto), 0)
    FROM [dbo].[voto_Inversiones]
    WHERE propuestaId = @propuestaId AND estado = 'Aprobada'; -- Solo se consideran las inversiones que han sido aprobadas.

    -- Validaci�n 12: Verifica que existan inversiones aprobadas en el proyecto. No se pueden distribuir dividendos si no hay inversores o inversi�n.
    IF @montoTotalInvertido IS NULL OR @montoTotalInvertido <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No hay inversiones aprobadas para este proyecto o el monto total invertido es cero. No se pueden distribuir dividendos.';
        RETURN;
    END;

    -- Validaci�n 13: Verifica que todos los inversionistas que tienen inversiones aprobadas en esta propuesta
    -- cuenten con un medio de dep�sito v�lido y habilitado de tipo 'CuentaBancaria'.
    -- Esta validaci�n es crucial para asegurar que los dividendos puedan ser efectivamente pagados.
    IF EXISTS (
        SELECT 1
        FROM [dbo].[voto_Inversiones] inv_link -- inv_link es la tabla de inversiones, representa una inversi�n espec�fica.
        JOIN [dbo].[voto_Inversionistas] inv_prof ON inv_link.inversionId = inv_prof.inversionId -- inv_prof es la tabla de perfiles de inversionistas, enlazada indirectamente a trav�s de inversionId.
        LEFT JOIN [dbo].[voto_contactInfoInversionistas] ci ON inv_prof.inversionistaId = ci.inversionistaId -- Informaci�n de contacto del inversionista.
        LEFT JOIN [dbo].[voto_ContactInfoTypes] cit ON ci.contactInfoTypeId = cit.contactInfoTypeId -- Tipos de informaci�n de contacto.
        WHERE inv_link.propuestaId = @propuestaId -- Filtra por la propuesta actual.
        AND inv_link.estado = 'Aprobada' -- Solo considera inversiones que est�n en estado 'Aprobada'.
        AND (
              cit.name <> 'CuentaBancaria' -- Comprueba si el tipo de contacto NO es 'CuentaBancaria'.
              OR ci.value IS NULL          -- O si el valor de la cuenta bancaria est� vac�o.
              OR ci.enabled = 0             -- O si la cuenta bancaria no est� habilitada.
              OR cit.contactInfoTypeId IS NULL -- O si no hay ning�n tipo de informaci�n de contacto registrado para el inversor (lo que implica la ausencia de una 'CuentaBancaria').
            )
        -- AND inv_prof.acreditado = 1 -- Esta l�nea es opcional: si deseas considerar solo inversionistas acreditados.
    )
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Uno o m�s inversionistas con inversiones aprobadas no tienen un medio de dep�sito "CuentaBancaria" v�lido y habilitado. La distribuci�n no puede proceder.';
        RETURN;
    END;

    /* =====================================================
        INICIAR TRANSACCI�N (OPERACIONES CR�TICAS)
        Todas las operaciones de modificaci�n de datos se envuelven en una transacci�n
        expl�cita. Esto garantiza la atomicidad de las operaciones: o todas se completan
        con �xito, o ninguna de ellas se aplica a la base de datos (se revierten).
        Esto es vital para mantener la integridad de los datos financieros.
    ===================================================== */
    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia la transacci�n. Todas las operaciones siguientes hasta COMMIT/ROLLBACK formar�n una unidad at�mica.
        
        -- 1. Registrar el encabezado del ciclo de distribuci�n de dividendos.
        -- Se inserta un nuevo registro en la tabla 'voto_DividendDistributionCycle' para documentar
        -- este evento de distribuci�n general.
        INSERT INTO [dbo].[voto_DividendDistributionCycle] (
            propuestaId,
            montoTotalDistribuido,
            fechaDistribucion,
            userIdEjecutor,
            hashReporteGanancias,
            fechaRegistro,
            estado
        )
        VALUES (
            @propuestaId,               -- ID de la propuesta a la que se asocia esta distribuci�n.
            @montoTotalDistribuir,      -- El monto total que se distribuye en este ciclo.
            @fechaDistribucion,         -- La fecha de esta distribuci�n.
            @userIdEjecutor,            -- El ID del usuario que inicia este ciclo.
            @hashReporteGanancias,      -- El hash del reporte financiero que justifica la distribuci�n.
            GETDATE(),                  -- La fecha y hora exactas en que se registra este ciclo.
            'Completado'                -- El estado inicial del ciclo de distribuci�n (asumido como completado si no hay errores).
        );
        
        SET @dividendCycleId = SCOPE_IDENTITY(); -- Obtiene el ID generado autom�ticamente para el nuevo registro de ciclo de distribuci�n.
        
        -- 2. Procesar cada inversionista con una inversi�n aprobada en esta propuesta.
        -- Se declara un cursor para iterar de manera eficiente sobre cada inversi�n individual que est�
        -- en estado 'Aprobada' y est� asociada a la propuesta actual.
        DECLARE inversion_cursor CURSOR LOCAL FORWARD_ONLY FOR
        SELECT 
            i.inversionId,      -- El ID de la inversi�n individual.
            i.userId,           -- El ID del usuario que realiz� esta inversi�n.
            i.monto             -- El monto espec�fico de esta inversi�n.
        FROM [dbo].[voto_Inversiones] i
        WHERE i.propuestaId = @propuestaId  -- Filtra por la propuesta que est� distribuyendo dividendos.
        AND i.estado = 'Aprobada'; -- Solo procesa inversiones que han sido aprobadas.

        OPEN inversion_cursor; -- Abre el cursor para comenzar la iteraci�n.
        FETCH NEXT FROM inversion_cursor INTO @inversionIdCursor, @userIdInversionistaCursor, @montoInversionCursor; -- Obtiene la primera fila de datos.
        
        -- Bucle WHILE para procesar cada fila obtenida por el cursor.
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el inversionistaId para el userId actual del cursor.
            -- Se utiliza una uni�n indirecta a trav�s de la tabla 'voto_Inversiones' para encontrar el perfil del inversionista
            -- asociado a este usuario, utilizando la misma l�gica que en 'sp_InvertirEnPropuesta'.
            SELECT TOP 1 @inversionistaIdCursor = inv_prof.inversionistaId
            FROM [dbo].[voto_Inversionistas] inv_prof
            JOIN [dbo].[voto_Inversiones] inv_link ON inv_prof.inversionId = inv_link.inversionId
            WHERE inv_link.userId = @userIdInversionistaCursor
            ORDER BY inv_prof.fechaRegistro DESC; -- Si hay m�ltiples perfiles de inversionista para el mismo usuario, se selecciona el m�s reciente.


            -- Calcular el porcentaje de participaci�n de este inversionista en el proyecto.
            -- Se basa en el monto de su inversi�n individual en relaci�n con el monto total invertido por todos.
            DECLARE @porcentajeParticipacion DECIMAL(10, 6);
            IF @montoTotalInvertido > 0
                SET @porcentajeParticipacion = (@montoInversionCursor / @montoTotalInvertido);
            ELSE
                SET @porcentajeParticipacion = 0; -- Evita la divisi�n por cero si @montoTotalInvertido es 0.
            
            -- Calcular el monto exacto de dividendo a distribuir a este inversionista,
            -- multiplicando el monto total de ganancias por su porcentaje de participaci�n.
            SET @montoDistribuirAInversionista = @montoTotalDistribuir * @porcentajeParticipacion;
            
            -- Obtener el ID del registro de balance y el saldo actual del inversionista para el fondo principal.
            SELECT @inversionistaBalanceIdCursor = personBalanceId, @saldoActualInversionista = balance
            FROM [dbo].[voto_InversionistaBalance]
            WHERE inversionistaId = @inversionistaIdCursor AND fundId = @fundIdPrincipal;

            -- Si no se encuentra un registro de balance para el inversionista en el fondo principal, se crea uno nuevo.
            -- Esto es una medida de contingencia, aunque las validaciones previas deber�an asegurar que ya existe.
            IF @inversionistaBalanceIdCursor IS NULL
            BEGIN
                 INSERT INTO [dbo].[voto_InversionistaBalance] (
                    [inversionistaId],      -- El ID del perfil de inversionista.
                    [balance],              -- El nuevo balance, que inicialmente es solo el monto del dividendo.
                    [lastBalance],          -- El balance anterior, que es 0 ya que es un nuevo registro.
                    [fundId],               -- El ID del fondo principal.
                    [hashContenido]         -- El hash del reporte de ganancias como hash de contenido.
                 )
                 VALUES (
                    @inversionistaIdCursor, @montoDistribuirAInversionista, 0, 
                    @fundIdPrincipal, @hashReporteGanancias
                 );
                 SET @inversionistaBalanceIdCursor = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo registro de balance.
                 SET @saldoActualInversionista = 0; -- Reinicia el saldo actual para que el UPDATE posterior sume correctamente desde cero.
            END;

            -- Actualizar el saldo del inversionista en la tabla 'voto_InversionistaBalance'.
            -- Se suma el monto del dividendo al balance actual del inversionista.
            UPDATE [dbo].[voto_InversionistaBalance]
            SET 
                lastBalance = balance, -- Guarda el balance que exist�a antes de esta actualizaci�n.
                balance = @saldoActualInversionista + @montoDistribuirAInversionista -- Actualiza el balance sumando el dividendo.
            WHERE personBalanceId = @inversionistaBalanceIdCursor; -- Actualiza el registro espec�fico del inversionista.

            -- Registrar el pago del dividendo en la tabla 'voto_Pagos'.
            -- Esto crea un registro individual para cada transferencia de dividendo.
            INSERT INTO [dbo].[voto_Pagos] (
                pagoMedioId,                -- El ID del medio de pago (ej. 'Web').
                metodoPagoId,               -- El ID del m�todo de pago (ej. 'Transferencia Bancaria').
                propuestaId,                -- El ID de la propuesta a la que se asocia este pago.
                inversionId,                -- El ID de la inversi�n individual a la que se asocia este dividendo.
                inversionistaId,            -- El ID del perfil de inversionista.
                monto,                      -- El monto del dividendo que se est� pagando.
                actualMonto,                -- El monto real pagado (puede ser igual a 'monto' aqu�).
                result,                     -- El resultado del pago (0x01 para �xito).
                auth,                       -- El estado de autorizaci�n (0x01 para �xito).
                error,                      -- Mensaje de error (vac�o si no hay error).
                fecha,                      -- La fecha y hora del pago.
                checksum,                   -- Un checksum para verificar la integridad del registro de pago.
                exchangeRate,               -- La tasa de cambio utilizada para este pago.
                convertedAmount,            -- El monto convertido si aplica (monto * exchangeRate).
                moduleId,                   -- El ID del m�dulo que genera el pago (ej. 1 para el sistema principal).
                currencyId,                 -- El ID de la moneda del pago.
                hashContenido               -- Un hash del contenido del pago (se reutiliza el hash del reporte de ganancias).
            )
            VALUES (
                @pagoMedioIdWeb,                  -- Utiliza el ID del medio de pago 'Web'.
                @metodoPagoIdTransferenciaBancaria, -- Utiliza el ID del m�todo de pago 'Transferencia Bancaria'.
                @propuestaId,
                @inversionIdCursor,
                @inversionistaIdCursor,
                @montoDistribuirAInversionista,
                @montoDistribuirAInversionista,
                0x01,
                0x01,
                '',
                GETDATE(),
                0x01, -- Checksum simulado
                @exchangeRate, 
                @montoDistribuirAInversionista * @exchangeRate,
                1, -- ModuloId simulado
                @currencyId, 
                @hashReporteGanancias
            );
            SET @pagoId = SCOPE_IDENTITY(); -- Obtiene el ID generado para el nuevo registro de pago.

            -- Registrar la confirmaci�n o detalle del pago de dividendo en la tabla 'voto_Distribution'.
            -- Esta tabla parece servir como un registro adicional o una confirmaci�n de cada pago individual de dividendo.
            INSERT INTO [dbo].[voto_Distribution] (
                enabled,        -- Indica si el registro de distribuci�n est� habilitado (1 = s�).
                checksum,       -- Un hash para verificar la integridad de este registro de distribuci�n.
                pagoId,         -- El ID del pago reci�n creado en 'voto_Pagos' al que se enlaza este registro.
                hashSeguridad   -- Un hash de seguridad relacionado con la transacci�n.
            )
            VALUES (
                1, -- enabled = true
                -- Genera un checksum �nico para este registro de 'voto_Distribution'.
                HASHBYTES('SHA2_256', CAST(@pagoId AS VARCHAR(10)) + CAST(@montoDistribuirAInversionista AS VARCHAR(50)) + CONVERT(VARCHAR(256), @hashReporteGanancias)),
                CAST(@pagoId AS NCHAR(10)), -- Convierte el INT @pagoId a NCHAR(10) para que coincida con el tipo de columna.
                @hashReporteGanancias -- Reutiliza el hash del reporte de ganancias como hash de seguridad.
            );

            -- Generar una transacci�n de ingreso de dividendos para el inversionista en la tabla 'voto_Transacciones'.
            -- Obtiene el siguiente ID disponible para 'transaccionId'. Se asume que no es una columna IDENTITY.
            SELECT @transaccionId = ISNULL(MAX(transaccionId), 0) + 1 FROM [dbo].[voto_Transacciones];

            INSERT INTO [dbo].[voto_Transacciones] (
                transaccionId,          -- El ID de la transacci�n (generado manualmente aqu�).
                description,            -- Una descripci�n detallada de la transacci�n.
                tranDateTime,           -- La fecha y hora de la transacci�n.
                postTime,               -- La fecha y hora de contabilizaci�n.
                pagoId,                 -- El ID del pago asociado a esta transacci�n.
                refNumber,              -- Un n�mero de referencia �nico (generado con NEWID() para unicidad).
                inversionistaId,        -- El ID del perfil de inversionista.
                transTypeId,            -- El ID del tipo de transacci�n 'Dividendo'.
                inversionistaBalanceId, -- El ID del registro de balance del inversionista.
                hashTrans,              -- El hash de la transacci�n (se reutiliza el hash del reporte de ganancias).
                llavePrivada            -- Una llave privada simulada para la transacci�n.
            )
            VALUES (
                @transaccionId,
                'Pago de Dividendos para Inversi�n #' + CAST(@inversionIdCursor AS VARCHAR) + ' de la propuesta "' + @tituloPropuesta + '"',
                GETDATE(),
                GETDATE(),
                @pagoId,
                CAST(NEWID() AS VARCHAR(100)), -- Genera un GUID y lo convierte a VARCHAR para el n�mero de referencia.
                @inversionistaIdCursor,
                @transTypeIdDividendos, 
                @inversionistaBalanceIdCursor,
                @hashReporteGanancias, 
                HASHBYTES('SHA2_256', 'LlaveDiv_' + CAST(@pagoId AS VARCHAR) + CAST(@montoDistribuirAInversionista AS VARCHAR)) -- Genera una llave privada simulada.
            );

            -- Registrar el detalle de la distribuci�n para esta inversi�n en la tabla 'voto_DistribucionDetalle'.
            -- Esta tabla guarda los pormenores de cada dividendo individual dentro del ciclo de distribuci�n mayor.
            INSERT INTO [dbo].[voto_DistribucionDetalle] (
                cycleId,                    -- El ID del ciclo de distribuci�n general al que pertenece este detalle.
                inversionId,                -- El ID de la inversi�n individual.
                inversionistaId,            -- El ID del perfil de inversionista.
                montoInversion,             -- El monto original de la inversi�n del inversionista.
                porcentajeParticipacion,    -- El porcentaje de participaci�n calculado.
                montoDistribuido,           -- El monto de dividendo distribuido a este inversionista.
                pagoId,                     -- El ID del pago asociado a este detalle.
                fechaRegistro               -- La fecha y hora de registro de este detalle.
            )
            VALUES (
                @dividendCycleId,
                @inversionIdCursor,
                @inversionistaIdCursor,
                @montoInversionCursor,
                @porcentajeParticipacion,
                @montoDistribuirAInversionista,
                @pagoId,
                GETDATE()
            );
            
            FETCH NEXT FROM inversion_cursor INTO @inversionIdCursor, @userIdInversionistaCursor, @montoInversionCursor; -- Avanza el cursor a la siguiente fila.
        END;
        
        CLOSE inversion_cursor; -- Cierra el cursor una vez que se han procesado todas las filas.
        DEALLOCATE inversion_cursor; -- Libera los recursos asociados al cursor.
        
        -- Confirmar la transacci�n si todas las operaciones dentro del bloque TRY fueron exitosas.
        -- Esto hace que todos los cambios sean permanentes en la base de datos.
        COMMIT TRANSACTION;
        
        -- Retornar el resultado exitoso y un mensaje descriptivo de la operaci�n completada.
        SET @resultado = 1;
        SET @mensaje = 'Distribuci�n de dividendos completada exitosamente para el proyecto "' + @tituloPropuesta + '".';
        
    END TRY
    BEGIN CATCH
        -- Manejo de errores: Este bloque se ejecuta si ocurre cualquier error dentro del bloque TRY.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; -- Si hay una transacci�n abierta, se revierte para deshacer todos los cambios y mantener la integridad de los datos.
            
        SET @resultado = 0; -- Establece el resultado del procedimiento a fallo.
        SET @mensaje = 'Error al distribuir dividendos: ' + ERROR_MESSAGE(); -- Captura el mensaje de error original de SQL Server y lo asigna al par�metro de salida.
        
        -- Registrar el error en la tabla de logs ('voto_Log') para fines de depuraci�n y auditor�a.
        INSERT INTO [dbo].[voto_Log] (
            [description], [postTime], [computer], [username],
            [trace], [reference1], [reference2], [checksum]
        )
        VALUES (
            'Error en repartirDividendos: ' + ERROR_MESSAGE(), -- Descripci�n detallada del error.
            GETDATE(), HOST_NAME(), @usernameEjecutor, -- Fecha/hora del error, nombre del equipo, nombre de usuario ejecutor.
            'Propuesta: ' + @tituloPropuesta + ', Monto a Distribuir: ' + CAST(@montoTotalDistribuir AS VARCHAR), -- Traza del contexto del error.
            @propuestaId, @userIdEjecutor, -- Referencias a la propuesta y el usuario.
            -- Genera un hash SHA2_256 para el registro de log, asegurando su unicidad y la integridad de la entrada del log.
            HASHBYTES('SHA2_256', CAST(@propuestaId AS VARCHAR) + @usernameEjecutor + ERROR_MESSAGE())
        );
    END CATCH;
END;




drop procedure [repartirDividendos]



-- Declaraci�n de variables para los par�metros de entrada del SP
DECLARE @tituloPropuesta NVARCHAR(100) = 'Proyecto de reciclaje comunitario'; -- �Importante: Reemplaza con el t�tulo exacto de una propuesta en estado 'Ejecutando' que tenga inversiones!
DECLARE @montoTotalDistribuir DECIMAL(15, 2) = 100000.00; -- Monto total de dividendos a repartir (ej. 100,000.00)
DECLARE @fechaDistribucion DATE = GETDATE(); -- Fecha actual de distribuci�n
DECLARE @usernameEjecutor NVARCHAR(50) = 'juan.perez@email.com'; -- �Importante: Reemplaza con un username v�lido y existente en tu tabla voto_Users!
DECLARE @hashReporteGanancias VARBINARY(256); -- Hash del reporte de ganancias, generado para la prueba

-- Generar un hash de ejemplo para el reporte de ganancias
-- Este hash simular� el contenido de un reporte financiero verificado.
SET @hashReporteGanancias = HASHBYTES('SHA2_256', 'ReporteFinanciero_2025_Q2_ProyectoABC_' + CONVERT(NVARCHAR(50), NEWID()));

-- Declaraci�n de variables para los par�metros de salida del SP
DECLARE @resultado BIT;
DECLARE @mensaje NVARCHAR(500);

-- Ejecuci�n del procedimiento almacenado
EXEC [dbo].[repartirDividendos]
    @tituloPropuesta = @tituloPropuesta,
    @montoTotalDistribuir = @montoTotalDistribuir,
    @fechaDistribucion = @fechaDistribucion,
    @usernameEjecutor = @usernameEjecutor,
    @hashReporteGanancias = @hashReporteGanancias,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

-- Mostrar los resultados de la ejecuci�n
SELECT 
    @resultado AS 'Resultado de Ejecuci�n (1=�xito, 0=Fallo)',
    @mensaje AS 'Mensaje del SP';



Select * from voto_DividendDistributionCycle
Select * from voto_InversionistaBalance
Select * from voto_Pagos
Select * from voto_Distribution
Select * from voto_Transacciones
Select * from voto_DistribucionDetalle
Select * from voto_Log