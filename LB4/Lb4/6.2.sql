--2. ������ ����, �� ������� ����������� ������� ���:
CREATE FUNCTION dbo.GetMaxAccidentLocation()
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN (
        SELECT TOP 1 Location
        FROM Accident
        GROUP BY Location
        ORDER BY COUNT(ID_Accident) DESC
    );
END;
