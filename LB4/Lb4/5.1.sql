--1. Multistate функція для класифікації ДТП за кількістю постраждалих:
CREATE FUNCTION dbo.ClassifyAccidentByVictimCount
(
    @VictimCount INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT CASE
            WHEN @VictimCount = 0 THEN 'No Victims'
            WHEN @VictimCount BETWEEN 1 AND 2 THEN 'Minor Accident'
            WHEN @VictimCount BETWEEN 3 AND 5 THEN 'Moderate Accident'
            ELSE 'Severe Accident'
           END AS Severity
)

