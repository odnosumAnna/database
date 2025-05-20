-- �������� 4: DDL �������

-- ������ ��� ���������� ��������� �������
CREATE TRIGGER tr_Database_CreateTable
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    PRINT '���� �������� ���� �������'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') AS '���� �������'
END;
GO

-- ������ ��� ���������� ��� � �������� �������
CREATE TRIGGER tr_Database_AlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    PRINT '���� ������ ��������� �������'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') AS '������ �������'
END;
GO

-- ������ ��� ���������� ��������� �������
CREATE TRIGGER tr_Database_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    PRINT '���� �������� �������'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') AS '�������� �������'
END;
GO
