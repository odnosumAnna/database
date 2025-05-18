-- Увімкнути вимір часу виконання
SET STATISTICS TIME ON;
--Вивести повний список ДТП, на які виїжджали міліціонери із зазначеним званням за вказаний період часу, з повними відомостями про ДТП:
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       Po.LastName AS Policeman_LastName, Po.FirstName AS Policeman_FirstName, Po.MiddleName AS Policeman_MiddleName,
       Po.Rank AS Policeman_Rank
FROM Accident A
JOIN Policeman Po ON A.ID_Accident = Po.ID_Accident
WHERE Po.Rank = 'Lieutenant' AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

--Скласти список водіїв, які брали участь більше ніж в одній ДТП за зазначений період часу, з повними відомостями про цих водіїв:
SELECT D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2022-01-01' AND '2024-01-01'
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
HAVING COUNT(DI.ID_Accident) > 1
ORDER BY D.LastName, D.FirstName;

--	Скласти список постраждалих у ДТП за вказаний період часу з повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду.
SELECT 
    v.LastName, v.FirstName, v.MiddleName, v.Address, v.Passport_Number,
    a.Date, a.Time, a.Location, a.Accident_Type, 
    v.Injury_Type,
    COUNT(v.Injury_Type) OVER (PARTITION BY v.Injury_Type) AS Injury_Count, 
    COUNT(v.ID_Victim) OVER (PARTITION BY a.ID_Accident) AS Victim_Count
FROM Victim v
JOIN Accident a ON v.ID_Accident = a.ID_Accident
WHERE a.Date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY Injury_Count DESC, Victim_Count DESC;

-- Вимкнути вимір часу
SET STATISTICS TIME OFF;