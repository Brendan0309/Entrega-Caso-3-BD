alter PROCEDURE [dbo].[crearActualizarPropuesta]
    -- Parámetros de entrada del procedimiento almacenado.
    -- Estos parámetros permiten tanto la creación de una nueva propuesta como la actualización de una existente.
    @propuestaTitulo VARCHAR(100) = NULL,   -- Título actual de la propuesta (requerido para actualización, NULL para creación).
    @titulo VARCHAR(100),                   -- Nuevo título de la propuesta (o el mismo si solo se actualizan otros campos).
    @descripcion VARCHAR(1500),             -- Descripción detallada de la propuesta.
    @resumenEjecutivo VARCHAR(1500),        -- Resumen conciso de la propuesta.
    @nombreUsuario VARCHAR(100),            -- Nombre de usuario del creador o modificador de la propuesta.
    @tipoPropuestaNombre VARCHAR(50),       -- Nombre del tipo de propuesta (ej. 'Proyecto Social', 'Innovación').
    @institucionNombre VARCHAR(100) = NULL, -- Nombre de la institución asociada (opcional).
    @documentosJSON VARCHAR(1500),          -- Cadena JSON con la información de los documentos de la propuesta.
                                            -- Formato esperado: '[{"nombreDocumento": "doc1.pdf", "tipoDocumento": "PDF"}]'
                                            -- O alternativo: '{"Documentos":[{"nombreDocumento": "doc1.pdf", "tipoDocumento": "PDF"}]}'
    @segmentosDirigidosJSON VARCHAR(1500),  -- Cadena JSON con los segmentos de audiencia a los que la propuesta está dirigida.
                                            -- Formato esperado: '[{"nombre": "Jóvenes"}, {"nombre": "Adultos"}]'
    @segmentosImpactoJSON VARCHAR(1500),    -- Cadena JSON con los segmentos de impacto que la propuesta busca lograr.
                                            -- Formato esperado: '[{"nombre": "Jóvenes"}, {"nombre": "Adultos"}]'
    @nuevoEstadoNombre VARCHAR(50) = 'Pendiente de validación' -- Nombre del estado inicial o nuevo estado de la propuesta.
AS
BEGIN
    SET NOCOUNT ON; -- Evita que se envíen mensajes de conteo de filas afectadas, mejorando el rendimiento.
    
    -- Variables de control generales para el procedimiento.
    DECLARE @transactionName VARCHAR(32) = 'crearActualizarPropuesta'; -- Nombre para la transacción explícita.
    DECLARE @fechaActual DATETIME = GETDATE();                        -- Almacena la fecha y hora actual al inicio del SP.
    DECLARE @hashDocumentacion VARBINARY(250);                      -- Almacena el hash calculado de la documentación de la propuesta.
    DECLARE @hashContenido VARBINARY(250);                          -- Almacena el hash calculado del contenido principal de la propuesta.
    DECLARE @resultado INT = 0;                                     -- Variable para el resultado final del SP (0 por defecto, indica éxito o error).
    DECLARE @mensaje VARCHAR(500) = 'Operación exitosa';             -- Mensaje descriptivo del resultado.
    
    -- Variables para almacenar IDs de entidades de la base de datos.
    DECLARE @propuestaId INT;       -- ID de la propuesta (existente o recién creada).
    DECLARE @userId INT;            -- ID del usuario que crea/actualiza la propuesta.
    DECLARE @tipoPropuestaId INT;   -- ID del tipo de propuesta.
    DECLARE @institucionId INT = NULL; -- ID de la institución (NULL si no se proporciona o no existe).
    DECLARE @nuevoEstadoId INT;     -- ID del nuevo estado de la propuesta.
    DECLARE @userName VARCHAR(50);  -- Nombre de usuario real (se obtiene y se usa para el log).
    
    -- Variables booleanas para validaciones previas a la transacción.
    DECLARE @docTypesValidos BIT = 1;   -- Bandera para validar los tipos de documento (si todos existen).
    DECLARE @existePropuesta BIT = 0;   -- Bandera para indicar si la propuesta ya existe (para determinar si es CREATE o UPDATE).
    
    -- Variable para almacenar un ID de archivo multimedia por defecto.
    DECLARE @defaultMediaFileId INT;
    
    -- Declaración de tablas temporales para parsear los datos JSON de entrada.
    -- Estas tablas se usan para estructurar los datos JSON antes de insertarlos/actualizarlos en las tablas permanentes.
    DECLARE @Documentos TABLE (
        documentoNombre VARCHAR(50), -- Nombre del documento.
        docTypeNombre VARCHAR(50)    -- Nombre del tipo de documento.
    );
    
    DECLARE @SegmentosDirigidos TABLE (
        segmentoNombre VARCHAR(50) -- Nombre del segmento dirigido.
    );
    
    DECLARE @SegmentosImpacto TABLE (
        segmentoNombre VARCHAR(50) -- Nombre del segmento de impacto.
    );
    
    -- =============================================
    -- SECCIÓN 1: VALIDACIONES PREVIAS Y OBTENCIÓN DE IDs (FUERA DE TRANSACCIÓN)
    -- =============================================
    -- Esta sección se ejecuta antes de iniciar la transacción principal. Su propósito es:
    -- 1. Obtener todos los IDs y datos de referencia necesarios.
    -- 2. Realizar validaciones de los parámetros de entrada y de la existencia de entidades relacionadas.
    -- Al hacer esto fuera de la transacción, se minimiza el tiempo de bloqueo de la transacción, mejorando el rendimiento.
    
    -- 1. OBTENER UN MEDIAFILEID VÁLIDO POR DEFECTO
    -- Se intenta obtener el ID de un archivo multimedia no eliminado para usarlo por defecto.
    SELECT TOP 1 @defaultMediaFileId = mediaFileId 
    FROM voto_MediaFiles 
    WHERE deleted = 0 
    ORDER BY mediaFileId;
    
    -- Si no se encuentra un archivo multimedia no eliminado, se toma cualquier mediaFileId existente.
    IF @defaultMediaFileId IS NULL
    BEGIN
        SELECT TOP 1 @defaultMediaFileId = mediaFileId 
        FROM voto_MediaFiles 
        ORDER BY mediaFileId;
    END
    
    -- 2. VALIDAR USUARIO
    -- Obtiene el ID y el nombre de usuario real del usuario que está creando/actualizando la propuesta.
    SELECT 
        @userId = userId, 
        @userName = username
    FROM voto_Users 
    WHERE username = @nombreUsuario;
    
    -- Si el usuario no es encontrado, se retorna un error.
    IF @userId IS NULL
    BEGIN
        SELECT -1 AS Resultado, 'Usuario no encontrado' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 3. VALIDAR TIPO DE PROPUESTA
    -- Obtiene el ID del tipo de propuesta basándose en el nombre proporcionado.
    SELECT @tipoPropuestaId = proposalTypeId 
    FROM voto_ProposalType 
    WHERE name = @tipoPropuestaNombre;
    
    -- Si el tipo de propuesta no es encontrado, se retorna un error.
    IF @tipoPropuestaId IS NULL
    BEGIN
        SELECT -2 AS Resultado, 'Tipo de propuesta no encontrado' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 4. VALIDAR INSTITUCIÓN (SI SE PROPORCIONÓ)
    -- Si se proporcionó un nombre de institución, se busca su ID.
    IF @institucionNombre IS NOT NULL
    BEGIN
        SELECT @institucionId = institucionId 
        FROM voto_Instituciones 
        WHERE nombre = @institucionNombre;
        
        -- Si la institución no es encontrada, se retorna un error.
        IF @institucionId IS NULL
        BEGIN
            SELECT -3 AS Resultado, 'Institución no encontrada' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END
    
    -- 5. VALIDAR ESTADO
    -- Obtiene el ID del nuevo estado al que se desea mover la propuesta.
    SELECT @nuevoEstadoId = estadoId 
    FROM voto_Estado 
    WHERE name = @nuevoEstadoNombre;
    
    -- Si el estado no es encontrado, se retorna un error.
    IF @nuevoEstadoId IS NULL
    BEGIN
        SELECT -4 AS Resultado, 'Estado no encontrado' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 6. VALIDAR PROPUESTA EXISTENTE (PARA DETERMINAR SI ES ACTUALIZACIÓN)
    -- Si se proporcionó un @propuestaTitulo, se intenta encontrar la propuesta existente y verificar si pertenece al usuario.
    IF @propuestaTitulo IS NOT NULL
    BEGIN
        SELECT 
            @propuestaId = propuestaId,
            @existePropuesta = 1 -- Se activa la bandera indicando que la propuesta existe.
        FROM voto_Propuestas 
        WHERE titulo = @propuestaTitulo AND userId = @userId;
        
        -- Si la propuesta no es encontrada o no pertenece al usuario, se retorna un error.
        IF @propuestaId IS NULL
        BEGIN
            SELECT -5 AS Resultado, 'Propuesta no encontrada o no pertenece al usuario' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END
    
    -- 7. PARSEAR Y VALIDAR DOCUMENTOS
    -- Intenta parsear el JSON de documentos y lo inserta en la tabla temporal @Documentos.
    BEGIN TRY
        INSERT INTO @Documentos
        SELECT 
            documentoNombre, 
            docTypeNombre
        FROM OPENJSON(@documentosJSON) -- Intenta un formato JSON directo de array de objetos.
        WITH (
            documentoNombre VARCHAR(50) '$.nombreDocumento',
            docTypeNombre VARCHAR(50) '$.tipoDocumento'
        );
    END TRY
    BEGIN CATCH
        -- Si el primer intento de parseo falla, intenta con un formato JSON anidado (ej. {"Documentos": [...]}).
        BEGIN TRY
            INSERT INTO @Documentos
            SELECT 
                documentoNombre, 
                docTypeNombre
            FROM OPENJSON(@documentosJSON, '$.Documentos') -- Intenta un formato JSON con un nodo raíz 'Documentos'.
            WITH (
                documentoNombre VARCHAR(50) '$.nombreDocumento',
                docTypeNombre VARCHAR(50) '$.tipoDocumento'
            );
        END TRY
        BEGIN CATCH
            -- Si ambos intentos de parseo fallan, se retorna un error de formato JSON.
            SELECT -6 AS Resultado, 'Formato incorrecto en documentos: ' + ERROR_MESSAGE() AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END CATCH
    END CATCH
    
    -- Validar que todos los tipos de documento especificados en el JSON existan en la tabla voto_DocTypes.
    IF EXISTS (
        SELECT 1 FROM @Documentos d
        LEFT JOIN voto_DocTypes dt ON dt.name = d.docTypeNombre
        WHERE dt.docTypeId IS NULL -- Si el LEFT JOIN no encuentra un docTypeId, significa que el tipo de documento no existe.
    )
    BEGIN
        SELECT -6 AS Resultado, 'Uno o más tipos de documento no existen' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 8. PARSEAR Y VALIDAR SEGMENTOS DIRIGIDOS
    -- Valida que la cadena JSON de segmentos dirigidos no sea nula, vacía o un array vacío.
    IF @segmentosDirigidosJSON IS NULL OR @segmentosDirigidosJSON = '' OR @segmentosDirigidosJSON = '[]'
    BEGIN
        SELECT -7 AS Resultado, 'Debe especificar al menos un segmento dirigido' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- Intenta parsear el JSON de segmentos dirigidos y lo inserta en la tabla temporal @SegmentosDirigidos.
    BEGIN TRY
        INSERT INTO @SegmentosDirigidos
        SELECT segmentoNombre
        FROM OPENJSON(@segmentosDirigidosJSON)
        WITH (
            segmentoNombre VARCHAR(50) '$.nombre' -- Extrae el valor de la clave 'nombre'.
        )
        WHERE NULLIF(segmentoNombre, '') IS NOT NULL; -- Asegura que el nombre del segmento no esté vacío.
        
        -- Si después de parsear, la tabla temporal está vacía, significa que no se proporcionaron segmentos válidos.
        IF NOT EXISTS (SELECT 1 FROM @SegmentosDirigidos)
        BEGIN
            SELECT -7 AS Resultado, 'Los segmentos dirigidos no pueden estar vacíos' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Si hay un error durante el parseo del JSON, se retorna un mensaje de error de formato.
        SELECT -9 AS Resultado, 'Formato incorrecto en segmentos dirigidos: ' + ERROR_MESSAGE() AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END CATCH
    
    -- 9. PARSEAR Y VALIDAR SEGMENTOS DE IMPACTO
    -- Valida que la cadena JSON de segmentos de impacto no sea nula, vacía o un array vacío.
    IF @segmentosImpactoJSON IS NULL OR @segmentosImpactoJSON = '' OR @segmentosImpactoJSON = '[]'
    BEGIN
        SELECT -8 AS Resultado, 'Debe especificar al menos un segmento de impacto' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- Intenta parsear el JSON de segmentos de impacto y lo inserta en la tabla temporal @SegmentosImpacto.
    BEGIN TRY
        INSERT INTO @SegmentosImpacto
        SELECT segmentoNombre
        FROM OPENJSON(@segmentosImpactoJSON)
        WITH (
            segmentoNombre VARCHAR(50) '$.nombre' -- Extrae el valor de la clave 'nombre'.
        )
        WHERE NULLIF(segmentoNombre, '') IS NOT NULL; -- Asegura que el nombre del segmento no esté vacío.
        
        -- Si después de parsear, la tabla temporal está vacía, se retorna un error.
        IF NOT EXISTS (SELECT 1 FROM @SegmentosImpacto)
        BEGIN
            SELECT -8 AS Resultado, 'Los segmentos de impacto no pueden estar vacíos' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        -- Si hay un error durante el parseo del JSON, se retorna un mensaje de error de formato.
        SELECT -9 AS Resultado, 'Formato incorrecto en segmentos de impacto: ' + ERROR_MESSAGE() AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END CATCH
    
    -- Pre-calcular el hash de contenido de la propuesta.
    -- Este hash se genera a partir de los campos principales de la propuesta para verificar su integridad o detectar cambios.
    SET @hashContenido = HASHBYTES('SHA2_256', 
        CONCAT(@titulo, @descripcion, @resumenEjecutivo, CAST(@fechaActual AS VARCHAR(50))));
    
    -- =============================================
    -- SECCIÓN 2: PROCESAMIENTO TRANSACCIONAL
    -- =============================================
    -- Esta sección contiene las operaciones de modificación de datos (INSERT/UPDATE/DELETE)
    -- y está encapsulada dentro de una transacción para garantizar atomicidad y consistencia.
    BEGIN TRY
        BEGIN TRANSACTION @transactionName; -- Inicia una transacción con un nombre específico.
        
        -- 1. CREACIÓN O ACTUALIZACIÓN DE PROPUESTA
        -- Decide si crear una nueva propuesta o actualizar una existente basándose en la bandera @existePropuesta.
        IF @existePropuesta = 0 -- Si la propuesta no existe, se procede a crearla.
        BEGIN
            INSERT INTO voto_Propuestas (
                titulo, descripcion, resumenEjecutivo, userId, 
                estadoId, fechaCreacion, proposalTypeId, institucionId,
                hashDocumentacion, hashContenido
            )
            VALUES (
                @titulo, @descripcion, @resumenEjecutivo, @userId,
                @nuevoEstadoId, @fechaActual, @tipoPropuestaId, @institucionId,
                NULL, @hashContenido -- hashDocumentacion se actualizará al final.
            );
            
            SET @propuestaId = SCOPE_IDENTITY(); -- Obtiene el ID de la propuesta recién insertada.
            SET @mensaje = 'Propuesta creada exitosamente'; -- Actualiza el mensaje de éxito.
        END
        ELSE -- Si la propuesta ya existe, se procede a actualizarla.
        BEGIN
            UPDATE voto_Propuestas
            SET 
                titulo = @titulo,
                descripcion = @descripcion,
                resumenEjecutivo = @resumenEjecutivo,
                estadoId = @nuevoEstadoId,
                hashContenido = @hashContenido,
                proposalTypeId = @tipoPropuestaId,
                institucionId = @institucionId
            WHERE propuestaId = @propuestaId; -- Actualiza la propuesta específica por su ID.
            
            SET @mensaje = 'Propuesta actualizada exitosamente'; -- Actualiza el mensaje de éxito.
        END
        
        -- 2. PROCESAMIENTO DE DOCUMENTOS
        -- Itera sobre la tabla temporal de documentos para insertarlos y asociarlos a la propuesta.
        DECLARE @docTypeId INT;
        DECLARE @documentoNombre VARCHAR(50);
        
        -- Declara un cursor para recorrer los documentos parseados del JSON.
        DECLARE doc_cursor CURSOR LOCAL FOR
        SELECT 
            d.documentoNombre, 
            dt.docTypeId
        FROM @Documentos d
        INNER JOIN voto_DocTypes dt ON dt.name = d.docTypeNombre; -- Asegura que solo se procesen tipos de documento válidos.
        
        OPEN doc_cursor; -- Abre el cursor.
        FETCH NEXT FROM doc_cursor INTO @documentoNombre, @docTypeId; -- Obtiene la primera fila.
        
        WHILE @@FETCH_STATUS = 0 -- Bucle para procesar cada documento.
        BEGIN
            -- Calcula un hash para cada documento individual.
            DECLARE @hashDocumento VARBINARY(150) = HASHBYTES('SHA2_256', 
                CONCAT(@documentoNombre, CAST(@fechaActual AS VARCHAR(50))));
            
            -- Inserta el registro del documento en la tabla maestra de documentos.
            INSERT INTO voto_Documents (
                nombreDocumento, 
                hashDocumento, 
                usuarioSubio,
                estadoId, 
                detalles, 
                lastUpdate, 
                docTypeId,
                version,
                mediaFileId
            )
            VALUES (
                @documentoNombre, 
                @hashDocumento, 
                @userId,
                1, -- Estado 1 (asumido como 'Activo' o 'Válido').
                'Documento de propuesta', 
                @fechaActual, 
                @docTypeId,
                '1.0',
                @defaultMediaFileId -- Usa el mediaFileId por defecto.
            );
            
            -- Asocia el documento recién creado a la propuesta en la tabla de relación.
            INSERT INTO voto_DocPropuesta (propuestaId, documentoId, enabled, fecha)
            VALUES (@propuestaId, SCOPE_IDENTITY(), 1, @fechaActual); -- SCOPE_IDENTITY() obtiene el ID del último INSERT (el documento).
            
            FETCH NEXT FROM doc_cursor INTO @documentoNombre, @docTypeId; -- Avanza a la siguiente fila.
        END
        
        CLOSE doc_cursor; -- Cierra el cursor.
        DEALLOCATE doc_cursor; -- Libera los recursos del cursor.
        
        -- 3. PROCESAMIENTO DE SEGMENTOS DIRIGIDOS
        -- Actualiza todos los segmentos dirigidos existentes para esta propuesta a 'inhabilitado' (enabled = 0).
        -- Esto permite reinsertar o habilitar solo los segmentos que vienen en el JSON actual.
        UPDATE voto_propuestaSegmentos 
        SET enabled = 0 
        WHERE propuestaId = @propuestaId;
        
        DECLARE @segmentoNombre VARCHAR(50);
        DECLARE @segmentoId INT;
        
        -- Declara un cursor para recorrer los segmentos dirigidos parseados del JSON.
        DECLARE seg_dirigidos_cursor CURSOR LOCAL FOR
        SELECT segmentoNombre FROM @SegmentosDirigidos;
        
        OPEN seg_dirigidos_cursor;
        FETCH NEXT FROM seg_dirigidos_cursor INTO @segmentoNombre;
        
        WHILE @@FETCH_STATUS = 0 -- Bucle para procesar cada segmento.
        BEGIN
            -- Intenta obtener el ID del segmento existente.
            SELECT @segmentoId = segmentoId 
            FROM voto_Segmentos 
            WHERE name = @segmentoNombre;
            
            -- Si el segmento no existe, se inserta como un nuevo segmento.
            IF @segmentoId IS NULL
            BEGIN
                INSERT INTO voto_Segmentos (name, description)
                VALUES (@segmentoNombre, 'Segmento creado automáticamente para propuesta');
                
                SET @segmentoId = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo segmento.
            END
            
            -- Verifica si ya existe una asociación entre la propuesta y este segmento.
            IF EXISTS (
                SELECT 1 FROM voto_propuestaSegmentos 
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId
            )
            BEGIN
                -- Si ya existe, se actualiza a 'habilitado' y se actualiza la fecha.
                UPDATE voto_propuestaSegmentos
                SET enabled = 1, fecha = @fechaActual
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId;
            END
            ELSE
            BEGIN
                -- Si no existe, se inserta una nueva asociación entre la propuesta y el segmento.
                INSERT INTO voto_propuestaSegmentos (segmentoId, propuestaId, fecha, enabled)
                VALUES (@segmentoId, @propuestaId, @fechaActual, 1);
            END
            
            FETCH NEXT FROM seg_dirigidos_cursor INTO @segmentoNombre; -- Avanza a la siguiente fila.
        END
        
        CLOSE seg_dirigidos_cursor;
        DEALLOCATE seg_dirigidos_cursor;
        
        -- 4. PROCESAMIENTO DE SEGMENTOS DE IMPACTO
        -- Deshabilita todas las asociaciones de segmentos de impacto existentes para esta propuesta.
        UPDATE voto_propuestaImpact 
        SET enabled = 0 
        WHERE propuestaId = @propuestaId;
        
        -- Declara un cursor para recorrer los segmentos de impacto parseados del JSON.
        DECLARE seg_impacto_cursor CURSOR LOCAL FOR
        SELECT segmentoNombre FROM @SegmentosImpacto;
        
        OPEN seg_impacto_cursor;
        FETCH NEXT FROM seg_impacto_cursor INTO @segmentoNombre;
        
        WHILE @@FETCH_STATUS = 0 -- Bucle para procesar cada segmento de impacto.
        BEGIN
            -- Intenta obtener el ID del segmento de impacto existente.
            SELECT @segmentoId = segmentoId 
            FROM voto_Segmentos 
            WHERE name = @segmentoNombre;
            
            -- Si el segmento no existe, se inserta como un nuevo segmento.
            IF @segmentoId IS NULL
            BEGIN
                INSERT INTO voto_Segmentos (name, description)
                VALUES (@segmentoNombre, 'Segmento de impacto creado automáticamente para propuesta');
                
                SET @segmentoId = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo segmento.
            END
            
            -- Verifica si ya existe una asociación entre la propuesta y este segmento de impacto.
            IF EXISTS (
                SELECT 1 FROM voto_propuestaImpact 
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId
            )
            BEGIN
                -- Si ya existe, se actualiza a 'habilitado' y se actualiza la fecha.
                UPDATE voto_propuestaImpact
                SET enabled = 1, fecha = @fechaActual
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId;
            END
            ELSE
            BEGIN
                -- Si no existe, se inserta una nueva asociación.
                INSERT INTO voto_propuestaImpact (segmentoId, propuestaId, fecha, enabled)
                VALUES (@segmentoId, @propuestaId, @fechaActual, 1);
            END
            
            FETCH NEXT FROM seg_impacto_cursor INTO @segmentoNombre; -- Avanza a la siguiente fila.
        END
        
        CLOSE seg_impacto_cursor;
        DEALLOCATE seg_impacto_cursor;
        
        -- 5. CÁLCULO HASH DOCUMENTACIÓN
        -- Calcula el hash final de la documentación de la propuesta.
        -- Este hash se genera concatenando los hashes de todos los documentos asociados a la propuesta.
        SELECT @hashDocumentacion = HASHBYTES('SHA2_256', 
            (SELECT CAST((
                SELECT hashDocumento 
                FROM voto_Documents d
                JOIN voto_DocPropuesta dp ON d.documentoId = dp.documentoId
                WHERE dp.propuestaId = @propuestaId AND dp.enabled = 1
                ORDER BY d.documentoId -- Asegura un orden consistente para el hash.
                FOR XML PATH('') -- Concatena los hashes de los documentos en un solo string XML.
            ) AS NVARCHAR(MAX)))); -- Se convierte a NVARCHAR(MAX) para manejar cadenas largas.
            
        -- Actualiza el hash de documentación en el registro principal de la propuesta.
        UPDATE voto_Propuestas
        SET hashDocumentacion = @hashDocumentacion
        WHERE propuestaId = @propuestaId;
        
        -- 6. AUDITORÍA (REGISTRO EN EL LOG)
        -- Inserta un registro en la tabla de logs para auditar la operación de creación o actualización de la propuesta.
        INSERT INTO voto_Log (
            description,    -- Descripción de la operación (creación o actualización).
            postTime,       -- Fecha y hora del registro.
            computer,       -- Nombre del equipo donde se ejecutó la operación.
            username,       -- Nombre de usuario que ejecutó la operación.
            reference1,     -- Referencia 1 (aquí, el ID de la propuesta).
            reference2,     -- Referencia 2 (aquí, el ID del usuario).
            checksum        -- Un hash para verificar la integridad del registro de log.
        )
        VALUES (
            CASE WHEN @existePropuesta = 0 THEN 'Creación de propuesta' ELSE 'Actualización de propuesta' END, -- Determina la descripción.
            @fechaActual,
            HOST_NAME(),    -- Obtiene el nombre del host.
            @userName,
            @propuestaId,
            @userId,
            HASHBYTES('SHA2_256', CONCAT(@propuestaId, @userId, @fechaActual)) -- Genera un hash para el log.
        );
        
        COMMIT TRANSACTION @transactionName; -- Confirma la transacción, haciendo permanentes todos los cambios.
        
        -- 7. RESULTADO FINAL
        -- Devuelve los resultados de la operación, incluyendo el estado, mensaje y IDs generados.
        SELECT 
            @resultado AS Resultado,
            @mensaje AS Mensaje,
            @propuestaId AS PropuestaId,
            @hashDocumentacion AS HashDocumentacion,
            @hashContenido AS HashContenido;
    END TRY
    BEGIN CATCH
        -- BLOQUE DE MANEJO DE ERRORES (CATCH)
        -- Este bloque se ejecuta si ocurre cualquier error SQL dentro del bloque TRY.
        
        IF @@TRANCOUNT > 0 -- Verifica si hay una transacción abierta.
            ROLLBACK TRANSACTION @transactionName; -- Si hay una transacción, la revierte para deshacer todos los cambios y mantener la integridad de los datos.
            
        -- Devuelve información detallada del error al llamador.
        SELECT 
            ERROR_NUMBER() AS Resultado,    -- Código de error de SQL Server.
            ERROR_MESSAGE() AS Mensaje,     -- Mensaje de error detallado de SQL Server.
            NULL AS PropuestaId,            -- Retorna NULL para IDs si la operación falló.
            NULL AS HashDocumentacion,
            NULL AS HashContenido;
    END CATCH
END

drop procedure [crearActualizarPropuesta];


--Creacion de nueva propuesta--
EXEC [dbo].[crearActualizarPropuesta]
    @titulo = 'Arreglos para el parque',
    @descripcion = 'Descripción detallada de la propuesta...',
    @resumenEjecutivo = 'Resumen ejecutivo de la propuesta...',
    @nombreUsuario = 'admin',
    @tipoPropuestaNombre = 'Proyecto Social',
    @institucionNombre = 'Fundación Pura Vida',
    @documentosJSON = '[
		{
			"nombreDocumento": "documento1.pdf",
			"tipoDocumento": "PDF"
		}
	]',
    @segmentosDirigidosJSON = '
		[
		{"nombre": "Jóvenes"},
		{"nombre": "Adultos"}
	]',
    @segmentosImpactoJSON = '
        [
		{"nombre": "Jóvenes"},
		{"nombre": "Adultos"}
	]',
    @nuevoEstadoNombre = 'Pendiente de validación';




--actualizacion de propuesta 
EXEC [dbo].[crearActualizarPropuesta]
    @propuestaTitulo = 'Arreglos para el parque',
    @titulo = 'Arreglos para la piscina',
    @descripcion = 'Descripción detallada de la propuesta...',
    @resumenEjecutivo = 'Resumen ejecutivo de la propuesta...',
    @nombreUsuario = 'admin',
    @tipoPropuestaNombre = 'Proyecto Social',
    @institucionNombre = 'Fundación Pura Vida',
    @documentosJSON = '[
		{
			"nombreDocumento": "documento1.pdf",
			"tipoDocumento": "PDF"
		}
	]',
    @segmentosDirigidosJSON = '
		[
		{"nombre": "Jóvenes"},
		{"nombre": "Adultos"}
	]',
    @segmentosImpactoJSON = '
        [
		{"nombre": "Jóvenes"},
		{"nombre": "Adultos"}
	]',
    @nuevoEstadoNombre = 'Pendiente de validación';


select * from voto_Propuestas
select * from voto_Documents
select * from voto_DocPropuesta
select * from voto_Segmentos 
select * from voto_propuestaSegmentos  
select * from voto_propuestaImpact  
select * from voto_Log  
