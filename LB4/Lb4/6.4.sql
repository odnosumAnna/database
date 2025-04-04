--4. Скласти список водіїв, які брали участь більше ніж в одній ДТП за зазначений період часу з повними відомостями про цих водіїв:
CREATE FUNCTION dbo.GetDriversWithMultipleAccidents
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        D.LastName,
        D.FirstName,
        COUNT(DISTINCT DI.ID_Accident) AS AccidentCount
    FROM Driver D
    JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
    JOIN Accident A ON DI.ID_Accident = A.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
    GROUP BY D.LastName, D.FirstName
    HAVING COUNT(DISTINCT DI.ID_Accident) > 1
);
