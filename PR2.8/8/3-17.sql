
--3 ������������� ��� ������ ���� ��䳿�
CREATE VIEW vDriverNames AS
SELECT ID_Driver, FirstName, MiddleName, LastName
FROM Driver;


--4 ���� ���� ��䳿� � �������������
SELECT FirstName, MiddleName, LastName FROM vDriverNames;


--5 ������������� vInjuredDrivers, ��� ������ ��� ������������ ��䳿� (�, ��� � �� � ������� Victim, ��� � � ������� Driver_Involvement).
CREATE VIEW vInjuredDrivers AS
SELECT
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    D.Address,
    D.License_Number,
    A.ID_Accident,
    A.Date,
    A.Location,
    V.Injury_Type,
    V.Severity
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE V.Passport_Number IN (
    SELECT Passport_Number FROM Victim
    INTERSECT
    SELECT Passport_Number FROM (
        SELECT Passport_Number, Address
        FROM Driver
    ) AS DriverPassports
);


--6 ������������� vDrivers
CREATE VIEW vDrivers AS
SELECT
    ID_Driver,
    LastName,
    FirstName,
    MiddleName,
    Address,
    License_Number
FROM Driver;
--������� ��������� ����� ����� �������������:
UPDATE vDrivers
SET Address = '10 Shevchenko St'
WHERE ID_Driver = 1;


--7 ������������� � JOIN ��� ������� "���":
CREATE VIEW DriverAccidents AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    A.ID_Accident,
    A.Date,
    A.Time,
    A.Location,
    A.Accident_Type
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident;


--8 ���������� ��� ������� ���, � ���� ��� ������� ����� ����.
CREATE VIEW DriverAccidentCounts AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    COUNT(DI.ID_Accident) AS AccidentCount
FROM Driver D
LEFT JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName;

SELECT * FROM DriverAccidentCounts;


--10 �������������, ��� �������� �� ������ ��� ��������� ������������.

CREATE VIEW DriverAccidentCounts AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    COUNT(DI.ID_Accident) AS AccidentCount
FROM Driver D
LEFT JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName;

CREATE VIEW VIPDrivers AS
SELECT ID_Driver, LastName, FirstName, MiddleName, AccidentCount
FROM DriverAccidentCounts
WHERE AccidentCount > 5;


--11 ���� ������������� (ALTER VIEW):
ALTER VIEW DriverAccidents AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    D.Address,            -- ������ ���� ������ ����
    A.ID_Accident,
    A.Date,
    A.Time,
    A.Location,
    A.Accident_Type
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident;


--12  ��������� ������������� (DROP VIEW)
DROP VIEW VIPDrivers;


-- �������� 13.
-- ������������� � ����������� ��������: ��������� ������������� DriverSummary, ��� ������
-- ID ����, ����� ��'� ���� �� ����� ���������� ���������� � ����������� ��� ������ ����.

CREATE VIEW DriverSummary AS
SELECT 
    ID_Driver AS DriverID,
    CONCAT(FirstName, ' ', LastName) AS FullName,
    License_Number AS DriverLicenseNumber
FROM Driver;


-- �������� 14.
-- ��������� ������������� DriverLicenseExpiryWithWarning, ��� ������ ϲ� ����, ����� ����������
-- �� ������� ��� �� ��������� ������ 䳿 ���������� (������������ ��������).

CREATE VIEW DriverLicenseExpiryWithWarning AS
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    License_Number,
    DATEDIFF(DAY, GETDATE(), License_Expiry) AS DaysUntilExpiry
FROM Driver;


-- �������� 15.
-- ��������� ������������� SeriousAccidents, ��� ������ ��� � ������� ������������ ����� 2,
-- � ������ WITH CHECK OPTION.

CREATE VIEW SeriousAccidents AS
SELECT *
FROM Accident
WHERE Victim_Count > 2
WITH CHECK OPTION;

-- ������ �������� ��� � ������ ������� ������������ (<=2) �������� �� �������.
INSERT INTO SeriousAccidents (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES ('2025-05-19', '12:00', '���. ��������', 1, 'ǳ�������', '� ������');


-- �������� 16.
-- ��������� ������������� �������������, ��� ������ ���������� ��� ���������.

CREATE VIEW EncryptedPolicemen
WITH ENCRYPTION
AS
SELECT ID_Policeman, LastName, FirstName, Rank, Department
FROM Policeman;


-- �������� 17.
-- ��������� ������������� RestrictedDriverInfo, ��� ������ ����� ϲ� �� ����� ���������� ����.

CREATE VIEW RestrictedDriverInfo AS
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, License_Number
FROM Driver;

-- ������� ���� ����������� ReadOnlyUser �� SELECT �� ����� �������������
GRANT SELECT ON RestrictedDriverInfo TO ReadOnlyUser;
