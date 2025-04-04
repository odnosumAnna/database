-- 1. Власна функція для формування П.І.Б. водія
CREATE FUNCTION dbo.GetDriverFullName
(
    @LastName VARCHAR(50),
    @FirstName VARCHAR(50),
    @MiddleName VARCHAR(50)
)
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN @LastName + ' ' + LEFT(@FirstName, 1) + '.' + LEFT(@MiddleName, 1) + '.'
END;

