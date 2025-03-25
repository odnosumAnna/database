-- Видалення таблиць, якщо вони існують
DROP TABLE IF EXISTS DTB;
DROP TABLE IF EXISTS Avtomobili;
DROP TABLE IF EXISTS Vodii;

-- Створення таблиці "Водії"
CREATE TABLE Vodii (
    id INT IDENTITY(1,1) PRIMARY KEY,  
    prizvyshche VARCHAR(50) NOT NULL,
    imya VARCHAR(50) NOT NULL,
    pobatkovi VARCHAR(50),
    nomer_vodiy_sk VARCHAR(20) UNIQUE NOT NULL
);

-- Створення таблиці "Автомобілі"
CREATE TABLE Avtomobili (
    id INT IDENTITY(1,1) PRIMARY KEY,  
    nomer VARCHAR(10) UNIQUE NOT NULL,
    marka VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    rik_vypusku INT NOT NULL,
    id_vodiya INT NOT NULL,
    FOREIGN KEY (id_vodiya) REFERENCES Vodii(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Створення таблиці "ДТП"
CREATE TABLE DTB (
    id INT IDENTITY(1,1) PRIMARY KEY,  
    data_dtp DATE NOT NULL,
    mistse VARCHAR(100) NOT NULL,
    prychyna TEXT,
    id_avtomobilya INT NOT NULL,
    FOREIGN KEY (id_avtomobilya) REFERENCES Avtomobili(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Додавання тестових даних
INSERT INTO Vodii (prizvyshche, imya, pobatkovi, nomer_vodiy_sk) 
VALUES 
('Ivanenko', 'Petro', 'Serhiyovych', 'AB123456'),
('Petrenko', 'Oksana', 'Mykhailivna', 'CD234567'),
('Kovalenko', 'Serhiy', 'Igorovych', 'EF345678');

INSERT INTO Avtomobili (nomer, marka, model, rik_vypusku, id_vodiya) 
VALUES 
('AA1111BB', 'Toyota', 'Camry', 2018, 1),
('BB2222CC', 'BMW', 'X5', 2020, 2),
('CC3333DD', 'Audi', 'A6', 2021, 3);

INSERT INTO DTB (data_dtp, mistse, prychyna, id_avtomobilya) 
VALUES 
('2024-03-01', 'Shevchenko St., 10', 'Speeding', 1),
('2024-03-02', 'Khreshchatyk St., 15', 'Drunk driving', 2),
('2024-03-03', 'Haharina Ave., 5', 'Red light violation', 3);

-- Перевірка каскадного оновлення (оновлення номер водійського посвідчення)
UPDATE Vodii SET nomer_vodiy_sk = 'ZZ999999' WHERE id = 1;
SELECT * FROM Avtomobili;
SELECT * FROM DTB;

-- Перевірка каскадного видалення (видалення водія)
DELETE FROM Vodii WHERE id = 1;
SELECT * FROM Avtomobili;
SELECT * FROM DTB;

-- Перевірка каскадного оновлення (оновлення прізвище водія)
UPDATE Vodii SET prizvyshche = 'Shevchenko' WHERE id = 2;
SELECT * FROM Avtomobili;
SELECT * FROM DTB;

-- Перевірка каскадного видалення (видалення водія)
DELETE FROM Vodii WHERE id = 2;
SELECT * FROM Avtomobili;
SELECT * FROM DTB;
