CREATE OR ALTER PROCEDURE dbo.InsertAccident
    @Date DATE,
    @Time TIME,
    @Location VARCHAR(100),
    @Victim_Count INT,
    @Accident_Type VARCHAR(50),
    @Investigation_Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME2 = SYSDATETIME();
    PRINT 'Procedure InsertAccident started at: ' + CONVERT(VARCHAR, @StartTime, 121);
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
        VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error in InsertAccident: ' + @ErrorMessage;
        THROW;
    END CATCH
    
    DECLARE @EndTime DATETIME2 = SYSDATETIME();
    PRINT 'Procedure InsertAccident ended at: ' + CONVERT(VARCHAR, @EndTime, 121);
    
    DECLARE @Duration INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
    PRINT 'Total execution time: ' + CAST(@Duration AS VARCHAR) + ' ms';
END;