--Завдання 6: Запити з використанням функцій для обробки дати
--Запит 1: Визначення статусу водійського посвідчення та кількості днів до його закінчення
SELECT ID_Driver, License_Number, License_Expiry, 
       DATEDIFF(DAY, GETDATE(), License_Expiry) AS DaysUntilExpiry,
       CASE 
           WHEN DATEDIFF(DAY, GETDATE(), License_Expiry) < 0 THEN 'Expired'
           ELSE 'Valid'
       END AS Status
FROM Driver;

--Запит 2: Визначення дня тижня для кожного ДТП
SELECT ID_Accident, Date, 
       DATENAME(WEEKDAY, Date) AS AccidentDay
FROM Accident;

--Запит 3: Додавання 7 днів до дати ДТП (для прогнозу наслідків)
SELECT ID_Accident, Date, 
       DATEADD(DAY, 7, Date) AS FollowUpDate
FROM Accident;
