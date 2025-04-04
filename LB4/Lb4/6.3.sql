--3. Вивести повний список ДТП, на які виїжджали міліціонери із зазначеним званням за вказаний період часу, з повними відомостями про ДТП:
CREATE FUNCTION dbo.GetAccidentsWithPoliceInvolvement
(
    @StartDate DATE,
    @EndDate DATE,
    @Rank VARCHAR(50)
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
        P.Rank AS PoliceRank
    FROM Accident A
    JOIN Policeman P ON A.ID_Accident = P.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
    AND P.Rank = @Rank
);
