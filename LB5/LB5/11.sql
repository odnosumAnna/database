-- 1. Видалення послідовності, якщо існує
IF OBJECT_ID('dbo.AccidentSeq', 'SO') IS NOT NULL
    DROP SEQUENCE dbo.AccidentSeq;
GO

-- Створення послідовності
CREATE SEQUENCE dbo.AccidentSeq
    START WITH 1000
    INCREMENT BY 1;
GO

-- 2. Видалення процедури, якщо існує
IF OBJECT_ID('dbo.InsertAccidentWithSequence', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertAccidentWithSequence;
GO

-- Створення збереженої процедури
CREATE PROCEDURE dbo.InsertAccidentWithSequence
    @Location NVARCHAR(100),
    @Date DATETIME,
    @Time TIME,
    @Victim_Count INT,
    @Accident_Type NVARCHAR(100),
    @Investigation_Status NVARCHAR(100),
    @NewID INT OUTPUT
AS
BEGIN
    DECLARE @NextID INT = NEXT VALUE FOR dbo.AccidentSeq;

    -- Вставка без явного значення для ID_Accident
    INSERT INTO dbo.Accident (
        Date, Time, Location, 
        Victim_Count, Accident_Type, Investigation_Status
    )
    VALUES (
        @Date, @Time, @Location,
        @Victim_Count, @Accident_Type, @Investigation_Status
    );

    -- Повертає ID нового запису
    SET @NewID = SCOPE_IDENTITY();
END;
GO

-- 3. Виклик процедури з тестовими даними
DECLARE @NewAccidentID INT;

EXEC dbo.InsertAccidentWithSequence
    @Location = 'Kyiv',
    @Date = '2023-11-15',
    @Time = '14:30:00',
    @Victim_Count = 3,
    @Accident_Type = 'Collision',
    @Investigation_Status = 'In Progress',
    @NewID = @NewAccidentID OUTPUT;

-- 4. Display the result
SELECT 'New Accident ID:' AS Info, @NewAccidentID AS ID;
