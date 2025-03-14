                                                  Практична робота 6
                                                  
Мета роботи: Набути досвіду створення запитів у реляційній моделі баз даних, ознайомитися з основними операціями 
реляційної алгебри та навчитися застосовувати їх для оптимізації запитів і роботи з даними.

![image](https://github.com/user-attachments/assets/c14afb28-7836-45ea-b2d4-38d75c9de86b)


Завдання 1:

        1.	Отримати повну інформацію про товари: P
        Операція, яка просто повертає всю таблицю P (Товар)
        
        2.	Отримати повну інформацію про всі проекти в Києві :
        J WHERE CITY='Київ'
        Фільтруємо таблицю проектів (J), залишаємо тільки проекти з міста Київ
        
        3. Отримати всі поєднання "ім'я товару-колір" : P [PNAME, COLOR]
        Беремо таблицю товарів (P),показуємо тільки назву (PNAME) та колір (COLOR)
        
        4. Отримати всі міста постачальників : S [CITY]
        Беремо таблицю постачальників (S), показуємо тільки колонку з містами
        
        5. Отримати номери товарів, які забезпечують проект J3 : 
        (SPJ WHERE J#='J3') [P#]
        Беремо таблицю поставок (SPJ), фільтруємо тільки поставки для проекту J3, показуємо номери товарів з  
        цих поставок
        
        6. Отримати імена товарів, які постачаються постачальником S4. 
        ((SPJ WHERE S#='S4') JOIN P) [PNAME]
        •	Беремо таблицю поставок (SPJ)
        •	Фільтруємо поставки постачальника S4
        •	З'єднуємо з таблицею товарів (P)
        •	Показуємо назви товарів
        
        7. Отримати імена проектів, у яких беруть участь постачальники з Харкова. 
        ((SPJ JOIN (S WHERE CITY='Харків')) JOIN J) [JNAME]
        •	Фільтруємо постачальників з Харкова
        •	З'єднуємо з таблицею поставок (SPJ)
        •	З'єднуємо з таблицею проектів (J)
        •	Показуємо назви проектів
        
        8. Отримати номери товарів, що постачаються або постачальником зі статусом більше 20 або для проекту у 
        Харкова.
        ((SPJ JOIN (S WHERE STATUS > 20)) [P#]) UNION ((SPJ JOIN (J WHERE CITY='Харків')) [P#])

Завдання 2. 

![image](https://github.com/user-attachments/assets/d9941c27-5401-40ac-b8d2-d2a3eaaedbb7)

        Для виконання цього завдання я обрала наступний запит до моєї предметної області :
         •	Вивести повний список ДТП, які виникли з вини пішоходів, за вказаний
        період з повними відомостями про них;
        Для побудови цього запиту відповідно будуть виконуватися такі кроки:
        
          Крок 1: Фільтруємо винуватців-пішоходів 
        T1 := Culprit WHERE Type='Pedestrian'
        
          Крок 2: З'єднуємо з таблицею пішоходів для отримання їх даних 
        T2 := T1 JOIN Pedestrian
        
          Крок 3: З'єднуємо з таблицею ДТП та фільтруємо за періодом 
        T3 := (Accident WHERE Date BETWEEN 'start_date' AND 'end_date') JOIN T2
        
           Крок 4: Проектуємо необхідні атрибути 
        Result := T3 [ID_Accident, Date, Time, Location, Number_of_victims, 
                   Accident_type, Investigation_status, 
                   Pedestrian.Name, Pedestrian.Last_name, 
                   Pedestrian.Middle_name, Pedestrian.Address, 
                   Pedestrian.Passport_number, Pedestrian.Phone]


Висновки: 
У ході виконання лабораторної роботи я здобула практичні навички створення запитів у реляційній моделі баз даних, використовуючи мову реляційної алгебри. Було виконано аналіз структури бази даних, а також побудовано відповідні запити. Це дало змогу закріпити знання основних операцій реляційної алгебри, таких як фільтрація, об'єднання, проєкція та об'єднання множин, і навчитися їх ефективно застосовувати для отримання необхідних даних. 
