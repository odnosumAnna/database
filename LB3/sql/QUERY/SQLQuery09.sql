-- Кількість ДТП за типами з фільтрацією 
SELECT a.Accident_Type, COUNT(*) AS Total_Accidents
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
GROUP BY a.Accident_Type
HAVING COUNT(*) > 2;

-- Кількість транспортних засобів, які брали участь у ДТП, за роками випуску
SELECT v.Year, COUNT(v.ID_Accident) AS Vehicle_Count
FROM Vehicle v
JOIN Accident a ON v.ID_Accident = a.ID_Accident
GROUP BY v.Year
HAVING COUNT(v.ID_Accident) > 1;

-- Середня кількість постраждалих у ДТП по вулицях 
SELECT a.Location, AVG(a.Victim_Count) AS Avg_Victims
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
GROUP BY a.Location
HAVING AVG(a.Victim_Count) > 1;

-- Кількість ДТП, розслідуваних міліціонерами певного звання
SELECT p.Rank, COUNT(DISTINCT a.ID_Accident) AS Total_Cases
FROM Policeman p
JOIN Accident a ON p.ID_Accident = a.ID_Accident
GROUP BY p.Rank
HAVING COUNT(DISTINCT a.ID_Accident) > 2;

-- Список водіїв із кількістю ДТП, у яких вони брали участь, з обмеженням
SELECT d.LastName, d.FirstName, COUNT(di.ID_Accident) AS Accident_Count
FROM Driver d
JOIN Driver_Involvement di ON d.ID_Driver = di.ID_Driver
JOIN Accident a ON di.ID_Accident = a.ID_Accident
GROUP BY d.LastName, d.FirstName
HAVING COUNT(di.ID_Accident) > 1;
