--3. Multistate ������� ��� ���������� ������� �������� ������ �������������:
CREATE FUNCTION dbo.GetInjuryDate
(
    @InjuryType VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT Hospitalization_Status
    FROM Victim
    WHERE Injury_Type = @InjuryType
    AND Severity = (SELECT MAX(Severity) FROM Victim WHERE Injury_Type = @InjuryType)
)

