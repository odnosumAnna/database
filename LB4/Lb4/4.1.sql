-- �������� 4: Inline ��� �������
-- 1. ������ ������� ��� �������� ������� ���

CREATE FUNCTION CheckAccidentStatus (@accident_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Investigation_Status  
    FROM [DAI].[dbo].[Accident]  
    WHERE ID_Accident = @accident_id  
);

