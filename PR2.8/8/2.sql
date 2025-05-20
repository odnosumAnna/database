--Вивести повний список ДТП, які виникли з вини пішоходів за вказаний період із повними відомостями.:
CREATE VIEW Pedestrian_Caused_Accidents AS
SELECT 
    A.ID_Accident,
    A.Date,
    A.Time,
    A.Location,
    A.Accident_Type,
    A.Victim_Count,
    P.LastName AS Pedestrian_LastName,
    P.FirstName AS Pedestrian_FirstName,
    P.MiddleName AS Pedestrian_MiddleName,
    P.Address AS Pedestrian_Address,
    P.Passport_Number AS Pedestrian_Passport,
    C.ID_Culprit
FROM 
    Accident A
JOIN 
    Culprit C ON A.ID_Accident = C.ID_Accident AND C.Type = 'Pedestrian'
JOIN 
    Pedestrian P ON C.ID_Related = P.ID_Pedestrian


	SELECT *
FROM Pedestrian_Caused_Accidents
WHERE Date BETWEEN '2024-01-01' AND '2024-12-31'
