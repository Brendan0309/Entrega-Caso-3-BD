USE [master]
GO
/****** Object:  Database [voto_Puravida2]    Script Date: 24/6/2025 16:54:41 ******/
CREATE DATABASE [voto_Puravida2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'voto_Puravida2', FILENAME = N'E:\Bases de datos 1, tercer semestre\Entregable 3\cosas de la base localhost\voto_Puravida2.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'voto_Puravida2_log', FILENAME = N'E:\Bases de datos 1, tercer semestre\Entregable 3\cosas de la base localhost\voto_Puravida2_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [voto_Puravida2] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [voto_Puravida2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [voto_Puravida2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [voto_Puravida2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [voto_Puravida2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [voto_Puravida2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [voto_Puravida2] SET ARITHABORT OFF 
GO
ALTER DATABASE [voto_Puravida2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [voto_Puravida2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [voto_Puravida2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [voto_Puravida2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [voto_Puravida2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [voto_Puravida2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [voto_Puravida2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [voto_Puravida2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [voto_Puravida2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [voto_Puravida2] SET  DISABLE_BROKER 
GO
ALTER DATABASE [voto_Puravida2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [voto_Puravida2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [voto_Puravida2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [voto_Puravida2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [voto_Puravida2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [voto_Puravida2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [voto_Puravida2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [voto_Puravida2] SET RECOVERY FULL 
GO
ALTER DATABASE [voto_Puravida2] SET  MULTI_USER 
GO
ALTER DATABASE [voto_Puravida2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [voto_Puravida2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [voto_Puravida2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [voto_Puravida2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [voto_Puravida2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [voto_Puravida2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'voto_Puravida2', N'ON'
GO
ALTER DATABASE [voto_Puravida2] SET QUERY_STORE = ON
GO
ALTER DATABASE [voto_Puravida2] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [voto_Puravida2]
GO
/****** Object:  User [votouser]    Script Date: 24/6/2025 16:54:42 ******/
CREATE USER [votouser] FOR LOGIN [votouser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [votouser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [votouser]
GO
/****** Object:  Table [dbo].[voto_adresses]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_adresses](
	[adressId] [int] IDENTITY(1,1) NOT NULL,
	[line1] [varchar](200) NOT NULL,
	[line2] [varchar](200) NULL,
	[zipCode] [varchar](9) NOT NULL,
	[geoposition] [geography] NOT NULL,
	[cityId] [int] NOT NULL,
 CONSTRAINT [PK_caipi_adresses] PRIMARY KEY CLUSTERED 
(
	[adressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_AquienInterese]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_AquienInterese](
	[aQuienIntereseId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[mediaFileId] [int] NOT NULL,
	[nombreArchivo] [varchar](50) NOT NULL,
	[hashArchivo] [varbinary](250) NOT NULL,
	[problematica] [text] NOT NULL,
	[solucion] [text] NOT NULL,
	[mercado] [text] NOT NULL,
	[modeloNegocio] [text] NOT NULL,
 CONSTRAINT [PK_voto_AquienInterese] PRIMARY KEY CLUSTERED 
(
	[aQuienIntereseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_AuditoriaSeguridad]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_AuditoriaSeguridad](
	[auditoriaId] [bigint] IDENTITY(1,1) NOT NULL,
	[fechaHora] [datetime2](7) NOT NULL,
	[tipoEvento] [varchar](50) NOT NULL,
	[categoria] [varchar](50) NOT NULL,
	[logseverityId] [int] NOT NULL,
	[userId] [int] NULL,
	[direccionIP] [varchar](45) NULL,
	[dispositivo] [varchar](100) NULL,
	[detalles] [nvarchar](max) NULL,
	[hashAuditoria] [varbinary](290) NOT NULL,
	[firmaDigital] [varchar](512) NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Aud__ED6C0FFB4049618B] PRIMARY KEY CLUSTERED 
(
	[auditoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_AutenticacionMFA]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_AutenticacionMFA](
	[mfaId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[tipo] [varchar](20) NOT NULL,
	[identificador] [varchar](100) NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[ultimoUso] [datetime] NULL,
	[activo] [bit] NOT NULL,
	[codigo] [varchar](10) NULL,
	[fechaExpiracion] [datetime] NULL,
	[intentosFallidos] [int] NOT NULL,
	[bloqueado] [bit] NOT NULL,
	[hash] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Aut__2AA17B239766DC4B] PRIMARY KEY CLUSTERED 
(
	[mfaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_AvalesPropuesta]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_AvalesPropuesta](
	[avalId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[grupoId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[fechaAval] [datetime] NOT NULL,
	[comentarios] [varchar](1500) NULL,
	[porcentajeEquity] [decimal](5, 2) NULL,
	[honorarios] [decimal](15, 2) NULL,
	[condiciones] [varchar](1500) NULL,
	[hashDocumento] [varchar](256) NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Ava__20FBA6E91BB0C517] PRIMARY KEY CLUSTERED 
(
	[avalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_BenefitRestrictions]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_BenefitRestrictions](
	[benefitRestrictionId] [int] NOT NULL,
	[restrictionDesc] [varchar](200) NOT NULL,
	[maxAmount] [float] NOT NULL,
	[scheduleId] [int] NOT NULL,
	[isActive] [bit] NOT NULL,
	[partnerDealBenefitsId] [int] NOT NULL,
	[dateRestriction] [datetime] NOT NULL,
 CONSTRAINT [PK_voto_BenefitRestrictions] PRIMARY KEY CLUSTERED 
(
	[benefitRestrictionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_BiometricErrors]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_BiometricErrors](
	[biometricErrorId] [int] NOT NULL,
	[description] [varchar](30) NOT NULL,
	[tipoBiometricErrorId] [int] NOT NULL,
 CONSTRAINT [PK_voto_BiometricErrors] PRIMARY KEY CLUSTERED 
(
	[biometricErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_BiometricMedia]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_BiometricMedia](
	[biometricoId] [int] NOT NULL,
	[mediaFileId] [int] NOT NULL,
	[uploadTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Cities]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Cities](
	[cityId] [int] NOT NULL,
	[name] [varchar](60) NOT NULL,
	[stateId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Cities] PRIMARY KEY CLUSTERED 
(
	[cityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ComentariosPropuestas]    Script Date: 24/6/2025 16:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ComentariosPropuestas](
	[comentarioId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[contenido] [varchar](1500) NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[estadoId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[hashComentario] [varbinary](256) NOT NULL,
	[firmaDigital] [varchar](512) NULL,
	[tipoComentarioId] [int] NOT NULL,
 CONSTRAINT [PK_voto_ComentariosPropuestas] PRIMARY KEY CLUSTERED 
(
	[comentarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_comparticion]    Script Date: 24/6/2025 16:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_comparticion](
	[comparticionId] [int] NOT NULL,
	[encriptedId] [int] NOT NULL,
	[desencriptedId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_voto_compartición] PRIMARY KEY CLUSTERED 
(
	[comparticionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_CondicionesGubernamentales]    Script Date: 24/6/2025 16:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_CondicionesGubernamentales](
	[condicionId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[tipoCondicion] [varchar](50) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[valor] [varchar](100) NULL,
	[fechaEstablecida] [datetime] NOT NULL,
	[userId] [int] NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Con__1F08316ADA2E2940] PRIMARY KEY CLUSTERED 
(
	[condicionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ConfigSeguridad]    Script Date: 24/6/2025 16:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ConfigSeguridad](
	[configId] [int] NOT NULL,
	[algoritmoVotos] [varchar](50) NOT NULL,
	[algoritmoFirmas] [varchar](50) NOT NULL,
	[algoritmoHash] [varchar](50) NOT NULL,
	[nivelSeguridadMinimo] [int] NOT NULL,
	[tlsVersion] [varchar](10) NOT NULL,
	[fechaActualizacion] [datetime] NOT NULL,
	[userId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[configId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ConfigVisualizacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ConfigVisualizacion](
	[configId] [int] NOT NULL,
	[votacionId] [int] NOT NULL,
	[tipoGrafico] [varchar](30) NULL,
	[mostrarResumen] [bit] NOT NULL,
	[mostrarDetalle] [bit] NOT NULL,
	[mostrarPorGrupo] [bit] NOT NULL,
	[plantillaResultados] [varchar](50) NULL,
	[hashSeguridad] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Con__3FEDA8E6770AD2DD] PRIMARY KEY CLUSTERED 
(
	[configId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ContactInfoInstituciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ContactInfoInstituciones](
	[value] [varchar](100) NOT NULL,
	[enabled] [bit] NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
	[contactInfoTypeId] [int] NOT NULL,
	[institucionId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_contactInfoInversionistas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_contactInfoInversionistas](
	[value] [varchar](100) NOT NULL,
	[enabled] [bit] NOT NULL,
	[lastUppdate] [datetime] NOT NULL,
	[contactInfoTypeId] [int] NOT NULL,
	[inversionistaId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ContactInfoPerson]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ContactInfoPerson](
	[value] [varchar](100) NOT NULL,
	[enabled] [bit] NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
	[contactInfoTypeId] [int] NOT NULL,
	[personId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ContactInfoTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ContactInfoTypes](
	[contactInfoTypeId] [int] NOT NULL,
	[name] [varchar](20) NOT NULL,
 CONSTRAINT [PK_voto_ContactInfoTypes] PRIMARY KEY CLUSTERED 
(
	[contactInfoTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Countries]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Countries](
	[countryId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_Countries] PRIMARY KEY CLUSTERED 
(
	[countryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_CrowdfundingPublicaciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_CrowdfundingPublicaciones](
	[publicacionId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[titulo] [varchar](100) NOT NULL,
	[resumen] [varchar](1500) NOT NULL,
	[descripcionCompleta] [varchar](1500) NOT NULL,
	[problema] [varchar](1500) NOT NULL,
	[solucion] [varchar](1500) NOT NULL,
	[logoURL] [varchar](40) NULL,
	[fechaPublicacion] [datetime] NOT NULL,
	[fechaCierre] [datetime] NULL,
	[estadoid] [int] NOT NULL,
	[visitas] [int] NOT NULL,
	[compartidos] [int] NOT NULL,
	[hashContenido] [varbinary](256) NOT NULL,
	[tipoPublicacionesId] [int] NOT NULL,
	[llavePrivada] [varbinary](250) NULL,
	[segmentoid] [int] NOT NULL,
	[recaudacionId] [int] NOT NULL,
 CONSTRAINT [PK_voto_CrowdfundingPublicaciones] PRIMARY KEY CLUSTERED 
(
	[publicacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_CrowdfundingRecompensas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_CrowdfundingRecompensas](
	[recompensaId] [int] IDENTITY(1,1) NOT NULL,
	[publicacionId] [int] NOT NULL,
	[montoMinimo] [decimal](15, 2) NOT NULL,
	[descripcion] [text] NOT NULL,
	[cantidadDisponible] [int] NULL,
	[fechaEntregaEstimada] [date] NULL,
	[restricciones] [varchar](1500) NULL,
	[hashRecomensa] [varbinary](250) NULL,
 CONSTRAINT [PK_voto_CrowdfundingRecompensas] PRIMARY KEY CLUSTERED 
(
	[recompensaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Currencies]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Currencies](
	[currencyId] [int] NOT NULL,
	[name] [varchar](45) NOT NULL,
	[acronym] [varchar](3) NOT NULL,
	[symbol] [char](1) NOT NULL,
 CONSTRAINT [PK_voto_Currencies] PRIMARY KEY CLUSTERED 
(
	[currencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_CurrencyConvertions]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_CurrencyConvertions](
	[conversionId] [int] IDENTITY(1,1) NOT NULL,
	[startdate] [date] NOT NULL,
	[enddate] [date] NOT NULL,
	[exchangeRate] [decimal](10, 6) NOT NULL,
	[enabled] [bit] NOT NULL,
	[currentExchangeRate] [bit] NULL,
	[currencyId_Source] [int] NOT NULL,
	[currencyId_destiny] [int] NOT NULL,
 CONSTRAINT [PK_voto_CurrencyConvertions] PRIMARY KEY CLUSTERED 
(
	[conversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DealBenefitTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DealBenefitTypes](
	[dealBenefitTypeId] [int] NOT NULL,
	[name] [varchar](40) NOT NULL,
	[description] [varchar](100) NOT NULL,
	[isActive] [bit] NOT NULL,
 CONSTRAINT [PK_voto_DealBenefitTypes] PRIMARY KEY CLUSTERED 
(
	[dealBenefitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DealMedia]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DealMedia](
	[dealMediaId] [int] NOT NULL,
	[partnerDealId] [int] NOT NULL,
	[mediaFileId] [int] NOT NULL,
 CONSTRAINT [PK_voto_DealMedia] PRIMARY KEY CLUSTERED 
(
	[dealMediaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Desembolsos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Desembolsos](
	[desembolsoId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[itemId] [int] NOT NULL,
	[fechaProgramada] [date] NOT NULL,
	[fechaReal] [date] NULL,
	[monto] [decimal](15, 2) NOT NULL,
	[estadoId] [int] NOT NULL,
	[comprobante] [varchar](100) NULL,
	[hashTransaccion] [varchar](256) NULL,
	[userIdAutorizacion] [int] NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Des__5F163EF55890D52C] PRIMARY KEY CLUSTERED 
(
	[desembolsoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DesembolsosDoc]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DesembolsosDoc](
	[desembolsoId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Desencriptacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Desencriptacion](
	[desencriptionId] [int] NOT NULL,
	[publicDesencripted] [varbinary](170) NOT NULL,
	[privateDesencripted] [varbinary](170) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_voto_Desencriptacion] PRIMARY KEY CLUSTERED 
(
	[desencriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Dispositivos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Dispositivos](
	[dispositivoId] [int] IDENTITY(1,1) NOT NULL,
	[modelo] [varchar](50) NOT NULL,
	[descripcion] [varchar](70) NOT NULL,
	[fechaRegistro] [date] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_Dispositivos] PRIMARY KEY CLUSTERED 
(
	[dispositivoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DistribucionDetalle]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DistribucionDetalle](
	[detalleId] [int] IDENTITY(1,1) NOT NULL,
	[cycleId] [int] NOT NULL,
	[inversionId] [int] NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[montoInversion] [decimal](15, 2) NOT NULL,
	[porcentajeParticipacion] [decimal](10, 6) NOT NULL,
	[montoDistribuido] [decimal](15, 2) NOT NULL,
	[pagoId] [int] NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
 CONSTRAINT [PK_voto_DistribucionDetalle] PRIMARY KEY CLUSTERED 
(
	[detalleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Distribution]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Distribution](
	[distributionId] [int] IDENTITY(1,1) NOT NULL,
	[enabled] [bit] NOT NULL,
	[checksum] [varbinary](200) NOT NULL,
	[pagoId] [nchar](10) NOT NULL,
	[hashSeguridad] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_Distribution] PRIMARY KEY CLUSTERED 
(
	[distributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DividendDistributionCycle]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DividendDistributionCycle](
	[cycleId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[montoTotalDistribuido] [decimal](15, 2) NOT NULL,
	[fechaDistribucion] [date] NOT NULL,
	[userIdEjecutor] [int] NOT NULL,
	[hashReporteGanancias] [varbinary](256) NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[estado] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_DividendDistributionCycle] PRIMARY KEY CLUSTERED 
(
	[cycleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocComentarios]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocComentarios](
	[comentarioId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocMedia]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocMedia](
	[mediafileId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocPagos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocPagos](
	[pagoId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocPropuesta]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocPropuesta](
	[propuestaId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocReportes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocReportes](
	[reporteId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocTrans]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocTrans](
	[transaccionId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocTypes](
	[docTypeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_voto_DocTypes] PRIMARY KEY CLUSTERED 
(
	[docTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocTypesPerProposalTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocTypesPerProposalTypes](
	[docTypesProposalId] [int] NOT NULL,
	[proposalTypeId] [int] NOT NULL,
	[documentTypeId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_voto_DocTypesProposalTypes] PRIMARY KEY CLUSTERED 
(
	[docTypesProposalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Documents]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Documents](
	[documentoId] [int] IDENTITY(1,1) NOT NULL,
	[nombreDocumento] [varchar](50) NOT NULL,
	[hashDocumento] [varbinary](150) NOT NULL,
	[usuarioSubio] [int] NOT NULL,
	[estadoId] [int] NOT NULL,
	[detalles] [varchar](200) NOT NULL,
	[lastUpdate] [datetime] NOT NULL,
	[version] [varchar](50) NOT NULL,
	[docTypeId] [int] NOT NULL,
	[mediaFileId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Documents] PRIMARY KEY CLUSTERED 
(
	[documentoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocVotacion](
	[votacionId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_DocXProposalType]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_DocXProposalType](
	[proposalTypeId] [int] NOT NULL,
	[documentTypeId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Educacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Educacion](
	[nivelEducacionId] [int] NOT NULL,
	[tipoEducacionId] [int] NOT NULL,
	[fechaGraduado] [datetime] NOT NULL,
 CONSTRAINT [PK_voto_Educacion] PRIMARY KEY CLUSTERED 
(
	[nivelEducacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Encriptacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Encriptacion](
	[encriptedId] [int] NOT NULL,
	[publicEncripted] [varbinary](170) NOT NULL,
	[privateEncrited] [varbinary](170) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_voto_Encriptacion] PRIMARY KEY CLUSTERED 
(
	[encriptedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_EstadisticasVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_EstadisticasVotacion](
	[estadisticaId] [int] IDENTITY(1,1) NOT NULL,
	[votacionId] [int] NOT NULL,
	[tipoEstadisticaId] [int] NOT NULL,
	[valor] [decimal](18, 4) NOT NULL,
	[fechaCalculo] [datetime] NOT NULL,
	[metadatos] [nvarchar](max) NULL,
	[hashCalculo] [varbinary](256) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_EstadisticasVotacion] PRIMARY KEY CLUSTERED 
(
	[estadisticaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Estado]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Estado](
	[estadoId] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_Estado] PRIMARY KEY CLUSTERED 
(
	[estadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_EstadoDoc]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_EstadoDoc](
	[estadoId] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_EstadoDoc] PRIMARY KEY CLUSTERED 
(
	[estadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Estados]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Estados](
	[estadoId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[descripcion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[estadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_EstadoSistema]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_EstadoSistema](
	[registroId] [int] IDENTITY(1,1) NOT NULL,
	[fechaHora] [datetime2](7) NOT NULL,
	[componente] [varchar](50) NOT NULL,
	[estado] [varchar](20) NOT NULL,
	[latencia] [int] NULL,
	[cargaCPU] [decimal](5, 2) NULL,
	[memoriaUsada] [decimal](5, 2) NULL,
	[alertas] [smallint] NOT NULL,
	[detalles] [nvarchar](max) NULL,
	[hashEstado] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Est__5CFD53CFA653DD6C] PRIMARY KEY CLUSTERED 
(
	[registroId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_EstadoUser]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_EstadoUser](
	[estadoId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_EstadoUser] PRIMARY KEY CLUSTERED 
(
	[estadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_EstadoVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_EstadoVotacion](
	[estadoId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_EstadoVotacion] PRIMARY KEY CLUSTERED 
(
	[estadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Features]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Features](
	[featureId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[value] [varchar](100) NOT NULL,
	[enabled] [bit] NOT NULL,
	[featureTypeId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Features] PRIMARY KEY CLUSTERED 
(
	[featureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_FeaturesTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_FeaturesTypes](
	[featureTypeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[enabled] [bit] NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_FeaturesTypes] PRIMARY KEY CLUSTERED 
(
	[featureTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_featuresXUser]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_featuresXUser](
	[featureId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_FeatureXSegmento]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_FeatureXSegmento](
	[featureId] [int] NOT NULL,
	[segmentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[value] [varchar](100) NOT NULL,
 CONSTRAINT [PK_voto_FeatureXSegmento] PRIMARY KEY CLUSTERED 
(
	[featureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_FirmasValidadores]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_FirmasValidadores](
	[firmaId] [int] NOT NULL,
	[validacionId] [int] NOT NULL,
	[validadorId] [int] NOT NULL,
	[fechaFirma] [datetime] NULL,
	[firmaDigital] [varchar](512) NULL,
	[estado] [varchar](20) NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Fir__1455FFC26BDD9A6E] PRIMARY KEY CLUSTERED 
(
	[firmaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Fiscalizaciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Fiscalizaciones](
	[fiscalizacionId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[fechaReporte] [datetime] NOT NULL,
	[descripcion] [varchar](1500) NOT NULL,
	[evidencia] [varchar](255) NULL,
	[hashEvidencia] [varbinary](256) NOT NULL,
	[estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK__voto_Fis__63C1CD69E2F25329] PRIMARY KEY CLUSTERED 
(
	[fiscalizacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_funds]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_funds](
	[fundId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_funds] PRIMARY KEY CLUSTERED 
(
	[fundId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_GruposAvaladores]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_GruposAvaladores](
	[grupoId] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[tipo] [varchar](50) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[porcentajeEquity] [decimal](5, 2) NULL,
	[honorarios] [decimal](15, 2) NULL,
	[condiciones] [varchar](1500) NULL,
	[userId] [int] NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK__voto_Gru__A0BD40DFCBA6365D] PRIMARY KEY CLUSTERED 
(
	[grupoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_HistorialIntereses]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_HistorialIntereses](
	[historialId] [int] IDENTITY(1,1) NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[tipoInteresId] [int] NULL,
	[tipoInversionId] [int] NULL,
	[descripcion] [varchar](1500) NULL,
	[fechaAccion] [datetime] NOT NULL,
	[metadata] [nvarchar](max) NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_HistorialIntereses] PRIMARY KEY CLUSTERED 
(
	[historialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_HistorialinteresesDoc]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_HistorialinteresesDoc](
	[historialId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_HitosPlanTrabajo]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_HitosPlanTrabajo](
	[hitoId] [int] IDENTITY(1,1) NOT NULL,
	[planId] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[fechaPrevista] [date] NOT NULL,
	[porcentajeAvance] [decimal](5, 2) NOT NULL,
	[fiscalizacionId] [int] NULL,
	[estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_voto_HitosPlanTrabajo] PRIMARY KEY CLUSTERED 
(
	[hitoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_IdentidadesDigitales]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_IdentidadesDigitales](
	[identidadId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[llavePublica] [varchar](512) NOT NULL,
	[llavePrivadaEncriptada] [varbinary](max) NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaExpiracion] [datetime] NOT NULL,
	[activa] [bit] NOT NULL,
	[ultimoUso] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[identidadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Instituciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Instituciones](
	[institucionId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](60) NOT NULL,
	[creationDate] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL,
	[adressId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[fechaUltimaValidacion] [datetime] NULL,
	[estadoValidacion] [varchar](20) NOT NULL,
	[hashConstitutiva] [varbinary](268) NOT NULL,
	[tipoInstitucionId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Instituciones] PRIMARY KEY CLUSTERED 
(
	[institucionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_institucionesDoc]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_institucionesDoc](
	[documentoId] [int] NOT NULL,
	[institucionId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_InstitucionRepresentantes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_InstitucionRepresentantes](
	[representanteId] [int] IDENTITY(1,1) NOT NULL,
	[institucionId] [int] NOT NULL,
	[personId] [int] NOT NULL,
	[fechaInicio] [date] NOT NULL,
	[fechaFin] [date] NULL,
	[documentoRepresentacionId] [int] NULL,
	[activo] [bit] NOT NULL,
	[tipoRepresentanteId] [int] NOT NULL,
	[hashRepresentante] [varbinary](250) NULL,
 CONSTRAINT [PK_voto_InstitucionRepresentantes] PRIMARY KEY CLUSTERED 
(
	[representanteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_intereses]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_intereses](
	[interesId] [int] NOT NULL,
	[tasa] [decimal](10, 4) NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[tipoInteresId] [int] NOT NULL,
 CONSTRAINT [PK_voto_intereses] PRIMARY KEY CLUSTERED 
(
	[interesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_InversionDocumentos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_InversionDocumentos](
	[documentoId] [int] NOT NULL,
	[inversionId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Inversiones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Inversiones](
	[inversionId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[monto] [decimal](15, 2) NOT NULL,
	[fechaInversion] [datetime] NOT NULL,
	[metodoPago] [varchar](50) NOT NULL,
	[comprobantePago] [varchar](100) NULL,
	[hashTransaccion] [varchar](256) NULL,
	[estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK__voto_Inv__C85E5C53A6501F03] PRIMARY KEY CLUSTERED 
(
	[inversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_InversionistaBalance]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_InversionistaBalance](
	[personBalanceId] [int] NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[balance] [float] NOT NULL,
	[lastBalance] [float] NOT NULL,
	[checksum] [varbinary](200) NOT NULL,
	[frezeAmount] [float] NOT NULL,
	[fundId] [int] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_InversionistaBalance] PRIMARY KEY CLUSTERED 
(
	[personBalanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Inversionistas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Inversionistas](
	[inversionistaId] [int] IDENTITY(1,1) NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[montoMaximoInversion] [decimal](15, 2) NULL,
	[experiencia] [varchar](100) NULL,
	[acreditado] [bit] NOT NULL,
	[fechaAcreditacion] [datetime] NULL,
	[hashCertificacion] [varbinary](256) NULL,
	[estado] [varchar](20) NOT NULL,
	[inversionId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Inversionistas] PRIMARY KEY CLUSTERED 
(
	[inversionistaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_IPsPermitidas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_IPsPermitidas](
	[ipId] [int] NOT NULL,
	[rangoInicio] [varchar](45) NOT NULL,
	[rangoFin] [varchar](45) NULL,
	[paisId] [int] NULL,
	[descripcion] [varchar](100) NULL,
	[activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ItemsDesembolso]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ItemsDesembolso](
	[itemId] [int] NOT NULL,
	[planId] [int] NOT NULL,
	[numeroMes] [int] NOT NULL,
	[concepto] [varchar](100) NOT NULL,
	[monto] [decimal](15, 2) NOT NULL,
	[condiciones] [varchar](1500) NULL,
 CONSTRAINT [PK__voto_Ite__56A128AA7C6DFA5A] PRIMARY KEY CLUSTERED 
(
	[itemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Languages]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Languages](
	[languageId] [int] NOT NULL,
	[name] [varchar](30) NOT NULL,
	[culture] [varchar](5) NOT NULL,
	[countryId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Languages] PRIMARY KEY CLUSTERED 
(
	[languageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Log]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Log](
	[logId] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](500) NOT NULL,
	[postTime] [datetime] NOT NULL,
	[computer] [varchar](45) NOT NULL,
	[username] [varchar](45) NOT NULL,
	[trace] [varchar](1500) NULL,
	[reference1] [bigint] NULL,
	[reference2] [bigint] NULL,
	[value1] [bigint] NULL,
	[value2] [bigint] NULL,
	[checksum] [varbinary](250) NULL,
 CONSTRAINT [PK_voto_Log] PRIMARY KEY CLUSTERED 
(
	[logId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_LogIn]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_LogIn](
	[logInId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[intentosFallidos] [int] NOT NULL,
	[estadoId] [int] NOT NULL,
	[dispositivoId] [int] NOT NULL,
	[fechaAcceso] [datetime] NOT NULL,
 CONSTRAINT [PK_voto_LogIn] PRIMARY KEY CLUSTERED 
(
	[logInId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_LogSeverity]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_LogSeverity](
	[logSeverityId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[logId] [int] NOT NULL,
 CONSTRAINT [PK_voto_LogSeverity] PRIMARY KEY CLUSTERED 
(
	[logSeverityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_LogSources]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_LogSources](
	[logSourceId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[logId] [int] NOT NULL,
 CONSTRAINT [PK_voto_LogSources] PRIMARY KEY CLUSTERED 
(
	[logSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_LogTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_LogTypes](
	[logTypeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[ref1Desc] [varchar](50) NULL,
	[ref2Desc] [varchar](50) NULL,
	[val1Desc] [varchar](50) NULL,
	[val2Desc] [varchar](50) NULL,
	[logId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_MediaFiles]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_MediaFiles](
	[mediaFileId] [int] IDENTITY(1,1) NOT NULL,
	[url] [varchar](100) NOT NULL,
	[deleted] [bit] NOT NULL,
	[reference] [varchar](250) NOT NULL,
	[generationDate] [datetime] NOT NULL,
	[mediaTypeId] [int] NOT NULL,
	[version] [varchar](100) NOT NULL,
 CONSTRAINT [PK_voto_MediaFiles] PRIMARY KEY CLUSTERED 
(
	[mediaFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_MediaTypes]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_MediaTypes](
	[mediaTypeId] [int] NOT NULL,
	[name] [varchar](30) NOT NULL,
	[playerImp] [varchar](60) NOT NULL,
 CONSTRAINT [PK_voto_MediaTypes] PRIMARY KEY CLUSTERED 
(
	[mediaTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_MediosDisponibles]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_MediosDisponibles](
	[pagoMedioId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[token] [varbinary](129) NOT NULL,
	[expTokenDate] [date] NOT NULL,
	[maskAccount] [varchar](45) NOT NULL,
	[callbackURLget] [varchar](100) NOT NULL,
	[callBackPost] [varchar](100) NOT NULL,
	[callBackRedirect] [varchar](100) NOT NULL,
	[metodoPagoId] [int] NOT NULL,
	[configurationJson] [varchar](max) NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_voto_MediosDisponibles] PRIMARY KEY CLUSTERED 
(
	[pagoMedioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_MetodosDePago]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_MetodosDePago](
	[metodoPagoId] [int] NOT NULL,
	[name] [varchar](30) NOT NULL,
	[apiuRL] [varchar](60) NOT NULL,
	[secretKey] [varbinary](250) NOT NULL,
	[llave] [varbinary](128) NOT NULL,
	[logoIconURL] [varchar](50) NULL,
	[enabled] [bit] NOT NULL,
	[templateJSON] [varchar](max) NULL,
 CONSTRAINT [PK_voto_MetodosDePago] PRIMARY KEY CLUSTERED 
(
	[metodoPagoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Modules]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Modules](
	[moduleId] [int] NOT NULL,
	[name] [varchar](40) NOT NULL,
	[languajeId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Modules] PRIMARY KEY CLUSTERED 
(
	[moduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_notificationMedia]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_notificationMedia](
	[notificationMediaId] [int] NOT NULL,
	[name] [varchar](45) NOT NULL,
 CONSTRAINT [PK_voto_notificationMedia] PRIMARY KEY CLUSTERED 
(
	[notificationMediaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Notifications]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Notifications](
	[notificationId] [int] NOT NULL,
	[sentDate] [datetime] NOT NULL,
	[title] [varchar](100) NOT NULL,
	[description] [varchar](200) NULL,
	[notificationStatusId] [int] NOT NULL,
	[notificationMediaId] [int] NOT NULL,
	[receiveUserId] [int] NOT NULL,
	[sendUserId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Notifications] PRIMARY KEY CLUSTERED 
(
	[notificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_NotificationStatus]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_NotificationStatus](
	[notificationStatusId] [int] NOT NULL,
	[name] [varchar](45) NOT NULL,
 CONSTRAINT [PK_voto_NotificationStatus] PRIMARY KEY CLUSTERED 
(
	[notificationStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_OpcionesVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_OpcionesVotacion](
	[opcionId] [int] NOT NULL,
	[votacionId] [int] NOT NULL,
	[tokenCifrado] [varbinary](250) NOT NULL,
	[display] [varchar](1500) NOT NULL,
	[URL] [varchar](50) NOT NULL,
	[value] [varchar](50) NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK__voto_Opc__232CF501D3F7E476] PRIMARY KEY CLUSTERED 
(
	[opcionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PagoInversiones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PagoInversiones](
	[pagoInversionId] [int] NOT NULL,
	[inversionId] [int] NOT NULL,
	[distributionId] [int] NOT NULL,
	[scheduleId] [int] NOT NULL,
 CONSTRAINT [PK_voto_PagoInversiones] PRIMARY KEY CLUSTERED 
(
	[pagoInversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Pagos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Pagos](
	[pagoId] [int] IDENTITY(1,1) NOT NULL,
	[pagoMedioId] [int] NOT NULL,
	[metodoPagoId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[inversionId] [int] NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[monto] [float] NOT NULL,
	[actualMonto] [float] NOT NULL,
	[result] [varbinary](300) NOT NULL,
	[auth] [varbinary](200) NOT NULL,
	[error] [varchar](50) NOT NULL,
	[fecha] [date] NOT NULL,
	[checksum] [varbinary](200) NOT NULL,
	[exchangeRate] [float] NOT NULL,
	[convertedAmount] [float] NOT NULL,
	[moduleId] [int] NOT NULL,
	[currencyId] [int] NOT NULL,
	[scheduleId] [int] NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Pag__5736FC0CCA7D56C1] PRIMARY KEY CLUSTERED 
(
	[pagoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PapeletaAuditoria]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PapeletaAuditoria](
	[auditoriaId] [int] IDENTITY(1,1) NOT NULL,
	[papeletaId] [int] NOT NULL,
	[accion] [varchar](50) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[fechaHora] [datetime] NOT NULL,
	[direccionIP] [varchar](45) NULL,
	[dispositivoId] [int] NULL,
	[detalles] [nvarchar](max) NULL,
	[hashContenido] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_PapeletaAuditoria] PRIMARY KEY CLUSTERED 
(
	[auditoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PapeletaOpciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PapeletaOpciones](
	[opcionId] [int] IDENTITY(1,1) NOT NULL,
	[seccionId] [int] NOT NULL,
	[orden] [int] NOT NULL,
	[codigo] [varchar](20) NOT NULL,
	[texto] [varchar](500) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[Abstencion] [bit] NOT NULL,
	[Nulo] [bit] NOT NULL,
	[valor] [varchar](100) NULL,
	[metadata] [nvarchar](max) NULL,
	[hashContenido] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_PapeletaOpciones] PRIMARY KEY CLUSTERED 
(
	[opcionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PapeletaPlantillas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PapeletaPlantillas](
	[plantillaId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[contenidoHtml] [varchar](1500) NULL,
	[estilosCss] [varchar](1500) NULL,
	[parametros] [nvarchar](max) NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[esPublica] [bit] NOT NULL,
	[version] [int] NOT NULL,
 CONSTRAINT [PK_voto_PapeletaPlantillas] PRIMARY KEY CLUSTERED 
(
	[plantillaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Papeletas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Papeletas](
	[papeletaId] [int] IDENTITY(1,1) NOT NULL,
	[votacionId] [int] NOT NULL,
	[codigo] [varchar](50) NOT NULL,
	[descripcion] [text] NULL,
	[instrucciones] [text] NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[hashContenido] [varbinary](256) NOT NULL,
	[firmaDigital] [varchar](512) NULL,
	[estado] [varchar](20) NOT NULL,
	[version] [int] NOT NULL,
	[plantillaId] [int] NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_Papeletas] PRIMARY KEY CLUSTERED 
(
	[papeletaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_voto_Papeletas_codigo] UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PapeletaSecciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PapeletaSecciones](
	[seccionId] [int] IDENTITY(1,1) NOT NULL,
	[papeletaId] [int] NOT NULL,
	[orden] [int] NOT NULL,
	[titulo] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[instrucciones] [varchar](1500) NULL,
	[minSelecciones] [int] NOT NULL,
	[maxSelecciones] [int] NOT NULL,
	[esObligatoria] [bit] NOT NULL,
	[tipoSeccionId] [int] NOT NULL,
 CONSTRAINT [PK_voto_PapeletaSecciones] PRIMARY KEY CLUSTERED 
(
	[seccionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_partnerDealBenefits]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_partnerDealBenefits](
	[partnerDealBenefitsId] [int] NOT NULL,
	[partnerDealId] [int] NOT NULL,
	[dealBenefitTypeId] [int] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NULL,
	[limit] [int] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_partnerDealBenefits] PRIMARY KEY CLUSTERED 
(
	[partnerDealBenefitsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PartnerDeals]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PartnerDeals](
	[partnerDealId] [int] NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[sealDate] [date] NOT NULL,
	[isActive] [bit] NOT NULL,
	[dealDescription] [text] NOT NULL,
 CONSTRAINT [PK_voto_PartnerDeals] PRIMARY KEY CLUSTERED 
(
	[partnerDealId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PartnerObligations]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PartnerObligations](
	[partnerObligationId] [int] NOT NULL,
	[pledgedAmount] [decimal](16, 2) NULL,
	[currencyId] [int] NULL,
	[minValue] [int] NULL,
	[minValueDsc] [int] NULL,
	[isActive] [bit] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NULL,
	[obligationDesc] [varchar](100) NOT NULL,
	[partnerDealId] [int] NOT NULL,
	[lastUpdate] [date] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_PartnerObligations] PRIMARY KEY CLUSTERED 
(
	[partnerObligationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PartnerObligationStorage]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PartnerObligationStorage](
	[storageId] [int] NOT NULL,
	[partnerObligationId] [int] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_PartnerObligationStorage] PRIMARY KEY CLUSTERED 
(
	[storageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Permissions]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Permissions](
	[permissionId] [int] NOT NULL,
	[description] [varchar](150) NOT NULL,
	[code] [varchar](10) NOT NULL,
	[moduleId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Permissions] PRIMARY KEY CLUSTERED 
(
	[permissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Personas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Personas](
	[personId] [int] NOT NULL,
	[firstName] [varchar](45) NOT NULL,
	[lastName] [varchar](50) NOT NULL,
	[birthDate] [date] NOT NULL,
	[sexoId] [int] NOT NULL,
	[educaciónid] [int] NOT NULL,
	[countryId] [int] NULL,
	[profesionId] [int] NOT NULL,
	[fechaUltimaValidacion] [datetime] NULL,
	[estadoValidacion] [varchar](20) NOT NULL,
	[hashIdentidad] [varchar](256) NULL,
 CONSTRAINT [PK_voto_Personas] PRIMARY KEY CLUSTERED 
(
	[personId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PesoSegunSegmentoYVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PesoSegunSegmentoYVotacion](
	[pesoId] [int] NOT NULL,
	[votacionId] [int] NOT NULL,
	[segmentoId] [int] NOT NULL,
	[pesovoto] [float] NOT NULL,
 CONSTRAINT [PK_voto_PeroSegunTarget] PRIMARY KEY CLUSTERED 
(
	[pesoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PlanesDesembolso]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PlanesDesembolso](
	[planId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[version] [int] NOT NULL,
	[fechaAprobacion] [datetime] NULL,
	[userIdAprobacion] [int] NULL,
	[hashDocumento] [varchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[planId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PlanesTrabajo]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PlanesTrabajo](
	[planId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[version] [int] NOT NULL,
	[fechaInicio] [date] NOT NULL,
	[duracionMeses] [int] NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[fechaAprobacion] [datetime] NULL,
	[hashDocumento] [varbinary](256) NULL,
	[estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK_voto_PlanesTrabajo] PRIMARY KEY CLUSTERED 
(
	[planId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PoliticasAcceso]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PoliticasAcceso](
	[politicaId] [int] NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](500) NULL,
	[nivelSeguridadRequerido] [int] NOT NULL,
	[requiereMFA] [bit] NOT NULL,
	[requiereBiometrico] [bit] NOT NULL,
	[horaInicioAcceso] [datetime] NULL,
	[horaFinAcceso] [datetime] NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK__voto_Pol__83971CC4AF8715C5] PRIMARY KEY CLUSTERED 
(
	[politicaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PreferenciasInversion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PreferenciasInversion](
	[preferenciaId] [int] IDENTITY(1,1) NOT NULL,
	[inversionistaId] [int] NOT NULL,
	[tipoInversionId] [int] NOT NULL,
	[montoMinimo] [decimal](15, 2) NULL,
	[montoMaximo] [decimal](15, 2) NULL,
	[monedaPreferida] [int] NULL,
	[fechaActualizacion] [datetime] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_PreferenciasInversion] PRIMARY KEY CLUSTERED 
(
	[preferenciaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ProcesosManuales]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ProcesosManuales](
	[procesoId] [int] NOT NULL,
	[tipoProceso] [varchar](50) NOT NULL,
	[estado] [varchar](20) NOT NULL,
	[fechaCreacion] [datetime2](7) NOT NULL,
	[userId] [int] NOT NULL,
	[fechaCierre] [datetime2](7) NULL,
	[resultado] [varchar](20) NULL,
	[comentarios] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[procesoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Profesion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Profesion](
	[profesionId] [int] NOT NULL,
	[tipoProfesionId] [int] NOT NULL,
	[fechaInicio] [datetime] NOT NULL,
	[fechaFin] [datetime] NULL,
 CONSTRAINT [PK_voto_Profesion] PRIMARY KEY CLUSTERED 
(
	[profesionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ProposalType]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ProposalType](
	[proposalTypeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[detalles] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_ProposalType] PRIMARY KEY CLUSTERED 
(
	[proposalTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_propuestaImpact]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_propuestaImpact](
	[propuestaId] [int] NOT NULL,
	[segmentoId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Propuestas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Propuestas](
	[propuestaId] [int] IDENTITY(1,1) NOT NULL,
	[titulo] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[resumenEjecutivo] [varchar](1500) NULL,
	[userId] [int] NOT NULL,
	[estadoId] [int] NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaPublicacion] [datetime] NULL,
	[fechaCierre] [datetime] NULL,
	[hashDocumentacion] [varbinary](250) NULL,
	[hashContenido] [varbinary](250) NULL,
	[proposalTypeId] [int] NOT NULL,
	[institucionId] [int] NULL,
 CONSTRAINT [PK__voto_Pro__01294C12967C5864] PRIMARY KEY CLUSTERED 
(
	[propuestaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_propuestaSegmentos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_propuestaSegmentos](
	[segmentoId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PruebasMedia]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PruebasMedia](
	[pruebaId] [int] NOT NULL,
	[mediaFileId] [int] NOT NULL,
	[uploadTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_PruebasVida]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_PruebasVida](
	[pruebaId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[tipo] [varchar](30) NOT NULL,
	[fechaPrueba] [datetime] NOT NULL,
	[resultado] [bit] NOT NULL,
	[scoreConfianza] [decimal](5, 2) NULL,
	[dispositivoId] [int] NULL,
	[adrees] [geography] NULL,
	[tipoPruebasVidaId] [int] NOT NULL,
	[cantidad] [int] NOT NULL,
 CONSTRAINT [PK__voto_Pru__64DBA470728C3F1D] PRIMARY KEY CLUSTERED 
(
	[pruebaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_questions]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_questions](
	[questionId] [int] NOT NULL,
	[displayText] [varchar](1500) NOT NULL,
	[limite] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[questionTypeId] [int] NOT NULL,
 CONSTRAINT [PK_voto_questions] PRIMARY KEY CLUSTERED 
(
	[questionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_questionType]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_questionType](
	[questionTyoeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_questionType] PRIMARY KEY CLUSTERED 
(
	[questionTyoeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_recaudacionFondos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_recaudacionFondos](
	[recaudacionId] [int] NOT NULL,
	[inversionId] [int] NOT NULL,
	[metaFinanciamiento] [decimal](15, 2) NOT NULL,
	[minimoFinanciamiento] [decimal](15, 2) NOT NULL,
	[fondosRecaudados] [decimal](15, 2) NOT NULL,
	[hashContenido] [varbinary](150) NOT NULL,
 CONSTRAINT [PK_voto_recaudacionFondos] PRIMARY KEY CLUSTERED 
(
	[recaudacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_RegistroBiometrico]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_RegistroBiometrico](
	[biometricoId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[tipoBiometricoId] [int] NOT NULL,
	[template] [varbinary](max) NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[fechaActualizacion] [datetime] NULL,
	[scoreCalidad] [decimal](5, 2) NULL,
	[biometricErrorId] [int] NULL,
	[hasRegistro] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Reg__627AE283E00EA1C9] PRIMARY KEY CLUSTERED 
(
	[biometricoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ReglasDecision]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ReglasDecision](
	[reglaId] [int] NOT NULL,
	[votacionId] [int] NOT NULL,
	[tipo] [varchar](30) NOT NULL,
	[valor] [decimal](5, 2) NOT NULL,
	[descripcion] [varchar](200) NULL,
	[hashReglas] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Reg__416412BC47E25193] PRIMARY KEY CLUSTERED 
(
	[reglaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ReglasVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ReglasVotacion](
	[reglaId] [int] NOT NULL,
	[votacionId] [int] NOT NULL,
	[tipoReglaId] [int] NOT NULL,
	[cantidad] [int] NOT NULL,
	[manejoInstru] [xml] NOT NULL,
	[fechaInicio] [datetime] NOT NULL,
	[fechaFin] [datetime] NOT NULL,
 CONSTRAINT [PK__voto_Reg__416412BC14C8F5F5] PRIMARY KEY CLUSTERED 
(
	[reglaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Renewal]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Renewal](
	[renewalId] [int] NOT NULL,
	[partnerDealId] [int] NOT NULL,
	[confirmation] [bit] NOT NULL,
	[estadoId] [int] NOT NULL,
	[startDate] [date] NOT NULL,
	[endDate] [date] NULL,
	[sealDate] [date] NOT NULL,
 CONSTRAINT [PK_voto_Renewal] PRIMARY KEY CLUSTERED 
(
	[renewalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ReplicasVotos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ReplicasVotos](
	[replicaId] [int] IDENTITY(1,1) NOT NULL,
	[votoId] [int] NOT NULL,
	[datosEncriptados] [varbinary](max) NOT NULL,
	[hashOriginal] [varchar](512) NOT NULL,
	[fechaReplica] [datetime2](7) NOT NULL,
	[nodoDestino] [varchar](100) NOT NULL,
	[estado] [varchar](20) NOT NULL,
 CONSTRAINT [PK__voto_Rep__B69ADF88AF842892] PRIMARY KEY CLUSTERED 
(
	[replicaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ReportesFinancieros]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ReportesFinancieros](
	[reporteId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[periodo] [varchar](20) NOT NULL,
	[fechaInicio] [date] NOT NULL,
	[fechaFin] [date] NOT NULL,
	[urlDocumento] [varchar](255) NOT NULL,
	[hashDocumento] [varchar](256) NOT NULL,
	[fechaSubida] [datetime] NOT NULL,
	[userId] [int] NOT NULL,
	[estadoId] [int] NOT NULL,
 CONSTRAINT [PK__voto_Rep__771E4C01B14FFC7B] PRIMARY KEY CLUSTERED 
(
	[reporteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_RepresentanteDoc]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_RepresentanteDoc](
	[representanteId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_RequisitosDocumentos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_RequisitosDocumentos](
	[requisitoId] [int] NOT NULL,
	[tipoVotacionId] [int] NOT NULL,
	[tipoDocumento] [varchar](50) NOT NULL,
	[obligatorio] [bit] NOT NULL,
	[descripcion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[requisitoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ResultadoPropuestas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ResultadoPropuestas](
	[resultadoId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NOT NULL,
	[decisionCifrada] [varbinary](500) NOT NULL,
	[fechaRegistro] [datetime] NULL,
	[votoId] [int] NOT NULL,
 CONSTRAINT [PK__voto_Res__008B853766D3DBB8] PRIMARY KEY CLUSTERED 
(
	[resultadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ResultadosPropuestas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ResultadosPropuestas](
	[resultadoPropuestaId] [int] IDENTITY(1,1) NOT NULL,
	[propuestaId] [int] NULL,
	[votoId] [int] NULL,
	[decisionCifrada] [varbinary](200) NULL,
	[fechaRegistro] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[resultadoPropuestaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[votoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Roles]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Roles](
	[roleId] [int] NOT NULL,
	[name] [varchar](30) NOT NULL,
 CONSTRAINT [PK_voto_Roles] PRIMARY KEY CLUSTERED 
(
	[roleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_RolPoliticasAcceso]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_RolPoliticasAcceso](
	[asignacionId] [int] NOT NULL,
	[roleId] [int] NOT NULL,
	[politicaId] [int] NOT NULL,
	[fechaAsignacion] [datetime] NOT NULL,
	[userId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[asignacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ScheduleDetails]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ScheduleDetails](
	[scheduleDetailid] [int] NOT NULL,
	[deleted] [bit] NOT NULL,
	[baseDate] [date] NOT NULL,
	[datePart] [date] NOT NULL,
	[lastExecution] [datetime] NULL,
	[nextExecution] [datetime] NULL,
	[scheduleId] [int] NOT NULL,
 CONSTRAINT [PK_voto_ScheduleDetails] PRIMARY KEY CLUSTERED 
(
	[scheduleDetailid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Schedules]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Schedules](
	[scheduleId] [int] NOT NULL,
	[name] [varchar](45) NOT NULL,
	[recurrencyType] [int] NOT NULL,
	[repeat] [bit] NOT NULL,
 CONSTRAINT [PK_voto_Schedules] PRIMARY KEY CLUSTERED 
(
	[scheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Segmentos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Segmentos](
	[segmentoId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_Segmentos] PRIMARY KEY CLUSTERED 
(
	[segmentoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_SegmentosAVotos]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_SegmentosAVotos](
	[segmentoId] [int] NOT NULL,
	[votoId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Sexo]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Sexo](
	[sexoId] [int] NOT NULL,
	[description] [varchar](20) NOT NULL,
 CONSTRAINT [PK_voto_Sexo] PRIMARY KEY CLUSTERED 
(
	[sexoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_SignUp]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_SignUp](
	[signUpId] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[contrasena] [varbinary](250) NOT NULL,
	[dispositivoId] [int] NOT NULL,
	[fechaRegistro] [datetime] NOT NULL,
	[estadoId] [int] NOT NULL,
 CONSTRAINT [PK_voto_SignUp] PRIMARY KEY CLUSTERED 
(
	[signUpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_States]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_States](
	[stateId] [int] NOT NULL,
	[name] [varchar](60) NOT NULL,
	[countryId] [int] NOT NULL,
 CONSTRAINT [PK_voto_States] PRIMARY KEY CLUSTERED 
(
	[stateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoBiometricError]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoBiometricError](
	[tipoBiometricErrorId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_voto_TipoBiometricError] PRIMARY KEY CLUSTERED 
(
	[tipoBiometricErrorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoBiometrico]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoBiometrico](
	[tipoBiomettricoId] [int] NOT NULL,
	[name] [varchar](40) NOT NULL,
	[description] [varchar](80) NOT NULL,
 CONSTRAINT [PK_voto_TipoBiometrico] PRIMARY KEY CLUSTERED 
(
	[tipoBiomettricoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoCedula]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoCedula](
	[tipoCedulaId] [int] NOT NULL,
	[name] [varchar](30) NOT NULL,
	[description] [varchar](30) NOT NULL,
	[hashIdentificacion] [varbinary](128) NOT NULL,
 CONSTRAINT [PK_voto_TipoCedula] PRIMARY KEY CLUSTERED 
(
	[tipoCedulaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoComentario]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoComentario](
	[tipoComentarioId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_TipoComentario] PRIMARY KEY CLUSTERED 
(
	[tipoComentarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_tipoEducacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_tipoEducacion](
	[tipoEducacionId] [int] NOT NULL,
	[name] [varchar](20) NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_tipoEducacion] PRIMARY KEY CLUSTERED 
(
	[tipoEducacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoEstadistica]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoEstadistica](
	[tipoEstadisticaId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_TipoEstadistica] PRIMARY KEY CLUSTERED 
(
	[tipoEstadisticaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoInstitucion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoInstitucion](
	[tipoInstitucioneId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
	[sector] [varchar](30) NOT NULL,
 CONSTRAINT [PK_voto_TipoInstitucion] PRIMARY KEY CLUSTERED 
(
	[tipoInstitucioneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_tipoProfesion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_tipoProfesion](
	[tipoProfesionId] [int] NOT NULL,
	[name] [varchar](20) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_tipoProfesion] PRIMARY KEY CLUSTERED 
(
	[tipoProfesionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoPropuesta]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoPropuesta](
	[tipoPropuestaId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NULL,
	[descripcion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[tipoPropuestaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_tipoPruebasVida]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_tipoPruebasVida](
	[tipoPruebasVidaId] [int] NOT NULL,
	[name] [varchar](40) NOT NULL,
	[descripcion] [varchar](80) NOT NULL,
 CONSTRAINT [PK_voto_tipoPruebasVida] PRIMARY KEY CLUSTERED 
(
	[tipoPruebasVidaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoPublicaciones]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoPublicaciones](
	[tipoPublicacionId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_TipoPublicaciones] PRIMARY KEY CLUSTERED 
(
	[tipoPublicacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoRepresentante]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoRepresentante](
	[tipoRepresentanteId] [int] NOT NULL,
	[name] [varchar](30) NOT NULL,
	[description] [int] NOT NULL,
	[tipoCedulaId] [int] NOT NULL,
 CONSTRAINT [PK_voto_TipoRepresentante] PRIMARY KEY CLUSTERED 
(
	[tipoRepresentanteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TiposDeReglas]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TiposDeReglas](
	[tipoReglaId] [int] NOT NULL,
	[name] [varchar](200) NOT NULL,
	[descripcion] [varchar](200) NOT NULL,
 CONSTRAINT [PK_voto_TiposDeReglas] PRIMARY KEY CLUSTERED 
(
	[tipoReglaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoSeccion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoSeccion](
	[tipoSeccionId] [int] NOT NULL,
	[name] [varchar](40) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_TipoSeccion] PRIMARY KEY CLUSTERED 
(
	[tipoSeccionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TiposIntereses]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TiposIntereses](
	[tipoInteresId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[esSectorEconomico] [bit] NOT NULL,
	[codigoClasificacion] [varchar](20) NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_voto_TiposIntereses] PRIMARY KEY CLUSTERED 
(
	[tipoInteresId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TiposInversion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TiposInversion](
	[tipoInversionId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[caracteristicas] [varchar](1500) NULL,
	[liquidez] [varchar](50) NULL,
	[activo] [bit] NOT NULL,
 CONSTRAINT [PK_voto_TiposInversion] PRIMARY KEY CLUSTERED 
(
	[tipoInversionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TiposPropuesta]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TiposPropuesta](
	[tipoPropuestaId] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[descripcion] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[tipoPropuestaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TiposVotacion]    Script Date: 24/6/2025 16:54:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TiposVotacion](
	[tipoVotacionId] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[descripcion] [varchar](200) NULL,
	[documentacion] [bit] NOT NULL,
	[validacion] [bit] NOT NULL,
	[minValidadores] [int] NULL,
	[maxValidadores] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[tipoVotacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_TipoUser]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_TipoUser](
	[tipoUserId] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_TipoUser] PRIMARY KEY CLUSTERED 
(
	[tipoUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Transacciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Transacciones](
	[transaccionId] [int] NOT NULL,
	[description] [varchar](160) NOT NULL,
	[tranDateTime] [datetime] NOT NULL,
	[postTime] [datetime] NOT NULL,
	[pagoId] [int] NULL,
	[refNumber] [varchar](50) NULL,
	[inversionistaId] [int] NULL,
	[transTypeId] [int] NOT NULL,
	[inversionistaBalanceId] [int] NOT NULL,
	[hashTrans] [varbinary](250) NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
 CONSTRAINT [PK_voto_Transacciones] PRIMARY KEY CLUSTERED 
(
	[transaccionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_translations]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_translations](
	[translationId] [int] NOT NULL,
	[code] [varchar](5) NOT NULL,
	[caption] [varchar](100) NOT NULL,
	[enabled] [bit] NOT NULL,
	[languajeId] [int] NOT NULL,
 CONSTRAINT [PK_voto_translations] PRIMARY KEY CLUSTERED 
(
	[translationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_transTypes]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_transTypes](
	[transTypeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_voto_transTypes] PRIMARY KEY CLUSTERED 
(
	[transTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_UserAdresses]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_UserAdresses](
	[enabled] [bit] NOT NULL,
	[userId] [int] NOT NULL,
	[adressId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_UserDocs]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_UserDocs](
	[userId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_UserMediaFiles]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_UserMediaFiles](
	[userId] [int] NOT NULL,
	[mediaFileId] [int] NOT NULL,
	[uploadTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_UserPermissions]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_UserPermissions](
	[userPermissionId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[deleted] [bit] NULL,
	[lastUpdate] [datetime] NOT NULL,
	[username] [varchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[permissionId] [int] NOT NULL,
	[userId] [int] NOT NULL,
 CONSTRAINT [PK_voto_UserPermissions] PRIMARY KEY CLUSTERED 
(
	[userPermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_UserRoles]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_UserRoles](
	[lastUpdate] [datetime] NOT NULL,
	[username] [varchar](50) NOT NULL,
	[checksum] [varbinary](250) NOT NULL,
	[enabled] [bit] NOT NULL,
	[deleted] [bit] NOT NULL,
	[userId] [int] NOT NULL,
	[roleId] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Users]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Users](
	[userId] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[contrasena] [varbinary](200) NOT NULL,
	[enabled] [bit] NOT NULL,
	[fechaUltimaAutenticacion] [datetime] NULL,
	[nivelSeguridad] [int] NOT NULL,
	[requiereRevalidacion] [bit] NOT NULL,
	[fechaExpiracionCuenta] [datetime] NULL,
	[fechaExpiracionCredenciales] [datetime2](7) NULL,
	[cuentaBloqueada] [bit] NOT NULL,
	[ultimoCambioCredenciales] [datetime2](7) NULL,
	[tipoUserId] [int] NOT NULL,
	[signUpId] [int] NOT NULL,
	[comparticionId] [int] NOT NULL,
 CONSTRAINT [PK_voto_Users] PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_ValidacionesGrupales]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_ValidacionesGrupales](
	[validacionId] [int] NOT NULL,
	[documentoId] [int] NOT NULL,
	[minimoAprobaciones] [int] NOT NULL,
	[estado] [varchar](20) NOT NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaCierre] [datetime] NULL,
	[hashContenido] [varbinary](250) NOT NULL,
 CONSTRAINT [PK__voto_Val__37D3AC83BFCE5744] PRIMARY KEY CLUSTERED 
(
	[validacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Votaciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Votaciones](
	[votacionId] [int] NOT NULL,
	[titulo] [varchar](100) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[fechaInicio] [datetime] NOT NULL,
	[fechaFin] [datetime] NOT NULL,
	[esPublica] [bit] NOT NULL,
	[esPrivada] [bit] NOT NULL,
	[esSecreta] [bit] NOT NULL,
	[tipoVotacionId] [int] NOT NULL,
	[creadorId] [int] NOT NULL,
	[institucionId] [int] NULL,
	[estadoId] [int] NOT NULL,
	[hashSeguridad] [varbinary](250) NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[diasNotificacionPrevia] [int] NULL,
	[notificationId] [int] NULL,
	[hashConfiguracion] [varbinary](512) NULL,
	[firmaConfiguracion] [varchar](512) NULL,
	[minimoParticipantes] [int] NULL,
	[propuestaId] [int] NOT NULL,
	[tarjetId] [int] NULL,
	[restriccionIp] [bit] NOT NULL,
	[restriccionPais] [bit] NOT NULL,
	[questionId] [int] NOT NULL,
 CONSTRAINT [PK__voto_Vot__F9F1A43BE7691FC1] PRIMARY KEY CLUSTERED 
(
	[votacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_VotacionesApoyo]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_VotacionesApoyo](
	[votacionApoyoId] [int] NOT NULL,
	[propuestaId] [int] NOT NULL,
	[tipoApoyo] [varchar](50) NOT NULL,
	[descripcion] [varchar](1500) NULL,
	[votacionId] [int] NOT NULL,
	[resultado] [varchar](20) NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaCierre] [datetime] NULL,
	[hashContenido] [varbinary](250) NULL,
 CONSTRAINT [PK__voto_Vot__263B05D24D9E9EE4] PRIMARY KEY CLUSTERED 
(
	[votacionApoyoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_VotacionesFiscalizacion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_VotacionesFiscalizacion](
	[votacionFiscalizacionId] [int] NOT NULL,
	[fiscalizacionId] [int] NOT NULL,
	[votacionId] [int] NOT NULL,
	[resultado] [varchar](20) NULL,
	[fechaCreacion] [datetime] NOT NULL,
	[fechaCierre] [datetime] NULL,
	[accionTomada] [varchar](1500) NULL,
	[hashVotacion] [varbinary](250) NULL,
 CONSTRAINT [PK__voto_Vot__197BD908379EDC4F] PRIMARY KEY CLUSTERED 
(
	[votacionFiscalizacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_VotacionesXSegmentos]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_VotacionesXSegmentos](
	[votacionId] [int] NOT NULL,
	[segmentoId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_Votos]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_Votos](
	[votoId] [int] IDENTITY(1,1) NOT NULL,
	[votacionId] [int] NOT NULL,
	[papeletaId] [int] NOT NULL,
	[userId] [int] NULL,
	[opcionId] [int] NOT NULL,
	[fechaHora] [datetime] NOT NULL,
	[hashContenido] [varbinary](250) NOT NULL,
	[direccionIP] [varchar](45) NULL,
	[dispositivo] [varchar](100) NULL,
	[ubicacion] [geography] NULL,
	[segmentoId] [int] NULL,
	[timestampSeguro] [bigint] NOT NULL,
	[llavePrivada] [varbinary](250) NOT NULL,
	[pesoId] [int] NOT NULL,
 CONSTRAINT [PK__voto_Vot__799A0FCF0EAEA0FD] PRIMARY KEY CLUSTERED 
(
	[votoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkAquien]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkAquien](
	[aQuienInterese] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[wnabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkAuditoria]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkAuditoria](
	[auditoriaId] [int] NOT NULL,
	[workFlow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkAvalesPropuesta]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkAvalesPropuesta](
	[avalId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkBalance]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkBalance](
	[personBalanceId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkBenefitRestrictions]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkBenefitRestrictions](
	[benefitRestrictionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkCondiciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkCondiciones](
	[condicionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkConfigVisualizacion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkConfigVisualizacion](
	[configId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkDealBenefitTypes]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkDealBenefitTypes](
	[dealMediaTypeId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkDesembolsos]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkDesembolsos](
	[desembolsoId] [int] NOT NULL,
	[workFlowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkDocTypes]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkDocTypes](
	[docTypeId] [int] NOT NULL,
	[workFlowId] [int] NOT NULL,
	[orderIndex] [int] NOT NULL,
	[enable] [bit] NOT NULL,
	[posttime] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkDocumentosVotacion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkDocumentosVotacion](
	[documentoId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkFiscalizaciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkFiscalizaciones](
	[fiscalizacionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkGruposAvaladores]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkGruposAvaladores](
	[grupoId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndexint] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkHistorial]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkHistorial](
	[historialIdd] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkHitos]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkHitos](
	[hitoId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkInversionista]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkInversionista](
	[inversionistaId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[orderIndex] [int] NOT NULL,
	[enabled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkMedia]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkMedia](
	[mediaFileID] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkOpcionesVotacion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkOpcionesVotacion](
	[opcionId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPagos]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPagos](
	[pagoId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPapeletasOpciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPapeletasOpciones](
	[opcionId] [int] NOT NULL,
	[workFlow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPartnerDeals]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPartnerDeals](
	[partnerDealId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPartnerObligations]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPartnerObligations](
	[partnerObligationId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPersonas]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPersonas](
	[personId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPlantillas]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPlantillas](
	[plantillaId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPlanTrabajo]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPlanTrabajo](
	[planId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPreferencias]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPreferencias](
	[preferenciaId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkPublicaciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkPublicaciones](
	[publicacionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkReplica]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkReplica](
	[replicaId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkReportesFinancieros]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkReportesFinancieros](
	[reporteId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkSignUp]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkSignUp](
	[signUpId] [int] NOT NULL,
	[workflow_Id] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoBiometrico]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoBiometrico](
	[tipoBiometricoId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoCedula]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoCedula](
	[tipoCedulaId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoComentarios]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoComentarios](
	[tipoComentarioId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoEducacion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoEducacion](
	[tipoEducacionId] [int] NOT NULL,
	[workFlow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoEstadisticas]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoEstadisticas](
	[tipoEstadisticaId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoInstitucion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoInstitucion](
	[tipoInstitucionId] [int] NOT NULL,
	[workdflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoInteres]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoInteres](
	[tipoInteresId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoInversion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoInversion](
	[tipoInversionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoProfesion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoProfesion](
	[tipoProfesionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoPropuesta]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoPropuesta](
	[tipoPropuestaId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoPruebas]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoPruebas](
	[tipoPruebasVidaId] [int] NOT NULL,
	[workflow_Id] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoPubli]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoPubli](
	[tipoPublicacionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoReglas]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoReglas](
	[tipoReglaId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoRepresentante]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoRepresentante](
	[tipoRepresentanteId] [int] NOT NULL,
	[workFlowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoSeccion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoSeccion](
	[tipoSeccionId] [int] NOT NULL,
	[workflow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoUser]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoUser](
	[tipoUserId] [int] NOT NULL,
	[workflow_Id] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTipoVotacion]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTipoVotacion](
	[tipoVotacionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTransacciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTransacciones](
	[transaccionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkTypePropuestas]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkTypePropuestas](
	[proposalTypeId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkUsers]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkUsers](
	[userId] [int] NOT NULL,
	[workflow_Id] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkVotaciones]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkVotaciones](
	[votacionId] [int] NOT NULL,
	[workflowId] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[voto_WorkVotos]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[voto_WorkVotos](
	[votoId] [int] NOT NULL,
	[workFlow] [int] NOT NULL,
	[enabled] [bit] NOT NULL,
	[orderIndex] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_bitacora]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_bitacora](
	[bitacoraId] [int] NOT NULL,
	[wkLogTypeId] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[resultado] [varchar](1500) NOT NULL,
	[estadoId] [int] NOT NULL,
	[workflow_Id] [int] NOT NULL,
	[parametros] [varchar](1500) NOT NULL,
 CONSTRAINT [PK_wk_bitacora] PRIMARY KEY CLUSTERED 
(
	[bitacoraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_LogType]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_LogType](
	[wkLogTypeId] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[description] [varchar](50) NOT NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK_wk_LogType] PRIMARY KEY CLUSTERED 
(
	[wkLogTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_step_param]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_step_param](
	[param_id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[tipo_dato] [varchar](50) NOT NULL,
	[requerido] [bit] NOT NULL,
	[valor_defecto] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[param_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_step_run]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_step_run](
	[step_run_id] [int] IDENTITY(1,1) NOT NULL,
	[run_id] [uniqueidentifier] NOT NULL,
	[estadoId] [int] NOT NULL,
	[resultado] [varchar](1500) NULL,
	[fecha_inicio] [datetime] NULL,
	[fecha_fin] [datetime] NULL,
 CONSTRAINT [PK__wk_step___A4DC027C4EC6D657] PRIMARY KEY CLUSTERED 
(
	[step_run_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_workflow]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_workflow](
	[workflow_id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[descripcion] [varchar](500) NOT NULL,
	[tipoid] [int] NOT NULL,
	[version] [int] NOT NULL,
	[activo] [bit] NOT NULL,
	[fecha_creacion] [datetime] NOT NULL,
	[configWork] [varchar](1500) NOT NULL,
	[URL] [varchar](50) NOT NULL,
	[enabled] [bit] NOT NULL,
	[lastupdate] [datetime] NOT NULL,
 CONSTRAINT [PK__wk_workf__64A76B7081793DB1] PRIMARY KEY CLUSTERED 
(
	[workflow_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_WorkFlow_Estado]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_WorkFlow_Estado](
	[estadoId] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_wk_WorkFlow_Estado] PRIMARY KEY CLUSTERED 
(
	[estadoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_workflow_run]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_workflow_run](
	[run_id] [uniqueidentifier] NOT NULL,
	[workflow_id] [int] NOT NULL,
	[estadoId] [int] NOT NULL,
	[fecha_inicio] [datetime] NOT NULL,
	[fecha_fin] [datetime] NULL,
	[parametros] [varchar](1500) NOT NULL,
 CONSTRAINT [PK__wk_workf__7D3D901B9C8144C6] PRIMARY KEY CLUSTERED 
(
	[run_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[wk_workflow_tipo]    Script Date: 24/6/2025 16:54:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[wk_workflow_tipo](
	[tipoid] [int] NOT NULL,
	[descripcion] [varchar](500) NOT NULL,
 CONSTRAINT [PK__wk_workf__E7F956480B42D5B4] PRIMARY KEY CLUSTERED 
(
	[tipoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_voto_AuditoriaSeguridad_fechaHora]    Script Date: 24/6/2025 16:54:48 ******/
CREATE NONCLUSTERED INDEX [IX_voto_AuditoriaSeguridad_fechaHora] ON [dbo].[voto_AuditoriaSeguridad]
(
	[fechaHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_voto_AuditoriaSeguridad_usuarioId]    Script Date: 24/6/2025 16:54:48 ******/
CREATE NONCLUSTERED INDEX [IX_voto_AuditoriaSeguridad_usuarioId] ON [dbo].[voto_AuditoriaSeguridad]
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_voto_EstadoSistema_componente]    Script Date: 24/6/2025 16:54:48 ******/
CREATE NONCLUSTERED INDEX [IX_voto_EstadoSistema_componente] ON [dbo].[voto_EstadoSistema]
(
	[componente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_voto_EstadoSistema_fechaHora]    Script Date: 24/6/2025 16:54:48 ******/
CREATE NONCLUSTERED INDEX [IX_voto_EstadoSistema_fechaHora] ON [dbo].[voto_EstadoSistema]
(
	[fechaHora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[voto_AuditoriaSeguridad] ADD  CONSTRAINT [DF__voto_Audi__fecha__719CDDE7]  DEFAULT (sysutcdatetime()) FOR [fechaHora]
GO
ALTER TABLE [dbo].[voto_AutenticacionMFA] ADD  CONSTRAINT [DF__voto_Aute__fecha__3587F3E0]  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_AutenticacionMFA] ADD  CONSTRAINT [DF__voto_Aute__activ__367C1819]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[voto_AutenticacionMFA] ADD  CONSTRAINT [DF__voto_Aute__inten__41EDCAC5]  DEFAULT ((0)) FOR [intentosFallidos]
GO
ALTER TABLE [dbo].[voto_AutenticacionMFA] ADD  CONSTRAINT [DF__voto_Aute__bloqu__42E1EEFE]  DEFAULT ((0)) FOR [bloqueado]
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta] ADD  CONSTRAINT [DF__voto_Aval__fecha__42ACE4D4]  DEFAULT (getdate()) FOR [fechaAval]
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas] ADD  CONSTRAINT [DF__voto_Come__fecha__07AC1A97]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas] ADD  CONSTRAINT [DF__voto_Come__estad__08A03ED0]  DEFAULT ('Activo') FOR [estadoId]
GO
ALTER TABLE [dbo].[voto_CondicionesGubernamentales] ADD  CONSTRAINT [DF__voto_Cond__fecha__4D2A7347]  DEFAULT (getdate()) FOR [fechaEstablecida]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] ADD  DEFAULT ('AES-256') FOR [algoritmoVotos]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] ADD  DEFAULT ('ECDSA') FOR [algoritmoFirmas]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] ADD  DEFAULT ('SHA-512') FOR [algoritmoHash]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] ADD  DEFAULT ((3)) FOR [nivelSeguridadMinimo]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] ADD  DEFAULT ('TLS 1.3') FOR [tlsVersion]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] ADD  DEFAULT (getdate()) FOR [fechaActualizacion]
GO
ALTER TABLE [dbo].[voto_ConfigVisualizacion] ADD  CONSTRAINT [DF__voto_Conf__mostr__625A9A57]  DEFAULT ((1)) FOR [mostrarResumen]
GO
ALTER TABLE [dbo].[voto_ConfigVisualizacion] ADD  CONSTRAINT [DF__voto_Conf__mostr__634EBE90]  DEFAULT ((0)) FOR [mostrarDetalle]
GO
ALTER TABLE [dbo].[voto_ConfigVisualizacion] ADD  CONSTRAINT [DF__voto_Conf__mostr__6442E2C9]  DEFAULT ((0)) FOR [mostrarPorGrupo]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] ADD  CONSTRAINT [DF__voto_Crow__fecha__0E591826]  DEFAULT (getdate()) FOR [fechaPublicacion]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] ADD  CONSTRAINT [DF__voto_Crow__estad__0F4D3C5F]  DEFAULT ('Borrador') FOR [estadoid]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] ADD  CONSTRAINT [DF__voto_Crow__visit__10416098]  DEFAULT ((0)) FOR [visitas]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] ADD  CONSTRAINT [DF__voto_Crow__compa__113584D1]  DEFAULT ((0)) FOR [compartidos]
GO
ALTER TABLE [dbo].[voto_Desembolsos] ADD  CONSTRAINT [DF__voto_Dese__estad__5F492382]  DEFAULT ('Pendiente') FOR [estadoId]
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle] ADD  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_DividendDistributionCycle] ADD  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_DividendDistributionCycle] ADD  DEFAULT ('Completado') FOR [estado]
GO
ALTER TABLE [dbo].[voto_EstadisticasVotacion] ADD  CONSTRAINT [DF__voto_Esta__fecha__0B7CAB7B]  DEFAULT (getdate()) FOR [fechaCalculo]
GO
ALTER TABLE [dbo].[voto_EstadoSistema] ADD  CONSTRAINT [DF__voto_Esta__fecha__11158940]  DEFAULT (sysutcdatetime()) FOR [fechaHora]
GO
ALTER TABLE [dbo].[voto_EstadoSistema] ADD  CONSTRAINT [DF__voto_Esta__alert__1209AD79]  DEFAULT ((0)) FOR [alertas]
GO
ALTER TABLE [dbo].[voto_FirmasValidadores] ADD  CONSTRAINT [DF__voto_Firm__estad__57DD0BE4]  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[voto_Fiscalizaciones] ADD  CONSTRAINT [DF__voto_Fisc__fecha__6ABAD62E]  DEFAULT (getdate()) FOR [fechaReporte]
GO
ALTER TABLE [dbo].[voto_Fiscalizaciones] ADD  CONSTRAINT [DF__voto_Fisc__estad__6BAEFA67]  DEFAULT ('Reportada') FOR [estado]
GO
ALTER TABLE [dbo].[voto_GruposAvaladores] ADD  CONSTRAINT [DF__voto_Grup__fecha__3DE82FB7]  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_GruposAvaladores] ADD  CONSTRAINT [DF__voto_Grup__activ__3EDC53F0]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[voto_HistorialIntereses] ADD  CONSTRAINT [DF__voto_Hist__fecha__7DB89C09]  DEFAULT (getdate()) FOR [fechaAccion]
GO
ALTER TABLE [dbo].[voto_HitosPlanTrabajo] ADD  CONSTRAINT [DF__voto_Hito__porce__19CACAD2]  DEFAULT ((0)) FOR [porcentajeAvance]
GO
ALTER TABLE [dbo].[voto_HitosPlanTrabajo] ADD  CONSTRAINT [DF__voto_Hito__estad__1ABEEF0B]  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[voto_IdentidadesDigitales] ADD  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_IdentidadesDigitales] ADD  DEFAULT ((1)) FOR [activa]
GO
ALTER TABLE [dbo].[voto_Instituciones] ADD  CONSTRAINT [DF__voto_Inst__estad__40058253]  DEFAULT ('Pendiente') FOR [estadoValidacion]
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes] ADD  CONSTRAINT [DF__voto_Inst__activ__04CFADEC]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[voto_InversionDocumentos] ADD  CONSTRAINT [DF__voto_Inve__estad__01F34141]  DEFAULT ('Valido') FOR [enabled]
GO
ALTER TABLE [dbo].[voto_Inversiones] ADD  CONSTRAINT [DF__voto_Inve__fecha__39E294A9]  DEFAULT (getdate()) FOR [fechaInversion]
GO
ALTER TABLE [dbo].[voto_Inversiones] ADD  CONSTRAINT [DF__voto_Inve__estad__3AD6B8E2]  DEFAULT ('Activa') FOR [estado]
GO
ALTER TABLE [dbo].[voto_Inversionistas] ADD  CONSTRAINT [DF__voto_Inve__fecha__7C3A67EB]  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_Inversionistas] ADD  CONSTRAINT [DF__voto_Inve__acred__7D2E8C24]  DEFAULT ((0)) FOR [acreditado]
GO
ALTER TABLE [dbo].[voto_Inversionistas] ADD  CONSTRAINT [DF__voto_Inve__estad__7E22B05D]  DEFAULT ('Activo') FOR [estado]
GO
ALTER TABLE [dbo].[voto_IPsPermitidas] ADD  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[voto_PapeletaAuditoria] ADD  CONSTRAINT [DF__voto_Pape__fecha__705EA0EB]  DEFAULT (getdate()) FOR [fechaHora]
GO
ALTER TABLE [dbo].[voto_PapeletaOpciones] ADD  CONSTRAINT [DF__voto_Pape__Abste__67C95AEA]  DEFAULT ((0)) FOR [Abstencion]
GO
ALTER TABLE [dbo].[voto_PapeletaOpciones] ADD  CONSTRAINT [DF__voto_Papel__Nulo__68BD7F23]  DEFAULT ((0)) FOR [Nulo]
GO
ALTER TABLE [dbo].[voto_PapeletaPlantillas] ADD  CONSTRAINT [DF__voto_Pape__fecha__6B99EBCE]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_PapeletaPlantillas] ADD  CONSTRAINT [DF__voto_Pape__esPub__6C8E1007]  DEFAULT ((0)) FOR [esPublica]
GO
ALTER TABLE [dbo].[voto_PapeletaPlantillas] ADD  CONSTRAINT [DF__voto_Pape__versi__6D823440]  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[voto_Papeletas] ADD  CONSTRAINT [DF__voto_Pape__fecha__5E3FF0B0]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_Papeletas] ADD  CONSTRAINT [DF__voto_Pape__estad__5F3414E9]  DEFAULT ('Borrador') FOR [estado]
GO
ALTER TABLE [dbo].[voto_Papeletas] ADD  CONSTRAINT [DF__voto_Pape__versi__60283922]  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[voto_PapeletaSecciones] ADD  CONSTRAINT [DF__voto_Pape__minSe__6304A5CD]  DEFAULT ((1)) FOR [minSelecciones]
GO
ALTER TABLE [dbo].[voto_PapeletaSecciones] ADD  CONSTRAINT [DF__voto_Pape__maxSe__63F8CA06]  DEFAULT ((1)) FOR [maxSelecciones]
GO
ALTER TABLE [dbo].[voto_PapeletaSecciones] ADD  CONSTRAINT [DF__voto_Pape__esObl__64ECEE3F]  DEFAULT ((1)) FOR [esObligatoria]
GO
ALTER TABLE [dbo].[voto_Personas] ADD  CONSTRAINT [DF__voto_Pers__estad__3C34F16F]  DEFAULT ('Pendiente') FOR [estadoValidacion]
GO
ALTER TABLE [dbo].[voto_PlanesDesembolso] ADD  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[voto_PlanesTrabajo] ADD  CONSTRAINT [DF__voto_Plan__versi__15FA39EE]  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[voto_PlanesTrabajo] ADD  CONSTRAINT [DF__voto_Plan__estad__16EE5E27]  DEFAULT ('Borrador') FOR [estado]
GO
ALTER TABLE [dbo].[voto_PoliticasAcceso] ADD  CONSTRAINT [DF__voto_Poli__requi__74794A92]  DEFAULT ((1)) FOR [requiereMFA]
GO
ALTER TABLE [dbo].[voto_PoliticasAcceso] ADD  CONSTRAINT [DF__voto_Poli__requi__756D6ECB]  DEFAULT ((0)) FOR [requiereBiometrico]
GO
ALTER TABLE [dbo].[voto_PoliticasAcceso] ADD  CONSTRAINT [DF__voto_Poli__activ__76619304]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[voto_PreferenciasInversion] ADD  CONSTRAINT [DF__voto_Pref__fecha__77FFC2B3]  DEFAULT (getdate()) FOR [fechaActualizacion]
GO
ALTER TABLE [dbo].[voto_ProcesosManuales] ADD  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[voto_ProcesosManuales] ADD  DEFAULT (sysutcdatetime()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_Propuestas] ADD  CONSTRAINT [DF__voto_Prop__estad__32767D0B]  DEFAULT ('Borrador') FOR [estadoId]
GO
ALTER TABLE [dbo].[voto_Propuestas] ADD  CONSTRAINT [DF__voto_Prop__fecha__336AA144]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_PruebasVida] ADD  CONSTRAINT [DF__voto_Prue__fecha__3A4CA8FD]  DEFAULT (getdate()) FOR [fechaPrueba]
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico] ADD  CONSTRAINT [DF__voto_Regi__fecha__45BE5BA9]  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_ReplicasVotos] ADD  CONSTRAINT [DF__voto_Repl__fecha__7EF6D905]  DEFAULT (sysutcdatetime()) FOR [fechaReplica]
GO
ALTER TABLE [dbo].[voto_ReplicasVotos] ADD  CONSTRAINT [DF__voto_Repl__estad__7FEAFD3E]  DEFAULT ('Activo') FOR [estado]
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros] ADD  CONSTRAINT [DF__voto_Repo__fecha__6501FCD8]  DEFAULT (getdate()) FOR [fechaSubida]
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros] ADD  CONSTRAINT [DF__voto_Repo__estad__65F62111]  DEFAULT ('Pendiente') FOR [estadoId]
GO
ALTER TABLE [dbo].[voto_RequisitosDocumentos] ADD  DEFAULT ((1)) FOR [obligatorio]
GO
ALTER TABLE [dbo].[voto_ResultadoPropuestas] ADD  CONSTRAINT [DF__voto_Resu__fecha__29971E47]  DEFAULT (getdate()) FOR [fechaRegistro]
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso] ADD  DEFAULT (getdate()) FOR [fechaAsignacion]
GO
ALTER TABLE [dbo].[voto_TiposIntereses] ADD  CONSTRAINT [DF__voto_Tipo__esSec__742F31CF]  DEFAULT ((0)) FOR [esSectorEconomico]
GO
ALTER TABLE [dbo].[voto_TiposIntereses] ADD  CONSTRAINT [DF__voto_Tipo__activ__75235608]  DEFAULT ((1)) FOR [enabled]
GO
ALTER TABLE [dbo].[voto_TiposInversion] ADD  CONSTRAINT [DF__voto_Tipo__activ__7ADC2F5E]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[voto_TiposVotacion] ADD  DEFAULT ((0)) FOR [documentacion]
GO
ALTER TABLE [dbo].[voto_TiposVotacion] ADD  DEFAULT ((0)) FOR [validacion]
GO
ALTER TABLE [dbo].[voto_Users] ADD  CONSTRAINT [DF__voto_User__nivel__3E1D39E1]  DEFAULT ((1)) FOR [nivelSeguridad]
GO
ALTER TABLE [dbo].[voto_Users] ADD  CONSTRAINT [DF__voto_User__requi__3F115E1A]  DEFAULT ((0)) FOR [requiereRevalidacion]
GO
ALTER TABLE [dbo].[voto_Users] ADD  CONSTRAINT [DF__voto_User__cuent__0D44F85C]  DEFAULT ((0)) FOR [cuentaBloqueada]
GO
ALTER TABLE [dbo].[voto_ValidacionesGrupales] ADD  CONSTRAINT [DF__voto_Vali__minim__5224328E]  DEFAULT ((2)) FOR [minimoAprobaciones]
GO
ALTER TABLE [dbo].[voto_ValidacionesGrupales] ADD  CONSTRAINT [DF__voto_Vali__estad__531856C7]  DEFAULT ('Pendiente') FOR [estado]
GO
ALTER TABLE [dbo].[voto_ValidacionesGrupales] ADD  CONSTRAINT [DF__voto_Vali__fecha__540C7B00]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_Votaciones] ADD  CONSTRAINT [DF__voto_Vota__esPub__19DFD96B]  DEFAULT ((1)) FOR [esPublica]
GO
ALTER TABLE [dbo].[voto_Votaciones] ADD  CONSTRAINT [DF__voto_Vota__fecha__1AD3FDA4]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_Votaciones] ADD  CONSTRAINT [DF__voto_Vota__diasN__5BAD9CC8]  DEFAULT ((7)) FOR [diasNotificacionPrevia]
GO
ALTER TABLE [dbo].[voto_VotacionesApoyo] ADD  CONSTRAINT [DF__voto_Vota__fecha__4865BE2A]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_VotacionesFiscalizacion] ADD  CONSTRAINT [DF__voto_Vota__fecha__7073AF84]  DEFAULT (getdate()) FOR [fechaCreacion]
GO
ALTER TABLE [dbo].[voto_Votos] ADD  CONSTRAINT [DF__voto_Voto__fecha__2645B050]  DEFAULT (getdate()) FOR [fechaHora]
GO
ALTER TABLE [dbo].[voto_Votos] ADD  CONSTRAINT [DF__voto_Voto__times__6EC0713C]  DEFAULT (datediff_big(second,'1970-01-01',getdate())) FOR [timestampSeguro]
GO
ALTER TABLE [dbo].[wk_step_param] ADD  DEFAULT ((1)) FOR [requerido]
GO
ALTER TABLE [dbo].[wk_step_run] ADD  CONSTRAINT [DF__wk_step_r__estad__00750D23]  DEFAULT ('PENDIENTE') FOR [estadoId]
GO
ALTER TABLE [dbo].[wk_workflow] ADD  CONSTRAINT [DF__wk_workfl__versi__6A85CC04]  DEFAULT ((1)) FOR [version]
GO
ALTER TABLE [dbo].[wk_workflow] ADD  CONSTRAINT [DF__wk_workfl__activ__6B79F03D]  DEFAULT ((1)) FOR [activo]
GO
ALTER TABLE [dbo].[wk_workflow] ADD  CONSTRAINT [DF__wk_workfl__fecha__6C6E1476]  DEFAULT (sysdatetime()) FOR [fecha_creacion]
GO
ALTER TABLE [dbo].[wk_workflow_run] ADD  CONSTRAINT [DF__wk_workfl__run_i__7ABC33CD]  DEFAULT (newid()) FOR [run_id]
GO
ALTER TABLE [dbo].[wk_workflow_run] ADD  CONSTRAINT [DF__wk_workfl__estad__7BB05806]  DEFAULT ('EN_EJECUCION') FOR [estadoId]
GO
ALTER TABLE [dbo].[wk_workflow_run] ADD  CONSTRAINT [DF__wk_workfl__fecha__7CA47C3F]  DEFAULT (sysdatetime()) FOR [fecha_inicio]
GO
ALTER TABLE [dbo].[voto_AquienInterese]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AquienInterese_voto_MediaFiles] FOREIGN KEY([mediaFileId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_AquienInterese] CHECK CONSTRAINT [FK_voto_AquienInterese_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_AquienInterese]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AquienInterese_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_AquienInterese] CHECK CONSTRAINT [FK_voto_AquienInterese_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_AuditoriaSeguridad]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AuditoriaSeguridad_voto_LogSeverity] FOREIGN KEY([logseverityId])
REFERENCES [dbo].[voto_LogSeverity] ([logSeverityId])
GO
ALTER TABLE [dbo].[voto_AuditoriaSeguridad] CHECK CONSTRAINT [FK_voto_AuditoriaSeguridad_voto_LogSeverity]
GO
ALTER TABLE [dbo].[voto_AuditoriaSeguridad]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AuditoriaSeguridad_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_AuditoriaSeguridad] CHECK CONSTRAINT [FK_voto_AuditoriaSeguridad_voto_Users]
GO
ALTER TABLE [dbo].[voto_AutenticacionMFA]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AutenticacionMFA_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_AutenticacionMFA] CHECK CONSTRAINT [FK_voto_AutenticacionMFA_voto_Users]
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AvalesPropuesta_voto_GruposAvaladores] FOREIGN KEY([grupoId])
REFERENCES [dbo].[voto_GruposAvaladores] ([grupoId])
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta] CHECK CONSTRAINT [FK_voto_AvalesPropuesta_voto_GruposAvaladores]
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AvalesPropuesta_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta] CHECK CONSTRAINT [FK_voto_AvalesPropuesta_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_AvalesPropuesta_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_AvalesPropuesta] CHECK CONSTRAINT [FK_voto_AvalesPropuesta_voto_Users]
GO
ALTER TABLE [dbo].[voto_BenefitRestrictions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_BenefitRestrictions_voto_partnerDealBenefits] FOREIGN KEY([partnerDealBenefitsId])
REFERENCES [dbo].[voto_partnerDealBenefits] ([partnerDealBenefitsId])
GO
ALTER TABLE [dbo].[voto_BenefitRestrictions] CHECK CONSTRAINT [FK_voto_BenefitRestrictions_voto_partnerDealBenefits]
GO
ALTER TABLE [dbo].[voto_BenefitRestrictions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_BenefitRestrictions_voto_Schedules] FOREIGN KEY([scheduleId])
REFERENCES [dbo].[voto_Schedules] ([scheduleId])
GO
ALTER TABLE [dbo].[voto_BenefitRestrictions] CHECK CONSTRAINT [FK_voto_BenefitRestrictions_voto_Schedules]
GO
ALTER TABLE [dbo].[voto_BiometricErrors]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_BiometricErrors_voto_TipoBiometricError] FOREIGN KEY([tipoBiometricErrorId])
REFERENCES [dbo].[voto_TipoBiometricError] ([tipoBiometricErrorId])
GO
ALTER TABLE [dbo].[voto_BiometricErrors] CHECK CONSTRAINT [FK_voto_BiometricErrors_voto_TipoBiometricError]
GO
ALTER TABLE [dbo].[voto_BiometricMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_BiometricMedia_voto_MediaFiles] FOREIGN KEY([biometricoId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_BiometricMedia] CHECK CONSTRAINT [FK_voto_BiometricMedia_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_BiometricMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_BiometricMedia_voto_RegistroBiometrico] FOREIGN KEY([mediaFileId])
REFERENCES [dbo].[voto_RegistroBiometrico] ([biometricoId])
GO
ALTER TABLE [dbo].[voto_BiometricMedia] CHECK CONSTRAINT [FK_voto_BiometricMedia_voto_RegistroBiometrico]
GO
ALTER TABLE [dbo].[voto_Cities]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Cities_voto_States] FOREIGN KEY([stateId])
REFERENCES [dbo].[voto_States] ([stateId])
GO
ALTER TABLE [dbo].[voto_Cities] CHECK CONSTRAINT [FK_voto_Cities_voto_States]
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ComentariosPropuestas_voto_intereses] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_intereses] ([interesId])
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas] CHECK CONSTRAINT [FK_voto_ComentariosPropuestas_voto_intereses]
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ComentariosPropuestas_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas] CHECK CONSTRAINT [FK_voto_ComentariosPropuestas_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ComentariosPropuestas_voto_TipoComentario] FOREIGN KEY([tipoComentarioId])
REFERENCES [dbo].[voto_TipoComentario] ([tipoComentarioId])
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas] CHECK CONSTRAINT [FK_voto_ComentariosPropuestas_voto_TipoComentario]
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ComentariosPropuestas_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_ComentariosPropuestas] CHECK CONSTRAINT [FK_voto_ComentariosPropuestas_voto_Users]
GO
ALTER TABLE [dbo].[voto_comparticion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_compartición_voto_Desencriptacion] FOREIGN KEY([desencriptedId])
REFERENCES [dbo].[voto_Desencriptacion] ([desencriptionId])
GO
ALTER TABLE [dbo].[voto_comparticion] CHECK CONSTRAINT [FK_voto_compartición_voto_Desencriptacion]
GO
ALTER TABLE [dbo].[voto_comparticion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_compartición_voto_Encriptacion] FOREIGN KEY([encriptedId])
REFERENCES [dbo].[voto_Encriptacion] ([encriptedId])
GO
ALTER TABLE [dbo].[voto_comparticion] CHECK CONSTRAINT [FK_voto_compartición_voto_Encriptacion]
GO
ALTER TABLE [dbo].[voto_CondicionesGubernamentales]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CondicionesGubernamentales_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_CondicionesGubernamentales] CHECK CONSTRAINT [FK_voto_CondicionesGubernamentales_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_CondicionesGubernamentales]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CondicionesGubernamentales_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_CondicionesGubernamentales] CHECK CONSTRAINT [FK_voto_CondicionesGubernamentales_voto_Users]
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ConfigSeguridad_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_ConfigSeguridad] CHECK CONSTRAINT [FK_voto_ConfigSeguridad_voto_Users]
GO
ALTER TABLE [dbo].[voto_ConfigVisualizacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ConfigVisualizacion_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_ConfigVisualizacion] CHECK CONSTRAINT [FK_voto_ConfigVisualizacion_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_ContactInfoInstituciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ContactInfoInstituciones_voto_ContactInfoTypes] FOREIGN KEY([contactInfoTypeId])
REFERENCES [dbo].[voto_ContactInfoTypes] ([contactInfoTypeId])
GO
ALTER TABLE [dbo].[voto_ContactInfoInstituciones] CHECK CONSTRAINT [FK_voto_ContactInfoInstituciones_voto_ContactInfoTypes]
GO
ALTER TABLE [dbo].[voto_ContactInfoInstituciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ContactInfoInstituciones_voto_Instituciones] FOREIGN KEY([institucionId])
REFERENCES [dbo].[voto_Instituciones] ([institucionId])
GO
ALTER TABLE [dbo].[voto_ContactInfoInstituciones] CHECK CONSTRAINT [FK_voto_ContactInfoInstituciones_voto_Instituciones]
GO
ALTER TABLE [dbo].[voto_contactInfoInversionistas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_contactInfoInversionistas_voto_ContactInfoTypes] FOREIGN KEY([contactInfoTypeId])
REFERENCES [dbo].[voto_ContactInfoTypes] ([contactInfoTypeId])
GO
ALTER TABLE [dbo].[voto_contactInfoInversionistas] CHECK CONSTRAINT [FK_voto_contactInfoInversionistas_voto_ContactInfoTypes]
GO
ALTER TABLE [dbo].[voto_ContactInfoPerson]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ContactInfoPerson_voto_ContactInfoTypes] FOREIGN KEY([contactInfoTypeId])
REFERENCES [dbo].[voto_ContactInfoTypes] ([contactInfoTypeId])
GO
ALTER TABLE [dbo].[voto_ContactInfoPerson] CHECK CONSTRAINT [FK_voto_ContactInfoPerson_voto_ContactInfoTypes]
GO
ALTER TABLE [dbo].[voto_ContactInfoPerson]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ContactInfoPerson_voto_Personas] FOREIGN KEY([personId])
REFERENCES [dbo].[voto_Personas] ([personId])
GO
ALTER TABLE [dbo].[voto_ContactInfoPerson] CHECK CONSTRAINT [FK_voto_ContactInfoPerson_voto_Personas]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_Estado] FOREIGN KEY([estadoid])
REFERENCES [dbo].[voto_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] CHECK CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_Estado]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] CHECK CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_recaudacionFondos] FOREIGN KEY([recaudacionId])
REFERENCES [dbo].[voto_recaudacionFondos] ([recaudacionId])
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] CHECK CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_recaudacionFondos]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_Segmentos] FOREIGN KEY([segmentoid])
REFERENCES [dbo].[voto_Segmentos] ([segmentoId])
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] CHECK CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_Segmentos]
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_TipoPublicaciones] FOREIGN KEY([tipoPublicacionesId])
REFERENCES [dbo].[voto_TipoPublicaciones] ([tipoPublicacionId])
GO
ALTER TABLE [dbo].[voto_CrowdfundingPublicaciones] CHECK CONSTRAINT [FK_voto_CrowdfundingPublicaciones_voto_TipoPublicaciones]
GO
ALTER TABLE [dbo].[voto_CrowdfundingRecompensas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CrowdfundingRecompensas_voto_CrowdfundingPublicaciones] FOREIGN KEY([publicacionId])
REFERENCES [dbo].[voto_CrowdfundingPublicaciones] ([publicacionId])
GO
ALTER TABLE [dbo].[voto_CrowdfundingRecompensas] CHECK CONSTRAINT [FK_voto_CrowdfundingRecompensas_voto_CrowdfundingPublicaciones]
GO
ALTER TABLE [dbo].[voto_CurrencyConvertions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CurrencyConvertions_voto_Currencies] FOREIGN KEY([currencyId_Source])
REFERENCES [dbo].[voto_Currencies] ([currencyId])
GO
ALTER TABLE [dbo].[voto_CurrencyConvertions] CHECK CONSTRAINT [FK_voto_CurrencyConvertions_voto_Currencies]
GO
ALTER TABLE [dbo].[voto_CurrencyConvertions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_CurrencyConvertions_voto_Currencies1] FOREIGN KEY([currencyId_destiny])
REFERENCES [dbo].[voto_Currencies] ([currencyId])
GO
ALTER TABLE [dbo].[voto_CurrencyConvertions] CHECK CONSTRAINT [FK_voto_CurrencyConvertions_voto_Currencies1]
GO
ALTER TABLE [dbo].[voto_DealMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DealMedia_voto_MediaFiles] FOREIGN KEY([mediaFileId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_DealMedia] CHECK CONSTRAINT [FK_voto_DealMedia_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_DealMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DealMedia_voto_PartnerDeals] FOREIGN KEY([partnerDealId])
REFERENCES [dbo].[voto_PartnerDeals] ([partnerDealId])
GO
ALTER TABLE [dbo].[voto_DealMedia] CHECK CONSTRAINT [FK_voto_DealMedia_voto_PartnerDeals]
GO
ALTER TABLE [dbo].[voto_Desembolsos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Desembolsos_voto_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[voto_Desembolsos] CHECK CONSTRAINT [FK_voto_Desembolsos_voto_Estado]
GO
ALTER TABLE [dbo].[voto_Desembolsos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Desembolsos_voto_ItemsDesembolso] FOREIGN KEY([itemId])
REFERENCES [dbo].[voto_ItemsDesembolso] ([itemId])
GO
ALTER TABLE [dbo].[voto_Desembolsos] CHECK CONSTRAINT [FK_voto_Desembolsos_voto_ItemsDesembolso]
GO
ALTER TABLE [dbo].[voto_Desembolsos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Desembolsos_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_Desembolsos] CHECK CONSTRAINT [FK_voto_Desembolsos_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_Desembolsos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Desembolsos_voto_Users] FOREIGN KEY([userIdAutorizacion])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Desembolsos] CHECK CONSTRAINT [FK_voto_Desembolsos_voto_Users]
GO
ALTER TABLE [dbo].[voto_DesembolsosDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DesembolsosDoc_voto_Desembolsos] FOREIGN KEY([desembolsoId])
REFERENCES [dbo].[voto_Desembolsos] ([desembolsoId])
GO
ALTER TABLE [dbo].[voto_DesembolsosDoc] CHECK CONSTRAINT [FK_voto_DesembolsosDoc_voto_Desembolsos]
GO
ALTER TABLE [dbo].[voto_DesembolsosDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DesembolsosDoc_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DesembolsosDoc] CHECK CONSTRAINT [FK_voto_DesembolsosDoc_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle]  WITH CHECK ADD  CONSTRAINT [FK_voto_DistribucionDetalle_voto_DividendDistributionCycle] FOREIGN KEY([cycleId])
REFERENCES [dbo].[voto_DividendDistributionCycle] ([cycleId])
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle] CHECK CONSTRAINT [FK_voto_DistribucionDetalle_voto_DividendDistributionCycle]
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle]  WITH CHECK ADD  CONSTRAINT [FK_voto_DistribucionDetalle_voto_Inversiones] FOREIGN KEY([inversionId])
REFERENCES [dbo].[voto_Inversiones] ([inversionId])
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle] CHECK CONSTRAINT [FK_voto_DistribucionDetalle_voto_Inversiones]
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle]  WITH CHECK ADD  CONSTRAINT [FK_voto_DistribucionDetalle_voto_Inversionistas] FOREIGN KEY([inversionistaId])
REFERENCES [dbo].[voto_Inversionistas] ([inversionistaId])
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle] CHECK CONSTRAINT [FK_voto_DistribucionDetalle_voto_Inversionistas]
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle]  WITH CHECK ADD  CONSTRAINT [FK_voto_DistribucionDetalle_voto_Pagos] FOREIGN KEY([pagoId])
REFERENCES [dbo].[voto_Pagos] ([pagoId])
GO
ALTER TABLE [dbo].[voto_DistribucionDetalle] CHECK CONSTRAINT [FK_voto_DistribucionDetalle_voto_Pagos]
GO
ALTER TABLE [dbo].[voto_DividendDistributionCycle]  WITH CHECK ADD  CONSTRAINT [FK_voto_DividendDistributionCycle_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_DividendDistributionCycle] CHECK CONSTRAINT [FK_voto_DividendDistributionCycle_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_DividendDistributionCycle]  WITH CHECK ADD  CONSTRAINT [FK_voto_DividendDistributionCycle_voto_Users] FOREIGN KEY([userIdEjecutor])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_DividendDistributionCycle] CHECK CONSTRAINT [FK_voto_DividendDistributionCycle_voto_Users]
GO
ALTER TABLE [dbo].[voto_DocComentarios]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocComentarios_voto_ComentariosPropuestas] FOREIGN KEY([comentarioId])
REFERENCES [dbo].[voto_ComentariosPropuestas] ([comentarioId])
GO
ALTER TABLE [dbo].[voto_DocComentarios] CHECK CONSTRAINT [FK_voto_DocComentarios_voto_ComentariosPropuestas]
GO
ALTER TABLE [dbo].[voto_DocComentarios]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocComentarios_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocComentarios] CHECK CONSTRAINT [FK_voto_DocComentarios_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocMedia_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocMedia] CHECK CONSTRAINT [FK_voto_DocMedia_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocMedia_voto_MediaFiles] FOREIGN KEY([mediafileId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_DocMedia] CHECK CONSTRAINT [FK_voto_DocMedia_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_DocPagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocPagos_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocPagos] CHECK CONSTRAINT [FK_voto_DocPagos_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocPagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocPagos_voto_Pagos] FOREIGN KEY([pagoId])
REFERENCES [dbo].[voto_Pagos] ([pagoId])
GO
ALTER TABLE [dbo].[voto_DocPagos] CHECK CONSTRAINT [FK_voto_DocPagos_voto_Pagos]
GO
ALTER TABLE [dbo].[voto_DocPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocPropuesta_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocPropuesta] CHECK CONSTRAINT [FK_voto_DocPropuesta_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocPropuesta_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_DocPropuesta] CHECK CONSTRAINT [FK_voto_DocPropuesta_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_DocReportes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocReportes_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocReportes] CHECK CONSTRAINT [FK_voto_DocReportes_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocReportes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocReportes_voto_ReportesFinancieros] FOREIGN KEY([reporteId])
REFERENCES [dbo].[voto_ReportesFinancieros] ([reporteId])
GO
ALTER TABLE [dbo].[voto_DocReportes] CHECK CONSTRAINT [FK_voto_DocReportes_voto_ReportesFinancieros]
GO
ALTER TABLE [dbo].[voto_DocTrans]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocTrans_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocTrans] CHECK CONSTRAINT [FK_voto_DocTrans_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocTrans]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocTrans_voto_Transacciones] FOREIGN KEY([transaccionId])
REFERENCES [dbo].[voto_Transacciones] ([transaccionId])
GO
ALTER TABLE [dbo].[voto_DocTrans] CHECK CONSTRAINT [FK_voto_DocTrans_voto_Transacciones]
GO
ALTER TABLE [dbo].[voto_DocTypesPerProposalTypes]  WITH CHECK ADD  CONSTRAINT [FK_voto_DocTypesPerProposalTypes_voto_ProposalType1] FOREIGN KEY([proposalTypeId])
REFERENCES [dbo].[voto_ProposalType] ([proposalTypeId])
GO
ALTER TABLE [dbo].[voto_DocTypesPerProposalTypes] CHECK CONSTRAINT [FK_voto_DocTypesPerProposalTypes_voto_ProposalType1]
GO
ALTER TABLE [dbo].[voto_DocTypesPerProposalTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocTypesProposalTypes_voto_DocTypes] FOREIGN KEY([documentTypeId])
REFERENCES [dbo].[voto_DocTypes] ([docTypeId])
GO
ALTER TABLE [dbo].[voto_DocTypesPerProposalTypes] CHECK CONSTRAINT [FK_voto_DocTypesProposalTypes_voto_DocTypes]
GO
ALTER TABLE [dbo].[voto_Documents]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Documents_voto_DocTypes] FOREIGN KEY([docTypeId])
REFERENCES [dbo].[voto_DocTypes] ([docTypeId])
GO
ALTER TABLE [dbo].[voto_Documents] CHECK CONSTRAINT [FK_voto_Documents_voto_DocTypes]
GO
ALTER TABLE [dbo].[voto_Documents]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Documents_voto_EstadoDoc] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_EstadoDoc] ([estadoId])
GO
ALTER TABLE [dbo].[voto_Documents] CHECK CONSTRAINT [FK_voto_Documents_voto_EstadoDoc]
GO
ALTER TABLE [dbo].[voto_Documents]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Documents_voto_MediaFiles] FOREIGN KEY([mediaFileId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_Documents] CHECK CONSTRAINT [FK_voto_Documents_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_Documents]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Documents_voto_Users] FOREIGN KEY([usuarioSubio])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Documents] CHECK CONSTRAINT [FK_voto_Documents_voto_Users]
GO
ALTER TABLE [dbo].[voto_DocVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocVotacion_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_DocVotacion] CHECK CONSTRAINT [FK_voto_DocVotacion_voto_Documents]
GO
ALTER TABLE [dbo].[voto_DocVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocVotacion_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_DocVotacion] CHECK CONSTRAINT [FK_voto_DocVotacion_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_DocXProposalType]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocXProposalType_voto_DocTypes] FOREIGN KEY([documentTypeId])
REFERENCES [dbo].[voto_DocTypes] ([docTypeId])
GO
ALTER TABLE [dbo].[voto_DocXProposalType] CHECK CONSTRAINT [FK_voto_DocXProposalType_voto_DocTypes]
GO
ALTER TABLE [dbo].[voto_DocXProposalType]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_DocXProposalType_voto_ProposalType] FOREIGN KEY([proposalTypeId])
REFERENCES [dbo].[voto_ProposalType] ([proposalTypeId])
GO
ALTER TABLE [dbo].[voto_DocXProposalType] CHECK CONSTRAINT [FK_voto_DocXProposalType_voto_ProposalType]
GO
ALTER TABLE [dbo].[voto_Educacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Educacion_voto_tipoEducacion] FOREIGN KEY([tipoEducacionId])
REFERENCES [dbo].[voto_tipoEducacion] ([tipoEducacionId])
GO
ALTER TABLE [dbo].[voto_Educacion] CHECK CONSTRAINT [FK_voto_Educacion_voto_tipoEducacion]
GO
ALTER TABLE [dbo].[voto_EstadisticasVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_EstadisticasVotacion_voto_TipoEstadistica] FOREIGN KEY([tipoEstadisticaId])
REFERENCES [dbo].[voto_TipoEstadistica] ([tipoEstadisticaId])
GO
ALTER TABLE [dbo].[voto_EstadisticasVotacion] CHECK CONSTRAINT [FK_voto_EstadisticasVotacion_voto_TipoEstadistica]
GO
ALTER TABLE [dbo].[voto_EstadisticasVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_EstadisticasVotacion_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_EstadisticasVotacion] CHECK CONSTRAINT [FK_voto_EstadisticasVotacion_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_Features]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Features_voto_FeaturesTypes] FOREIGN KEY([featureTypeId])
REFERENCES [dbo].[voto_FeaturesTypes] ([featureTypeId])
GO
ALTER TABLE [dbo].[voto_Features] CHECK CONSTRAINT [FK_voto_Features_voto_FeaturesTypes]
GO
ALTER TABLE [dbo].[voto_featuresXUser]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_featuresXUser_voto_Features] FOREIGN KEY([featureId])
REFERENCES [dbo].[voto_Features] ([featureId])
GO
ALTER TABLE [dbo].[voto_featuresXUser] CHECK CONSTRAINT [FK_voto_featuresXUser_voto_Features]
GO
ALTER TABLE [dbo].[voto_FeatureXSegmento]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_FeatureXSegmento_voto_Features] FOREIGN KEY([featureId])
REFERENCES [dbo].[voto_Features] ([featureId])
GO
ALTER TABLE [dbo].[voto_FeatureXSegmento] CHECK CONSTRAINT [FK_voto_FeatureXSegmento_voto_Features]
GO
ALTER TABLE [dbo].[voto_FeatureXSegmento]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_FeatureXSegmento_voto_Segmentos] FOREIGN KEY([segmentoId])
REFERENCES [dbo].[voto_Segmentos] ([segmentoId])
GO
ALTER TABLE [dbo].[voto_FeatureXSegmento] CHECK CONSTRAINT [FK_voto_FeatureXSegmento_voto_Segmentos]
GO
ALTER TABLE [dbo].[voto_FirmasValidadores]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_FirmasValidadores_voto_Users] FOREIGN KEY([validadorId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_FirmasValidadores] CHECK CONSTRAINT [FK_voto_FirmasValidadores_voto_Users]
GO
ALTER TABLE [dbo].[voto_FirmasValidadores]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_FirmasValidadores_voto_ValidacionesGrupales] FOREIGN KEY([validacionId])
REFERENCES [dbo].[voto_ValidacionesGrupales] ([validacionId])
GO
ALTER TABLE [dbo].[voto_FirmasValidadores] CHECK CONSTRAINT [FK_voto_FirmasValidadores_voto_ValidacionesGrupales]
GO
ALTER TABLE [dbo].[voto_Fiscalizaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Fiscalizaciones_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_Fiscalizaciones] CHECK CONSTRAINT [FK_voto_Fiscalizaciones_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_Fiscalizaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Fiscalizaciones_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Fiscalizaciones] CHECK CONSTRAINT [FK_voto_Fiscalizaciones_voto_Users]
GO
ALTER TABLE [dbo].[voto_GruposAvaladores]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_GruposAvaladores_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_GruposAvaladores] CHECK CONSTRAINT [FK_voto_GruposAvaladores_voto_Users]
GO
ALTER TABLE [dbo].[voto_HistorialIntereses]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_HistorialIntereses_voto_Inversionistas] FOREIGN KEY([inversionistaId])
REFERENCES [dbo].[voto_Inversionistas] ([inversionistaId])
GO
ALTER TABLE [dbo].[voto_HistorialIntereses] CHECK CONSTRAINT [FK_voto_HistorialIntereses_voto_Inversionistas]
GO
ALTER TABLE [dbo].[voto_HistorialIntereses]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_HistorialIntereses_voto_TiposInversion] FOREIGN KEY([tipoInversionId])
REFERENCES [dbo].[voto_TiposInversion] ([tipoInversionId])
GO
ALTER TABLE [dbo].[voto_HistorialIntereses] CHECK CONSTRAINT [FK_voto_HistorialIntereses_voto_TiposInversion]
GO
ALTER TABLE [dbo].[voto_HistorialinteresesDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_HistorialinteresesDoc_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_HistorialinteresesDoc] CHECK CONSTRAINT [FK_voto_HistorialinteresesDoc_voto_Documents]
GO
ALTER TABLE [dbo].[voto_HistorialinteresesDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_HistorialinteresesDoc_voto_HistorialIntereses] FOREIGN KEY([historialId])
REFERENCES [dbo].[voto_HistorialIntereses] ([historialId])
GO
ALTER TABLE [dbo].[voto_HistorialinteresesDoc] CHECK CONSTRAINT [FK_voto_HistorialinteresesDoc_voto_HistorialIntereses]
GO
ALTER TABLE [dbo].[voto_HitosPlanTrabajo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_HitosPlanTrabajo_voto_Fiscalizaciones] FOREIGN KEY([fiscalizacionId])
REFERENCES [dbo].[voto_Fiscalizaciones] ([fiscalizacionId])
GO
ALTER TABLE [dbo].[voto_HitosPlanTrabajo] CHECK CONSTRAINT [FK_voto_HitosPlanTrabajo_voto_Fiscalizaciones]
GO
ALTER TABLE [dbo].[voto_HitosPlanTrabajo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_HitosPlanTrabajo_voto_PlanesTrabajo] FOREIGN KEY([planId])
REFERENCES [dbo].[voto_PlanesTrabajo] ([planId])
GO
ALTER TABLE [dbo].[voto_HitosPlanTrabajo] CHECK CONSTRAINT [FK_voto_HitosPlanTrabajo_voto_PlanesTrabajo]
GO
ALTER TABLE [dbo].[voto_IdentidadesDigitales]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_IdentidadesDigitales_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_IdentidadesDigitales] CHECK CONSTRAINT [FK_voto_IdentidadesDigitales_voto_Users]
GO
ALTER TABLE [dbo].[voto_Instituciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Instituciones_caipi_adresses] FOREIGN KEY([adressId])
REFERENCES [dbo].[voto_adresses] ([adressId])
GO
ALTER TABLE [dbo].[voto_Instituciones] CHECK CONSTRAINT [FK_voto_Instituciones_caipi_adresses]
GO
ALTER TABLE [dbo].[voto_Instituciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Instituciones_voto_TipoInstitucion] FOREIGN KEY([tipoInstitucionId])
REFERENCES [dbo].[voto_TipoInstitucion] ([tipoInstitucioneId])
GO
ALTER TABLE [dbo].[voto_Instituciones] CHECK CONSTRAINT [FK_voto_Instituciones_voto_TipoInstitucion]
GO
ALTER TABLE [dbo].[voto_Instituciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Instituciones_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Instituciones] CHECK CONSTRAINT [FK_voto_Instituciones_voto_Users]
GO
ALTER TABLE [dbo].[voto_institucionesDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_institucionesDoc_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_institucionesDoc] CHECK CONSTRAINT [FK_voto_institucionesDoc_voto_Documents]
GO
ALTER TABLE [dbo].[voto_institucionesDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_institucionesDoc_voto_Instituciones] FOREIGN KEY([institucionId])
REFERENCES [dbo].[voto_Instituciones] ([institucionId])
GO
ALTER TABLE [dbo].[voto_institucionesDoc] CHECK CONSTRAINT [FK_voto_institucionesDoc_voto_Instituciones]
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_InstitucionRepresentantes_voto_Instituciones] FOREIGN KEY([institucionId])
REFERENCES [dbo].[voto_Instituciones] ([institucionId])
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes] CHECK CONSTRAINT [FK_voto_InstitucionRepresentantes_voto_Instituciones]
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_InstitucionRepresentantes_voto_Personas] FOREIGN KEY([personId])
REFERENCES [dbo].[voto_Personas] ([personId])
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes] CHECK CONSTRAINT [FK_voto_InstitucionRepresentantes_voto_Personas]
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_InstitucionRepresentantes_voto_TipoRepresentante] FOREIGN KEY([tipoRepresentanteId])
REFERENCES [dbo].[voto_TipoRepresentante] ([tipoRepresentanteId])
GO
ALTER TABLE [dbo].[voto_InstitucionRepresentantes] CHECK CONSTRAINT [FK_voto_InstitucionRepresentantes_voto_TipoRepresentante]
GO
ALTER TABLE [dbo].[voto_intereses]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_intereses_voto_Inversionistas] FOREIGN KEY([inversionistaId])
REFERENCES [dbo].[voto_Inversionistas] ([inversionistaId])
GO
ALTER TABLE [dbo].[voto_intereses] CHECK CONSTRAINT [FK_voto_intereses_voto_Inversionistas]
GO
ALTER TABLE [dbo].[voto_intereses]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_intereses_voto_TiposIntereses] FOREIGN KEY([tipoInteresId])
REFERENCES [dbo].[voto_TiposIntereses] ([tipoInteresId])
GO
ALTER TABLE [dbo].[voto_intereses] CHECK CONSTRAINT [FK_voto_intereses_voto_TiposIntereses]
GO
ALTER TABLE [dbo].[voto_InversionDocumentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_InversionDocumentos_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_InversionDocumentos] CHECK CONSTRAINT [FK_voto_InversionDocumentos_voto_Documents]
GO
ALTER TABLE [dbo].[voto_InversionDocumentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_InversionDocumentos_voto_Inversiones] FOREIGN KEY([inversionId])
REFERENCES [dbo].[voto_Inversiones] ([inversionId])
GO
ALTER TABLE [dbo].[voto_InversionDocumentos] CHECK CONSTRAINT [FK_voto_InversionDocumentos_voto_Inversiones]
GO
ALTER TABLE [dbo].[voto_Inversiones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Inversiones_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_Inversiones] CHECK CONSTRAINT [FK_voto_Inversiones_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_Inversiones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Inversiones_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Inversiones] CHECK CONSTRAINT [FK_voto_Inversiones_voto_Users]
GO
ALTER TABLE [dbo].[voto_Inversionistas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Inversionistas_voto_Inversiones] FOREIGN KEY([inversionId])
REFERENCES [dbo].[voto_Inversiones] ([inversionId])
GO
ALTER TABLE [dbo].[voto_Inversionistas] CHECK CONSTRAINT [FK_voto_Inversionistas_voto_Inversiones]
GO
ALTER TABLE [dbo].[voto_IPsPermitidas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_IPsPermitidas_voto_Countries] FOREIGN KEY([paisId])
REFERENCES [dbo].[voto_Countries] ([countryId])
GO
ALTER TABLE [dbo].[voto_IPsPermitidas] CHECK CONSTRAINT [FK_voto_IPsPermitidas_voto_Countries]
GO
ALTER TABLE [dbo].[voto_ItemsDesembolso]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ItemsDesembolso_voto_PlanesDesembolso] FOREIGN KEY([planId])
REFERENCES [dbo].[voto_PlanesDesembolso] ([planId])
GO
ALTER TABLE [dbo].[voto_ItemsDesembolso] CHECK CONSTRAINT [FK_voto_ItemsDesembolso_voto_PlanesDesembolso]
GO
ALTER TABLE [dbo].[voto_Languages]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Languages_voto_Countries] FOREIGN KEY([countryId])
REFERENCES [dbo].[voto_Countries] ([countryId])
GO
ALTER TABLE [dbo].[voto_Languages] CHECK CONSTRAINT [FK_voto_Languages_voto_Countries]
GO
ALTER TABLE [dbo].[voto_LogIn]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_LogIn_voto_Dispositivos] FOREIGN KEY([dispositivoId])
REFERENCES [dbo].[voto_Dispositivos] ([dispositivoId])
GO
ALTER TABLE [dbo].[voto_LogIn] CHECK CONSTRAINT [FK_voto_LogIn_voto_Dispositivos]
GO
ALTER TABLE [dbo].[voto_LogIn]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_LogIn_voto_EstadoUser] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_EstadoUser] ([estadoId])
GO
ALTER TABLE [dbo].[voto_LogIn] CHECK CONSTRAINT [FK_voto_LogIn_voto_EstadoUser]
GO
ALTER TABLE [dbo].[voto_LogIn]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_LogIn_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_LogIn] CHECK CONSTRAINT [FK_voto_LogIn_voto_Users]
GO
ALTER TABLE [dbo].[voto_LogSeverity]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_LogSeverity_voto_Log] FOREIGN KEY([logId])
REFERENCES [dbo].[voto_Log] ([logId])
GO
ALTER TABLE [dbo].[voto_LogSeverity] CHECK CONSTRAINT [FK_voto_LogSeverity_voto_Log]
GO
ALTER TABLE [dbo].[voto_LogSources]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_LogSources_voto_Log] FOREIGN KEY([logId])
REFERENCES [dbo].[voto_Log] ([logId])
GO
ALTER TABLE [dbo].[voto_LogSources] CHECK CONSTRAINT [FK_voto_LogSources_voto_Log]
GO
ALTER TABLE [dbo].[voto_LogTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_LogTypes_voto_Log] FOREIGN KEY([logId])
REFERENCES [dbo].[voto_Log] ([logId])
GO
ALTER TABLE [dbo].[voto_LogTypes] CHECK CONSTRAINT [FK_voto_LogTypes_voto_Log]
GO
ALTER TABLE [dbo].[voto_MediaFiles]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_MediaFiles_voto_MediaTypes] FOREIGN KEY([mediaTypeId])
REFERENCES [dbo].[voto_MediaTypes] ([mediaTypeId])
GO
ALTER TABLE [dbo].[voto_MediaFiles] CHECK CONSTRAINT [FK_voto_MediaFiles_voto_MediaTypes]
GO
ALTER TABLE [dbo].[voto_MediosDisponibles]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_MediosDisponibles_voto_MetodosDePago] FOREIGN KEY([metodoPagoId])
REFERENCES [dbo].[voto_MetodosDePago] ([metodoPagoId])
GO
ALTER TABLE [dbo].[voto_MediosDisponibles] CHECK CONSTRAINT [FK_voto_MediosDisponibles_voto_MetodosDePago]
GO
ALTER TABLE [dbo].[voto_Modules]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Modules_voto_Languages] FOREIGN KEY([languajeId])
REFERENCES [dbo].[voto_Languages] ([languageId])
GO
ALTER TABLE [dbo].[voto_Modules] CHECK CONSTRAINT [FK_voto_Modules_voto_Languages]
GO
ALTER TABLE [dbo].[voto_Notifications]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Notifications_voto_notificationMedia] FOREIGN KEY([notificationMediaId])
REFERENCES [dbo].[voto_notificationMedia] ([notificationMediaId])
GO
ALTER TABLE [dbo].[voto_Notifications] CHECK CONSTRAINT [FK_voto_Notifications_voto_notificationMedia]
GO
ALTER TABLE [dbo].[voto_Notifications]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Notifications_voto_NotificationStatus] FOREIGN KEY([notificationStatusId])
REFERENCES [dbo].[voto_NotificationStatus] ([notificationStatusId])
GO
ALTER TABLE [dbo].[voto_Notifications] CHECK CONSTRAINT [FK_voto_Notifications_voto_NotificationStatus]
GO
ALTER TABLE [dbo].[voto_Notifications]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Notifications_voto_Users] FOREIGN KEY([receiveUserId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Notifications] CHECK CONSTRAINT [FK_voto_Notifications_voto_Users]
GO
ALTER TABLE [dbo].[voto_Notifications]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Notifications_voto_Users1] FOREIGN KEY([sendUserId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Notifications] CHECK CONSTRAINT [FK_voto_Notifications_voto_Users1]
GO
ALTER TABLE [dbo].[voto_OpcionesVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_OpcionesVotacion_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_OpcionesVotacion] CHECK CONSTRAINT [FK_voto_OpcionesVotacion_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_PagoInversiones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PagoInversiones_voto_Distribution] FOREIGN KEY([distributionId])
REFERENCES [dbo].[voto_Distribution] ([distributionId])
GO
ALTER TABLE [dbo].[voto_PagoInversiones] CHECK CONSTRAINT [FK_voto_PagoInversiones_voto_Distribution]
GO
ALTER TABLE [dbo].[voto_PagoInversiones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PagoInversiones_voto_Inversiones] FOREIGN KEY([inversionId])
REFERENCES [dbo].[voto_Inversiones] ([inversionId])
GO
ALTER TABLE [dbo].[voto_PagoInversiones] CHECK CONSTRAINT [FK_voto_PagoInversiones_voto_Inversiones]
GO
ALTER TABLE [dbo].[voto_PagoInversiones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PagoInversiones_voto_Schedules] FOREIGN KEY([scheduleId])
REFERENCES [dbo].[voto_Schedules] ([scheduleId])
GO
ALTER TABLE [dbo].[voto_PagoInversiones] CHECK CONSTRAINT [FK_voto_PagoInversiones_voto_Schedules]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Pagos_voto_Currencies] FOREIGN KEY([currencyId])
REFERENCES [dbo].[voto_Currencies] ([currencyId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_Pagos_voto_Currencies]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Pagos_voto_MediosDisponibles] FOREIGN KEY([pagoMedioId])
REFERENCES [dbo].[voto_MediosDisponibles] ([pagoMedioId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_Pagos_voto_MediosDisponibles]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Pagos_voto_MetodosDePago] FOREIGN KEY([metodoPagoId])
REFERENCES [dbo].[voto_MetodosDePago] ([metodoPagoId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_Pagos_voto_MetodosDePago]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Pagos_voto_Modules] FOREIGN KEY([moduleId])
REFERENCES [dbo].[voto_Modules] ([moduleId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_Pagos_voto_Modules]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Pagos_voto_Schedules] FOREIGN KEY([scheduleId])
REFERENCES [dbo].[voto_Schedules] ([scheduleId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_Pagos_voto_Schedules]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PagosInversionistas_voto_Inversiones] FOREIGN KEY([inversionId])
REFERENCES [dbo].[voto_Inversiones] ([inversionId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_PagosInversionistas_voto_Inversiones]
GO
ALTER TABLE [dbo].[voto_Pagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PagosInversionistas_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_Pagos] CHECK CONSTRAINT [FK_voto_PagosInversionistas_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_PapeletaAuditoria]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PapeletaAuditoria_voto_Dispositivos] FOREIGN KEY([dispositivoId])
REFERENCES [dbo].[voto_Dispositivos] ([dispositivoId])
GO
ALTER TABLE [dbo].[voto_PapeletaAuditoria] CHECK CONSTRAINT [FK_voto_PapeletaAuditoria_voto_Dispositivos]
GO
ALTER TABLE [dbo].[voto_PapeletaAuditoria]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PapeletaAuditoria_voto_Papeletas] FOREIGN KEY([papeletaId])
REFERENCES [dbo].[voto_Papeletas] ([papeletaId])
GO
ALTER TABLE [dbo].[voto_PapeletaAuditoria] CHECK CONSTRAINT [FK_voto_PapeletaAuditoria_voto_Papeletas]
GO
ALTER TABLE [dbo].[voto_PapeletaOpciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PapeletaOpciones_voto_PapeletaSecciones] FOREIGN KEY([seccionId])
REFERENCES [dbo].[voto_PapeletaSecciones] ([seccionId])
GO
ALTER TABLE [dbo].[voto_PapeletaOpciones] CHECK CONSTRAINT [FK_voto_PapeletaOpciones_voto_PapeletaSecciones]
GO
ALTER TABLE [dbo].[voto_Papeletas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Papeletas_voto_PapeletaPlantillas] FOREIGN KEY([plantillaId])
REFERENCES [dbo].[voto_PapeletaPlantillas] ([plantillaId])
GO
ALTER TABLE [dbo].[voto_Papeletas] CHECK CONSTRAINT [FK_voto_Papeletas_voto_PapeletaPlantillas]
GO
ALTER TABLE [dbo].[voto_Papeletas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Papeletas_voto_PapeletaSecciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_PapeletaSecciones] ([seccionId])
GO
ALTER TABLE [dbo].[voto_Papeletas] CHECK CONSTRAINT [FK_voto_Papeletas_voto_PapeletaSecciones]
GO
ALTER TABLE [dbo].[voto_Papeletas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Papeletas_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_Papeletas] CHECK CONSTRAINT [FK_voto_Papeletas_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_PapeletaSecciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PapeletaSecciones_voto_TipoSeccion] FOREIGN KEY([tipoSeccionId])
REFERENCES [dbo].[voto_TipoSeccion] ([tipoSeccionId])
GO
ALTER TABLE [dbo].[voto_PapeletaSecciones] CHECK CONSTRAINT [FK_voto_PapeletaSecciones_voto_TipoSeccion]
GO
ALTER TABLE [dbo].[voto_partnerDealBenefits]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_partnerDealBenefits_voto_DealBenefitTypes] FOREIGN KEY([dealBenefitTypeId])
REFERENCES [dbo].[voto_DealBenefitTypes] ([dealBenefitTypeId])
GO
ALTER TABLE [dbo].[voto_partnerDealBenefits] CHECK CONSTRAINT [FK_voto_partnerDealBenefits_voto_DealBenefitTypes]
GO
ALTER TABLE [dbo].[voto_partnerDealBenefits]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_partnerDealBenefits_voto_PartnerDeals] FOREIGN KEY([partnerDealId])
REFERENCES [dbo].[voto_PartnerDeals] ([partnerDealId])
GO
ALTER TABLE [dbo].[voto_partnerDealBenefits] CHECK CONSTRAINT [FK_voto_partnerDealBenefits_voto_PartnerDeals]
GO
ALTER TABLE [dbo].[voto_PartnerObligations]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PartnerObligations_voto_Currencies] FOREIGN KEY([currencyId])
REFERENCES [dbo].[voto_Currencies] ([currencyId])
GO
ALTER TABLE [dbo].[voto_PartnerObligations] CHECK CONSTRAINT [FK_voto_PartnerObligations_voto_Currencies]
GO
ALTER TABLE [dbo].[voto_PartnerObligations]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PartnerObligations_voto_PartnerDeals] FOREIGN KEY([partnerDealId])
REFERENCES [dbo].[voto_PartnerDeals] ([partnerDealId])
GO
ALTER TABLE [dbo].[voto_PartnerObligations] CHECK CONSTRAINT [FK_voto_PartnerObligations_voto_PartnerDeals]
GO
ALTER TABLE [dbo].[voto_PartnerObligationStorage]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PartnerObligationStorage_voto_PartnerObligations] FOREIGN KEY([partnerObligationId])
REFERENCES [dbo].[voto_PartnerObligations] ([partnerObligationId])
GO
ALTER TABLE [dbo].[voto_PartnerObligationStorage] CHECK CONSTRAINT [FK_voto_PartnerObligationStorage_voto_PartnerObligations]
GO
ALTER TABLE [dbo].[voto_Permissions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Permissions_voto_Modules] FOREIGN KEY([moduleId])
REFERENCES [dbo].[voto_Modules] ([moduleId])
GO
ALTER TABLE [dbo].[voto_Permissions] CHECK CONSTRAINT [FK_voto_Permissions_voto_Modules]
GO
ALTER TABLE [dbo].[voto_Personas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Personas_voto_Educacion] FOREIGN KEY([educaciónid])
REFERENCES [dbo].[voto_Educacion] ([nivelEducacionId])
GO
ALTER TABLE [dbo].[voto_Personas] CHECK CONSTRAINT [FK_voto_Personas_voto_Educacion]
GO
ALTER TABLE [dbo].[voto_Personas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Personas_voto_Profesion] FOREIGN KEY([profesionId])
REFERENCES [dbo].[voto_Profesion] ([profesionId])
GO
ALTER TABLE [dbo].[voto_Personas] CHECK CONSTRAINT [FK_voto_Personas_voto_Profesion]
GO
ALTER TABLE [dbo].[voto_Personas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Personas_voto_Sexo] FOREIGN KEY([sexoId])
REFERENCES [dbo].[voto_Sexo] ([sexoId])
GO
ALTER TABLE [dbo].[voto_Personas] CHECK CONSTRAINT [FK_voto_Personas_voto_Sexo]
GO
ALTER TABLE [dbo].[voto_PesoSegunSegmentoYVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PesoSegunSegmento_voto_Segmentos] FOREIGN KEY([segmentoId])
REFERENCES [dbo].[voto_Segmentos] ([segmentoId])
GO
ALTER TABLE [dbo].[voto_PesoSegunSegmentoYVotacion] CHECK CONSTRAINT [FK_voto_PesoSegunSegmento_voto_Segmentos]
GO
ALTER TABLE [dbo].[voto_PlanesDesembolso]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PlanesDesembolso_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_PlanesDesembolso] CHECK CONSTRAINT [FK_voto_PlanesDesembolso_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_PlanesDesembolso]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PlanesDesembolso_voto_Users] FOREIGN KEY([userIdAprobacion])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_PlanesDesembolso] CHECK CONSTRAINT [FK_voto_PlanesDesembolso_voto_Users]
GO
ALTER TABLE [dbo].[voto_PlanesTrabajo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PlanesTrabajo_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_PlanesTrabajo] CHECK CONSTRAINT [FK_voto_PlanesTrabajo_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_PreferenciasInversion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PreferenciasInversion_voto_Inversionistas] FOREIGN KEY([inversionistaId])
REFERENCES [dbo].[voto_Inversionistas] ([inversionistaId])
GO
ALTER TABLE [dbo].[voto_PreferenciasInversion] CHECK CONSTRAINT [FK_voto_PreferenciasInversion_voto_Inversionistas]
GO
ALTER TABLE [dbo].[voto_PreferenciasInversion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PreferenciasInversion_voto_TiposInversion] FOREIGN KEY([tipoInversionId])
REFERENCES [dbo].[voto_TiposInversion] ([tipoInversionId])
GO
ALTER TABLE [dbo].[voto_PreferenciasInversion] CHECK CONSTRAINT [FK_voto_PreferenciasInversion_voto_TiposInversion]
GO
ALTER TABLE [dbo].[voto_ProcesosManuales]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ProcesosManuales_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_ProcesosManuales] CHECK CONSTRAINT [FK_voto_ProcesosManuales_voto_Users]
GO
ALTER TABLE [dbo].[voto_Profesion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Profesion_voto_tipoProfesion] FOREIGN KEY([tipoProfesionId])
REFERENCES [dbo].[voto_tipoProfesion] ([tipoProfesionId])
GO
ALTER TABLE [dbo].[voto_Profesion] CHECK CONSTRAINT [FK_voto_Profesion_voto_tipoProfesion]
GO
ALTER TABLE [dbo].[voto_propuestaImpact]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_propuestaInput_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_propuestaImpact] CHECK CONSTRAINT [FK_voto_propuestaInput_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_propuestaImpact]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_propuestaInput_voto_Segmentos] FOREIGN KEY([segmentoId])
REFERENCES [dbo].[voto_Segmentos] ([segmentoId])
GO
ALTER TABLE [dbo].[voto_propuestaImpact] CHECK CONSTRAINT [FK_voto_propuestaInput_voto_Segmentos]
GO
ALTER TABLE [dbo].[voto_Propuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Propuestas_voto_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[voto_Propuestas] CHECK CONSTRAINT [FK_voto_Propuestas_voto_Estado]
GO
ALTER TABLE [dbo].[voto_Propuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Propuestas_voto_Instituciones] FOREIGN KEY([institucionId])
REFERENCES [dbo].[voto_Instituciones] ([institucionId])
GO
ALTER TABLE [dbo].[voto_Propuestas] CHECK CONSTRAINT [FK_voto_Propuestas_voto_Instituciones]
GO
ALTER TABLE [dbo].[voto_Propuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Propuestas_voto_ProposalType] FOREIGN KEY([proposalTypeId])
REFERENCES [dbo].[voto_ProposalType] ([proposalTypeId])
GO
ALTER TABLE [dbo].[voto_Propuestas] CHECK CONSTRAINT [FK_voto_Propuestas_voto_ProposalType]
GO
ALTER TABLE [dbo].[voto_Propuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Propuestas_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Propuestas] CHECK CONSTRAINT [FK_voto_Propuestas_voto_Users]
GO
ALTER TABLE [dbo].[voto_propuestaSegmentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_propuestaSegmentos_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_propuestaSegmentos] CHECK CONSTRAINT [FK_voto_propuestaSegmentos_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_propuestaSegmentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_propuestaSegmentos_voto_Segmentos] FOREIGN KEY([segmentoId])
REFERENCES [dbo].[voto_Segmentos] ([segmentoId])
GO
ALTER TABLE [dbo].[voto_propuestaSegmentos] CHECK CONSTRAINT [FK_voto_propuestaSegmentos_voto_Segmentos]
GO
ALTER TABLE [dbo].[voto_PruebasMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PruebasMedia_voto_MediaFiles] FOREIGN KEY([mediaFileId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_PruebasMedia] CHECK CONSTRAINT [FK_voto_PruebasMedia_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_PruebasMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PruebasMedia_voto_PruebasVida] FOREIGN KEY([pruebaId])
REFERENCES [dbo].[voto_PruebasVida] ([pruebaId])
GO
ALTER TABLE [dbo].[voto_PruebasMedia] CHECK CONSTRAINT [FK_voto_PruebasMedia_voto_PruebasVida]
GO
ALTER TABLE [dbo].[voto_PruebasVida]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PruebasVida_voto_Dispositivos] FOREIGN KEY([dispositivoId])
REFERENCES [dbo].[voto_Dispositivos] ([dispositivoId])
GO
ALTER TABLE [dbo].[voto_PruebasVida] CHECK CONSTRAINT [FK_voto_PruebasVida_voto_Dispositivos]
GO
ALTER TABLE [dbo].[voto_PruebasVida]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PruebasVida_voto_tipoPruebasVida] FOREIGN KEY([tipoPruebasVidaId])
REFERENCES [dbo].[voto_tipoPruebasVida] ([tipoPruebasVidaId])
GO
ALTER TABLE [dbo].[voto_PruebasVida] CHECK CONSTRAINT [FK_voto_PruebasVida_voto_tipoPruebasVida]
GO
ALTER TABLE [dbo].[voto_PruebasVida]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_PruebasVida_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_PruebasVida] CHECK CONSTRAINT [FK_voto_PruebasVida_voto_Users]
GO
ALTER TABLE [dbo].[voto_questions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_questions_voto_questionType] FOREIGN KEY([questionTypeId])
REFERENCES [dbo].[voto_questionType] ([questionTyoeId])
GO
ALTER TABLE [dbo].[voto_questions] CHECK CONSTRAINT [FK_voto_questions_voto_questionType]
GO
ALTER TABLE [dbo].[voto_recaudacionFondos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_recaudacionFondos_voto_Inversiones] FOREIGN KEY([inversionId])
REFERENCES [dbo].[voto_Inversiones] ([inversionId])
GO
ALTER TABLE [dbo].[voto_recaudacionFondos] CHECK CONSTRAINT [FK_voto_recaudacionFondos_voto_Inversiones]
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RegistroBiometrico_voto_BiometricErrors] FOREIGN KEY([biometricErrorId])
REFERENCES [dbo].[voto_BiometricErrors] ([biometricErrorId])
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico] CHECK CONSTRAINT [FK_voto_RegistroBiometrico_voto_BiometricErrors]
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RegistroBiometrico_voto_TipoBiometrico] FOREIGN KEY([tipoBiometricoId])
REFERENCES [dbo].[voto_TipoBiometrico] ([tipoBiomettricoId])
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico] CHECK CONSTRAINT [FK_voto_RegistroBiometrico_voto_TipoBiometrico]
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RegistroBiometrico_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_RegistroBiometrico] CHECK CONSTRAINT [FK_voto_RegistroBiometrico_voto_Users]
GO
ALTER TABLE [dbo].[voto_ReglasDecision]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReglasDecision_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_ReglasDecision] CHECK CONSTRAINT [FK_voto_ReglasDecision_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_ReglasVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReglasVotacion_voto_TiposDeReglas] FOREIGN KEY([tipoReglaId])
REFERENCES [dbo].[voto_TiposDeReglas] ([tipoReglaId])
GO
ALTER TABLE [dbo].[voto_ReglasVotacion] CHECK CONSTRAINT [FK_voto_ReglasVotacion_voto_TiposDeReglas]
GO
ALTER TABLE [dbo].[voto_ReglasVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReglasVotacion_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_ReglasVotacion] CHECK CONSTRAINT [FK_voto_ReglasVotacion_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_Renewal]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Renewal_voto_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[voto_Renewal] CHECK CONSTRAINT [FK_voto_Renewal_voto_Estado]
GO
ALTER TABLE [dbo].[voto_Renewal]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Renewal_voto_PartnerDeals] FOREIGN KEY([partnerDealId])
REFERENCES [dbo].[voto_PartnerDeals] ([partnerDealId])
GO
ALTER TABLE [dbo].[voto_Renewal] CHECK CONSTRAINT [FK_voto_Renewal_voto_PartnerDeals]
GO
ALTER TABLE [dbo].[voto_ReplicasVotos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReplicasVotos_voto_Votos] FOREIGN KEY([votoId])
REFERENCES [dbo].[voto_Votos] ([votoId])
GO
ALTER TABLE [dbo].[voto_ReplicasVotos] CHECK CONSTRAINT [FK_voto_ReplicasVotos_voto_Votos]
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReportesFinancieros_voto_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros] CHECK CONSTRAINT [FK_voto_ReportesFinancieros_voto_Estado]
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReportesFinancieros_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros] CHECK CONSTRAINT [FK_voto_ReportesFinancieros_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ReportesFinancieros_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_ReportesFinancieros] CHECK CONSTRAINT [FK_voto_ReportesFinancieros_voto_Users]
GO
ALTER TABLE [dbo].[voto_RepresentanteDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RepresentanteDoc_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_RepresentanteDoc] CHECK CONSTRAINT [FK_voto_RepresentanteDoc_voto_Documents]
GO
ALTER TABLE [dbo].[voto_RepresentanteDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RepresentanteDoc_voto_InstitucionRepresentantes] FOREIGN KEY([representanteId])
REFERENCES [dbo].[voto_InstitucionRepresentantes] ([representanteId])
GO
ALTER TABLE [dbo].[voto_RepresentanteDoc] CHECK CONSTRAINT [FK_voto_RepresentanteDoc_voto_InstitucionRepresentantes]
GO
ALTER TABLE [dbo].[voto_RepresentanteDoc]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RepresentanteDoc_voto_InstitucionRepresentantes1] FOREIGN KEY([representanteId])
REFERENCES [dbo].[voto_InstitucionRepresentantes] ([representanteId])
GO
ALTER TABLE [dbo].[voto_RepresentanteDoc] CHECK CONSTRAINT [FK_voto_RepresentanteDoc_voto_InstitucionRepresentantes1]
GO
ALTER TABLE [dbo].[voto_RequisitosDocumentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RequisitosDocumentos_voto_TiposVotacion] FOREIGN KEY([tipoVotacionId])
REFERENCES [dbo].[voto_TiposVotacion] ([tipoVotacionId])
GO
ALTER TABLE [dbo].[voto_RequisitosDocumentos] CHECK CONSTRAINT [FK_voto_RequisitosDocumentos_voto_TiposVotacion]
GO
ALTER TABLE [dbo].[voto_ResultadoPropuestas]  WITH CHECK ADD  CONSTRAINT [FK_ResultadoPropuestas_Propuesta] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_ResultadoPropuestas] CHECK CONSTRAINT [FK_ResultadoPropuestas_Propuesta]
GO
ALTER TABLE [dbo].[voto_ResultadoPropuestas]  WITH CHECK ADD  CONSTRAINT [FK_voto_ResultadoPropuestas_voto_Votos] FOREIGN KEY([votoId])
REFERENCES [dbo].[voto_Votos] ([votoId])
GO
ALTER TABLE [dbo].[voto_ResultadoPropuestas] CHECK CONSTRAINT [FK_voto_ResultadoPropuestas_voto_Votos]
GO
ALTER TABLE [dbo].[voto_ResultadosPropuestas]  WITH CHECK ADD FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_ResultadosPropuestas]  WITH CHECK ADD FOREIGN KEY([votoId])
REFERENCES [dbo].[voto_Votos] ([votoId])
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RolPoliticasAcceso_voto_PoliticasAcceso] FOREIGN KEY([politicaId])
REFERENCES [dbo].[voto_PoliticasAcceso] ([politicaId])
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso] CHECK CONSTRAINT [FK_voto_RolPoliticasAcceso_voto_PoliticasAcceso]
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RolPoliticasAcceso_voto_Roles] FOREIGN KEY([roleId])
REFERENCES [dbo].[voto_Roles] ([roleId])
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso] CHECK CONSTRAINT [FK_voto_RolPoliticasAcceso_voto_Roles]
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_RolPoliticasAcceso_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_RolPoliticasAcceso] CHECK CONSTRAINT [FK_voto_RolPoliticasAcceso_voto_Users]
GO
ALTER TABLE [dbo].[voto_ScheduleDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_ScheduleDetails_voto_Schedules] FOREIGN KEY([scheduleId])
REFERENCES [dbo].[voto_Schedules] ([scheduleId])
GO
ALTER TABLE [dbo].[voto_ScheduleDetails] CHECK CONSTRAINT [FK_voto_ScheduleDetails_voto_Schedules]
GO
ALTER TABLE [dbo].[voto_SignUp]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_SignUp_voto_Dispositivos] FOREIGN KEY([dispositivoId])
REFERENCES [dbo].[voto_Dispositivos] ([dispositivoId])
GO
ALTER TABLE [dbo].[voto_SignUp] CHECK CONSTRAINT [FK_voto_SignUp_voto_Dispositivos]
GO
ALTER TABLE [dbo].[voto_SignUp]  WITH CHECK ADD  CONSTRAINT [FK_voto_SignUp_voto_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[voto_SignUp] CHECK CONSTRAINT [FK_voto_SignUp_voto_Estado]
GO
ALTER TABLE [dbo].[voto_States]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_States_voto_Countries] FOREIGN KEY([countryId])
REFERENCES [dbo].[voto_Countries] ([countryId])
GO
ALTER TABLE [dbo].[voto_States] CHECK CONSTRAINT [FK_voto_States_voto_Countries]
GO
ALTER TABLE [dbo].[voto_TipoRepresentante]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_TipoRepresentante_voto_TipoCedula] FOREIGN KEY([tipoCedulaId])
REFERENCES [dbo].[voto_TipoCedula] ([tipoCedulaId])
GO
ALTER TABLE [dbo].[voto_TipoRepresentante] CHECK CONSTRAINT [FK_voto_TipoRepresentante_voto_TipoCedula]
GO
ALTER TABLE [dbo].[voto_Transacciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Transacciones_voto_InversionistaBalance] FOREIGN KEY([inversionistaBalanceId])
REFERENCES [dbo].[voto_InversionistaBalance] ([personBalanceId])
GO
ALTER TABLE [dbo].[voto_Transacciones] CHECK CONSTRAINT [FK_voto_Transacciones_voto_InversionistaBalance]
GO
ALTER TABLE [dbo].[voto_Transacciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Transacciones_voto_transTypes] FOREIGN KEY([transTypeId])
REFERENCES [dbo].[voto_transTypes] ([transTypeId])
GO
ALTER TABLE [dbo].[voto_Transacciones] CHECK CONSTRAINT [FK_voto_Transacciones_voto_transTypes]
GO
ALTER TABLE [dbo].[voto_translations]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_translations_voto_Languages] FOREIGN KEY([languajeId])
REFERENCES [dbo].[voto_Languages] ([languageId])
GO
ALTER TABLE [dbo].[voto_translations] CHECK CONSTRAINT [FK_voto_translations_voto_Languages]
GO
ALTER TABLE [dbo].[voto_UserAdresses]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserAdresses_caipi_adresses] FOREIGN KEY([adressId])
REFERENCES [dbo].[voto_adresses] ([adressId])
GO
ALTER TABLE [dbo].[voto_UserAdresses] CHECK CONSTRAINT [FK_voto_UserAdresses_caipi_adresses]
GO
ALTER TABLE [dbo].[voto_UserAdresses]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserAdresses_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_UserAdresses] CHECK CONSTRAINT [FK_voto_UserAdresses_voto_Users]
GO
ALTER TABLE [dbo].[voto_UserDocs]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserDocs_voto_Documents] FOREIGN KEY([documentoId])
REFERENCES [dbo].[voto_Documents] ([documentoId])
GO
ALTER TABLE [dbo].[voto_UserDocs] CHECK CONSTRAINT [FK_voto_UserDocs_voto_Documents]
GO
ALTER TABLE [dbo].[voto_UserDocs]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserDocs_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_UserDocs] CHECK CONSTRAINT [FK_voto_UserDocs_voto_Users]
GO
ALTER TABLE [dbo].[voto_UserMediaFiles]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserMediaFiles_voto_MediaFiles] FOREIGN KEY([mediaFileId])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_UserMediaFiles] CHECK CONSTRAINT [FK_voto_UserMediaFiles_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_UserMediaFiles]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserMediaFiles_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_UserMediaFiles] CHECK CONSTRAINT [FK_voto_UserMediaFiles_voto_Users]
GO
ALTER TABLE [dbo].[voto_UserPermissions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserPermissions_voto_Permissions] FOREIGN KEY([permissionId])
REFERENCES [dbo].[voto_Permissions] ([permissionId])
GO
ALTER TABLE [dbo].[voto_UserPermissions] CHECK CONSTRAINT [FK_voto_UserPermissions_voto_Permissions]
GO
ALTER TABLE [dbo].[voto_UserPermissions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserPermissions_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_UserPermissions] CHECK CONSTRAINT [FK_voto_UserPermissions_voto_Users]
GO
ALTER TABLE [dbo].[voto_UserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserRoles_voto_Roles] FOREIGN KEY([roleId])
REFERENCES [dbo].[voto_Roles] ([roleId])
GO
ALTER TABLE [dbo].[voto_UserRoles] CHECK CONSTRAINT [FK_voto_UserRoles_voto_Roles]
GO
ALTER TABLE [dbo].[voto_UserRoles]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_UserRoles_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_UserRoles] CHECK CONSTRAINT [FK_voto_UserRoles_voto_Users]
GO
ALTER TABLE [dbo].[voto_Users]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Users_voto_compartición] FOREIGN KEY([comparticionId])
REFERENCES [dbo].[voto_comparticion] ([comparticionId])
GO
ALTER TABLE [dbo].[voto_Users] CHECK CONSTRAINT [FK_voto_Users_voto_compartición]
GO
ALTER TABLE [dbo].[voto_Users]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Users_voto_SignUp] FOREIGN KEY([signUpId])
REFERENCES [dbo].[voto_SignUp] ([signUpId])
GO
ALTER TABLE [dbo].[voto_Users] CHECK CONSTRAINT [FK_voto_Users_voto_SignUp]
GO
ALTER TABLE [dbo].[voto_Users]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Users_voto_TipoUser] FOREIGN KEY([tipoUserId])
REFERENCES [dbo].[voto_TipoUser] ([tipoUserId])
GO
ALTER TABLE [dbo].[voto_Users] CHECK CONSTRAINT [FK_voto_Users_voto_TipoUser]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_EstadoVotacion] FOREIGN KEY([estadoId])
REFERENCES [dbo].[voto_EstadoVotacion] ([estadoId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_EstadoVotacion]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_Instituciones] FOREIGN KEY([institucionId])
REFERENCES [dbo].[voto_Instituciones] ([institucionId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_Instituciones]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_Notifications1] FOREIGN KEY([notificationId])
REFERENCES [dbo].[voto_Notifications] ([notificationId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_Notifications1]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_questions] FOREIGN KEY([questionId])
REFERENCES [dbo].[voto_questions] ([questionId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_questions]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_TiposVotacion] FOREIGN KEY([tipoVotacionId])
REFERENCES [dbo].[voto_TiposVotacion] ([tipoVotacionId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_TiposVotacion]
GO
ALTER TABLE [dbo].[voto_Votaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votaciones_voto_Users] FOREIGN KEY([creadorId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Votaciones] CHECK CONSTRAINT [FK_voto_Votaciones_voto_Users]
GO
ALTER TABLE [dbo].[voto_VotacionesApoyo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_VotacionesApoyo_voto_Propuestas] FOREIGN KEY([propuestaId])
REFERENCES [dbo].[voto_Propuestas] ([propuestaId])
GO
ALTER TABLE [dbo].[voto_VotacionesApoyo] CHECK CONSTRAINT [FK_voto_VotacionesApoyo_voto_Propuestas]
GO
ALTER TABLE [dbo].[voto_VotacionesApoyo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_VotacionesApoyo_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_VotacionesApoyo] CHECK CONSTRAINT [FK_voto_VotacionesApoyo_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_VotacionesFiscalizacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_VotacionesFiscalizacion_voto_Fiscalizaciones] FOREIGN KEY([fiscalizacionId])
REFERENCES [dbo].[voto_Fiscalizaciones] ([fiscalizacionId])
GO
ALTER TABLE [dbo].[voto_VotacionesFiscalizacion] CHECK CONSTRAINT [FK_voto_VotacionesFiscalizacion_voto_Fiscalizaciones]
GO
ALTER TABLE [dbo].[voto_VotacionesFiscalizacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_VotacionesFiscalizacion_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_VotacionesFiscalizacion] CHECK CONSTRAINT [FK_voto_VotacionesFiscalizacion_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_VotacionesXSegmentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_VotacionesXSegmentos_voto_Segmentos] FOREIGN KEY([segmentoId])
REFERENCES [dbo].[voto_Segmentos] ([segmentoId])
GO
ALTER TABLE [dbo].[voto_VotacionesXSegmentos] CHECK CONSTRAINT [FK_voto_VotacionesXSegmentos_voto_Segmentos]
GO
ALTER TABLE [dbo].[voto_VotacionesXSegmentos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_VotacionesXSegmentos_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_VotacionesXSegmentos] CHECK CONSTRAINT [FK_voto_VotacionesXSegmentos_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_Votos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votos_voto_OpcionesVotacion] FOREIGN KEY([opcionId])
REFERENCES [dbo].[voto_OpcionesVotacion] ([opcionId])
GO
ALTER TABLE [dbo].[voto_Votos] CHECK CONSTRAINT [FK_voto_Votos_voto_OpcionesVotacion]
GO
ALTER TABLE [dbo].[voto_Votos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votos_voto_Papeletas] FOREIGN KEY([papeletaId])
REFERENCES [dbo].[voto_Papeletas] ([papeletaId])
GO
ALTER TABLE [dbo].[voto_Votos] CHECK CONSTRAINT [FK_voto_Votos_voto_Papeletas]
GO
ALTER TABLE [dbo].[voto_Votos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votos_voto_PesoSegunSegmentoYVotacion] FOREIGN KEY([pesoId])
REFERENCES [dbo].[voto_PesoSegunSegmentoYVotacion] ([pesoId])
GO
ALTER TABLE [dbo].[voto_Votos] CHECK CONSTRAINT [FK_voto_Votos_voto_PesoSegunSegmentoYVotacion]
GO
ALTER TABLE [dbo].[voto_Votos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votos_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_Votos] CHECK CONSTRAINT [FK_voto_Votos_voto_Users]
GO
ALTER TABLE [dbo].[voto_Votos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_Votos_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_Votos] CHECK CONSTRAINT [FK_voto_Votos_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_WorkAquien]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkAquien_voto_AquienInterese] FOREIGN KEY([aQuienInterese])
REFERENCES [dbo].[voto_AquienInterese] ([aQuienIntereseId])
GO
ALTER TABLE [dbo].[voto_WorkAquien] CHECK CONSTRAINT [FK_voto_WorkAquien_voto_AquienInterese]
GO
ALTER TABLE [dbo].[voto_WorkAquien]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkAquien_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkAquien] CHECK CONSTRAINT [FK_voto_WorkAquien_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkAuditoria]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkAuditoria_voto_PapeletaAuditoria] FOREIGN KEY([auditoriaId])
REFERENCES [dbo].[voto_PapeletaAuditoria] ([auditoriaId])
GO
ALTER TABLE [dbo].[voto_WorkAuditoria] CHECK CONSTRAINT [FK_voto_WorkAuditoria_voto_PapeletaAuditoria]
GO
ALTER TABLE [dbo].[voto_WorkAuditoria]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkAuditoria_wk_workflow] FOREIGN KEY([workFlow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkAuditoria] CHECK CONSTRAINT [FK_voto_WorkAuditoria_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkAvalesPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkAvalesPropuesta_voto_AvalesPropuesta] FOREIGN KEY([avalId])
REFERENCES [dbo].[voto_AvalesPropuesta] ([avalId])
GO
ALTER TABLE [dbo].[voto_WorkAvalesPropuesta] CHECK CONSTRAINT [FK_voto_WorkAvalesPropuesta_voto_AvalesPropuesta]
GO
ALTER TABLE [dbo].[voto_WorkAvalesPropuesta]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkAvalesPropuesta_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkAvalesPropuesta] CHECK CONSTRAINT [FK_voto_WorkAvalesPropuesta_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkBalance]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkBalance_voto_InversionistaBalance] FOREIGN KEY([personBalanceId])
REFERENCES [dbo].[voto_InversionistaBalance] ([personBalanceId])
GO
ALTER TABLE [dbo].[voto_WorkBalance] CHECK CONSTRAINT [FK_voto_WorkBalance_voto_InversionistaBalance]
GO
ALTER TABLE [dbo].[voto_WorkBalance]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkBalance_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkBalance] CHECK CONSTRAINT [FK_voto_WorkBalance_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkBenefitRestrictions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkBenefitRestrictions_voto_BenefitRestrictions] FOREIGN KEY([benefitRestrictionId])
REFERENCES [dbo].[voto_BenefitRestrictions] ([benefitRestrictionId])
GO
ALTER TABLE [dbo].[voto_WorkBenefitRestrictions] CHECK CONSTRAINT [FK_voto_WorkBenefitRestrictions_voto_BenefitRestrictions]
GO
ALTER TABLE [dbo].[voto_WorkBenefitRestrictions]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkBenefitRestrictions_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkBenefitRestrictions] CHECK CONSTRAINT [FK_voto_WorkBenefitRestrictions_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkCondiciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkCondiciones_voto_CondicionesGubernamentales] FOREIGN KEY([condicionId])
REFERENCES [dbo].[voto_CondicionesGubernamentales] ([condicionId])
GO
ALTER TABLE [dbo].[voto_WorkCondiciones] CHECK CONSTRAINT [FK_voto_WorkCondiciones_voto_CondicionesGubernamentales]
GO
ALTER TABLE [dbo].[voto_WorkCondiciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkCondiciones_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkCondiciones] CHECK CONSTRAINT [FK_voto_WorkCondiciones_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkConfigVisualizacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkConfigVisualizacion_voto_ConfigVisualizacion] FOREIGN KEY([configId])
REFERENCES [dbo].[voto_ConfigVisualizacion] ([configId])
GO
ALTER TABLE [dbo].[voto_WorkConfigVisualizacion] CHECK CONSTRAINT [FK_voto_WorkConfigVisualizacion_voto_ConfigVisualizacion]
GO
ALTER TABLE [dbo].[voto_WorkConfigVisualizacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkConfigVisualizacion_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkConfigVisualizacion] CHECK CONSTRAINT [FK_voto_WorkConfigVisualizacion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkDealBenefitTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDealBenefitTypes_voto_DealBenefitTypes] FOREIGN KEY([dealMediaTypeId])
REFERENCES [dbo].[voto_DealBenefitTypes] ([dealBenefitTypeId])
GO
ALTER TABLE [dbo].[voto_WorkDealBenefitTypes] CHECK CONSTRAINT [FK_voto_WorkDealBenefitTypes_voto_DealBenefitTypes]
GO
ALTER TABLE [dbo].[voto_WorkDealBenefitTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDealBenefitTypes_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkDealBenefitTypes] CHECK CONSTRAINT [FK_voto_WorkDealBenefitTypes_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkDesembolsos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDesembolsos_voto_Desembolsos] FOREIGN KEY([desembolsoId])
REFERENCES [dbo].[voto_Desembolsos] ([desembolsoId])
GO
ALTER TABLE [dbo].[voto_WorkDesembolsos] CHECK CONSTRAINT [FK_voto_WorkDesembolsos_voto_Desembolsos]
GO
ALTER TABLE [dbo].[voto_WorkDesembolsos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDesembolsos_wk_workflow] FOREIGN KEY([workFlowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkDesembolsos] CHECK CONSTRAINT [FK_voto_WorkDesembolsos_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkDocTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDocTypes_voto_DocTypes] FOREIGN KEY([docTypeId])
REFERENCES [dbo].[voto_DocTypes] ([docTypeId])
GO
ALTER TABLE [dbo].[voto_WorkDocTypes] CHECK CONSTRAINT [FK_voto_WorkDocTypes_voto_DocTypes]
GO
ALTER TABLE [dbo].[voto_WorkDocTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDocTypes_wk_workflow] FOREIGN KEY([workFlowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkDocTypes] CHECK CONSTRAINT [FK_voto_WorkDocTypes_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkDocumentosVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkDocumentosVotacion_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkDocumentosVotacion] CHECK CONSTRAINT [FK_voto_WorkDocumentosVotacion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkFiscalizaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkFiscalizaciones_voto_Fiscalizaciones] FOREIGN KEY([fiscalizacionId])
REFERENCES [dbo].[voto_Fiscalizaciones] ([fiscalizacionId])
GO
ALTER TABLE [dbo].[voto_WorkFiscalizaciones] CHECK CONSTRAINT [FK_voto_WorkFiscalizaciones_voto_Fiscalizaciones]
GO
ALTER TABLE [dbo].[voto_WorkFiscalizaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkFiscalizaciones_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkFiscalizaciones] CHECK CONSTRAINT [FK_voto_WorkFiscalizaciones_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkGruposAvaladores]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkGruposAvaladores_voto_GruposAvaladores] FOREIGN KEY([grupoId])
REFERENCES [dbo].[voto_GruposAvaladores] ([grupoId])
GO
ALTER TABLE [dbo].[voto_WorkGruposAvaladores] CHECK CONSTRAINT [FK_voto_WorkGruposAvaladores_voto_GruposAvaladores]
GO
ALTER TABLE [dbo].[voto_WorkGruposAvaladores]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkGruposAvaladores_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkGruposAvaladores] CHECK CONSTRAINT [FK_voto_WorkGruposAvaladores_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkGruposAvaladores]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkGruposAvaladores_wk_workflow1] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkGruposAvaladores] CHECK CONSTRAINT [FK_voto_WorkGruposAvaladores_wk_workflow1]
GO
ALTER TABLE [dbo].[voto_WorkHistorial]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WordHistorial_voto_HistorialIntereses] FOREIGN KEY([historialIdd])
REFERENCES [dbo].[voto_HistorialIntereses] ([historialId])
GO
ALTER TABLE [dbo].[voto_WorkHistorial] CHECK CONSTRAINT [FK_voto_WordHistorial_voto_HistorialIntereses]
GO
ALTER TABLE [dbo].[voto_WorkHistorial]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkHistorial_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkHistorial] CHECK CONSTRAINT [FK_voto_WorkHistorial_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkHitos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkHitos_voto_HitosPlanTrabajo] FOREIGN KEY([hitoId])
REFERENCES [dbo].[voto_HitosPlanTrabajo] ([hitoId])
GO
ALTER TABLE [dbo].[voto_WorkHitos] CHECK CONSTRAINT [FK_voto_WorkHitos_voto_HitosPlanTrabajo]
GO
ALTER TABLE [dbo].[voto_WorkHitos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkHitos_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkHitos] CHECK CONSTRAINT [FK_voto_WorkHitos_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkInversionista]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkInversionista_voto_Inversionistas] FOREIGN KEY([inversionistaId])
REFERENCES [dbo].[voto_Inversionistas] ([inversionistaId])
GO
ALTER TABLE [dbo].[voto_WorkInversionista] CHECK CONSTRAINT [FK_voto_WorkInversionista_voto_Inversionistas]
GO
ALTER TABLE [dbo].[voto_WorkInversionista]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkInversionista_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkInversionista] CHECK CONSTRAINT [FK_voto_WorkInversionista_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkMedia_voto_MediaFiles] FOREIGN KEY([mediaFileID])
REFERENCES [dbo].[voto_MediaFiles] ([mediaFileId])
GO
ALTER TABLE [dbo].[voto_WorkMedia] CHECK CONSTRAINT [FK_voto_WorkMedia_voto_MediaFiles]
GO
ALTER TABLE [dbo].[voto_WorkMedia]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkMedia_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkMedia] CHECK CONSTRAINT [FK_voto_WorkMedia_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkOpcionesVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkOpcionesVotacion_voto_OpcionesVotacion] FOREIGN KEY([opcionId])
REFERENCES [dbo].[voto_OpcionesVotacion] ([opcionId])
GO
ALTER TABLE [dbo].[voto_WorkOpcionesVotacion] CHECK CONSTRAINT [FK_voto_WorkOpcionesVotacion_voto_OpcionesVotacion]
GO
ALTER TABLE [dbo].[voto_WorkOpcionesVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkOpcionesVotacion_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkOpcionesVotacion] CHECK CONSTRAINT [FK_voto_WorkOpcionesVotacion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkOpcionesVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkOpcionesVotacion_wk_workflow1] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkOpcionesVotacion] CHECK CONSTRAINT [FK_voto_WorkOpcionesVotacion_wk_workflow1]
GO
ALTER TABLE [dbo].[voto_WorkPagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPagos_voto_Pagos] FOREIGN KEY([pagoId])
REFERENCES [dbo].[voto_Pagos] ([pagoId])
GO
ALTER TABLE [dbo].[voto_WorkPagos] CHECK CONSTRAINT [FK_voto_WorkPagos_voto_Pagos]
GO
ALTER TABLE [dbo].[voto_WorkPagos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPagos_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPagos] CHECK CONSTRAINT [FK_voto_WorkPagos_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPapeletasOpciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPapeletasOpciones_voto_PapeletaOpciones] FOREIGN KEY([opcionId])
REFERENCES [dbo].[voto_PapeletaOpciones] ([opcionId])
GO
ALTER TABLE [dbo].[voto_WorkPapeletasOpciones] CHECK CONSTRAINT [FK_voto_WorkPapeletasOpciones_voto_PapeletaOpciones]
GO
ALTER TABLE [dbo].[voto_WorkPapeletasOpciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPapeletasOpciones_wk_workflow] FOREIGN KEY([workFlow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPapeletasOpciones] CHECK CONSTRAINT [FK_voto_WorkPapeletasOpciones_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPartnerDeals]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPartnerDeals_voto_PartnerDeals] FOREIGN KEY([partnerDealId])
REFERENCES [dbo].[voto_PartnerDeals] ([partnerDealId])
GO
ALTER TABLE [dbo].[voto_WorkPartnerDeals] CHECK CONSTRAINT [FK_voto_WorkPartnerDeals_voto_PartnerDeals]
GO
ALTER TABLE [dbo].[voto_WorkPartnerDeals]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPartnerDeals_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPartnerDeals] CHECK CONSTRAINT [FK_voto_WorkPartnerDeals_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPartnerObligations]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPartnerObligations_voto_PartnerObligations] FOREIGN KEY([partnerObligationId])
REFERENCES [dbo].[voto_PartnerObligations] ([partnerObligationId])
GO
ALTER TABLE [dbo].[voto_WorkPartnerObligations] CHECK CONSTRAINT [FK_voto_WorkPartnerObligations_voto_PartnerObligations]
GO
ALTER TABLE [dbo].[voto_WorkPartnerObligations]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPartnerObligations_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPartnerObligations] CHECK CONSTRAINT [FK_voto_WorkPartnerObligations_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPersonas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPersonas_voto_Personas] FOREIGN KEY([personId])
REFERENCES [dbo].[voto_Personas] ([personId])
GO
ALTER TABLE [dbo].[voto_WorkPersonas] CHECK CONSTRAINT [FK_voto_WorkPersonas_voto_Personas]
GO
ALTER TABLE [dbo].[voto_WorkPersonas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPersonas_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPersonas] CHECK CONSTRAINT [FK_voto_WorkPersonas_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPlantillas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPlantillas_voto_PapeletaPlantillas] FOREIGN KEY([plantillaId])
REFERENCES [dbo].[voto_PapeletaPlantillas] ([plantillaId])
GO
ALTER TABLE [dbo].[voto_WorkPlantillas] CHECK CONSTRAINT [FK_voto_WorkPlantillas_voto_PapeletaPlantillas]
GO
ALTER TABLE [dbo].[voto_WorkPlantillas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPlantillas_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPlantillas] CHECK CONSTRAINT [FK_voto_WorkPlantillas_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPlanTrabajo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPlanTrabajo_voto_PlanesTrabajo] FOREIGN KEY([planId])
REFERENCES [dbo].[voto_PlanesTrabajo] ([planId])
GO
ALTER TABLE [dbo].[voto_WorkPlanTrabajo] CHECK CONSTRAINT [FK_voto_WorkPlanTrabajo_voto_PlanesTrabajo]
GO
ALTER TABLE [dbo].[voto_WorkPlanTrabajo]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPlanTrabajo_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPlanTrabajo] CHECK CONSTRAINT [FK_voto_WorkPlanTrabajo_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPreferencias]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPreferencias_voto_PreferenciasInversion] FOREIGN KEY([preferenciaId])
REFERENCES [dbo].[voto_PreferenciasInversion] ([preferenciaId])
GO
ALTER TABLE [dbo].[voto_WorkPreferencias] CHECK CONSTRAINT [FK_voto_WorkPreferencias_voto_PreferenciasInversion]
GO
ALTER TABLE [dbo].[voto_WorkPreferencias]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPreferencias_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPreferencias] CHECK CONSTRAINT [FK_voto_WorkPreferencias_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPublicaciones_voto_CrowdfundingPublicaciones] FOREIGN KEY([publicacionId])
REFERENCES [dbo].[voto_CrowdfundingPublicaciones] ([publicacionId])
GO
ALTER TABLE [dbo].[voto_WorkPublicaciones] CHECK CONSTRAINT [FK_voto_WorkPublicaciones_voto_CrowdfundingPublicaciones]
GO
ALTER TABLE [dbo].[voto_WorkPublicaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPublicaciones_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkPublicaciones] CHECK CONSTRAINT [FK_voto_WorkPublicaciones_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkReplica]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkReplica_voto_ReplicasVotos] FOREIGN KEY([replicaId])
REFERENCES [dbo].[voto_ReplicasVotos] ([replicaId])
GO
ALTER TABLE [dbo].[voto_WorkReplica] CHECK CONSTRAINT [FK_voto_WorkReplica_voto_ReplicasVotos]
GO
ALTER TABLE [dbo].[voto_WorkReplica]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkReplica_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkReplica] CHECK CONSTRAINT [FK_voto_WorkReplica_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkReportesFinancieros]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkReportesFinancieros_voto_ReportesFinancieros] FOREIGN KEY([reporteId])
REFERENCES [dbo].[voto_ReportesFinancieros] ([reporteId])
GO
ALTER TABLE [dbo].[voto_WorkReportesFinancieros] CHECK CONSTRAINT [FK_voto_WorkReportesFinancieros_voto_ReportesFinancieros]
GO
ALTER TABLE [dbo].[voto_WorkReportesFinancieros]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkReportesFinancieros_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkReportesFinancieros] CHECK CONSTRAINT [FK_voto_WorkReportesFinancieros_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkSignUp]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkSignUp_voto_SignUp] FOREIGN KEY([signUpId])
REFERENCES [dbo].[voto_SignUp] ([signUpId])
GO
ALTER TABLE [dbo].[voto_WorkSignUp] CHECK CONSTRAINT [FK_voto_WorkSignUp_voto_SignUp]
GO
ALTER TABLE [dbo].[voto_WorkSignUp]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkSignUp_wk_workflow] FOREIGN KEY([workflow_Id])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkSignUp] CHECK CONSTRAINT [FK_voto_WorkSignUp_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoBiometrico]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoBiometrico_voto_TipoBiometrico] FOREIGN KEY([tipoBiometricoId])
REFERENCES [dbo].[voto_TipoBiometrico] ([tipoBiomettricoId])
GO
ALTER TABLE [dbo].[voto_WorkTipoBiometrico] CHECK CONSTRAINT [FK_voto_WorkTipoBiometrico_voto_TipoBiometrico]
GO
ALTER TABLE [dbo].[voto_WorkTipoBiometrico]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoBiometrico_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoBiometrico] CHECK CONSTRAINT [FK_voto_WorkTipoBiometrico_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoCedula]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoCedula_voto_TipoCedula] FOREIGN KEY([tipoCedulaId])
REFERENCES [dbo].[voto_TipoCedula] ([tipoCedulaId])
GO
ALTER TABLE [dbo].[voto_WorkTipoCedula] CHECK CONSTRAINT [FK_voto_WorkTipoCedula_voto_TipoCedula]
GO
ALTER TABLE [dbo].[voto_WorkTipoCedula]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoCedula_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoCedula] CHECK CONSTRAINT [FK_voto_WorkTipoCedula_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoComentarios]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoComentarios_voto_TipoComentario] FOREIGN KEY([tipoComentarioId])
REFERENCES [dbo].[voto_TipoComentario] ([tipoComentarioId])
GO
ALTER TABLE [dbo].[voto_WorkTipoComentarios] CHECK CONSTRAINT [FK_voto_WorkTipoComentarios_voto_TipoComentario]
GO
ALTER TABLE [dbo].[voto_WorkTipoComentarios]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoComentarios_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoComentarios] CHECK CONSTRAINT [FK_voto_WorkTipoComentarios_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoEducacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoEducacion_voto_tipoEducacion] FOREIGN KEY([tipoEducacionId])
REFERENCES [dbo].[voto_tipoEducacion] ([tipoEducacionId])
GO
ALTER TABLE [dbo].[voto_WorkTipoEducacion] CHECK CONSTRAINT [FK_voto_WorkTipoEducacion_voto_tipoEducacion]
GO
ALTER TABLE [dbo].[voto_WorkTipoEducacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoEducacion_wk_workflow] FOREIGN KEY([workFlow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoEducacion] CHECK CONSTRAINT [FK_voto_WorkTipoEducacion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoEstadisticas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoEstadisticas_voto_TipoEstadistica] FOREIGN KEY([tipoEstadisticaId])
REFERENCES [dbo].[voto_TipoEstadistica] ([tipoEstadisticaId])
GO
ALTER TABLE [dbo].[voto_WorkTipoEstadisticas] CHECK CONSTRAINT [FK_voto_WorkTipoEstadisticas_voto_TipoEstadistica]
GO
ALTER TABLE [dbo].[voto_WorkTipoEstadisticas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoEstadisticas_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoEstadisticas] CHECK CONSTRAINT [FK_voto_WorkTipoEstadisticas_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoInstitucion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoInstitucion_voto_TipoInstitucion] FOREIGN KEY([tipoInstitucionId])
REFERENCES [dbo].[voto_TipoInstitucion] ([tipoInstitucioneId])
GO
ALTER TABLE [dbo].[voto_WorkTipoInstitucion] CHECK CONSTRAINT [FK_voto_WorkTipoInstitucion_voto_TipoInstitucion]
GO
ALTER TABLE [dbo].[voto_WorkTipoInstitucion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoInstitucion_wk_workflow] FOREIGN KEY([workdflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoInstitucion] CHECK CONSTRAINT [FK_voto_WorkTipoInstitucion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoInteres]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoInteres_voto_TiposIntereses] FOREIGN KEY([tipoInteresId])
REFERENCES [dbo].[voto_TiposIntereses] ([tipoInteresId])
GO
ALTER TABLE [dbo].[voto_WorkTipoInteres] CHECK CONSTRAINT [FK_voto_WorkTipoInteres_voto_TiposIntereses]
GO
ALTER TABLE [dbo].[voto_WorkTipoInteres]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoInteres_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoInteres] CHECK CONSTRAINT [FK_voto_WorkTipoInteres_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoInversion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoInversion_voto_TiposInversion] FOREIGN KEY([tipoInversionId])
REFERENCES [dbo].[voto_TiposInversion] ([tipoInversionId])
GO
ALTER TABLE [dbo].[voto_WorkTipoInversion] CHECK CONSTRAINT [FK_voto_WorkTipoInversion_voto_TiposInversion]
GO
ALTER TABLE [dbo].[voto_WorkTipoInversion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoInversion_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoInversion] CHECK CONSTRAINT [FK_voto_WorkTipoInversion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoProfesion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoProfesion_voto_tipoProfesion] FOREIGN KEY([tipoProfesionId])
REFERENCES [dbo].[voto_tipoProfesion] ([tipoProfesionId])
GO
ALTER TABLE [dbo].[voto_WorkTipoProfesion] CHECK CONSTRAINT [FK_voto_WorkTipoProfesion_voto_tipoProfesion]
GO
ALTER TABLE [dbo].[voto_WorkTipoProfesion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoProfesion_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoProfesion] CHECK CONSTRAINT [FK_voto_WorkTipoProfesion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoPropuesta]  WITH CHECK ADD  CONSTRAINT [FK_voto_WorkTipoPropuesta_voto_ProposalType] FOREIGN KEY([tipoPropuestaId])
REFERENCES [dbo].[voto_ProposalType] ([proposalTypeId])
GO
ALTER TABLE [dbo].[voto_WorkTipoPropuesta] CHECK CONSTRAINT [FK_voto_WorkTipoPropuesta_voto_ProposalType]
GO
ALTER TABLE [dbo].[voto_WorkTipoPropuesta]  WITH CHECK ADD  CONSTRAINT [FK_voto_WorkTipoPropuesta_wk_workflow1] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoPropuesta] CHECK CONSTRAINT [FK_voto_WorkTipoPropuesta_wk_workflow1]
GO
ALTER TABLE [dbo].[voto_WorkTipoPruebas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoPruebas_voto_tipoPruebasVida] FOREIGN KEY([tipoPruebasVidaId])
REFERENCES [dbo].[voto_tipoPruebasVida] ([tipoPruebasVidaId])
GO
ALTER TABLE [dbo].[voto_WorkTipoPruebas] CHECK CONSTRAINT [FK_voto_WorkTipoPruebas_voto_tipoPruebasVida]
GO
ALTER TABLE [dbo].[voto_WorkTipoPruebas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoPruebas_wk_workflow] FOREIGN KEY([workflow_Id])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoPruebas] CHECK CONSTRAINT [FK_voto_WorkTipoPruebas_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoPubli]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoPubli_voto_TipoPublicaciones] FOREIGN KEY([tipoPublicacionId])
REFERENCES [dbo].[voto_TipoPublicaciones] ([tipoPublicacionId])
GO
ALTER TABLE [dbo].[voto_WorkTipoPubli] CHECK CONSTRAINT [FK_voto_WorkTipoPubli_voto_TipoPublicaciones]
GO
ALTER TABLE [dbo].[voto_WorkTipoPubli]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoPubli_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoPubli] CHECK CONSTRAINT [FK_voto_WorkTipoPubli_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoReglas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoReglas_voto_TiposDeReglas] FOREIGN KEY([tipoReglaId])
REFERENCES [dbo].[voto_TiposDeReglas] ([tipoReglaId])
GO
ALTER TABLE [dbo].[voto_WorkTipoReglas] CHECK CONSTRAINT [FK_voto_WorkTipoReglas_voto_TiposDeReglas]
GO
ALTER TABLE [dbo].[voto_WorkTipoReglas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoReglas_wk_workflow] FOREIGN KEY([workflow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoReglas] CHECK CONSTRAINT [FK_voto_WorkTipoReglas_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoRepresentante]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoRepresentante_voto_TipoRepresentante] FOREIGN KEY([tipoRepresentanteId])
REFERENCES [dbo].[voto_TipoRepresentante] ([tipoRepresentanteId])
GO
ALTER TABLE [dbo].[voto_WorkTipoRepresentante] CHECK CONSTRAINT [FK_voto_WorkTipoRepresentante_voto_TipoRepresentante]
GO
ALTER TABLE [dbo].[voto_WorkTipoRepresentante]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoRepresentante_wk_workflow] FOREIGN KEY([workFlowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoRepresentante] CHECK CONSTRAINT [FK_voto_WorkTipoRepresentante_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoSeccion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoSeccion_voto_TipoSeccion] FOREIGN KEY([tipoSeccionId])
REFERENCES [dbo].[voto_TipoSeccion] ([tipoSeccionId])
GO
ALTER TABLE [dbo].[voto_WorkTipoSeccion] CHECK CONSTRAINT [FK_voto_WorkTipoSeccion_voto_TipoSeccion]
GO
ALTER TABLE [dbo].[voto_WorkTipoUser]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoUser_voto_TipoUser] FOREIGN KEY([tipoUserId])
REFERENCES [dbo].[voto_TipoUser] ([tipoUserId])
GO
ALTER TABLE [dbo].[voto_WorkTipoUser] CHECK CONSTRAINT [FK_voto_WorkTipoUser_voto_TipoUser]
GO
ALTER TABLE [dbo].[voto_WorkTipoUser]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoUser_wk_workflow] FOREIGN KEY([workflow_Id])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoUser] CHECK CONSTRAINT [FK_voto_WorkTipoUser_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTipoVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoVotacion_voto_TiposVotacion] FOREIGN KEY([tipoVotacionId])
REFERENCES [dbo].[voto_TiposVotacion] ([tipoVotacionId])
GO
ALTER TABLE [dbo].[voto_WorkTipoVotacion] CHECK CONSTRAINT [FK_voto_WorkTipoVotacion_voto_TiposVotacion]
GO
ALTER TABLE [dbo].[voto_WorkTipoVotacion]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTipoVotacion_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTipoVotacion] CHECK CONSTRAINT [FK_voto_WorkTipoVotacion_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTransacciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTransacciones_voto_Transacciones] FOREIGN KEY([transaccionId])
REFERENCES [dbo].[voto_Transacciones] ([transaccionId])
GO
ALTER TABLE [dbo].[voto_WorkTransacciones] CHECK CONSTRAINT [FK_voto_WorkTransacciones_voto_Transacciones]
GO
ALTER TABLE [dbo].[voto_WorkTransacciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTransacciones_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTransacciones] CHECK CONSTRAINT [FK_voto_WorkTransacciones_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTypePropuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkPropuestas_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkTypePropuestas] CHECK CONSTRAINT [FK_voto_WorkPropuestas_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkTypePropuestas]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkTypePropuestas_voto_ProposalType] FOREIGN KEY([proposalTypeId])
REFERENCES [dbo].[voto_ProposalType] ([proposalTypeId])
GO
ALTER TABLE [dbo].[voto_WorkTypePropuestas] CHECK CONSTRAINT [FK_voto_WorkTypePropuestas_voto_ProposalType]
GO
ALTER TABLE [dbo].[voto_WorkUsers]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkUsers_voto_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[voto_Users] ([userId])
GO
ALTER TABLE [dbo].[voto_WorkUsers] CHECK CONSTRAINT [FK_voto_WorkUsers_voto_Users]
GO
ALTER TABLE [dbo].[voto_WorkVotaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkVotaciones_voto_Votaciones] FOREIGN KEY([votacionId])
REFERENCES [dbo].[voto_Votaciones] ([votacionId])
GO
ALTER TABLE [dbo].[voto_WorkVotaciones] CHECK CONSTRAINT [FK_voto_WorkVotaciones_voto_Votaciones]
GO
ALTER TABLE [dbo].[voto_WorkVotaciones]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkVotaciones_wk_workflow] FOREIGN KEY([workflowId])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkVotaciones] CHECK CONSTRAINT [FK_voto_WorkVotaciones_wk_workflow]
GO
ALTER TABLE [dbo].[voto_WorkVotos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkVotos_voto_Votos] FOREIGN KEY([votoId])
REFERENCES [dbo].[voto_Votos] ([votoId])
GO
ALTER TABLE [dbo].[voto_WorkVotos] CHECK CONSTRAINT [FK_voto_WorkVotos_voto_Votos]
GO
ALTER TABLE [dbo].[voto_WorkVotos]  WITH NOCHECK ADD  CONSTRAINT [FK_voto_WorkVotos_wk_workflow] FOREIGN KEY([workFlow])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[voto_WorkVotos] CHECK CONSTRAINT [FK_voto_WorkVotos_wk_workflow]
GO
ALTER TABLE [dbo].[wk_bitacora]  WITH NOCHECK ADD  CONSTRAINT [FK_wk_bitacora_wk_LogType] FOREIGN KEY([wkLogTypeId])
REFERENCES [dbo].[wk_LogType] ([wkLogTypeId])
GO
ALTER TABLE [dbo].[wk_bitacora] CHECK CONSTRAINT [FK_wk_bitacora_wk_LogType]
GO
ALTER TABLE [dbo].[wk_bitacora]  WITH NOCHECK ADD  CONSTRAINT [FK_wk_bitacora_wk_WorkFlow_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[wk_WorkFlow_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[wk_bitacora] CHECK CONSTRAINT [FK_wk_bitacora_wk_WorkFlow_Estado]
GO
ALTER TABLE [dbo].[wk_step_run]  WITH NOCHECK ADD  CONSTRAINT [FK__wk_step_r__run_i__0169315C] FOREIGN KEY([run_id])
REFERENCES [dbo].[wk_workflow_run] ([run_id])
GO
ALTER TABLE [dbo].[wk_step_run] CHECK CONSTRAINT [FK__wk_step_r__run_i__0169315C]
GO
ALTER TABLE [dbo].[wk_step_run]  WITH NOCHECK ADD  CONSTRAINT [FK_wk_step_run_wk_WorkFlow_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[wk_WorkFlow_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[wk_step_run] CHECK CONSTRAINT [FK_wk_step_run_wk_WorkFlow_Estado]
GO
ALTER TABLE [dbo].[wk_workflow]  WITH NOCHECK ADD  CONSTRAINT [FK_wk_workflow_wk_workflow_tipo] FOREIGN KEY([tipoid])
REFERENCES [dbo].[wk_workflow_tipo] ([tipoid])
GO
ALTER TABLE [dbo].[wk_workflow] CHECK CONSTRAINT [FK_wk_workflow_wk_workflow_tipo]
GO
ALTER TABLE [dbo].[wk_workflow_run]  WITH NOCHECK ADD  CONSTRAINT [FK__wk_workfl__workf__7D98A078] FOREIGN KEY([workflow_id])
REFERENCES [dbo].[wk_workflow] ([workflow_id])
GO
ALTER TABLE [dbo].[wk_workflow_run] CHECK CONSTRAINT [FK__wk_workfl__workf__7D98A078]
GO
ALTER TABLE [dbo].[wk_workflow_run]  WITH NOCHECK ADD  CONSTRAINT [FK_wk_workflow_run_wk_WorkFlow_Estado] FOREIGN KEY([estadoId])
REFERENCES [dbo].[wk_WorkFlow_Estado] ([estadoId])
GO
ALTER TABLE [dbo].[wk_workflow_run] CHECK CONSTRAINT [FK_wk_workflow_run_wk_WorkFlow_Estado]
GO
/****** Object:  StoredProcedure [dbo].[crearActualizarPropuesta]    Script Date: 24/6/2025 16:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[crearActualizarPropuesta]
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
GO
/****** Object:  StoredProcedure [dbo].[repartirDividendos]    Script Date: 24/6/2025 16:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[repartirDividendos]
    -- Parámetros de entrada del procedimiento almacenado
    @tituloPropuesta VARCHAR(100),            -- Título de la propuesta/proyecto a la que se distribuirán los dividendos.
    @montoTotalDistribuir DECIMAL(15, 2),     -- Monto total de ganancias netas a distribuir entre los inversionistas para este ciclo.
    @fechaDistribucion DATE,                  -- Fecha efectiva en la que se planifica esta distribución de dividendos.
    @usernameEjecutor VARCHAR(50),            -- Nombre de usuario de la persona (administrador, contable, etc.) que inicia la distribución.
    @hashReporteGanancias VARBINARY(256),     -- Hash criptográfico del reporte financiero que justifica y avala la disponibilidad de estos fondos.
    
    -- Parámetros de salida para comunicar el resultado de la ejecución del procedimiento
    @resultado BIT OUTPUT,                    -- Indicador booleano: 1 si la operación de distribución fue exitosa, 0 si hubo algún fallo.
    @mensaje VARCHAR(500) OUTPUT              -- Mensaje descriptivo que proporciona información detallada sobre el éxito o el error de la operación.
AS
BEGIN
    SET NOCOUNT ON; -- Previene que SQL Server envíe mensajes de conteo de filas afectadas por las sentencias. Esto puede mejorar el rendimiento, especialmente en aplicaciones cliente-servidor.
    
    /* =====================================================
        DECLARACIÓN DE VARIABLES
        Se declaran todas las variables locales que se utilizarán para almacenar IDs, montos,
        fechas, estados y otros datos intermedios necesarios a lo largo del procedimiento.
    ===================================================== */
    DECLARE @propuestaId INT;               -- Almacena el ID interno de la propuesta (obtenido a partir de @tituloPropuesta).
    DECLARE @userIdEjecutor INT;            -- Almacena el ID del usuario que ejecuta este procedimiento (obtenido a partir de @usernameEjecutor).
    DECLARE @estadoPropuestaId INT;         -- Almacena el ID del estado actual de la propuesta.
    DECLARE @estadoEjecutandoId INT;        -- Almacena el ID del estado que corresponde a 'Ejecutando' para validación.
    DECLARE @montoTotalInvertido DECIMAL(15, 2); -- Almacena la suma total de todos los montos de inversión aprobados en esta propuesta, de todos los inversionistas.
    DECLARE @transTypeIdDividendos INT;     -- Almacena el ID del tipo de transacción que corresponde a 'Dividendo'.
    DECLARE @fundIdPrincipal INT;           -- Almacena el ID del fondo principal al cual se asocian los balances de los inversionistas.
    DECLARE @pagoMedioIdWeb INT;            -- Almacena el ID del medio de pago 'Web' (obtenido de voto_MediosDisponibles), que representa el canal de pago.
    DECLARE @metodoPagoIdTransferenciaBancaria INT; -- Almacena el ID del método de pago 'Transferencia Bancaria' (obtenido de voto_MetodosDePago), que representa la forma específica de pago.
    DECLARE @dividendCycleId INT;           -- Almacena el ID del registro principal creado en voto_DividendDistributionCycle para este ciclo de distribución.
    DECLARE @currencyId INT;                -- Almacena el ID de la moneda utilizada para los pagos de dividendos.
    DECLARE @exchangeRate FLOAT;            -- Almacena la tasa de cambio de la moneda para los pagos de dividendos.
    
    -- Variables específicas para el cursor (utilizadas durante la iteración sobre cada inversionista)
    DECLARE @inversionIdCursor INT;         -- Almacena el ID de una inversión individual mientras el cursor itera.
    DECLARE @userIdInversionistaCursor INT; -- Almacena el ID del usuario del inversionista para la inversión actual del cursor.
    DECLARE @montoInversionCursor DECIMAL(15, 2); -- Almacena el monto de la inversión individual actual del cursor.
    DECLARE @inversionistaIdCursor INT;     -- Almacena el ID del perfil de inversionista correspondiente a la inversión actual del cursor.
    DECLARE @montoDistribuirAInversionista DECIMAL(15, 2); -- Almacena el monto de dividendo calculado para ser distribuido al inversionista actual del cursor.
    DECLARE @saldoActualInversionista DECIMAL(15, 2); -- Almacena el saldo actual del inversionista antes de sumar los dividendos.
    DECLARE @inversionistaBalanceIdCursor INT; -- Almacena el ID del registro de balance del inversionista actual del cursor.
    DECLARE @pagoId INT;                    -- Almacena el ID del registro de pago generado para el dividendo del inversionista actual.
    DECLARE @transaccionId INT;             -- Almacena el ID de la transacción generada para el ingreso de dividendo al inversionista actual.

    /* =====================================================
        OBTENER IDs Y DATOS NECESARIOS (FUERA DE TRANSACCIÓN)
        Esta sección se encarga de recopilar todos los datos de referencia y IDs de configuración
        necesarios para la ejecución del procedimiento. Se realizan estas consultas ANTES de
        iniciar el bloque de transacción principal para minimizar el tiempo que la transacción
        permanece abierta, lo que reduce la contención de bloqueos y mejora la concurrencia y el rendimiento general.
    ===================================================== */
    -- Obtiene el ID de la propuesta y su estado actual buscando por el título de la propuesta.
    SELECT @propuestaId = propuestaId, @estadoPropuestaId = estadoId
    FROM [dbo].[voto_Propuestas]
    WHERE titulo = @tituloPropuesta;

    -- Obtiene el ID del usuario que está ejecutando este procedimiento a partir de su nombre de usuario.
    SELECT @userIdEjecutor = userId
    FROM [dbo].[voto_Users]
    WHERE username = @usernameEjecutor;

    -- Obtiene el ID del estado 'Ejecutando' de la tabla de estados, el cual es necesario para validar la propuesta.
    SELECT @estadoEjecutandoId = estadoId
    FROM [dbo].[voto_Estado]
    WHERE name = 'Ejecutando';

    -- Obtiene el ID del tipo de transacción 'Dividendo' de la tabla de tipos de transacciones.
    -- Es crucial que este tipo de transacción exista y esté configurado correctamente.
    SELECT @transTypeIdDividendos = transTypeId
    FROM [dbo].[voto_transTypes]
    WHERE name = 'Dividendo';

    -- Obtiene el ID del fondo principal de la tabla de fondos. Este fondo es donde se gestionan los balances de los inversionistas.
    SELECT @fundIdPrincipal = fundId
    FROM [dbo].[voto_funds]
    WHERE name = 'Fondo Principal';

    -- Obtiene el ID del medio de pago 'Web' de la tabla voto_MediosDisponibles. Esto define el canal por el cual se procesa el pago.
    SELECT @pagoMedioIdWeb = pagoMedioId
    FROM [dbo].[voto_MediosDisponibles]
    WHERE name = 'Web' AND enabled = 1;

    -- Obtiene el ID del método de pago 'Transferencia Bancaria' de la tabla voto_MetodosDePago. Esto define la forma específica del pago.
    SELECT @metodoPagoIdTransferenciaBancaria = metodoPagoId
    FROM [dbo].[voto_MetodosDePago]
    WHERE name = 'Transferencia Bancaria' AND enabled = 1;

    -- Obtiene la información de la moneda base y su tasa de cambio.
    -- Se asume que existe una entrada donde 'currentExchangeRate' es 1 y 'enabled' es 1, lo que indica la moneda principal.
    SELECT TOP 1 
        @currencyId = c.currencyId,
        @exchangeRate = cc.exchangeRate
    FROM [dbo].[voto_Currencies] c
    JOIN [dbo].[voto_CurrencyConvertions] cc ON c.currencyId = cc.currencyId_destiny
    WHERE cc.currentExchangeRate = 1 AND cc.enabled = 1
    ORDER BY cc.startdate DESC; -- Prioriza la tasa de cambio más reciente.

    /* =====================================================
        VALIDACIONES INICIALES
        Esta sección realiza una serie de validaciones críticas sobre los datos obtenidos
        y las condiciones de negocio requeridas para la distribución de dividendos.
        Cualquier fallo en estas validaciones resultará en la terminación temprana del
        procedimiento almacenado, devolviendo un mensaje de error descriptivo.
    ===================================================== */
    -- Validación 1: Verifica que la propuesta especificada por el título exista en la base de datos.
    IF @propuestaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: La propuesta especificada no fue encontrada.';
        RETURN;
    END

    -- Validación 2: Verifica que el usuario que intenta ejecutar el procedimiento exista.
    IF @userIdEjecutor IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El usuario ejecutor no es válido o no existe.';
        RETURN;
    END

    -- Validación 3: Verifica que el tipo de transacción 'Dividendo' esté correctamente configurado en la tabla voto_transTypes.
    IF @transTypeIdDividendos IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de transacción "Dividendo" no está configurado en voto_transTypes.';
        RETURN;
    END

    -- Validación 4: Verifica que el fondo principal esté configurado en la tabla voto_funds.
    IF @fundIdPrincipal IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El fondo "Fondo Principal" no está configurado.';
        RETURN;
    END

    -- Validación 5: Verifica que el medio de pago 'Web' esté configurado y habilitado en voto_MediosDisponibles.
    IF @pagoMedioIdWeb IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El medio de pago "Web" no está configurado o habilitado en voto_MediosDisponibles.';
        RETURN;
    END

    -- Validación 6: Verifica que el método de pago 'Transferencia Bancaria' esté configurado y habilitado en voto_MetodosDePago.
    IF @metodoPagoIdTransferenciaBancaria IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El método de pago "Transferencia Bancaria" no está configurado o habilitado en voto_MetodosDePago.';
        RETURN;
    END

    -- Validación 7: Verifica que la configuración de moneda y su tasa de cambio estén disponibles.
    IF @currencyId IS NULL OR @exchangeRate IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No se pudo obtener la configuración de moneda y/o tipo de cambio para los pagos.';
        RETURN;
    END

    -- Validación 8: Verifica que el monto total a distribuir sea un valor positivo.
    IF @montoTotalDistribuir <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto total a distribuir debe ser mayor que cero.';
        RETURN;
    END

    -- Validación 9: Verifica que el proyecto esté en el estado 'Ejecutando'. Los dividendos solo deben distribuirse para proyectos en ejecución.
    IF @estadoPropuestaId IS NULL OR @estadoPropuestaId <> @estadoEjecutandoId
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El proyecto no está en estado "Ejecutando".';
        RETURN;
    END;
    
    -- Validación 10: Verifica que todas las fiscalizaciones asociadas a la propuesta estén aprobadas.
    -- Esto es crucial para asegurar que los reportes financieros han sido validados.
    IF EXISTS (
        SELECT 1 
        FROM [dbo].[voto_Fiscalizaciones] 
        WHERE propuestaId = @propuestaId 
        AND estado <> 'Aprobado' -- Se asume que el campo 'estado' de fiscalizaciones almacena el string 'Aprobado'.
    )
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Existen fiscalizaciones pendientes o no aprobadas para este proyecto.';
        RETURN;
    END;
    
    -- Validación 11: Verifica la validez del hash del reporte de ganancias y asume la disponibilidad de fondos.
    -- En una implementación real más compleja, aquí se verificaría el reporte contra un registro contable.
    IF @hashReporteGanancias IS NULL OR DATALENGTH(@hashReporteGanancias) = 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El hash del reporte de ganancias no es válido. Se requiere un reporte verificado que respalde la distribución.';
        RETURN;
    END

    -- Consulta el monto total invertido por todos los inversionistas en esta propuesta.
    -- Este valor es fundamental para calcular el porcentaje de participación de cada inversor.
    SELECT @montoTotalInvertido = ISNULL(SUM(monto), 0)
    FROM [dbo].[voto_Inversiones]
    WHERE propuestaId = @propuestaId AND estado = 'Aprobada'; -- Solo se consideran las inversiones que han sido aprobadas.

    -- Validación 12: Verifica que existan inversiones aprobadas en el proyecto. No se pueden distribuir dividendos si no hay inversores o inversión.
    IF @montoTotalInvertido IS NULL OR @montoTotalInvertido <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No hay inversiones aprobadas para este proyecto o el monto total invertido es cero. No se pueden distribuir dividendos.';
        RETURN;
    END;

    -- Validación 13: Verifica que todos los inversionistas que tienen inversiones aprobadas en esta propuesta
    -- cuenten con un medio de depósito válido y habilitado de tipo 'CuentaBancaria'.
    -- Esta validación es crucial para asegurar que los dividendos puedan ser efectivamente pagados.
    IF EXISTS (
        SELECT 1
        FROM [dbo].[voto_Inversiones] inv_link -- inv_link es la tabla de inversiones, representa una inversión específica.
        JOIN [dbo].[voto_Inversionistas] inv_prof ON inv_link.inversionId = inv_prof.inversionId -- inv_prof es la tabla de perfiles de inversionistas, enlazada indirectamente a través de inversionId.
        LEFT JOIN [dbo].[voto_contactInfoInversionistas] ci ON inv_prof.inversionistaId = ci.inversionistaId -- Información de contacto del inversionista.
        LEFT JOIN [dbo].[voto_ContactInfoTypes] cit ON ci.contactInfoTypeId = cit.contactInfoTypeId -- Tipos de información de contacto.
        WHERE inv_link.propuestaId = @propuestaId -- Filtra por la propuesta actual.
        AND inv_link.estado = 'Aprobada' -- Solo considera inversiones que están en estado 'Aprobada'.
        AND (
              cit.name <> 'CuentaBancaria' -- Comprueba si el tipo de contacto NO es 'CuentaBancaria'.
              OR ci.value IS NULL          -- O si el valor de la cuenta bancaria está vacío.
              OR ci.enabled = 0             -- O si la cuenta bancaria no está habilitada.
              OR cit.contactInfoTypeId IS NULL -- O si no hay ningún tipo de información de contacto registrado para el inversor (lo que implica la ausencia de una 'CuentaBancaria').
            )
        -- AND inv_prof.acreditado = 1 -- Esta línea es opcional: si deseas considerar solo inversionistas acreditados.
    )
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Uno o más inversionistas con inversiones aprobadas no tienen un medio de depósito "CuentaBancaria" válido y habilitado. La distribución no puede proceder.';
        RETURN;
    END;

    /* =====================================================
        INICIAR TRANSACCIÓN (OPERACIONES CRÍTICAS)
        Todas las operaciones de modificación de datos se envuelven en una transacción
        explícita. Esto garantiza la atomicidad de las operaciones: o todas se completan
        con éxito, o ninguna de ellas se aplica a la base de datos (se revierten).
        Esto es vital para mantener la integridad de los datos financieros.
    ===================================================== */
    BEGIN TRY
        BEGIN TRANSACTION; -- Inicia la transacción. Todas las operaciones siguientes hasta COMMIT/ROLLBACK formarán una unidad atómica.
        
        -- 1. Registrar el encabezado del ciclo de distribución de dividendos.
        -- Se inserta un nuevo registro en la tabla 'voto_DividendDistributionCycle' para documentar
        -- este evento de distribución general.
        INSERT INTO [dbo].[voto_DividendDistributionCycle] (
            propuestaId,
            montoTotalDistribuido,
            fechaDistribucion,
            userIdEjecutor,
            hashReporteGanancias,
            fechaRegistro,
            estado
        )
        VALUES (
            @propuestaId,               -- ID de la propuesta a la que se asocia esta distribución.
            @montoTotalDistribuir,      -- El monto total que se distribuye en este ciclo.
            @fechaDistribucion,         -- La fecha de esta distribución.
            @userIdEjecutor,            -- El ID del usuario que inicia este ciclo.
            @hashReporteGanancias,      -- El hash del reporte financiero que justifica la distribución.
            GETDATE(),                  -- La fecha y hora exactas en que se registra este ciclo.
            'Completado'                -- El estado inicial del ciclo de distribución (asumido como completado si no hay errores).
        );
        
        SET @dividendCycleId = SCOPE_IDENTITY(); -- Obtiene el ID generado automáticamente para el nuevo registro de ciclo de distribución.
        
        -- 2. Procesar cada inversionista con una inversión aprobada en esta propuesta.
        -- Se declara un cursor para iterar de manera eficiente sobre cada inversión individual que está
        -- en estado 'Aprobada' y está asociada a la propuesta actual.
        DECLARE inversion_cursor CURSOR LOCAL FORWARD_ONLY FOR
        SELECT 
            i.inversionId,      -- El ID de la inversión individual.
            i.userId,           -- El ID del usuario que realizó esta inversión.
            i.monto             -- El monto específico de esta inversión.
        FROM [dbo].[voto_Inversiones] i
        WHERE i.propuestaId = @propuestaId  -- Filtra por la propuesta que está distribuyendo dividendos.
        AND i.estado = 'Aprobada'; -- Solo procesa inversiones que han sido aprobadas.

        OPEN inversion_cursor; -- Abre el cursor para comenzar la iteración.
        FETCH NEXT FROM inversion_cursor INTO @inversionIdCursor, @userIdInversionistaCursor, @montoInversionCursor; -- Obtiene la primera fila de datos.
        
        -- Bucle WHILE para procesar cada fila obtenida por el cursor.
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el inversionistaId para el userId actual del cursor.
            -- Se utiliza una unión indirecta a través de la tabla 'voto_Inversiones' para encontrar el perfil del inversionista
            -- asociado a este usuario, utilizando la misma lógica que en 'sp_InvertirEnPropuesta'.
            SELECT TOP 1 @inversionistaIdCursor = inv_prof.inversionistaId
            FROM [dbo].[voto_Inversionistas] inv_prof
            JOIN [dbo].[voto_Inversiones] inv_link ON inv_prof.inversionId = inv_link.inversionId
            WHERE inv_link.userId = @userIdInversionistaCursor
            ORDER BY inv_prof.fechaRegistro DESC; -- Si hay múltiples perfiles de inversionista para el mismo usuario, se selecciona el más reciente.


            -- Calcular el porcentaje de participación de este inversionista en el proyecto.
            -- Se basa en el monto de su inversión individual en relación con el monto total invertido por todos.
            DECLARE @porcentajeParticipacion DECIMAL(10, 6);
            IF @montoTotalInvertido > 0
                SET @porcentajeParticipacion = (@montoInversionCursor / @montoTotalInvertido);
            ELSE
                SET @porcentajeParticipacion = 0; -- Evita la división por cero si @montoTotalInvertido es 0.
            
            -- Calcular el monto exacto de dividendo a distribuir a este inversionista,
            -- multiplicando el monto total de ganancias por su porcentaje de participación.
            SET @montoDistribuirAInversionista = @montoTotalDistribuir * @porcentajeParticipacion;
            
            -- Obtener el ID del registro de balance y el saldo actual del inversionista para el fondo principal.
            SELECT @inversionistaBalanceIdCursor = personBalanceId, @saldoActualInversionista = balance
            FROM [dbo].[voto_InversionistaBalance]
            WHERE inversionistaId = @inversionistaIdCursor AND fundId = @fundIdPrincipal;

            -- Si no se encuentra un registro de balance para el inversionista en el fondo principal, se crea uno nuevo.
            -- Esto es una medida de contingencia, aunque las validaciones previas deberían asegurar que ya existe.
            IF @inversionistaBalanceIdCursor IS NULL
            BEGIN
                 INSERT INTO [dbo].[voto_InversionistaBalance] (
                    [inversionistaId],      -- El ID del perfil de inversionista.
                    [balance],              -- El nuevo balance, que inicialmente es solo el monto del dividendo.
                    [lastBalance],          -- El balance anterior, que es 0 ya que es un nuevo registro.
                    [fundId],               -- El ID del fondo principal.
                    [hashContenido]         -- El hash del reporte de ganancias como hash de contenido.
                 )
                 VALUES (
                    @inversionistaIdCursor, @montoDistribuirAInversionista, 0, 
                    @fundIdPrincipal, @hashReporteGanancias
                 );
                 SET @inversionistaBalanceIdCursor = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo registro de balance.
                 SET @saldoActualInversionista = 0; -- Reinicia el saldo actual para que el UPDATE posterior sume correctamente desde cero.
            END;

            -- Actualizar el saldo del inversionista en la tabla 'voto_InversionistaBalance'.
            -- Se suma el monto del dividendo al balance actual del inversionista.
            UPDATE [dbo].[voto_InversionistaBalance]
            SET 
                lastBalance = balance, -- Guarda el balance que existía antes de esta actualización.
                balance = @saldoActualInversionista + @montoDistribuirAInversionista -- Actualiza el balance sumando el dividendo.
            WHERE personBalanceId = @inversionistaBalanceIdCursor; -- Actualiza el registro específico del inversionista.

            -- Registrar el pago del dividendo en la tabla 'voto_Pagos'.
            -- Esto crea un registro individual para cada transferencia de dividendo.
            INSERT INTO [dbo].[voto_Pagos] (
                pagoMedioId,                -- El ID del medio de pago (ej. 'Web').
                metodoPagoId,               -- El ID del método de pago (ej. 'Transferencia Bancaria').
                propuestaId,                -- El ID de la propuesta a la que se asocia este pago.
                inversionId,                -- El ID de la inversión individual a la que se asocia este dividendo.
                inversionistaId,            -- El ID del perfil de inversionista.
                monto,                      -- El monto del dividendo que se está pagando.
                actualMonto,                -- El monto real pagado (puede ser igual a 'monto' aquí).
                result,                     -- El resultado del pago (0x01 para éxito).
                auth,                       -- El estado de autorización (0x01 para éxito).
                error,                      -- Mensaje de error (vacío si no hay error).
                fecha,                      -- La fecha y hora del pago.
                checksum,                   -- Un checksum para verificar la integridad del registro de pago.
                exchangeRate,               -- La tasa de cambio utilizada para este pago.
                convertedAmount,            -- El monto convertido si aplica (monto * exchangeRate).
                moduleId,                   -- El ID del módulo que genera el pago (ej. 1 para el sistema principal).
                currencyId,                 -- El ID de la moneda del pago.
                hashContenido               -- Un hash del contenido del pago (se reutiliza el hash del reporte de ganancias).
            )
            VALUES (
                @pagoMedioIdWeb,                  -- Utiliza el ID del medio de pago 'Web'.
                @metodoPagoIdTransferenciaBancaria, -- Utiliza el ID del método de pago 'Transferencia Bancaria'.
                @propuestaId,
                @inversionIdCursor,
                @inversionistaIdCursor,
                @montoDistribuirAInversionista,
                @montoDistribuirAInversionista,
                0x01,
                0x01,
                '',
                GETDATE(),
                0x01, -- Checksum simulado
                @exchangeRate, 
                @montoDistribuirAInversionista * @exchangeRate,
                1, -- ModuloId simulado
                @currencyId, 
                @hashReporteGanancias
            );
            SET @pagoId = SCOPE_IDENTITY(); -- Obtiene el ID generado para el nuevo registro de pago.

            -- Registrar la confirmación o detalle del pago de dividendo en la tabla 'voto_Distribution'.
            -- Esta tabla parece servir como un registro adicional o una confirmación de cada pago individual de dividendo.
            INSERT INTO [dbo].[voto_Distribution] (
                enabled,        -- Indica si el registro de distribución está habilitado (1 = sí).
                checksum,       -- Un hash para verificar la integridad de este registro de distribución.
                pagoId,         -- El ID del pago recién creado en 'voto_Pagos' al que se enlaza este registro.
                hashSeguridad   -- Un hash de seguridad relacionado con la transacción.
            )
            VALUES (
                1, -- enabled = true
                -- Genera un checksum único para este registro de 'voto_Distribution'.
                HASHBYTES('SHA2_256', CAST(@pagoId AS VARCHAR(10)) + CAST(@montoDistribuirAInversionista AS VARCHAR(50)) + CONVERT(VARCHAR(256), @hashReporteGanancias)),
                CAST(@pagoId AS NCHAR(10)), -- Convierte el INT @pagoId a NCHAR(10) para que coincida con el tipo de columna.
                @hashReporteGanancias -- Reutiliza el hash del reporte de ganancias como hash de seguridad.
            );

            -- Generar una transacción de ingreso de dividendos para el inversionista en la tabla 'voto_Transacciones'.
            -- Obtiene el siguiente ID disponible para 'transaccionId'. Se asume que no es una columna IDENTITY.
            SELECT @transaccionId = ISNULL(MAX(transaccionId), 0) + 1 FROM [dbo].[voto_Transacciones];

            INSERT INTO [dbo].[voto_Transacciones] (
                transaccionId,          -- El ID de la transacción (generado manualmente aquí).
                description,            -- Una descripción detallada de la transacción.
                tranDateTime,           -- La fecha y hora de la transacción.
                postTime,               -- La fecha y hora de contabilización.
                pagoId,                 -- El ID del pago asociado a esta transacción.
                refNumber,              -- Un número de referencia único (generado con NEWID() para unicidad).
                inversionistaId,        -- El ID del perfil de inversionista.
                transTypeId,            -- El ID del tipo de transacción 'Dividendo'.
                inversionistaBalanceId, -- El ID del registro de balance del inversionista.
                hashTrans,              -- El hash de la transacción (se reutiliza el hash del reporte de ganancias).
                llavePrivada            -- Una llave privada simulada para la transacción.
            )
            VALUES (
                @transaccionId,
                'Pago de Dividendos para Inversión #' + CAST(@inversionIdCursor AS VARCHAR) + ' de la propuesta "' + @tituloPropuesta + '"',
                GETDATE(),
                GETDATE(),
                @pagoId,
                CAST(NEWID() AS VARCHAR(100)), -- Genera un GUID y lo convierte a VARCHAR para el número de referencia.
                @inversionistaIdCursor,
                @transTypeIdDividendos, 
                @inversionistaBalanceIdCursor,
                @hashReporteGanancias, 
                HASHBYTES('SHA2_256', 'LlaveDiv_' + CAST(@pagoId AS VARCHAR) + CAST(@montoDistribuirAInversionista AS VARCHAR)) -- Genera una llave privada simulada.
            );

            -- Registrar el detalle de la distribución para esta inversión en la tabla 'voto_DistribucionDetalle'.
            -- Esta tabla guarda los pormenores de cada dividendo individual dentro del ciclo de distribución mayor.
            INSERT INTO [dbo].[voto_DistribucionDetalle] (
                cycleId,                    -- El ID del ciclo de distribución general al que pertenece este detalle.
                inversionId,                -- El ID de la inversión individual.
                inversionistaId,            -- El ID del perfil de inversionista.
                montoInversion,             -- El monto original de la inversión del inversionista.
                porcentajeParticipacion,    -- El porcentaje de participación calculado.
                montoDistribuido,           -- El monto de dividendo distribuido a este inversionista.
                pagoId,                     -- El ID del pago asociado a este detalle.
                fechaRegistro               -- La fecha y hora de registro de este detalle.
            )
            VALUES (
                @dividendCycleId,
                @inversionIdCursor,
                @inversionistaIdCursor,
                @montoInversionCursor,
                @porcentajeParticipacion,
                @montoDistribuirAInversionista,
                @pagoId,
                GETDATE()
            );
            
            FETCH NEXT FROM inversion_cursor INTO @inversionIdCursor, @userIdInversionistaCursor, @montoInversionCursor; -- Avanza el cursor a la siguiente fila.
        END;
        
        CLOSE inversion_cursor; -- Cierra el cursor una vez que se han procesado todas las filas.
        DEALLOCATE inversion_cursor; -- Libera los recursos asociados al cursor.
        
        -- Confirmar la transacción si todas las operaciones dentro del bloque TRY fueron exitosas.
        -- Esto hace que todos los cambios sean permanentes en la base de datos.
        COMMIT TRANSACTION;
        
        -- Retornar el resultado exitoso y un mensaje descriptivo de la operación completada.
        SET @resultado = 1;
        SET @mensaje = 'Distribución de dividendos completada exitosamente para el proyecto "' + @tituloPropuesta + '".';
        
    END TRY
    BEGIN CATCH
        -- Manejo de errores: Este bloque se ejecuta si ocurre cualquier error dentro del bloque TRY.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION; -- Si hay una transacción abierta, se revierte para deshacer todos los cambios y mantener la integridad de los datos.
            
        SET @resultado = 0; -- Establece el resultado del procedimiento a fallo.
        SET @mensaje = 'Error al distribuir dividendos: ' + ERROR_MESSAGE(); -- Captura el mensaje de error original de SQL Server y lo asigna al parámetro de salida.
        
        -- Registrar el error en la tabla de logs ('voto_Log') para fines de depuración y auditoría.
        INSERT INTO [dbo].[voto_Log] (
            [description], [postTime], [computer], [username],
            [trace], [reference1], [reference2], [checksum]
        )
        VALUES (
            'Error en repartirDividendos: ' + ERROR_MESSAGE(), -- Descripción detallada del error.
            GETDATE(), HOST_NAME(), @usernameEjecutor, -- Fecha/hora del error, nombre del equipo, nombre de usuario ejecutor.
            'Propuesta: ' + @tituloPropuesta + ', Monto a Distribuir: ' + CAST(@montoTotalDistribuir AS VARCHAR), -- Traza del contexto del error.
            @propuestaId, @userIdEjecutor, -- Referencias a la propuesta y el usuario.
            -- Genera un hash SHA2_256 para el registro de log, asegurando su unicidad y la integridad de la entrada del log.
            HASHBYTES('SHA2_256', CAST(@propuestaId AS VARCHAR) + @usernameEjecutor + ERROR_MESSAGE())
        );
    END CATCH;
END;
GO
/****** Object:  StoredProcedure [dbo].[revisarPropuesta]    Script Date: 24/6/2025 16:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[revisarPropuesta]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_InvertirEnPropuesta]    Script Date: 24/6/2025 16:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_InvertirEnPropuesta]
    -- Parámetros de entrada del procedimiento almacenado
    @tituloPropuesta VARCHAR(100),            -- Título de la propuesta en la que se va a invertir.
    @usernameInversionista VARCHAR(50),       -- Nombre de usuario del inversionista que realiza la inversión.
    @monto DECIMAL(15, 2),                    -- Cantidad de dinero que el inversionista desea invertir en la propuesta.
    @nombreMetodoPago VARCHAR(50),            -- Nombre del método de pago utilizado para la inversión (ej. 'Tarjeta de Crédito', 'Transferencia Bancaria').
    @comprobantePago VARCHAR(100),            -- Referencia o número de comprobante de la transacción de pago.
    @hashTransaccion VARBINARY(256),          -- Hash binario de la transacción para verificar su integridad y unicidad.
    
    -- Parámetros de salida para comunicar el resultado de la ejecución
    @resultado BIT OUTPUT,                    -- Indicador booleano: 0 si la operación falló, 1 si fue exitosa.
    @mensaje VARCHAR(500) OUTPUT              -- Mensaje descriptivo que proporciona información sobre el éxito o el error de la operación.
AS
BEGIN
    SET NOCOUNT ON; -- Evita que SQL Server devuelva el número de filas afectadas por las sentencias. Esto puede mejorar el rendimiento, especialmente en aplicaciones.
    
    /* =====================================================
        DECLARACIÓN DE VARIABLES
        Se declaran todas las variables locales que se utilizarán para almacenar IDs, montos,
        fechas y otros datos necesarios a lo largo del procedimiento.
    ===================================================== */
    DECLARE @propuestaId INT,               -- Almacena el ID de la propuesta obtenida por su título.
            @inversionistaId INT,           -- Almacena el ID del perfil de inversionista.
            @metodoPagoId INT,              -- Almacena el ID del método de pago.
            @userId INT;                    -- Almacena el ID del usuario asociado al inversionista.
    DECLARE @valorTotalProyecto DECIMAL(15, 2), -- Almacena la meta de financiamiento total de la propuesta.
            @porcentajeAccionario DECIMAL(10, 6); -- Almacena el porcentaje accionario calculado para el inversionista.
    DECLARE @planId INT,                   -- Almacena el ID del plan de trabajo de la propuesta.
            @estadoPropuesta INT,           -- Almacena el ID del estado actual de la propuesta.
            @inversionId INT;               -- Almacena el ID de la inversión recién creada.
    DECLARE @totalInvertido DECIMAL(15, 2), -- Almacena el monto total ya recaudado para la propuesta (por todos los inversores).
            @montoMaximo DECIMAL(15, 2);    -- Almacena el monto máximo permitido para la inversión de este inversionista.
    DECLARE @currencyId INT,               -- Almacena el ID de la moneda utilizada en la transacción.
            @exchangeRate FLOAT;           -- Almacena la tasa de cambio de la moneda.
    DECLARE @publicacionId INT;            -- Almacena el ID de la publicación de crowdfunding.
    DECLARE @transactionName VARCHAR(32) = 'InvertirEnPropuesta'; -- Nombre para la transacción explícita de SQL Server.
    DECLARE @fechaActual DATETIME = GETDATE(); -- Almacena la fecha y hora actual al inicio del procedimiento.
    DECLARE @recaudacionId INT;             -- Almacena el ID del registro de recaudación de fondos.
    DECLARE @transTypeId INT,               -- Almacena el ID del tipo de transacción 'Inversión'.
            @fundId INT;                    -- Almacena el ID del fondo principal.
    DECLARE @saldoActual DECIMAL(15, 2) = 0; -- Saldo actual disponible del inversionista (inicializado a 0).
    DECLARE @nuevoSaldo DECIMAL(15, 2);     -- Saldo del inversionista después de la deducción de la inversión.
    DECLARE @inversionistaBalanceId INT;    -- Almacena el ID del registro de balance del inversionista.
    DECLARE @pagoMedioIdInterno INT;        -- Almacena el ID del medio de pago interno (ej. 'Web').
    DECLARE @docTypeIdContrato INT;         -- Almacena el ID del tipo de documento 'Contrato de Inversión'.
    DECLARE @transaccionId INT;             -- Almacena el ID de la transacción de balance.
    DECLARE @mediaFileId_Contrato INT;      -- Almacena el ID del archivo multimedia generado para el contrato de inversión.
    DECLARE @mediaTypeId_Doc INT;           -- Almacena el ID del tipo de medio 'Documento'.
    DECLARE @documentoId INT;               -- Almacena el ID del documento contractual en voto_Documents.
    
    /* =====================================================
        OBTENER IDs Y DATOS NECESARIOS (FUERA DE TRANSACCIÓN)
        Esta sección se encarga de recopilar todos los datos de referencia necesarios.
        Se realizan las consultas ANTES de iniciar la transacción principal para minimizar
        el tiempo que la transacción permanece abierta, reduciendo la contención de bloqueos.
    ===================================================== */
    -- 1. Obtiene el ID de la propuesta, su estado, ID de publicación, meta de financiamiento y fondos recaudados
    --    buscando por el título de la propuesta. Se utiliza LEFT JOIN para asegurar que, incluso si no hay
    --    registros en 'voto_CrowdfundingPublicaciones' o 'voto_recaudacionFondos', la propuesta aún pueda ser identificada.
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
    
    -- 3. Obtiene el ID del inversionista y el monto máximo de inversión permitido para su perfil.
    --    Esta consulta busca el perfil de inversionista asociado al usuario a través de una inversión previa.
    --    NOTA: La cláusula JOIN [dbo].[voto_Inversiones] inv ON i.inversionId = inv.inversionId
    --    y WHERE inv.userId = @userId sugiere que la tabla 'voto_Inversionistas' se relaciona con
    --    'voto_Inversiones' y luego con 'voto_Users'. Si 'voto_Inversionistas' tuviera directamente 'userId',
    --    la relación podría simplificarse.
    SELECT TOP 1 
        @inversionistaId = i.inversionistaId,
        @montoMaximo = i.montoMaximoInversion
    FROM [dbo].[voto_Inversionistas] i
    JOIN [dbo].[voto_Inversiones] inv ON i.inversionId = inv.inversionId -- Relación indirecta a través de inversiones.
    WHERE inv.userId = @userId -- Vincula al usuario a través de sus inversiones.
      AND i.estado = 'Activo'
      AND i.acreditado = 1
    ORDER BY i.fechaRegistro DESC; -- Selecciona el perfil más reciente si hay varios.

    -- 4. Obtiene el ID del método de pago a partir de su nombre.
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
    ORDER BY cc.startdate DESC; -- Obtiene la tasa de cambio más reciente.
    
    -- 6. Obtiene el ID del tipo de transacción 'Inversión'.
    SELECT @transTypeId = transTypeId 
    FROM [dbo].[voto_transTypes] 
    WHERE name = 'Inversión';
    
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
    
    -- 9. Obtiene el ID del plan de trabajo asociado a la propuesta que esté en estado 'Aprobado'.
    SELECT @planId = planId 
    FROM [dbo].[voto_PlanesTrabajo] 
    WHERE propuestaId = @propuestaId AND estado = 'Aprobado';

    -- 10. Obtiene el ID del medio de pago predeterminado 'Web' (asumiendo que se usa para pagos en línea).
    SELECT @pagoMedioIdInterno = pagoMedioId
    FROM [dbo].[voto_MediosDisponibles]
    WHERE name = 'Web' AND enabled = 1;

    -- 11. Obtiene el ID del tipo de documento 'Contrato de Inversión' de la tabla de tipos de documentos.
    SELECT @docTypeIdContrato = docTypeId
    FROM [dbo].[voto_DocTypes]
    WHERE name = 'Contrato de Inversión';

    -- 12. Obtiene el ID del tipo de medio 'Documento' de la tabla de tipos de medios.
    SELECT @mediaTypeId_Doc = mediaTypeId
    FROM [dbo].[voto_MediaTypes]
    WHERE name = 'Documento';
    
    /* =====================================================
        VALIDACIONES INICIALES (MÁS ROBUSTAS)
        Esta sección realiza validaciones críticas sobre la existencia y validez de los datos
        obtenidos. Si alguna validación falla, el procedimiento se detiene y devuelve un error.
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
    
    -- 2. Verifica que la propuesta esté en el estado 'Publicada' (ID 4) para permitir inversiones.
    IF @estadoPropuesta != 4
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: La propuesta no está publicada y lista para inversión.';
        RETURN;
    END
    
    -- 3. Verifica que el ID del inversionista se haya encontrado y sea válido/acreditado.
    IF @inversionistaId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Inversionista no válido o no acreditado. Asegúrese de que el usuario tenga un perfil de inversionista activo y acreditado asociado a alguna de sus inversiones.';
        RETURN;
    END

    -- 4. Verifica que el ID del método de pago se haya encontrado.
    IF @metodoPagoId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Método de pago no encontrado.';
        RETURN;
    END

    -- 5. Verifica que la configuración de moneda y tasa de cambio esté disponible.
    IF @currencyId IS NULL OR @exchangeRate IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: No se pudo obtener la configuración de moneda y/o tipo de cambio.';
        RETURN;
    END

    -- 6. Verifica que el tipo de transacción 'Inversión' esté configurado.
    IF @transTypeId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de transacción "Inversión" no está configurado.';
        RETURN;
    END

    -- 7. Verifica que el fondo principal esté configurado.
    IF @fundId IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El fondo "Fondo Principal" no está configurado.';
        RETURN;
    END

    -- 8. Verifica que el medio de pago predeterminado 'Web' esté configurado.
    IF @pagoMedioIdInterno IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El medio de pago predeterminado ("Web") no está configurado o no está habilitado en voto_MediosDisponibles.';
        RETURN;
    END

    -- 9. Verifica que el tipo de documento 'Contrato de Inversión' esté configurado.
    IF @docTypeIdContrato IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de documento "Contrato de Inversión" no está configurado en voto_DocTypes.';
        RETURN;
    END

    -- 10. Verifica que el tipo de medio 'Documento' esté configurado.
    IF @mediaTypeId_Doc IS NULL
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El tipo de medio "Documento" no está configurado en voto_MediaTypes. Por favor, agregue un tipo de medio con ese nombre.';
        RETURN;
    END
    
    -- 11. Verifica si el inversionista tiene suficiente saldo disponible para la inversión.
    IF @saldoActual < @monto
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: Saldo insuficiente para realizar la inversión.';
        RETURN;
    END
    
    -- 12. Verifica que el monto a invertir sea un valor positivo.
    IF @monto <= 0
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto a invertir debe ser mayor que cero.';
        RETURN;
    END

    -- Verifica si el monto a invertir excede el monto máximo permitido para este inversionista.
    IF @montoMaximo IS NOT NULL AND @monto > @montoMaximo
    BEGIN
        SET @resultado = 0;
        SET @mensaje = 'Error: El monto excede el máximo permitido para este inversionista (' + CAST(@montoMaximo AS VARCHAR) + ').';
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
        CÁLCULO DE PORCENTAJE ACCIONARIO (REPEATABLE READ)
        Esta sección se ejecuta bajo un nivel de aislamiento 'REPEATABLE READ' para garantizar
        que las lecturas de los montos totales no cambien durante el cálculo del porcentaje,
        evitando inconsistencias por concurrencia.
    ===================================================== */
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        
        -- Obtiene el total de los fondos ya invertidos para *esta propuesta* por *todos* los inversores.
        -- Se usa WITH (UPDLOCK) para tomar un bloqueo de actualización y prevenir que otras transacciones
        -- modifiquen estos datos mientras se realiza el cálculo.
        SELECT @totalInvertido = ISNULL(SUM(monto), 0)
        FROM [dbo].[voto_Inversiones] WITH (UPDLOCK)
        WHERE propuestaId = @propuestaId AND estado = 'Aprobada';
        
        -- Calcula la inversión total acumulada de *este inversionista* en *esta propuesta*.
        -- Esto incluye las inversiones pasadas del mismo usuario en la misma propuesta.
        DECLARE @totalInvertidoPorEsteInversionista DECIMAL(15, 2);
        SELECT @totalInvertidoPorEsteInversionista = ISNULL(SUM(monto), 0)
        FROM [dbo].[voto_Inversiones]
        WHERE userId = @userId AND propuestaId = @propuestaId AND estado = 'Aprobada';

        -- Suma el monto de la inversión actual al total acumulado del inversionista para determinar
        -- su participación total en el cálculo del porcentaje.
        DECLARE @nuevaInversionTotalInversionista DECIMAL(15, 2) = @totalInvertidoPorEsteInversionista + @monto;

        -- Calcula el porcentaje accionario que le corresponde al inversionista.
        -- Este porcentaje se basa en la *inversión total acumulada del inversionista*
        -- sobre el valor total del proyecto.
        IF @valorTotalProyecto > 0
            SET @porcentajeAccionario = (@nuevaInversionTotalInversionista / @valorTotalProyecto) * 100;
        ELSE
            SET @porcentajeAccionario = 0; -- Maneja la división por cero si el valor del proyecto es 0.

        -- Calcula el porcentaje total de la meta del proyecto que se ha recaudado,
        -- incluyendo el monto de la inversión actual.
        DECLARE @porcentajeTotal DECIMAL(10, 6);
        IF @valorTotalProyecto > 0
            SET @porcentajeTotal = ((@totalInvertido + @monto) / @valorTotalProyecto) * 100;
        ELSE
            SET @porcentajeTotal = 0;

        -- Si la suma total de las inversiones (incluyendo la actual) excede la meta del proyecto (100%),
        -- ajusta el monto de la inversión actual para que no se sobrepase el 100%.
        IF @porcentajeTotal > 100
        BEGIN
            DECLARE @montoOriginal DECIMAL(15, 2) = @monto; -- Almacena el monto original propuesto.
            -- El nuevo monto de inversión se convierte en la cantidad restante para alcanzar la meta.
            SET @monto = @valorTotalProyecto - @totalInvertido;
            
            IF @monto < 0 SET @monto = 0; -- Asegura que el monto ajustado no sea negativo.
            
            -- Recalcula el porcentaje accionario utilizando el monto de inversión *ajustado*
            -- más las inversiones pasadas del inversionista.
            SET @nuevaInversionTotalInversionista = @totalInvertidoPorEsteInversionista + @monto;
            IF @valorTotalProyecto > 0
                SET @porcentajeAccionario = (@nuevaInversionTotalInversionista / @valorTotalProyecto) * 100;
            ELSE
                SET @porcentajeAccionario = 0;

            -- Añade un mensaje de advertencia informando sobre el ajuste del monto.
            SET @mensaje = 'Advertencia: El monto de inversión se ajustó a ' + CAST(@monto AS VARCHAR) + ' para no exceder el valor total del proyecto.';
        END
    END TRY
    BEGIN CATCH
        -- Captura cualquier error ocurrido durante el cálculo del porcentaje accionario y devuelve un mensaje.
        SET @resultado = 0;
        SET @mensaje = 'Error al calcular porcentaje accionario: ' + ERROR_MESSAGE();
        RETURN;
    END CATCH
    
    -- Restablece el nivel de aislamiento de la transacción al predeterminado (READ COMMITTED)
    -- una vez que el cálculo crítico ha terminado.
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    
    /* =====================================================
        INICIAR TRANSACCIÓN (OPERACIONES CRÍTICAS)
        Todas las operaciones de modificación de datos se envuelven en una transacción
        explícita para asegurar atomicidad. Si cualquier paso falla, toda la transacción
        se revierte para mantener la integridad de los datos.
    ===================================================== */
    BEGIN TRY
        BEGIN TRANSACTION @transactionName; -- Inicia la transacción con un nombre para facilitar el manejo.
        
        /* -----------------------------------------------------
            1. ACTUALIZAR SALDO DEL INVERSIONISTA
            Se modifica el balance del inversionista en la tabla 'voto_InversionistaBalance'.
        ----------------------------------------------------- */
        SET @nuevoSaldo = @saldoActual - @monto; -- Calcula el nuevo saldo restando el monto invertido.
        
        IF @inversionistaBalanceId IS NOT NULL -- Si el inversionista ya tiene un registro de balance.
        BEGIN
            UPDATE [dbo].[voto_InversionistaBalance]
            SET 
                lastBalance = balance,  -- Guarda el saldo actual como 'lastBalance' (saldo antes de esta operación).
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
                @inversionistaId, @nuevoSaldo, @saldoActual, -- Inserta los saldos inicial y final de la operación.
                @fundId, @hashTransaccion -- Asocia al fondo y el hash de la transacción.
            );
            
            SET @inversionistaBalanceId = SCOPE_IDENTITY(); -- Obtiene el ID del registro de balance recién insertado.
        END
        
        /* -----------------------------------------------------
            2. REGISTRAR LA INVERSIÓN
            Se inserta un nuevo registro en la tabla 'voto_Inversiones' con los detalles de la inversión.
        ----------------------------------------------------- */
        INSERT INTO [dbo].[voto_Inversiones] (
            [propuestaId], [userId], [monto], 
            [fechaInversion], [metodoPago], [comprobantePago], 
            [hashTransaccion], [estado]
        )
        VALUES (
            @propuestaId, @userId, @monto, -- IDs de propuesta y usuario, y el monto invertido.
            @fechaActual, @nombreMetodoPago, @comprobantePago, -- Fecha, método y comprobante del pago.
            @hashTransaccion, -- Se inserta el hash binario directamente (asumiendo que la columna es VARBINARY).
            'Aprobada' -- Establece el estado inicial de la inversión como 'Aprobada'.
        );
        
        SET @inversionId = SCOPE_IDENTITY(); -- Obtiene el ID de la inversión recién registrada.
        
        /* -----------------------------------------------------
            3. REGISTRAR PAGO CON INFORMACIÓN COMPLETA
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
            @inversionistaId, @monto, @monto, 0x01, -- Montos, y estado del resultado (0x01 asumido como éxito).
            0x01, '', @fechaActual, 0x01, @exchangeRate, -- Autorización, error, fecha, checksum, tasa de cambio.
            @monto * @exchangeRate, 1, @currencyId, @hashTransaccion -- Monto convertido, ID de módulo (asumido 1), moneda, hash.
        );
        
        SET @pagoId = SCOPE_IDENTITY(); -- Obtiene el ID del pago recién registrado.
        
        /* -----------------------------------------------------
            4. REGISTRAR TRANSACCIÓN
            Se inserta un registro detallado en la tabla 'voto_Transacciones' para esta operación de inversión.
        ----------------------------------------------------- */
        -- Obtiene el siguiente ID disponible para 'transaccionId'.
        -- Nota: Si 'transaccionId' fuera una columna IDENTITY, esta línea y la inclusión explícita
        -- de 'transaccionId' en el INSERT no serían necesarias.
        SELECT @transaccionId = ISNULL(MAX(transaccionId), 0) + 1 FROM [dbo].[voto_Transacciones];

        INSERT INTO [dbo].[voto_Transacciones] (
            [transaccionId], -- ID de la transacción (generado manualmente aquí).
            [description], [tranDateTime], [postTime],
            [pagoId], [refNumber], [inversionistaId],
            [transTypeId], [inversionistaBalanceId], [hashTrans],
            [llavePrivada] 
        )
        VALUES (
            @transaccionId, -- El ID calculado para la transacción.
            'Inversión en propuesta: ' + @tituloPropuesta, -- Descripción de la transacción.
            @fechaActual, @fechaActual, -- Fecha y hora de la transacción y posteo.
            @pagoId, @comprobantePago, @inversionistaId, -- IDs de pago, referencia y inversionista.
            @transTypeId, @inversionistaBalanceId, @hashTransaccion, -- Tipo de transacción, balance ID, hash.
            -- Genera un hash SHA2_256 para una llave privada simulada, usando el hash de la transacción.
            HASHBYTES('SHA2_256', 'LlavePrivadaGeneradaParaTransaccion_' + CONVERT(VARCHAR(256), @hashTransaccion)) 
        );
        
        /* -----------------------------------------------------
            5. ACTUALIZAR RECAUDACIÓN DE FONDOS
            Se actualizan los fondos recaudados para la propuesta o se crea un nuevo registro
            de recaudación si es la primera inversión para esta propuesta.
        ----------------------------------------------------- */
        IF @recaudacionId IS NOT NULL -- Si ya existe un registro de recaudación para la propuesta.
        BEGIN
            UPDATE [dbo].[voto_recaudacionFondos]
            SET fondosRecaudados = fondosRecaudados + @monto, -- Incrementa los fondos recaudados.
                inversionId = @inversionId -- Actualiza la última inversión asociada a esta recaudación.
            WHERE recaudacionId = @recaudacionId;
        END
        ELSE -- Si no existe un registro de recaudación de fondos para esta propuesta.
        BEGIN
            INSERT INTO [dbo].[voto_recaudacionFondos] (
				[inversionId],	        -- Relaciona con la inversión que acaba de ocurrir.
				[metaFinanciamiento],   -- Establece la meta de financiamiento del proyecto.
				[minimoFinanciamiento],	-- Establece un mínimo de financiamiento (asumido 50% de la meta).
				[fondosRecaudados],	    -- Inicia los fondos recaudados con el monto de la inversión actual.
				[hashContenido]         -- Hash del contenido para verificación.
			)
			VALUES (
				@inversionId,	
				@valorTotalProyecto,
				@valorTotalProyecto * 0.5,	
				@monto,	
				@hashTransaccion
			);
            
            SET @recaudacionId = SCOPE_IDENTITY(); -- Obtiene el ID del nuevo registro de recaudación.
            
            -- Actualiza el registro de publicación de crowdfunding para vincularlo a la nueva recaudación.
            IF @publicacionId IS NOT NULL
            BEGIN
                UPDATE [dbo].[voto_CrowdfundingPublicaciones]
                SET recaudacionId = @recaudacionId
                WHERE publicacionId = @publicacionId;
            END
        END
        
        /* -----------------------------------------------------
            6. PROGRAMAR DESEMBOLSOS
            Se generan registros de desembolsos futuros basados en los ítems definidos en el plan de trabajo.
            El monto de cada desembolso se calcula proporcionalmente al porcentaje accionario
            (la inversión acumulada del inversionista) en relación con el valor total del proyecto.
        ----------------------------------------------------- */
        INSERT INTO [dbo].[voto_Desembolsos] (
            [propuestaId], [itemId], [fechaProgramada],
            [monto], [estadoId], [comprobante],
            [hashTransaccion], [userIdAutorizacion], [llavePrivada] 
        )
        SELECT 
            @propuestaId,
            itemId,
            DATEADD(MONTH, numeroMes, @fechaActual), -- Calcula la fecha programada añadiendo meses a la fecha actual.
            -- Calcula el monto de desembolso para cada ítem. Se usa el 'monto' del ítem de desembolso
            -- y se escala por la proporción que la inversión total acumulada del inversionista
            -- representa sobre el valor total del proyecto.
            (SELECT @nuevaInversionTotalInversionista * monto / @valorTotalProyecto) AS montoDesembolsoItem, 
            1, -- Estado 'Pendiente' (asumiendo 1 es el ID para pendiente).
            NULL, -- Comprobante inicial nulo.
            @hashTransaccion, -- Hash de la transacción.
            NULL, -- Usuario de autorización inicial nulo.
            -- Genera un hash SHA2_256 para una llave privada simulada para el desembolso.
            HASHBYTES('SHA2_256', 'LlavePrivadaDesembolso_' + CONVERT(VARCHAR(256), @hashTransaccion)) 
        FROM [dbo].[voto_ItemsDesembolso]
        WHERE planId = @planId; -- Filtra por el plan de trabajo de la propuesta.
        
        /* -----------------------------------------------------
            7. GENERAR DOCUMENTACIÓN CONTRACTUAL
            Se crean los registros necesarios para el contrato de inversión en las tablas
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
            0,     -- Indica que el archivo no está marcado como eliminado.
            'Contrato de Inversión para Propuesta ' + CAST(@propuestaId AS VARCHAR), -- Referencia o descripción del archivo.
            @fechaActual, -- Fecha de generación del archivo.
            @mediaTypeId_Doc, -- ID del tipo de medio 'Documento'.
            '1.0'  -- Versión inicial del documento.
        );
        SET @mediaFileId_Contrato = SCOPE_IDENTITY(); -- Obtiene el ID generado automáticamente para el nuevo mediaFile.

        -- Inserta un registro en 'voto_Documents', que es la tabla maestra de todos los documentos.
        INSERT INTO [dbo].[voto_Documents] (
            [nombreDocumento], [hashDocumento], [usuarioSubio],
            [estadoId], [detalles], [lastUpdate],
            [docTypeId],    -- ID del tipo de documento (singular), según la estructura final de tu tabla.
            [mediaFileId],
            [version] 
        )
        VALUES (
            'Contrato de Inversión #' + CAST(@inversionId AS VARCHAR), -- Nombre del documento contractual.
            @hashTransaccion, -- Hash binario del contenido del documento.
            @userId, -- ID del usuario que "subió" o generó este documento.
            1, -- Estado 'Activo' (asumiendo 1 es el ID para activo).
            'Documento generado automáticamente para la inversión de la propuesta ' + @tituloPropuesta, -- Detalles.
            @fechaActual, -- Fecha de la última actualización.
            @docTypeIdContrato, -- ID del tipo de documento 'Contrato de Inversión'.
            @mediaFileId_Contrato, -- ID del archivo multimedia asociado.
            '1.0' -- Versión del documento.
        );
        
        SET @documentoId = SCOPE_IDENTITY(); -- Obtiene el ID del documento recién insertado.
        
        -- Relaciona el documento contractual con la inversión específica en la tabla 'voto_InversionDocumentos'.
        INSERT INTO [dbo].[voto_InversionDocumentos] (
            [documentoId], [inversionId], [fecha], [enabled]
        )
        VALUES (
            @documentoId, @inversionId, @fechaActual, 1 -- Habilita la relación del documento con la inversión.
        );
        
        -- Si todas las operaciones dentro del bloque TRY se completaron sin errores,
        -- se confirma la transacción, haciendo permanentes todos los cambios.
        COMMIT TRANSACTION @transactionName;
        
        -- Se establece el parámetro de salida @resultado a 1 (éxito) y se construye
        -- un mensaje de éxito, incluyendo el porcentaje accionario calculado.
        SET @resultado = 1;
        SET @mensaje = ISNULL(@mensaje + ' ', '') + 'Inversión registrada exitosamente. Porcentaje accionario: ' + 
                     CAST(ROUND(@porcentajeAccionario, 4) AS VARCHAR) + '%';
    END TRY
    BEGIN CATCH
        -- Manejo de errores: este bloque se ejecuta si cualquier error ocurre dentro del bloque TRY.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION @transactionName; -- Si hay una transacción abierta, se revierte para deshacer todos los cambios.
            
        SET @resultado = 0; -- Establece el parámetro de salida @resultado a 0 (error).
        SET @mensaje = 'Error al procesar la inversión: ' + ERROR_MESSAGE(); -- Captura y asigna el mensaje de error de SQL Server.
        
        -- Registra el error en la tabla de logs ('voto_Log') para fines de depuración y auditoría.
        INSERT INTO [dbo].[voto_Log] (
            [description], [postTime], [computer], [username],
            [trace], [reference1], [reference2], [checksum]
        )
        VALUES (
            'Error en sp_InvertirEnPropuesta: ' + ERROR_MESSAGE(), -- Descripción detallada del error.
            GETDATE(), HOST_NAME(), @usernameInversionista, -- Fecha/hora, nombre del equipo, nombre de usuario.
            'Propuesta: ' + @tituloPropuesta + ', Monto: ' + CAST(@monto AS VARCHAR), -- Traza del contexto del error.
            @propuestaId, @userId, -- Referencias a la propuesta y el usuario.
            -- Genera un hash SHA2_256 para el registro de log, asegurando su unicidad y la integridad de la entrada.
            HASHBYTES('SHA2_256', CAST(@propuestaId AS VARCHAR) + @usernameInversionista + ERROR_MESSAGE())
        );
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_VerificarMFA]    Script Date: 24/6/2025 16:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Primero crear el procedimiento solo
CREATE   PROCEDURE [dbo].[sp_VerificarMFA]
    @UserId INT,
    @Codigo VARCHAR(10),
    @Resultado BIT OUTPUT
AS
BEGIN
    DECLARE @MFAId INT, @CodigoValido VARCHAR(10), @Expiracion DATETIME, @Bloqueado BIT;
    
    -- Obtener el MFA activo para el usuario
    SELECT TOP 1 
        @MFAId = [mfaId], 
        @CodigoValido = [codigo], 
        @Expiracion = [fechaExpiracion],
        @Bloqueado = [bloqueado]
    FROM [dbo].[voto_AutenticacionMFA]
    WHERE [userId] = @UserId AND [activo] = 1
    ORDER BY [fechaRegistro] DESC;
    
    -- Verificar condiciones
    IF @Bloqueado = 1
    BEGIN
        SET @Resultado = 0;
        RETURN;
    END
    
    IF @CodigoValido IS NULL OR @Expiracion < GETDATE()
    BEGIN
        SET @Resultado = 0;
        RETURN;
    END
    
    -- Comparar códigos
    IF @CodigoValido = @Codigo
    BEGIN
        -- Actualizar registro MFA
        UPDATE [dbo].[voto_AutenticacionMFA]
        SET [ultimoUso] = GETDATE(),
            [codigo] = NULL,
            [fechaExpiracion] = NULL,
            [intentosFallidos] = 0
        WHERE [mfaId] = @MFAId;
        
        SET @Resultado = 1;
    END
    ELSE
    BEGIN
        -- Incrementar intentos fallidos
        UPDATE [dbo].[voto_AutenticacionMFA]
        SET [intentosFallidos] = [intentosFallidos] + 1,
            [bloqueado] = CASE WHEN [intentosFallidos] >= 2 THEN 1 ELSE 0 END
        WHERE [mfaId] = @MFAId;
        
        SET @Resultado = 0;
    END
END;
GO
USE [master]
GO
ALTER DATABASE [voto_Puravida2] SET  READ_WRITE 
GO
