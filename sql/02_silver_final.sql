/* CAPA SILVER - version final de trabajo sin AnioFuente.
   Nombres alineados con los datasets/sinks usados en ADF.
   Ejecutar conectado a dw_transporte sobre una base limpia.
*/
SET NOCOUNT ON;
GO

IF DB_NAME() <> N'dw_transporte'
    THROW 51100, 'Conectese a dw_transporte antes de ejecutar.', 1;
GO

IF SCHEMA_ID(N'silver') IS NULL EXEC(N'CREATE SCHEMA silver');
GO

IF OBJECT_ID(N'silver.Rutas',N'U') IS NOT NULL OR
   OBJECT_ID(N'silver.Paradas',N'U') IS NOT NULL OR
   OBJECT_ID(N'silver.Vehiculos',N'U') IS NOT NULL OR
   OBJECT_ID(N'silver.Viajes',N'U') IS NOT NULL OR
   OBJECT_ID(N'silver.DemandaParadas',N'U') IS NOT NULL OR
   OBJECT_ID(N'silver.Incidentes',N'U') IS NOT NULL OR
   OBJECT_ID(N'silver.IncidenteRuta',N'U') IS NOT NULL
    THROW 51101, 'Ya hay tablas Silver. No ejecutar de nuevo sin revisar.', 1;
GO

CREATE TABLE silver.Rutas (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RutaHistoricaId NVARCHAR(30) NULL,
    CodigoRuta NVARCHAR(20) NULL,
    NombreRuta NVARCHAR(120) NULL,
    Origen NVARCHAR(80) NULL,
    Destino NVARCHAR(80) NULL,
    VigenciaDesde DATE NULL,
    VigenciaHasta DATE NULL,
    Estado NVARCHAR(20) NULL
);
GO

CREATE TABLE silver.Paradas (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ParadaHistoricaId NVARCHAR(30) NULL,
    CodigoPublicado NVARCHAR(20) NULL,
    NombreParada NVARCHAR(120) NULL,
    Zona NVARCHAR(40) NULL,
    Latitud DECIMAL(9,6) NULL,
    Longitud DECIMAL(9,6) NULL,
    VigenciaDesde DATE NULL,
    VigenciaHasta DATE NULL,
    Estado NVARCHAR(20) NULL
);
GO

CREATE TABLE silver.Vehiculos (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    VehiculoId NVARCHAR(20) NULL,
    Placa NVARCHAR(20) NULL,
    TipoVehiculo NVARCHAR(30) NULL,
    CapacidadEfectiva INT NULL,
    VigenciaDesde DATE NULL,
    VigenciaHasta DATE NULL,
    Estado NVARCHAR(20) NULL
);
GO

CREATE TABLE silver.Viajes (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ViajeId NVARCHAR(30) NULL,
    RutaHistoricaId NVARCHAR(30) NULL,
    VehiculoId NVARCHAR(20) NULL,
    FechaServicio DATE NULL,
    HoraProgramada TIME NULL,
    HoraSalida TIME NULL,
    HoraLlegada TIME NULL,
    ValidacionesTarjeta INT NULL,
    KmRecorridos DECIMAL(8,1) NULL,
    EstadoViaje NVARCHAR(20) NULL
);
GO

CREATE TABLE silver.DemandaParadas (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DemandaId NVARCHAR(30) NULL,
    FechaServicio DATE NULL,
    RutaHistoricaId NVARCHAR(30) NULL,
    ParadaHistoricaId NVARCHAR(30) NULL,
    Franja NVARCHAR(20) NULL,
    ValidacionesTarjeta INT NULL,
    Descensos INT NULL,
    DemandaNoAtendida INT NULL,
    Metodo NVARCHAR(30) NULL
);
GO

CREATE TABLE silver.Incidentes (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IncidenteId NVARCHAR(30) NULL,
    TipoIncidente NVARCHAR(30) NULL,
    Severidad NVARCHAR(15) NULL,
    FechaHoraInicio DATETIME2(0) NULL,
    FechaHoraFin DATETIME2(0) NULL,
    FechaHoraRegistro DATETIME2(0) NULL,
    VehiculoId NVARCHAR(20) NULL,
    Descripcion NVARCHAR(200) NULL
);
GO

CREATE TABLE silver.IncidenteRuta (
    SilverId BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    IncidenteId NVARCHAR(30) NULL,
    RutaHistoricaId NVARCHAR(30) NULL,
    EsPrincipal BIT NULL
);
GO

CREATE INDEX IX_silver_Viajes_FechaRuta
    ON silver.Viajes (FechaServicio, RutaHistoricaId);
CREATE INDEX IX_silver_Demanda_FechaFranja
    ON silver.DemandaParadas (FechaServicio, Franja);
GO
