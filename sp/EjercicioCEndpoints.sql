ALTER PROCEDURE [dbo].[sp_InvertirEnPropuesta]
    -- Parámetros de entrada del procedimiento almacenado
    @tituloPropuesta VARCHAR(100),            -- Título de la propuesta en la que se va a invertir.
    @usernameInversionista VARCHAR(50),       -- Nombre de usuario del inversionista que realiza la inversión.
    @monto DECIMAL(15, 2),                    -- Cantidad de dinero que el inversionista desea invertir en la propuesta.
    @nombreMetodoPago VARCHAR(50),            -- Nombre del método de pago utilizado para la inversión (ej. 'Tarjeta de Crédito', 'Transferencia Bancaria').
    @comprobantePago VARCHAR(100),            -- Referencia o número de comprobante de la transacción de pago.
    @hashTransaccion VARBINARY(256),          -- Hash binario de la transacción para verificar su integridad y unicidad.
    
    -- Parámetros de salida para comunicar el resultado de la ejecución
    @resultado BIT OUTPUT,                    -- Indicador booleano: 0 si la operación falló, 1 si fue exitosa.
    @mensaje VARCHAR(500) OUTPUT              -- Mensaje descriptivo que proporciona información sobre el éxito o el error de la operación.
AS
BEGIN
    SET NOCOUNT ON; -- Evita que SQL Server devuelva el número de filas afectadas por las sentencias. Esto puede mejorar el rendimiento, especialmente en aplicaciones.
    
    /* =====================================================
        DECLARACIÓN DE VARIABLES
        Se declaran todas las variables locales que se utilizarán para almacenar IDs, montos,
        fechas y otros datos necesarios a lo largo del procedimiento.
    ===================================================== */
    DECLARE @propuestaId INT,               -- Almacena el ID de la propuesta obtenida por su título.
            @inversionistaId INT,           -- Almacena el ID del perfil de inversionista.
            @metodoPagoId INT,              -- Almacena el ID del método de pago.
            @userId INT;                    -- Almacena el ID del usuario asociado al inversionista.
    DECLARE @valorTotalProyecto DECIMAL(15, 2), -- Almacena la meta de financiamiento total de la propuesta.
            @porcentajeAccionario DECIMAL(10, 6); -- Almacena el porcentaje accionario calculado para el inversionista.
    DECLARE @planId INT,                   -- Almacena el ID del plan de trabajo de la propuesta.
            @estadoPropuesta INT,           -- Almacena el ID del estado actual de la propuesta.
            @inversionId INT;               -- Almacena el ID de la inversión recién creada.
    DECLARE @totalInvertido DECIMAL(15, 2), -- Almacena el monto total ya recaudado para la propuesta (por todos los inversores).
            @montoMaximo DECIMAL(15, 2);    -- Almacena el monto máximo permitido para la inversión de este inversionista.
    DECLARE @currencyId INT,               -- Almacena el ID de la moneda utilizada en la transacción.
            @exchangeRate FLOAT;           -- Almacena la tasa de cambio de la moneda.
    DECLARE @publicacionId INT;            -- Almacena el ID de la publicación de crowdfunding.
    DECLARE @transactionName VARCHAR(32) = 'InvertirEnPropuesta'; -- Nombre para la transacción explícita de SQL Server.
    DECLARE @fechaActual DATETIME = GETDATE(); -- Almacena la fecha y hora actual al inicio del procedimiento.
    DECLARE @recaudacionId INT;             -- Almacena el ID del registro de recaudación de fondos.
    DECLARE @transTypeId INT,               -- Almacena el ID del tipo de transacción 'Inversión'.
            @fundId INT;                    -- Almacena el ID del fondo principal.
    DECLARE @saldoActual DECIMAL(15, 2) = 0; -- Saldo actual disponible del inversionista (inicializado a 0).
    DECLARE @nuevoSaldo DECIMAL(15, 2);     -- Saldo del inversionista después de la deducción de la inversión.
    DECLARE @inversionistaBalanceId INT;    -- Almacena el ID del registro de balance del inversionista.
    DECLARE @pagoMedioIdInterno INT;        -- Almacena el ID del medio de pago interno (ej. 'Web').
    DECLARE @docTypeIdContrato INT;         -- Almacena el ID del tipo de documento 'Contrato de Inversión'.
    DECLARE @transaccionId INT;             -- Almacena el ID de la transacción de balance.
    DECLARE @mediaFileId_Contrato INT;      -- Almacena el ID del archivo multimedia generado para el contrato de inversión.
    DECLARE @mediaTypeId_Doc INT;           -- Almacena el ID del tipo de medio 'Documento'.
    DECLARE @documentoId INT;               -- Almacena el ID del documento contractual en voto_Documents.
    
    /* =====================================================
        OBTENER IDs Y DATOS NECESARIOS (FUERA DE TRANSACCIÓN)
        Esta sección se encarga de recopilar todos los datos de referencia necesarios.
        Se realizan las consultas ANTES de iniciar la transacción principal para minimizar
        el tiempo que la transacción permanece abierta, reduciendo la contención de bloqueos.
    ===================================================== */
    -- 1. Obtiene el ID de la propuesta, su estado, ID de publicación, meta de financiamiento y fondos recaudados
    --    buscando por el título de la propuesta. Se utiliza LEFT JOIN para asegurar que, incluso si no hay
    --    registros en 'voto_CrowdfundingPublicaciones' o 'voto_recaudacionFondos', la propuesta aún pueda ser identificada.
    SELECT 
		@propuestaId = p.propuestaId,
		@estadoPropuesta = p.estadoId,
		@publicacionId = cp.publicacionId,
		@valorTotalProyecto = ISNULL(rf.metaFinanciamiento, 20000.00), -- Asigna la meta de financiamiento, con un valor por defecto si es nula.
		@recaudacionId = rf.recaudacionId,
		@totalInvertido = ISNULL(rf.fondosRecaudados, 0) -- Asigna los fondos ya recaudados, con un valor por defecto de 0 si es nula.
	FROM [dbo].[voto_Propuestas] p
	LEFT JOIN [dbo].[voto_CrowdfundingPublicaciones] cp ON p.propuestaId = cp.propuestaId
	LEFT JOIN [dbo].[voto_recaudacionFondos] rf ON rf.recaudacionId = cp.recaudacionId
	WHERE p.titulo = @tituloPropuesta;
    
    -- 2. Obtiene el ID del usuario a partir de su nombre de usuario.
    SELECT @userId = userId 
    FROM [dbo].[voto_Users] 
    WHERE username = @usernameInversionista;
    
    -- 3. Obtiene el ID del inversionista y el monto máximo de inversión permitido para su perfil.
    --    Esta consulta busca el perfil de inversionista asociado al usuario a través de una inversión previa.
    --    NOTA: La cláusula JOIN [dbo].[voto_Inversiones] inv ON i.inversionId = inv.inversionId
    --    y WHERE inv.userId = @userId sugiere que la tabla 'voto_Inversionistas' se relaciona con
    --    'voto_Inversiones' y luego con 'voto_Users'. Si 'voto_Inversionistas' tuviera directamente 'userId',
    --    la relación podría simplificarse.
    SELECT TOP 1 
        @inversionistaId = i.inversionistaId,
        @montoMaximo = i.montoMaximoInversion
    FROM [dbo].[voto_Inversionistas] i
    JOIN [dbo].[voto_Inversiones] inv ON i.inversionId = inv.inversionId -- Relación indirecta a través de inversiones.
    WHERE inv.userId = @userId -- Vincula al usuario a través de sus inversiones.
      AND i.estado = 'Activo'
      AND i.acreditado = 1
    ORDER BY i.fechaRegistro DESC; -- Selecciona el perfil más reciente si hay varios.

    -- 4. Obtiene el ID del método de pago a partir de su nombre.
    SELECT @metodoPagoId = metodoPagoId
    FROM [dbo].[voto_MetodosDePago]
    WHERE name = @nombreMetodoPago;
    
    -- 5. Obtiene el ID de la moneda y la tasa de cambio actual.
    --    Se asume que la tabla 'voto_CurrencyConvertions' contiene la tasa de cambio actual (currentExchangeRate = 1)
    --    para la moneda base.
    SELECT TOP 1 
        @currencyId = c.currencyId,
        @exchangeRate = cc.exchangeRate
    FROM [dbo].[voto_Currencies] c
    JOIN [dbo].[voto_CurrencyConvertions] cc ON c.currencyId = cc.currencyId_destiny
    WHERE cc.currentExchangeRate = 1 AND cc.enabled = 1
    ORDER BY cc.startdate DESC; -- Obtiene la tasa de cambio más reciente.
    
    -- 6. Obtiene el ID del tipo de transacción 'Inversión'.
    SELECT @transTypeId = transTypeId 
    FROM [dbo].[voto_transTypes] 
    WHERE name = 'Inversión';
    
    -- 7. Obtiene el ID del fondo principal.
    SELECT @fundId = fundId 
    FROM [dbo].[voto_funds] 
    WHERE name = 'Fondo Principal';
    
    -- 8. Obtiene el saldo actual y el ID del registro de balance del inversionista para el fondo principal.
    --    Si no se encuentra un registro, @saldoActual permanece en su valor inicial de 0.
    SELECT 
        @inversionistaBalanceId = personBalanceId,
        @saldoActual = balance
    FROM [dbo].[voto_InversionistaBalance]
    WHERE inversionistaId = @inversionistaId AND fundId = @fundId;
    
    -- 9. Obtiene el ID del plan de trabajo asociado a la propuesta que esté en estado 'Aprobado'.
    SELECT @planId = planId 
    FROM [dbo].[voto_PlanesTrabajo] 
    WHERE propuestaId = @propuestaId AND estado = 'Aprobado';

    -- 10. Obtiene el ID del medio de pago predeterminado 'Web' (asumiendo que se usa para pagos en línea).
    SELECT @pagoMedioIdInterno = pagoMedioId
    FROM [dbo].[voto_MediosDisponibles]
    WHERE name = 'Web' AND enabled = 1;

    -- 11. Obtiene el ID del tipo de documento 'Contrato de Inversión' de la tabla de tipos de documentos.
    SELECT @docTypeIdContrato = docTypeId
    FROM [dbo].[voto_DocTypes]
    WHERE name = 'Contrato de Inversión';

    -- 12. Obtiene el ID del tipo de medio 'Documento' de la tabla de tipos de medios.
    SELECT @mediaTypeId_Doc = mediaTypeId
    FROM [dbo].[voto_MediaTypes]
    WHERE name = 'Documento';
    
    /* =====================================================
        VALIDACIONES INICIALES (MÁS ROBUSTAS)
        Esta sección realiza validaciones críticas sobre la existencia y validez de los datos
        obtenidos. Si alguna validación falla, el procedimiento se detiene y devuelve un error.
    ===================================================== */
    -- 0. Verifica que el ID del usuario inversionista se haya encontrado.
    IF @userId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Usuario inversionista no encontrado.';
        RETURN;
    END

    -- 1. Verifica que el ID de la propuesta se haya encontrado.
    IF @propuestaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Propuesta no encontrada.';
        RETURN;
    END
    
    -- 2. Verifica que la propuesta esté en el estado 'Publicada' (ID 4) para permitir inversiones.
    IF @estadoPropuesta != 4
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: La propuesta no está publicada y lista para inversión.';
        RETURN;
    END
    
    -- 3. Verifica que el ID del inversionista se haya encontrado y sea válido/acreditado.
    IF @inversionistaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Inversionista no válido o no acreditado. Asegúrese de que el usuario tenga un perfil de inversionista activo y acreditado asociado a alguna de sus inversiones.';
        RETURN;
    END

    -- 4. Verifica que el ID del método de pago se haya encontrado.
    IF @metodoPagoId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Método de pago no encontrado.';
        RETURN;
    END

    -- 5. Verifica que la configuración de moneda y tasa de cambio esté disponible.
    IF @currencyId IS NULL OR @exchangeRate IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No se pudo obtener la configuración de moneda y/o tipo de cambio.';
        RETURN;
    END

    -- 6. Verifica que el tipo de transacción 'Inversión' esté configurado.
    IF @transTypeId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de transacción "Inversión" no está configurado.';
        RETURN;
    END

    -- 7. Verifica que el fondo principal esté configurado.
    IF @fundId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El fondo "Fondo Principal" no está configurado.';
        RETURN;
    END

    -- 8. Verifica que el medio de pago predeterminado 'Web' esté configurado.
    IF @pagoMedioIdInterno IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El medio de pago predeterminado ("Web") no está configurado o no está habilitado en voto_MediosDisponibles.';
        RETURN;
    END

    -- 9. Verifica que el tipo de documento 'Contrato de Inversión' esté configurado.
    IF @docTypeIdContrato IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de documento "Contrato de Inversión" no está configurado en voto_DocTypes.';
        RETURN;
    END

    -- 10. Verifica que el tipo de medio 'Documento' esté configurado.
    IF @mediaTypeId_Doc IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de medio "Documento" no está configurado en voto_MediaTypes. Por favor, agregue un tipo de medio con ese nombre.';
        RETURN;
    END
    
    -- 11. Verifica si el inversionista tiene suficiente saldo disponible para la inversión.
    IF @saldoActual < @monto
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Saldo insuficiente para realizar la inversión.';
        RETURN;
    END
    
    -- 12. Verifica que el monto a invertir sea un valor positivo.
    IF @monto <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto a invertir debe ser mayor que cero.';
        RETURN;
    END

    -- Verifica si el monto a invertir excede el monto máximo permitido para este inversionista.
    IF @montoMaximo IS NOT NULL AND @monto > @montoMaximo
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto excede el máximo permitido para este inversionista (' + CAST(@montoMaximo AS VARCHAR) + ').';
        RETURN;
    END
    
    -- Verifica si la suma del monto actual y el total ya invertido excede el valor total del proyecto.
    IF (@totalInvertido + @monto) > @valorTotalProyecto
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto excede el valor total del proyecto. El monto restante a recaudar es ' + CAST((@valorTotalProyecto - @totalInvertido) AS VARCHAR) + '.';
        RETURN;
    END
    
    -- 13. Verifica si existe un plan de trabajo aprobado para la propuesta.
    IF @planId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No existe un plan de trabajo aprobado para esta propuesta.';
        RETURN;
    END
    
    /* =====================================================
        CÁLCULO DE PORCENTAJE ACCIONARIO (REPEATABLE READ)
        Esta sección se ejecuta bajo un nivel de aislamiento 'REPEATABLE READ' para garantizar
        que las lecturas de los montos totales no cambien durante el cálculo del porcentaje,
        evitando inconsistencias por concurrencia.
    ===================================================== */
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        
        -- Obtiene el total de los fondos ya invertidos para *esta propuesta* por *todos* los inversores.
        -- Se usa WITH (UPDLOCK) para tomar un bloqueo de actualización y prevenir que otras transacciones
        -- modifiquen estos datos mientras se realiza el cálculo.
        SELECT @totalInvertido = ISNULL(SUM(monto), 0)
        FROM [dbo].[voto_Inversiones] WITH (UPDLOCK)
        WHERE propuestaId = @propuestaId AND estado = 'Aprobada';
        
        -- Calcula la inversión total acumulada de *este inversionista* en *esta propuesta*.
        -- Esto incluye las inversiones pasadas del mismo usuario en la misma propuesta.
        DECLARE @totalInvertidoPorEsteInversionista DECIMAL(15, 2);
        SELECT @totalInvertidoPorEsteInversionista = ISNULL(SUM(monto), 0)
        FROM [dbo].[voto_Inversiones]
        WHERE userId = @userId AND propuestaId = @propuestaId AND estado = 'Aprobada';

        -- Suma el monto de la inversión actual al total acumulado del inversionista para determinar
        -- su participación total en el cálculo del porcentaje.
        DECLARE @nuevaInversionTotalInversionista DECIMAL(15, 2) = @totalInvertidoPorEsteInversionista + @monto;

        -- Calcula el porcentaje accionario que le corresponde al inversionista.
        -- Este porcentaje se basa en la *inversión total acumulada del inversionista*
        -- sobre el valor total del proyecto.
        IF @valorTotalProyecto > 0
            SET @porcentajeAccionario = (@nuevaInversionTotalInversionista / @valorTotalProyecto) * 100;
        ELSE
            SET @porcentajeAccionario = 0; -- Maneja la división por cero si el valor del proyecto es 0.

        -- Calcula el porcentaje total de la meta del proyecto que se ha recaudado,
        -- incluyendo el monto de la inversión actual.
        DECLARE @porcentajeTotal DECIMAL(10, 6);
        IF @valorTotalProyecto > 0
            SET @porcentajeTotal = ((@totalInvertido + @monto) / @valorTotalProyecto) * 100;
        ELSE
            SET @porcentajeTotal = 0;

        -- Si la suma total de las inversiones (incluyendo la actual) excede la meta del proyecto (100%),
        -- ajusta el monto de la inversión actual para que no se sobrepase el 100%.
        IF @porcentajeTotal > 100
        BEGIN
            DECLARE @montoOriginal DECIMAL(15, 2) = @monto; -- Almacena el monto original propuesto.
            -- El nuevo monto de inversión se convierte en la cantidad restante para alcanzar la meta.
            SET @monto = @valorTotalProyecto - @totalInvertido;
            
            IF @monto < 0 SET @monto = 0; -- Asegura que el monto ajustado no sea negativo.
            
            -- Recalcula el porcentaje accionario utilizando el monto de inversión *ajustado*
            -- más las inversiones pasadas del inversionista.
            SET @nuevaInversionTotalInversionista = @totalInvertidoPorEsteInversionista + @monto;
            IF @valorTotalProyecto > 0
                SET @porcentajeAccionario = (@nuevaInversionTotalInversionista / @valorTotalProyecto) * 100;
            ELSE
                SET @porcentajeAccionario = 0;

            -- Añade un mensaje de advertencia informando sobre el ajuste del monto.
            SET @mensaje = 'Advertencia: El monto de inversión se ajustó a ' + CAST(@monto AS VARCHAR) + ' para no exceder el valor total del proyecto.';
        END
    END TRY
    BEGIN CATCH
        -- Captura cualquier error ocurrido durante el cálculo del porcentaje accionario y devuelve un mensaje.
        SET @resultado = 0;
        SET @mensaje = 'Error al calcular porcentaje accionario: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
    
    -- Restablece el nivel de aislamiento de la transacción al predeterminado (READ COMMITTED)
    -- una vez que el cálculo crítico ha terminado.
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    /* =====================================================
        INICIAR TRANSACCIÓN (OPERACIONES CRÍTICAS)
        Todas las operaciones de modificación de datos se envuelven en una transacción
        explícita para asegurar atomicidad. Si cualquier paso falla, toda la transacción
        se revierte para mantener la integridad de los datos.
    ===================================================== */
    BEGIN TRY
        BEGIN TRANSACTION @transactionName; -- Inicia la transacción con un nombre para facilitar el manejo.
        
        /* -----------------------------------------------------
            1. ACTUALIZAR SALDO DEL INVERSIONISTA
            Se modifica el balance del inversionista en la tabla 'voto_InversionistaBalance'.
        ----------------------------------------------------- */
        SET @nuevoSaldo = @saldoActual - @monto; -- Calcula el nuevo saldo restando el monto invertido.
        
        IF @inversionistaBalanceId IS NOT NULL -- Si el inversionista ya tiene un registro de balance.
        BEGIN
            UPDATE [dbo].[voto_InversionistaBalance]
            SET 
                lastBalance = balance,  -- Guarda el saldo actual como 'lastBalance' (saldo antes de esta operación).
                balance = @nuevoSaldo   -- Actualiza el 'balance' con el nuevo saldo.
            WHERE personBalanceId = @inversionistaBalanceId;
        END
        ELSE -- Si el inversionista no tiene un registro de balance, se inserta uno nuevo.
        BEGIN
            INSERT INTO [dbo].[voto_InversionistaBalance] (
                [inversionistaId], [balance], [lastBalance],
                [fundId], [hashContenido]
            )
            VALUES (
                @inversionistaId, @nuevoSaldo, @saldoActual, -- Inserta los saldos inicial y final de la operación.
                @fundId, @hashTransaccion -- Asocia al fondo y el hash de la transacción.
            );
            
            SET @inversionistaBalanceId = SCOPE_IDENTITY(); -- Obtiene el ID del registro de balance recién insertado.
        END
        
        /* -----------------------------------------------------
            2. REGISTRAR LA INVERSIÓN
            Se inserta un nuevo registro en la tabla 'voto_Inversiones' con los detalles de la inversión.
        ----------------------------------------------------- */
        INSERT INTO [dbo].[voto_Inversiones] (
            [propuestaId], [userId], [monto], 
            [fechaInversion], [metodoPago], [comprobantePago], 
            [hashTransaccion], [estado]
        )
        VALUES (
            @propuestaId, @userId, @monto, -- IDs de propuesta y usuario, y el monto invertido.
            @fechaActual, @nombreMetodoPago, @comprobantePago, -- Fecha, método y comprobante del pago.
            @hashTransaccion, -- Se inserta el hash binario directamente (asumiendo que la columna es VARBINARY).
            'Aprobada' -- Establece el estado inicial de la inversión como 'Aprobada'.
        );
        
        SET @inversionId = SCOPE_IDENTITY(); -- Obtiene el ID de la inversión recién registrada.
        
        /* -----------------------------------------------------
            3. REGISTRAR PAGO CON INFORMACIÓN COMPLETA
            Se inserta el detalle del pago en la tabla 'voto_Pagos'.
        ----------------------------------------------------- */
        DECLARE @pagoId INT; -- Declara la variable para almacenar el ID del pago.
        
        INSERT INTO [dbo].[voto_Pagos] (
            [pagoMedioId], [metodoPagoId], [propuestaId], [inversionId],
            [inversionistaId], [monto], [actualMonto], [result],
            [auth], [error], [fecha], [checksum], [exchangeRate],
            [convertedAmount], [moduleId], [currencyId], [hashContenido]
        )
        VALUES (
            @pagoMedioIdInterno, -- ID del medio de pago interno (ej. 'Web').
            @metodoPagoId, @propuestaId, @inversionId, -- IDs relevantes.
            @inversionistaId, @monto, @monto, 0x01, -- Montos, y estado del resultado (0x01 asumido como éxito).
            0x01, '', @fechaActual, 0x01, @exchangeRate, -- Autorización, error, fecha, checksum, tasa de cambio.
            @monto * @exchangeRate, 1, @currencyId, @hashTransaccion -- Monto convertido, ID de módulo (asumido 1), moneda, hash.
        );
        
        SET @pagoId = SCOPE_IDENTITY(); -- Obtiene el ID del pago recién registrado.
        
        /* -----------------------------------------------------
            4. REGISTRAR TRANSACCIÓN
            Se inserta un registro detallado en la tabla 'voto_Transacciones' para esta operación de inversión.
        ----------------------------------------------------- */
        -- Obtiene el siguiente ID disponible para 'transaccionId'.
        -- Nota: Si 'transaccionId' fuera una columna IDENTITY, esta línea y la inclusión explícita
        -- de 'transaccionId' en el INSERT no serían necesarias.
        SELECT @transaccionId = ISNULL(MAX(transaccionId), 0) + 1 FROM [dbo].[voto_Transacciones];

        INSERT INTO [dbo].[voto_Transacciones] (
            [transaccionId], -- ID de la transacción (generado manualmente aquí).
            [description], [tranDateTime], [postTime],
            [pagoId], [refNumber], [inversionistaId],
            [transTypeId], [inversionistaBalanceId], [hashTrans],
            [llavePrivada] 
        )
        VALUES (
            @transaccionId, -- El ID calculado para la transacción.
            'Inversión en propuesta: ' + @tituloPropuesta, -- Descripción de la transacción.
            @fechaActual, @fechaActual, -- Fecha y hora de la transacción y posteo.
            @pagoId, @comprobantePago, @inversionistaId, -- IDs de pago, referencia y inversionista.
            @transTypeId, @inversionistaBalanceId, @hashTransaccion, -- Tipo de transacción, balance ID, hash.
            -- Genera un hash SHA2_256 para una llave privada simulada, usando el hash de la transacción.
            HASHBYTES('SHA2_256', 'LlavePrivadaGeneradaParaTransaccion_' + CONVERT(VARCHAR(256), @hashTransaccion)) 
        );
        
        /* -----------------------------------------------------
            5. ACTUALIZAR RECAUDACIÓN DE FONDOS
            Se actualizan los fondos recaudados para la propuesta o se crea un nuevo registro
            de recaudación si es la primera inversión para esta propuesta.
        ----------------------------------------------------- */
        IF @recaudacionId IS NOT NULL -- Si ya existe un registro de recaudación para la propuesta.
        BEGIN
            UPDATE [dbo].[voto_recaudacionFondos]
            SET fondosRecaudados = fondosRecaudados + @monto, -- Incrementa los fondos recaudados.
                inversionId = @inversionId -- Actualiza la última inversión asociada a esta recaudación.
            WHERE recaudacionId = @recaudacionId;
        END
        ELSE -- Si no existe un registro de recaudación de fondos para esta propuesta.
        BEGIN
            INSERT INTO [dbo].[voto_recaudacionFondos] (
				[inversionId],	        -- Relaciona con la inversión que acaba de ocurrir.
				[metaFinanciamiento],   -- Establece la meta de financiamiento del proyecto.
				[minimoFinanciamiento],	-- Establece un mínimo de financiamiento (asumido 50% de la meta).
				[fondosRecaudados],	    -- Inicia los fondos recaudados con el monto de la inversión actual.
				[hashContenido]         -- Hash del contenido para verificación.
			)
			VALUES (
				@inversionId,	
				@valorTotalProyecto,
				@valorTotalProyecto * 0.5,	
				@monto,	
				@hashTransaccion
			);
            
            SET @recaudacionId = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo registro de recaudación.
            
            -- Actualiza el registro de publicación de crowdfunding para vincularlo a la nueva recaudación.
            IF @publicacionId IS NOT NULL
            BEGIN
                UPDATE [dbo].[voto_CrowdfundingPublicaciones]
                SET recaudacionId = @recaudacionId
                WHERE publicacionId = @publicacionId;
            END
        END
        
        /* -----------------------------------------------------
            6. PROGRAMAR DESEMBOLSOS
            Se generan registros de desembolsos futuros basados en los ítems definidos en el plan de trabajo.
            El monto de cada desembolso se calcula proporcionalmente al porcentaje accionario
            (la inversión acumulada del inversionista) en relación con el valor total del proyecto.
        ----------------------------------------------------- */
        INSERT INTO [dbo].[voto_Desembolsos] (
            [propuestaId], [itemId], [fechaProgramada],
            [monto], [estadoId], [comprobante],
            [hashTransaccion], [userIdAutorizacion], [llavePrivada] 
        )
        SELECT 
            @propuestaId,
            itemId,
            DATEADD(MONTH, numeroMes, @fechaActual), -- Calcula la fecha programada añadiendo meses a la fecha actual.
            -- Calcula el monto de desembolso para cada ítem. Se usa el 'monto' del ítem de desembolso
            -- y se escala por la proporción que la inversión total acumulada del inversionista
            -- representa sobre el valor total del proyecto.
            (SELECT @nuevaInversionTotalInversionista * monto / @valorTotalProyecto) AS montoDesembolsoItem, 
            1, -- Estado 'Pendiente' (asumiendo 1 es el ID para pendiente).
            NULL, -- Comprobante inicial nulo.
            @hashTransaccion, -- Hash de la transacción.
            NULL, -- Usuario de autorización inicial nulo.
            -- Genera un hash SHA2_256 para una llave privada simulada para el desembolso.
            HASHBYTES('SHA2_256', 'LlavePrivadaDesembolso_' + CONVERT(VARCHAR(256), @hashTransaccion)) 
        FROM [dbo].[voto_ItemsDesembolso]
        WHERE planId = @planId; -- Filtra por el plan de trabajo de la propuesta.
        
        /* -----------------------------------------------------
            7. GENERAR DOCUMENTACIÓN CONTRACTUAL
            Se crean los registros necesarios para el contrato de inversión en las tablas
            'voto_MediaFiles', 'voto_Documents' y 'voto_InversionDocumentos'.
        ----------------------------------------------------- */
        -- Inserta un registro en 'voto_MediaFiles' para el documento del contrato.
        -- Como 'mediaFileId' es IDENTITY, la base de datos auto-genera el ID.
        INSERT INTO [dbo].[voto_MediaFiles] (
            [url],            
            [deleted],        
            [reference],      
            [generationDate], 
            [mediaTypeId],    
            [version]         
        )
        VALUES (
            'https://tu_dominio.com/contratos/' + CONVERT(VARCHAR(50), @inversionId) + '.pdf', -- URL simulada del contrato.
            0,     -- Indica que el archivo no está marcado como eliminado.
            'Contrato de Inversión para Propuesta ' + CAST(@propuestaId AS VARCHAR), -- Referencia o descripción del archivo.
            @fechaActual, -- Fecha de generación del archivo.
            @mediaTypeId_Doc, -- ID del tipo de medio 'Documento'.
            '1.0'  -- Versión inicial del documento.
        );
        SET @mediaFileId_Contrato = SCOPE_IDENTITY(); -- Obtiene el ID generado automáticamente para el nuevo mediaFile.

        -- Inserta un registro en 'voto_Documents', que es la tabla maestra de todos los documentos.
        INSERT INTO [dbo].[voto_Documents] (
            [nombreDocumento], [hashDocumento], [usuarioSubio],
            [estadoId], [detalles], [lastUpdate],
            [docTypeId],    -- ID del tipo de documento (singular), según la estructura final de tu tabla.
            [mediaFileId],
            [version] 
        )
        VALUES (
            'Contrato de Inversión #' + CAST(@inversionId AS VARCHAR), -- Nombre del documento contractual.
            @hashTransaccion, -- Hash binario del contenido del documento.
            @userId, -- ID del usuario que "subió" o generó este documento.
            1, -- Estado 'Activo' (asumiendo 1 es el ID para activo).
            'Documento generado automáticamente para la inversión de la propuesta ' + @tituloPropuesta, -- Detalles.
            @fechaActual, -- Fecha de la última actualización.
            @docTypeIdContrato, -- ID del tipo de documento 'Contrato de Inversión'.
            @mediaFileId_Contrato, -- ID del archivo multimedia asociado.
            '1.0' -- Versión del documento.
        );
        
        SET @documentoId = SCOPE_IDENTITY(); -- Obtiene el ID del documento recién insertado.
        
        -- Relaciona el documento contractual con la inversión específica en la tabla 'voto_InversionDocumentos'.
        INSERT INTO [dbo].[voto_InversionDocumentos] (
            [documentoId], [inversionId], [fecha], [enabled]
        )
        VALUES (
            @documentoId, @inversionId, @fechaActual, 1 -- Habilita la relación del documento con la inversión.
        );
        
        -- Si todas las operaciones dentro del bloque TRY se completaron sin errores,
        -- se confirma la transacción, haciendo permanentes todos los cambios.
        COMMIT TRANSACTION @transactionName;
        
        -- Se establece el parámetro de salida @resultado a 1 (éxito) y se construye
        -- un mensaje de éxito, incluyendo el porcentaje accionario calculado.
        SET @resultado = 1;
        SET @mensaje = ISNULL(@mensaje + ' ', '') + 'Inversión registrada exitosamente. Porcentaje accionario: ' + 
                     CAST(ROUND(@porcentajeAccionario, 4) AS VARCHAR) + '%';
    END TRY
    BEGIN CATCH
        -- Manejo de errores: este bloque se ejecuta si cualquier error ocurre dentro del bloque TRY.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName; -- Si hay una transacción abierta, se revierte para deshacer todos los cambios.
            
        SET @resultado = 0; -- Establece el parámetro de salida @resultado a 0 (error).
        SET @mensaje = 'Error al procesar la inversión: ' + ERROR_MESSAGE(); -- Captura y asigna el mensaje de error de SQL Server.
        
        -- Registra el error en la tabla de logs ('voto_Log') para fines de depuración y auditoría.
        INSERT INTO [dbo].[voto_Log] (
            [description], [postTime], [computer], [username],
            [trace], [reference1], [reference2], [checksum]
        )
        VALUES (
            'Error en sp_InvertirEnPropuesta: ' + ERROR_MESSAGE(), -- Descripción detallada del error.
            GETDATE(), HOST_NAME(), @usernameInversionista, -- Fecha/hora, nombre del equipo, nombre de usuario.
            'Propuesta: ' + @tituloPropuesta + ', Monto: ' + CAST(@monto AS VARCHAR), -- Traza del contexto del error.
            @propuestaId, @userId, -- Referencias a la propuesta y el usuario.
            -- Genera un hash SHA2_256 para el registro de log, asegurando su unicidad y la integridad de la entrada.
            HASHBYTES('SHA2_256', CAST(@propuestaId AS VARCHAR) + @usernameInversionista + ERROR_MESSAGE())
        );
    END CATCH
END;

drop procedure [sp_InvertirEnPropuesta];

-- Declarar variables para los parámetros de salida
DECLARE @resultado BIT
DECLARE @mensaje VARCHAR(500)
DECLARE @comprobante VARCHAR(100)
DECLARE @hashTransaccion VARBINARY(256)

-- Generar valores para comprobante y hash
SET @comprobante = 'COMP-' + CONVERT(VARCHAR, GETDATE(), 112) + 
                    REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '')
SET @hashTransaccion = HASHBYTES('SHA2_256', 'transaccion_' + 
                                  CONVERT(VARCHAR, GETDATE(), 112) + 
                                  REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', ''))

-- Ejecutar el procedimiento
EXEC [dbo].[sp_InvertirEnPropuesta]
    @tituloPropuesta = 'Proyecto de reciclaje comunitario',  -- Propuesta en estado 4 (Publicada)
    @usernameInversionista = 'juan.perez@email.com',          -- Usuario con saldo
    @monto = 10000.00,                                        -- Menor que el saldo disponible
    @nombreMetodoPago = 'Transferencia Bancaria',             -- Método existente
    @comprobantePago = @comprobante,
    @hashTransaccion = @hashTransaccion,
    @resultado = @resultado OUTPUT,
    @mensaje = @mensaje OUTPUT

-- Mostrar resultados
SELECT 
    @resultado AS Resultado,
    @mensaje AS Mensaje;


SELECT * FROM voto_Inversiones WHERE hashTransaccion = CONVERT(VARCHAR(256), @hashTransaccion);
SELECT * FROM voto_InversionistaBalance WHERE inversionistaId = (SELECT i.inversionistaId FROM voto_Inversionistas i JOIN voto_Inversiones inv ON i.inversionId = inv.inversionId WHERE inv.userId = (SELECT userId FROM voto_Users WHERE username = 'juan.perez@email.com'));
SELECT * FROM voto_Pagos WHERE hashContenido = @hashTransaccion;
SELECT * FROM voto_Transacciones WHERE hashTrans = @hashTransaccion;
SELECT * FROM voto_Desembolsos WHERE hashTransaccion = @hashTransaccion;
SELECT * FROM voto_Documents WHERE hashDocumento = @hashTransaccion;
SELECT * FROM voto_InversionDocumentos WHERE documentoId = (SELECT documentoId FROM voto_Documents WHERE hashDocumento = @hashTransaccion);
SELECT * FROM voto_Log ORDER BY postTime DESC; -- Para ver los logs de errores


select * from voto_InversionistaBalance

--verifica el monto de recaudacion del proyecto

SELECT
    p.titulo AS 'Proyecto de reciclaje comunitario',
    rf.metaFinanciamiento AS 'Meta Financiamiento',
    rf.fondosRecaudados AS 'Fondos Recaudados Actuales',
    (rf.metaFinanciamiento - rf.fondosRecaudados) AS 'Monto Restante para Recaudar',
    rf.recaudacionId
FROM
    voto_Propuestas p
JOIN
    voto_CrowdfundingPublicaciones cp ON p.propuestaId = cp.propuestaId
JOIN
    voto_recaudacionFondos rf ON cp.recaudacionId = rf.recaudacionId
WHERE
    p.titulo = 'Proyecto de reciclaje comunitario'; -- Reemplaza con el título real de tu propuesta


--Modifica el monto recaudado
UPDATE [dbo].[voto_recaudacionFondos]
SET
    metaFinanciamiento = 150000.00 -- Nuevo monto meta de financiamiento
WHERE
    recaudacionId = (
        SELECT TOP 1 rf.recaudacionId
        FROM voto_Propuestas p
        JOIN voto_CrowdfundingPublicaciones cp ON p.propuestaId = cp.propuestaId
        JOIN voto_recaudacionFondos rf ON cp.recaudacionId = rf.recaudacionId
        WHERE p.titulo = 'Proyecto de reciclaje comunitario'
    );

-- Para verificar el cambio:
SELECT
    p.titulo,
    rf.metaFinanciamiento,
    rf.fondosRecaudados
FROM
    voto_Propuestas p
JOIN
    voto_CrowdfundingPublicaciones cp ON p.propuestaId = cp.propuestaId
JOIN
    voto_recaudacionFondos rf ON cp.recaudacionId = rf.recaudacionId
WHERE
    p.titulo = 'Proyecto de reciclaje comunitario'; -- Reemplaza con el título real de tu propuesta


--modificar el balance
UPDATE [dbo].[voto_InversionistaBalance]
SET
    balance = 100000,  -- Nuevo valor para el saldo actual
    lastBalance = 100000 -- Nuevo valor para el último saldo registrado
WHERE
    personBalanceId = 4; -- ID del registro de balance a modificar

-- PASO 3: Verifica el cambio (opcional).
-- Ejecuta esta consulta para confirmar que los valores se actualizaron correctamente.
SELECT
    personBalanceId,
    inversionistaId,
    balance,
    lastBalance,
    fundId
FROM
    [dbo].[voto_InversionistaBalance]
WHERE
    personBalanceId = 4; -- ID del registro de balance que acabas de modificar

