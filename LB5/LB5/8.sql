-- �������� ������� �������� ��������� ����� ���������� �����
IF OBJECT_ID('tempdb..#GetDrivers', 'P') IS NOT NULL
    DROP PROCEDURE #GetDrivers;
GO

IF OBJECT_ID('tempdb..#InsertDriver', 'P') IS NOT NULL
    DROP PROCEDURE #InsertDriver;
GO

IF OBJECT_ID('tempdb..#DeleteDriver', 'P') IS NOT NULL
    DROP PROCEDURE #DeleteDriver;
GO

-- ��������� ����� ��������

-- ��������� ��������� ��� ������� ����
CREATE PROCEDURE #InsertDriver
    @LastName NVARCHAR(100),
    @FirstName NVARCHAR(100),
    @MiddleName NVARCHAR(100),
    @License_Number NVARCHAR(50),
    @License_Expiry DATE,
    @Phone NVARCHAR(20),
    @Address NVARCHAR(255)
AS
BEGIN
    INSERT INTO dbo.Driver (LastName, FirstName, MiddleName, License_Number, License_Expiry, Phone, Address)
    VALUES (@LastName, @FirstName, @MiddleName, @License_Number, @License_Expiry, @Phone, @Address);
END;
GO

-- ��������� ��������� ��� ��������� ��䳿�
CREATE PROCEDURE #GetDrivers
AS
BEGIN
    SELECT * FROM dbo.Driver;
END;
GO

-- ��������� ��������� ��� ��������� ����
CREATE PROCEDURE #DeleteDriver
    @ID_Driver INT
AS
BEGIN
    DELETE FROM dbo.Driver WHERE ID_Driver = @ID_Driver;
END;
GO


EXEC #InsertDriver
    @LastName = '��������',
    @FirstName = '����',
    @MiddleName = '��������',
    @License_Number = 'AB1234567',
    @License_Expiry = '2026-12-31',
    @Phone = '380500123456',
    @Address = '�. ���, ���. �������� 123';

	EXEC #GetDrivers;

	EXEC #DeleteDriver @ID_Driver = 1;
