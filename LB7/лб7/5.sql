
-- �������� 5: LOGON ������

CREATE TRIGGER tr_Logon_Audit
ON ALL SERVER
FOR LOGON
AS
BEGIN
    DECLARE @LoginTime DATETIME = GETDATE();
    DECLARE @LoginName NVARCHAR(100) = ORIGINAL_LOGIN();

    BEGIN TRY
        INSERT INTO DAI_Database.dbo.AuditLog (EventType, LoginName, EventTime, Description)
        VALUES ('LOGON', @LoginName, @LoginTime, '������� ���� � �������');
    END TRY
    BEGIN CATCH
        
    END CATCH
END;
GO

-- �������� ������� ��� ������������

-- ������ ��� �������� ������� ������������ � ���
IF OBJECT_ID('tr_Accident_VictimCount', 'TR') IS NOT NULL
    DROP TRIGGER tr_Accident_VictimCount;
GO

CREATE TRIGGER tr_Accident_VictimCount
ON Victim
AFTER INSERT, DELETE
AS
BEGIN
    UPDATE a
    SET Victim_Count = (
        SELECT COUNT(*) 
        FROM Victim v 
        WHERE v.ID_Accident = a.ID_Accident
    )
    FROM Accident a
    WHERE a.ID_Accident IN (SELECT ID_Accident FROM inserted UNION SELECT ID_Accident FROM deleted)
END;
GO

-- ������ ��� �������� ���������� ������ ��������� ��䳿�
IF OBJECT_ID('tr_Driver_LicenseUnique', 'TR') IS NOT NULL
    DROP TRIGGER tr_Driver_LicenseUnique;
GO

CREATE TRIGGER tr_Driver_LicenseUnique
ON Driver
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT License_Number 
        FROM Driver 
        GROUP BY License_Number 
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('����� ���������� ���� ������� ���� ���������', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO