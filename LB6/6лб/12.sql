-- Виведення результатів для аналізу
SELECT 
    ID,
    QueryType AS 'Тип запиту',
    ExecutionTimeMs AS 'Час виконання (мс)',
    ExecutionDateTime AS 'Дата виконання'
FROM QueryExecutionTimes
ORDER BY ID;

-- Аналіз результатів
SELECT 
    ' The fastest query' AS Аналіз,
    QueryType AS 'Тип запиту',
    ExecutionTimeMs AS 'Час (мс)'
FROM QueryExecutionTimes
WHERE ExecutionTimeMs = (SELECT MIN(ExecutionTimeMs) FROM QueryExecutionTimes)
UNION ALL
SELECT 
    'The slowest query',
    QueryType,
    ExecutionTimeMs
FROM QueryExecutionTimes
WHERE ExecutionTimeMs = (SELECT MAX(ExecutionTimeMs) FROM QueryExecutionTimes);