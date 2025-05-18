
-- Приклади обмежень цілісності за областю дії в одному коді

-- 1) Обмеження домена (Domain constraint)
-- Приклад: Тип ДТП повинен бути не порожнім і довжина не більше 50 символів
ALTER TABLE Accident
ADD CONSTRAINT CHK_Accident_Type_Length
CHECK (Accident_Type IS NOT NULL AND LEN(Accident_Type) <= 50);

-- 2) Обмеження атрибута (Attribute constraint)
-- Приклад: Максимальна довжина державного номера транспортного засобу - 10 символів (вже в таблиці Vehicle)
-- Для демонстрації додамо CHECK на формат номера: номер повинен містити тільки великі літери та цифри (наприклад)
ALTER TABLE Vehicle
ADD CONSTRAINT CHK_License_Plate_Format
CHECK (License_Plate NOT LIKE '%[^A-Z0-9]%');

-- 3) Обмеження кортежу (Tuple constraint)
-- Приклад: Один водій може керувати лише одним транспортним засобом в одній ДТП
-- Реалізуємо через унікальний індекс на пару (ID_Accident, ID_Driver) у таблиці Driver_Involvement (вже є PRIMARY KEY)
-- Щоб продемонструвати, створимо унікальний індекс на ID_Driver у межах однієї ДТП
-- Але він уже реалізований як PRIMARY KEY, тому приклад: додамо перевірку, що роль водія не може бути одночасно і "Driver" і "Pedestrian" в одному ДТП

ALTER TABLE Driver_Involvement
ADD CONSTRAINT CHK_Role_Valid CHECK (Role IN ('Driver', 'Pedestrian'));

-- 4) Обмеження відношення (Relation constraint)
-- Приклад: Кожне ДТП повинно мати хоча б одного міліціонера (взаємозв’язок)
-- Перевірити через тригер або перевірку наявності записів. SQL Server не підтримує FOREIGN KEY з мінімальною кількістю 1, тому приклад з тригером:

CREATE TRIGGER trg_CheckPolicemanForAccident
ON Policeman
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Перевірка, чи всі ДТП мають хоча б одного міліціонера
    IF EXISTS (
        SELECT ID_Accident
        FROM Accident A
        WHERE NOT EXISTS (SELECT 1 FROM Policeman P WHERE P.ID_Accident = A.ID_Accident)
    )
    BEGIN
        RAISERROR('Кожне ДТП повинно мати хоча б одного міліціонера', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- 5) Обмеження бази даних (Database constraint)
-- Приклад: Дата ДТП не може бути в майбутньому
ALTER TABLE Accident
ADD CONSTRAINT CHK_Date_NotFuture
CHECK (Date <= CAST(GETDATE() AS DATE));


