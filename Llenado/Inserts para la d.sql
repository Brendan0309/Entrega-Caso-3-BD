

-- Tipos de contacto
INSERT INTO [dbo].[voto_ContactInfoTypes] ([contactInfoTypeId], [name])
VALUES 
(1, 'CuentaBancaria'),
(2, 'Email'),
(3, 'Teléfono');

-- Tipos de transacción
INSERT INTO [dbo].[voto_transTypes] ([transTypeId], [name])
VALUES 
(1, 'Inversión'),
(2, 'Retiro'),
(3, 'Dividendo');

-- Monedas
INSERT INTO [dbo].[voto_Currencies] ([currencyId], [name], [acronym], [symbol])
VALUES 
(1, 'Dólar Estadounidense', 'USD', '$'),
(2, 'Colón Costarricense', 'CRC', '?');

select * from voto_Currencies

-- Métodos de pago
INSERT INTO [dbo].[voto_MetodosDePago] ([metodoPagoId], [name], [apiuRL], [secretKey], [llave], [logoIconURL], [enabled], [templateJSON])
VALUES 
(1, 'Transferencia Bancaria', 'api/transferencias', 0x01, 0x01, 'transferencia.png', 1, NULL);

select * from voto_MetodosDePago

-- Módulos
INSERT INTO [dbo].[voto_Modules] ([moduleId], [name], [languajeId])
VALUES 
(1, 'Inversiones', 1),
(2, 'Proyectos', 1),
(3, 'Pagos', 1);

select * from voto_Modules

-- Fondos
INSERT INTO [dbo].[voto_funds] ([fundId], [name])
VALUES 
(1, 'Fondo Principal');

select * from voto_funds

-- Personas
INSERT INTO [dbo].[voto_Personas] ([personId], [firstName], [lastName], [birthDate], [sexoId], [educaciónid], [countryId], [profesionId], [fechaUltimaValidacion], [estadoValidacion], [hashIdentidad])
VALUES 
(2, 'Juan', 'Pérez', '1980-01-15', 1, 1, 1, 1, GETDATE(), 'Validado', NULL),
(3, 'María', 'Gómez', '1985-05-20', 2, 1, 1, 1, GETDATE(), 'Validado', NULL),
(4, 'Carlos', 'Rodríguez', '1975-11-30', 1, 1, 1, 1, GETDATE(), 'Validado', NULL);

select * from voto_Personas

-- Usuarios
INSERT INTO [dbo].[voto_Users] ( [username], [contrasena], [enabled], [fechaUltimaAutenticacion], [nivelSeguridad], [requiereRevalidacion], [fechaExpiracionCuenta], [fechaExpiracionCredenciales], [cuentaBloqueada], [ultimoCambioCredenciales], [tipoUserId], [signUpId], [comparticionId])
VALUES 
( 'admin', HASHBYTES('SHA2_256', 'admin123'), 1, GETDATE(), 3, 0, NULL, NULL, 0, GETDATE(), 1, 1, 1),
( 'inversionista1', HASHBYTES('SHA2_256', 'inv123'), 1, GETDATE(), 2, 0, NULL, NULL, 0, GETDATE(), 2, 2, 2),
( 'inversionista2', HASHBYTES('SHA2_256', 'inv456'), 1, GETDATE(), 2, 0, NULL, NULL, 0, GETDATE(), 2, 3, 3);


-- Tipos de institución
INSERT INTO [dbo].[voto_TipoInstitucion] ([tipoInstitucioneId], [name], [descripcion], [sector])
VALUES 
(1, 'ONG', 'Organización No Gubernamental', 'Social'),
(2, 'Empresa', 'Empresa Privada', 'Comercial');


INSERT INTO [dbo].[voto_States] ([stateId], [countryId], [name])
VALUES 
(1, 1, 'San José'),
(2, 2, 'New York');

INSERT INTO [dbo].[voto_Cities] ([cityId], [stateId], [name])
VALUES 
(1, 1, 'Tibás'),
(2, 2, 'New York');

INSERT INTO dbo.voto_adresses (
    adressId,
    line1,
    line2,
    zipCode,
    geoposition,
    cityId
)
VALUES (
    1,                                     -- adressId
    'Av. Principal #123',                 -- line1
    'Depto 4B',                           -- line2 (puede ser NULL)
    '12345-678',                          -- zipCode
    geography::Point(19.4326, -99.1332, 4326), -- geoposition (lat, long, SRID)
    1001                                  -- cityId
);

-- Instituciones
INSERT INTO [dbo].[voto_Instituciones] ( [nombre], [creationDate], [enabled], [adressId], [userId], [fechaUltimaValidacion], [estadoValidacion], [hashConstitutiva], [tipoInstitucionId])
VALUES 
( 'Fundación Pura Vida', GETDATE(), 1, 1, 1, GETDATE(), 'Validado', 0x01, 1);



-- Propuestas (proyectos)
INSERT INTO [dbo].[voto_Propuestas] ([titulo], [descripcion], [resumenEjecutivo], [userId], [estadoId], [fechaCreacion], [fechaPublicacion], [fechaCierre], [hashDocumentacion], [hashContenido], [proposalTypeId], [institucionId])
VALUES 
( 'Proyecto de Energía Solar', 'Instalación de paneles solares en comunidad rural', 'Resumen ejecutivo del proyecto', 1, 1, GETDATE(), GETDATE(), DATEADD(MONTH, 6, GETDATE()), 0x01, 0x01, 1, 1);


select * from voto_Propuestas


-- Inversionistas
INSERT INTO [dbo].[voto_Inversionistas] ([inversionistaId], [fechaRegistro], [montoMaximoInversion], [experiencia], [acreditado], [fechaAcreditacion], [hashCertificacion], [estado], [inversionId])
VALUES 
(1, GETDATE(), 50000.00, 'Experiencia en energías renovables', 1, GETDATE(), 0x01, 'Activo', 1),
(2, GETDATE(), 75000.00, 'Inversor experimentado', 1, GETDATE(), 0x01, 'Activo', 2);

-- Información de contacto de inversionistas (cuentas bancarias)
INSERT INTO [dbo].[voto_contactInfoInversionistas] ([value], [enabled], [lastUppdate], [contactInfoTypeId], [inversionistaId])
VALUES 
('CR12345678901234567890', 1, GETDATE(), 1, 1),
('CR98765432109876543210', 1, GETDATE(), 1, 2);

-- Balances de inversionistas
INSERT INTO [dbo].[voto_InversionistaBalance] ([personBalanceId], [inversionistaId], [balance], [lastBalance], [checksum], [frezeAmount], [funfId], [hashContenido])
VALUES 
(1, 1, 10000.00, 10000.00, HASHBYTES('SHA2_256', '10000.001'), 0.00, 1, 0x01),
(2, 2, 15000.00, 15000.00, HASHBYTES('SHA2_256', '15000.002'), 0.00, 1, 0x01);

-- Inversiones
INSERT INTO [dbo].[voto_Inversiones] ( [propuestaId], [userId], [monto], [fechaInversion], [metodoPago], [comprobantePago], [hashTransaccion], [estado])
VALUES 
(1, 2, 30000.00, GETDATE(), 'Transferencia', 'COMP-001', 'HASH-001', 'Aprobado'),
(2, 3, 45000.00, GETDATE(), 'Transferencia', 'COMP-002', 'HASH-002', 'Aprobado');

-- Fiscalizaciones
INSERT INTO [dbo].[voto_Fiscalizaciones] ([fiscalizacionId], [propuestaId], [userId], [fechaReporte], [descripcion], [evidencia], [hashEvidencia], [estado])
VALUES 
(1, 2, 1, GETDATE(), 'Fiscalización inicial del proyecto', 'evidencia.pdf', 0x01, 'Aprobado');