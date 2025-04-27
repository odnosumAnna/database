-- Створення індексу на колонці Date в таблиці Accident
CREATE NONCLUSTERED INDEX IX_Accident_Date ON Accident (Date);

-- Створення індексу на колонці ID_Accident в таблиці Pedestrian
CREATE NONCLUSTERED INDEX IX_Pedestrian_Accident ON Pedestrian (ID_Accident);

SET STATISTICS TIME ON;

-- Запит після створення індексів
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.MiddleName AS Pedestrian_MiddleName,
       P.Address AS Pedestrian_Address, P.Passport_Number AS Pedestrian_Passport
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

SET STATISTICS TIME OFF;
