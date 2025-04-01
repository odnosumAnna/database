--�������� 5: ������ � ������������� �������� �������
--����� 1: ������������ ���� ��䳿� � ������ ������
SELECT ID_Driver, FirstName, LastName, 
       UPPER(FirstName) AS UpperFirstName, 
       UPPER(LastName) AS UpperLastName
FROM Driver;

--����� 2: ����������� ��� �� ������ ���������� ����������
SELECT ID_Driver, License_Number, 
       LEFT(License_Number, 2) AS LicenseSeries, 
       RIGHT(License_Number, 6) AS LicenseNumber
FROM Driver;
--����� 3: ��������� ������ � ������ ���������
SELECT ID_Vehicle, License_Plate, 
       TRIM(License_Plate) AS TrimmedLicensePlate
FROM Vehicle;
