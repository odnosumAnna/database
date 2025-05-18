-- Якщо constraint існує — видаляємо, щоб не було конфліктів
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'fk_victim_accident')
BEGIN
    ALTER TABLE Victim DROP CONSTRAINT fk_victim_accident;
END

-- Додаємо FK з негайною перевіркою (імовірно це "IMMEDIATE" в умові)
ALTER TABLE Victim
WITH CHECK
ADD CONSTRAINT fk_victim_accident FOREIGN KEY (ID_Accident) REFERENCES Accident(ID_Accident);

-- Тепер імітуємо "DEFERRED" — відключаємо перевірку FK перед вставками
ALTER TABLE Victim NOCHECK CONSTRAINT fk_victim_accident;

BEGIN TRANSACTION;

-- Вставляємо дані без негайної перевірки FK
INSERT INTO Victim 
    (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status) 
VALUES 
    (21632, 'White', 'Charles', 'Q', '641 Oak Blvd', 'AB8209996', 'Burns', 'Severe', 'Outpatient');

-- Після всіх вставок примусово увімкнути і перевірити FK
ALTER TABLE Victim WITH CHECK CHECK CONSTRAINT fk_victim_accident;

COMMIT;


-- SET CONSTRAINTS ALL IMMEDIATE; --  не підтримується в SQL Server
-- SET CONSTRAINTS ALL DEFERRED;  --  не підтримується в SQL Server
