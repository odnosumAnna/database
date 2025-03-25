-- 1. Вивід ДТП з вини пішоходів за період
DECLARE @StartDate DATE = '2024-01-01', @EndDate DATE = '2025-12-31';
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate

-- 2. Знайти місце з максимальною кількістю ДТП
SELECT TOP 1 Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
ORDER BY COUNT(*) DESC;

-- 3. Вивід ДТП, на які виїжджали міліціонери певного звання за період
DECLARE @Rank VARCHAR(30) = 'Captain';
SELECT A.*
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = @Rank
AND A.Date BETWEEN @StartDate AND @EndDate;

-- 4. Список водіїв, які брали участь більше ніж в одній ДТП за період
SELECT D.*
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
HAVING COUNT(DI.ID_Accident) > 1;

-- 5. Список постраждалих у ДТП за період, впорядкований за кількістю травм
SELECT V.*, A.*
FROM Victim V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate
ORDER BY V.Severity DESC;

-- 6. Додавання нової ДТП
DECLARE @Date DATE = '2025-01-01', @Time TIME = '12:00', @Location VARCHAR(100) = 'Main St', @Victim_Count INT = 2, @Accident_Type VARCHAR(50) = 'Collision', @Investigation_Status VARCHAR(20) = 'Open';
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);

-- 7. Видалення ДТП, які сталися раніше вказаної дати
DECLARE @DeleteDate DATE = '2023-01-01';
DELETE FROM Accident
WHERE Date < @DeleteDate;
