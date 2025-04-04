-- 1. ������� ������ ������ ���, �� ������� � ���� ������� �� �������� ����� � ������� ���������� ��� ���:
SELECT * 
FROM dbo.GetAccidentsByPedestrians('2020-01-01', '2025-04-01');

-- 2. ������ ����, �� ������� ����������� ������� ���:
SELECT dbo.GetMaxAccidentLocation() AS MaxAccidentLocation;

-- 3. ������� ������ ������ ���, �� �� �������� ��������� �� ���������� ������� �� �������� ����� ����, � ������� ���������� ��� ���:
SELECT * 
FROM dbo.GetAccidentsWithPoliceInvolvement('2020-01-01', '2025-04-01', 'Captain');

-- 4. ������� ������ ��䳿�, �� ����� ������ ����� �� � ���� ��� �� ���������� ����� ���� � ������� ���������� ��� ��� ��䳿�:
SELECT * 
FROM dbo.GetDriversWithMultipleAccidents('2020-01-01', '2025-04-01');

-- 5. ������� ������ ������������ � ��� �� �������� ����� ���� � ������� ���������� ��� �� ���, ����������� �� ������� ����� ������� ����:
SELECT * 
FROM dbo.GetAccidentVictimsByInjuryType('2020-01-01', '2025-04-01')
ORDER BY Injury_Type, Severity DESC;



