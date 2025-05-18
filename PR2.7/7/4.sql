-- Завдання 4: Декларативна підтримка обмежень цілісності
-- Таблиці вже містять наступні декларативні обмеження:
-- PRIMARY KEY, FOREIGN KEY, CHECK, NOT NULL

-- Додаткові декларативні приклади:

-- Обмеження унікальності номера паспорта постраждалого
ALTER TABLE Victim
ADD CONSTRAINT UQ_Victim_Passport UNIQUE (Passport_Number);

-- Обмеження унікальності номера паспорта пішохода
ALTER TABLE Pedestrian
ADD CONSTRAINT UQ_Pedestrian_Passport UNIQUE (Passport_Number);

-- Обмеження NOT NULL для Injury_Type
ALTER TABLE Victim
ALTER COLUMN Injury_Type VARCHAR(100) NOT NULL;

-- Обмеження на тип винуватця
ALTER TABLE Culprit
ADD CONSTRAINT CHK_Culprit_Type CHECK (Type IN ('Driver', 'Pedestrian'));