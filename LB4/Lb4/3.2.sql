
--2. ������ ������� ��� �������� ������������ ���������� ����������
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

