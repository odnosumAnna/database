-- Запит 1: Інформація про ДТП, транспортні засоби та водіїв
SELECT A.ID_Accident, A.Date, A.Location, V.License_Plate, V.Model, D.LastName AS Driver_LastName, D.FirstName AS Driver_FirstName, DI.Role AS Driver_Role 
FROM Accident A 
JOIN Vehicle V ON A.ID_Accident = V.ID_Accident 
JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident 
JOIN Driver D ON DI.ID_Driver = D.ID_Driver 
ORDER BY A.Date;

-- Запит 2: Інформація про постраждалих у ДТП та пішоходів
SELECT V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName, V.Injury_Type, V.Severity, P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.Is_Victim 
FROM Victim V 
LEFT JOIN Pedestrian P ON V.ID_Accident = P.ID_Accident 
ORDER BY V.LastName;

-- Запит 3: Інформація про міліціонерів на ДТП, де постраждалих більше 2
SELECT P.LastName AS Policeman_LastName, P.FirstName AS Policeman_FirstName, P.Rank, A.Date, A.Location, A.Victim_Count 
FROM Policeman P 
JOIN Accident A ON P.ID_Accident = A.ID_Accident 
WHERE A.Victim_Count > 2 
ORDER BY A.Date DESC;
