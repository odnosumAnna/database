BEGIN TRANSACTION;

-- 1. Додавання нової інформації про ДТП
DECLARE @NewAccidentID INT;

-- Додаємо основні дані про ДТП
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES ('2023-05-15', '14:30:00', 'Central St, 25', 2, 'Two-car collision', 'Under investigation');

-- Отримуємо ID нової ДТП
SET @NewAccidentID = SCOPE_IDENTITY();

-- Додаємо дані про водіїв
INSERT INTO Driver (LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone)
VALUES ('Ivanov', 'Petro', 'Sergiyovych', 'Forest St, 10', 'AB123456', '2025-12-31', '+380501234567');

DECLARE @Driver1ID INT = SCOPE_IDENTITY();

INSERT INTO Driver (LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone)
VALUES ('Petrov', 'Oleksiy', 'Ivanovych', 'Garden St, 5', 'BC654321', '2024-10-15', '+380671234567');

DECLARE @Driver2ID INT = SCOPE_IDENTITY();

-- Додаємо транспортні засоби
INSERT INTO Vehicle (ID_Accident, License_Plate, Model, Year)
VALUES (@NewAccidentID, 'AA1234BC', 'Toyota Camry', 2018);

INSERT INTO Vehicle (ID_Accident, License_Plate, Model, Year)
VALUES (@NewAccidentID, 'BC5678AA', 'Honda Civic', 2020);

-- Додаємо участь водіїв у ДТП
INSERT INTO Driver_Involvement (ID_Accident, ID_Driver, Role, Involvement_Status, Fixation_Time)
VALUES (@NewAccidentID, @Driver1ID, 'Participant', 'Registered', GETDATE());

INSERT INTO Driver_Involvement (ID_Accident, ID_Driver, Role, Involvement_Status, Fixation_Time)
VALUES (@NewAccidentID, @Driver2ID, 'Participant', 'Registered', GETDATE());

-- Додаємо дані про постраждалих
INSERT INTO Victim (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status)
VALUES (@NewAccidentID, 'Ivanov', 'Petro', 'Sergiyovych', 'Forest St, 10', 'KM123456', 'Arm fracture', 'Moderate', 'Hospitalized');

INSERT INTO Victim (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status)
VALUES (@NewAccidentID, 'Sydorenko', 'Maria', 'Olehivna', 'Park St, 15', 'KM654321', 'Brain concussion', 'Severe', 'Hospitalized');

-- Додаємо дані про пішохода (винуватця)
INSERT INTO Pedestrian (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Is_Victim, Phone)
VALUES (@NewAccidentID, 'Kovalenko', 'Andriy', 'Volodymyrovych', 'Shevchenko St, 20', 'KM987654', 0, '+380631234567');

-- Додаємо винуватця ДТП (пішохід)
INSERT INTO Culprit (ID_Related, ID_Accident, Type)
VALUES (SCOPE_IDENTITY(), @NewAccidentID, 'Pedestrian');

-- Додаємо дані про поліцейських
INSERT INTO Policeman (ID_Accident, LastName, FirstName, MiddleName, Rank, Department)
VALUES (@NewAccidentID, 'Boyko', 'Oleh', 'Mykhailovych', 'Senior Lieutenant', 'Kyiv Traffic Police');

INSERT INTO Policeman (ID_Accident, LastName, FirstName, MiddleName, Rank, Department)
VALUES (@NewAccidentID, 'Shevchenko', 'Vitaliy', 'Ihorovych', 'Lieutenant', 'Kyiv Traffic Police');

-- Перевіряємо наявність помилок
IF @@ERROR = 0
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully. New accident data added to database.';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Error occurred during transaction. All changes have been rolled back.';
END;