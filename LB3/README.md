                                               Лабораторна робота 3
                                                  
Мета роботи: Навчитися виконувати багатотабличні запити, використовувати каскадні дії для забезпечення цілісності даних, застосовувати сортування результатів запитів, використовувати булеві та реляційні оператори для фільтрації даних, а також освоїти різні види JOIN для об'єднання таблиць та аналізувати продуктивність SQL-запитів.

                                             Варіант №20 (ДАІ)
База даних повинна містити інформацію про дорожньо-транспортні
подіях (ДТП). Про ДТП має бути відомо вид ДТП, які транспортні засоби в ньому брали участь (можливо більше двох), їх державні номери, П.І.Б., домашні адреси водіїв цих транспортних засобів, а також номери посвідчень водія. Крімтого, необхідно знати кількість постраждалих у даній ДТП, вид травми, П.І.Б., домашня адреса та номер паспорта кожного потерпілого. Постраждалими можуть бути водії. У ДТП можуть брати участь і пішоходи, про які потрібно знати, чи не є вони постраждалими, а також їх П.І.Б., домашню адресу та номер паспорта. Про ДТП також мають бути відомі місце, дата, час, винуватець ДТП та які міліціонери (їх звання та П.І.Б.) виїжджали ДТП.
                          
                                Запити
        •	Вивести повний список ДТП, які виникли з вини пішоходів, за вказаний
        період з повними відомостями про них;
        •	Знайти місце, де сталася максимальна кількість ДТП;
        •	Вивести повний список ДТП, на які ВИЇжджали міліціонери із зазначеним
        званням за вказаний період часу, з повними відомостями про ДТП;
        •	Скласти список водіїв, які брали участь більше НІЖ В ОДНІЙ ДТП за
        зазначений період часу, З повними відомостями про цих водіїв;
        •	Скласти список постраждалих у ДТП за вказаний період часу з
        повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду.
        •	Внести відомості про нову ДТП;
        •	Видалити відомості про ДТП, які сталися раніше вказаної дати.

                            
                        Логічна та фізична модель
![image](https://github.com/user-attachments/assets/f28b2ca6-c263-4cf1-8a6b-23382d8fbcb9)

![image](https://github.com/user-attachments/assets/96d46b57-0b9a-4983-97ca-c6d99bad622c)

Завдання 3: Використання розгорнутого інстанстанс MS SQL на Docker, та додавання базу даних використовуючи скрипти SETUP.SQL та INSERT.SQL
 ![image](https://github.com/user-attachments/assets/7b6e3911-9942-4456-9dbe-9c4188ae473d)

                            Рисунок 4 – виконання завдання 3.

Завдання 4: Формування запитів із використанням багатотабличних дій

-- Запит 1: Інформація про ДТП, транспортні засоби та водіїв
SELECT A.ID_Accident, A.Date, A.Location, V.License_Plate, V.Model, D.LastName AS Driver_LastName, D.FirstName AS Driver_FirstName, DI.Role AS Driver_Role 
FROM Accident A 
JOIN Vehicle V ON A.ID_Accident = V.ID_Accident 
JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident 
JOIN Driver D ON DI.ID_Driver = D.ID_Driver 
ORDER BY A.Date;

-- Запит 2: Інформація про постраждалих у ДТП та пішоходів
SELECT V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName, V.Injury_Type, V.Severity, P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.Is_Victim 
FROM Victim V 
LEFT JOIN Pedestrian P ON V.ID_Accident = P.ID_Accident 
ORDER BY V.LastName;

-- Запит 3: Інформація про міліціонерів на ДТП, де постраждалих більше 2
SELECT P.LastName AS Policeman_LastName, P.FirstName AS Policeman_FirstName, P.Rank, A.Date, A.Location, A.Victim_Count 
FROM Policeman P 
JOIN Accident A ON P.ID_Accident = A.ID_Accident 
WHERE A.Victim_Count > 2 
ORDER BY A.Date DESC;

Запит 1: Виводить інформацію про ДТП, транспортні засоби та водіїв, використовуючи JOIN для об'єднання таблиць Accident, Vehicle, Driver_Involvement та Driver. Результати сортуються за датою ДТП.
Запит 2: Виводить інформацію про постраждалих у ДТП та пішоходів, де використовується LEFT JOIN між таблицями Victim і Pedestrian, щоб отримати постраждалих, навіть якщо вони не є пішоходами. Сортування за прізвищем постраждалих.
Запит 3: Виводить інформацію про міліціонерів, що працювали на ДТП з кількістю постраждалих більше 2, використовуючи JOIN між таблицями Policeman і Accident, фільтруючи ДТП за кількістю постраждалих.

![image](https://github.com/user-attachments/assets/7f67bdb5-c123-4442-bc2d-b88c25ba4e1b)

                            Рисунок 5 – результат виконання використанням багатотабличних дій.
              (декілька однакових значень в ID_Accident означає, що в цьому ДТП було декілька водіїв.)
              
Завдання 5: Формування запитів із каскадними діями

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

Створюю три таблиці: Vodii, Avtomobili та DTB, з каскадними діями для оновлення та видалення. При оновленні даних у таблиці Vodii змінюються відповідні записи в Avtomobili та DTB. При видаленні водія з Vodii також видаляються пов'язані записи в інших таблицях.

 ![image](https://github.com/user-attachments/assets/a5183a74-5aac-454b-a872-5984a0b1e65d)

                  Рисунок 6 – результат виконання 5 завдання: формування запитів із каскадними діями.
                  
Завдання 6: Формування запитів із використанням сортування даних (ORDER BY)

-- 1. Вивести всі ДТП, відсортовані за датою у зворотньому порядку (від найновіших до найстаріших)
SELECT * 
FROM Accident
ORDER BY Date DESC;

-- 2. Вивести всі ДТП, відсортовані за кількістю постраждалих у зростаючому порядку
SELECT * 
FROM Accident
ORDER BY Victim_Count ASC;

-- 3. Вивести список водіїв, які брали участь у ДТП, відсортованих за прізвищем
SELECT D.LastName, D.FirstName, D.MiddleName, A.Date, A.Location
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
ORDER BY D.LastName;

-- 4. Вивести список всіх постраждалих у ДТП, відсортованих за тяжкістю травми (від важких до легких)
SELECT V.LastName, V.FirstName, V.Injury_Type, V.Severity, A.Date, A.Location
FROM Victim V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
ORDER BY V.Severity DESC;

-- 5. Вивести місце, де сталося максимальне число ДТП (відсортоване за кількістю випадків)
SELECT Location, COUNT(*) AS AccidentCount
FROM Accident
GROUP BY Location
ORDER BY AccidentCount DESC;

-- 6. Вивести список транспортних засобів, відсортованих за моделлю
SELECT V.License_Plate, V.Model, V.Year, A.Date
FROM Vehicle V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
ORDER BY V.Model;
-- 7. Вивести список водіїв, які брали участь більше ніж в одній ДТП, за період з 2022 року, відсортованих за кількістю ДТП
SELECT D.LastName, D.FirstName, COUNT(DI.ID_Accident) AS AccidentCount
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
WHERE DI.Fixation_Time >= '2022-01-01'
GROUP BY D.LastName, D.FirstName
HAVING COUNT(DI.ID_Accident) > 1
ORDER BY AccidentCount DESC;

-- 8. Вивести всі ДТП, де брали участь пішоходи, відсортовані за типом ДТП
SELECT A.Date, A.Location, A.Accident_Type, P.LastName, P.FirstName, P.Is_Victim
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
ORDER BY A.Accident_Type;

-- 9. Вивести інформацію про міліціонерів, які виїжджали на ДТП з певним званням, відсортованих за прізвищем
SELECT M.LastName, M.FirstName, M.Rank, A.Date, A.Location
FROM Policeman M
JOIN Accident A ON M.ID_Accident = A.ID_Accident
WHERE M.Rank = 'Captain'
ORDER BY M.LastName;

-- 10. Вивести список всіх ДТП, де була максимальна кількість постраждалих, відсортованих за місцем
SELECT A.Date, A.Location, A.Victim_Count, A.Accident_Type
FROM Accident A
WHERE A.Victim_Count = (SELECT MAX(Victim_Count) FROM Accident)
ORDER BY A.Location;

 ![image](https://github.com/user-attachments/assets/b2b39fb0-c0f4-44b9-89c9-144dbb455c61)
 ![image](https://github.com/user-attachments/assets/9cb3fe1c-7169-4335-b6b1-65552fe33132)
 ![image](https://github.com/user-attachments/assets/1429a30c-2816-41b9-8bb8-fd0723c07603)
![image](https://github.com/user-attachments/assets/f5cb9bb0-20f9-4ba9-ada4-6aad5f718349)
![image](https://github.com/user-attachments/assets/be646943-4f06-4685-bd42-4ff6b77a1aa8)

                            Рисунок 7 -11 – результат виконання завдання 6: Формування запитів із використанням сортування даних (ORDER BY).

Завдання 7: Використання булевих та реляційних операторів

-- Вибірка всіх ДТП, де кількість постраждалих більше 2 і тип ДТП – "Rear-end"
SELECT * 
FROM Accident
WHERE Victim_Count > 2 AND Accident_Type = 'Rear-end';

-- Вибірка всіх ДТП, де або кількість постраждалих більше 5, або тип ДТП – "Head-on"
SELECT * 
FROM Accident
WHERE Victim_Count > 5 OR Accident_Type = 'Head-on';

-- Вибірка всіх ДТП, де тип ДТП не є "Rear-end"
SELECT * 
FROM Accident
WHERE NOT Accident_Type = 'Rear-end';

-- Вибірка всіх ДТП, де кількість постраждалих не менша за 5
SELECT * 
FROM Accident
WHERE Victim_Count >= 5;
-- Вибірка всіх ДТП, де дата сталася до 2021 року
SELECT * 
FROM Accident
WHERE Date < '2021-01-01';

-- Вибірка всіх ДТП, де кількість постраждалих не дорівнює 0
SELECT * 
FROM Accident
WHERE Victim_Count <> 0;

-- Вибірка всіх ДТП після 2020 року, де більше ніж 3 постраждалих і тип не "Side-swipe"
SELECT * 
FROM Accident
WHERE Date > '2020-12-31' AND Victim_Count > 3 AND NOT Accident_Type = 'Side-swipe';

Запит 1: Вибірка ДТП, де кількість постраждалих більше 2 і тип ДТП — "Rear-end". Застосовую оператор AND для обох умов.
Запит 2: Вибірка ДТП, де кількість постраждалих більше 5 або тип ДТП — "Head-on". Використовую оператор OR для альтернативних умов.
Запит 3: Вибірка ДТП, де тип ДТП не є "Rear-end". Використовую NOT для заперечення умови.
Запит 4: Вибірка ДТП, де кількість постраждалих не менша за 5. Проста умова з порівнянням.
Запит 5: Вибірка ДТП до 2021року. Встановлюю фільтр на дату, використовуючи оператор <.
Запит 6: Вибірка ДТП, де кількість постраждалих не дорівнює 0. Використовую оператор <> для нерівності.
Запит 7: Вибірка ДТП після 2020 року, з більше ніж 3 постраждалими і типом не "Side-swipe". Комбінація AND та NOT для уточнених фільтрів.

  ![image](https://github.com/user-attachments/assets/0b1e03b8-cafd-4574-993d-afb893b14ae2)
  ![image](https://github.com/user-attachments/assets/40cec8b2-c793-4a2d-b32e-56dc3a477128)
  ![image](https://github.com/user-attachments/assets/bb268e6e-fe9f-4ae7-8719-baac0fa6e81b)
  
                   Рисунок 12-14  – результат виконання завдання 7: Використання булевих та реляційних операторів.

Завдання 8: Розширене використання оператора JOIN у складних запитах

-- 1. Вибірка всіх ДТП з інформацією про транспортні засоби та водіїв
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Accident_Type, 
       V.License_Plate, V.Model, V.Year, 
       D.LastName, D.FirstName, D.MiddleName, D.License_Number
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
LEFT JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
LEFT JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- 2. Виведення всіх потерпілих та їхніх травм по кожному ДТП
SELECT A.ID_Accident, A.Date, A.Location, 
       V.LastName, V.FirstName, V.MiddleName, V.Injury_Type, V.Severity
FROM Accident A
RIGHT JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- 3. Відображення ДТП разом із міліціонерами, що їх розслідували
SELECT A.ID_Accident, A.Date, A.Location, 
       P.LastName, P.FirstName, P.MiddleName, P.Rank, P.Department
FROM Accident A
FULL JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- 4. Всі ДТП, у яких брали участь пішоходи (чи постраждалі, чи ні)
SELECT A.ID_Accident, A.Date, A.Location, 
       P.LastName, P.FirstName, P.MiddleName, P.Is_Victim
FROM Accident A
INNER JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- 5. ДТП, у яких кількість постраждалих перевищує 3
SELECT A.ID_Accident, A.Date, A.Location, A.Victim_Count
FROM Accident A
WHERE A.Victim_Count > 3;

-- 6. Всі водії, що були винуватцями ДТП
SELECT D.LastName, D.FirstName, D.MiddleName, D.License_Number, A.ID_Accident, A.Date, A.Location
FROM Driver D
INNER JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
INNER JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE DI.Involvement_Status = 'Responsible';

Запит 1: Вибірка ДТП з інформацією про транспортні засоби та водіїв за допомогою LEFT JOIN для кожної таблиці.
Запит 2: Виведення потерпілих та їхніх травм для кожного ДТП, використовуючи RIGHT JOIN для включення всіх потерпілих.
Запит 3: Відображення ДТП з міліціонерами, які їх розслідували, через FULL JOIN для включення всіх записів з обох таблиць.
Запит 4: Вибірка ДТП, де брали участь пішоходи, незалежно від того, постраждали вони чи ні, через INNER JOIN для зв'язку між таблицями.
Запит 5: Вибірка ДТП з більше ніж 3 постраждалими, без використання JOIN.
Запит 6: Вибірка водіїв, що були винуватцями ДТП, через INNER JOIN та фільтрацію за статусом відповідальності.

 ![image](https://github.com/user-attachments/assets/23d40359-a691-4ca4-8b30-c1261bcb176c)
 ![image](https://github.com/user-attachments/assets/5fea0008-63eb-4a9f-9db5-320949eb1f94)
 ![image](https://github.com/user-attachments/assets/be1643c3-e887-4c25-8bf5-2d36988937c5)

                    Рисунок 15-17 –результат виконання завдання 8: Розширене використання оператора JOIN у складних запитах.

Завдання 9: Застосування оператора GROUP BY та умови HAVING у поєднанні з JOIN

-- Кількість ДТП за типами з фільтрацією 
SELECT a.Accident_Type, COUNT(*) AS Total_Accidents
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
GROUP BY a.Accident_Type
HAVING COUNT(*) > 2;

-- Кількість транспортних засобів, які брали участь у ДТП, за роками випуску
SELECT v.Year, COUNT(v.ID_Accident) AS Vehicle_Count
FROM Vehicle v
JOIN Accident a ON v.ID_Accident = a.ID_Accident
GROUP BY v.Year
HAVING COUNT(v.ID_Accident) > 1;

-- Середня кількість постраждалих у ДТП по вулицях 
SELECT a.Location, AVG(a.Victim_Count) AS Avg_Victims
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
GROUP BY a.Location
HAVING AVG(a.Victim_Count) > 1;

-- Кількість ДТП, розслідуваних міліціонерами певного звання
SELECT p.Rank, COUNT(DISTINCT a.ID_Accident) AS Total_Cases
FROM Policeman p
JOIN Accident a ON p.ID_Accident = a.ID_Accident
GROUP BY p.Rank
HAVING COUNT(DISTINCT a.ID_Accident) > 2;

-- Список водіїв із кількістю ДТП, у яких вони брали участь, з обмеженням
SELECT d.LastName, d.FirstName, COUNT(di.ID_Accident) AS Accident_Count
FROM Driver d
JOIN Driver_Involvement di ON d.ID_Driver = di.ID_Driver
JOIN Accident a ON di.ID_Accident = a.ID_Accident
GROUP BY d.LastName, d.FirstName
HAVING COUNT(di.ID_Accident) > 1;

Запит 1: Підрахунок кількості ДТП за типами, відфільтрованих за типами, де кількість ДТП більше 2. Використовується JOIN для з'єднання таблиць і HAVING для фільтрації результатів.
Запит 2: Підрахунок кількості транспортних засобів за роками випуску, де кількість ДТП більше 1. Використовується JOIN між таблицями транспортних засобів та ДТП.
Запит 3: Розрахунок середньої кількості постраждалих у ДТП по вулицях, відфільтрованих за середнім значенням більше 1. Застосовується GROUP BY за локацією.
Запит 4: Підрахунок кількості ДТП, розслідуваних міліціонерами з певним званням, де кількість розслідуваних ДТП більше 2. Використовуються GROUP BY і HAVING.
Запит 5: Виведення списку водіїв з кількістю ДТП, де вони брали участь, з обмеженням на кількість ДТП більше 1. Використовується JOIN для з'єднання таблиць водіїв та їхніх участей у ДТП.

![image](https://github.com/user-attachments/assets/e9945275-41f0-4e59-b7be-0f2efe884d5f)
![image](https://github.com/user-attachments/assets/3cf73ee3-d068-4af7-a7ce-a45eaa4005ea)
![image](https://github.com/user-attachments/assets/343b76a6-717d-4ee9-ba0a-c98f26d3bfe1)

                   Рисунок 18-20 –результат виконання завдання 9: Застосування оператора GROUP BY та умови HAVING у поєднанні з JOIN

Завдання 10: Аналіз продуктивності запитів
Аналіз продуктивності запитів у MS SQL використовую EXPLAIN (Execution Plan):
Для завдання 4:

![image](https://github.com/user-attachments/assets/996620fd-1ddb-41c8-bb94-9fa42955f3c0)

Для завдання 5:

![image](https://github.com/user-attachments/assets/6dabc87d-9529-49fe-9daa-410550f2e7c3)

Для завдання 6:

![image](https://github.com/user-attachments/assets/b458ef5c-a79b-49f9-89b7-fbf5dfb958b3)

Для завдання 7:

![image](https://github.com/user-attachments/assets/bb6301d2-31b6-4ffd-9af3-0553e1c553a1)

Для завдання 8:

![image](https://github.com/user-attachments/assets/179af0fe-db71-4427-bb58-a532d3aff0d3)

Для завдання 9:

![image](https://github.com/user-attachments/assets/beb4310d-d644-41af-bf02-590dea0a4c2a)
 
Рисунок 21-26 –результат виконання завдання 10 - Аналіз продуктивності запитів у MS SQL використовую EXPLAIN (Execution Plan):

Завдання 12: Виконати запити за Вашим варіантом відповідно до опису предметної області основного варіанта.

--Вивести повний список ДТП, які виникли з вини пішоходів, за вказаний період з повними відомостями про них:
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.MiddleName AS Pedestrian_MiddleName,
       P.Address AS Pedestrian_Address, P.Passport_Number AS Pedestrian_Passport
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

--Знайти місце, де сталася максимальна кількість ДТП:
SELECT Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
ORDER BY Accident_Count DESC;

--Вивести повний список ДТП, на які виїжджали міліціонери із зазначеним званням за вказаний період часу, з повними відомостями про ДТП:
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       Po.LastName AS Policeman_LastName, Po.FirstName AS Policeman_FirstName, Po.MiddleName AS Policeman_MiddleName,
       Po.Rank AS Policeman_Rank
FROM Accident A
JOIN Policeman Po ON A.ID_Accident = Po.ID_Accident
WHERE Po.Rank = 'Lieutenant' AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

--Скласти список водіїв, які брали участь більше ніж в одній ДТП за зазначений період часу, з повними відомостями про цих водіїв:
SELECT D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2022-01-01' AND '2024-01-01'
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
HAVING COUNT(DI.ID_Accident) > 1
ORDER BY D.LastName, D.FirstName;

--	Скласти список постраждалих у ДТП за вказаний період часу з повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду.
SELECT 
    v.LastName, v.FirstName, v.MiddleName, v.Address, v.Passport_Number,
    a.Date, a.Time, a.Location, a.Accident_Type, 
    v.Injury_Type,
    COUNT(v.Injury_Type) OVER (PARTITION BY v.Injury_Type) AS Injury_Count, 
    COUNT(v.ID_Victim) OVER (PARTITION BY a.ID_Accident) AS Victim_Count
FROM Victim v
JOIN Accident a ON v.ID_Accident = a.ID_Accident
WHERE a.Date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY Injury_Count DESC, Victim_Count DESC;

Запит 1: Виведення списку ДТП, де пішоходи є постраждалими, за період з 2022 по 2024 рік. З'єднання таблиць ДТП та пішоходів, фільтрація за періодом і станом пішохода як жертви.
Запит 2: Підрахунок ДТП за місцем їхнього виникнення. Використовуються GROUP BY та ORDER BY для визначення місця з найбільшою кількістю ДТП.
Запит 3: Список ДТП, на які виїжджали міліціонери з певним званням ("Lieutenant") у період з 2022 по 2024 рік. З'єднання таблиць ДТП та міліціонерів із фільтрацією за званням та періодом.
Запит 4: Список водіїв, які брали участь у більше ніж одній ДТП за період з 2022 по 2024 рік. Використовується GROUP BY та HAVING для вибору водіїв, що брали участь в кількох ДТП.
Запит 5: Список постраждалих у ДТП з повними відомостями, упорядкований за кількістю травм певного виду, з фільтрацією за період 2023 року. Використовуються віконні функції COUNT з PARTITION BY для підрахунку травм та постраждалих.

![image](https://github.com/user-attachments/assets/fe25d608-7106-4626-93e3-1ce8c44a9e56)
![image](https://github.com/user-attachments/assets/cf440730-25e7-40b0-a068-ec4c173ac493)

                            Рисунок 27- – Виконання запитів за описом предметної області ДАІ.

Висновки: 
У ході виконання роботи я досягла поставленої мети: навчилася виконувати багатотабличні запити, використовувати каскадні дії для забезпечення цілісності даних, застосовувати сортування результатів запитів, використовувати булеві та реляційні оператори для фільтрації даних, а також освоїла різні види JOIN для об'єднання таблиць та аналізувати продуктивність SQL-запитів.

