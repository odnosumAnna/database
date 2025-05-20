--1. ������ ��� �������� ���������� ��������� ����� ������������� ������
CREATE TRIGGER tr_Vehicle_LicensePlateUnique
ON Vehicle
INSTEAD OF INSERT
AS
BEGIN
    -- �������� �� �������� �������� �������� �����
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Vehicle v ON i.License_Plate = v.License_Plate
    )
    BEGIN
        RAISERROR('������������ ���� � ����� �������� ������ ��� ����', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- �������� ����������� ������� ��������� �����
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(License_Plate) > 10)
    BEGIN
        RAISERROR('�������� ���� �� ���� ���� ������ �� 10 �������', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- ���� ��� � �������, �������� �������
    INSERT INTO Vehicle (ID_Accident, License_Plate, Model, Year)
    SELECT ID_Accident, License_Plate, Model, Year
    FROM inserted
    
    PRINT '������������ ���� ������ ������'
END;
GO

--2. ������ ��� �������� �������� ����
CREATE TRIGGER tr_Driver_PhoneCheck
ON Driver
AFTER INSERT, UPDATE
AS
BEGIN
    -- �������� ������� �������� (����� 10 ����)
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE Phone IS NOT NULL AND LEN(REPLACE(REPLACE(REPLACE(REPLACE(Phone, ' ', ''), '-', ''), '(', ''), ')', '')) < 10
    )
    BEGIN
        RAISERROR('����� �������� ������� ������ ���������� 10 ����', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO

--3. ������ ��� �������� �������� ��������� ��� ���
CREATE TRIGGER tr_Accident_PolicemanCheck
ON Accident
AFTER INSERT, UPDATE
AS
BEGIN
    -- ��������, �� ��� ������� ������ ��� � ���� � ���� ��������
    IF EXISTS (
        SELECT i.ID_Accident
        FROM inserted i
        LEFT JOIN Policeman p ON i.ID_Accident = p.ID_Accident
        WHERE p.ID_Policeman IS NULL
    )
    BEGIN
        RAISERROR('����� ��� ������� ���� ���� � ������ ������������ ���������', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO

--4. ������ ��� �������� ���������� ������ ��������
CREATE TRIGGER tr_Person_PassportUnique
ON Victim
AFTER INSERT, UPDATE
AS
BEGIN
    -- �������� ���������� ������ �������� ����� ������������
    IF EXISTS (
        SELECT Passport_Number
        FROM Victim
        WHERE Passport_Number IN (SELECT Passport_Number FROM inserted)
        GROUP BY Passport_Number
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('����� �������� ������� ���� ��������� ����� ������������', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- �������� ���������� ������ �������� ����� �������
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Pedestrian p ON i.Passport_Number = p.Passport_Number
    )
    BEGIN
        RAISERROR('��� ����� �������� ��� ��������������� ��������', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO
