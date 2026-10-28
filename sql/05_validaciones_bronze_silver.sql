/* =========================================================
   VALIDACIONES UTILIZADAS DURANTE LA TAREA
   ========================================================= */

/* 1. Distribucion por AnioFuente en Bronze. */
SELECT 'DemandaParadas' AS Tabla, AnioFuente, COUNT(*) AS Total
FROM bronze.DemandaParadasAzure
GROUP BY AnioFuente
UNION ALL
SELECT 'Incidentes', AnioFuente, COUNT(*)
FROM bronze.IncidentesAzure
GROUP BY AnioFuente
UNION ALL
SELECT 'Paradas', AnioFuente, COUNT(*)
FROM bronze.ParadasAzure
GROUP BY AnioFuente
UNION ALL
SELECT 'Rutas', AnioFuente, COUNT(*)
FROM bronze.RutasAzure
GROUP BY AnioFuente
UNION ALL
SELECT 'Vehiculos', AnioFuente, COUNT(*)
FROM bronze.VehiculosAzure
GROUP BY AnioFuente
UNION ALL
SELECT 'Viajes', AnioFuente, COUNT(*)
FROM bronze.ViajesAzure
GROUP BY AnioFuente
ORDER BY Tabla, AnioFuente;

/* 2. Conteos finales de Silver. */
SELECT 'DemandaParadas' AS Tabla, COUNT(*) AS Total FROM silver.DemandaParadas
UNION ALL
SELECT 'Incidentes', COUNT(*) FROM silver.Incidentes
UNION ALL
SELECT 'Paradas', COUNT(*) FROM silver.Paradas
UNION ALL
SELECT 'Rutas', COUNT(*) FROM silver.Rutas
UNION ALL
SELECT 'Vehiculos', COUNT(*) FROM silver.Vehiculos
UNION ALL
SELECT 'Viajes', COUNT(*) FROM silver.Viajes;

/* 3. Fechas nulas en Silver. */
SELECT 'DemandaParadas' AS Tabla,
       SUM(CASE WHEN FechaServicio IS NULL THEN 1 ELSE 0 END) AS FechasNulas
FROM silver.DemandaParadas
UNION ALL
SELECT 'Incidentes',
       SUM(CASE WHEN FechaHoraInicio IS NULL THEN 1 ELSE 0 END)
FROM silver.Incidentes
UNION ALL
SELECT 'Paradas',
       SUM(CASE WHEN VigenciaDesde IS NULL THEN 1 ELSE 0 END)
FROM silver.Paradas
UNION ALL
SELECT 'Rutas',
       SUM(CASE WHEN VigenciaDesde IS NULL THEN 1 ELSE 0 END)
FROM silver.Rutas
UNION ALL
SELECT 'Vehiculos',
       SUM(CASE WHEN VigenciaDesde IS NULL THEN 1 ELSE 0 END)
FROM silver.Vehiculos
UNION ALL
SELECT 'Viajes',
       SUM(CASE WHEN FechaServicio IS NULL THEN 1 ELSE 0 END)
FROM silver.Viajes;

/* 4. Comprobar que no quedaron fechas 1899 en Incidentes. */
SELECT COUNT(*) AS FechasRaras
FROM silver.Incidentes
WHERE YEAR(FechaHoraInicio) = 1899
   OR YEAR(FechaHoraFin) = 1899
   OR YEAR(FechaHoraRegistro) = 1899;

/* 5. Confirmar que los nulos de Incidentes/Viajes ya venian de Bronze. */
SELECT 'Incidentes' AS Tabla,
       COUNT(*) AS TotalBronze,
       SUM(CASE
             WHEN FechaHoraInicio IS NULL
               OR LTRIM(RTRIM(FechaHoraInicio)) = ''
             THEN 1 ELSE 0
           END) AS VaciosBronze
FROM bronze.IncidentesAzure
UNION ALL
SELECT 'Viajes',
       COUNT(*),
       SUM(CASE
             WHEN FechaServicio IS NULL
               OR LTRIM(RTRIM(FechaServicio)) = ''
             THEN 1 ELSE 0
           END)
FROM bronze.ViajesAzure;
