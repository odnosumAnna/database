
--2. Власна функція для перевірки прострочення водійського посвідчення
CREATE FUNCTION dbo.CheckLicenseStatus
(
    @ExpiryDate DATE
)
RETURNS VARCHAR(20)
AS
BEGIN
    IF @ExpiryDate < GETDATE()
        RETURN 'Expired';
    RETURN 'True';
END;

