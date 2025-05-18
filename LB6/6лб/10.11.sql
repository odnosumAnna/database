-- Завдання 10: Перше виконання курсором
DECLARE @CursorStartTime1 DATETIME2 = SYSDATETIME();

DECLARE AccidentCursor CURSOR LOCAL FOR
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

OPEN AccidentCursor;

DECLARE 
    @ID_Accident INT,
    @Date DATE,
    @Time TIME,
    @Location VARCHAR(100),
    @Accident_Type VARCHAR(50),
    @DriverName VARCHAR(200),
    @License_Plate VARCHAR(50),
    @PolicemanName VARCHAR(200),
    @CulpritType VARCHAR(50);

FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Тут можна виконувати дії з даними
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;

DECLARE @CursorEndTime1 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration1 INT = DATEDIFF(MILLISECOND, @CursorStartTime1, @CursorEndTime1);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (first run)', @CursorDuration1);

-- Завдання 11: Друге виконання без DEALLOCATE
DECLARE @CursorStartTime2 DATETIME2 = SYSDATETIME();

OPEN AccidentCursor;
FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Тут можна виконувати дії з даними
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;

DECLARE @CursorEndTime2 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration2 INT = DATEDIFF(MILLISECOND, @CursorStartTime2, @CursorEndTime2);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (second run)', @CursorDuration2);

-- Третє виконання для демонстрації
DECLARE @CursorStartTime3 DATETIME2 = SYSDATETIME();

OPEN AccidentCursor;
FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Тут можна виконувати дії з даними
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;
DEALLOCATE AccidentCursor;

DECLARE @CursorEndTime3 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration3 INT = DATEDIFF(MILLISECOND, @CursorStartTime3, @CursorEndTime3);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (third run)', @CursorDuration3);