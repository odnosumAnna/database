BEGIN TRAN;

-- Додати нову ДТП
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES ('2025-05-13', '17:30:00', 'Highway 12', 2, 'Collision', 'Under Investigation');

-- Отримати ID нової ДТП
DECLARE @NewAccidentID INT = SCOPE_IDENTITY();

-- Додати постраждалих
INSERT INTO Victim (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status)
VALUES 
(@NewAccidentID, 'Shevchenko', 'Oleh', 'Ivanovych', 'Kyiv, Peremohy Ave, 15', 'AB1234567', 'Leg injury', 'Moderate', 'Hospitalized'),
(@NewAccidentID, 'Bondar', 'Maria', 'Oleksiivna', 'Lviv, Shevchenka St, 42', 'CD7654321', 'Head trauma', 'Severe', 'Hospitalized');

-- Оновити кількість постраждалих у таблиці Accident
UPDATE Accident
SET Victim_Count = (SELECT COUNT(*) FROM Victim WHERE ID_Accident = @NewAccidentID)
WHERE ID_Accident = @NewAccidentID;

COMMIT;
