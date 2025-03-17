                                               Лабораторна робота 2
                                                  
Мета роботи: Навчитися створювати запити до бази даних з використанням умови WHERE, виконувати багатотабличні запити, застосовувати різні види JOIN для об'єднання даних із кількох таблиць, а також використовувати складні умови фільтрації.

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


                          Бізнес-правила для системи ДАІ
1.	Максимальна довжина моделі транспортного засобу - 50 символів.
2.	Максимальна довжина державного номера транспортного засобу - 10 символів.
3.	Кожне ДТП повинно мати хоча б одного призначеного міліціонера.
4.	Максимальна довжина адреси місця ДТП - 100 символів.
5.	Інформація про травму завжди повинна бути прив'язана до конкретного постраждалого.
6.	Максимальна довжина опису типу травми - 100 символів.
7.	Кожний постраждалий повинен бути зареєстрований в конкретному ДТП.
8.	Максимальна довжина звання міліціонера - 30 символів.
9.	В одному ДТП може брати участь декілька транспортних засобів.
10.	Максимальна довжина номера посвідчення водія - 10 символів.
11.	Максимальна довжина номера паспорта - 9 символів.
12.	Тип ДТП повинен бути обов'язково вказаний.
13.	Один водій може керувати тільки одним транспортним засобом в момент ДТП.
14.	Максимальна довжина ПІБ учасників - 50 символів для кожного компонента.

![image](https://github.com/user-attachments/assets/e50f1a9a-7176-45a5-8055-1a35ab7e4c7c)

Завдання 3:
 ![image](https://github.com/user-attachments/assets/ede721a9-0b3b-4876-b804-b98cf12a5be5)
![image](https://github.com/user-attachments/assets/70426e4e-f033-46c9-9392-5542e0136d26)
![image](https://github.com/user-attachments/assets/939a9c65-ea86-48f7-a4ea-b14485005f9f)
![image](https://github.com/user-attachments/assets/6cbbbacc-459c-4d75-af80-4e3493b5faf2)

                      Рисунок 4-7 –успішне додавання по 100 записів у таблиці.

Завдання 4: Використання оператора WHERE
-- Виведення всіх ДТП, у яких постраждало більше двох осіб
SELECT * FROM Accident WHERE Victim_Count > 2;

-- Виведення ДТП, що сталися в зазначеному місці
SELECT * FROM Accident WHERE Location = 'Kyiv';

-- Виведення ДТП певного типу
SELECT * FROM Accident WHERE Accident_Type = 'Collision';

-- Виведення ДТП за конкретною датою
SELECT * FROM Accident WHERE Date = '2025-01-01';

-- Виведення ДТП з відкритим статусом розслідування
SELECT * FROM Accident WHERE Investigation_Status = 'Open'; 
Рисунок 8 – результат завдання 4.
Завдання 5: Використання логічних операторів у WHERE
- ДТП з більш ніж двома постраждалими, якщо розслідування ще не закрито
SELECT * FROM Accident WHERE Victim_Count > 2 AND Investigation_Status = 'Open';

-- ДТП, що сталися або в Києві, або у Львові
SELECT * FROM Accident WHERE Location = 'Kyiv' OR Location = 'Lviv';

-- ДТП з фільтрацією за двома умовами
SELECT * FROM Accident WHERE Victim_Count > 1 AND Date > '2025-01-01';

-- ДТП без постраждалих
SELECT * FROM Accident WHERE NOT Victim_Count > 0;

-- ДТП, що сталися у визначений період
SELECT * FROM Accident WHERE Date BETWEEN '2025-01-01' AND '2025-03-01';
 
Рисунок 9 – результат завдання 5.
Завдання  6: Використання оператора LIKE
-- ДТП, що сталися на вулицях, які закінчуються на "Street" або "St"
SELECT * FROM Accident WHERE Location LIKE '% Street' OR Location LIKE '% St';

-- ДТП у районах, що починаються на "North"
SELECT * FROM Accident WHERE Location LIKE 'North%';

-- ДТП, що містять у назві місця слово "Avenue"
SELECT * FROM Accident WHERE Location LIKE '%Avenue%';

-- ДТП з типами, що починаються на "C"
SELECT * FROM Accident WHERE Accident_Type LIKE 'C%';

-- ДТП у певному місті з точністю до літери
SELECT * FROM Accident WHERE Location LIKE '_yiv';
 
Рисунок 10 – результат завдання 6.

Завдання 7:Використання INNER JOIN
-- Виведення всіх ДТП разом з іменами постраждалих
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName 
FROM Accident A
INNER JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- Виведення ДТП та водіїв, що в них брали участь
SELECT A.*, D.LastName AS Driver_LastName, D.FirstName AS Driver_FirstName
FROM Accident A
INNER JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
INNER JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- ДТП та залучені транспортні засоби
SELECT A.*, V.License_Plate, V.Model 
FROM Accident A
INNER JOIN Vehicle V ON A.ID_Accident = V.ID_Accident;

-- ДТП з деталями про міліціонерів, що виїжджали
SELECT A.*, P.LastName AS Policeman_LastName, P.Rank
FROM Accident A
INNER JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- ДТП з даними про пішоходів
SELECT A.*, P.LastName AS Pedestrian_LastName
FROM Accident A
INNER JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;
 
Рисунок 11 – результат завдання 7.
Завдання 8: Використання LEFT JOIN
-- ДТП та можливі жертви (якщо немає — NULL)
SELECT A.*, COALESCE(V.LastName, 'No Victim') AS Victim_LastName 
FROM Accident A
LEFT JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- ДТП та міліціонери, які могли виїжджати
SELECT A.*, COALESCE(P.LastName, 'No Officer') AS Policeman_LastName
FROM Accident A
LEFT JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- ДТП та водії, які могли брати участь
SELECT A.*, COALESCE(D.LastName, 'Unknown') AS Driver_LastName
FROM Accident A
LEFT JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
LEFT JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- ДТП та пішоходи (якщо були)
SELECT A.*, COALESCE(P.LastName, 'No Pedestrian') AS Pedestrian_LastName
FROM Accident A
LEFT JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- ДТП та їх транспортні засоби
SELECT A.*, COALESCE(V.License_Plate, 'No Vehicle') AS License_Plate
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident;
 
Рисунок 12 – результат завдання 8.
Завдання 9: Використання вкладеного запиту (SUBQUERY)
-- ДТП, у яких є хоча б один потерпілий із тяжкими травмами
SELECT * FROM Accident 
WHERE EXISTS (
    SELECT 1 FROM Victim WHERE Victim.ID_Accident = Accident.ID_Accident AND Victim.Severity = 'Severe'
);

-- ДТП, де кількість жертв перевищує середнє значення
SELECT * FROM Accident 
WHERE Victim_Count > (SELECT AVG(Victim_Count) FROM Accident);

-- Водії, які брали участь більше ніж в одній ДТП
SELECT * FROM Driver 
WHERE ID_Driver IN (
    SELECT ID_Driver FROM Driver_Involvement GROUP BY ID_Driver HAVING COUNT(*) > 1
);

-- ДТП, які мають більше 2 транспортних засобів
SELECT * FROM Accident 
WHERE ID_Accident IN (
    SELECT ID_Accident FROM Vehicle GROUP BY ID_Accident HAVING COUNT(*) > 2
);

-- ДТП з найбільшою кількістю постраждалих
SELECT * FROM Accident 
WHERE Victim_Count = (SELECT MAX(Victim_Count) FROM Accident);
 
Рисунок 13 – результат завдання 9.
Завдання 10: Використання GROUP BY та HAVING
-- Підрахунок кількості ДТП за типом, якщо більше 1, з урахуванням пішоходів
SELECT A.Accident_Type, COUNT(*) AS Total_Accidents
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
GROUP BY A.Accident_Type
HAVING COUNT(*) > 1;

-- Визначення кількості ДТП за місцем, якщо в них постраждали водії
SELECT A.Location, COUNT(*) AS Accident_Count
FROM Accident A
JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
GROUP BY A.Location
HAVING COUNT(*) > 1;

-- Кількість ДТП, у яких є постраждалі, згруповані за місцем, якщо їх більше 2
SELECT A.Location, COUNT(*) AS Accident_With_Victims
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Victim_Count > 0
GROUP BY A.Location
HAVING COUNT(*) > 2;

-- Визначення кількості ДТП за роками, якщо в них брали участь міліціонери певного звання
SELECT YEAR(A.Date) AS Year, COUNT(*) AS Total_Accidents
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain'
GROUP BY YEAR(A.Date)
HAVING COUNT(*) > 1;

-- Кількість ДТП, де кількість транспортних засобів перевищує 2
SELECT A.ID_Accident, COUNT(V.ID_Vehicle) AS Vehicle_Count
FROM Accident A
JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
GROUP BY A.ID_Accident
HAVING COUNT(V.ID_Vehicle) > 2;
 
Рисунок 14 – результат завдання 10.
Завдання 11: Складний багатотабличний JOIN

-- 1. Виведення всіх ДТП разом з кількістю залучених транспортних засобів
SELECT 
    A.ID_Accident, A.Date, A.Location, A.Accident_Type, 
    COUNT(V.ID_Vehicle) AS Vehicle_Count
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
GROUP BY A.ID_Accident, A.Date, A.Location, A.Accident_Type;

-- 2. Визначення місця, де сталося найбільше ДТП
SELECT TOP 1 Location, COUNT(*) AS Total_Accidents
FROM Accident
GROUP BY Location
ORDER BY Total_Accidents DESC;

-- 3. Список водіїв, які брали участь у ДТП більше ніж один раз за певний період
SELECT D.ID_Driver, D.LastName, D.FirstName, COUNT(DI.ID_Accident) AS Accident_Count
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY D.ID_Driver, D.LastName, D.FirstName
HAVING COUNT(DI.ID_Accident) > 1;

-- 4. Визначення найбільш небезпечного типу ДТП (з найбільшою середньою кількістю постраждалих)
SELECT TOP 1 Accident_Type, AVG(Victim_Count) AS Avg_Victims
FROM Accident
GROUP BY Accident_Type
ORDER BY Avg_Victims DESC;

-- 5. Виведення ДТП, на які виїжджали міліціонери певного звання
SELECT 
    A.ID_Accident, A.Date, A.Location, A.Accident_Type, 
    P.LastName AS Policeman_LastName, P.Rank
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain';
 
Рисунок 15 – результат завдання 11.
Завдання 12: WHERE у поєднанні з JOIN
-- 1. Виведення всіх відкритих ДТП разом з іменами постраждалих
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Investigation_Status = 'Open';

-- 2. ДТП з вини пішоходів за певний період
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2025-01-01' AND '2025-12-31';

-- 3. ДТП з більш ніж двома постраждалими, якщо розслідування ще не закрито
SELECT * FROM Accident 
WHERE Victim_Count > 2 AND Investigation_Status = 'Open';

-- 4. Визначення кількості ДТП за місцем, якщо їх більше 3
SELECT Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
HAVING COUNT(*) > 3;

-- 5. Водії, які брали участь у ДТП з важкими наслідками
SELECT DISTINCT D.*
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Victim_Count > 3;
 
Рисунок 16 – результат завдання 12.
Завдання 14. запити за варіантом відповідно до опису предметної області основного варіанта
-- 1. Вивід ДТП з вини пішоходів за період
DECLARE @StartDate DATE = '2024-01-01', @EndDate DATE = '2024-12-31';
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate

-- 2. Знайти місце з максимальною кількістю ДТП
SELECT TOP 1 Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
ORDER BY COUNT(*) DESC;

-- 3. Вивід ДТП, на які виїжджали міліціонери певного звання за період
DECLARE @Rank VARCHAR(30) = 'Captain';
SELECT A.*
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = @Rank
AND A.Date BETWEEN @StartDate AND @EndDate;

-- 4. Список водіїв, які брали участь більше ніж в одній ДТП за період
SELECT D.*
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate
GROUP BY D.ID_Driver, D.LastName, D.FirstName, D.MiddleName, D.Address, D.License_Number, D.License_Expiry, D.Phone
HAVING COUNT(DI.ID_Accident) > 1;

-- 5. Список постраждалих у ДТП за період, впорядкований за кількістю травм
SELECT V.*, A.*
FROM Victim V
JOIN Accident A ON V.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN @StartDate AND @EndDate
ORDER BY V.Severity DESC;

-- 6. Додавання нової ДТП
DECLARE @Date DATE = '2025-01-01', @Time TIME = '12:00', @Location VARCHAR(100) = 'Main St', @Victim_Count INT = 2, @Accident_Type VARCHAR(50) = 'Collision', @Investigation_Status VARCHAR(20) = 'Open';
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);

-- 7. Видалення ДТП, які сталися раніше вказаної дати
DECLARE @DeleteDate DATE = '2023-01-01';
DELETE FROM Accident
WHERE Date < @DeleteDate;
 
Рисунок 17 – результат завдання 14.

Висновки: 
У ході виконання роботи я навчилася формувати запити до бази даних із використанням умови WHERE, що дозволяє здійснювати селекцію даних за заданими критеріями. Освоїла застосування логічних операторів AND, OR, NOT для побудови складних умов фільтрації.
Я також працювала з багатотабличними запитами, використовуючи різні види JOIN (INNER JOIN, LEFT JOIN), що дало змогу об’єднувати дані з декількох таблиць та отримувати комплексну інформацію про ДТП, їх учасників та наслідки.
Крім того, я застосувала вкладені запити (SUBQUERY) для реалізації складних вибірок, а також оператори GROUP BY та HAVING для групування даних і отримання статистичних підсумків.
Таким чином, у ході виконання роботи я здобула навички роботи з SQL-запитами різного рівня складності, що є важливим для ефективного аналізу та обробки інформації в реляційних базах даних.



