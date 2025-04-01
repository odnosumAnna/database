--Запит 1: Підрахунок загальної кількості постраждалих у всіх ДТП
SELECT SUM(Victim_Count) AS TotalVictims FROM Accident;

--Запит 2: Середній рік випуску транспортних засобів
SELECT AVG(Year) AS AverageVehicleYear FROM Vehicle;

--Запит 3: Пошук найновішого та найстарішого транспортного засобу
SELECT MAX(Year) AS NewestVehicle, MIN(Year) AS OldestVehicle FROM Vehicle;

