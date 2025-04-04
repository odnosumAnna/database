--2. Власна функція для виведення імені міліціонера за званням:
CREATE FUNCTION dbo.GetPolicemanName (@Rank VARCHAR(30), @LastName VARCHAR(50), @FirstName VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT @Rank + ' ' + @LastName + ' ' + LEFT(@FirstName, 1) + '.' AS PolicemanName
);