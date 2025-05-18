CREATE PROCEDURE InsertNAccidents
    @Count INT
AS
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @Count
    BEGIN
        INSERT INTO dbo.Accident (Location, Date, Time, Accident_Type)
        VALUES (CONCAT('Place ', @i), GETDATE(), CONVERT(TIME, GETDATE()), '��� ����');  -- ������� �������� ��� Accident_Type

        SET @i += 1;
    END
END;
GO

EXEC InsertNAccidents @Count = 5;  -- �� �������� 5 �����

SELECT * FROM dbo.Accident;
