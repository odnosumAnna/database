BEGIN TRAN;

BEGIN TRY
    -- Спроба вставити некоректну дату — викликає помилку
    UPDATE Accident
    SET Date = 'invalid-date'
    WHERE ID_Accident = 1;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;
