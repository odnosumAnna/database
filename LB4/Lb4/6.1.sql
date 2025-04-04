--1. Вивести повний список ДТП, які виникли з вини пішоходів за вказаний період з повними відомостями про них:
CREATE FUNCTION dbo.GetAccidentsByPedestrians
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        A.ID_Accident,
        A.Date,
        A.Location,
        A.Victim_Count,
        A.Accident_Type,
        C.Type AS CulpritType
    FROM Accident A
    JOIN Culprit C ON A.ID_Accident = C.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
    AND C.Type = 'Pedestrian'
);
