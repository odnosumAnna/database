-- 1. ���� ��� � ���� ������� �� �����
DECLARE @StartDate DATE = '2024-01-01', @EndDate DATE = '2025-12-31';
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate

-- 2. ������ ���� � ������������ ������� ���
SELECT TOP 1 Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
ORDER BY COUNT(*) DESC;

-- 3. ���� ���, �� �� �������� ��������� ������� ������ �� �����
DECLARE @Rank VARCHAR(30) = 'Captain';
SELECT A.*
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = @Rank
AND A.Date BETWEEN @StartDate AND @EndDate;

-- 4. ������ ��䳿�, �� ����� ������ ����� �� � ���� ��� �� �����
SELECT D.*
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
HAVING COUNT(DI.ID_Accident) > 1;

-- 5. ������ ������������ � ��� �� �����, ������������� �� ������� �����
SELECT V.*, A.*
FROM Victim V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate
ORDER BY V.Severity DESC;

-- 6. ��������� ���� ���
DECLARE @Date DATE = '2025-01-01', @Time TIME = '12:00', @Location VARCHAR(100) = 'Main St', @Victim_Count INT = 2, @Accident_Type VARCHAR(50) = 'Collision', @Investigation_Status VARCHAR(20) = 'Open';
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);

-- 7. ��������� ���, �� ������� ����� ������� ����
DECLARE @DeleteDate DATE = '2023-01-01';
DELETE FROM Accident
WHERE Date < @DeleteDate;
