-- Процедура для вставки аварії з транзакцією
CREATE PROCEDURE InsertAccidentWithTransaction
    @Location NVARCHAR(100),
    @Date DATETIME,
    @Time TIME,
    @Victim_Count INT,
    @Accident_Type NVARCHAR(50),
    @Investigation_Status NVARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;  -- Починаємо транзакцію

    BEGIN TRY
        -- Вставка нового запису в таблицю Accident
        INSERT INTO dbo.Accident (Location, Date, Time, Victim_Count, Accident_Type, Investigation_Status)
        VALUES (@Location, @Date, @Time, @Victim_Count, @Accident_Type, @Investigation_Status);

        COMMIT TRANSACTION;  -- Підтверджуємо зміни
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;  -- У разі помилки скасовуємо зміни
        PRINT 'Помилка вставки аварії: ' + ERROR_MESSAGE();  -- Виводимо повідомлення про помилку
    END CATCH
END;
GO
