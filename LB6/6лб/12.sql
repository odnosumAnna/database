-- ��������� ���������� ��� ������
SELECT 
    ID,
    QueryType AS '��� ������',
    ExecutionTimeMs AS '��� ��������� (��)',
    ExecutionDateTime AS '���� ���������'
FROM QueryExecutionTimes
ORDER BY ID;

-- ����� ����������
SELECT 
    ' The fastest query' AS �����,
    QueryType AS '��� ������',
    ExecutionTimeMs AS '��� (��)'
FROM QueryExecutionTimes
WHERE ExecutionTimeMs = (SELECT MIN(ExecutionTimeMs) FROM QueryExecutionTimes)
UNION ALL
SELECT 
    'The slowest query',
    QueryType,
    ExecutionTimeMs
FROM QueryExecutionTimes
WHERE ExecutionTimeMs = (SELECT MAX(ExecutionTimeMs) FROM QueryExecutionTimes);