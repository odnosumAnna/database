-- Завдання 3: DML тригери (AFTER та INSTEAD OF)

-- AFTER INSERT тригер для таблиці Accident
CREATE TRIGGER tr_Accident_AfterInsert
ON Accident
AFTER INSERT
AS
BEGIN
    PRINT 'AFTER INSERT тригер: Було додано новий запис про ДТП'
    SELECT 'Додано ДТП', i.ID_Accident, i.Date, i.Location 
    FROM inserted i
END;
GO

-- INSTEAD OF INSERT тригер для таблиці Driver
CREATE TRIGGER tr_Driver_InsteadOfInsert
ON Driver
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'INSTEAD OF INSERT тригер: Перевірка даних перед вставкою водія'
    
    -- Перевірка максимальної довжини номеру посвідчення
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(License_Number) > 10)
    BEGIN
        RAISERROR('Номер посвідчення водія не може бути довшим за 10 символів', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Перевірка максимальної довжини ПІБ
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(LastName) > 50 OR LEN(FirstName) > 50 OR LEN(MiddleName) > 50)
    BEGIN
        RAISERROR('Кожен компонент ПІБ не може бути довшим за 50 символів', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Якщо все в порядку, виконуємо вставку
    INSERT INTO Driver (LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone)
    SELECT LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone
    FROM inserted
    
    PRINT 'Дані водія успішно додані'
END;
GO

-- AFTER UPDATE тригер для таблиці Vehicle
CREATE TRIGGER tr_Vehicle_AfterUpdate
ON Vehicle
AFTER UPDATE
AS
BEGIN
    PRINT 'AFTER UPDATE тригер: Було оновлено дані транспортного засобу'
    
    SELECT 'Оновлено транспортний засіб', 
           i.ID_Vehicle AS 'ID до', 
           d.ID_Vehicle AS 'ID після',
           d.License_Plate AS 'Новий номер',
           i.License_Plate AS 'Старий номер'
    FROM inserted i
    JOIN deleted d ON i.ID_Vehicle = d.ID_Vehicle
END;
GO

-- INSTEAD OF DELETE тригер для таблиці Policeman
CREATE TRIGGER tr_Policeman_InsteadOfDelete
ON Policeman
INSTEAD OF DELETE
AS
BEGIN
    PRINT 'INSTEAD OF DELETE тригер: Спроба видалення міліціонера'
    
    -- Перевіряємо, чи не є міліціонер останнім у ДТП
    DECLARE @AccidentID INT
    SELECT @AccidentID = ID_Accident FROM deleted
    
    DECLARE @PolicemanCount INT
    SELECT @PolicemanCount = COUNT(*) FROM Policeman WHERE ID_Accident = @AccidentID
    
    IF @PolicemanCount <= 1
    BEGIN
        RAISERROR('Не можна видалити останнього міліціонера у ДТП', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Якщо не останній, видаляємо
    DELETE FROM Policeman WHERE ID_Policeman IN (SELECT ID_Policeman FROM deleted)
    
    PRINT 'Міліціонера успішно видалено'
END;
GO

