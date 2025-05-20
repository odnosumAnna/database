--1. Тригер для перевірки унікальності номерного знака транспортного засобу
CREATE TRIGGER tr_Vehicle_LicensePlateUnique
ON Vehicle
INSTEAD OF INSERT
AS
BEGIN
    -- Перевірка на наявність дублікатів номерних знаків
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        JOIN Vehicle v ON i.License_Plate = v.License_Plate
    )
    BEGIN
        RAISERROR('Транспортний засіб з таким номерним знаком вже існує', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Перевірка максимальної довжини номерного знака
    IF EXISTS (SELECT 1 FROM inserted WHERE LEN(License_Plate) > 10)
    BEGIN
        RAISERROR('Номерний знак не може бути довшим за 10 символів', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Якщо все в порядку, виконуємо вставку
    INSERT INTO Vehicle (ID_Accident, License_Plate, Model, Year)
    SELECT ID_Accident, License_Plate, Model, Year
    FROM inserted
    
    PRINT 'Транспортний засіб успішно додано'
END;
GO

--2. Тригер для перевірки телефону водія
CREATE TRIGGER tr_Driver_PhoneCheck
ON Driver
AFTER INSERT, UPDATE
AS
BEGIN
    -- Перевірка довжини телефону (мінімум 10 цифр)
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE Phone IS NOT NULL AND LEN(REPLACE(REPLACE(REPLACE(REPLACE(Phone, ' ', ''), '-', ''), '(', ''), ')', '')) < 10
    )
    BEGIN
        RAISERROR('Номер телефону повинен містити щонайменше 10 цифр', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO

--3. Тригер для перевірки наявності міліціонера для ДТП
CREATE TRIGGER tr_Accident_PolicemanCheck
ON Accident
AFTER INSERT, UPDATE
AS
BEGIN
    -- Перевірка, чи для кожного нового ДТП є хоча б один міліціонер
    IF EXISTS (
        SELECT i.ID_Accident
        FROM inserted i
        LEFT JOIN Policeman p ON i.ID_Accident = p.ID_Accident
        WHERE p.ID_Policeman IS NULL
    )
    BEGIN
        RAISERROR('Кожне ДТП повинно мати хоча б одного призначеного міліціонера', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO

--4. Тригер для перевірки унікальності номерів паспортів
CREATE TRIGGER tr_Person_PassportUnique
ON Victim
AFTER INSERT, UPDATE
AS
BEGIN
    -- Перевірка унікальності номерів паспортів серед постраждалих
    IF EXISTS (
        SELECT Passport_Number
        FROM Victim
        WHERE Passport_Number IN (SELECT Passport_Number FROM inserted)
        GROUP BY Passport_Number
        HAVING COUNT(*) > 1
    )
    BEGIN
        RAISERROR('Номер паспорта повинен бути унікальним серед постраждалих', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    -- Перевірка унікальності номерів паспортів серед пішоходів
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Pedestrian p ON i.Passport_Number = p.Passport_Number
    )
    BEGIN
        RAISERROR('Цей номер паспорта вже використовується пішоходом', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
GO
