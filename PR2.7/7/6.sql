-- ���� constraint ���� � ���������, ��� �� ���� ��������
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_victim_accident')
BEGIN
    ALTER TABLE Victim DROP CONSTRAINT fk_victim_accident;
END

-- ������ FK � �������� ��������� (������� �� "IMMEDIATE" � ����)
ALTER TABLE Victim
WITH CHECK
ADD CONSTRAINT fk_victim_accident FOREIGN KEY (ID_Accident) REFERENCES Accident(ID_Accident);

-- ����� ������ "DEFERRED" � ��������� �������� FK ����� ���������
ALTER TABLE Victim NOCHECK CONSTRAINT fk_victim_accident;

BEGIN TRANSACTION;

-- ���������� ��� ��� ������� �������� FK
INSERT INTO Victim 
    (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status) 
VALUES 
    (21632, 'White', 'Charles', 'Q', '641 Oak Blvd', 'AB8209996', 'Burns', 'Severe', 'Outpatient');

-- ϳ��� ��� ������� ��������� �������� � ��������� FK
ALTER TABLE Victim WITH CHECK CHECK CONSTRAINT fk_victim_accident;

COMMIT;


-- SET CONSTRAINTS ALL IMMEDIATE; --  �� ����������� � SQL Server
-- SET CONSTRAINTS ALL DEFERRED;  --  �� ����������� � SQL Server
