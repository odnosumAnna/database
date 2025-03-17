-- ������� ������ ������ ���, �� ������� � ���� �������, �� �������� �����
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE A.Date BETWEEN '2025-01-01' AND '2025-12-31';

-- ������ ����, �� ������� ����������� ������� ���
SELECT TOP 1 Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
ORDER BY Accident_Count DESC;

-- ������� ������ ������ ���, �� �� �������� ��������� �� ���������� ������� �� �������� ����� ����
SELECT A.*, P.LastName, P.FirstName, P.Rank
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain' AND A.Date BETWEEN '2025-01-01' AND '2025-12-31';

-- ������� ������ ��䳿�, �� ����� ������ ����� �� � ���� ��� �� ���������� ����� ����
SELECT D.*, COUNT(DI.ID_Accident) AS Accident_Count
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
HAVING COUNT(DI.ID_Accident) > 1;

-- ������� ������ ������������ � ��� �� �������� ����� ���� � ������� ���������� ��� �� ���, ����������� �� ������� ����� ������� ����
SELECT V.LastName, V.FirstName, V.MiddleName, V.Address, V.Passport_Number, V.Injury_Type, V.Severity, V.Hospitalization_Status, A.Date, A.Time, A.Location, A.Accident_Type, COUNT(V.Injury_Type) AS Injury_Count
FROM Victim V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY V.LastName, V.FirstName, V.MiddleName, V.Address, V.Passport_Number, V.Injury_Type, V.Severity, V.Hospitalization_Status, A.Date, A.Time, A.Location, A.Accident_Type
ORDER BY Injury_Count DESC;

-- ������ ������� ��� ���� ���
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES ('2025-03-08', '14:00:00', 'New Avenue, 25', 3, 'Collision', 'Open');


