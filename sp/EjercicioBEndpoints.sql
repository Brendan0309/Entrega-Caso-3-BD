ALTER PROCEDURE [dbo].[revisarPropuesta]
    -- Par�metros de entrada del procedimiento almacenado.
    -- Estos par�metros permiten identificar la propuesta y el revisor de manera segura, sin usar IDs directamente.
    @tituloPropuesta VARCHAR(100),  -- T�tulo de la propuesta que se va a someter a revisi�n.
    @usernameRevisor VARCHAR(50),   -- Nombre de usuario del revisor que inicia el proceso.
    @mensajeSalida VARCHAR(500) OUTPUT -- Par�metro de salida que contendr� el mensaje de �xito o error del proceso.
AS
BEGIN
    -- Evita que SQL Server env�e mensajes de conteo de filas afectadas, lo que puede mejorar el rendimiento en aplicaciones cliente-servidor.
    SET NOCOUNT ON;
    
    /* =====================================================
        DECLARACI�N DE VARIABLES
        Se declaran todas las variables locales necesarias para almacenar IDs, estados,
        contadores y otros datos temporales utilizados durante la ejecuci�n del SP.
    ===================================================== */
    -- Variables para almacenar IDs clave de la base de datos.
    DECLARE @propuestaId INT,       -- Almacena el ID interno de la propuesta.
            @userIdRevisor INT,     -- Almacena el ID del usuario revisor.
            @tipoPropuestaId INT;   -- Almacena el ID del tipo de propuesta.
    
    -- Variables para gestionar los estados de la propuesta y del workflow.
    DECLARE @estadoActual VARCHAR(50),      -- Almacena el nombre del estado actual de la propuesta.
            @estadoEnRevisionId INT;        -- Almacena el ID del estado 'En revisi�n'.
    
    -- Variables de control del proceso y para la transacci�n.
    DECLARE @workflowCount INT = 0,         -- Contador para el n�mero de workflows procesados.
            @cursorExists BIT = 0;          -- Bandera para indicar si el cursor de workflows fue abierto.
    DECLARE @transactionName VARCHAR(32) = 'revisarPropuesta'; -- Nombre para la transacci�n expl�cita.
    DECLARE @fechaActual DATETIME = GETDATE(); -- Almacena la fecha y hora actual al inicio del SP.
    
    -- Variables para la gesti�n de registros espec�ficos (ej. bit�cora).
    DECLARE @newBitacoraId INT,         -- Almacena el ID para un nuevo registro en la bit�cora.
            @resultadoRandom BIT;       -- Variable para simular un resultado aleatorio de revisi�n (aprobado/rechazado).

    /* =====================================================
        OBTENER DATOS NECESARIOS (FUERA DE TRANSACCI�N)
        Esta secci�n se encarga de recopilar todos los datos de referencia y IDs necesarios
        antes de iniciar el bloque de transacci�n principal. Esta pr�ctica minimiza el tiempo
        que la transacci�n permanece abierta, reduciendo la contenci�n de bloqueos y mejorando la concurrencia.
    ===================================================== */
    -- Obtiene la informaci�n principal de la propuesta (ID, tipo, y nombre del estado actual)
    -- en una sola consulta, buscando por el t�tulo de la propuesta.
    SELECT 
        @propuestaId = p.propuestaId,          -- Obtiene el ID num�rico de la propuesta.
        @tipoPropuestaId = p.proposalTypeId,   -- Obtiene el ID del tipo de propuesta.
        @estadoActual = e.name,                -- Obtiene el nombre del estado actual de la propuesta.
        -- Subconsulta para obtener el ID del estado 'En revisi�n'.
        @estadoEnRevisionId = (SELECT estadoId FROM voto_Estado WHERE name = 'En revisi�n') 
    FROM voto_Propuestas p
    JOIN voto_Estado e ON p.estadoId = e.estadoId -- Une con la tabla de estados para obtener el nombre del estado.
    WHERE p.titulo = @tituloPropuesta;         -- Filtra por el t�tulo de la propuesta proporcionado.
    
    -- Obtiene el ID del usuario revisor buscando por su nombre de usuario.
    SELECT @userIdRevisor = userId 
    FROM voto_Users 
    WHERE username = @usernameRevisor; 
    
    /* =====================================================
        VALIDACIONES INICIALES
        Esta secci�n realiza validaciones cr�ticas sobre los par�metros de entrada y los datos
        obtenidos antes de que se inicie cualquier operaci�n de modificaci�n de datos.
        Cualquier fallo aqu� detendr� la ejecuci�n del SP y devolver� un mensaje de error.
    ===================================================== */
    -- Validaci�n 1: Verifica que la propuesta con el t�tulo dado exista en la base de datos.
    IF @propuestaId IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Propuesta no encontrada';
        RETURN;
    END
    
    -- Validaci�n 2: Verifica que el usuario revisor especificado exista en la base de datos.
    IF @userIdRevisor IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Usuario no v�lido';
        RETURN;
    END
    
    -- Validaci�n 3: Verifica que la propuesta est� en un estado v�lido para iniciar la revisi�n.
    -- Solo permite la revisi�n si el estado actual es 'Pendiente de validaci�n' o ya est� 'En revisi�n'.
    IF @estadoActual NOT IN ('Pendiente de validaci�n', 'En revisi�n')
    BEGIN
        SET @mensajeSalida = 'Error: Estado no v�lido para revisi�n';
        RETURN;
    END
    
    -- Validaci�n 4: Verifica que el estado 'En revisi�n' est� configurado en la tabla voto_Estado.
    -- Esto asegura que se pueda asignar este estado a la propuesta.
    IF @estadoEnRevisionId IS NULL
    BEGIN
        SET @mensajeSalida = 'Error: Estado "En revisi�n" no configurado';
        RETURN;
    END
    
    /* =====================================================
        OBTENER WORKFLOWS CONFIGURADOS
        Esta secci�n recupera la configuraci�n de los workflows (flujos de trabajo)
        asociados al tipo espec�fico de la propuesta que se va a revisar.
    ===================================================== */
    -- Tabla temporal para almacenar los detalles de los workflows que deben ejecutarse.
    DECLARE @Workflows TABLE (
        workflow_id INT,            -- ID del workflow.
        nombre VARCHAR(100),        -- Nombre descriptivo del workflow.
        orderIndex INT,             -- Orden en que este workflow debe ser ejecutado.
        configWork VARCHAR(1500)    -- Configuraci�n espec�fica en formato JSON o texto para este workflow.
    );
    
    -- Inserta en la tabla temporal @Workflows todos los workflows activos y habilitados
    -- que est�n configurados para el tipo de propuesta actual.
    INSERT INTO @Workflows
    SELECT 
        w.workflow_id,
        w.nombre,
        wtp.orderIndex,             -- El orden de ejecuci�n se toma de la tabla de configuraci�n.
        w.configWork                -- La configuraci�n se toma directamente del registro del workflow.
    FROM voto_WorkTipoPropuesta wtp   -- Tabla que asocia tipos de propuesta con workflows.
    JOIN wk_workflow w ON wtp.workflowId = w.workflow_id -- Tabla maestra de workflows.
    WHERE wtp.tipoPropuestaId = @tipoPropuestaId -- Filtra por el tipo de propuesta actual.
    AND wtp.enabled = 1                         -- Solo considera asociaciones de workflow habilitadas.
    AND w.activo = 1                            -- Solo considera workflows que est�n marcados como activos.
    ORDER BY wtp.orderIndex;                    -- Ordena los workflows para ejecutarlos en la secuencia correcta.
    
    -- Validaci�n: Verifica que al menos un workflow est� configurado para este tipo de propuesta.
    IF NOT EXISTS (SELECT 1 FROM @Workflows)
    BEGIN
        SET @mensajeSalida = 'Error: No hay workflows configurados para este tipo de propuesta. La revisi�n no puede continuar.';
        RETURN;
    END
    
    /* =====================================================
        INICIAR TRANSACCI�N (OPERACIONES CR�TICAS)
        Todas las operaciones de modificaci�n de datos se envuelven en una transacci�n
        expl�cita para garantizar su atomicidad. Esto significa que si cualquier parte
        de este bloque falla, todos los cambios realizados desde BEGIN TRANSACTION
        ser�n revertidos (deshechos) para mantener la integridad de la base de datos.
    ===================================================== */
    BEGIN TRY
        -- Marca el inicio de la transacci�n at�mica con un nombre para facilitar la gesti�n.
        BEGIN TRANSACTION @transactionName;
        
        /* -----------------------------------------------------
            1. ACTUALIZAR ESTADO DE LA PROPUESTA
            Se cambia el estado de la propuesta a 'En revisi�n' para indicar que ha comenzado el proceso.
        ----------------------------------------------------- */
        UPDATE voto_Propuestas
        SET estadoId = @estadoEnRevisionId -- Asigna el ID del estado 'En revisi�n'.
        WHERE propuestaId = @propuestaId;   -- Actualiza la propuesta espec�fica.
        
        /* -----------------------------------------------------
            2. EJECUTAR WORKFLOWS EN ORDEN CONFIGURADO
            Se itera a trav�s de los workflows recuperados y se registra su ejecuci�n.
        ----------------------------------------------------- */
        -- Variables para almacenar los datos de cada workflow mientras el cursor itera.
        DECLARE @workflow_id INT, 
                @workflow_nombre VARCHAR(100), 
                @configWork VARCHAR(1500);
        DECLARE @run_id UNIQUEIDENTIFIER; -- Identificador �nico global (GUID) para cada ejecuci�n de workflow.
        
        -- Crea un cursor para procesar cada workflow de la tabla temporal @Workflows en el orden definido.
        DECLARE workflow_cursor CURSOR LOCAL FOR
        SELECT workflow_id, nombre, configWork FROM @Workflows ORDER BY orderIndex;
        
        -- Abre el cursor para comenzar a procesar las filas.
        OPEN workflow_cursor;
        SET @cursorExists = 1; -- Establece la bandera para indicar que el cursor est� abierto.
        -- Obtiene la primera fila de datos del cursor.
        FETCH NEXT FROM workflow_cursor INTO @workflow_id, @workflow_nombre, @configWork;
        
        -- Bucle WHILE para procesar cada workflow secuencialmente.
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Genera un identificador �nico para esta ejecuci�n particular del workflow.
            SET @run_id = NEWID();
            
            -- Registra la ejecuci�n de este workflow en la tabla 'wk_workflow_run'.
            -- Esto sirve para auditar cu�ndo y c�mo se ejecut� cada paso del workflow.
            INSERT INTO wk_workflow_run (
                run_id,             -- El identificador �nico de esta ejecuci�n.
                workflow_id,        -- El ID del workflow que se est� ejecutando.
                estadoId,           -- El estado inicial de esta ejecuci�n (1 = Pendiente).
                fecha_inicio,       -- La fecha y hora en que se inici� esta ejecuci�n.
                parametros          -- La configuraci�n espec�fica utilizada para esta ejecuci�n del workflow.
            ) VALUES (
                @run_id,            
                @workflow_id,       
                1,                  -- Asumiendo que 1 es el ID para el estado 'Pendiente'.
                @fechaActual,       
                @configWork         -- Utiliza la configuraci�n espec�fica almacenada en el workflow.
            );
            
            -- Obtiene el pr�ximo ID disponible para un nuevo registro en la bit�cora del workflow.
            SELECT @newBitacoraId = ISNULL(MAX(bitacoraId), 0) + 1 FROM wk_bitacora;
            
            -- Registra un evento en la bit�cora del workflow indicando el inicio de su ejecuci�n.
            INSERT INTO wk_bitacora (
                bitacoraId,         -- El ID �nico para este registro de bit�cora.
                wkLogTypeId,        -- El tipo de registro de log (1 = Inicio de Workflow).
                fecha,              -- La fecha y hora del evento.
                resultado,          -- Un mensaje descriptivo del evento.
                estadoId,           -- El estado asociado al registro (1 = Inicio/Pendiente).
                workflow_Id,        -- El ID del workflow al que se refiere este registro.
                parametros          -- Par�metros adicionales o contexto del evento (aqu�, el ID de la propuesta).
            ) VALUES (
                @newBitacoraId,     
                1,                  -- Asumiendo que 1 es el ID para 'Inicio'.
                @fechaActual,
                'Ejecutado workflow: ' + @workflow_nombre, -- Mensaje que indica qu� workflow se ejecut�.
                1,                  -- Asumiendo que 1 es el ID para el estado 'Inicio/Pendiente'.
                @workflow_id,       
                'PropuestaID: ' + CAST(@propuestaId AS VARCHAR) -- Concatena el ID de la propuesta como par�metro.
            );
            
            -- Incrementa el contador de workflows procesados.
            SET @workflowCount = @workflowCount + 1;
            
            -- Obtiene la siguiente fila de datos del cursor para la pr�xima iteraci�n.
            FETCH NEXT FROM workflow_cursor INTO @workflow_id, @workflow_nombre, @configWork;
        END
        
        /* -----------------------------------------------------
            CERRAR CURSOR (BUENA PR�CTICA)
            Asegura que el cursor se cierre y se desasigne para liberar recursos.
        ----------------------------------------------------- */
        IF @cursorExists = 1 -- Verifica si el cursor fue realmente abierto.
        BEGIN
            CLOSE workflow_cursor;      -- Cierra el cursor, liberando los bloqueos en las filas.
            DEALLOCATE workflow_cursor; -- Libera la memoria y los recursos asociados al cursor.
        END
        
        /* -----------------------------------------------------
            3. SIMULAR RESULTADO FINAL (80% APROBADO, 20% RECHAZADO)
            Esta secci�n simula un resultado de revisi�n, �til para entornos de desarrollo/prueba.
        ----------------------------------------------------- */
        -- Genera un resultado aleatorio: 1 (Aprobado) si el n�mero aleatorio es <= 0.8 (80% de probabilidad), de lo contrario 0 (Rechazado).
        SET @resultadoRandom = CASE WHEN RAND() <= 0.8 THEN 1 ELSE 0 END;
        
        /* -----------------------------------------------------
            4. REGISTRAR EN LOG DEL SISTEMA
            Se registra un evento en la tabla de logs del sistema para auditar el proceso de revisi�n.
        ----------------------------------------------------- */
        INSERT INTO voto_Log (
            description,    -- Descripci�n del evento registrado.
            postTime,       -- Fecha y hora en que se registr� el evento.
            computer,       -- Nombre del equipo donde se ejecut� el proceso.
            username,       -- Nombre del usuario que inici� el proceso de revisi�n.
            trace,          -- Informaci�n de traza adicional (aqu�, la configuraci�n del tipo de propuesta).
            reference1,     -- Primera referencia (aqu�, el ID de la propuesta).
            reference2,     -- Segunda referencia (aqu�, el ID del usuario revisor).
            value1,         -- Valor adicional 1 (aqu�, el tipo de propuesta).
            value2,         -- Valor adicional 2 (aqu�, el resultado simulado de la revisi�n).
            checksum        -- Hash para asegurar la integridad del registro de log.
        ) VALUES (
            'Revisi�n iniciada | Workflows: ' + CAST(@workflowCount AS VARCHAR) + -- Descripci�n que incluye el n�mero de workflows ejecutados.
            CASE WHEN @resultadoRandom = 1 THEN ' | Simulaci�n: Aprobada' ELSE ' | Simulaci�n: Rechazada' END, -- A�ade el resultado simulado.
            @fechaActual,   -- Fecha y hora actual.
            HOST_NAME(),    -- Obtiene el nombre del equipo.
            @usernameRevisor, -- Nombre del usuario revisor.
            'Configuraci�n: ' + CAST(@tipoPropuestaId AS VARCHAR), -- Traza con el tipo de propuesta.
            @propuestaId,   -- ID de la propuesta.
            @userIdRevisor, -- ID del usuario revisor.
            @tipoPropuestaId, -- Tipo de propuesta.
            @resultadoRandom, -- Resultado simulado.
            -- Genera un hash SHA2_256 para la integridad del registro de log.
            HASHBYTES('SHA2_256', CONVERT(VARCHAR(50), @propuestaId) + 
            CONVERT(VARCHAR(50), @userIdRevisor) + 
            CONVERT(VARCHAR(50), @fechaActual, 121))
        );
        
        -- Confirma la transacci�n. Si todas las operaciones dentro del bloque TRY fueron exitosas, los cambios se guardan permanentemente.
        COMMIT TRANSACTION @transactionName;
        
        -- Establece el mensaje de salida indicando que el proceso de revisi�n se inici� correctamente.
        SET @mensajeSalida = 'Proceso de revisi�n iniciado correctamente';
    END TRY
    BEGIN CATCH
        /* =====================================================
            MANEJO DE ERRORES (CATCH BLOCK)
            Este bloque se ejecuta si ocurre cualquier error SQL dentro del bloque TRY.
            Su objetivo es capturar el error, revertir la transacci�n para mantener la integridad
            de los datos y registrar el error para la depuraci�n y auditor�a.
        ===================================================== */
        -- Obtiene el mensaje de error detallado generado por SQL Server.
        DECLARE @errorMsg VARCHAR(2000) = ERROR_MESSAGE();
        
        -- Cierra y desasigna el cursor si estaba abierto. Esto es crucial para liberar recursos en caso de un error.
        IF @cursorExists = 1 AND CURSOR_STATUS('global', 'workflow_cursor') >= 0
        BEGIN
            CLOSE workflow_cursor;
            DEALLOCATE workflow_cursor;
        END
        
        -- Revertir la transacci�n si est� activa. Esto deshace todos los cambios realizados
        -- dentro del bloque TRY desde que se inici� la transacci�n.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName;
            
        -- Establece el mensaje de salida para indicar el error, incluyendo el mensaje de error de SQL Server.
        SET @mensajeSalida = 'Error: ' + @errorMsg;
        
        -- Registra el error en la tabla 'wk_bitacora' del workflow.
        -- Esto permite un seguimiento de los fallos en el proceso de revisi�n.
        INSERT INTO wk_bitacora (
            bitacoraId,     -- El ID para este registro de bit�cora (se genera el siguiente ID disponible).
            wkLogTypeId,    -- El tipo de registro de log (3 = Error).
            fecha,          -- La fecha y hora en que ocurri� el error.
            resultado,      -- Mensaje que describe el error.
            estadoId,       -- El estado asociado al registro (4 = Error).
            workflow_Id,    -- El ID del workflow que estaba en ejecuci�n (si aplica, o 0 si el error fue antes de un workflow espec�fico).
            parametros      -- Informaci�n adicional o contexto del error (aqu�, el t�tulo de la propuesta).
        ) VALUES (
            (SELECT ISNULL(MAX(bitacoraId), 0) + 1 FROM wk_bitacora), -- Obtiene el siguiente ID de bit�cora.
            3,                  -- Asumiendo que 3 es el ID para 'Error'.
            GETDATE(),          
            'Error en revisi�n: ' + @errorMsg, -- Mensaje de error detallado.
            4,                  -- Asumiendo que 4 es el ID para el estado 'Error'.
            ISNULL(@workflow_id, 0), -- Si @workflow_id es NULL (error antes de un workflow), usa 0.
            'Propuesta: ' + @tituloPropuesta -- Contexto de la propuesta donde ocurri� el error.
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
