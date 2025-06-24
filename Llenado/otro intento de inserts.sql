-- 0. Tablas de países (requerida para Languages)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Countries])
BEGIN
    INSERT INTO [dbo].[voto_Countries] ([countryId], [name])
    VALUES 
    (1, 'Costa Rica'),
    (2, 'Estados Unidos');
END

-- 1. Tablas maestras básicas sin dependencias
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Estado] WHERE [estadoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Estado] ( [name], [descripcion])
    VALUES 
    ( 'Pendiente de validación', 'Propuesta creada pero no validada'),
    ( 'Validada', 'Propuesta validada por el sistema'),
    ( 'Rechazada', 'Propuesta rechazada en validación'),
    ( 'Publicada', 'Propuesta publicada para votación'),
    ( 'Cerrada', 'Propuesta cerrada'),
    ( 'Archivada', 'Propuesta archivada');
END



-- EstadoDoc (requerido para Documents)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_EstadoDoc] WHERE [estadoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_EstadoDoc] ([estadoId], [nombre], [descripcion])
    VALUES 
    (1, 'Pendiente', 'Documento pendiente de revisión'),
    (2, 'Aprobado', 'Documento aprobado'),
    (3, 'Rechazado', 'Documento rechazado');
END

-- EstadoUser (requerido para SignUp)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_EstadoUser] WHERE [estadoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_EstadoUser] ([estadoId], [name], [descripcion])
    VALUES 
    (1, 'Activo', 'Usuario activo'),
    (2, 'Inactivo', 'Usuario inactivo'),
    (3, 'Bloqueado', 'Usuario bloqueado'),
    (4, 'Pendiente', 'Usuario pendiente de activación');
END

-- 2. Tablas de tipos y categorías
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_TipoUser] WHERE [tipoUserId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_TipoUser] ( [nombre], [descripcion])
    VALUES 
    ( 'Administrador', 'Usuario con todos los permisos'),
    ('Creador', 'Usuario que puede crear propuestas'),
    ( 'Validador', 'Usuario que valida propuestas'),
    ( 'Inversionista', 'Usuario que invierte en propuestas'),
    ( 'Ciudadano', 'Usuario que vota en propuestas');
END

-- Tipos de documento
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_DocTypes] WHERE [docTypeId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_DocTypes] ([docTypeId], [name], [descripcion])
    VALUES 
    (1, 'PDF', 'Documento en formato PDF'),
    (2, 'Word', 'Documento de Microsoft Word'),
    (3, 'Excel', 'Hoja de cálculo Excel'),
    (4, 'Presentación', 'Presentación PowerPoint'),
    (5, 'Imagen', 'Documento de imagen'),
    (6, 'Video', 'Archivo de video');
END

-- Tipos de propuesta
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_ProposalType] WHERE [proposalTypeId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_ProposalType] ([proposalTypeId], [name], [detalles])
    VALUES 
    (1, 'Proyecto Social', 'Iniciativas de impacto social'),
    (2, 'Proyecto Educativo', 'Iniciativas en educación'),
    (3, 'Proyecto Ambiental', 'Iniciativas ecológicas'),
    (4, 'Proyecto Tecnológico', 'Iniciativas tecnológicas');
END

-- Relación entre tipos de propuesta y documentos
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_DocTypesPerProposalTypes] WHERE [docTypesProposalId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_DocTypesPerProposalTypes] ([docTypesProposalId], [proposalTypeId], [documentTypeId], [fecha], [enabled])
    VALUES 
    (1, 1, 1, GETDATE(), 1),  -- Proyecto Social requiere PDF
    (2, 1, 2, GETDATE(), 1),  -- Proyecto Social requiere Word
    (3, 2, 1, GETDATE(), 1),  -- Proyecto Educativo requiere PDF
    (4, 3, 1, GETDATE(), 1),  -- Proyecto Ambiental requiere PDF
    (5, 3, 5, GETDATE(), 1),  -- Proyecto Ambiental requiere Imagen
    (6, 4, 1, GETDATE(), 1),  -- Proyecto Tecnológico requiere PDF
    (7, 4, 6, GETDATE(), 1);  -- Proyecto Tecnológico requiere Video
END

-- 3. Tablas de soporte para usuarios
-- Lenguajes (requerido para Modules)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Languages] WHERE [languageId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Languages] ([languageId], [name], [culture], [countryId])
    VALUES 
    (1, 'Español', 'es-CR', 1),
    (2, 'Inglés', 'en-US', 2);
END

-- Módulos
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Modules] WHERE [moduleId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Modules] ([moduleId], [name], [languajeId])
    VALUES 
    (1, 'Propuestas', 1),
    (2, 'Usuarios', 1),
    (3, 'Votaciones', 1);
END

-- Tipos de medios (requerido para MediaFiles)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_MediaTypes] WHERE [mediaTypeId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_MediaTypes] ([mediaTypeId], [name], [playerImp])
    VALUES 
    (1, 'PDF', 'AdobeReader'),
    (2, 'Word', 'MSWord'),
    (3, 'Excel', 'MSExcel'),
    (4, 'PowerPoint', 'MSPowerPoint'),
    (5, 'Imagen', 'ImageViewer'),
    (6, 'Video', 'VideoPlayer');
END

-- Dispositivos (requerido para SignUp)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Dispositivos] WHERE [dispositivoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Dispositivos] ( [modelo], [descripcion], [fechaRegistro], [hashContenido], [llavePrivada])
    VALUES 
    ( 'PC-Admin', 'Computadora administrativa', GETDATE(), HASHBYTES('SHA2_256', 'dispositivo1'), 0x01);
END

-- Encriptación/Desencriptación (requerido para compartición)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Encriptacion] WHERE [encriptedId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Encriptacion] ([encriptedId], [publicEncripted], [privateEncrited], [fecha], [enabled])
    VALUES (1, 0x01, 0x01, GETDATE(), 1);
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Desencriptacion] WHERE [desencriptionId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Desencriptacion] ([desencriptionId], [publicDesencripted], [privateDesencripted], [fecha], [enabled])
    VALUES (1, 0x01, 0x01, GETDATE(), 1);
END

-- 4. Tablas de usuarios y permisos
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_comparticion] WHERE [comparticionId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_comparticion] ([comparticionId], [encriptedId], [desencriptedId], [enabled])
    VALUES (1, 1, 1, 1);
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_SignUp] WHERE [signUpid] = 1)
BEGIN
    INSERT INTO [dbo].[voto_SignUp] ( [username], [contrasena], [dispositivoId], [fechaRegistro], [estadoId])
    VALUES ( 'admin', HASHBYTES('SHA2_256', 'tempPassword'), 1, GETDATE(), 1);
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Users] WHERE [userId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Users] (
         [username], [contrasena], [enabled], [fechaUltimaAutenticacion], 
        [nivelSeguridad], [requiereRevalidacion], [fechaExpiracionCuenta], 
        [fechaExpiracionCredenciales], [cuentaBloqueada], [ultimoCambioCredenciales], 
        [tipoUserId], [signUpId], [comparticionId]
    )
    VALUES (
         'admin', HASHBYTES('SHA2_256', 'adminPassword'), 1, NULL,
        3, 0, DATEADD(YEAR, 1, GETDATE()), 
        DATEADD(MONTH, 3, GETDATE()), 0, GETDATE(),
        1, 1, 1
    );
END

-- Permisos
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Permissions] WHERE [permissionId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Permissions] ([permissionId], [description], [code], [moduleId])
    VALUES 
    (1, 'Crear propuestas', 'CREA_PROP', 1),
    (2, 'Editar propuestas', 'EDIT_PROP', 1),
    (3, 'Eliminar propuestas', 'DEL_PROP', 1),
    (4, 'Validar propuestas', 'VAL_PROP', 1),
    (5, 'Publicar propuestas', 'PUB_PROP', 1);
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_UserPermissions] WHERE [userPermissionId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_UserPermissions] (
        [userPermissionId], [enabled], [deleted], [lastUpdate], 
        [username], [checksum], [permissionId], [userId]
    )
    VALUES 
    (1, 1, 0, GETDATE(), 'admin', HASHBYTES('SHA2_256', '1'), 1, 1),
    (2, 1, 0, GETDATE(), 'admin', HASHBYTES('SHA2_256', '2'), 2, 1),
    (3, 1, 0, GETDATE(), 'admin', HASHBYTES('SHA2_256', '3'), 3, 1),
    (4, 1, 0, GETDATE(), 'admin', HASHBYTES('SHA2_256', '4'), 4, 1),
    (5, 1, 0, GETDATE(), 'admin', HASHBYTES('SHA2_256', '5'), 5, 1);
END

-- 5. Segmentos poblacionales
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Segmentos] WHERE [segmentoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Segmentos] ([segmentoId], [name], [description])
    VALUES 
    (1, 'Jóvenes', 'Personas entre 18-25 años'),
    (2, 'Adultos', 'Personas entre 26-60 años'),
    (3, 'Adultos mayores', 'Personas mayores de 60 años'),
    (4, 'Mujeres', 'Población femenina'),
    (5, 'Hombres', 'Población masculina'),
    (6, 'Zona urbana', 'Población en áreas urbanas'),
    (7, 'Zona rural', 'Población en áreas rurales');
END

-- 6. MediaFiles (requerido para Documents)
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_MediaFiles] WHERE [mediaFileId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_MediaFiles] ([mediaFileId], [url], [deleted], [reference], [generationDate], [mediaTypeId], [version])
    VALUES 
    (1, '/documents/doc1.pdf', 0, 'doc1', GETDATE(), 1, '1.0'),
    (2, '/documents/anexo.docx', 0, 'doc2', GETDATE(), 2, '1.0');
END

-- 7. Finalmente, los datos de propuestas
-- Insertar documentos primero
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Documents] WHERE [documentoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Documents] (
         [nombreDocumento], [hashDocumento], [usuarioSubio],
        [estadoId], [detalles], [lastUpdate], [docTypesId], [version],
        [docTypeId], [mediaFileId]
    )
    VALUES 
    ( 'Documento1.pdf', HASHBYTES('SHA2_256', 'doc1'), 1, 
    1, 'Documento principal', GETDATE(), 1, '1.0', 1, 1),
    ( 'Anexo.docx', HASHBYTES('SHA2_256', 'doc2'), 1, 
    1, 'Documento complementario', GETDATE(), 2, '1.0', 2, 2);
END

-- Insertar la propuesta
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_Propuestas] WHERE [propuestaId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_Propuestas] (
         [titulo], [descripcion], [resumenEjecutivo], 
        [userId], [estadoId], [fechaCreacion], [proposalTypeId], 
        [institucionId], [hashDocumentacion], [hashContenido]
    )
    VALUES (
         'Proyecto de reciclaje comunitario', 
        'Iniciativa para implementar puntos de reciclaje en la comunidad', 
        'Reducir residuos mediante puntos de reciclaje accesibles',
        1, 1, GETDATE(), 3, NULL, 
        HASHBYTES('SHA2_256', 'doc1doc2'), 
        HASHBYTES('SHA2_256', 'Proyecto de reciclaje comunitario')
    );
END

-- Relacionar documentos con la propuesta
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_DocPropuesta] WHERE [propuestaId] = 1 AND [documentoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_DocPropuesta] ([propuestaId], [documentoId], [enabled], [fecha])
    VALUES 
    (1, 1, 1, GETDATE()),
    (1, 2, 1, GETDATE());
END

-- Asignar segmentos poblacionales
IF NOT EXISTS (SELECT 1 FROM [dbo].[voto_propuestaSegmentos] WHERE [propuestaId] = 1 AND [segmentoId] = 1)
BEGIN
    INSERT INTO [dbo].[voto_propuestaSegmentos] ([segmentoId], [propuestaId], [fecha], [enabled])
    VALUES 
    (1, 1, GETDATE(), 1), -- Jóvenes
    (2, 1, GETDATE(), 1), -- Adultos
    (6, 1, GETDATE(), 1); -- Zona urbana
END