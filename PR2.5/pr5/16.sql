SELECT
    DB_NAME() AS [База_даних],
    OBJECT_NAME(i.[object_id]) AS [Таблиця],
    i.name AS [Індекс],
    i.type_desc AS [Тип_індексу],
    i.is_unique AS [Унікальний],
    ps.avg_fragmentation_in_percent AS [Фрагментація_у_%],
    ps.page_count AS [Кількість_сторінок]
FROM
    sys.indexes AS i
INNER JOIN
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
    ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE
    i.type > 0 AND i.is_hypothetical = 0
ORDER BY
    ps.avg_fragmentation_in_percent DESC;
