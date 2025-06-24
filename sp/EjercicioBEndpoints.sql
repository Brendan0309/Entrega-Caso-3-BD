ALTER PROCEDURE [dbo].[revisarPropuesta]
    -- Parámetros de entrada del procedimiento almacenado.
    -- Estos parámetros permiten identificar la propuesta y el revisor de manera segura, sin usar IDs directamente.
    @tituloPropuesta VARCHAR(100),  -- Título de la propuesta que se va a someter a revisión.
    @usernameRevisor VARCHAR(50),   -- Nombre de usuario del revisor que inicia el proceso.
    @mensajeSalida VARCHAR(500) OUTPUT -- Parámetro de salida que contendrá el mensaje de éxito o error del proceso.
AS
BEGIN
    -- Evita que SQL Server envíe mensajes de conteo de filas afectadas, lo que puede mejorar el rendimiento en aplicaciones cliente-servidor.
    SET NOCOUNT ON;
    
    /* =====================================================
        DECLARACIÓN DE VARIABLES
        Se declaran todas las variables locales necesarias para almacenar IDs, estados,
        contadores y otros datos temporales utilizados durante la ejecución del SP.
    ===================================================== */
    -- Variables para almacenar IDs clave de la base de datos.
    DECLARE @propuestaId INT,       -- Almacena el ID interno de la propuesta.
            @userIdRevisor INT,     -- Almacena el ID del usuario revisor.
            @tipoPropuestaId INT;   -- Almacena el ID del tipo de propuesta.
    
    -- Variables para gestionar los estados de la propuesta y del workflow.
    DECLARE @estadoActual VARCHAR(50),      -- Almacena el nombre del estado actual de la propuesta.
            @estadoEnRevisionId INT;        -- Almacena el ID del estado 'En revisión'.
    
    -- Variables de control del proceso y para la transacción.
    DECLARE @workflowCount INT = 0,         -- Contador para el número de workflows procesados.
            @cursorExists BIT = 0;          -- Bandera para indicar si el cursor de workflows fue abierto.
    DECLARE @transactionName VARCHAR(32) = 'revisarPropuesta'; -- Nombre para la transacción explícita.
    DECLARE @fechaActual DATETIME = GETDATE(); -- Almacena la fecha y hora actual al inicio del SP.
    
    -- Variables para la gestión de registros específicos (ej. bitácora).
    DECLARE @newBitacoraId INT,         -- Almacena el ID para un nuevo registro en la bitácora.
            @resultadoRandom BIT;       -- Variable para simular un resultado aleatorio de revisión (aprobado/rechazado).

    /* =====================================================
        OBTENER DATOS NECESARIOS (FUERA DE TRANSACCIÓN)
        Esta sección se encarga de recopilar todos los datos de referencia y IDs necesarios
        antes de iniciar el bloque de transacción principal. Esta práctica minimiza el tiempo
        que la transacción permanece abierta, reduciendo la contención de bloqueos y mejorando la concurrencia.
    ===================================================== */
    -- Obtiene la información principal de la propuesta (ID, tipo, y nombre del estado actual)
    -- en una sola consulta, buscando por el título de la propuesta.
    SELECT 
        @propuestaId = p.propuestaId,          -- Obtiene el ID numérico de la propuesta.
        @tipoPropuestaId = p.proposalTypeId,   -- Obtiene el ID del tipo de propuesta.
        @estadoActual = e.name,                -- Obtiene el nombre del estado actual de la propuesta.
        -- Subconsulta para obtener el ID del estado 'En revisión'.
        @estadoEnRevisionId = (SELECT estadoId FROM voto_Estado WHERE name = 'En revisión') 
    FROM voto_Propuestas p
    JOIN voto_Estado e ON p.estadoId = e.estadoId -- Une con la tabla de estados para obtener el nombre del estado.
    WHERE p.titulo = @tituloPropuesta;         -- Filtra por el título de la propuesta proporcionado.
    
    -- Obtiene el ID del usuario revisor buscando por su nombre de usuario.
    SELECT @userIdRevisor = userId 
    FROM voto_Users 
    WHERE username = @usernameRevisor; 
    
    /* =====================================================
        VALIDACIONES INICIALES
        Esta sección realiza validaciones críticas sobre los parámetros de entrada y los datos
        obtenidos antes de que se inicie cualquier operación de modificación de datos.
        Cualquier fallo aquí detendrá la ejecución del SP y devolverá un mensaje de error.
    ===================================================== */
    -- Validación 1: Verifica que la propuesta con el título dado exista en la base de datos.
    IF @propuestaId IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Propuesta no encontrada';
        RETURN;
    END
    
    -- Validación 2: Verifica que el usuario revisor especificado exista en la base de datos.
    IF @userIdRevisor IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Usuario no válido';
        RETURN;
    END
    
    -- Validación 3: Verifica que la propuesta esté en un estado válido para iniciar la revisión.
    -- Solo permite la revisión si el estado actual es 'Pendiente de validación' o ya está 'En revisión'.
    IF @estadoActual NOT IN ('Pendiente de validación', 'En revisión')
    BEGIN
        SET @mensajeSalida = 'Error: Estado no válido para revisión';
        RETURN;
    END
    
    -- Validación 4: Verifica que el estado 'En revisión' esté configurado en la tabla voto_Estado.
    -- Esto asegura que se pueda asignar este estado a la propuesta.
    IF @estadoEnRevisionId IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Estado "En revisión" no configurado';
        RETURN;
    END
    
    /* =====================================================
        OBTENER WORKFLOWS CONFIGURADOS
        Esta sección recupera la configuración de los workflows (flujos de trabajo)
        asociados al tipo específico de la propuesta que se va a revisar.
    ===================================================== */
    -- Tabla temporal para almacenar los detalles de los workflows que deben ejecutarse.
    DECLARE @Workflows TABLE (
        workflow_id INT,            -- ID del workflow.
        nombre VARCHAR(100),        -- Nombre descriptivo del workflow.
        orderIndex INT,             -- Orden en que este workflow debe ser ejecutado.
        configWork VARCHAR(1500)    -- Configuración específica en formato JSON o texto para este workflow.
    );
    
    -- Inserta en la tabla temporal @Workflows todos los workflows activos y habilitados
    -- que están configurados para el tipo de propuesta actual.
    INSERT INTO @Workflows
    SELECT 
        w.workflow_id,
        w.nombre,
        wtp.orderIndex,             -- El orden de ejecución se toma de la tabla de configuración.
        w.configWork                -- La configuración se toma directamente del registro del workflow.
    FROM voto_WorkTipoPropuesta wtp   -- Tabla que asocia tipos de propuesta con workflows.
    JOIN wk_workflow w ON wtp.workflowId = w.workflow_id -- Tabla maestra de workflows.
    WHERE wtp.tipoPropuestaId = @tipoPropuestaId -- Filtra por el tipo de propuesta actual.
    AND wtp.enabled = 1                         -- Solo considera asociaciones de workflow habilitadas.
    AND w.activo = 1                            -- Solo considera workflows que están marcados como activos.
    ORDER BY wtp.orderIndex;                    -- Ordena los workflows para ejecutarlos en la secuencia correcta.
    
    -- Validación: Verifica que al menos un workflow esté configurado para este tipo de propuesta.
    IF NOT EXISTS (SELECT 1 FROM @Workflows)
    BEGIN
        SET @mensajeSalida = 'Error: No hay workflows configurados para este tipo de propuesta. La revisión no puede continuar.';
        RETURN;
    END
    
    /* =====================================================
        INICIAR TRANSACCIÓN (OPERACIONES CRÍTICAS)
        Todas las operaciones de modificación de datos se envuelven en una transacción
        explícita para garantizar su atomicidad. Esto significa que si cualquier parte
        de este bloque falla, todos los cambios realizados desde BEGIN TRANSACTION
        serán revertidos (deshechos) para mantener la integridad de la base de datos.
    ===================================================== */
    BEGIN TRY
        -- Marca el inicio de la transacción atómica con un nombre para facilitar la gestión.
        BEGIN TRANSACTION @transactionName;
        
        /* -----------------------------------------------------
            1. ACTUALIZAR ESTADO DE LA PROPUESTA
            Se cambia el estado de la propuesta a 'En revisión' para indicar que ha comenzado el proceso.
        ----------------------------------------------------- */
        UPDATE voto_Propuestas
        SET estadoId = @estadoEnRevisionId -- Asigna el ID del estado 'En revisión'.
        WHERE propuestaId = @propuestaId;   -- Actualiza la propuesta específica.
        
        /* -----------------------------------------------------
            2. EJECUTAR WORKFLOWS EN ORDEN CONFIGURADO
            Se itera a través de los workflows recuperados y se registra su ejecución.
        ----------------------------------------------------- */
        -- Variables para almacenar los datos de cada workflow mientras el cursor itera.
        DECLARE @workflow_id INT, 
                @workflow_nombre VARCHAR(100), 
                @configWork VARCHAR(1500);
        DECLARE @run_id UNIQUEIDENTIFIER; -- Identificador único global (GUID) para cada ejecución de workflow.
        
        -- Crea un cursor para procesar cada workflow de la tabla temporal @Workflows en el orden definido.
        DECLARE workflow_cursor CURSOR LOCAL FOR
        SELECT workflow_id, nombre, configWork FROM @Workflows ORDER BY orderIndex;
        
        -- Abre el cursor para comenzar a procesar las filas.
        OPEN workflow_cursor;
        SET @cursorExists = 1; -- Establece la bandera para indicar que el cursor está abierto.
        -- Obtiene la primera fila de datos del cursor.
        FETCH NEXT FROM workflow_cursor INTO @workflow_id, @workflow_nombre, @configWork;
        
        -- Bucle WHILE para procesar cada workflow secuencialmente.
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Genera un identificador único para esta ejecución particular del workflow.
            SET @run_id = NEWID();
            
            -- Registra la ejecución de este workflow en la tabla 'wk_workflow_run'.
            -- Esto sirve para auditar cuándo y cómo se ejecutó cada paso del workflow.
            INSERT INTO wk_workflow_run (
                run_id,             -- El identificador único de esta ejecución.
                workflow_id,        -- El ID del workflow que se está ejecutando.
                estadoId,           -- El estado inicial de esta ejecución (1 = Pendiente).
                fecha_inicio,       -- La fecha y hora en que se inició esta ejecución.
                parametros          -- La configuración específica utilizada para esta ejecución del workflow.
            ) VALUES (
                @run_id,            
                @workflow_id,       
                1,                  -- Asumiendo que 1 es el ID para el estado 'Pendiente'.
                @fechaActual,       
                @configWork         -- Utiliza la configuración específica almacenada en el workflow.
            );
            
            -- Obtiene el próximo ID disponible para un nuevo registro en la bitácora del workflow.
            SELECT @newBitacoraId = ISNULL(MAX(bitacoraId), 0) + 1 FROM wk_bitacora;
            
            -- Registra un evento en la bitácora del workflow indicando el inicio de su ejecución.
            INSERT INTO wk_bitacora (
                bitacoraId,         -- El ID único para este registro de bitácora.
                wkLogTypeId,        -- El tipo de registro de log (1 = Inicio de Workflow).
                fecha,              -- La fecha y hora del evento.
                resultado,          -- Un mensaje descriptivo del evento.
                estadoId,           -- El estado asociado al registro (1 = Inicio/Pendiente).
                workflow_Id,        -- El ID del workflow al que se refiere este registro.
                parametros          -- Parámetros adicionales o contexto del evento (aquí, el ID de la propuesta).
            ) VALUES (
                @newBitacoraId,     
                1,                  -- Asumiendo que 1 es el ID para 'Inicio'.
                @fechaActual,
                'Ejecutado workflow: ' + @workflow_nombre, -- Mensaje que indica qué workflow se ejecutó.
                1,                  -- Asumiendo que 1 es el ID para el estado 'Inicio/Pendiente'.
                @workflow_id,       
                'PropuestaID: ' + CAST(@propuestaId AS VARCHAR) -- Concatena el ID de la propuesta como parámetro.
            );
            
            -- Incrementa el contador de workflows procesados.
            SET @workflowCount = @workflowCount + 1;
            
            -- Obtiene la siguiente fila de datos del cursor para la próxima iteración.
            FETCH NEXT FROM workflow_cursor INTO @workflow_id, @workflow_nombre, @configWork;
        END
        
        /* -----------------------------------------------------
            CERRAR CURSOR (BUENA PRÁCTICA)
            Asegura que el cursor se cierre y se desasigne para liberar recursos.
        ----------------------------------------------------- */
        IF @cursorExists = 1 -- Verifica si el cursor fue realmente abierto.
        BEGIN
            CLOSE workflow_cursor;      -- Cierra el cursor, liberando los bloqueos en las filas.
            DEALLOCATE workflow_cursor; -- Libera la memoria y los recursos asociados al cursor.
        END
        
        /* -----------------------------------------------------
            3. SIMULAR RESULTADO FINAL (80% APROBADO, 20% RECHAZADO)
            Esta sección simula un resultado de revisión, útil para entornos de desarrollo/prueba.
        ----------------------------------------------------- */
        -- Genera un resultado aleatorio: 1 (Aprobado) si el número aleatorio es <= 0.8 (80% de probabilidad), de lo contrario 0 (Rechazado).
        SET @resultadoRandom = CASE WHEN RAND() <= 0.8 THEN 1 ELSE 0 END;
        
        /* -----------------------------------------------------
            4. REGISTRAR EN LOG DEL SISTEMA
            Se registra un evento en la tabla de logs del sistema para auditar el proceso de revisión.
        ----------------------------------------------------- */
        INSERT INTO voto_Log (
            description,    -- Descripción del evento registrado.
            postTime,       -- Fecha y hora en que se registró el evento.
            computer,       -- Nombre del equipo donde se ejecutó el proceso.
            username,       -- Nombre del usuario que inició el proceso de revisión.
            trace,          -- Información de traza adicional (aquí, la configuración del tipo de propuesta).
            reference1,     -- Primera referencia (aquí, el ID de la propuesta).
            reference2,     -- Segunda referencia (aquí, el ID del usuario revisor).
            value1,         -- Valor adicional 1 (aquí, el tipo de propuesta).
            value2,         -- Valor adicional 2 (aquí, el resultado simulado de la revisión).
            checksum        -- Hash para asegurar la integridad del registro de log.
        ) VALUES (
            'Revisión iniciada | Workflows: ' + CAST(@workflowCount AS VARCHAR) + -- Descripción que incluye el número de workflows ejecutados.
            CASE WHEN @resultadoRandom = 1 THEN ' | Simulación: Aprobada' ELSE ' | Simulación: Rechazada' END, -- Añade el resultado simulado.
            @fechaActual,   -- Fecha y hora actual.
            HOST_NAME(),    -- Obtiene el nombre del equipo.
            @usernameRevisor, -- Nombre del usuario revisor.
            'Configuración: ' + CAST(@tipoPropuestaId AS VARCHAR), -- Traza con el tipo de propuesta.
            @propuestaId,   -- ID de la propuesta.
            @userIdRevisor, -- ID del usuario revisor.
            @tipoPropuestaId, -- Tipo de propuesta.
            @resultadoRandom, -- Resultado simulado.
            -- Genera un hash SHA2_256 para la integridad del registro de log.
            HASHBYTES('SHA2_256', CONVERT(VARCHAR(50), @propuestaId) + 
            CONVERT(VARCHAR(50), @userIdRevisor) + 
            CONVERT(VARCHAR(50), @fechaActual, 121))
        );
        
        -- Confirma la transacción. Si todas las operaciones dentro del bloque TRY fueron exitosas, los cambios se guardan permanentemente.
        COMMIT TRANSACTION @transactionName;
        
        -- Establece el mensaje de salida indicando que el proceso de revisión se inició correctamente.
        SET @mensajeSalida = 'Proceso de revisión iniciado correctamente';
    END TRY
    BEGIN CATCH
        /* =====================================================
            MANEJO DE ERRORES (CATCH BLOCK)
            Este bloque se ejecuta si ocurre cualquier error SQL dentro del bloque TRY.
            Su objetivo es capturar el error, revertir la transacción para mantener la integridad
            de los datos y registrar el error para la depuración y auditoría.
        ===================================================== */
        -- Obtiene el mensaje de error detallado generado por SQL Server.
        DECLARE @errorMsg VARCHAR(2000) = ERROR_MESSAGE();
        
        -- Cierra y desasigna el cursor si estaba abierto. Esto es crucial para liberar recursos en caso de un error.
        IF @cursorExists = 1 AND CURSOR_STATUS('global', 'workflow_cursor') >= 0
        BEGIN
            CLOSE workflow_cursor;
            DEALLOCATE workflow_cursor;
        END
        
        -- Revertir la transacción si está activa. Esto deshace todos los cambios realizados
        -- dentro del bloque TRY desde que se inició la transacción.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName;
            
        -- Establece el mensaje de salida para indicar el error, incluyendo el mensaje de error de SQL Server.
        SET @mensajeSalida = 'Error: ' + @errorMsg;
        
        -- Registra el error en la tabla 'wk_bitacora' del workflow.
        -- Esto permite un seguimiento de los fallos en el proceso de revisión.
        INSERT INTO wk_bitacora (
            bitacoraId,     -- El ID para este registro de bitácora (se genera el siguiente ID disponible).
            wkLogTypeId,    -- El tipo de registro de log (3 = Error).
            fecha,          -- La fecha y hora en que ocurrió el error.
            resultado,      -- Mensaje que describe el error.
            estadoId,       -- El estado asociado al registro (4 = Error).
            workflow_Id,    -- El ID del workflow que estaba en ejecución (si aplica, o 0 si el error fue antes de un workflow específico).
            parametros      -- Información adicional o contexto del error (aquí, el título de la propuesta).
        ) VALUES (
            (SELECT ISNULL(MAX(bitacoraId), 0) + 1 FROM wk_bitacora), -- Obtiene el siguiente ID de bitácora.
            3,                  -- Asumiendo que 3 es el ID para 'Error'.
            GETDATE(),          
            'Error en revisión: ' + @errorMsg, -- Mensaje de error detallado.
            4,                  -- Asumiendo que 4 es el ID para el estado 'Error'.
            ISNULL(@workflow_id, 0), -- Si @workflow_id es NULL (error antes de un workflow), usa 0.
            'Propuesta: ' + @tituloPropuesta -- Contexto de la propuesta donde ocurrió el error.
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
