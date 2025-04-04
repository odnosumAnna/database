-- 3. ������ ������� ��� ��������, �� � ���� � ������ ������������ (inline ���)
CREATE FUNCTION dbo.IsDriverVictim (@DriverID INT, @AccidentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM Victim 
                    WHERE ID_Accident = @AccidentID AND ID_Victim = @DriverID
                ) 
                THEN 1 
                ELSE 0 
            END AS IsVictim
);
