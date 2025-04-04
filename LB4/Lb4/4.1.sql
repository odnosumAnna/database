-- Завдання 4: Inline тип функцій
-- 1. Власна функція для перевірки статусу ДТП

CREATE FUNCTION CheckAccidentStatus (@accident_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Investigation_Status  
    FROM [DAI].[dbo].[Accident]  
    WHERE ID_Accident = @accident_id  
);

