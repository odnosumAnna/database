                                                 Лабораторна робота 4
                                 на тему: «Вивчення DML на прикладі створення функцій для роботи з БД.»
                                 
Мета роботи: Метою даної роботи є ознайомлення з концепцією функцій у MSSQL, зокрема скалярних та віконних функцій, та їх застосування у практичних запитах. Робота передбачає вивчення можливостей скалярних функцій для обробки та трансформації даних у базах даних..

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


Завдання 3. Скалярний тип функцій

Функції:
-- 1. Власна функція для формування П.І.Б. водія
CREATE FUNCTION dbo.GetDriverFullName
(
    @LastName VARCHAR(50),
    @FirstName VARCHAR(50),
    @MiddleName VARCHAR(50)
)
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN @LastName + ' ' + LEFT(@FirstName, 1) + '.' + LEFT(@MiddleName, 1) + '.'
END;

--2. Власна функція для перевірки прострочення водійського посвідчення
CREATE FUNCTION dbo.CheckLicenseStatus
(
    @ExpiryDate DATE
)
RETURNS VARCHAR(20)
AS
BEGIN
    IF @ExpiryDate < GETDATE()
        RETURN 'Expired';
    RETURN 'True';
END;

-- 3. Власна функція для класифікації рівня травмування
CREATE FUNCTION dbo.ClassifyInjurySeverity
(
    @Severity VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Result VARCHAR(20);

	-- Перетворюємо Severity на верхній регістр для уніфікації
    SET @Severity = UPPER(@Severity);

    SET @Result = 
        CASE 
            WHEN @Severity IN ('Mild', 'Light') THEN 'Mild'
            WHEN @Severity IN ('Moderate', 'Medium') THEN 'Moderate'
            WHEN @Severity IN ('Severe', 'Critical', 'Heavy') THEN 'Severe'
            ELSE 'Unknown'
        END;
    RETURN @Result;
END;
Запити

-- 1. Власна функція для формування П.І.Б. водія
SELECT 
    dbo.GetDriverFullName(LastName, FirstName, MiddleName) AS FullName,
    License_Number
FROM Driver;

--2. Власна функція для перевірки прострочення водійського посвідчення
SELECT 
    LastName,
    FirstName,
    License_Number,
    dbo.CheckLicenseStatus(License_Expiry) AS License_Status
FROM Driver;

--3. Власна функція для класифікації рівня травмування
SELECT 
    LastName,
    FirstName,
    Injury_Type,
    dbo.ClassifyInjurySeverity(Severity) AS Severity_Level
FROM Victim;

Пояснення:

Власна функція для формування П.І.Б. водія:

•	Функція: dbo.GetDriverFullName приймає три параметри: Прізвище, Ім'я та По батькові. Вона повертає сформовану строку у вигляді "Прізвище І. П." (LEFT(): для отримання першої літери імені та по батькові.).
•	Запит: Для кожного водія з таблиці Driver виводиться його повне ім'я за допомогою цієї функції.

Власна функція для перевірки прострочення водійського посвідчення:

•	Функція: dbo.CheckLicenseStatus приймає дату закінчення терміну дії посвідчення і порівнює її з поточною датою за допомогою вбудованої функції GETDATE(). Якщо посвідчення прострочене, функція повертає 'Expired', інакше — 'True'.
•	Запит: Для кожного водія з таблиці Driver виводиться його статус посвідчення.

Власна функція для класифікації рівня травмування:

•	Функція: dbo.ClassifyInjurySeverity приймає рівень травмування (стрічка) і класифікує його на три категорії: "Mild" (легкий), "Moderate" (середній), "Severe" (важкий). Якщо значення не підходить під жодну з категорій, повертається 'Unknown' (UPPER(): для перетворення рівня травмування на верхній регістр для уніфікації порівнянь.).
•	Запит: Для кожної жертви з таблиці Victim виводиться її категорія травмування за допомогою цієї функції.

![image](https://github.com/user-attachments/assets/f0606875-ff0d-4a71-b515-436b0ee88c3c)
![image](https://github.com/user-attachments/assets/61aff2a4-832b-4e74-a593-f5ef87061774)


Завдання 4. Inline тип функцій

Функції:
--1. Власна функція для перевірки статусу ДТП:
CREATE FUNCTION CheckAccidentStatus (@accident_id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT Investigation_Status  
    FROM [DAI].[dbo].[Accident]  
    WHERE ID_Accident = @accident_id  
);

--2. Власна функція для виведення імені міліціонера за званням:
CREATE FUNCTION dbo.GetPolicemanName (@Rank VARCHAR(30), @LastName VARCHAR(50), @FirstName VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT @Rank + ' ' + @LastName + ' ' + LEFT(@FirstName, 1) + '.' AS PolicemanName
);
--3. Власна функція для перевірки, чи є водій у списку постраждалих:
CREATE FUNCTION dbo.IsDriverVictim (@DriverID INT, @AccidentID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM Victim 
                    WHERE ID_Accident = @AccidentID AND ID_Victim = @DriverID
                ) 
                THEN 1 
                ELSE 0 
            END AS IsVictim
);

Запити:
--1. Власна функція для перевірки статусу ДТП:
SELECT 
    ID_Accident, 
    Accident.Investigation_Status AS Accident_Status
FROM [DAI].[dbo].[Accident]
CROSS APPLY dbo.CheckAccidentStatus(ID_Accident);

--2. Власна функція для виведення імені міліціонера за званням:
SELECT 
    Policeman.ID_Policeman, 
    Policeman.Rank, 
    Policeman.LastName, 
    Policeman.FirstName,
    Name.PolicemanName
FROM Policeman
CROSS APPLY dbo.GetPolicemanName(Policeman.Rank, Policeman.LastName, Policeman.FirstName) AS Name;

--3. Власна функція для перевірки, чи є водій у списку постраждалих:
SELECT 
    Driver.LastName,
    Driver.FirstName,
    DriverVictim.IsVictim
FROM Driver
JOIN Driver_Involvement ON Driver.ID_Driver = Driver_Involvement.ID_Driver
CROSS APPLY dbo.IsDriverVictim(Driver.ID_Driver, Driver_Involvement.ID_Accident) AS DriverVictim
WHERE Driver_Involvement.ID_Accident = 1;

Пояснення:

Власна функція для перевірки статусу ДТП:

•	Функція: dbo.CheckAccidentStatus приймає параметр @accident_id, який є ідентифікатором ДТП. Функція перевіряє, який статус має конкретне ДТП, зберігаючи його у таблиці Accident. Повертається значення поля Investigation_Status для відповідного ДТП.
•	Запит: У запиті використовується функція для того, щоб для кожного запису в таблиці Accident вивести відповідний статус розслідування ДТП. Використовується конструкція CROSS APPLY для застосування функції до кожного рядка таблиці Accident.

Власна функція для виведення імені міліціонера за званням:

•	Функція: dbo.GetPolicemanName приймає три параметри: @Rank (звання), @LastName (прізвище) та @FirstName (ім'я). Функція формує повне ім'я міліціонера у форматі "Звання Прізвище І." (де І — це перша буква імені міліціонера).
•	Запит: Для кожного міліціонера з таблиці Policeman запит виводить повне ім'я у зазначеному форматі, застосовуючи функцію через CROSS APPLY.

Власна функція для перевірки, чи є водій у списку постраждалих:

•	Функція: dbo.IsDriverVictim приймає два параметри: @DriverID (ідентифікатор водія) та @AccidentID (ідентифікатор ДТП). Функція перевіряє наявність водія в таблиці Victim для вказаного ДТП, повертаючи 1, якщо водій є постраждалим, і 0, якщо не є.
•	Запит: Запит для кожного водія з таблиці Driver, який залучений до конкретного ДТП, виводить інформацію, чи є він постраждалим, використовуючи функцію через CROSS APPLY.

![image](https://github.com/user-attachments/assets/68154241-7e69-42a4-9591-46c248363010)

Завдання 5. Multistate тип функцій
Функції:

--1. Multistate функція для класифікації ДТП за кількістю постраждалих:
CREATE FUNCTION dbo.ClassifyAccidentByVictimCount
(
    @VictimCount INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT CASE
            WHEN @VictimCount = 0 THEN 'No Victims'
            WHEN @VictimCount BETWEEN 1 AND 2 THEN 'Minor Accident'
            WHEN @VictimCount BETWEEN 3 AND 5 THEN 'Moderate Accident'
            ELSE 'Severe Accident'
           END AS Severity
)
--2. Multistate функція для визначення, чи є водій винуватцем (або пішоходом):
CREATE FUNCTION dbo.IsCulprit
(
    @ID_Culprit INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT CASE
            WHEN Type = 'Driver' THEN 'Driver'
            WHEN Type = 'Pedestrian' THEN 'Pedestrian'
            ELSE 'Unknown'
           END AS CulpritType
    FROM Culprit
    WHERE ID_Culprit = @ID_Culprit
)

--3. Multistate функція для визначення найбільш серйозної травми постраждалого:
CREATE FUNCTION dbo.GetInjuryDate
(
    @InjuryType VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT Hospitalization_Status
    FROM Victim
    WHERE Injury_Type = @InjuryType
    AND Severity = (SELECT MAX(Severity) FROM Victim WHERE Injury_Type = @InjuryType)
)
Запити:

--1. Multistate функція для класифікації ДТП за кількістю постраждалих:
SELECT 
    ID_Accident, 
    Severity
FROM Accident
CROSS APPLY dbo.ClassifyAccidentByVictimCount(Victim_Count);

--2. Multistate функція для визначення, чи є водій винуватцем (або пішоходом):
SELECT 
    Driver.LastName,
    Driver.FirstName,
    CulpritType
FROM Driver
JOIN Culprit ON Driver.ID_Driver = Culprit.ID_Related
CROSS APPLY dbo.IsCulprit(ID_Culprit);

--3. Multistate функція для визначення найбільш серйозної травми постраждалого:
SELECT 
    v.Injury_Type,
    v.Hospitalization_Status
FROM Victim v
CROSS APPLY dbo.GetInjuryDate(v.Injury_Type) AS g;

Пояснення:

Власна функція для класифікації ДТП за кількістю постраждалих:
VictimCount, який є кількістю постраждалих у ДТП. Функція класифікує ДТП залежно від кількості постраждалих, визначаючи ступінь серйозності події. Повертається значення, яке вказує на ступінь серйозності (наприклад, "Minor Accident", "Moderate Accident", "Severe Accident").
•	Запит: У запиті використовується функція для кожного запису в таблиці Accident, щоб вивести відповідний ступінь серйозності для кожного ДТП. Використовується конструкція CROSS APPLY, щоб застосувати функцію до кожного рядка таблиці Accident.

Власна функція для визначення, чи є водій винуватцем або пішоходом:

•	Функція: dbo.IsCulprit приймає параметр @ID_Culprit, який є ідентифікатором винуватця. Функція перевіряє, чи є винуватець водієм чи пішоходом, повертаючи відповідний тип ("Driver" або "Pedestrian").
•	Запит: Для кожного водія або пішохода з таблиці Culprit, запит виводить інформацію про тип винуватця, використовуючи функцію через CROSS APPLY.

Власна функція для визначення найбільш серйозної травми постраждалого:

•	Функція: dbo.GetInjuryDate приймає параметр @InjuryType, який є типом травми. Функція повертає статус госпіталізації для найбільш серйозної травми постраждалого з цією травмою.
•	Запит: У запиті для кожного постраждалого з таблиці Victim виводиться тип травми та статус госпіталізації, використовуючи функцію через CROSS APPLY.

![image](https://github.com/user-attachments/assets/ca28c041-c606-44d5-bf65-3f417012e641)
![image](https://github.com/user-attachments/assets/90968d3c-f1c9-4680-94dd-bb346a272207)

Завдання 6. Запити варіанта ДАІ

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
•	Видалити відомості про ДТП, які сталися раніше вказаної дати

Функції:
--1. Вивести повний список ДТП, які виникли з вини пішоходів за вказаний період з повними відомостями про них:
CREATE FUNCTION dbo.GetAccidentsByPedestrians
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        A.ID_Accident,
        A.Date,
        A.Location,
        A.Victim_Count,
        A.Accident_Type,
        C.Type AS CulpritType
    FROM Accident A
    JOIN Culprit C ON A.ID_Accident = C.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
    AND C.Type = 'Pedestrian'
);

--2. Знайти місце, де сталася максимальна кількість ДТП:
CREATE FUNCTION dbo.GetMaxAccidentLocation()
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN (
        SELECT TOP 1 Location
        FROM Accident
        GROUP BY Location
        ORDER BY COUNT(ID_Accident) DESC
    );
END;

--3. Вивести повний список ДТП, на які виїжджали міліціонери із зазначеним званням за вказаний період часу, з повними відомостями про ДТП:
CREATE FUNCTION dbo.GetAccidentsWithPoliceInvolvement
(
    @StartDate DATE,
    @EndDate DATE,
    @Rank VARCHAR(50)
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        A.ID_Accident,
        A.Date,
        A.Location,
        A.Victim_Count,
        A.Accident_Type,
        P.Rank AS PoliceRank
    FROM Accident A
    JOIN Policeman P ON A.ID_Accident = P.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
    AND P.Rank = @Rank
);

--4. Скласти список водіїв, які брали участь більше ніж в одній ДТП за зазначений період часу з повними відомостями про цих водіїв:
CREATE FUNCTION dbo.GetDriversWithMultipleAccidents
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        D.LastName,
        D.FirstName,
        COUNT(DISTINCT DI.ID_Accident) AS AccidentCount
    FROM Driver D
    JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
    JOIN Accident A ON DI.ID_Accident = A.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
    GROUP BY D.LastName, D.FirstName
    HAVING COUNT(DISTINCT DI.ID_Accident) > 1
);

--5. Скласти список постраждалих у ДТП за вказаний період часу з повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду:
CREATE FUNCTION dbo.GetAccidentVictimsByInjuryType
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        A.ID_Accident,
        A.Date,
        A.Location,
        V.FirstName + ' ' + V.LastName AS VictimName,  -- Поєднання імені та прізвища
        V.Injury_Type,  -- Тип травми
        V.Severity  -- Ступінь важкості травми
    FROM Accident A
    JOIN Victim V ON A.ID_Accident = V.ID_Accident
    WHERE A.Date BETWEEN @StartDate AND @EndDate
);

--6 Внести відомості про нову ДТП;
CREATE PROCEDURE dbo.InsertAccident
(
    @Date DATE,
    @Location VARCHAR(100),
    @Victim_Count INT,
    @Accident_Type VARCHAR(50),
    @Investigation_Status VARCHAR(50) = NULL,  
    @Time DATETIME = NULL                     
)
AS
BEGIN
    -- Якщо час не переданий, використовуємо поточний час
    IF @Time IS NULL
    BEGIN
        SET @Time = GETDATE();
    END

    -- Вставляємо новий запис у таблицю Accident
    INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
    VALUES (@Date, @Time, @Location, @Victim_Count, @Accident_Type, @Investigation_Status);
END;

-- 7. Видалити відомості про ДТП, які сталися раніше вказаної дати:

CREATE PROCEDURE dbo.DeleteAccidentsBeforeDate
(
    @Date DATE
)
AS
BEGIN
    -- Спочатку видаляємо залежні записи з таблиці Vehicle
    DELETE FROM Vehicle
    WHERE ID_Accident IN (SELECT ID_Accident FROM Accident WHERE Date < @Date);

    -- Потім видаляємо залежні записи з таблиці Driver_Involvement
    DELETE FROM Driver_Involvement
    WHERE ID_Accident IN (SELECT ID_Accident FROM Accident WHERE Date < @Date);

    -- Тепер видаляємо записи з таблиці Accident
    DELETE FROM Accident
    WHERE Date < @Date;
END;
Запити:

-- 1. Вивести повний список ДТП, які виникли з вини пішоходів за вказаний період з повними відомостями про них:
SELECT * 
FROM dbo.GetAccidentsByPedestrians('2020-01-01', '2025-04-01');

-- 2. Знайти місце, де сталася максимальна кількість ДТП:
SELECT dbo.GetMaxAccidentLocation() AS MaxAccidentLocation;

-- 3. Вивести повний список ДТП, на які виїжджали міліціонери із зазначеним званням за вказаний період часу, з повними відомостями про ДТП:
SELECT * 
FROM dbo.GetAccidentsWithPoliceInvolvement('2020-01-01', '2025-04-01', 'Captain');

-- 4. Скласти список водіїв, які брали участь більше ніж в одній ДТП за зазначений період часу з повними відомостями про цих водіїв:
SELECT * 
FROM dbo.GetDriversWithMultipleAccidents('2020-01-01', '2025-04-01');

-- 5. Скласти список постраждалих у ДТП за вказаний період часу з повними відомостями про ці ДТП, упорядковані за кількістю травм певного виду:
SELECT * 
FROM dbo.GetAccidentVictimsByInjuryType('2020-01-01', '2025-04-01')
ORDER BY Injury_Type, Severity DESC;

-- 6. Внести відомості про нову ДТП:
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
VALUES ('2025-04-01', GETDATE(), 'Kyiv, Khreshchatyk St.', 3, 'Collision', 'Open');

Пояснення:
•	GetAccidentsByPedestrians: Виводить список ДТП, які сталися з вини пішоходів за вказаний період, з повними відомостями (дата, місце, кількість жертв, тип ДТП).
•	GetMaxAccidentLocation: Повертає місце з найбільшим числом ДТП за весь час.
•	GetAccidentsWithPoliceInvolvement: Виводить ДТП, у яких брали участь міліціонери із заданим званням в межах вказаного періоду.
•	GetDriversWithMultipleAccidents: Виводить список водіїв, які брали участь в більше ніж одній ДТП за вказаний період.
•	GetAccidentVictimsByInjuryType: Показує постраждалих у ДТП за вказаний період з детальними відомостями про тип і важкість травм, впорядкованих за типом травм.
•	InsertAccident: Додає нову ДТП в базу даних (з можливістю вказати дату, час, місце, кількість жертв та тип ДТП).
•	DeleteAccidentsBeforeDate: Видаляє всі ДТП та пов'язані з ними записи (автомобілі, водії) до зазначеної дати.

![image](https://github.com/user-attachments/assets/c8e243c3-2597-4205-8fe1-6bbd64e83391)


   Завдання 7. Аналіз продуктивності запитів у MS SQL за допомогою EXPLAIN (Execution Plan).
   
![image](https://github.com/user-attachments/assets/d0224925-4fb2-4610-a865-9a6ae8f7453c)
![image](https://github.com/user-attachments/assets/5ddcf72c-cfc1-499f-9cac-6a011eaad3ab)
![image](https://github.com/user-attachments/assets/f08f9abe-863a-4fdb-aa49-c602b4368204)
![image](https://github.com/user-attachments/assets/32488e2f-b81c-47d3-b037-09538c67e8bc)

Аналіз запитів завдання 3:

![image](https://github.com/user-attachments/assets/79177abc-7520-4eb8-a3c1-3a2d779361f7)

Аналіз запитів завдання 4:

![image](https://github.com/user-attachments/assets/f780af60-3d9c-4d8c-86eb-12df6bc521d4)

Аналіз запитів завдання 5:

![image](https://github.com/user-attachments/assets/5124aeac-cc94-4db4-a2fc-033ca0488f28)
![image](https://github.com/user-attachments/assets/bab34d39-0687-4665-a2d4-59b219673e46)

Висновки: 
У ході виконання роботи я досягла поставленої мети: ознайомилася з концепцією функцій у MSSQL, зокрема скалярних та віконних функцій, та їх застосування у практичних запитах. Робота передбачає вивчення можливостей скалярних функцій для обробки та трансформації даних у базах даних.
