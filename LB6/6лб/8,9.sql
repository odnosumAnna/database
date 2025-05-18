-- Створення таблиці для результатів (якщо ще не існує)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QueryExecutionTimes')
BEGIN
    CREATE TABLE QueryExecutionTimes (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        QueryType VARCHAR(50) NOT NULL,
        ExecutionTimeMs INT NOT NULL,
        ExecutionDateTime DATETIME2 DEFAULT SYSDATETIME()
    );
END

-- Завдання 8: Запит без індексів
DECLARE @StartTime1 DATETIME2 = SYSDATETIME();

-- Складний запит з JOIN, фільтрацією, сортуванням
SELECT 
    a.ID_Accident,
    a.Date,
    a.Time,
    a.Location,
    a.Accident_Type,
    d.LastName + ' ' + d.FirstName AS DriverName,
    v.License_Plate,
    p.LastName + ' ' + p.FirstName AS PolicemanName,
    c.Type AS CulpritType
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
JOIN Driver_Involvement di ON a.ID_Accident = di.ID_Accident
JOIN Driver d ON di.ID_Driver = d.ID_Driver
JOIN Policeman p ON a.ID_Accident = p.ID_Accident
LEFT JOIN Culprit c ON a.ID_Accident = c.ID_Accident
WHERE a.Date BETWEEN '2020-01-01' AND '2024-12-31'
  AND a.Accident_Type = 'Rear-end'
ORDER BY a.Date DESC, a.Time DESC;

DECLARE @EndTime1 DATETIME2 = SYSDATETIME();
DECLARE @Duration1 INT = DATEDIFF(MILLISECOND, @StartTime1, @EndTime1);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Basic query without indexes', @Duration1);

-- Завдання 9: Створення індексів та повторний запит
CREATE NONCLUSTERED INDEX IDX_Accident_Date_Type ON Accident(Date, Accident_Type);
CREATE NONCLUSTERED INDEX IDX_Vehicle_Accident ON Vehicle(ID_Accident);
CREATE NONCLUSTERED INDEX IDX_DriverInvolvement_Accident ON Driver_Involvement(ID_Accident);

DECLARE @StartTime2 DATETIME2 = SYSDATETIME();

-- Той самий запит з індексами
SELECT 
    a.ID_Accident,
    a.Date,
    a.Time,
    a.Location,
    a.Accident_Type,
    d.LastName + ' ' + d.FirstName AS DriverName,
    v.License_Plate,
    p.LastName + ' ' + p.FirstName AS PolicemanName,
    c.Type AS CulpritType
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
JOIN Driver_Involvement di ON a.ID_Accident = di.ID_Accident
JOIN Driver d ON di.ID_Driver = d.ID_Driver
JOIN Policeman p ON a.ID_Accident = p.ID_Accident
LEFT JOIN Culprit c ON a.ID_Accident = c.ID_Accident
WHERE a.Date BETWEEN '2020-01-01' AND '2024-12-31'
  AND a.Accident_Type = 'Rear-end'
ORDER BY a.Date DESC, a.Time DESC;

DECLARE @EndTime2 DATETIME2 = SYSDATETIME();
DECLARE @Duration2 INT = DATEDIFF(MILLISECOND, @StartTime2, @EndTime2);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Optimized query with indexes', @Duration2);