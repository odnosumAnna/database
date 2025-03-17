-- Оновлення статусу розслідування
UPDATE Accident
SET Investigation_Status = 'Closed'
WHERE ID_Accident = 1;

-- Видалення транспортного засобу
DELETE FROM Vehicle
WHERE ID_Vehicle = 1;

-- Оновлення інформації про постраждалого
UPDATE Victim
SET Hospitalization_Status = 'Discharged'
WHERE ID_Victim = 1;
