SELECT 
    db.name AS DatabaseName,
    t.name AS TableName,
    i.name AS IndexName,
    ips.index_type_desc AS IndexType,
    ips.avg_fragmentation_in_percent AS Fragmentation,
    ips.page_count AS PageCount
FROM 
    sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, 'DETAILED') AS ips
JOIN 
    sys.tables AS t
    ON ips.object_id = t.object_id
JOIN 
    sys.indexes AS i
    ON ips.object_id = i.object_id
    AND ips.index_id = i.index_id
JOIN 
    sys.databases AS db
    ON db.database_id = DB_ID()
WHERE 
    ips.page_count > 0  -- Фільтруємо індекси, що мають більше 0 сторінок
ORDER BY 
    ips.avg_fragmentation_in_percent DESC;  -- Відсортовано за рівнем фрагментації
