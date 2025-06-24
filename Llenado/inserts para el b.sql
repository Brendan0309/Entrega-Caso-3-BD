-- Verificar si los permisos existen
-------Primero-------
SELECT * FROM voto_Permissions WHERE code IN ('REV_PROP', 'PUB_PROP');

-- Si no existen, crearlos (versión corregida)
IF NOT EXISTS (SELECT 1 FROM voto_Permissions WHERE code = 'REV_PROP')
BEGIN
    INSERT INTO voto_Permissions (permissionId, code, description, moduleId)
    VALUES ((SELECT ISNULL(MAX(permissionId), 0) + 1 FROM voto_Permissions), 
           'REV_PROP', 
           'Permiso para revisar propuestas',
           1); -- Asumiendo que moduleId 1 existe
END

IF NOT EXISTS (SELECT 1 FROM voto_Permissions WHERE code = 'PUB_PROP')
BEGIN
    INSERT INTO voto_Permissions (permissionId, code, description, moduleId)
    VALUES ((SELECT ISNULL(MAX(permissionId), 0) + 1 FROM voto_Permissions), 
           'PUB_PROP', 
           'Permiso para publicar propuestas',
           1); -- Asumiendo que moduleId 1 existe
END




-----Segundo----
-- Versión corregida para creación de usuario
-- Versión definitiva para creación de usuario
IF NOT EXISTS (SELECT 1 FROM voto_Users WHERE userId = 2)
BEGIN
    -- Obtener valores para columnas requeridas
    DECLARE @comparticionId INT = ISNULL((SELECT TOP 1 comparticionId FROM voto_Comparticion ORDER BY comparticionId), 1);
    DECLARE @signUpId INT = ISNULL((SELECT TOP 1 signUpId FROM voto_SignUp ORDER BY signUpId), 1);
    
    INSERT INTO voto_Users (
         username, contrasena, enabled,
        nivelSeguridad, tipoUserId, cuentaBloqueada, 
        ultimoCambioCredenciales, comparticionId, signUpId
    )
    VALUES (
        'revisor_test', HASHBYTES('SHA2_256', 'temp123'), 
        1, -- enabled
        1, -- nivelSeguridad
        1, -- tipoUserId
        0, -- cuentaBloqueada
        GETDATE(), -- ultimoCambioCredenciales
        @comparticionId, -- comparticionId
        @signUpId -- signUpId
    );
END
ELSE
BEGIN
    UPDATE voto_Users 
    SET username = 'revisor_test'
    WHERE userId = 2 AND (username IS NULL OR username = '');
END

-- Verificación de username
DECLARE @username VARCHAR(50) = (SELECT username FROM voto_Users WHERE userId = 2);
IF @username IS NULL OR @username = ''
BEGIN
    RAISERROR('No se pudo asignar username al usuario 2', 16, 1);
    RETURN;
END


----cuarto--
-- 1. Crear tipo de propuesta (solo con columnas existentes)
-- Versión corregida para tipos de votación
IF NOT EXISTS (SELECT 1 FROM voto_TiposVotacion WHERE tipoVotacionId = 1)
BEGIN
    -- Verificar si la columna se llama 'description' o 'descripcion'
    IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('voto_TiposVotacion') AND name = 'descripcion')
    BEGIN
        INSERT INTO voto_TiposVotacion (tipoVotacionId, nombre, descripcion)
        VALUES (1, 'General', 'Propuesta general');
    END
    ELSE IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('voto_TiposVotacion') AND name = 'descripcion')
    BEGIN
        INSERT INTO voto_TiposVotacion (tipoVotacionId, nombre, descripcion)
        VALUES (1, 'General', 'Propuesta general');
    END
    ELSE
    BEGIN
        INSERT INTO voto_TiposVotacion (tipoVotacionId, nombre)
        VALUES (1, 'General');
    END
END

-- Estados (versión corregida)
IF NOT EXISTS (SELECT 1 FROM voto_Estado WHERE name = 'Pendiente de validación')
BEGIN
    INSERT INTO voto_Estado (estadoId, name, descripcion)
    VALUES (1, 'Pendiente de validación', 'Propuesta pendiente de revisión');
END

IF NOT EXISTS (SELECT 1 FROM voto_Estado WHERE name = 'Publicada')
BEGIN
    INSERT INTO voto_Estado (estadoId, name, descripcion)
    VALUES (2, 'Publicada', 'Propuesta publicada');
END

IF NOT EXISTS (SELECT 1 FROM voto_Estado WHERE name = 'Rechazada')
BEGIN
    INSERT INTO voto_Estado (estadoId, name, descripcion)
    VALUES (3, 'Rechazada', 'Propuesta rechazada');
END



-- 1. Insertar tipos de workflow
INSERT INTO wk_workflow_tipo (tipoid, descripcion)
VALUES 
(1, 'Validación documental'),
(2, 'Revisión técnica'),
(3, 'Aprobación institucional'),
(4, 'Publicación automática');

-- 2. Insertar workflows básicos
INSERT INTO wk_workflow ( nombre, descripcion, tipoid, version, activo, fecha_creacion, configWork, URL, enabled, lastupdate)
VALUES
( 'Validador Documental', 'Verifica documentos requeridos', 1, 1, 1, GETDATE(), 
 '{"parametros": ["docTypeId", "propuestaId"], "acciones": ["validar_completitud", "verificar_firmas"]}', 
 '/workflows/docval', 1, GETDATE()),
 
('Revisor Técnico', 'Analiza viabilidad técnica', 2, 1, 1, GETDATE(), 
 '{"parametros": ["propuestaId", "userId"], "acciones": ["evaluar_viabilidad", "generar_recomendaciones"]}', 
 '/workflows/techrev', 1, GETDATE()),
 
('Aprobador Institucional', 'Valida desde perspectiva institucional', 3, 1, 1, GETDATE(), 
 '{"parametros": ["institucionId", "propuestaId"], "acciones": ["validar_alineacion", "confirmar_aprobacion"]}', 
 '/workflows/instapp', 1, GETDATE());


-- 3. Insertar relación entre tipos de propuesta y workflows
-- (Asumiendo que existen tipos de propuesta con IDs 1, 2 y 3 en voto_ProposalType)
INSERT INTO voto_WorkTipoPropuesta (tipoPropuestaId, workflowId, enabled, orderIndex)
VALUES
(1, 1, 1, 1),  -- Tipo 1: Primero validación documental
(1, 2, 1, 2),  -- Tipo 1: Luego revisión técnica
(2, 1, 1, 1),  -- Tipo 2: Validación documental
(2, 3, 1, 2),  -- Tipo 2: Aprobación institucional
(3, 1, 1, 1),  -- Tipo 3: Validación documental
(3, 2, 1, 2),  -- Tipo 3: Revisión técnica
(3, 3, 1, 3),  -- Tipo 3: Aprobación institucional
(3, 3, 1, 4);  -- Tipo 3: Publicación automática

-- 4. Insertar tipos de parámetros para workflows
INSERT INTO wk_step_param ( nombre, tipo_dato, requerido, valor_defecto)
VALUES
( 'propuestaId', 'int', 1, NULL),
( 'userId', 'int', 1, NULL),
( 'docTypeId', 'int', 0, NULL),
( 'institucionId', 'int', 0, NULL),
( 'nivelUrgencia', 'string', 0, 'normal');

-- 5. Insertar tipos de log
INSERT INTO wk_LogType (wkLogTypeId, name, description, enabled)
VALUES
(1, 'Inicio', 'Inicio de workflow', 1),
(2, 'Completado', 'Workflow completado', 1),
(3, 'Error', 'Error en workflow', 1),
(4, 'Advertencia', 'Advertencia en ejecución', 1);

-- 6. Crear algunos datos de prueba para propuestas (si no existen)
-- Primero asegurar que exista al menos un estado
IF NOT EXISTS (SELECT 1 FROM voto_Estado WHERE estadoId = 1)
    INSERT INTO voto_Estado (estadoId, name) VALUES (1, 'Pendiente de validación');


sELECT * FROM voto_Instituciones

sELECT * FROM voto_adresses

select * from voto_Users

select * from voto_Countries
