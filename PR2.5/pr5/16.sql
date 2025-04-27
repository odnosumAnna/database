SELECT
    DB_NAME() AS [����_�����],
    OBJECT_NAME(i.[object_id]) AS [�������],
    i.name AS [������],
    i.type_desc AS [���_�������],
    i.is_unique AS [���������],
    ps.avg_fragmentation_in_percent AS [������������_�_%],
    ps.page_count AS [ʳ������_�������]
FROM
    sys.indexes AS i
INNER JOIN
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
    ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE
    i.type > 0 AND i.is_hypothetical = 0
ORDER BY
    ps.avg_fragmentation_in_percent DESC;
