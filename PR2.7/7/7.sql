
-- �������� �������� �������� �� ������� 䳿 � ������ ���

-- 1) ��������� ������ (Domain constraint)
-- �������: ��� ��� ������� ���� �� ������� � ������� �� ����� 50 �������
ALTER TABLE Accident
ADD CONSTRAINT CHK_Accident_Type_Length
CHECK (Accident_Type IS NOT NULL AND LEN(Accident_Type) <= 50);

-- 2) ��������� �������� (Attribute constraint)
-- �������: ����������� ������� ���������� ������ ������������� ������ - 10 ������� (��� � ������� Vehicle)
-- ��� ������������ ������ CHECK �� ������ ������: ����� ������� ������ ����� ����� ����� �� ����� (���������)
ALTER TABLE Vehicle
ADD CONSTRAINT CHK_License_Plate_Format
CHECK (License_Plate NOT LIKE '%[^A-Z0-9]%');

-- 3) ��������� ������� (Tuple constraint)
-- �������: ���� ���� ���� �������� ���� ����� ������������ ������� � ���� ���
-- �������� ����� ��������� ������ �� ���� (ID_Accident, ID_Driver) � ������� Driver_Involvement (��� � PRIMARY KEY)
-- ��� ����������������, �������� ��������� ������ �� ID_Driver � ����� ���� ���
-- ��� �� ��� ����������� �� PRIMARY KEY, ���� �������: ������ ��������, �� ���� ���� �� ���� ���� ��������� � "Driver" � "Pedestrian" � ������ ���

ALTER TABLE Driver_Involvement
ADD CONSTRAINT CHK_Role_Valid CHECK (Role IN ('Driver', 'Pedestrian'));

-- 4) ��������� ��������� (Relation constraint)
-- �������: ����� ��� ������� ���� ���� � ������ ��������� (�����������)
-- ��������� ����� ������ ��� �������� �������� ������. SQL Server �� ������� FOREIGN KEY � ��������� ������� 1, ���� ������� � ��������:

CREATE TRIGGER trg_CheckPolicemanForAccident
ON Policeman
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- ��������, �� �� ��� ����� ���� � ������ ���������
    IF EXISTS (
        SELECT ID_Accident
        FROM Accident A
        WHERE NOT EXISTS (SELECT 1 FROM Policeman P WHERE P.ID_Accident = A.ID_Accident)
    )
    BEGIN
        RAISERROR('����� ��� ������� ���� ���� � ������ ���������', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- 5) ��������� ���� ����� (Database constraint)
-- �������: ���� ��� �� ���� ���� � �����������
ALTER TABLE Accident
ADD CONSTRAINT CHK_Date_NotFuture
CHECK (Date <= CAST(GETDATE() AS DATE));


