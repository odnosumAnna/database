                                               ЛАБОРАТОРНА РОБОТА №6
          	                        на тему: « Поняття транзакцій й робота з ними в MSSQL.»
                                 
Мета роботи: Ознайомитися з поняттям індексів у системі керування базами даних Microsoft SQL Server, вивчити їх призначення, особливості використання та вплив на продуктивність запитів. Засвоїти оператори створення індексів, порядок їх застосування, а також методи реорганізації та видалення. Набути практичних навичок роботи з індексами шляхом створення, оптимізації та аналізу їх ефективності у базі даних.

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


Завдання 3. Реалізація транзакції з двома операціями та умовою, яка призведе до ROLLBACK.
У цьому завданні я реалізую транзакцію, що містить дві основні операції: оновлення статусу розслідування для певної ДТП та перевірку наявності пішохода, який є винуватцем. Якщо умова виконання перевірки не буде задоволена (тобто не знайдено пішохода-винуватця), то транзакція буде скасована за допомогою операції ROLLBACK. Якщо ж умова виконується, транзакція буде підтверджена за допомогою операції COMMIT.
Цей підхід дозволяє забезпечити цілісність даних: якщо одна з операцій не виконується, то всі зміни будуть скасовані, що гарантує коректність і надійність обробки даних у базі.
Лістинг коду:
BEGIN TRAN;

-- Оновлюємо статус розслідування для ДТП з ID = 1
UPDATE Accident
SET Investigation_Status = 'Closed'
WHERE ID_Accident = 1;

-- Якщо немає жодного пішохода, який є винуватцем — відкат
IF (SELECT COUNT(*) FROM Culprit WHERE Type = 'Pedestrian') = 0
    ROLLBACK;
ELSE
    COMMIT;
Пояснення коду:
1.	BEGIN TRAN; — Ініціалізація транзакції. Це означає, що всі зміни в межах цієї транзакції будуть або підтверджені, або скасовані разом.
2.	UPDATE Accident SET Investigation_Status = 'Closed' WHERE ID_Accident = 1; — Оновлення статусу розслідування для ДТП з ID = 1 на "Closed". Це перша операція транзакції.
3.	IF (SELECT COUNT(*) FROM Culprit WHERE Type = 'Pedestrian') = 0 ROLLBACK; — Перевірка, чи є в таблиці Culprit пішохід, який є винуватцем. Якщо таких пішоходів немає (кількість = 0), то транзакція скасовується за допомогою ROLLBACK.
4.	ELSE COMMIT; — Якщо в таблиці є пішохід-винуватець, то транзакція підтверджується через COMMIT.
Транзакція забезпечує цілісність даних: якщо не виконано умови (немає пішохода-винуватця), всі зміни скасовуються, щоб не зберігалися неповні або некоректні дані.

  ![image](https://github.com/user-attachments/assets/d095a372-1604-4fe8-8346-d8a129a83827)

Рисунок 6  – виконання завдання 3.

Завдання 4. Перевірка @@ERROR для керування транзакцією.
У цьому завданні я реалізувала транзакцію з використанням системної змінної @@ERROR для контролю помилок під час виконання SQL-операцій. Код перевіряє, чи сталася помилка під час оновлення даних про ДТП, і відповідно виконує ROLLBACK або COMMIT.

Лістинг коду:
BEGIN TRAN;

-- Спроба оновлення дати ДТП (можливо неіснуючого запису)
UPDATE Accident
SET Date = '2025-01-01'
WHERE ID_Accident = 9999;

-- Якщо сталася помилка — відкочуємо транзакцію
IF @@ERROR <> 0
    ROLLBACK;
ELSE
    COMMIT;
Пояснення до коду :
1.	BEGIN TRAN; — початок транзакції.
2.	UPDATE Accident SET Date = '2025-01-01' WHERE ID_Accident = 9999;
— спроба оновити запис про ДТП з неіснуючим ID. Це потенційно викличе помилку.
3.	IF @@ERROR <> 0 ROLLBACK;
— якщо під час оновлення виникла помилка, транзакція скасовується.
4.	ELSE COMMIT;
— якщо помилки не було, зміни підтверджуються.
Такий підхід забезпечує контроль за цілісністю даних та дозволяє уникнути частково виконаних змін.


 ![image](https://github.com/user-attachments/assets/4c530441-4cb4-4928-a985-51de2c34238c)

Рисунок  7 – виконання завдання 4.


Завдання 5. TRY...CATCH у транзакції.
У цьому завданні я реалізувала обробку помилок під час виконання транзакції за допомогою конструкції TRY...CATCH. Такий підхід дозволяє безпечно виконувати SQL-операції й автоматично обробляти винятки, що можуть виникнути, наприклад, через неправильні дані.
Лістинг коду:
BEGIN TRAN;

BEGIN TRY
    -- Спроба вставити некоректну дату — викликає помилку
    UPDATE Accident
    SET Date = 'invalid-date'
    WHERE ID_Accident = 1;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;
Пояснення до коду:
1.	BEGIN TRAN; — початок транзакції.
2.	BEGIN TRY ... END TRY — в цьому блоці виконується спроба оновити дату ДТП. Значення 'invalid-date' не є коректною датою, тому викликається помилка.
3.	COMMIT; — фіксація змін, якщо помилки не сталося (в цьому випадку не виконається).
4.	BEGIN CATCH ... END CATCH — при виникненні помилки виконується відкат транзакції (ROLLBACK) і виводиться повідомлення про помилку (PRINT ERROR_MESSAGE();).
Цей механізм забезпечує контрольоване завершення транзакції навіть при виникненні помилок.


![image](https://github.com/user-attachments/assets/713a0b95-02b1-4bec-bcdd-15ad81ad796c)

Рисунок  8 – виконання завдання 5.


Завдання 6. У цьому завданні я створила транзакцію, яка вставляє в таблицю Accident велику кількість рядків — у моєму випадку 10 000, але ця кількість може бути змінена до 100 000. Основна мета — показати, що таблиця може містити велику кількість даних для подальшого аналізу або тестування продуктивності.
Лістинг коду :
BEGIN TRANSACTION;

DECLARE @i INT = 1;

WHILE @i <= 10000 -- or more, up to 100000
BEGIN
    INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
    VALUES (
        DATEADD(DAY, -@i, GETDATE()),  -- Date of the accident
        CAST(DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % 86400, 0) AS TIME),  -- Random time of day
        CONCAT('Location #', @i),  -- Location name with number
        ABS(CHECKSUM(NEWID()) % 5),  -- Number of victims (0-4)
        CASE ABS(CHECKSUM(NEWID()) % 3)  -- Type of accident
            WHEN 0 THEN 'Collision'
            WHEN 1 THEN 'Hit'
            ELSE 'Other'
        END,
        CASE ABS(CHECKSUM(NEWID()) % 2)  -- Investigation status
            WHEN 0 THEN 'Open'
            ELSE 'Closed'
        END
    );

    SET @i += 1;
END

COMMIT TRANSACTION;



Пояснення до коду:
1.	BEGIN TRANSACTION;
— Початок транзакції. Це означає, що всі вставки будуть оброблятися як одне ціле. Якщо щось піде не так — можна відкотити все.
2.	DECLARE @i INT = 1;
— Змінна-лічильник для циклу.
3.	WHILE @i <= 10000
— Цикл виконується 10 000 разів (або більше, якщо змінити межу).
4.	Усередині циклу:
— INSERT INTO Accident (...) VALUES (...) вставляє один новий запис у таблицю Accident.
— Дата аварії створюється як сьогодні мінус @i днів: DATEADD(DAY, -@i, GETDATE()).
— Час аварії — випадковий час доби, створений через CHECKSUM(NEWID()) % 86400.
— Location — текст "Location #" з номером ітерації, наприклад: "Location #500".
— Victim_Count — випадкове число від 0 до 4.
— Accident_Type — випадкове значення з трьох варіантів: Collision, Hit або Other.
— Investigation_Status — випадкове значення: Open або Closed.
5.	SET @i += 1;
— Збільшує лічильник циклу.
6.	COMMIT TRANSACTION;
— Завершує транзакцію і зберігає всі 10 000 записів у базі.
Завдяки цій транзакції таблиця Accident стає багаторядковою, і її можна використовувати для тестування масштабованості, індексації або складних запитів у майбутньому.

 
 ![image](https://github.com/user-attachments/assets/fee9a3a1-08e7-4768-9933-1b534cfa8a2a)
![image](https://github.com/user-attachments/assets/4f703468-de98-4f67-b5d4-ae19c3508754)

Рисунок  9-10 – виконання завдання 6.

Завдання 7. У рамках виконання лабораторної роботи я здійснила транзакцію, яка передбачала модифікацію однієї з наявних процедур у базі даних. Метою цієї транзакції було додавання виведення тимчасових міток (timestamp) на початку та в кінці виконання функції з метою фіксації часу її роботи. Це дозволяє оцінити продуктивність функції, а також виявити можливі затримки або неефективності під час її виконання.

Лістинг коду :
CREATE OR ALTER PROCEDURE dbo.InsertAccident
    @Date DATE,
    @Time TIME,
    @Location VARCHAR(100),
    @Victim_Count INT,
    @Accident_Type VARCHAR(50),
    @Investigation_Status VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME2 = SYSDATETIME();
    PRINT 'Procedure InsertAccident started at: ' + CONVERT(VARCHAR, @StartTime, 121);
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
        VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Error in InsertAccident: ' + @ErrorMessage;
        THROW;
    END CATCH
    
    DECLARE @EndTime DATETIME2 = SYSDATETIME();
    PRINT 'Procedure InsertAccident ended at: ' + CONVERT(VARCHAR, @EndTime, 121);
    
    DECLARE @Duration INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);
    PRINT 'Total execution time: ' + CAST(@Duration AS VARCHAR) + ' ms';
END;
Пояснення до коду:
У цій збереженій процедурі InsertAccident відбувається вставка нової інформації про аварію до таблиці Accident. На початку та в кінці процедури виводяться тимчасові мітки, щоб зафіксувати час початку і завершення її виконання.
•	@StartTime — час початку виконання.
•	BEGIN TRANSACTION — початок транзакції.
•	INSERT — вставка даних у таблицю.
•	TRY...CATCH — обробка помилок: якщо сталася помилка, виконується ROLLBACK і виводиться повідомлення.
•	@EndTime — час завершення.
•	@Duration — обчислюється тривалість виконання в мілісекундах.
Таким чином, ця процедура не тільки додає новий запис, а й дозволяє відстежити продуктивність її виконання.
  
   ![image](https://github.com/user-attachments/assets/6bd3ac4e-f118-4f3f-a532-20b248d5b501)

Рисунок 11 – виконання завдання 7.


Завдання 8. 
У цьому завданні я створила таблицю, яка містить результати вимірювання часу виконання різних варіантів одного й того ж складного запиту. Запит виконується по таблиці з великою кількістю рядків, і я порівнювала час виконання в різних умовах: без індексів, з індексами, а також з використанням курсорів.

№	Опис запуску п/п	Час виконання запиту
1	Запуск п/п за таблицею (з великою кількістю рядків)	2276 мс
2	Запуск з Index таблицею (оптимізований той же самий запит до цієї ж таблиці)	2245 мс
3	З використанням Cursor1 п.8 (Виконання того ж самого запиту засобами курсорів)	2523 мс
4	З використанням Cursor2 п.9 (Виконання того ж самого запиту засобами курсорів)	2586 мс
5	З використанням Cursor2 п.10 (Виконання того ж самого запиту засобами курсорів)	2442 мс
Таблиця 1. Час виконання запитів

Лістинг коду :
-- Створення таблиці для результатів (якщо ще не існує)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QueryExecutionTimes')
BEGIN
    CREATE TABLE QueryExecutionTimes (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        QueryType VARCHAR(50) NOT NULL,
        ExecutionTimeMs INT NOT NULL,
        ExecutionDateTime DATETIME2 DEFAULT SYSDATETIME()
    );
END

-- Завдання 8: Запит без індексів
DECLARE @StartTime1 DATETIME2 = SYSDATETIME();

-- Складний запит з JOIN, фільтрацією, сортуванням
SELECT 
    a.ID_Accident,
    a.Date,
    a.Time,
    a.Location,
    a.Accident_Type,
    d.LastName + ' ' + d.FirstName AS DriverName,
    v.License_Plate,
    p.LastName + ' ' + p.FirstName AS PolicemanName,
    c.Type AS CulpritType
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
JOIN Driver_Involvement di ON a.ID_Accident = di.ID_Accident
JOIN Driver d ON di.ID_Driver = d.ID_Driver
JOIN Policeman p ON a.ID_Accident = p.ID_Accident
LEFT JOIN Culprit c ON a.ID_Accident = c.ID_Accident
WHERE a.Date BETWEEN '2020-01-01' AND '2024-12-31'
  AND a.Accident_Type = 'Rear-end'
ORDER BY a.Date DESC, a.Time DESC;

DECLARE @EndTime1 DATETIME2 = SYSDATETIME();
DECLARE @Duration1 INT = DATEDIFF(MILLISECOND, @StartTime1, @EndTime1);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Basic query without indexes', @Duration1);
Пояснення до коду:
У цьому коді я реалізувала тестування часу виконання складного SQL-запиту без індексів на таблицях, які містять багато даних.
•	Спершу створюється таблиця QueryExecutionTimes, якщо вона ще не існує. Вона потрібна для збереження результатів вимірювання часу виконання різних запитів. Таблиця містить унікальний ідентифікатор, тип запиту, час виконання в мілісекундах та дату і час виконання.
•	Потім я запускаю складний SELECT-запит, який включає кілька JOIN між таблицями Accident, Vehicle, Driver_Involvement, Driver, Policeman та Culprit. Запит фільтрує дані за датою та типом аварії, і сортує їх за датою і часом у спадному порядку.
•	Для вимірювання часу я фіксую момент початку виконання запиту в змінну @StartTime1 та момент закінчення у @EndTime1. Різницю в мілісекундах записую в змінну @Duration1.
•	Наприкінці час виконання та опис запиту записую у таблицю QueryExecutionTimes для подальшого аналізу.
Таким чином, цей код допомагає оцінити продуктивність запиту без оптимізацій, а також створити базу для порівняння з іншими варіантами запитів (з індексами, з курсорами і т.д.). Це важливо для розуміння ефективності роботи з великою кількістю даних.


![image](https://github.com/user-attachments/assets/868ea8ca-d730-4e37-9098-2a31beb1d78a)
![image](https://github.com/user-attachments/assets/4ade4282-4234-482a-9adf-2154da29361b)

  Рисунок 12-13 – виконання завдання 8.

  
Завдання 9. 
У цьому завданні я виконую оптимізацію складного SQL-запиту, що працює з великою кількістю даних, за допомогою створення індексів. В першій частині було виміряно час виконання запиту без використання індексів. У другій частині — додаються індекси відповідно до параметрів запиту, і час виконання заміряється повторно. Метою є показати, наскільки індекси покращують продуктивність вибірок з таблиць, які містять багато рядків, особливо при складних операціях JOIN, фільтрації та сортування.
Лістинг коду :
 -- Створення таблиці для результатів (якщо ще не існує)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'QueryExecutionTimes')
BEGIN
    CREATE TABLE QueryExecutionTimes (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        QueryType VARCHAR(50) NOT NULL,
        ExecutionTimeMs INT NOT NULL,
        ExecutionDateTime DATETIME2 DEFAULT SYSDATETIME()
    );
END

-- Завдання 8: Запит без індексів
DECLARE @StartTime1 DATETIME2 = SYSDATETIME();

-- Складний запит з JOIN, фільтрацією, сортуванням
SELECT 
    a.ID_Accident,
    a.Date,
    a.Time,
    a.Location,
    a.Accident_Type,
    d.LastName + ' ' + d.FirstName AS DriverName,
    v.License_Plate,
    p.LastName + ' ' + p.FirstName AS PolicemanName,
    c.Type AS CulpritType
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
JOIN Driver_Involvement di ON a.ID_Accident = di.ID_Accident
JOIN Driver d ON di.ID_Driver = d.ID_Driver
JOIN Policeman p ON a.ID_Accident = p.ID_Accident
LEFT JOIN Culprit c ON a.ID_Accident = c.ID_Accident
WHERE a.Date BETWEEN '2020-01-01' AND '2024-12-31'
  AND a.Accident_Type = 'Rear-end'
ORDER BY a.Date DESC, a.Time DESC;

DECLARE @EndTime1 DATETIME2 = SYSDATETIME();
DECLARE @Duration1 INT = DATEDIFF(MILLISECOND, @StartTime1, @EndTime1);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Basic query without indexes', @Duration1);

-- Завдання 9: Створення індексів та повторний запит
CREATE NONCLUSTERED INDEX IDX_Accident_Date_Type ON Accident(Date, Accident_Type);
CREATE NONCLUSTERED INDEX IDX_Vehicle_Accident ON Vehicle(ID_Accident);
CREATE NONCLUSTERED INDEX IDX_DriverInvolvement_Accident ON Driver_Involvement(ID_Accident);

DECLARE @StartTime2 DATETIME2 = SYSDATETIME();

-- Той самий запит з індексами
SELECT 
    a.ID_Accident,
    a.Date,
    a.Time,
    a.Location,
    a.Accident_Type,
    d.LastName + ' ' + d.FirstName AS DriverName,
    v.License_Plate,
    p.LastName + ' ' + p.FirstName AS PolicemanName,
    c.Type AS CulpritType
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
JOIN Driver_Involvement di ON a.ID_Accident = di.ID_Accident
JOIN Driver d ON di.ID_Driver = d.ID_Driver
JOIN Policeman p ON a.ID_Accident = p.ID_Accident
LEFT JOIN Culprit c ON a.ID_Accident = c.ID_Accident
WHERE a.Date BETWEEN '2020-01-01' AND '2024-12-31'
  AND a.Accident_Type = 'Rear-end'
ORDER BY a.Date DESC, a.Time DESC;

DECLARE @EndTime2 DATETIME2 = SYSDATETIME();
DECLARE @Duration2 INT = DATEDIFF(MILLISECOND, @StartTime2, @EndTime2);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Optimized query with indexes', @Duration2);

Пояснення до коду:
•	Спочатку створюється таблиця QueryExecutionTimes (якщо вона ще не існує) для збереження результатів вимірювання часу виконання різних варіантів запитів. Це дає змогу порівняти ефективність без індексів і з індексами.
•	У першій частині коду я запускаю складний SELECT-запит без індексів. Запит з’єднує таблиці Accident, Vehicle, Driver_Involvement, Driver, Policeman і Culprit. Виконується фільтрація за датою і типом аварії, а також сортування за датою і часом у спадному порядку. Час початку і закінчення запиту фіксується, після чого розраховується тривалість у мілісекундах і зберігається у таблиці результатів.
•	Далі створюються не кластеризовані індекси на колонках, які активно використовуються в умовах фільтрації та зв’язках (Date, Accident_Type, ID_Accident). Це робить пошук і з’єднання даних швидшими, бо СУБД може швидко орієнтуватися у великих таблицях.
•	Після створення індексів повторно виконується той самий складний запит. Час виконання також фіксується і заноситься у таблицю результатів, але вже з позначкою, що це оптимізований запит.
•	Таким чином, у таблиці QueryExecutionTimes будуть два рядки: один із часом виконання запиту без індексів, інший — з індексами. Це дозволить наочно порівняти вплив індексів на продуктивність.


 ![image](https://github.com/user-attachments/assets/62a79a5c-0bfa-4827-90f6-8a238e22679d)
![image](https://github.com/user-attachments/assets/2063ed6b-93c5-4635-9cdc-db87d36d24c7)
![image](https://github.com/user-attachments/assets/4ee769fa-3bfb-4360-99d4-4c8f43594968)


  Рисунок  14-16– виконання завдання 9.

  
Завдання 10-11. 
У рамках виконання завдань 10 та 11 було реалізовано складний запит з використанням курсорів T-SQL. Метою було додати результат виконання цього запиту у третій, четвертий та п’ятий рядок зведеної таблиці, яка фіксує часи виконання різних варіантів запитів. Запит повинен повністю відтворювати логіку попередніх складних SELECT-запитів із кількома JOIN, фільтрацією та сортуванням. Використання курсорів допомогло поетапно опрацьовувати рядки результату, що є корисним для подальшого детального аналізу та виводу інформації.
Особливо важливо було перевірити, як працюватиме курсор при повторному відкритті без звільнення пам’яті (DEALLOCATE), що розглянуто у завданні 11. Це дозволило порівняти часи виконання та ефективність різних підходів, а також краще зрозуміти особливості роботи курсорів у T-SQL.

Лістинг коду :

-- Завдання 10: Перше виконання курсором
DECLARE @CursorStartTime1 DATETIME2 = SYSDATETIME();

DECLARE AccidentCursor CURSOR LOCAL FOR
SELECT 
    a.ID_Accident,
    a.Date,
    a.Time,
    a.Location,
    a.Accident_Type,
    d.LastName + ' ' + d.FirstName AS DriverName,
    v.License_Plate,
    p.LastName + ' ' + p.FirstName AS PolicemanName,
    c.Type AS CulpritType
FROM Accident a
JOIN Vehicle v ON a.ID_Accident = v.ID_Accident
JOIN Driver_Involvement di ON a.ID_Accident = di.ID_Accident
JOIN Driver d ON di.ID_Driver = d.ID_Driver
JOIN Policeman p ON a.ID_Accident = p.ID_Accident
LEFT JOIN Culprit c ON a.ID_Accident = c.ID_Accident
WHERE a.Date BETWEEN '2020-01-01' AND '2024-12-31'
  AND a.Accident_Type = 'Rear-end'
ORDER BY a.Date DESC, a.Time DESC;

OPEN AccidentCursor;

DECLARE 
    @ID_Accident INT,
    @Date DATE,
    @Time TIME,
    @Location VARCHAR(100),
    @Accident_Type VARCHAR(50),
    @DriverName VARCHAR(200),
    @License_Plate VARCHAR(50),
    @PolicemanName VARCHAR(200),
    @CulpritType VARCHAR(50);

-- Додано виведення заголовків
PRINT 'ID_Accident | Date       | Time     | Location          | Accident_Type | DriverName       | License_Plate | PolicemanName    | CulpritType';
PRINT '-----------------------------------------------------------------------------------------------------------------------------------';

FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Виведення даних у консоль
    PRINT FORMAT(@ID_Accident, '00000') + ' | ' + 
          CONVERT(VARCHAR(10), @Date, 120) + ' | ' + 
          CONVERT(VARCHAR(8), @Time) + ' | ' + 
          LEFT(@Location, 15) + '... | ' + 
          LEFT(@Accident_Type, 13) + ' | ' + 
          LEFT(@DriverName, 15) + ' | ' + 
          LEFT(@License_Plate, 13) + ' | ' + 
          LEFT(@PolicemanName, 15) + ' | ' + 
          ISNULL(@CulpritType, 'NULL');
    
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;

DECLARE @CursorEndTime1 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration1 INT = DATEDIFF(MILLISECOND, @CursorStartTime1, @CursorEndTime1);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (first run)', @CursorDuration1);

-- Завдання 11: Друге виконання без DEALLOCATE
DECLARE @CursorStartTime2 DATETIME2 = SYSDATETIME();

OPEN AccidentCursor;
FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

PRINT CHAR(13) + CHAR(10) + 'Second run results:';
PRINT '-----------------------------------------------------------------------------------------------------------------------------------';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT FORMAT(@ID_Accident, '00000') + ' | ' + 
          CONVERT(VARCHAR(10), @Date, 120) + ' | ' + 
          CONVERT(VARCHAR(8), @Time) + ' | ' + 
          LEFT(@Location, 15) + '... | ' + 
          LEFT(@Accident_Type, 13) + ' | ' + 
          LEFT(@DriverName, 15) + ' | ' + 
          LEFT(@License_Plate, 13) + ' | ' + 
          LEFT(@PolicemanName, 15) + ' | ' + 
          ISNULL(@CulpritType, 'NULL');
    
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;

DECLARE @CursorEndTime2 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration2 INT = DATEDIFF(MILLISECOND, @CursorStartTime2, @CursorEndTime2);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (second run)', @CursorDuration2);

-- Третє виконання з DEALLOCATE
DECLARE @CursorStartTime3 DATETIME2 = SYSDATETIME();

OPEN AccidentCursor;
FETCH NEXT FROM AccidentCursor INTO 
    @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
    @DriverName, @License_Plate, @PolicemanName, @CulpritType;

PRINT CHAR(13) + CHAR(10) + 'Third run results:';
PRINT '-----------------------------------------------------------------------------------------------------------------------------------';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT FORMAT(@ID_Accident, '00000') + ' | ' + 
          CONVERT(VARCHAR(10), @Date, 120) + ' | ' + 
          CONVERT(VARCHAR(8), @Time) + ' | ' + 
          LEFT(@Location, 15) + '... | ' + 
          LEFT(@Accident_Type, 13) + ' | ' + 
          LEFT(@DriverName, 15) + ' | ' + 
          LEFT(@License_Plate, 13) + ' | ' + 
          LEFT(@PolicemanName, 15) + ' | ' + 
          ISNULL(@CulpritType, 'NULL');
    
    FETCH NEXT FROM AccidentCursor INTO 
        @ID_Accident, @Date, @Time, @Location, @Accident_Type, 
        @DriverName, @License_Plate, @PolicemanName, @CulpritType;
END

CLOSE AccidentCursor;
DEALLOCATE AccidentCursor;

DECLARE @CursorEndTime3 DATETIME2 = SYSDATETIME();
DECLARE @CursorDuration3 INT = DATEDIFF(MILLISECOND, @CursorStartTime3, @CursorEndTime3);

INSERT INTO QueryExecutionTimes (QueryType, ExecutionTimeMs)
VALUES ('Cursor implementation (third run)', @CursorDuration3);

PRINT CHAR(13) + CHAR(10) + 'Execution times:';
PRINT '1. First run: ' + CAST(@CursorDuration1 AS VARCHAR) + ' ms';
PRINT '2. Second run: ' + CAST(@CursorDuration2 AS VARCHAR) + ' ms';
PRINT '3. Third run: ' + CAST(@CursorDuration3 AS VARCHAR) + ' ms';
Пояснення до коду:
У коді реалізовано три основні етапи виконання запиту:
1.	Перше виконання курсором (Завдання 10)
Спочатку курсор створюється та відкривається, після чого послідовно проходить по всіх рядках, отриманих зі складного SELECT-запиту з кількома JOIN-операціями, фільтрацією за датою та типом аварії, а також сортуванням за датою і часом. Для кожного рядка дані виводяться у консоль за допомогою команди PRINT у форматованому вигляді. Після завершення проходження курсор закривається, а час виконання фіксується і заноситься у таблицю QueryExecutionTimes.
2.	Друге виконання курсором без DEALLOCATE (Завдання 11, перша частина)
Тут курсор повторно відкривається без звільнення ресурсів командою DEALLOCATE. Цей підхід дозволяє використати вже існуючий курсор, не створюючи його заново. Аналогічно першому разу, результати виводяться у консоль, а час виконання також заноситься у таблицю.
3.	Третє виконання курсором з DEALLOCATE (Завдання 11, друга частина)
Для порівняння та закріплення правильності роботи курсор закривається і звільняється після виконання (через DEALLOCATE). Цей підхід є рекомендованим для уникнення утечок пам’яті. Результати та час виконання також зберігаються у таблиці.
Кожен із трьох запусків відтворює однаковий набір даних, що дозволяє порівнювати їх продуктивність. Такий підхід допомагає глибше зрозуміти, як курсори впливають на продуктивність запитів у SQL Server, а також дає практичні навички роботи з ними.


   ![image](https://github.com/user-attachments/assets/053c1b19-24fd-49b5-976e-bb60e409da80)
![image](https://github.com/user-attachments/assets/233e3f8a-01cc-4181-9f56-579d6485fea0)
![image](https://github.com/user-attachments/assets/c925aa53-26a1-4782-a65a-ab66f2972e8d)

Рисунок  17-19– виконання завдання 10-11.


Завдання 12. Порівняйте час виконання запитів у зведеній таблиці. Проаналізуйте результати. Яким чином можна прискорити виконання запитів? Який тип запитів може прискорити цей час? В яких випадках потрібно використовувати курсори?

Лістинг коду :
-- Виведення результатів для аналізу
SELECT 
    ID,
    QueryType AS 'Тип запиту',
    ExecutionTimeMs AS 'Час виконання (мс)',
    ExecutionDateTime AS 'Дата виконання'
FROM QueryExecutionTimes
ORDER BY ID;

-- Аналіз результатів
SELECT 
    ' The fastest query' AS Аналіз,
    QueryType AS 'Тип запиту',
    ExecutionTimeMs AS 'Час (мс)'
FROM QueryExecutionTimes
WHERE ExecutionTimeMs = (SELECT MIN(ExecutionTimeMs) FROM QueryExecutionTimes)
UNION ALL
SELECT 
    'The slowest query',
    QueryType,
    ExecutionTimeMs
FROM QueryExecutionTimes
WHERE ExecutionTimeMs = (SELECT MAX(ExecutionTimeMs) FROM QueryExecutionTimes);
Пояснення до коду:
Аналіз результатів
1.	Basic query without indexes:
o	Середній час ≈ 2288 мс.
o	Очікувано довший, оскільки БД сканує таблицю повністю (table scan).
2.	Cursor implementation:
o	Всі три запуски показали час понад 2400 мс (в середньому ≈ 2517 мс).
o	Найгірший результат серед усіх. Курсори обробляють кожен рядок по черзі, що суттєво уповільнює виконання.
3.	Optimized query with indexes:
o	Найшвидший запит: 2245 мс.
o	Індекси зменшують кількість рядків, які потрібно переглядати, що значно прискорює вибірку.
Під час виконання порівняння різних типів запитів було виявлено, що найшвидше виконується оптимізований запит з використанням індексів — його час становив 2245 мс. Це найменший показник серед усіх тестів. Для порівняння, базовий запит без індексів виконувався трохи довше: 2276 мс та 2301 мс відповідно у двох запусках. Очевидно, що на продуктивність безпосередньо впливає наявність індексів, оскільки вони дозволяють скоротити кількість оброблюваних рядків та зменшити навантаження на систему.
Найгірші результати показали запити, реалізовані за допомогою курсорів. Їхній час коливався від 2442 мс до 2586 мс. Це пов’язано з тим, що курсори обробляють дані поелементно, тобто по одному рядку, що значно знижує ефективність у порівнянні з пакетною обробкою в SQL.
Щоб прискорити виконання запитів, перш за все слід впроваджувати індекси для колонок, які часто використовуються у фільтрації, сортуванні та об’єднаннях таблиць. Також варто уникати курсорів у тих випадках, коли можна обійтися операціями над наборами даних, такими як об’єднання (JOIN), віконні функції або CTE. Системи управління базами даних оптимізовані саме для роботи з наборами, тому це дає значний приріст продуктивності.
Курсори доцільно використовувати лише тоді, коли обробка даних вимагає покрокового проходження по рядках і логіки, яку неможливо реалізувати стандартними SQL-запитами. Це можуть бути ситуації, коли для кожного запису потрібно виконати унікальний обчислювальний процес або взаємодію із зовнішніми системами. Проте в загальному випадку краще уникати їх застосування, оскільки вони сповільнюють виконання запитів.

 ![image](https://github.com/user-attachments/assets/a3caffd5-3837-4799-9570-e24b0d99c220)

  Рисунок  20 – виконання завдання 12.

  
Висновки:
Виконання цієї лабораторної роботи допомогло мені закріпити практичні навички роботи з транзакціями в Microsoft SQL Server. Я навчилася створювати транзакції з використанням умовного виконання, перевірки помилок через @@ERROR та конструкції TRY...CATCH, що дозволяє контролювати цілісність даних і обробляти помилки під час виконання запитів. Додавання великої кількості рядків до таблиць показало, як змінюється продуктивність при роботі з великими обсягами інформації.
Також я порівняла час виконання складних запитів із використанням індексів і курсорів, що дало змогу оцінити їх вплив на швидкість обробки даних. Результати показали, що індекси значно пришвидшують виконання, тоді як курсори варто застосовувати лише для поелементної обробки, коли це дійсно необхідно. Загалом робота дала мені розуміння, як оптимізувати запити і забезпечувати надійність роботи бази даних.

Посилання на конспект:
https://docs.google.com/document/d/1cQ80CNWDVrDLPALv9pUK2ATEX58BABgg/edit?usp=drive_link&ouid=106130475242017779182&rtpof=true&sd=true

