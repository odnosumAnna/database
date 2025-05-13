BEGIN TRAN;

-- Додаємо ДТП
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type)
VALUES ('2025-04-10', '10:45', 'Dnipro Central', 2, 'Collision');

-- Отримуємо ID щойно доданої ДТП
DECLARE @AccidentID INT = SCOPE_IDENTITY();

-- Додаємо міліціонера, який виїхав на цю ДТП
INSERT INTO Policeman (ID_Accident, LastName, FirstName, Rank)
VALUES (@AccidentID, 'Shevchenko', 'Oleh', 'Lieutenant');

-- Оновлюємо кількість постраждалих (наприклад, помилково внесли 2, а потрібно 1)
UPDATE Accident
SET Victim_Count = 1
WHERE ID_Accident = @AccidentID;

COMMIT;
