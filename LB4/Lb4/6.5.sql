--5. ������� ������ ������������ � ��� �� �������� ����� ���� � ������� ���������� ��� �� ���, ����������� �� ������� ����� ������� ����:
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
        V.FirstName + ' ' + V.LastName AS VictimName,  -- �������� ���� �� �������
        V.Injury_Type,  -- ��� ������
        V.Severity  -- ������ ������� ������
    FROM Accident A
    JOIN Victim V ON A.ID_Accident = V.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
);
