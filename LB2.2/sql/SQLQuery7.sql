-- Завдання 4: Використання WHERE
-- Виведення всіх ДТП, у яких постраждало більше двох осіб
SELECT * FROM Accident WHERE Victim_Count > 2;

-- Виведення ДТП, що сталися в зазначеному місці
SELECT * FROM Accident WHERE Location = 'Kyiv';

-- Виведення ДТП певного типу
SELECT * FROM Accident WHERE Accident_Type = 'Collision';

-- Виведення ДТП за конкретною датою
SELECT * FROM Accident WHERE Date = '2025-01-01';

-- Виведення ДТП з відкритим статусом розслідування
SELECT * FROM Accident WHERE Investigation_Status = 'Open';

-- Завдання 5: Використання логічних операторів
-- ДТП з більш ніж двома постраждалими, якщо розслідування ще не закрито
SELECT * FROM Accident WHERE Victim_Count > 2 AND Investigation_Status = 'Open';

-- ДТП, що сталися або в Києві, або у Львові
SELECT * FROM Accident WHERE Location = 'Kyiv' OR Location = 'Lviv';

-- ДТП з фільтрацією за двома умовами
SELECT * FROM Accident WHERE Victim_Count > 1 AND Date > '2025-01-01';

-- ДТП без постраждалих
SELECT * FROM Accident WHERE NOT Victim_Count > 0;

-- ДТП, що сталися у визначений період
SELECT * FROM Accident WHERE Date BETWEEN '2025-01-01' AND '2025-03-01';

-- Завдання 6: Використання LIKE
-- ДТП, що сталися на вулицях, які закінчуються на "Street" або "St"
SELECT * FROM Accident WHERE Location LIKE '% Street' OR Location LIKE '% St';

-- ДТП у районах, що починаються на "North"
SELECT * FROM Accident WHERE Location LIKE 'North%';

-- ДТП, що містять у назві місця слово "Avenue"
SELECT * FROM Accident WHERE Location LIKE '%Avenue%';

-- ДТП з типами, що починаються на "C"
SELECT * FROM Accident WHERE Accident_Type LIKE 'C%';

-- ДТП у певному місті з точністю до літери
SELECT * FROM Accident WHERE Location LIKE '_yiv';

-- Завдання 7: INNER JOIN
-- Виведення всіх ДТП разом з іменами постраждалих
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName 
FROM Accident A
INNER JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- Виведення ДТП та водіїв, що в них брали участь
SELECT A.*, D.LastName AS Driver_LastName, D.FirstName AS Driver_FirstName
FROM Accident A
INNER JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
INNER JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- ДТП та залучені транспортні засоби
SELECT A.*, V.License_Plate, V.Model 
FROM Accident A
INNER JOIN Vehicle V ON A.ID_Accident = V.ID_Accident;

-- ДТП з деталями про міліціонерів, що виїжджали
SELECT A.*, P.LastName AS Policeman_LastName, P.Rank
FROM Accident A
INNER JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- ДТП з даними про пішоходів
SELECT A.*, P.LastName AS Pedestrian_LastName
FROM Accident A
INNER JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- Завдання 8: LEFT JOIN
-- ДТП та можливі жертви (якщо немає — NULL)
SELECT A.*, COALESCE(V.LastName, 'No Victim') AS Victim_LastName 
FROM Accident A
LEFT JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- ДТП та міліціонери, які могли виїжджати
SELECT A.*, COALESCE(P.LastName, 'No Officer') AS Policeman_LastName
FROM Accident A
LEFT JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- ДТП та водії, які могли брати участь
SELECT A.*, COALESCE(D.LastName, 'Unknown') AS Driver_LastName
FROM Accident A
LEFT JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
LEFT JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- ДТП та пішоходи (якщо були)
SELECT A.*, COALESCE(P.LastName, 'No Pedestrian') AS Pedestrian_LastName
FROM Accident A
LEFT JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- ДТП та їх транспортні засоби
SELECT A.*, COALESCE(V.License_Plate, 'No Vehicle') AS License_Plate
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident;

-- Завдання 9: Використання SUBQUERY
-- ДТП, у яких є хоча б один потерпілий із тяжкими травмами
SELECT * FROM Accident 
WHERE EXISTS (
    SELECT 1 FROM Victim WHERE Victim.ID_Accident = Accident.ID_Accident AND Victim.Severity = 'Severe'
);

-- ДТП, де кількість жертв перевищує середнє значення
SELECT * FROM Accident 
WHERE Victim_Count > (SELECT AVG(Victim_Count) FROM Accident);

-- Водії, які брали участь більше ніж в одній ДТП
SELECT * FROM Driver 
WHERE ID_Driver IN (
    SELECT ID_Driver FROM Driver_Involvement GROUP BY ID_Driver HAVING COUNT(*) > 1
);

-- ДТП, які мають більше 2 транспортних засобів
SELECT * FROM Accident 
WHERE ID_Accident IN (
    SELECT ID_Accident FROM Vehicle GROUP BY ID_Accident HAVING COUNT(*) > 2
);

-- ДТП з найбільшою кількістю постраждалих
SELECT * FROM Accident 
WHERE Victim_Count = (SELECT MAX(Victim_Count) FROM Accident);

-- Завдання 10: GROUP BY та HAVING
-- Підрахунок кількості ДТП за типом, якщо більше 1, з урахуванням пішоходів
SELECT A.Accident_Type, COUNT(*) AS Total_Accidents
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
GROUP BY A.Accident_Type
HAVING COUNT(*) > 1;

-- Визначення кількості ДТП за місцем, якщо в них постраждали водії
SELECT A.Location, COUNT(*) AS Accident_Count
FROM Accident A
JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
GROUP BY A.Location
HAVING COUNT(*) > 1;

-- Кількість ДТП, у яких є постраждалі, згруповані за місцем, якщо їх більше 2
SELECT A.Location, COUNT(*) AS Accident_With_Victims
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Victim_Count > 0
GROUP BY A.Location
HAVING COUNT(*) > 2;

-- Визначення кількості ДТП за роками, якщо в них брали участь міліціонери певного звання
SELECT YEAR(A.Date) AS Year, COUNT(*) AS Total_Accidents
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain'
GROUP BY YEAR(A.Date)
HAVING COUNT(*) > 1;

-- Кількість ДТП, де кількість транспортних засобів перевищує 2
SELECT A.ID_Accident, COUNT(V.ID_Vehicle) AS Vehicle_Count
FROM Accident A
JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
GROUP BY A.ID_Accident
HAVING COUNT(V.ID_Vehicle) > 2;

-- Завдання 11: Складні багатотабличні запити

-- 1. Виведення всіх ДТП разом з кількістю залучених транспортних засобів
SELECT 
    A.ID_Accident, A.Date, A.Location, A.Accident_Type, 
    COUNT(V.ID_Vehicle) AS Vehicle_Count
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
GROUP BY A.ID_Accident, A.Date, A.Location, A.Accident_Type;

-- 2. Визначення місця, де сталося найбільше ДТП
SELECT TOP 1 Location, COUNT(*) AS Total_Accidents
FROM Accident
GROUP BY Location
ORDER BY Total_Accidents DESC;

-- 3. Список водіїв, які брали участь у ДТП більше ніж один раз за певний період
SELECT D.ID_Driver, D.LastName, D.FirstName, COUNT(DI.ID_Accident) AS Accident_Count
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY D.ID_Driver, D.LastName, D.FirstName
HAVING COUNT(DI.ID_Accident) > 1;

-- 4. Визначення найбільш небезпечного типу ДТП (з найбільшою середньою кількістю постраждалих)
SELECT TOP 1 Accident_Type, AVG(Victim_Count) AS Avg_Victims
FROM Accident
GROUP BY Accident_Type
ORDER BY Avg_Victims DESC;

-- 5. Виведення ДТП, на які виїжджали міліціонери певного звання
SELECT 
    A.ID_Accident, A.Date, A.Location, A.Accident_Type, 
    P.LastName AS Policeman_LastName, P.Rank
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain';


-- Завдання 12: WHERE у поєднанні з JOIN

-- 1. Виведення всіх відкритих ДТП разом з іменами постраждалих
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Investigation_Status = 'Open';

-- 2. ДТП з вини пішоходів за певний період
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2025-01-01' AND '2025-12-31';

-- 3. ДТП з більш ніж двома постраждалими, якщо розслідування ще не закрито
SELECT * FROM Accident 
WHERE Victim_Count > 2 AND Investigation_Status = 'Open';

-- 4. Визначення кількості ДТП за місцем, якщо їх більше 3
SELECT Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
HAVING COUNT(*) > 3;

-- 5. Водії, які брали участь у ДТП з важкими наслідками
SELECT DISTINCT D.*
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Victim_Count > 3;

