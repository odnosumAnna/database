-- 1. Вивести всі ДТП, відсортовані за датою у зворотньому порядку (від найновіших до найстаріших)
SELECT * 
FROM Accident
ORDER BY Date DESC;

-- 2. Вивести всі ДТП, відсортовані за кількістю постраждалих у зростаючому порядку
SELECT * 
FROM Accident
ORDER BY Victim_Count ASC;

-- 3. Вивести список водіїв, які брали участь у ДТП, відсортованих за прізвищем
SELECT D.LastName, D.FirstName, D.MiddleName, A.Date, A.Location
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
ORDER BY D.LastName;

-- 4. Вивести список всіх постраждалих у ДТП, відсортованих за тяжкістю травми (від важких до легких)
SELECT V.LastName, V.FirstName, V.Injury_Type, V.Severity, A.Date, A.Location
FROM Victim V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
ORDER BY V.Severity DESC;

-- 5. Вивести місце, де сталося максимальне число ДТП (відсортоване за кількістю випадків)
SELECT Location, COUNT(*) AS AccidentCount
FROM Accident
GROUP BY Location
ORDER BY AccidentCount DESC;

-- 6. Вивести список транспортних засобів, відсортованих за моделлю
SELECT V.License_Plate, V.Model, V.Year, A.Date
FROM Vehicle V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
ORDER BY V.Model;

-- 7. Вивести список водіїв, які брали участь більше ніж в одній ДТП, за період з 2022 року, відсортованих за кількістю ДТП
SELECT D.LastName, D.FirstName, COUNT(DI.ID_Accident) AS AccidentCount
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
WHERE DI.Fixation_Time >= '2022-01-01'
GROUP BY D.LastName, D.FirstName
HAVING COUNT(DI.ID_Accident) > 1
ORDER BY AccidentCount DESC;

-- 8. Вивести всі ДТП, де брали участь пішоходи, відсортовані за типом ДТП
SELECT A.Date, A.Location, A.Accident_Type, P.LastName, P.FirstName, P.Is_Victim
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
ORDER BY A.Accident_Type;

-- 9. Вивести інформацію про міліціонерів, які виїжджали на ДТП з певним званням, відсортованих за прізвищем
SELECT M.LastName, M.FirstName, M.Rank, A.Date, A.Location
FROM Policeman M
JOIN Accident A ON M.ID_Accident = A.ID_Accident
WHERE M.Rank = 'Captain'
ORDER BY M.LastName;

-- 10. Вивести список всіх ДТП, де була максимальна кількість постраждалих, відсортованих за місцем
SELECT A.Date, A.Location, A.Victim_Count, A.Accident_Type
FROM Accident A
WHERE A.Victim_Count = (SELECT MAX(Victim_Count) FROM Accident)
ORDER BY A.Location;
