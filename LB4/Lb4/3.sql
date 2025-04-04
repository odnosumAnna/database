---- 1. ������ ������� ��� ���������� �.�.�. ����
SELECT 
    dbo.GetDriverFullName(LastName, FirstName, MiddleName) AS FullName,
    License_Number
FROM Driver;

--2. ������ ������� ��� �������� ������������ ���������� ����������
SELECT 
    LastName,
    FirstName,
    License_Number,
    dbo.CheckLicenseStatus(License_Expiry) AS License_Status
FROM Driver;

--3. ������ ������� ��� ������������ ���� �����������
SELECT 
    LastName,
    FirstName,
    Injury_Type,
    dbo.ClassifyInjurySeverity(Severity) AS Severity_Level
FROM Victim;


