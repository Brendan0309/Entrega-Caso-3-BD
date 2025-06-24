-- Insertar estados básicos
INSERT INTO [dbo].[voto_Estado] ([estadoId], [name], [descripcion])
VALUES 
(1, 'Borrador', 'Propuesta en borrador'),
(2, 'Revisión', 'Propuesta en revisión'),
(3, 'Aprobada', 'Propuesta aprobada para inversión'),
(4, 'Rechazada', 'Propuesta rechazada'),
(5, 'En ejecución', 'Propuesta en ejecución'),
(6, 'Finalizada', 'Propuesta finalizada');

select * from voto_Estado

-- Insertar tipos de propuesta
INSERT INTO [dbo].[voto_TiposPropuesta] ([tipoPropuestaId], [nombre], [descripcion])
VALUES 
(1, 'Proyecto Social', 'Proyecto de impacto social'),
(2, 'Proyecto Productivo', 'Proyecto con fines productivos');

-- Insertar monedas
INSERT INTO [dbo].[voto_Currencies] ([currencyId], [name], [acronym], [symbol])
VALUES 
(1, 'Dólar Estadounidense', 'USD', '$'),
(2, 'Colón Costarricense', 'CRC', '₡');

-- Insertar método de pago
INSERT INTO [dbo].[voto_MetodosDePago] ([metodoPagoId], [name], [apiuRL], [secretKey], [llave], [logoIconURL], [enabled], [templateJSON])
VALUES 
(1, 'Transferencia Bancaria', 'api/pagos/transferencia', 0x1234, 0x5678, 'transferencia.png', 1, '{"campos":["banco","cuenta","referencia"]}');

-- Insertar tipos de educación
INSERT INTO [dbo].[voto_tipoEducacion] ([tipoEducacionId], [name], [description])
VALUES 
(1, 'Primaria', 'Educación primaria completa'),
(2, 'Secundaria', 'Educación secundaria completa'),
(3, 'Universitaria', 'Educación universitaria completa');

-- Insertar niveles de educación
INSERT INTO [dbo].[voto_Educacion] ([nivelEducacionId], [tipoEducacionId], [fechaGraduado])
VALUES 
(1, 3, '2010-12-15'); -- Universitaria, graduado en 2010

-- Insertar sexos (necesario para personas)
INSERT INTO [dbo].[voto_Sexo] ([sexoId], [description])
VALUES 
(1, 'Masculino'),
(2, 'Femenino'),
(3, 'Otro');

-- Insertar países (necesario para personas)
INSERT INTO [dbo].[voto_Countries] ([countryId], [name])
VALUES 
(1, 'Costa Rica'),
(2, 'Estados Unidos');

-- Insertar profesiones (necesario para personas)
-- Primero tipoProfesion
INSERT INTO [dbo].[voto_tipoProfesion] ([tipoProfesionId], [name], [descripcion])
VALUES 
(1, 'Ingeniero', 'Profesional en ingeniería'),
(2, 'Médico', 'Profesional en medicina');

-- Luego profesión
INSERT INTO [dbo].[voto_Profesion] ([profesionId], [tipoProfesionId], [fechaInicio], [fechaFin])
VALUES 
(1, 1, '2011-01-01', NULL); -- Ingeniero desde 2011

-- Ahora podemos insertar la persona
INSERT INTO [dbo].[voto_Personas] ([personId], [firstName], [lastName], [birthDate], [sexoId], [educaciónid], [countryId], [profesionId], [fechaUltimaValidacion], [estadoValidacion], [hashIdentidad])
VALUES 
(1, 'Juan', 'Pérez', '1985-05-15', 1, 1, 1, 1, GETDATE(), 'Validado', 0x123456);

select * from [voto_Personas]
select * from voto_Educacion

INSERT INTO [dbo].[voto_Users] ([userId], [username], [contrasena], [enabled], [fechaUltimaAutenticacion], [nivelSeguridad], [requiereRevalidacion], [fechaExpiracionCuenta], [fechaExpiracionCredenciales], [cuentaBloqueada], [ultimoCambioCredenciales], [tipoUserId], [signUpId], [comparticionId])
VALUES 
(4, 'juan.perez@email.com', 0x123456789, 1, GETDATE(), 3, 0, DATEADD(YEAR, 1, GETDATE()), DATEADD(MONTH, 6, GETDATE()), 0, GETDATE(), 1, 1, 1);

select * from voto_Users

-- Insertar una inversión de ejemplo
INSERT INTO [dbo].[voto_Inversiones] (
    [inversionId], 
    [propuestaId], 
    [userId], 
    [monto], 
    [fechaInversion], 
    [metodoPago], 
    [comprobantePago], 
    [hashTransaccion], 
    [estado]
)
VALUES (
    1, 
    1, 
    1, 
    5000.00, 
    GETDATE(), 
    'Transferencia Bancaria', 
    'COMP-12345', 
    'abc123', 
    'Activa'
);

-- Ahora podemos insertar el inversionista
INSERT INTO [dbo].[voto_Inversionistas] (
    [fechaRegistro], 
    [montoMaximoInversion], 
    [experiencia], 
    [acreditado], 
    [fechaAcreditacion], 
    [hashCertificacion], 
    [estado], 
    [inversionId]
)
VALUES 
(
    GETDATE(), 
    100000.00, 
    'Inversionista experimentado', 
    1, 
    GETDATE(), 
    0x123456, 
    'Activo', 
    1
);
--
select * from voto_Inversionistas


-- Insertar propuesta aprobada para inversión
INSERT INTO [dbo].[voto_Propuestas] ([propuestaId], [titulo], [descripcion], [resumenEjecutivo], [userId], [estadoId], [fechaCreacion], [fechaPublicacion], [fechaCierre], [docTypesProposalId], [hashDocumentacion], [hashContenido], [proposalTypeId], [institucionId])
VALUES 
(1, 'Proyecto de Energía Solar', 'Instalación de paneles solares en comunidad rural', 'Proyecto sostenible para generación de energía limpia', 1, 3, GETDATE(), GETDATE(), DATEADD(MONTH, 3, GETDATE()), 1, 0x123456, 0x789ABC, 1, NULL);

-- Insertar plan de trabajo para la propuesta
INSERT INTO [dbo].[voto_PlanesTrabajo] ([propuestaId], [version], [fechaInicio], [duracionMeses], [descripcion], [fechaAprobacion], [hashDocumento], [estado])
VALUES 
(1, 1, DATEADD(MONTH, 1, GETDATE()), 12, 'Plan de implementación en 3 fases', GETDATE(), 0x123456, 'Aprobado');

-- Insertar plan de desembolsos
INSERT INTO [dbo].[voto_PlanesDesembolso] ([planId], [propuestaId], [version], [fechaAprobacion], [userIdAprobacion], [hashDocumento])
VALUES 
(1, 1, 1, GETDATE(), 1, 0x123456);

-- Insertar items de desembolso (tramos mensuales)
INSERT INTO [dbo].[voto_ItemsDesembolso] ([itemId], [planId], [numeroMes], [concepto], [monto], [condiciones])
VALUES 
(1, 1, 1, 'Adquisición inicial de materiales', 5000.00, 'Presentar facturas de compra'),
(2, 1, 2, 'Instalación fase 1', 3000.00, 'Presentar avance del 20%'),
(3, 1, 3, 'Instalación fase 2', 3000.00, 'Presentar avance del 40%'),
(4, 1, 6, 'Instalación fase 3', 4000.00, 'Presentar avance del 70%'),
(5, 1, 9, 'Finalización proyecto', 5000.00, 'Presentar avance del 100%');

INSERT INTO [dbo].[voto_Users] (
    [username], [contrasena], [enabled], [nivelSeguridad], 
    [tipoUserId], [signUpId]
)
VALUES
    ('inversor1', HASHBYTES('SHA2_256', 'clave123'), 1, 2, 3, 1),
    ('inversor2', HASHBYTES('SHA2_256', 'clave456'), 1, 2, 3, 1),
    ('admin1', HASHBYTES('SHA2_256', 'admin123'), 1, 3, 1, 1);



INSERT INTO [dbo].[voto_Propuestas] (
    [titulo], [descripcion], [resumenEjecutivo], [userId], 
    [estadoId], [fechaCreacion], [hashContenido], [proposalTypeId]
)
VALUES
    ('Desarrollo de App Educativa', 'Aplicación para aprendizaje infantil', 'Resumen ejecutivo de app educativa', 1, 9, GETDATE(), 0x0123456789, 1),
    ('Planta de Reciclaje Comunitaria', 'Proyecto de reciclaje para el barrio', 'Resumen ejecutivo de reciclaje', 2, 9, GETDATE(), 0x0123456789, 2),
    ('Energía Solar para Escuelas', 'Instalación de paneles solares', 'Resumen ejecutivo energía solar', 3, 9, GETDATE(), 0x0123456789, 3);




INSERT INTO [dbo].[voto_Inversionistas] (
    [fechaRegistro], [montoMaximoInversion], [acreditado], 
    [estado], [inversionId]
)
VALUES
    (GETDATE(), 100000.00, 1, 'Activo', NULL),
    (GETDATE(), 50000.00, 1, 'Activo', NULL),
    (GETDATE(), 75000.00, 1, 'Activo', NULL);




INSERT INTO [dbo].[voto_MetodosDePago] (
    [name], [apiuRL], [enabled], [templateJSON]
)
VALUES
    ('Transferencia Bancaria', 'https://api.bancos.com/transfer', 1, '{"cuenta": "123456"}'),
    ('Tarjeta de Crédito', 'https://api.creditos.com/pay', 1, '{"tarjeta": "411111"}'),
    ('PayPal', 'https://api.paypal.com/v1/payments', 1, '{"email": "user@example.com"}');




INSERT INTO [dbo].[voto_Currencies] (
    [name], [acronym], [symbol]
)
VALUES
    ('Dólar Estadounidense', 'USD', '$'),
    ('Euro', 'EUR', '€'),
    ('Peso Mexicano', 'MXN', '$');




INSERT INTO [dbo].[voto_CurrencyConvertions] (
    [startdate], [enddate], [exchangeRate], [enabled], 
    [currentExchangeRate], [currencyId_Source], [currencyId_destiny]
)
VALUES
    ('2023-01-01', '2023-12-31', 1.0, 1, 1, 1, 1),
    ('2023-01-01', '2023-12-31', 0.85, 1, 1, 1, 2);





INSERT INTO [dbo].[voto_transTypes] (
    [transTypeId] ,[name]
)
VALUES
    (1,'Inversión'),
    (2,'Retiro'),
    (3,'Reembolso');

select * from [voto_funds]


INSERT INTO [dbo].[voto_funds] (
    [fundId] ,[name]
)
VALUES
    (2,'Reserva'),
    (3, 'Inversiones');



INSERT INTO [dbo].[voto_PlanesDesembolso] (
    [planId], [propuestaId], [version], [fechaAprobacion], 
    [userIdAprobacion], [hashDocumento]
)
VALUES
    (2, 1, 1, GETDATE(), 1, CONVERT(VARBINARY(256), 'Plan1Hash')),
    (3, 2, 1, GETDATE(), 1, CONVERT(VARBINARY(256), 'Plan2Hash')),
    (4, 6, 1, GETDATE(), 1, CONVERT(VARBINARY(256), 'Plan3Hash'));

select * from [voto_PlanesDesembolso]


INSERT INTO [dbo].[voto_PlanesTrabajo] (
    [propuestaId], [version], [fechaInicio], 
    [duracionMeses], [descripcion], [fechaAprobacion], 
    [hashDocumento], [estado]
)
VALUES
    ( 1, 1, '2025-07-01', 6, 'Plan de trabajo para reciclaje comunitario', GETDATE(), CONVERT(VARBINARY(256), 'Plan1Doc'), 'Aprobado'),
    ( 2, 1, '2025-07-15', 12, 'Plan de implementación de energía solar', GETDATE(), CONVERT(VARBINARY(256), 'Plan2Doc'), 'Aprobado'),
    ( 6, 1, '2025-08-01', 9, 'Plan de trabajo para proyecto solar', GETDATE(), CONVERT(VARBINARY(256), 'Plan3Doc'), 'Aprobado');




INSERT INTO [dbo].[voto_ItemsDesembolso] (
    [itemId], [planId], [numeroMes], [concepto], [monto], [condiciones]
)
VALUES
    (6, 1, 1, 'Compra de contenedores', 2000.00, 'Pago contra entrega'),
    (7, 1, 2, 'Campaña de concientización', 3000.00, 'Pago contra informe'),
    (8, 1, 3, 'Mantenimiento inicial', 5000.00, 'Pago mensual'),
    (9, 2, 1, 'Compra de paneles solares', 4000.00, '50% anticipo, 50% contra entrega'),
    (10, 2, 2, 'Instalación', 4000.00, 'Pago contra entrega'),
    (11, 3, 1, 'Estudio de viabilidad', 2500.00, 'Pago contra informe'),
    (12, 3, 2, 'Compra de materiales', 2500.00, 'Pago contra factura'),
    (13, 3, 3, 'Instalación inicial', 2500.00, 'Pago contra entrega'),
    (14, 3, 4, 'Capacitación', 2500.00, 'Pago contra informe');



INSERT INTO [dbo].[voto_recaudacionFondos] (
    [recaudacionId], [inversionId] , [metaFinanciamiento], 
    [minimoFinanciamiento], [fondosRecaudados] , [hashContenido]
)
VALUES
    (1, 2, 50000.00, 25000.00, 32000.00, CONVERT(VARBINARY(150), 'HashRec1')),
    (2, 7, 75000.00, 37500.00, 45000.00,CONVERT(VARBINARY(150), 'HashRec2')),
    (3, 3, 60000.00, 30000.00, 60000.00,CONVERT(VARBINARY(150), 'HashRec3'));




INSERT INTO [dbo].[voto_TipoPublicaciones] (
    [tipoPublicacionId], [name], [descripcion]
)
VALUES
    (1, 'Proyecto Social', 'Proyectos que afectan a diferentes grupos sociales'),
    (2, 'Proyecto Privado', 'Proyecto diseñado para una institucion privada'),
    (3, 'Proyecto Rural', 'Proyecto que apoya las zonas rurales');



INSERT INTO [dbo].[voto_CrowdfundingPublicaciones] (
     [propuestaId], [titulo], [resumen], 
    [descripcionCompleta], [problema], [solucion], 
    [fechaPublicacion], [fechaCierre], [estadoid], 
    [hashContenido], [tipoPublicacionesId],segmentoid ,recaudacionId
)
VALUES
    ( 1, 'Proyecto de reciclaje comunitario', 'Iniciativa para implementar puntos de reciclaje', 
    'Descripción completa del proyecto de reciclaje', 'Problema de residuos en la comunidad', 
    'Solución con puntos de reciclaje', '2025-06-25', '2025-09-25', 1, 
    CONVERT(VARBINARY(256), 'HashContenido1'), 1, 7, 2),
    
    ( 2, 'Proyecto de Energía Solar', 'Instalación de paneles solares', 
    'Descripción completa del proyecto solar', 'Falta de acceso a energía', 
    'Instalación de paneles solares', '2025-06-25', '2025-12-25', 1, 
    CONVERT(VARBINARY(256), 'HashContenido2'), 1, 3, 1),
    
    ( 6, 'Proyecto de Energía Solar', 'Instalación de paneles solares en escuelas', 
    'Descripción completa del proyecto solar educativo', 'Escuelas sin acceso a energía confiable', 
    'Paneles solares para escuelas', '2025-07-01', '2025-12-31', 1, 
    CONVERT(VARBINARY(256), 'HashContenido3'), 1, 1, 3);


select * from [voto_CrowdfundingPublicaciones]



-- estas si estan llenas
select * from [voto_InversionistaBalance]


INSERT INTO [dbo].[voto_InversionistaBalance] (
    [personBalanceId] , [inversionistaId], [balance], [lastBalance], 
    [checksum], [frezeAmount], [fundId], [hashContenido]
)
VALUES
    (3,2, 100000.00, 100000.00, CONVERT(VARBINARY(200), 'Checksum1'), 0.00, 1, CONVERT(VARBINARY(250), 'HashIB1')),
    (4,3, 50000.00, 50000.00, CONVERT(VARBINARY(200), 'Checksum2'), 0.00, 1, CONVERT(VARBINARY(250), 'HashIB2')),
    (5, 4, 75000.00, 75000.00, CONVERT(VARBINARY(200), 'Checksum3'), 0.00, 1, CONVERT(VARBINARY(250), 'HashIB3'));