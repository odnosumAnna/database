CREATE PROCEDURE dbo.InsertAccident
(
    @Date DATE,
    @Location VARCHAR(100),
    @Victim_Count INT,
    @Accident_Type VARCHAR(50),
    @Investigation_Status VARCHAR(50) = NULL,  
    @Time DATETIME = NULL                     
)
AS
BEGIN
    -- якщо час не переданий, використовуЇмо поточний час
    IF @Time IS NULL
    BEGIN
        SET @Time = GETDATE();
    END

    -- ¬ставл€Їмо новий запис у таблицю Accident
    INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
    VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);
END;
