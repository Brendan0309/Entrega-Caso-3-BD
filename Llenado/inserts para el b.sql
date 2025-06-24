-- Verificar si los permisos existen
-------Primero-------
SELECT * FROM voto_Permissions WHERE code IN ('REV_PROP', 'PUB_PROP');

-- Si no existen, crearlos (versi�n corregida)
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
-- Versi�n corregida para creaci�n de usuario
-- Versi�n definitiva para creaci�n de usuario
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

-- Verificaci�n de username
DECLARE @username VARCHAR(50) = (SELECT username FROM voto_Users WHERE userId = 2);
IF @username IS NULL OR @username = ''
BEGIN
    RAISERROR('No se pudo asignar username al usuario 2', 16, 1);
    RETURN;
END


----cuarto--
-- 1. Crear tipo de propuesta (solo con columnas existentes)
-- Versi�n corregida para tipos de votaci�n
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

-- Estados (versi�n corregida)
IF NOT EXISTS (SELECT 1 FROM voto_Estado WHERE name = 'Pendiente de validaci�n')
BEGIN
    INSERT INTO voto_Estado (estadoId, name, descripcion)
    VALUES (1, 'Pendiente de validaci�n', 'Propuesta pendiente de revisi�n');
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
(1, 'Validaci�n documental'),
(2, 'Revisi�n t�cnica'),
(3, 'Aprobaci�n institucional'),
(4, 'Publicaci�n autom�tica');

-- 2. Insertar workflows b�sicos
INSERT INTO wk_workflow ( nombre, descripcion, tipoid, version, activo, fecha_creacion, configWork, URL, enabled, lastupdate)
VALUES
( 'Validador Documental', 'Verifica documentos requeridos', 1, 1, 1, GETDATE(), 
 '{"parametros": ["docTypeId", "propuestaId"], "acciones": ["validar_completitud", "verificar_firmas"]}', 
 '/workflows/docval', 1, GETDATE()),
 
('Revisor T�cnico', 'Analiza viabilidad t�cnica', 2, 1, 1, GETDATE(), 
 '{"parametros": ["propuestaId", "userId"], "acciones": ["evaluar_viabilidad", "generar_recomendaciones"]}', 
 '/workflows/techrev', 1, GETDATE()),
 
('Aprobador Institucional', 'Valida desde perspectiva institucional', 3, 1, 1, GETDATE(), 
 '{"parametros": ["institucionId", "propuestaId"], "acciones": ["validar_alineacion", "confirmar_aprobacion"]}', 
 '/workflows/instapp', 1, GETDATE());


-- 3. Insertar relaci�n entre tipos de propuesta y workflows
-- (Asumiendo que existen tipos de propuesta con IDs 1, 2 y 3 en voto_ProposalType)
INSERT INTO voto_WorkTipoPropuesta (tipoPropuestaId, workflowId, enabled, orderIndex)
VALUES
(1, 1, 1, 1),  -- Tipo 1: Primero validaci�n documental
(1, 2, 1, 2),  -- Tipo 1: Luego revisi�n t�cnica
(2, 1, 1, 1),  -- Tipo 2: Validaci�n documental
(2, 3, 1, 2),  -- Tipo 2: Aprobaci�n institucional
(3, 1, 1, 1),  -- Tipo 3: Validaci�n documental
(3, 2, 1, 2),  -- Tipo 3: Revisi�n t�cnica
(3, 3, 1, 3),  -- Tipo 3: Aprobaci�n institucional
(3, 3, 1, 4);  -- Tipo 3: Publicaci�n autom�tica

-- 4. Insertar tipos de par�metros para workflows
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
(4, 'Advertencia', 'Advertencia en ejecuci�n', 1);

-- 6. Crear algunos datos de prueba para propuestas (si no existen)
-- Primero asegurar que exista al menos un estado
IF NOT EXISTS (SELECT 1 FROM voto_Estado WHERE estadoId = 1)
    INSERT INTO voto_Estado (estadoId, name) VALUES (1, 'Pendiente de validaci�n');


sELECT * FROM voto_Instituciones

sELECT * FROM voto_adresses

select * from voto_Users

select * from voto_Countries
