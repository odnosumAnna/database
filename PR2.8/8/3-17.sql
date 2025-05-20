
--3 Представлення для виводу імен водіїв
CREATE VIEW vDriverNames AS
SELECT ID_Driver, FirstName, MiddleName, LastName
FROM Driver;


--4 Вибір імен водіїв з представлення
SELECT FirstName, MiddleName, LastName FROM vDriverNames;


--5 представлення vInjuredDrivers, яке показує усіх постраждалих водіїв (ті, хто є як у таблиці Victim, так і в таблиці Driver_Involvement).
CREATE VIEW vInjuredDrivers AS
SELECT
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    D.Address,
    D.License_Number,
    A.ID_Accident,
    A.Date,
    A.Location,
    V.Injury_Type,
    V.Severity
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE V.Passport_Number IN (
    SELECT Passport_Number FROM Victim
    INTERSECT
    SELECT Passport_Number FROM (
        SELECT Passport_Number, Address
        FROM Driver
    ) AS DriverPassports
);


--6 представлення vDrivers
CREATE VIEW vDrivers AS
SELECT
    ID_Driver,
    LastName,
    FirstName,
    MiddleName,
    Address,
    License_Number
FROM Driver;
--Приклад оновлення даних через представлення:
UPDATE vDrivers
SET Address = '10 Shevchenko St'
WHERE ID_Driver = 1;


--7 Представлення з JOIN для варіанта "ДАІ":
CREATE VIEW DriverAccidents AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    A.ID_Accident,
    A.Date,
    A.Time,
    A.Location,
    A.Accident_Type
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident;


--8 статистика про кількість ДТП, у яких був задіяний кожен водій.
CREATE VIEW DriverAccidentCounts AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    COUNT(DI.ID_Accident) AS AccidentCount
FROM Driver D
LEFT JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName;

SELECT * FROM DriverAccidentCounts;


--10 представлення, яке базується на іншому вже існуючому представленні.

CREATE VIEW DriverAccidentCounts AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    COUNT(DI.ID_Accident) AS AccidentCount
FROM Driver D
LEFT JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName;

CREATE VIEW VIPDrivers AS
SELECT ID_Driver, LastName, FirstName, MiddleName, AccidentCount
FROM DriverAccidentCounts
WHERE AccidentCount > 5;


--11 Зміна представлення (ALTER VIEW):
ALTER VIEW DriverAccidents AS
SELECT 
    D.ID_Driver,
    D.LastName,
    D.FirstName,
    D.MiddleName,
    D.Address,            -- Додано поле адреси водія
    A.ID_Accident,
    A.Date,
    A.Time,
    A.Location,
    A.Accident_Type
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident;


--12  Видалення представлення (DROP VIEW)
DROP VIEW VIPDrivers;


-- Завдання 13.
-- Представлення з псевдонімами стовпців: створюємо представлення DriverSummary, яке показує
-- ID водія, повне ім'я водія та номер водійського посвідчення з псевдонімами для деяких полів.

CREATE VIEW DriverSummary AS
SELECT 
    ID_Driver AS DriverID,
    CONCAT(FirstName, ' ', LastName) AS FullName,
    License_Number AS DriverLicenseNumber
FROM Driver;


-- Завдання 14.
-- Створення представлення DriverLicenseExpiryWithWarning, яке показує ПІБ водія, номер посвідчення
-- та кількість днів до закінчення терміну дії посвідчення (обчислюваний стовпець).

CREATE VIEW DriverLicenseExpiryWithWarning AS
SELECT 
    CONCAT(FirstName, ' ', LastName) AS FullName,
    License_Number,
    DATEDIFF(DAY, GETDATE(), License_Expiry) AS DaysUntilExpiry
FROM Driver;


-- Завдання 15.
-- Створення представлення SeriousAccidents, яке показує ДТП з кількістю постраждалих більше 2,
-- з опцією WITH CHECK OPTION.

CREATE VIEW SeriousAccidents AS
SELECT *
FROM Accident
WHERE Victim_Count > 2
WITH CHECK OPTION;

-- Спроба вставити ДТП з меншою кількістю постраждалих (<=2) призведе до помилки.
INSERT INTO SeriousAccidents (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES ('2025-05-19', '12:00', 'Вул. Шевченка', 1, 'Зіткнення', 'В процесі');


-- Завдання 16.
-- Створення зашифрованого представлення, яке показує інформацію про міліціонерів.

CREATE VIEW EncryptedPolicemen
WITH ENCRYPTION
AS
SELECT ID_Policeman, LastName, FirstName, Rank, Department
FROM Policeman;


-- Завдання 17.
-- Створення представлення RestrictedDriverInfo, яке показує тільки ПІБ та номер посвідчення водія.

CREATE VIEW RestrictedDriverInfo AS
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, License_Number
FROM Driver;

-- Надання прав користувачу ReadOnlyUser на SELECT до цього представлення
GRANT SELECT ON RestrictedDriverInfo TO ReadOnlyUser;
