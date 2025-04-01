--Завдання 4: Запити з використанням віконних функцій
--Запит 1: Нумерація ДТП за датою
SELECT ID_Accident, Date, 
       ROW_NUMBER() OVER (ORDER BY Date) AS AccidentNumber
FROM Accident;
--Запит 2: Визначення кількості постраждалих у кожній ДТП та середньої кількості по всій таблиці
SELECT ID_Accident, Victim_Count, 
       AVG(Victim_Count) OVER () AS AvgVictimCount
FROM Accident;
--Запит 3: Обчислення кількості ДТП до поточного рядка (з накопиченням)
SELECT ID_Accident, Date, 
       COUNT(ID_Accident) OVER (ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAccidents
FROM Accident;
