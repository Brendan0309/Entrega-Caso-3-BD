ALTER PROCEDURE [dbo].[sp_InvertirEnPropuesta]
    -- Par�metros de entrada del procedimiento almacenado
    @tituloPropuesta VARCHAR(100),            -- T�tulo de la propuesta en la que se va a invertir.
    @usernameInversionista VARCHAR(50),       -- Nombre de usuario del inversionista que realiza la inversi�n.
    @monto DECIMAL(15, 2),                    -- Cantidad de dinero que el inversionista desea invertir en la propuesta.
    @nombreMetodoPago VARCHAR(50),            -- Nombre del m�todo de pago utilizado para la inversi�n (ej. 'Tarjeta de Cr�dito', 'Transferencia Bancaria').
    @comprobantePago VARCHAR(100),            -- Referencia o n�mero de comprobante de la transacci�n de pago.
    @hashTransaccion VARBINARY(256),          -- Hash binario de la transacci�n para verificar su integridad y unicidad.
    
    -- Par�metros de salida para comunicar el resultado de la ejecuci�n
    @resultado BIT OUTPUT,                    -- Indicador booleano: 0 si la operaci�n fall�, 1 si fue exitosa.
    @mensaje VARCHAR(500) OUTPUT              -- Mensaje descriptivo que proporciona informaci�n sobre el �xito o el error de la operaci�n.
AS
BEGIN
    SET NOCOUNT ON; -- Evita que SQL Server devuelva el n�mero de filas afectadas por las sentencias. Esto puede mejorar el rendimiento, especialmente en aplicaciones.
    
    /* =====================================================
        DECLARACI�N DE VARIABLES
        Se declaran todas las variables locales que se utilizar�n para almacenar IDs, montos,
        fechas y otros datos necesarios a lo largo del procedimiento.
    ===================================================== */
    DECLARE @propuestaId INT,               -- Almacena el ID de la propuesta obtenida por su t�tulo.
            @inversionistaId INT,           -- Almacena el ID del perfil de inversionista.
            @metodoPagoId INT,              -- Almacena el ID del m�todo de pago.
            @userId INT;                    -- Almacena el ID del usuario asociado al inversionista.
    DECLARE @valorTotalProyecto DECIMAL(15, 2), -- Almacena la meta de financiamiento total de la propuesta.
            @porcentajeAccionario DECIMAL(10, 6); -- Almacena el porcentaje accionario calculado para el inversionista.
    DECLARE @planId INT,                   -- Almacena el ID del plan de trabajo de la propuesta.
            @estadoPropuesta INT,           -- Almacena el ID del estado actual de la propuesta.
            @inversionId INT;               -- Almacena el ID de la inversi�n reci�n creada.
    DECLARE @totalInvertido DECIMAL(15, 2), -- Almacena el monto total ya recaudado para la propuesta (por todos los inversores).
            @montoMaximo DECIMAL(15, 2);    -- Almacena el monto m�ximo permitido para la inversi�n de este inversionista.
    DECLARE @currencyId INT,               -- Almacena el ID de la moneda utilizada en la transacci�n.
            @exchangeRate FLOAT;           -- Almacena la tasa de cambio de la moneda.
    DECLARE @publicacionId INT;            -- Almacena el ID de la publicaci�n de crowdfunding.
    DECLARE @transactionName VARCHAR(32) = 'InvertirEnPropuesta'; -- Nombre para la transacci�n expl�cita de SQL Server.
    DECLARE @fechaActual DATETIME = GETDATE(); -- Almacena la fecha y hora actual al inicio del procedimiento.
    DECLARE @recaudacionId INT;             -- Almacena el ID del registro de recaudaci�n de fondos.
    DECLARE @transTypeId INT,               -- Almacena el ID del tipo de transacci�n 'Inversi�n'.
            @fundId INT;                    -- Almacena el ID del fondo principal.
    DECLARE @saldoActual DECIMAL(15, 2) = 0; -- Saldo actual disponible del inversionista (inicializado a 0).
    DECLARE @nuevoSaldo DECIMAL(15, 2);     -- Saldo del inversionista despu�s de la deducci�n de la inversi�n.
    DECLARE @inversionistaBalanceId INT;    -- Almacena el ID del registro de balance del inversionista.
    DECLARE @pagoMedioIdInterno INT;        -- Almacena el ID del medio de pago interno (ej. 'Web').
    DECLARE @docTypeIdContrato INT;         -- Almacena el ID del tipo de documento 'Contrato de Inversi�n'.
    DECLARE @transaccionId INT;             -- Almacena el ID de la transacci�n de balance.
    DECLARE @mediaFileId_Contrato INT;      -- Almacena el ID del archivo multimedia generado para el contrato de inversi�n.
    DECLARE @mediaTypeId_Doc INT;           -- Almacena el ID del tipo de medio 'Documento'.
    DECLARE @documentoId INT;               -- Almacena el ID del documento contractual en voto_Documents.
    
    /* =====================================================
        OBTENER IDs Y DATOS NECESARIOS (FUERA DE TRANSACCI�N)
        Esta secci�n se encarga de recopilar todos los datos de referencia necesarios.
        Se realizan las consultas ANTES de iniciar la transacci�n principal para minimizar
        el tiempo que la transacci�n permanece abierta, reduciendo la contenci�n de bloqueos.
    ===================================================== */
    -- 1. Obtiene el ID de la propuesta, su estado, ID de publicaci�n, meta de financiamiento y fondos recaudados
    --    buscando por el t�tulo de la propuesta. Se utiliza LEFT JOIN para asegurar que, incluso si no hay
    --    registros en 'voto_CrowdfundingPublicaciones' o 'voto_recaudacionFondos', la propuesta a�n pueda ser identificada.
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
    
    -- 3. Obtiene el ID del inversionista y el monto m�ximo de inversi�n permitido para su perfil.
    --    Esta consulta busca el perfil de inversionista asociado al usuario a trav�s de una inversi�n previa.
    --    NOTA: La cl�usula JOIN [dbo].[voto_Inversiones] inv ON i.inversionId = inv.inversionId
    --    y WHERE inv.userId = @userId sugiere que la tabla 'voto_Inversionistas' se relaciona con
    --    'voto_Inversiones' y luego con 'voto_Users'. Si 'voto_Inversionistas' tuviera directamente 'userId',
    --    la relaci�n podr�a simplificarse.
    SELECT TOP 1 
        @inversionistaId = i.inversionistaId,
        @montoMaximo = i.montoMaximoInversion
    FROM [dbo].[voto_Inversionistas] i
    JOIN [dbo].[voto_Inversiones] inv ON i.inversionId = inv.inversionId -- Relaci�n indirecta a trav�s de inversiones.
    WHERE inv.userId = @userId -- Vincula al usuario a trav�s de sus inversiones.
      AND i.estado = 'Activo'
      AND i.acreditado = 1
    ORDER BY i.fechaRegistro DESC; -- Selecciona el perfil m�s reciente si hay varios.

    -- 4. Obtiene el ID del m�todo de pago a partir de su nombre.
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
    ORDER BY cc.startdate DESC; -- Obtiene la tasa de cambio m�s reciente.
    
    -- 6. Obtiene el ID del tipo de transacci�n 'Inversi�n'.
    SELECT @transTypeId = transTypeId 
    FROM [dbo].[voto_transTypes] 
    WHERE name = 'Inversi�n';
    
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
    
    -- 9. Obtiene el ID del plan de trabajo asociado a la propuesta que est� en estado 'Aprobado'.
    SELECT @planId = planId 
    FROM [dbo].[voto_PlanesTrabajo] 
    WHERE propuestaId = @propuestaId AND estado = 'Aprobado';

    -- 10. Obtiene el ID del medio de pago predeterminado 'Web' (asumiendo que se usa para pagos en l�nea).
    SELECT @pagoMedioIdInterno = pagoMedioId
    FROM [dbo].[voto_MediosDisponibles]
    WHERE name = 'Web' AND enabled = 1;

    -- 11. Obtiene el ID del tipo de documento 'Contrato de Inversi�n' de la tabla de tipos de documentos.
    SELECT @docTypeIdContrato = docTypeId
    FROM [dbo].[voto_DocTypes]
    WHERE name = 'Contrato de Inversi�n';

    -- 12. Obtiene el ID del tipo de medio 'Documento' de la tabla de tipos de medios.
    SELECT @mediaTypeId_Doc = mediaTypeId
    FROM [dbo].[voto_MediaTypes]
    WHERE name = 'Documento';
    
    /* =====================================================
        VALIDACIONES INICIALES (M�S ROBUSTAS)
        Esta secci�n realiza validaciones cr�ticas sobre la existencia y validez de los datos
        obtenidos. Si alguna validaci�n falla, el procedimiento se detiene y devuelve un error.
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
    
    -- 2. Verifica que la propuesta est� en el estado 'Publicada' (ID 4) para permitir inversiones.
    IF @estadoPropuesta != 4
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: La propuesta no est� publicada y lista para inversi�n.';
        RETURN;
    END
    
    -- 3. Verifica que el ID del inversionista se haya encontrado y sea v�lido/acreditado.
    IF @inversionistaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Inversionista no v�lido o no acreditado. Aseg�rese de que el usuario tenga un perfil de inversionista activo y acreditado asociado a alguna de sus inversiones.';
        RETURN;
    END

    -- 4. Verifica que el ID del m�todo de pago se haya encontrado.
    IF @metodoPagoId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: M�todo de pago no encontrado.';
        RETURN;
    END

    -- 5. Verifica que la configuraci�n de moneda y tasa de cambio est� disponible.
    IF @currencyId IS NULL OR @exchangeRate IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No se pudo obtener la configuraci�n de moneda y/o tipo de cambio.';
        RETURN;
    END

    -- 6. Verifica que el tipo de transacci�n 'Inversi�n' est� configurado.
    IF @transTypeId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de transacci�n "Inversi�n" no est� configurado.';
        RETURN;
    END

    -- 7. Verifica que el fondo principal est� configurado.
    IF @fundId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El fondo "Fondo Principal" no est� configurado.';
        RETURN;
    END

    -- 8. Verifica que el medio de pago predeterminado 'Web' est� configurado.
    IF @pagoMedioIdInterno IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El medio de pago predeterminado ("Web") no est� configurado o no est� habilitado en voto_MediosDisponibles.';
        RETURN;
    END

    -- 9. Verifica que el tipo de documento 'Contrato de Inversi�n' est� configurado.
    IF @docTypeIdContrato IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de documento "Contrato de Inversi�n" no est� configurado en voto_DocTypes.';
        RETURN;
    END

    -- 10. Verifica que el tipo de medio 'Documento' est� configurado.
    IF @mediaTypeId_Doc IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de medio "Documento" no est� configurado en voto_MediaTypes. Por favor, agregue un tipo de medio con ese nombre.';
        RETURN;
    END
    
    -- 11. Verifica si el inversionista tiene suficiente saldo disponible para la inversi�n.
    IF @saldoActual < @monto
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Saldo insuficiente para realizar la inversi�n.';
        RETURN;
    END
    
    -- 12. Verifica que el monto a invertir sea un valor positivo.
    IF @monto <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto a invertir debe ser mayor que cero.';
        RETURN;
    END

    -- Verifica si el monto a invertir excede el monto m�ximo permitido para este inversionista.
    IF @montoMaximo IS NOT NULL AND @monto > @montoMaximo
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto excede el m�ximo permitido para este inversionista (' + CAST(@montoMaximo AS VARCHAR) + ').';
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
        C�LCULO DE PORCENTAJE ACCIONARIO (REPEATABLE READ)
        Esta secci�n se ejecuta bajo un nivel de aislamiento 'REPEATABLE READ' para garantizar
        que las lecturas de los montos totales no cambien durante el c�lculo del porcentaje,
        evitando inconsistencias por concurrencia.
    ===================================================== */
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        
        -- Obtiene el total de los fondos ya invertidos para *esta propuesta* por *todos* los inversores.
        -- Se usa WITH (UPDLOCK) para tomar un bloqueo de actualizaci�n y prevenir que otras transacciones
        -- modifiquen estos datos mientras se realiza el c�lculo.
        SELECT @totalInvertido = ISNULL(SUM(monto), 0)
        FROM [dbo].[voto_Inversiones] WITH (UPDLOCK)
        WHERE propuestaId = @propuestaId AND estado = 'Aprobada';
        
        -- Calcula la inversi�n total acumulada de *este inversionista* en *esta propuesta*.
        -- Esto incluye las inversiones pasadas del mismo usuario en la misma propuesta.
        DECLARE @totalInvertidoPorEsteInversionista DECIMAL(15, 2);
        SELECT @totalInvertidoPorEsteInversionista = ISNULL(SUM(monto), 0)
        FROM [dbo].[voto_Inversiones]
        WHERE userId = @userId AND propuestaId = @propuestaId AND estado = 'Aprobada';

        -- Suma el monto de la inversi�n actual al total acumulado del inversionista para determinar
        -- su participaci�n total en el c�lculo del porcentaje.
        DECLARE @nuevaInversionTotalInversionista DECIMAL(15, 2) = @totalInvertidoPorEsteInversionista + @monto;

        -- Calcula el porcentaje accionario que le corresponde al inversionista.
        -- Este porcentaje se basa en la *inversi�n total acumulada del inversionista*
        -- sobre el valor total del proyecto.
        IF @valorTotalProyecto > 0
            SET @porcentajeAccionario = (@nuevaInversionTotalInversionista / @valorTotalProyecto) * 100;
        ELSE
            SET @porcentajeAccionario = 0; -- Maneja la divisi�n por cero si el valor del proyecto es 0.

        -- Calcula el porcentaje total de la meta del proyecto que se ha recaudado,
        -- incluyendo el monto de la inversi�n actual.
        DECLARE @porcentajeTotal DECIMAL(10, 6);
        IF @valorTotalProyecto > 0
            SET @porcentajeTotal = ((@totalInvertido + @monto) / @valorTotalProyecto) * 100;
        ELSE
            SET @porcentajeTotal = 0;

        -- Si la suma total de las inversiones (incluyendo la actual) excede la meta del proyecto (100%),
        -- ajusta el monto de la inversi�n actual para que no se sobrepase el 100%.
        IF @porcentajeTotal > 100
        BEGIN
            DECLARE @montoOriginal DECIMAL(15, 2) = @monto; -- Almacena el monto original propuesto.
            -- El nuevo monto de inversi�n se convierte en la cantidad restante para alcanzar la meta.
            SET @monto = @valorTotalProyecto - @totalInvertido;
            
            IF @monto < 0 SET @monto = 0; -- Asegura que el monto ajustado no sea negativo.
            
            -- Recalcula el porcentaje accionario utilizando el monto de inversi�n *ajustado*
            -- m�s las inversiones pasadas del inversionista.
            SET @nuevaInversionTotalInversionista = @totalInvertidoPorEsteInversionista + @monto;
            IF @valorTotalProyecto > 0
                SET @porcentajeAccionario = (@nuevaInversionTotalInversionista / @valorTotalProyecto) * 100;
            ELSE
                SET @porcentajeAccionario = 0;

            -- A�ade un mensaje de advertencia informando sobre el ajuste del monto.
            SET @mensaje = 'Advertencia: El monto de inversi�n se ajust� a ' + CAST(@monto AS VARCHAR) + ' para no exceder el valor total del proyecto.';
        END
    END TRY
    BEGIN CATCH
        -- Captura cualquier error ocurrido durante el c�lculo del porcentaje accionario y devuelve un mensaje.
        SET @resultado = 0;
        SET @mensaje = 'Error al calcular porcentaje accionario: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
    
    -- Restablece el nivel de aislamiento de la transacci�n al predeterminado (READ COMMITTED)
    -- una vez que el c�lculo cr�tico ha terminado.
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    /* =====================================================
        INICIAR TRANSACCI�N (OPERACIONES CR�TICAS)
        Todas las operaciones de modificaci�n de datos se envuelven en una transacci�n
        expl�cita para asegurar atomicidad. Si cualquier paso falla, toda la transacci�n
        se revierte para mantener la integridad de los datos.
    ===================================================== */
    BEGIN TRY
        BEGIN TRANSACTION @transactionName; -- Inicia la transacci�n con un nombre para facilitar el manejo.
        
        /* -----------------------------------------------------
            1. ACTUALIZAR SALDO DEL INVERSIONISTA
            Se modifica el balance del inversionista en la tabla 'voto_InversionistaBalance'.
        ----------------------------------------------------- */
        SET @nuevoSaldo = @saldoActual - @monto; -- Calcula el nuevo saldo restando el monto invertido.
        
        IF @inversionistaBalanceId IS NOT NULL -- Si el inversionista ya tiene un registro de balance.
        BEGIN
            UPDATE [dbo].[voto_InversionistaBalance]
            SET 
                lastBalance = balance,  -- Guarda el saldo actual como 'lastBalance' (saldo antes de esta operaci�n).
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
                @inversionistaId, @nuevoSaldo, @saldoActual, -- Inserta los saldos inicial y final de la operaci�n.
                @fundId, @hashTransaccion -- Asocia al fondo y el hash de la transacci�n.
            );
            
            SET @inversionistaBalanceId = SCOPE_IDENTITY(); -- Obtiene el ID del registro de balance reci�n insertado.
        END
        
        /* -----------------------------------------------------
            2. REGISTRAR LA INVERSI�N
            Se inserta un nuevo registro en la tabla 'voto_Inversiones' con los detalles de la inversi�n.
        ----------------------------------------------------- */
        INSERT INTO [dbo].[voto_Inversiones] (
            [propuestaId], [userId], [monto], 
            [fechaInversion], [metodoPago], [comprobantePago], 
            [hashTransaccion], [estado]
        )
        VALUES (
            @propuestaId, @userId, @monto, -- IDs de propuesta y usuario, y el monto invertido.
            @fechaActual, @nombreMetodoPago, @comprobantePago, -- Fecha, m�todo y comprobante del pago.
            @hashTransaccion, -- Se inserta el hash binario directamente (asumiendo que la columna es VARBINARY).
            'Aprobada' -- Establece el estado inicial de la inversi�n como 'Aprobada'.
        );
        
        SET @inversionId = SCOPE_IDENTITY(); -- Obtiene el ID de la inversi�n reci�n registrada.
        
        /* -----------------------------------------------------
            3. REGISTRAR PAGO CON INFORMACI�N COMPLETA
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
            @inversionistaId, @monto, @monto, 0x01, -- Montos, y estado del resultado (0x01 asumido como �xito).
            0x01, '', @fechaActual, 0x01, @exchangeRate, -- Autorizaci�n, error, fecha, checksum, tasa de cambio.
            @monto * @exchangeRate, 1, @currencyId, @hashTransaccion -- Monto convertido, ID de m�dulo (asumido 1), moneda, hash.
        );
        
        SET @pagoId = SCOPE_IDENTITY(); -- Obtiene el ID del pago reci�n registrado.
        
        /* -----------------------------------------------------
            4. REGISTRAR TRANSACCI�N
            Se inserta un registro detallado en la tabla 'voto_Transacciones' para esta operaci�n de inversi�n.
        ----------------------------------------------------- */
        -- Obtiene el siguiente ID disponible para 'transaccionId'.
        -- Nota: Si 'transaccionId' fuera una columna IDENTITY, esta l�nea y la inclusi�n expl�cita
        -- de 'transaccionId' en el INSERT no ser�an necesarias.
        SELECT @transaccionId = ISNULL(MAX(transaccionId), 0) + 1 FROM [dbo].[voto_Transacciones];

        INSERT INTO [dbo].[voto_Transacciones] (
            [transaccionId], -- ID de la transacci�n (generado manualmente aqu�).
            [description], [tranDateTime], [postTime],
            [pagoId], [refNumber], [inversionistaId],
            [transTypeId], [inversionistaBalanceId], [hashTrans],
            [llavePrivada] 
        )
        VALUES (
            @transaccionId, -- El ID calculado para la transacci�n.
            'Inversi�n en propuesta: ' + @tituloPropuesta, -- Descripci�n de la transacci�n.
            @fechaActual, @fechaActual, -- Fecha y hora de la transacci�n y posteo.
            @pagoId, @comprobantePago, @inversionistaId, -- IDs de pago, referencia y inversionista.
            @transTypeId, @inversionistaBalanceId, @hashTransaccion, -- Tipo de transacci�n, balance ID, hash.
            -- Genera un hash SHA2_256 para una llave privada simulada, usando el hash de la transacci�n.
            HASHBYTES('SHA2_256', 'LlavePrivadaGeneradaParaTransaccion_' + CONVERT(VARCHAR(256), @hashTransaccion)) 
        );
        
        /* -----------------------------------------------------
            5. ACTUALIZAR RECAUDACI�N DE FONDOS
            Se actualizan los fondos recaudados para la propuesta o se crea un nuevo registro
            de recaudaci�n si es la primera inversi�n para esta propuesta.
        ----------------------------------------------------- */
        IF @recaudacionId IS NOT NULL -- Si ya existe un registro de recaudaci�n para la propuesta.
        BEGIN
            UPDATE [dbo].[voto_recaudacionFondos]
            SET fondosRecaudados = fondosRecaudados + @monto, -- Incrementa los fondos recaudados.
                inversionId = @inversionId -- Actualiza la �ltima inversi�n asociada a esta recaudaci�n.
            WHERE recaudacionId = @recaudacionId;
        END
        ELSE -- Si no existe un registro de recaudaci�n de fondos para esta propuesta.
        BEGIN
            INSERT INTO [dbo].[voto_recaudacionFondos] (
				[inversionId],	        -- Relaciona con la inversi�n que acaba de ocurrir.
				[metaFinanciamiento],   -- Establece la meta de financiamiento del proyecto.
				[minimoFinanciamiento],	-- Establece un m�nimo de financiamiento (asumido 50% de la meta).
				[fondosRecaudados],	    -- Inicia los fondos recaudados con el monto de la inversi�n actual.
				[hashContenido]         -- Hash del contenido para verificaci�n.
			)
			VALUES (
				@inversionId,	
				@valorTotalProyecto,
				@valorTotalProyecto * 0.5,	
				@monto,	
				@hashTransaccion
			);
            
            SET @recaudacionId = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo registro de recaudaci�n.
            
            -- Actualiza el registro de publicaci�n de crowdfunding para vincularlo a la nueva recaudaci�n.
            IF @publicacionId IS NOT NULL
            BEGIN
                UPDATE [dbo].[voto_CrowdfundingPublicaciones]
                SET recaudacionId = @recaudacionId
                WHERE publicacionId = @publicacionId;
            END
        END
        
        /* -----------------------------------------------------
            6. PROGRAMAR DESEMBOLSOS
            Se generan registros de desembolsos futuros basados en los �tems definidos en el plan de trabajo.
            El monto de cada desembolso se calcula proporcionalmente al porcentaje accionario
            (la inversi�n acumulada del inversionista) en relaci�n con el valor total del proyecto.
        ----------------------------------------------------- */
        INSERT INTO [dbo].[voto_Desembolsos] (
            [propuestaId], [itemId], [fechaProgramada],
            [monto], [estadoId], [comprobante],
            [hashTransaccion], [userIdAutorizacion], [llavePrivada] 
        )
        SELECT 
            @propuestaId,
            itemId,
            DATEADD(MONTH, numeroMes, @fechaActual), -- Calcula la fecha programada a�adiendo meses a la fecha actual.
            -- Calcula el monto de desembolso para cada �tem. Se usa el 'monto' del �tem de desembolso
            -- y se escala por la proporci�n que la inversi�n total acumulada del inversionista
            -- representa sobre el valor total del proyecto.
            (SELECT @nuevaInversionTotalInversionista * monto / @valorTotalProyecto) AS montoDesembolsoItem, 
            1, -- Estado 'Pendiente' (asumiendo 1 es el ID para pendiente).
            NULL, -- Comprobante inicial nulo.
            @hashTransaccion, -- Hash de la transacci�n.
            NULL, -- Usuario de autorizaci�n inicial nulo.
            -- Genera un hash SHA2_256 para una llave privada simulada para el desembolso.
            HASHBYTES('SHA2_256', 'LlavePrivadaDesembolso_' + CONVERT(VARCHAR(256), @hashTransaccion)) 
        FROM [dbo].[voto_ItemsDesembolso]
        WHERE planId = @planId; -- Filtra por el plan de trabajo de la propuesta.
        
        /* -----------------------------------------------------
            7. GENERAR DOCUMENTACI�N CONTRACTUAL
            Se crean los registros necesarios para el contrato de inversi�n en las tablas
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
            0,     -- Indica que el archivo no est� marcado como eliminado.
            'Contrato de Inversi�n para Propuesta ' + CAST(@propuestaId AS VARCHAR), -- Referencia o descripci�n del archivo.
            @fechaActual, -- Fecha de generaci�n del archivo.
            @mediaTypeId_Doc, -- ID del tipo de medio 'Documento'.
            '1.0'  -- Versi�n inicial del documento.
        );
        SET @mediaFileId_Contrato = SCOPE_IDENTITY(); -- Obtiene el ID generado autom�ticamente para el nuevo mediaFile.

        -- Inserta un registro en 'voto_Documents', que es la tabla maestra de todos los documentos.
        INSERT INTO [dbo].[voto_Documents] (
            [nombreDocumento], [hashDocumento], [usuarioSubio],
            [estadoId], [detalles], [lastUpdate],
            [docTypeId],    -- ID del tipo de documento (singular), seg�n la estructura final de tu tabla.
            [mediaFileId],
            [version] 
        )
        VALUES (
            'Contrato de Inversi�n #' + CAST(@inversionId AS VARCHAR), -- Nombre del documento contractual.
            @hashTransaccion, -- Hash binario del contenido del documento.
            @userId, -- ID del usuario que "subi�" o gener� este documento.
            1, -- Estado 'Activo' (asumiendo 1 es el ID para activo).
            'Documento generado autom�ticamente para la inversi�n de la propuesta ' + @tituloPropuesta, -- Detalles.
            @fechaActual, -- Fecha de la �ltima actualizaci�n.
            @docTypeIdContrato, -- ID del tipo de documento 'Contrato de Inversi�n'.
            @mediaFileId_Contrato, -- ID del archivo multimedia asociado.
            '1.0' -- Versi�n del documento.
        );
        
        SET @documentoId = SCOPE_IDENTITY(); -- Obtiene el ID del documento reci�n insertado.
        
        -- Relaciona el documento contractual con la inversi�n espec�fica en la tabla 'voto_InversionDocumentos'.
        INSERT INTO [dbo].[voto_InversionDocumentos] (
            [documentoId], [inversionId], [fecha], [enabled]
        )
        VALUES (
            @documentoId, @inversionId, @fechaActual, 1 -- Habilita la relaci�n del documento con la inversi�n.
        );
        
        -- Si todas las operaciones dentro del bloque TRY se completaron sin errores,
        -- se confirma la transacci�n, haciendo permanentes todos los cambios.
        COMMIT TRANSACTION @transactionName;
        
        -- Se establece el par�metro de salida @resultado a 1 (�xito) y se construye
        -- un mensaje de �xito, incluyendo el porcentaje accionario calculado.
        SET @resultado = 1;
        SET @mensaje = ISNULL(@mensaje + ' ', '') + 'Inversi�n registrada exitosamente. Porcentaje accionario: ' + 
                     CAST(ROUND(@porcentajeAccionario, 4) AS VARCHAR) + '%';
    END TRY
    BEGIN CATCH
        -- Manejo de errores: este bloque se ejecuta si cualquier error ocurre dentro del bloque TRY.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName; -- Si hay una transacci�n abierta, se revierte para deshacer todos los cambios.
            
        SET @resultado = 0; -- Establece el par�metro de salida @resultado a 0 (error).
        SET @mensaje = 'Error al procesar la inversi�n: ' + ERROR_MESSAGE(); -- Captura y asigna el mensaje de error de SQL Server.
        
        -- Registra el error en la tabla de logs ('voto_Log') para fines de depuraci�n y auditor�a.
        INSERT INTO [dbo].[voto_Log] (
            [description], [postTime], [computer], [username],
            [trace], [reference1], [reference2], [checksum]
        )
        VALUES (
            'Error en sp_InvertirEnPropuesta: ' + ERROR_MESSAGE(), -- Descripci�n detallada del error.
            GETDATE(), HOST_NAME(), @usernameInversionista, -- Fecha/hora, nombre del equipo, nombre de usuario.
            'Propuesta: ' + @tituloPropuesta + ', Monto: ' + CAST(@monto AS VARCHAR), -- Traza del contexto del error.
            @propuestaId, @userId, -- Referencias a la propuesta y el usuario.
            -- Genera un hash SHA2_256 para el registro de log, asegurando su unicidad y la integridad de la entrada.
            HASHBYTES('SHA2_256', CAST(@propuestaId AS VARCHAR) + @usernameInversionista + ERROR_MESSAGE())
        );
    END CATCH
END;

drop procedure [sp_InvertirEnPropuesta];

-- Declarar variables para los par�metros de salida
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
    @nombreMetodoPago = 'Transferencia Bancaria',             -- M�todo existente
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
    p.titulo = 'Proyecto de reciclaje comunitario'; -- Reemplaza con el t�tulo real de tu propuesta


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
    p.titulo = 'Proyecto de reciclaje comunitario'; -- Reemplaza con el t�tulo real de tu propuesta


--modificar el balance
UPDATE [dbo].[voto_InversionistaBalance]
SET
    balance = 100000,  -- Nuevo valor para el saldo actual
    lastBalance = 100000 -- Nuevo valor para el �ltimo saldo registrado
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

