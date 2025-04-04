
-- 3. ������ ������� ��� ������������ ���� �����������
CREATE FUNCTION dbo.ClassifyInjurySeverity
(
    @Severity VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Result VARCHAR(20);

	-- ������������ Severity �� ������ ������ ��� ���������
    SET @Severity = UPPER(@Severity);

    SET @Result = 
        CASE 
            WHEN @Severity IN ('Mild', 'Light') THEN 'Mild'
            WHEN @Severity IN ('Moderate', 'Medium') THEN 'Moderate'
            WHEN @Severity IN ('Severe', 'Critical', 'Heavy') THEN 'Severe'
            ELSE 'Unknown'
        END;
    RETURN @Result;
END;


