-- �������� 3: DML ������� (AFTER �� INSTEAD OF)

-- AFTER INSERT ������ ��� ������� Accident
CREATE TRIGGER tr_Accident_AfterInsert
ON Accident
AFTER INSERT
AS
BEGIN
    PRINT 'AFTER INSERT ������: ���� ������ ����� ����� ��� ���'
    SELECT '������ ���', i.ID_Accident, i.Date, i.Location 
    FROM inserted i
END;
GO

-- INSTEAD OF INSERT ������ ��� ������� Driver
CREATE TRIGGER tr_Driver_InsteadOfInsert
ON Driver
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'INSTEAD OF INSERT ������: �������� ����� ����� �������� ����'
    
    -- �������� ����������� ������� ������ ����������
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(License_Number) > 10)
    BEGIN
        RAISERROR('����� ���������� ���� �� ���� ���� ������ �� 10 �������', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- �������� ����������� ������� ϲ�
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(LastName) > 50 OR LEN(FirstName) > 50 OR LEN(MiddleName) > 50)
    BEGIN
        RAISERROR('����� ��������� ϲ� �� ���� ���� ������ �� 50 �������', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- ���� ��� � �������, �������� �������
    INSERT INTO Driver (LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone)
    SELECT LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone
    FROM inserted
    
    PRINT '��� ���� ������ �����'
END;
GO

-- AFTER UPDATE ������ ��� ������� Vehicle
CREATE TRIGGER tr_Vehicle_AfterUpdate
ON Vehicle
AFTER UPDATE
AS
BEGIN
    PRINT 'AFTER UPDATE ������: ���� �������� ��� ������������� ������'
    
    SELECT '�������� ������������ ����', 
           i.ID_Vehicle AS 'ID ��', 
           d.ID_Vehicle AS 'ID ����',
           d.License_Plate AS '����� �����',
           i.License_Plate AS '������ �����'
    FROM inserted i
    JOIN deleted d ON i.ID_Vehicle = d.ID_Vehicle
END;
GO

-- INSTEAD OF DELETE ������ ��� ������� Policeman
CREATE TRIGGER tr_Policeman_InsteadOfDelete
ON Policeman
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'INSTEAD OF DELETE ������: ������ ��������� ���������'
    
    -- ����������, �� �� � �������� ������� � ���
    DECLARE @AccidentID INT
    SELECT @AccidentID = ID_Accident FROM deleted
    
    DECLARE @PolicemanCount INT
    SELECT @PolicemanCount = COUNT(*) FROM Policeman WHERE ID_Accident = @AccidentID
    
    IF @PolicemanCount <= 1
    BEGIN
        RAISERROR('�� ����� �������� ���������� ��������� � ���', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- ���� �� �������, ���������
    DELETE FROM Policeman WHERE ID_Policeman IN (SELECT ID_Policeman FROM deleted)
    
    PRINT '̳�������� ������ ��������'
END;
GO

