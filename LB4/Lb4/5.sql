--1. Multistate ������� ��� ������������ ��� �� ������� ������������:
SELECT 
    ID_Accident, 
    Severity
FROM Accident
CROSS APPLY dbo.ClassifyAccidentByVictimCount(Victim_Count);

--2. Multistate ������� ��� ����������, �� � ���� ���������� (��� ��������):
SELECT 
    Driver.LastName,
    Driver.FirstName,
    CulpritType
FROM Driver
JOIN Culprit ON Driver.ID_Driver = Culprit.ID_Related
CROSS APPLY dbo.IsCulprit(ID_Culprit);

--3. Multistate ������� ��� ���������� ������� �������� ������ �������������:
SELECT 
    v.Injury_Type,
    v.Hospitalization_Status
FROM Victim v
CROSS APPLY dbo.GetInjuryDate(v.Injury_Type) AS g;


