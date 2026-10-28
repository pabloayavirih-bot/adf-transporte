/* Limpieza usada para recargar las seis tablas principales de Bronze sin duplicar. */
DELETE FROM bronze.DemandaParadasAzure;
DELETE FROM bronze.IncidentesAzure;
DELETE FROM bronze.ParadasAzure;
DELETE FROM bronze.RutasAzure;
DELETE FROM bronze.VehiculosAzure;
DELETE FROM bronze.ViajesAzure;

/* IncidenteRutaAzure se manejo por separado y no se elimina aqui. */
