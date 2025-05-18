-- 1. ��������� �����������, ���� ����
IF OBJECT_ID('dbo.AccidentSeq', 'SO') IS NOT NULL
    DROP SEQUENCE dbo.AccidentSeq;
GO

-- ��������� �����������
CREATE SEQUENCE dbo.AccidentSeq
    START WITH 1000
    INCREMENT BY 1;
GO

-- 2. ��������� ���������, ���� ����
IF OBJECT_ID('dbo.InsertAccidentWithSequence', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertAccidentWithSequence;
GO

-- ��������� ��������� ���������
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

    -- ������� ��� ������ �������� ��� ID_Accident
    INSERT INTO dbo.Accident (
        Date, Time, Location, 
        Victim_Count, Accident_Type, Investigation_Status
    )
    VALUES (
        @Date, @Time, @Location,
        @Victim_Count, @Accident_Type, @Investigation_Status
    );

    -- ������� ID ������ ������
    SET @NewID = SCOPE_IDENTITY();
END;
GO

-- 3. ������ ��������� � ��������� ������
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
