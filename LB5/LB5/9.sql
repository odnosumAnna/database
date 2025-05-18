-- ��������� ��� ������� ���� � �����������
CREATE PROCEDURE InsertAccidentWithTransaction
    @Location NVARCHAR(100),
    @Date DATETIME,
    @Time TIME,
    @Victim_Count INT,
    @Accident_Type NVARCHAR(50),
    @Investigation_Status NVARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;  -- �������� ����������

    BEGIN TRY
        -- ������� ������ ������ � ������� Accident
        INSERT INTO dbo.Accident (Location, Date, Time, Victim_Count, Accident_Type, Investigation_Status)
        VALUES (@Location, @Date, @Time, @Victim_Count, @Accident_Type, @Investigation_Status);

        COMMIT TRANSACTION;  -- ϳ���������� ����
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  -- � ��� ������� ��������� ����
        PRINT '������� ������� ����: ' + ERROR_MESSAGE();  -- �������� ����������� ��� �������
    END CATCH
END;
GO
