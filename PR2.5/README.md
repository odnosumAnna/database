                                                 ПРАКТИЧНА РОБОТА №5
          	                         на тему: « Поняття індексів і робота з ними в MSSQL.»
                                 
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


Виконання завдання 2. 
Індекс у базі даних
Індекс у базі даних — це структура, яка дозволяє швидше знаходити та отримувати потрібні дані в таблиці.
Він працює подібно до змісту або алфавітного покажчика в книзі: замість того, щоб читати всю книгу сторінка за сторінкою, ми швидко переходимо до потрібного розділу через покажчик.
Коли немає індексу, база даних повинна переглядати всі рядки таблиці (це називається повне сканування таблиці), що займає багато часу при великих об'ємах даних.  Індекс скорочує цей процес, допомагаючи базі швидко знаходити потрібні рядки за певним критерієм.
Коли використовують індекси?
•	При частих запитах до бази даних за певними стовпцями (наприклад, пошук клієнтів за прізвищем).
•	При фільтрації, сортуванні або об'єднанні таблиць (WHERE, ORDER BY, JOIN).
Індекс прискорює пошук, але займає додаткову пам'ять і трохи сповільнює операції додавання/оновлення/видалення записів.
Кластеризований індекс
Кластеризований індекс змінює фізичний порядок записів у таблиці відповідно до значень індексу. Тобто дані таблиці зберігаються впорядковано за цим індексом.
•	У таблиці може бути тільки один кластеризований індекс, бо записи фізично можуть бути відсортовані лише один раз.
•	При запитах, які шукають діапазони значень (наприклад, дати від... до...), кластеризований індекс працює дуже ефективно.
•	При створенні первинного ключа (PRIMARY KEY) зазвичай автоматично створюється кластеризований індекс.
Приклад:
Таблиця замовлень впорядкована за датою замовлення. Шукати всі замовлення за певний місяць буде дуже швидко.
Некластеризований індекс
Некластеризований індекс створюється окремо від основної таблиці.
Він містить посилання (вказівники) на фізичне розташування рядків у таблиці, але не змінює порядок зберігання самих записів.
•	У таблиці можна створити кілька некластеризованих індексів на різні стовпці.
•	Некластеризований індекс підходить для пошуку окремих значень або для колонок, які часто використовуються у фільтрах.
•	Для знаходження даних за некластеризованим індексом спочатку шукається індекс, а потім йде звернення до таблиці за даними.
Приклад: Індекс на колонку "місто проживання клієнта", щоб швидко знайти всіх клієнтів із конкретного міста.
Порівняльна таблиця кластеризованого та некластеризованого індексу:

![image](https://github.com/user-attachments/assets/2d19ad5c-9f53-4bcf-b66f-2b2c0a20c553)

Виконання завдання 3. 
Для аналізу продуктивності запиту до великої таблиці без використання індексів я використала запит умови моєї предметної області: 

Лістинг коду 1:
--Вивести повний список ДТП, які виникли з вини пішоходів, за вказаний період з повними відомостями про них:
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.MiddleName AS Pedestrian_MiddleName,
       P.Address AS Pedestrian_Address, P.Passport_Number AS Pedestrian_Passport
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;
 
 
Рисунок 4-5  – виконання завдання 3.
Пояснення:
•	Clustered Index Scan на таблиці Pedestrian — читає всю таблицю, шукаючи записи, де Is_Victim = 1, оскільки немає відповідного індексу.
•	Clustered Index Seek на таблиці Accident — виконується ефективний пошук конкретних записів за ID_Accident під час з'єднання (JOIN).
•	Nested Loops (Inner Join) — використовується для з'єднання таблиць Accident і Pedestrian; добре працює для невеликої кількості даних.
•	Sort — сортування результатів за A.Date DESC, що вимагає додаткових ресурсів і займає найбільшу частину вартості запиту (41%).
•	Загальний Query cost: 100% (все навантаження припадає на цей запит).
Проблеми продуктивності:
•	Повне сканування таблиці Pedestrian (Clustered Index Scan) уповільнює запит через відсутність індексу за полем Is_Victim.
•	Сортування за датою (ORDER BY A.Date DESC) суттєво навантажує систему, особливо на великих об'ємах даних.
•	Використання Nested Loops на великих обсягах даних призводить до тривалого часу обробки.
Виконання завдання 4. 
Для виконання цього завдання  я використовую запити за умовою моєї предметної області , тобто SQL-запити, які використовують умови фільтрації (WHERE, ORDER BY, JOIN) для таблиць із великою кількістю записів.
Запити:
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
 
 
 
 
 
Рисунок 6-10  – виконання завдання 4
Пояснення:
1.	Запит на вивід ДТП із міліціонерами певного звання:
•	Використовується умова фільтрації по Po.Rank та по діапазону дат A.Date.
•	Проблема без індексів: без індексу система мусить переглядати всю таблицю Policeman і Accident, щоб знайти потрібні записи.
•	Чому потрібен індекс:
    -Індекс на Po.Rank прискорює пошук міліціонерів потрібного звання.
    -Індекс на A.Date дозволяє швидко відбирати ДТП в заданому періоді часу.
    -Індекс на ID_Accident оптимізує з'єднання JOIN.
2. Запит на водіїв, які були в більше ніж одній ДТП:
•	Підключено три таблиці (Driver, Driver_Involvement, Accident), використовується WHERE, GROUP BY і HAVING.
•	Проблема без індексів: без індексу об'єднання та групування будуть дуже повільними при великій кількості даних.
•	Чому потрібен індекс:
    - Індекс на A.Date швидко обмежує період ДТП.
     -Індекс на DI.ID_Driver та DI.ID_Accident пришвидшує об'єднання таблиць і підрахунок кількості ДТП на одного водія.

3. Запит на постраждалих і підрахунок кількості травм:
•	Використовується віконна функція COUNT() OVER, фільтрація по даті та сортування за кількістю травм.
•	Проблема без індексів: без індексу обчислення кількості травм для кожного виду стане повільним, бо треба переглядати всю таблицю.
•	Чому потрібен індекс:
- Індекс на v.Injury_Type оптимізує підрахунок кількості за типом травми.
- Індекс на a.Date дозволяє швидко вибрати ДТП за потрібний рік.
- Індекс на v.ID_Accident допомагає ефективно з'єднувати Victim і Accident.
Загальний висновок:
•	Індекси значно зменшують обсяг даних, які потрібно сканувати при виконанні запиту.
•	Вони скорочують час пошуку, фільтрації, об'єднання (JOIN) і сортування (ORDER BY).
•	При великих об'ємах даних індекси допомагають уникнути повного сканування таблиць (Full Table Scan) і знижують навантаження на базу даних.

Виконання завдання 5: 
Для того щоб виконати завдання зі створення кластеризованого індексу на таблиці, яка містить більше 100 записів, я слідувала таким крокам:
1.	Підготовка таблиці для створення індексу: Оскільки кластеризований індекс може бути тільки один на таблиці, а у таблиці Accident_Investigation вже був встановлений первинний ключ як кластеризований індекс, я спершу повинна була видалити поточний кластеризований індекс. Це дозволяє створити новий кластеризований індекс на стовпці InvestigationDate.
2.	Видалення поточного кластеризованого індексу (PK): Я використала ALTER TABLE Accident_Investigation
DROP CONSTRAINT PK__Accident__57E7E5C453782ADE;
Ця команда дозволяє видалити поточний первинний ключ, який є кластеризованим індексом для таблиці Accident_Investigation.
3.	Створення нового кластеризованого індексу на стовпці InvestigationDate: Після видалення старого індексу я створила новий кластеризований індекс на стовпці InvestigationDate, що дозволяє ефективніше виконувати запити, де важливим є сортування чи фільтрація за датою розслідування. Для цього використала команду:
CREATE CLUSTERED INDEX IX_AccidentInvestigation_InvestigationDate
ON Accident_Investigation (InvestigationDate);
4.	Результат: Після виконання цих кроків я отримала успішно створений кластеризований індекс, який дозволяє оптимізувати виконання запитів на таблицю Accident_Investigation з урахуванням поля InvestigationDate.
Лістинг коду :
--Видалити поточний кластеризований індекс (PK):
ALTER TABLE Accident_Investigation
DROP CONSTRAINT PK__Accident__57E7E5C453782ADE;

-- Створення нового кластеризованого індексу на стовпці InvestigationDate
CREATE CLUSTERED INDEX IX_AccidentInvestigation_InvestigationDate
ON Accident_Investigation (InvestigationDate);

 
 
Рисунок  11-12 – виконання завдання 5

Виконання завдання 6: 
Для створення некластеризованого індексу на одному або кількох стовпцях я вибрала таблицю Accident. Вибір стовпців базувався на частому використанні цих полів для фільтрації даних у запитах.
•	Вибір стовпців:
o	Location: Це поле містить інформацію про місце ДТП, і його часто використовують для фільтрації або сортування даних за локацією.
o	Accident_Type: Поле, що містить тип ДТП (наприклад, зіткнення, наїзд, аварія). Це поле також часто використовують для фільтрації даних за типом ДТП.
Команда для створення некластеризованого індексу:
CREATE NONCLUSTERED INDEX IX_Accident_Location_AccidentType
ON Accident (Location, Accident_Type);
Цей індекс дозволяє покращити виконання запитів, які використовують ці два стовпці для фільтрації або сортування.
 
Рисунок 13  – виконання завдання 6

Виконання завдання 7: 
Для цього завдання я створюю унікальний індекс для поля Passport_Number в таблиці Victim, оскільки кожен постраждалий має унікальний номер паспорта. Так само, як і у випадку з email в таблиці Users, цей номер паспорта має бути унікальним для кожного постраждалого.
CREATE UNIQUE INDEX IX_Passport_Number_Unique
ON Victim(Passport_Number);
 
Рисунок  14 – виконання завдання 7
Пояснення:
1.	Таблиця: Створюється унікальний індекс на полі Passport_Number в таблиці Victim.
2.	Унікальність: Цей індекс гарантує, що в таблиці Victim не буде два однакових номера паспорта, що відповідають різним постраждалим.
3.	Назва індексу: Назва індексу IX_Passport_Number_Unique вказує на те, що це унікальний індекс для поля Passport_Number.
Це дозволить забезпечити цілісність даних, гарантуючи, що кожен постраждалий має унікальний номер паспорта в базі.

Виконання завдання 8: 
Створення індексу з включеними стовпцями (INCLUDE)
У цьому завданні я створила індекс з включеними стовпцями (INCLUDE) для покриття певного SELECT-запиту та порівняла план виконання запиту з індексом та без нього.
Кроки виконання завдання:

1.	Створення індексу з включеними стовпцями: Я створила індекс з включеними стовпцями для запиту, що часто використовує поля Location та Accident_Type з таблиці Accident.

Запит, для якого я створила індекс:
SELECT Location, Accident_Type
FROM Accident
WHERE Date BETWEEN '2020-01-01' AND '2020-12-31';
Створення індексу з включеними стовпцями: Для того щоб прискорити виконання запиту, я створила індекс з включеними стовпцями, які використовуються в SELECT-запиті, і включила додаткові стовпці в індекс:
CREATE INDEX IX_Accident_Location_AccidentType
ON Accident(Date)
INCLUDE (Location, Accident_Type);
  
   
 
Рисунок 15-19  – виконання завдання 8

Пояснення:
Порівняння плану виконання:
1.	План виконання без індексу: Спочатку я перевірила план виконання запиту без індексу. В цьому випадку SQL-сервер виконує повне сканування таблиці (Table Scan), оскільки індексу, який покриває всі стовпці запиту, немає.
2.	План виконання з індексом: Після того, як я створила індекс з включеними стовпцями, я перевірила план виконання з використанням цього індексу. SQL-сервер тепер використовує індексний пошук (Index Seek), що дозволяє йому ефективно фільтрувати за Date та витягати стовпці Location і Accident_Type прямо з індексу без потреби звертатися до основної таблиці.
Результати:
•	Без індексу: План виконання показує Table Scan, де весь набір даних таблиці сканується для пошуку відповідних рядків. Це може зайняти багато часу, особливо при великій кількості даних.
•	З індексом: План виконання з індексом показує Index Seek, де SQL-сервер використовує індекс для фільтрації за Date та одночасного отримання необхідних стовпців Location і Accident_Type, що значно прискорює виконання запиту.
Висновок:
Створення індексу з включеними стовпцями дозволяє значно покращити ефективність виконання запиту, оскільки сервер використовує індекс для фільтрації та отримання даних, замість того, щоб сканувати всю таблицю. Це дуже корисно для покращення продуктивності, особливо при роботі з великими таблицями.

Виконання завдання 9: 
У цьому завданні я створила фільтрований індекс для таблиці Accident, щоб прискорити виконання запиту, який вибирає всі записи, де статус розслідування дорівнює 'Open'. Ось детальне пояснення кожної частини запиту:
Створення фільтрованого індексу:
CREATE NONCLUSTERED INDEX IX_Filtered_InvestigationStatus_Open
ON Accident(Investigation_Status)
WHERE Investigation_Status = 'Open';
•	CREATE NONCLUSTERED INDEX — це команда для створення індексу, який не змінює фізичний порядок даних у таблиці, але прискорює пошук по зазначеному стовпцю.
•	IX_Filtered_InvestigationStatus_Open — це назва індексу, який я створюю. Ім'я індексу зазвичай повинно відображати його функцію або стовпці, за якими він створений.
•	ON Accident(Investigation_Status) — цей індекс створюється на стовпці Investigation_Status таблиці Accident. Це означає, що індекс буде використовуватися для фільтрації записів на основі значень у цьому стовпці.
•	WHERE Investigation_Status = 'Open' — це умовний фільтр, який визначає, що індекс буде створений лише для записів, де значення в стовпці Investigation_Status дорівнює 'Open'. Такий індекс є фільтрованим, тобто він лише охоплює підмножину даних, а не всю таблицю. Це дає змогу скоротити час пошуку саме для цього значення, оскільки база даних не повинна перевіряти всі записи.


Запит для вибору всіх записів зі статусом 'Open':
SELECT *
FROM Accident
WHERE Investigation_Status = 'Open';
o	SELECT * — вибір усіх стовпців для записів, які задовольняють умову.
o	FROM Accident — вибір даних з таблиці Accident.
o	WHERE Investigation_Status = 'Open' — фільтрація записів за значенням в стовпці Investigation_Status, вибираються лише ті записи, де статус розслідування має значення 'Open'.
Як працює індекс:
•	Після створення фільтрованого індексу, коли я виконую запит для вибору всіх записів з 'Open' у стовпці Investigation_Status, база даних може швидко скористатися створеним індексом для пошуку цих записів.
•	Завдяки індексу, який охоплює лише ті записи, де статус дорівнює 'Open', пошук буде швидким, оскільки база даних не буде обробляти всю таблицю, а лише частину даних, що відповідає умові.
Висновок: Фільтрований індекс оптимізує виконання запитів, де є конкретні фільтри, що обмежують вибірку (як у нашому випадку, коли ми шукаємо записи з певним статусом). Це дозволяє зменшити час виконання запитів, особливо в таблицях з великою кількістю записів.
 

 
Рисунок 20-21  – виконання завдання 9

Виконання завдання 10: 
Для виконання завдання 10 та отримання інформації про ступінь фрагментації індексів у базі даних, можна використовувати вбудовану функцію sys.dm_db_index_physical_stats, яка надає статистику про фізичний стан індексів у базі даних, включаючи ступінь фрагментації.
Лістинг коду:
 SELECT 
    db.name AS DatabaseName,
    t.name AS TableName,
    i.name AS IndexName,
    ips.index_type_desc AS IndexType,
    ips.avg_fragmentation_in_percent AS Fragmentation,
    ips.page_count AS PageCount
FROM 
    sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, 'DETAILED') AS ips
JOIN 
    sys.tables AS t
    ON ips.object_id = t.object_id
JOIN 
    sys.indexes AS i
    ON ips.object_id = i.object_id
    AND ips.index_id = i.index_id
JOIN 
    sys.databases AS db
    ON db.database_id = DB_ID()
WHERE 
    ips.page_count > 0  -- Фільтруємо індекси, що мають більше 0 сторінок
ORDER BY 
    ips.avg_fragmentation_in_percent DESC;  -- Відсортовано за рівнем фрагментації

 Рисунок  22 – виконання завдання 10.
Пояснення:
•	sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, 'DETAILED') — цей виклик отримує фізичну статистику індексів для всіх таблиць у поточній базі даних, використовуючи режим 'DETAILED', що надає максимальну деталізацію.
•	avg_fragmentation_in_percent — показує середній рівень фрагментації індексу у відсотках.
•	page_count — кількість сторінок, що використовуються індексом.
•	  NULL, NULL, NULL, NULL — ці параметри дозволяють отримати інформацію про всі індекси у всіх таблицях.
•	 DETAILED — параметр, що вказує на рівень деталізації для отримання точнішої інформації про фрагментацію.
•	 sys.tables — містить дані про таблиці.
•	 sys.indexes — містить дані про індекси.
•	  sys.databases — містить інформацію про бази даних.
Цей запит дозволяє отримати інформацію про ступінь фрагментації індексів у базі даних без будь-яких додаткових фільтрів чи складних умов. Результати будуть відсортовані за рівнем фрагментації в порядку спадання.

Виконання завдання 11: 
Реорганізацію індексу для зменшення фрагментації:
Команда ALTER INDEX ... REORGANIZE використовується для реорганізації індексів в SQL Server, щоб зменшити їх фрагментацію без потреби в повному пересозданні індексу (що зазвичай робиться командою REBUILD). Реорганізація індексу - це менш ресурсозатратна операція, яка допомагає покращити продуктивність при високій фрагментації індексів, але не вимоглива до великих системних ресурсів.
-- Реорганізація індексу для таблиці Pedestrian
ALTER INDEX PK__Pedestri__1DD2CD8AA2357B5D 
ON Pedestrian REORGANIZE;
Опис запиту:
•	ALTER INDEX: Це команда для зміни індексу в SQL Server.
•	PK__Pedestri__1DD2CD8AA2357B5D: Це ім'я індексу, який треба реорганізувати. Ім'я індексу PK__Pedestri__1DD2CD8AA2357B5D виглядає як автоматично згенероване ім'я для первинного ключа в таблиці Pedestrian. Це означає, що індекс використовуватиметься для забезпечення унікальності рядків в таблиці.
•	ON Pedestrian: Вказує таблицю, для якої треба реорганізувати індекс. У цьому випадку, індекс застосовний до таблиці Pedestrian.
•	REORGANIZE: Ця операція виконує реорганізацію індексу, що означає, що SQL Server збирає дані в індексах, зменшуючи ступінь фрагментації, не видаляючи і не пересоздаючи індекс. Це менш затратна операція порівняно з повним перезапуском індексу.
 
Рисунок 23   – виконання завдання 11

Виконання завдання 12: 
Повна перебудова індексу (REBUILD):
--Повна перебудова індексу (REBUILD)
ALTER INDEX PK__Victim__962126953F0422DB ON Victim REBUILD;
 
Рисунок  24 – виконання завдання 12

Опис:
•	ALTER INDEX — команда для зміни або обслуговування індексу в базі даних SQL Server.
•	PK__Victim__962126953F0422DB — ім'я індексу первинного ключа (Primary Key) для таблиці Victim.
•	ON Victim — вказує, що ця операція виконується для таблиці Victim.
•	REBUILD — означає повністю перебудувати індекс, тобто створити його заново.
Для чого виконується REBUILD?
•	У таблиці Victim індекс мав показник змін 50, що свідчить про високу фрагментацію або значні зміни в даних.
•	При високій фрагментації (понад 30%) рекомендується повна перебудова індексу (REBUILD), оскільки:
o	Вона повністю оптимізує структуру індексу.
o	Зменшує фрагментацію майже до нуля.
o	Покращує продуктивність запитів і доступ до даних у таблиці.
•	Операція REBUILD створює нову копію індексу, тому вона потребує більше ресурсів, ніж реорганізація, але забезпечує кращий результат при високій фрагментації.
Підсумок: Виконання цієї команди забезпечує повну оптимізацію індексу PK__Victim__962126953F0422DB у таблиці Victim, що підвищить швидкість доступу до даних і загальну продуктивність бази даних.

Виконання завдання 13: 
Видалення непотрібного індексу, який не використовується в запитах:
DROP INDEX IX_Passport_Number_Unique ON Victim;

Опис виконаного завдання:
•	Команда DROP INDEX використовується для видалення індексу з таблиці бази даних.
•	Індекс IX_Passport_Number_Unique належить таблиці Victim і є некластеризованим індексом.
•	За статистикою (0 змін і глибина дерева 1), цей індекс не бере участі у запитах і не використовується сервером для оптимізації виконання.
Чому обрала саме цей індекс для видалення:
•	Індекс IX_Passport_Number_Unique не бере участі у запитах.
•	Він займає місце в базі даних і потребує оновлення при зміні даних, навіть якщо не використовується.
•	Його видалення допоможе оптимізувати використання ресурсів і підвищити загальну продуктивність бази даних.
Підсумок: Видалення непотрібного індексу дозволяє зекономити простір, зменшити навантаження при зміні даних і прискорити роботу бази даних.
 
Рисунок 25 – виконання завдання 13

Виконання завдання 14: 
В цьому завданні порівнюю швидкодію запиту до великої таблиці до і після створення індексу до запиту із умови варіанту``Вивести повний список ДТП, які виникли з вини пішоходів, за вказаний період з повними відомостями про них``:

Виконання запиту без індексів:
 
 

 Вимірювання часу виконання запиту без індексів:
Для вимірювання часу виконання запиту в SQL Server можна використовувати команду SET STATISTICS TIME ON. Це дозволить отримати інформацію про час виконання запиту:
SET STATISTICS TIME ON;

-- Запит без індексів
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.MiddleName AS Pedestrian_MiddleName,
       P.Address AS Pedestrian_Address, P.Passport_Number AS Pedestrian_Passport
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

SET STATISTICS TIME OFF;
 
Створення індексів
Тепер створимо індекси для колонок, що використовуються у запиті для фільтрації та з'єднання:

-- Створення індексу на колонці Date в таблиці Accident
CREATE NONCLUSTERED INDEX IX_Accident_Date ON Accident (Date);

-- Створення індексу на колонці ID_Accident в таблиці Pedestrian
CREATE NONCLUSTERED INDEX IX_Pedestrian_Accident ON Pedestrian (ID_Accident);

 
 
Рисунок   25-28 – виконання завдання 14

Аналіз результатів
•	До створення індексів: час виконання запиту був вищий, оскільки SQL Server повинен був виконувати повне сканування таблиць для пошуку відповідних рядків.
•	Після створення індексів: час виконання запиту значно зменшився, оскільки SQL Server зміг використати індекси для швидшого пошуку потрібних даних.
Висновок:
Використання індексів значно покращує продуктивність запиту, особливо коли мова йде про великі таблиці з великою кількістю даних. У цьому випадку створення NONCLUSTERED INDEX на колонках Date в таблиці Accident і ID_Accident в таблиці Pedestrian дозволило значно скоротити час виконання запиту.





Виконання завдання 15: Використовуючи Database Engine Tuning Advisor, запропоновано оптимальні індекси для заданого запиту: 
--Вивести повний список ДТП, на які виїжджали міліціонери із зазначеним званням за вказаний період часу, з повними відомостями про ДТП:
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       Po.LastName AS Policeman_LastName, Po.FirstName AS Policeman_FirstName, Po.MiddleName AS Policeman_MiddleName,
       Po.Rank AS Policeman_Rank
FROM Accident A
JOIN Policeman Po ON A.ID_Accident = Po.ID_Accident
WHERE Po.Rank = 'Lieutenant' AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;
Database Engine Tuning Advisor (DETA) — це вбудований у SQL Server інструмент для автоматичної оптимізації структури бази даних під задане робоче навантаження.
 
 
 
Рисунок 29-31 – виконання завдання 15

 Мета аналізу
Аналіз робочого навантаження бази даних для виявлення оптимальних індексів, що покращать продуктивність запитів до таблиць Accident, Culprit та Accident_Investigation.
Рекомендації щодо індексів
Для таблиці Accident:
•	CREATE NONCLUSTERED INDEX IX_Accident_Date ON Accident (Date)
•	CREATE NONCLUSTERED INDEX IX_Accident_Status ON Accident (Investigation_Status) INCLUDE (Date, Location)
Для таблиці Culprit:
•	CREATE NONCLUSTERED INDEX IX_Culprit_Accident_Type ON Culprit (ID_Accident, Type)
Для таблиці Accident_Investigation:
•	CREATE NONCLUSTERED INDEX IX_AccidentInvestigation_ID ON Accident_Investigation (ID_Accident)
4. Висновки
Запропоновані індекси дозволять:
•	Прискорити операції фільтрації за датою в таблиці Accident
•	Оптимізувати пошук зв'язків між таблицями
•	Покращити продуктивність операцій INSERT/DELETE

Виконання завдання 16: 
У цьому завданні проводжу аудит усіх індексів у базі даних: визначаю кількість, тип, унікальність та фрагментацію кожного та створюю звіт у табличній формі.
Запит для проведення аудиту індексів в базі даних виглядає наступним чином:
SELECT
    DB_NAME() AS [База_даних],
    OBJECT_NAME(i.[object_id]) AS [Таблиця],
    i.name AS [Індекс],
    i.type_desc AS [Тип_індексу],
    i.is_unique AS [Унікальний],
    ps.avg_fragmentation_in_percent AS [Фрагментація_у_%],
    ps.page_count AS [Кількість_сторінок]
FROM
    sys.indexes AS i
INNER JOIN
    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
    ON i.[object_id] = ps.[object_id] AND i.index_id = ps.index_id
WHERE
    i.type > 0 AND i.is_hypothetical = 0
ORDER BY
    ps.avg_fragmentation_in_percent DESC;

 
Рисунок 32 – виконання завдання 16

Пояснення запиту:
•	DB_NAME() — повертає ім’я поточної бази даних.
•	OBJECT_NAME(i.[object_id]) — повертає ім’я таблиці, до якої належить індекс.
•	i.name — ім’я індексу.
•	i.type_desc — тип індексу (наприклад, CLUSTERED, NONCLUSTERED).
•	i.is_unique — визначає, чи є індекс унікальним (1 — унікальний, 0 — не унікальний).
•	ps.avg_fragmentation_in_percent — рівень фрагментації індексу, який показує, наскільки ефективно використовується індекс.
•	ps.page_count — кількість сторінок, які використовує індекс.
Аналіз індексів:
•	Типи індексів:
o	CLUSTERED: Визначають фізичний порядок збереження рядків і забезпечують унікальність (зазвичай для основного ключа).
o	NONCLUSTERED: Прискорюють пошук без зміни фізичного порядку рядків.
•	Унікальність:
o	CLUSTERED індекси завжди унікальні.
o	NONCLUSTERED можуть бути як унікальними, так і неунікальними.
•	Фрагментація:
o	Високий рівень фрагментації може потребувати реорганізації або перебудови індексів. У більшості випадків фрагментація 0, що свідчить про ефективну організацію індексів.
•	Кількість сторінок:
o	Невелика кількість сторінок свідчить про малий розмір таблиці або індексу.

Висновки: 
У ході виконання роботи я ознайомилася з основними поняттями індексів у системі керування базами даних Microsoft SQL Server. Вивчила їх важливу роль у підвищенні продуктивності запитів, а також розглянула різні типи індексів, їх призначення та особливості використання. Я засвоїла основні оператори для створення індексів, порядок їх застосування, а також методи реорганізації та видалення індексів у базі даних.
Практична частина роботи дозволила набути навичок створення, оптимізації та аналізу ефективності індексів. Я проаналізувала їх вплив на продуктивність запитів і нав learned, як правильно обирати тип індексів та методи їх обслуговування для досягнення найкращих результатів. Отримані знання і навички є важливими для подальшої роботи з базами даних і їх оптимізації.

Посилання на конспект:
https://drive.google.com/drive/folders/17AMroeri1iauaJBrmbK7aVMbIPCUe0uK
