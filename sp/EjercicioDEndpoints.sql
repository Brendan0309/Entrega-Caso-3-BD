ALTER PROCEDURE [dbo].[repartirDividendos]
    -- Parámetros de entrada del procedimiento almacenado
    @tituloPropuesta VARCHAR(100),            -- Título de la propuesta/proyecto a la que se distribuirán los dividendos.
    @montoTotalDistribuir DECIMAL(15, 2),     -- Monto total de ganancias netas a distribuir entre los inversionistas para este ciclo.
    @fechaDistribucion DATE,                  -- Fecha efectiva en la que se planifica esta distribución de dividendos.
    @usernameEjecutor VARCHAR(50),            -- Nombre de usuario de la persona (administrador, contable, etc.) que inicia la distribución.
    @hashReporteGanancias VARBINARY(256),     -- Hash criptográfico del reporte financiero que justifica y avala la disponibilidad de estos fondos.
    
    -- Parámetros de salida para comunicar el resultado de la ejecución del procedimiento
    @resultado BIT OUTPUT,                    -- Indicador booleano: 1 si la operación de distribución fue exitosa, 0 si hubo algún fallo.
    @mensaje VARCHAR(500) OUTPUT              -- Mensaje descriptivo que proporciona información detallada sobre el éxito o el error de la operación.
AS
BEGIN
    SET NOCOUNT ON; -- Previene que SQL Server envíe mensajes de conteo de filas afectadas por las sentencias. Esto puede mejorar el rendimiento, especialmente en aplicaciones cliente-servidor.
    
    /* =====================================================
        DECLARACIÓN DE VARIABLES
        Se declaran todas las variables locales que se utilizarán para almacenar IDs, montos,
        fechas, estados y otros datos intermedios necesarios a lo largo del procedimiento.
    ===================================================== */
    DECLARE @propuestaId INT;               -- Almacena el ID interno de la propuesta (obtenido a partir de @tituloPropuesta).
    DECLARE @userIdEjecutor INT;            -- Almacena el ID del usuario que ejecuta este procedimiento (obtenido a partir de @usernameEjecutor).
    DECLARE @estadoPropuestaId INT;         -- Almacena el ID del estado actual de la propuesta.
    DECLARE @estadoEjecutandoId INT;        -- Almacena el ID del estado que corresponde a 'Ejecutando' para validación.
    DECLARE @montoTotalInvertido DECIMAL(15, 2); -- Almacena la suma total de todos los montos de inversión aprobados en esta propuesta, de todos los inversionistas.
    DECLARE @transTypeIdDividendos INT;     -- Almacena el ID del tipo de transacción que corresponde a 'Dividendo'.
    DECLARE @fundIdPrincipal INT;           -- Almacena el ID del fondo principal al cual se asocian los balances de los inversionistas.
    DECLARE @pagoMedioIdWeb INT;            -- Almacena el ID del medio de pago 'Web' (obtenido de voto_MediosDisponibles), que representa el canal de pago.
    DECLARE @metodoPagoIdTransferenciaBancaria INT; -- Almacena el ID del método de pago 'Transferencia Bancaria' (obtenido de voto_MetodosDePago), que representa la forma específica de pago.
    DECLARE @dividendCycleId INT;           -- Almacena el ID del registro principal creado en voto_DividendDistributionCycle para este ciclo de distribución.
    DECLARE @currencyId INT;                -- Almacena el ID de la moneda utilizada para los pagos de dividendos.
    DECLARE @exchangeRate FLOAT;            -- Almacena la tasa de cambio de la moneda para los pagos de dividendos.
    
    -- Variables específicas para el cursor (utilizadas durante la iteración sobre cada inversionista)
    DECLARE @inversionIdCursor INT;         -- Almacena el ID de una inversión individual mientras el cursor itera.
    DECLARE @userIdInversionistaCursor INT; -- Almacena el ID del usuario del inversionista para la inversión actual del cursor.
    DECLARE @montoInversionCursor DECIMAL(15, 2); -- Almacena el monto de la inversión individual actual del cursor.
    DECLARE @inversionistaIdCursor INT;     -- Almacena el ID del perfil de inversionista correspondiente a la inversión actual del cursor.
    DECLARE @montoDistribuirAInversionista DECIMAL(15, 2); -- Almacena el monto de dividendo calculado para ser distribuido al inversionista actual del cursor.
    DECLARE @saldoActualInversionista DECIMAL(15, 2); -- Almacena el saldo actual del inversionista antes de sumar los dividendos.
    DECLARE @inversionistaBalanceIdCursor INT; -- Almacena el ID del registro de balance del inversionista actual del cursor.
    DECLARE @pagoId INT;                    -- Almacena el ID del registro de pago generado para el dividendo del inversionista actual.
    DECLARE @transaccionId INT;             -- Almacena el ID de la transacción generada para el ingreso de dividendo al inversionista actual.

    /* =====================================================
        OBTENER IDs Y DATOS NECESARIOS (FUERA DE TRANSACCIÓN)
        Esta sección se encarga de recopilar todos los datos de referencia y IDs de configuración
        necesarios para la ejecución del procedimiento. Se realizan estas consultas ANTES de
        iniciar el bloque de transacción principal para minimizar el tiempo que la transacción
        permanece abierta, lo que reduce la contención de bloqueos y mejora la concurrencia y el rendimiento general.
    ===================================================== */
    -- Obtiene el ID de la propuesta y su estado actual buscando por el título de la propuesta.
    SELECT @propuestaId = propuestaId, @estadoPropuestaId = estadoId
    FROM [dbo].[voto_Propuestas]
    WHERE titulo = @tituloPropuesta;

    -- Obtiene el ID del usuario que está ejecutando este procedimiento a partir de su nombre de usuario.
    SELECT @userIdEjecutor = userId
    FROM [dbo].[voto_Users]
    WHERE username = @usernameEjecutor;

    -- Obtiene el ID del estado 'Ejecutando' de la tabla de estados, el cual es necesario para validar la propuesta.
    SELECT @estadoEjecutandoId = estadoId
    FROM [dbo].[voto_Estado]
    WHERE name = 'Ejecutando';

    -- Obtiene el ID del tipo de transacción 'Dividendo' de la tabla de tipos de transacciones.
    -- Es crucial que este tipo de transacción exista y esté configurado correctamente.
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

    -- Obtiene el ID del método de pago 'Transferencia Bancaria' de la tabla voto_MetodosDePago. Esto define la forma específica del pago.
    SELECT @metodoPagoIdTransferenciaBancaria = metodoPagoId
    FROM [dbo].[voto_MetodosDePago]
    WHERE name = 'Transferencia Bancaria' AND enabled = 1;

    -- Obtiene la información de la moneda base y su tasa de cambio.
    -- Se asume que existe una entrada donde 'currentExchangeRate' es 1 y 'enabled' es 1, lo que indica la moneda principal.
    SELECT TOP 1 
        @currencyId = c.currencyId,
        @exchangeRate = cc.exchangeRate
    FROM [dbo].[voto_Currencies] c
    JOIN [dbo].[voto_CurrencyConvertions] cc ON c.currencyId = cc.currencyId_destiny
    WHERE cc.currentExchangeRate = 1 AND cc.enabled = 1
    ORDER BY cc.startdate DESC; -- Prioriza la tasa de cambio más reciente.

    /* =====================================================
        VALIDACIONES INICIALES
        Esta sección realiza una serie de validaciones críticas sobre los datos obtenidos
        y las condiciones de negocio requeridas para la distribución de dividendos.
        Cualquier fallo en estas validaciones resultará en la terminación temprana del
        procedimiento almacenado, devolviendo un mensaje de error descriptivo.
    ===================================================== */
    -- Validación 1: Verifica que la propuesta especificada por el título exista en la base de datos.
    IF @propuestaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: La propuesta especificada no fue encontrada.';
        RETURN;
    END

    -- Validación 2: Verifica que el usuario que intenta ejecutar el procedimiento exista.
    IF @userIdEjecutor IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El usuario ejecutor no es válido o no existe.';
        RETURN;
    END

    -- Validación 3: Verifica que el tipo de transacción 'Dividendo' esté correctamente configurado en la tabla voto_transTypes.
    IF @transTypeIdDividendos IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de transacción "Dividendo" no está configurado en voto_transTypes.';
        RETURN;
    END

    -- Validación 4: Verifica que el fondo principal esté configurado en la tabla voto_funds.
    IF @fundIdPrincipal IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El fondo "Fondo Principal" no está configurado.';
        RETURN;
    END

    -- Validación 5: Verifica que el medio de pago 'Web' esté configurado y habilitado en voto_MediosDisponibles.
    IF @pagoMedioIdWeb IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El medio de pago "Web" no está configurado o habilitado en voto_MediosDisponibles.';
        RETURN;
    END

    -- Validación 6: Verifica que el método de pago 'Transferencia Bancaria' esté configurado y habilitado en voto_MetodosDePago.
    IF @metodoPagoIdTransferenciaBancaria IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El método de pago "Transferencia Bancaria" no está configurado o habilitado en voto_MetodosDePago.';
        RETURN;
    END

    -- Validación 7: Verifica que la configuración de moneda y su tasa de cambio estén disponibles.
    IF @currencyId IS NULL OR @exchangeRate IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No se pudo obtener la configuración de moneda y/o tipo de cambio para los pagos.';
        RETURN;
    END

    -- Validación 8: Verifica que el monto total a distribuir sea un valor positivo.
    IF @montoTotalDistribuir <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto total a distribuir debe ser mayor que cero.';
        RETURN;
    END

    -- Validación 9: Verifica que el proyecto esté en el estado 'Ejecutando'. Los dividendos solo deben distribuirse para proyectos en ejecución.
    IF @estadoPropuestaId IS NULL OR @estadoPropuestaId <> @estadoEjecutandoId
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El proyecto no está en estado "Ejecutando".';
        RETURN;
    END;
    
    -- Validación 10: Verifica que todas las fiscalizaciones asociadas a la propuesta estén aprobadas.
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
    
    -- Validación 11: Verifica la validez del hash del reporte de ganancias y asume la disponibilidad de fondos.
    -- En una implementación real más compleja, aquí se verificaría el reporte contra un registro contable.
    IF @hashReporteGanancias IS NULL OR DATALENGTH(@hashReporteGanancias) = 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El hash del reporte de ganancias no es válido. Se requiere un reporte verificado que respalde la distribución.';
        RETURN;
    END

    -- Consulta el monto total invertido por todos los inversionistas en esta propuesta.
    -- Este valor es fundamental para calcular el porcentaje de participación de cada inversor.
    SELECT @montoTotalInvertido = ISNULL(SUM(monto), 0)
    FROM [dbo].[voto_Inversiones]
    WHERE propuestaId = @propuestaId AND estado = 'Aprobada'; -- Solo se consideran las inversiones que han sido aprobadas.

    -- Validación 12: Verifica que existan inversiones aprobadas en el proyecto. No se pueden distribuir dividendos si no hay inversores o inversión.
    IF @montoTotalInvertido IS NULL OR @montoTotalInvertido <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No hay inversiones aprobadas para este proyecto o el monto total invertido es cero. No se pueden distribuir dividendos.';
        RETURN;
    END;

    -- Validación 13: Verifica que todos los inversionistas que tienen inversiones aprobadas en esta propuesta
    -- cuenten con un medio de depósito válido y habilitado de tipo 'CuentaBancaria'.
    -- Esta validación es crucial para asegurar que los dividendos puedan ser efectivamente pagados.
    IF EXISTS (
        SELECT 1
        FROM [dbo].[voto_Inversiones] inv_link -- inv_link es la tabla de inversiones, representa una inversión específica.
        JOIN [dbo].[voto_Inversionistas] inv_prof ON inv_link.inversionId = inv_prof.inversionId -- inv_prof es la tabla de perfiles de inversionistas, enlazada indirectamente a través de inversionId.
        LEFT JOIN [dbo].[voto_contactInfoInversionistas] ci ON inv_prof.inversionistaId = ci.inversionistaId -- Información de contacto del inversionista.
        LEFT JOIN [dbo].[voto_ContactInfoTypes] cit ON ci.contactInfoTypeId = cit.contactInfoTypeId -- Tipos de información de contacto.
        WHERE inv_link.propuestaId = @propuestaId -- Filtra por la propuesta actual.
        AND inv_link.estado = 'Aprobada' -- Solo considera inversiones que están en estado 'Aprobada'.
        AND (
              cit.name <> 'CuentaBancaria' -- Comprueba si el tipo de contacto NO es 'CuentaBancaria'.
              OR ci.value IS NULL          -- O si el valor de la cuenta bancaria está vacío.
              OR ci.enabled = 0             -- O si la cuenta bancaria no está habilitada.
              OR cit.contactInfoTypeId IS NULL -- O si no hay ningún tipo de información de contacto registrado para el inversor (lo que implica la ausencia de una 'CuentaBancaria').
            )
        -- AND inv_prof.acreditado = 1 -- Esta línea es opcional: si deseas considerar solo inversionistas acreditados.
    )
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Uno o más inversionistas con inversiones aprobadas no tienen un medio de depósito "CuentaBancaria" válido y habilitado. La distribución no puede proceder.';
        RETURN;
    END;

    /* =====================================================
        INICIAR TRANSACCIÓN (OPERACIONES CRÍTICAS)
        Todas las operaciones de modificación de datos se envuelven en una transacción
        explícita. Esto garantiza la atomicidad de las operaciones: o todas se completan
        con éxito, o ninguna de ellas se aplica a la base de datos (se revierten).
        Esto es vital para mantener la integridad de los datos financieros.
    ===================================================== */
    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia la transacción. Todas las operaciones siguientes hasta COMMIT/ROLLBACK formarán una unidad atómica.
        
        -- 1. Registrar el encabezado del ciclo de distribución de dividendos.
        -- Se inserta un nuevo registro en la tabla 'voto_DividendDistributionCycle' para documentar
        -- este evento de distribución general.
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
            @propuestaId,               -- ID de la propuesta a la que se asocia esta distribución.
            @montoTotalDistribuir,      -- El monto total que se distribuye en este ciclo.
            @fechaDistribucion,         -- La fecha de esta distribución.
            @userIdEjecutor,            -- El ID del usuario que inicia este ciclo.
            @hashReporteGanancias,      -- El hash del reporte financiero que justifica la distribución.
            GETDATE(),                  -- La fecha y hora exactas en que se registra este ciclo.
            'Completado'                -- El estado inicial del ciclo de distribución (asumido como completado si no hay errores).
        );
        
        SET @dividendCycleId = SCOPE_IDENTITY(); -- Obtiene el ID generado automáticamente para el nuevo registro de ciclo de distribución.
        
        -- 2. Procesar cada inversionista con una inversión aprobada en esta propuesta.
        -- Se declara un cursor para iterar de manera eficiente sobre cada inversión individual que está
        -- en estado 'Aprobada' y está asociada a la propuesta actual.
        DECLARE inversion_cursor CURSOR LOCAL FORWARD_ONLY FOR
        SELECT 
            i.inversionId,      -- El ID de la inversión individual.
            i.userId,           -- El ID del usuario que realizó esta inversión.
            i.monto             -- El monto específico de esta inversión.
        FROM [dbo].[voto_Inversiones] i
        WHERE i.propuestaId = @propuestaId  -- Filtra por la propuesta que está distribuyendo dividendos.
        AND i.estado = 'Aprobada'; -- Solo procesa inversiones que han sido aprobadas.

        OPEN inversion_cursor; -- Abre el cursor para comenzar la iteración.
        FETCH NEXT FROM inversion_cursor INTO @inversionIdCursor, @userIdInversionistaCursor, @montoInversionCursor; -- Obtiene la primera fila de datos.
        
        -- Bucle WHILE para procesar cada fila obtenida por el cursor.
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el inversionistaId para el userId actual del cursor.
            -- Se utiliza una unión indirecta a través de la tabla 'voto_Inversiones' para encontrar el perfil del inversionista
            -- asociado a este usuario, utilizando la misma lógica que en 'sp_InvertirEnPropuesta'.
            SELECT TOP 1 @inversionistaIdCursor = inv_prof.inversionistaId
            FROM [dbo].[voto_Inversionistas] inv_prof
            JOIN [dbo].[voto_Inversiones] inv_link ON inv_prof.inversionId = inv_link.inversionId
            WHERE inv_link.userId = @userIdInversionistaCursor
            ORDER BY inv_prof.fechaRegistro DESC; -- Si hay múltiples perfiles de inversionista para el mismo usuario, se selecciona el más reciente.


            -- Calcular el porcentaje de participación de este inversionista en el proyecto.
            -- Se basa en el monto de su inversión individual en relación con el monto total invertido por todos.
            DECLARE @porcentajeParticipacion DECIMAL(10, 6);
            IF @montoTotalInvertido > 0
                SET @porcentajeParticipacion = (@montoInversionCursor / @montoTotalInvertido);
            ELSE
                SET @porcentajeParticipacion = 0; -- Evita la división por cero si @montoTotalInvertido es 0.
            
            -- Calcular el monto exacto de dividendo a distribuir a este inversionista,
            -- multiplicando el monto total de ganancias por su porcentaje de participación.
            SET @montoDistribuirAInversionista = @montoTotalDistribuir * @porcentajeParticipacion;
            
            -- Obtener el ID del registro de balance y el saldo actual del inversionista para el fondo principal.
            SELECT @inversionistaBalanceIdCursor = personBalanceId, @saldoActualInversionista = balance
            FROM [dbo].[voto_InversionistaBalance]
            WHERE inversionistaId = @inversionistaIdCursor AND fundId = @fundIdPrincipal;

            -- Si no se encuentra un registro de balance para el inversionista en el fondo principal, se crea uno nuevo.
            -- Esto es una medida de contingencia, aunque las validaciones previas deberían asegurar que ya existe.
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
                lastBalance = balance, -- Guarda el balance que existía antes de esta actualización.
                balance = @saldoActualInversionista + @montoDistribuirAInversionista -- Actualiza el balance sumando el dividendo.
            WHERE personBalanceId = @inversionistaBalanceIdCursor; -- Actualiza el registro específico del inversionista.

            -- Registrar el pago del dividendo en la tabla 'voto_Pagos'.
            -- Esto crea un registro individual para cada transferencia de dividendo.
            INSERT INTO [dbo].[voto_Pagos] (
                pagoMedioId,                -- El ID del medio de pago (ej. 'Web').
                metodoPagoId,               -- El ID del método de pago (ej. 'Transferencia Bancaria').
                propuestaId,                -- El ID de la propuesta a la que se asocia este pago.
                inversionId,                -- El ID de la inversión individual a la que se asocia este dividendo.
                inversionistaId,            -- El ID del perfil de inversionista.
                monto,                      -- El monto del dividendo que se está pagando.
                actualMonto,                -- El monto real pagado (puede ser igual a 'monto' aquí).
                result,                     -- El resultado del pago (0x01 para éxito).
                auth,                       -- El estado de autorización (0x01 para éxito).
                error,                      -- Mensaje de error (vacío si no hay error).
                fecha,                      -- La fecha y hora del pago.
                checksum,                   -- Un checksum para verificar la integridad del registro de pago.
                exchangeRate,               -- La tasa de cambio utilizada para este pago.
                convertedAmount,            -- El monto convertido si aplica (monto * exchangeRate).
                moduleId,                   -- El ID del módulo que genera el pago (ej. 1 para el sistema principal).
                currencyId,                 -- El ID de la moneda del pago.
                hashContenido               -- Un hash del contenido del pago (se reutiliza el hash del reporte de ganancias).
            )
            VALUES (
                @pagoMedioIdWeb,                  -- Utiliza el ID del medio de pago 'Web'.
                @metodoPagoIdTransferenciaBancaria, -- Utiliza el ID del método de pago 'Transferencia Bancaria'.
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

            -- Registrar la confirmación o detalle del pago de dividendo en la tabla 'voto_Distribution'.
            -- Esta tabla parece servir como un registro adicional o una confirmación de cada pago individual de dividendo.
            INSERT INTO [dbo].[voto_Distribution] (
                enabled,        -- Indica si el registro de distribución está habilitado (1 = sí).
                checksum,       -- Un hash para verificar la integridad de este registro de distribución.
                pagoId,         -- El ID del pago recién creado en 'voto_Pagos' al que se enlaza este registro.
                hashSeguridad   -- Un hash de seguridad relacionado con la transacción.
            )
            VALUES (
                1, -- enabled = true
                -- Genera un checksum único para este registro de 'voto_Distribution'.
                HASHBYTES('SHA2_256', CAST(@pagoId AS VARCHAR(10)) + CAST(@montoDistribuirAInversionista AS VARCHAR(50)) + CONVERT(VARCHAR(256), @hashReporteGanancias)),
                CAST(@pagoId AS NCHAR(10)), -- Convierte el INT @pagoId a NCHAR(10) para que coincida con el tipo de columna.
                @hashReporteGanancias -- Reutiliza el hash del reporte de ganancias como hash de seguridad.
            );

            -- Generar una transacción de ingreso de dividendos para el inversionista en la tabla 'voto_Transacciones'.
            -- Obtiene el siguiente ID disponible para 'transaccionId'. Se asume que no es una columna IDENTITY.
            SELECT @transaccionId = ISNULL(MAX(transaccionId), 0) + 1 FROM [dbo].[voto_Transacciones];

            INSERT INTO [dbo].[voto_Transacciones] (
                transaccionId,          -- El ID de la transacción (generado manualmente aquí).
                description,            -- Una descripción detallada de la transacción.
                tranDateTime,           -- La fecha y hora de la transacción.
                postTime,               -- La fecha y hora de contabilización.
                pagoId,                 -- El ID del pago asociado a esta transacción.
                refNumber,              -- Un número de referencia único (generado con NEWID() para unicidad).
                inversionistaId,        -- El ID del perfil de inversionista.
                transTypeId,            -- El ID del tipo de transacción 'Dividendo'.
                inversionistaBalanceId, -- El ID del registro de balance del inversionista.
                hashTrans,              -- El hash de la transacción (se reutiliza el hash del reporte de ganancias).
                llavePrivada            -- Una llave privada simulada para la transacción.
            )
            VALUES (
                @transaccionId,
                'Pago de Dividendos para Inversión #' + CAST(@inversionIdCursor AS VARCHAR) + ' de la propuesta "' + @tituloPropuesta + '"',
                GETDATE(),
                GETDATE(),
                @pagoId,
                CAST(NEWID() AS VARCHAR(100)), -- Genera un GUID y lo convierte a VARCHAR para el número de referencia.
                @inversionistaIdCursor,
                @transTypeIdDividendos, 
                @inversionistaBalanceIdCursor,
                @hashReporteGanancias, 
                HASHBYTES('SHA2_256', 'LlaveDiv_' + CAST(@pagoId AS VARCHAR) + CAST(@montoDistribuirAInversionista AS VARCHAR)) -- Genera una llave privada simulada.
            );

            -- Registrar el detalle de la distribución para esta inversión en la tabla 'voto_DistribucionDetalle'.
            -- Esta tabla guarda los pormenores de cada dividendo individual dentro del ciclo de distribución mayor.
            INSERT INTO [dbo].[voto_DistribucionDetalle] (
                cycleId,                    -- El ID del ciclo de distribución general al que pertenece este detalle.
                inversionId,                -- El ID de la inversión individual.
                inversionistaId,            -- El ID del perfil de inversionista.
                montoInversion,             -- El monto original de la inversión del inversionista.
                porcentajeParticipacion,    -- El porcentaje de participación calculado.
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
        
        -- Confirmar la transacción si todas las operaciones dentro del bloque TRY fueron exitosas.
        -- Esto hace que todos los cambios sean permanentes en la base de datos.
        COMMIT TRANSACTION;
        
        -- Retornar el resultado exitoso y un mensaje descriptivo de la operación completada.
        SET @resultado = 1;
        SET @mensaje = 'Distribución de dividendos completada exitosamente para el proyecto "' + @tituloPropuesta + '".';
        
    END TRY
    BEGIN CATCH
        -- Manejo de errores: Este bloque se ejecuta si ocurre cualquier error dentro del bloque TRY.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; -- Si hay una transacción abierta, se revierte para deshacer todos los cambios y mantener la integridad de los datos.
            
        SET @resultado = 0; -- Establece el resultado del procedimiento a fallo.
        SET @mensaje = 'Error al distribuir dividendos: ' + ERROR_MESSAGE(); -- Captura el mensaje de error original de SQL Server y lo asigna al parámetro de salida.
        
        -- Registrar el error en la tabla de logs ('voto_Log') para fines de depuración y auditoría.
        INSERT INTO [dbo].[voto_Log] (
            [description], [postTime], [computer], [username],
            [trace], [reference1], [reference2], [checksum]
        )
        VALUES (
            'Error en repartirDividendos: ' + ERROR_MESSAGE(), -- Descripción detallada del error.
            GETDATE(), HOST_NAME(), @usernameEjecutor, -- Fecha/hora del error, nombre del equipo, nombre de usuario ejecutor.
            'Propuesta: ' + @tituloPropuesta + ', Monto a Distribuir: ' + CAST(@montoTotalDistribuir AS VARCHAR), -- Traza del contexto del error.
            @propuestaId, @userIdEjecutor, -- Referencias a la propuesta y el usuario.
            -- Genera un hash SHA2_256 para el registro de log, asegurando su unicidad y la integridad de la entrada del log.
            HASHBYTES('SHA2_256', CAST(@propuestaId AS VARCHAR) + @usernameEjecutor + ERROR_MESSAGE())
        );
    END CATCH;
END;




drop procedure [repartirDividendos]



-- Declaración de variables para los parámetros de entrada del SP
DECLARE @tituloPropuesta NVARCHAR(100) = 'Proyecto de reciclaje comunitario'; -- ¡Importante: Reemplaza con el título exacto de una propuesta en estado 'Ejecutando' que tenga inversiones!
DECLARE @montoTotalDistribuir DECIMAL(15, 2) = 100000.00; -- Monto total de dividendos a repartir (ej. 100,000.00)
DECLARE @fechaDistribucion DATE = GETDATE(); -- Fecha actual de distribución
DECLARE @usernameEjecutor NVARCHAR(50) = 'juan.perez@email.com'; -- ¡Importante: Reemplaza con un username válido y existente en tu tabla voto_Users!
DECLARE @hashReporteGanancias VARBINARY(256); -- Hash del reporte de ganancias, generado para la prueba

-- Generar un hash de ejemplo para el reporte de ganancias
-- Este hash simulará el contenido de un reporte financiero verificado.
SET @hashReporteGanancias = HASHBYTES('SHA2_256', 'ReporteFinanciero_2025_Q2_ProyectoABC_' + CONVERT(NVARCHAR(50), NEWID()));

-- Declaración de variables para los parámetros de salida del SP
DECLARE @resultado BIT;
DECLARE @mensaje NVARCHAR(500);

-- Ejecución del procedimiento almacenado
EXEC [dbo].[repartirDividendos]
    @tituloPropuesta = @tituloPropuesta,
    @montoTotalDistribuir = @montoTotalDistribuir,
    @fechaDistribucion = @fechaDistribucion,
    @usernameEjecutor = @usernameEjecutor,
    @hashReporteGanancias = @hashReporteGanancias,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT;

-- Mostrar los resultados de la ejecución
SELECT 
    @resultado AS 'Resultado de Ejecución (1=Éxito, 0=Fallo)',
    @mensaje AS 'Mensaje del SP';



Select * from voto_DividendDistributionCycle
Select * from voto_InversionistaBalance
Select * from voto_Pagos
Select * from voto_Distribution
Select * from voto_Transacciones
Select * from voto_DistribucionDetalle
Select * from voto_Log