-- Додавання записів у таблицю ДТП
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES
('2024-11-01', '08:30:00', 'Main Street, 12', 2, 'Collision', 'Open'),
('2024-12-15', '16:45:00', 'Broadway, 45', 1, 'Hit and Run', 'Closed'),
('2025-01-05', '10:15:00', 'Central Square, 3', 4, 'Pile-up', 'Open'),
('2025-02-10', '14:20:00', 'Highway 8', 3, 'Pedestrian Hit', 'Open');

-- Додавання записів у таблицю Транспортний засіб
INSERT INTO Vehicle (ID_Accident, License_Plate, Model, Year)
VALUES
(1, 'AB1234CD', 'Toyota Camry', 2020),
(2, 'BC5678EF', 'Honda Civic', 2019),
(3, 'CD9101GH', 'Ford Focus', 2022),
(4, 'DE3456IJ', 'BMW X5', 2021);

-- Додавання записів у таблицю Водій
INSERT INTO Driver (LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone)
VALUES
('Ivanov', 'Ivan', 'Ivanovich', 'Street 10', 'AB1234567', '2025-12-31', '+380501234567'),
('Petrenko', 'Oleg', 'Sergeevich', 'Avenue 15', 'BC9876543', '2026-11-30', '+380502345678'),
('Sidorov', 'Nikolay', 'Andreevich', 'Boulevard 7', 'CD7654321', '2024-08-20', '+380503456789'),
('Fedorov', 'Maxim', 'Olegovich', 'Lane 5', 'DE3456789', '2027-05-15', '+380504567890');

-- Додавання записів у таблицю Постраждалий
INSERT INTO Victim (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status)
VALUES
(1, 'Petrov', 'Petr', 'Petrovich', 'Street 20', 'AB1234567', 'Head Injury', 'Severe', 'Hospitalized'),
(2, 'Semenov', 'Alexey', 'Igorevich', 'Road 5', 'BC7654321', 'Leg Fracture', 'Moderate', 'Discharged'),
(3, 'Kuznetsov', 'Dmitry', 'Vladimirovich', 'Square 9', 'CD6543210', 'Back Injury', 'Mild', 'Outpatient'),
(4, 'Orlov', 'Sergey', 'Pavlovich', 'Highway 8', 'DE9876543', 'Broken Arm', 'Moderate', 'Hospitalized');

-- Додавання записів у таблицю Пішохід
INSERT INTO Pedestrian (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Is_Victim)
VALUES
(4, 'Morozov', 'Andrey', 'Viktorovich', 'Street 30', 'EF6543210', 1);

-- Додавання записів у таблицю Міліціонер
INSERT INTO Policeman (ID_Accident, LastName, FirstName, MiddleName, Rank, Department)
VALUES
(1, 'Bondarenko', 'Serhiy', 'Mykolayovych', 'Captain', 'Traffic Police'),
(3, 'Tkachenko', 'Dmytro', 'Oleksandrovych', 'Lieutenant', 'Highway Patrol'),
(4, 'Kovalenko', 'Pavlo', 'Igorovych', 'Captain', 'Traffic Police');
