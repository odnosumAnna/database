BEGIN TRAN;

-- Вставка нового водія
INSERT INTO Driver (LastName, FirstName, Address, License_Number, License_Expiry)
VALUES ('Bondarenko', 'Oleksii', 'Kharkiv, Main St, 2', 'KH1234567', '2027-12-31');

-- Вставка ДТП (штучна помилка: передчасна кома)
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type)
VALUES ('2025-04-01', '15:30', 'Kharkiv Avenue', 1, 'Collision');

-- Якщо друга операція не вдасться — вся транзакція буде скасована
COMMIT;
