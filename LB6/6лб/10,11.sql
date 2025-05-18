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

-- Додано виведення заголовків
PRINT 'ID_Accident | Date       | Time     | Location          | Accident_Type | DriverName       | License_Plate | PolicemanName    | CulpritType';
PRINT '-----------------------------------------------------------------------------------------------------------------------------------';

FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Виведення даних у консоль
    PRINT FORMAT(@ID_Accident, '00000') + ' | ' + 
          CONVERT(VARCHAR(10), @Date, 120) + ' | ' + 
          CONVERT(VARCHAR(8), @Time) + ' | ' + 
          LEFT(@Location, 15) + '... | ' + 
          LEFT(@Accident_Type, 13) + ' | ' + 
          LEFT(@DriverName, 15) + ' | ' + 
          LEFT(@License_Plate, 13) + ' | ' + 
          LEFT(@PolicemanName, 15) + ' | ' + 
          ISNULL(@CulpritType, 'NULL');
    
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

PRINT CHAR(13) + CHAR(10) + 'Second run results:';
PRINT '-----------------------------------------------------------------------------------------------------------------------------------';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT FORMAT(@ID_Accident, '00000') + ' | ' + 
          CONVERT(VARCHAR(10), @Date, 120) + ' | ' + 
          CONVERT(VARCHAR(8), @Time) + ' | ' + 
          LEFT(@Location, 15) + '... | ' + 
          LEFT(@Accident_Type, 13) + ' | ' + 
          LEFT(@DriverName, 15) + ' | ' + 
          LEFT(@License_Plate, 13) + ' | ' + 
          LEFT(@PolicemanName, 15) + ' | ' + 
          ISNULL(@CulpritType, 'NULL');
    
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;

DECLARE @CursorEndTime2 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration2 INT = DATEDIFF(MILLISECOND, @CursorStartTime2, @CursorEndTime2);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (second run)', @CursorDuration2);

-- Третє виконання з DEALLOCATE
DECLARE @CursorStartTime3 DATETIME2 = SYSDATETIME();

OPEN AccidentCursor;
FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

PRINT CHAR(13) + CHAR(10) + 'Third run results:';
PRINT '-----------------------------------------------------------------------------------------------------------------------------------';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT FORMAT(@ID_Accident, '00000') + ' | ' + 
          CONVERT(VARCHAR(10), @Date, 120) + ' | ' + 
          CONVERT(VARCHAR(8), @Time) + ' | ' + 
          LEFT(@Location, 15) + '... | ' + 
          LEFT(@Accident_Type, 13) + ' | ' + 
          LEFT(@DriverName, 15) + ' | ' + 
          LEFT(@License_Plate, 13) + ' | ' + 
          LEFT(@PolicemanName, 15) + ' | ' + 
          ISNULL(@CulpritType, 'NULL');
    
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

PRINT CHAR(13) + CHAR(10) + 'Execution times:';
PRINT '1. First run: ' + CAST(@CursorDuration1 AS VARCHAR) + ' ms';
PRINT '2. Second run: ' + CAST(@CursorDuration2 AS VARCHAR) + ' ms';
PRINT '3. Third run: ' + CAST(@CursorDuration3 AS VARCHAR) + ' ms';