--2. Multistate функція для визначення, чи є водій винуватцем (або пішоходом):
CREATE FUNCTION dbo.IsCulprit
(
    @ID_Culprit INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT CASE
            WHEN Type = 'Driver' THEN 'Driver'
            WHEN Type = 'Pedestrian' THEN 'Pedestrian'
            ELSE 'Unknown'
           END AS CulpritType
    FROM Culprit
    WHERE ID_Culprit = @ID_Culprit
)
