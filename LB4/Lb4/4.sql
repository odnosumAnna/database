--�������� 4: Inline ��� �������
--1. ������ ������� ��� �������� ������� ���:

SELECT 
    ID_Accident, 
    Accident.Investigation_Status AS Accident_Status
FROM [DAI].[dbo].[Accident]
CROSS APPLY dbo.CheckAccidentStatus(ID_Accident);


--2. ������ ������� ��� ��������� ���� ��������� �� �������:
SELECT 
    Policeman.ID_Policeman, 
    Policeman.Rank, 
    Policeman.LastName, 
    Policeman.FirstName,
    Name.PolicemanName
FROM Policeman
CROSS APPLY dbo.GetPolicemanName(Policeman.Rank, Policeman.LastName, Policeman.FirstName) AS Name;


--3. ������ ������� ��� ��������, �� � ���� � ������ ������������:
SELECT 
    Driver.LastName,
    Driver.FirstName,
    DriverVictim.IsVictim
FROM Driver
JOIN Driver_Involvement ON Driver.ID_Driver = Driver_Involvement.ID_Driver
CROSS APPLY dbo.IsDriverVictim(Driver.ID_Driver, Driver_Involvement.ID_Accident) AS DriverVictim
WHERE Driver_Involvement.ID_Accident = 1;

