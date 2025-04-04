--2. Multistate ������� ��� ����������, �� � ���� ���������� (��� ��������):
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
