--5. Скласти список постраждалих у ДТП за вказаний період часу з повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду:
CREATE FUNCTION dbo.GetAccidentVictimsByInjuryType
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
        V.FirstName + ' ' + V.LastName AS VictimName,  -- Поєднання імені та прізвища
        V.Injury_Type,  -- Тип травми
        V.Severity  -- Ступінь важкості травми
    FROM Accident A
    JOIN Victim V ON A.ID_Accident = V.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
);
