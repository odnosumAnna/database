SELECT 
    ind.name AS Index_Name,
    ind.type_desc AS Index_Type,
    ind.is_unique AS Is_Unique,
    frag.avg_fragmentation_in_percent AS Fragmentation_Level,
    tab.name AS Table_Name,
    frag.page_count AS Page_Count
FROM 
    sys.indexes ind
JOIN 
    sys.tables tab ON ind.object_id = tab.object_id
JOIN 
    sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, 'DETAILED') frag
    ON ind.index_id = frag.index_id AND ind.object_id = frag.object_id
ORDER BY 
    Table_Name, Index_Name;
