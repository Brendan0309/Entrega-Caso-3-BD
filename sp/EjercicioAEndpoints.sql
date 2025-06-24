CREATE PROCEDURE [dbo].[crearActualizarPropuesta]
    @propuestaTitulo VARCHAR(100) = NULL,
    @titulo VARCHAR(100),
    @descripcion VARCHAR(1500),
    @resumenEjecutivo VARCHAR(1500),
    @nombreUsuario VARCHAR(100),
    @tipoPropuestaNombre VARCHAR(50),
    @institucionNombre VARCHAR(100) = NULL,
    @documentosJSON VARCHAR(1500),
    @segmentosDirigidosJSON VARCHAR(1500),
    @segmentosImpactoJSON VARCHAR(1500),
    @nuevoEstadoNombre VARCHAR(50) = 'Pendiente de validaci�n'
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Variables de control
    DECLARE @transactionName VARCHAR(32) = 'crearActualizarPropuesta';
    DECLARE @fechaActual DATETIME = GETDATE();
    DECLARE @hashDocumentacion VARBINARY(250);
    DECLARE @hashContenido VARBINARY(250);
    DECLARE @resultado INT = 0;
    DECLARE @mensaje VARCHAR(500) = 'Operaci�n exitosa';
    
    -- Variables para IDs
    DECLARE @propuestaId INT;
    DECLARE @userId INT;
    DECLARE @tipoPropuestaId INT;
    DECLARE @institucionId INT = NULL;
    DECLARE @nuevoEstadoId INT;
    DECLARE @userName VARCHAR(50);
    
    -- Variables para validaci�n previa
    DECLARE @docTypesValidos BIT = 1;
    DECLARE @existePropuesta BIT = 0;
    
    -- Variable para mediaFileId
    DECLARE @defaultMediaFileId INT;
    
    -- Tablas temporales
    DECLARE @Documentos TABLE (
        documentoNombre VARCHAR(50),
        docTypeNombre VARCHAR(50)
    );
    
    DECLARE @SegmentosDirigidos TABLE (
        segmentoNombre VARCHAR(50)
    );
    
    DECLARE @SegmentosImpacto TABLE (
        segmentoNombre VARCHAR(50)
    );
    
    -- =============================================
    -- SECCI�N 1: VALIDACIONES PREVIAS (FUERA DE TRANSACCI�N)
    -- =============================================
    
    -- 1. OBTENER UN MEDIAFILEID V�LIDO POR DEFECTO
    SELECT TOP 1 @defaultMediaFileId = mediaFileId 
    FROM voto_MediaFiles 
    WHERE deleted = 0 
    ORDER BY mediaFileId;
    
    IF @defaultMediaFileId IS NULL
    BEGIN
        SELECT TOP 1 @defaultMediaFileId = mediaFileId 
        FROM voto_MediaFiles 
        ORDER BY mediaFileId;
    END
    
    -- 2. VALIDAR USUARIO
    SELECT 
        @userId = userId, 
        @userName = username
    FROM voto_Users 
    WHERE username = @nombreUsuario;
    
    IF @userId IS NULL
    BEGIN
        SELECT -1 AS Resultado, 'Usuario no encontrado' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 3. VALIDAR TIPO DE PROPUESTA
    SELECT @tipoPropuestaId = proposalTypeId 
    FROM voto_ProposalType 
    WHERE name = @tipoPropuestaNombre;
    
    IF @tipoPropuestaId IS NULL
    BEGIN
        SELECT -2 AS Resultado, 'Tipo de propuesta no encontrado' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 4. VALIDAR INSTITUCI�N (SI SE PROPORCION�)
    IF @institucionNombre IS NOT NULL
    BEGIN
        SELECT @institucionId = institucionId 
        FROM voto_Instituciones 
        WHERE nombre = @institucionNombre;
        
        IF @institucionId IS NULL
        BEGIN
            SELECT -3 AS Resultado, 'Instituci�n no encontrada' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END
    
    -- 5. VALIDAR ESTADO
    SELECT @nuevoEstadoId = estadoId 
    FROM voto_Estado 
    WHERE name = @nuevoEstadoNombre;
    
    IF @nuevoEstadoId IS NULL
    BEGIN
        SELECT -4 AS Resultado, 'Estado no encontrado' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 6. VALIDAR PROPUESTA EXISTENTE (PARA ACTUALIZACI�N)
    IF @propuestaTitulo IS NOT NULL
    BEGIN
        SELECT 
            @propuestaId = propuestaId,
            @existePropuesta = 1
        FROM voto_Propuestas 
        WHERE titulo = @propuestaTitulo AND userId = @userId;
        
        IF @propuestaId IS NULL
        BEGIN
            SELECT -5 AS Resultado, 'Propuesta no encontrada o no pertenece al usuario' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END
    
    -- 7. PARSEAR Y VALIDAR DOCUMENTOS
    BEGIN TRY
        INSERT INTO @Documentos
        SELECT 
            documentoNombre, 
            docTypeNombre
        FROM OPENJSON(@documentosJSON)
        WITH (
            documentoNombre VARCHAR(50) '$.nombreDocumento',
            docTypeNombre VARCHAR(50) '$.tipoDocumento'
        );
    END TRY
    BEGIN CATCH
        BEGIN TRY
            INSERT INTO @Documentos
            SELECT 
                documentoNombre, 
                docTypeNombre
            FROM OPENJSON(@documentosJSON, '$.Documentos')
            WITH (
                documentoNombre VARCHAR(50) '$.nombreDocumento',
                docTypeNombre VARCHAR(50) '$.tipoDocumento'
            );
        END TRY
        BEGIN CATCH
            SELECT -6 AS Resultado, 'Formato incorrecto en documentos: ' + ERROR_MESSAGE() AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END CATCH
    END CATCH
    
    -- Validar tipos de documento
    IF EXISTS (
        SELECT 1 FROM @Documentos d
        LEFT JOIN voto_DocTypes dt ON dt.name = d.docTypeNombre
        WHERE dt.docTypeId IS NULL
    )
    BEGIN
        SELECT -6 AS Resultado, 'Uno o m�s tipos de documento no existen' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    -- 8. PARSEAR Y VALIDAR SEGMENTOS DIRIGIDOS
    IF @segmentosDirigidosJSON IS NULL OR @segmentosDirigidosJSON = '' OR @segmentosDirigidosJSON = '[]'
    BEGIN
        SELECT -7 AS Resultado, 'Debe especificar al menos un segmento dirigido' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    BEGIN TRY
        INSERT INTO @SegmentosDirigidos
        SELECT segmentoNombre
        FROM OPENJSON(@segmentosDirigidosJSON)
        WITH (
            segmentoNombre VARCHAR(50) '$.nombre'
        )
        WHERE NULLIF(segmentoNombre, '') IS NOT NULL;
        
        IF NOT EXISTS (SELECT 1 FROM @SegmentosDirigidos)
        BEGIN
            SELECT -7 AS Resultado, 'Los segmentos dirigidos no pueden estar vac�os' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        SELECT -9 AS Resultado, 'Formato incorrecto en segmentos dirigidos: ' + ERROR_MESSAGE() AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END CATCH
    
    -- 9. PARSEAR Y VALIDAR SEGMENTOS DE IMPACTO
    IF @segmentosImpactoJSON IS NULL OR @segmentosImpactoJSON = '' OR @segmentosImpactoJSON = '[]'
    BEGIN
        SELECT -8 AS Resultado, 'Debe especificar al menos un segmento de impacto' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END
    
    BEGIN TRY
        INSERT INTO @SegmentosImpacto
        SELECT segmentoNombre
        FROM OPENJSON(@segmentosImpactoJSON)
        WITH (
            segmentoNombre VARCHAR(50) '$.nombre'
        )
        WHERE NULLIF(segmentoNombre, '') IS NOT NULL;
        
        IF NOT EXISTS (SELECT 1 FROM @SegmentosImpacto)
        BEGIN
            SELECT -8 AS Resultado, 'Los segmentos de impacto no pueden estar vac�os' AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
            RETURN;
        END
    END TRY
    BEGIN CATCH
        SELECT -9 AS Resultado, 'Formato incorrecto en segmentos de impacto: ' + ERROR_MESSAGE() AS Mensaje, NULL AS PropuestaId, NULL AS HashDocumentacion, NULL AS HashContenido;
        RETURN;
    END CATCH
    
    -- Pre-calcular hash de contenido
    SET @hashContenido = HASHBYTES('SHA2_256', 
        CONCAT(@titulo, @descripcion, @resumenEjecutivo, CAST(@fechaActual AS VARCHAR(50))));
    
    -- =============================================
    -- SECCI�N 2: PROCESAMIENTO TRANSACCIONAL
    -- =============================================
    BEGIN TRY
        BEGIN TRANSACTION @transactionName;
        
        -- 1. CREACI�N O ACTUALIZACI�N DE PROPUESTA
        IF @existePropuesta = 0
        BEGIN
            INSERT INTO voto_Propuestas (
                titulo, descripcion, resumenEjecutivo, userId, 
                estadoId, fechaCreacion, proposalTypeId, institucionId,
                hashDocumentacion, hashContenido
            )
            VALUES (
                @titulo, @descripcion, @resumenEjecutivo, @userId,
                @nuevoEstadoId, @fechaActual, @tipoPropuestaId, @institucionId,
                NULL, @hashContenido
            );
            
            SET @propuestaId = SCOPE_IDENTITY();
            SET @mensaje = 'Propuesta creada exitosamente';
        END
        ELSE
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
            WHERE propuestaId = @propuestaId;
            
            SET @mensaje = 'Propuesta actualizada exitosamente';
        END
        
        -- 2. PROCESAMIENTO DE DOCUMENTOS
        DECLARE @docTypeId INT;
        DECLARE @documentoNombre VARCHAR(50);
        
        DECLARE doc_cursor CURSOR LOCAL FOR
        SELECT 
            d.documentoNombre, 
            dt.docTypeId
        FROM @Documentos d
        INNER JOIN voto_DocTypes dt ON dt.name = d.docTypeNombre;
        
        OPEN doc_cursor;
        FETCH NEXT FROM doc_cursor INTO @documentoNombre, @docTypeId;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @hashDocumento VARBINARY(150) = HASHBYTES('SHA2_256', 
                CONCAT(@documentoNombre, CAST(@fechaActual AS VARCHAR(50))));
            
            INSERT INTO voto_Documents (
                nombreDocumento, 
                hashDocumento, 
                usuarioSubio,
                estadoId, 
                detalles, 
                lastUpdate, 
                docTypeId,
                docTypesId,
                version,
                mediaFileId
            )
            VALUES (
                @documentoNombre, 
                @hashDocumento, 
                @userId,
                1, 
                'Documento de propuesta', 
                @fechaActual, 
                @docTypeId,
                @docTypeId,
                '1.0',
                @defaultMediaFileId
            );
            
            INSERT INTO voto_DocPropuesta (propuestaId, documentoId, enabled, fecha)
            VALUES (@propuestaId, SCOPE_IDENTITY(), 1, @fechaActual);
            
            FETCH NEXT FROM doc_cursor INTO @documentoNombre, @docTypeId;
        END
        
        CLOSE doc_cursor;
        DEALLOCATE doc_cursor;
        
        -- 3. PROCESAMIENTO DE SEGMENTOS DIRIGIDOS
        DECLARE @segmentoNombre VARCHAR(50);
        DECLARE @segmentoId INT;
        
        UPDATE voto_propuestaSegmentos 
        SET enabled = 0 
        WHERE propuestaId = @propuestaId;
        
        DECLARE seg_dirigidos_cursor CURSOR LOCAL FOR
        SELECT segmentoNombre FROM @SegmentosDirigidos;
        
        OPEN seg_dirigidos_cursor;
        FETCH NEXT FROM seg_dirigidos_cursor INTO @segmentoNombre;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @segmentoId = segmentoId 
            FROM voto_Segmentos 
            WHERE name = @segmentoNombre;
            
            IF @segmentoId IS NULL
            BEGIN
                INSERT INTO voto_Segmentos (name, description)
                VALUES (@segmentoNombre, 'Segmento creado autom�ticamente para propuesta');
                
                SET @segmentoId = SCOPE_IDENTITY();
            END
            
            IF EXISTS (
                SELECT 1 FROM voto_propuestaSegmentos 
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId
            )
            BEGIN
                UPDATE voto_propuestaSegmentos
                SET enabled = 1, fecha = @fechaActual
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId;
            END
            ELSE
            BEGIN
                INSERT INTO voto_propuestaSegmentos (segmentoId, propuestaId, fecha, enabled)
                VALUES (@segmentoId, @propuestaId, @fechaActual, 1);
            END
            
            FETCH NEXT FROM seg_dirigidos_cursor INTO @segmentoNombre;
        END
        
        CLOSE seg_dirigidos_cursor;
        DEALLOCATE seg_dirigidos_cursor;
        
        -- 4. PROCESAMIENTO DE SEGMENTOS DE IMPACTO
        UPDATE voto_propuestaImpact 
        SET enabled = 0 
        WHERE propuestaId = @propuestaId;
        
        DECLARE seg_impacto_cursor CURSOR LOCAL FOR
        SELECT segmentoNombre FROM @SegmentosImpacto;
        
        OPEN seg_impacto_cursor;
        FETCH NEXT FROM seg_impacto_cursor INTO @segmentoNombre;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @segmentoId = segmentoId 
            FROM voto_Segmentos 
            WHERE name = @segmentoNombre;
            
            IF @segmentoId IS NULL
            BEGIN
                INSERT INTO voto_Segmentos (name, description)
                VALUES (@segmentoNombre, 'Segmento de impacto creado autom�ticamente para propuesta');
                
                SET @segmentoId = SCOPE_IDENTITY();
            END
            
            IF EXISTS (
                SELECT 1 FROM voto_propuestaImpact 
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId
            )
            BEGIN
                UPDATE voto_propuestaImpact
                SET enabled = 1, fecha = @fechaActual
                WHERE propuestaId = @propuestaId AND segmentoId = @segmentoId;
            END
            ELSE
            BEGIN
                INSERT INTO voto_propuestaImpact (segmentoId, propuestaId, fecha, enabled)
                VALUES (@segmentoId, @propuestaId, @fechaActual, 1);
            END
            
            FETCH NEXT FROM seg_impacto_cursor INTO @segmentoNombre;
        END
        
        CLOSE seg_impacto_cursor;
        DEALLOCATE seg_impacto_cursor;
        
        -- 5. C�LCULO HASH DOCUMENTACI�N
        SELECT @hashDocumentacion = HASHBYTES('SHA2_256', 
            (SELECT CAST((
                SELECT hashDocumento 
                FROM voto_Documents d
                JOIN voto_DocPropuesta dp ON d.documentoId = dp.documentoId
                WHERE dp.propuestaId = @propuestaId AND dp.enabled = 1
                ORDER BY d.documentoId
                FOR XML PATH('')
            ) AS NVARCHAR(MAX))));
            
        UPDATE voto_Propuestas
        SET hashDocumentacion = @hashDocumentacion
        WHERE propuestaId = @propuestaId;
        
        -- 6. AUDITOR�A (CON logId COMO IDENTITY)
        INSERT INTO voto_Log (
            description, 
            postTime, 
            computer, 
            username, 
            reference1, 
            reference2, 
            checksum
        )
        VALUES (
            CASE WHEN @existePropuesta = 0 THEN 'Creaci�n de propuesta' ELSE 'Actualizaci�n de propuesta' END,
            @fechaActual,
            HOST_NAME(),
            @userName,
            @propuestaId,
            @userId,
            HASHBYTES('SHA2_256', CONCAT(@propuestaId, @userId, @fechaActual))
        );
        
        COMMIT TRANSACTION @transactionName;
        
        -- 7. RESULTADO FINAL
        SELECT 
            @resultado AS Resultado,
            @mensaje AS Mensaje,
            @propuestaId AS PropuestaId,
            @hashDocumentacion AS HashDocumentacion,
            @hashContenido AS HashContenido;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName;
            
        SELECT 
            ERROR_NUMBER() AS Resultado,
            ERROR_MESSAGE() AS Mensaje,
            NULL AS PropuestaId,
            NULL AS HashDocumentacion,
            NULL AS HashContenido;
    END CATCH
END

drop procedure [crearActualizarPropuesta];


--Creacion de nueva propuesta--
EXEC [dbo].[crearActualizarPropuesta]
    @titulo = 'Arreglos para el parque',
    @descripcion = 'Descripci�n detallada de la propuesta...',
    @resumenEjecutivo = 'Resumen ejecutivo de la propuesta...',
    @nombreUsuario = 'admin',
    @tipoPropuestaNombre = 'Proyecto Social',
    @institucionNombre = 'Fundaci�n Pura Vida',
    @documentosJSON = '[
		{
			"nombreDocumento": "documento1.pdf",
			"tipoDocumento": "PDF"
		}
	]',
    @segmentosDirigidosJSON = '
		[
		{"nombre": "J�venes"},
		{"nombre": "Adultos"}
	]',
    @segmentosImpactoJSON = '
        [
		{"nombre": "J�venes"},
		{"nombre": "Adultos"}
	]',
    @nuevoEstadoNombre = 'Pendiente de validaci�n';



SELECT * FROM voto_MediaFiles;

--actualizacion de propuesta 
EXEC [dbo].[crearActualizarPropuesta]
    @propuestaTitulo = 'Arreglos para el parque',
    @titulo = 'Arreglos para la piscina',
    @descripcion = 'Descripci�n detallada de la propuesta...',
    @resumenEjecutivo = 'Resumen ejecutivo de la propuesta...',
    @nombreUsuario = 'admin',
    @tipoPropuestaNombre = 'Proyecto Social',
    @institucionNombre = 'Fundaci�n Pura Vida',
    @documentosJSON = '[
		{
			"nombreDocumento": "documento1.pdf",
			"tipoDocumento": "PDF"
		}
	]',
    @segmentosDirigidosJSON = '
		[
		{"nombre": "J�venes"},
		{"nombre": "Adultos"}
	]',
    @segmentosImpactoJSON = '
        [
		{"nombre": "J�venes"},
		{"nombre": "Adultos"}
	]',
    @nuevoEstadoNombre = 'Pendiente de validaci�n';


select * from voto_Propuestas
select * from voto_Documents
select * from voto_DocPropuesta
select * from voto_Segmentos 
select * from voto_propuestaSegmentos  
select * from voto_propuestaImpact  
select * from voto_Log  
