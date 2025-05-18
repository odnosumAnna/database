-- Некластеризований індекс для таблиці Accident по полю Date
CREATE NONCLUSTERED INDEX idx_Accident_Date ON Accident (Date);

-- Некластеризований індекс для таблиці Driver_Involvement по полю ID_Accident
CREATE NONCLUSTERED INDEX idx_Driver_Involvement_Accident ON Driver_Involvement (ID_Accident);

-- Некластеризований індекс для таблиці Driver_Involvement по полю ID_Driver
CREATE NONCLUSTERED INDEX idx_Driver_Involvement_Driver ON Driver_Involvement (ID_Driver);

-- Унікальний індекс для таблиці Vehicle по полю License_Plate
CREATE UNIQUE NONCLUSTERED INDEX idx_Vehicle_License_Plate ON Vehicle (License_Plate);

-- Некластеризований індекс для таблиці Vehicle по полю ID_Accident
CREATE NONCLUSTERED INDEX idx_Vehicle_Accident ON Vehicle (ID_Accident);

-- Некластеризований індекс для таблиці Driver по полю LastName
CREATE NONCLUSTERED INDEX idx_Driver_LastName ON Driver (LastName);

-- Некластеризований індекс для таблиці Policeman по полю ID_Accident
CREATE NONCLUSTERED INDEX idx_Policeman_Accident ON Policeman (ID_Accident);

-- Індекс з включеними стовпцями для таблиці Policeman
CREATE NONCLUSTERED INDEX idx_Policeman_Accident_ID
ON Policeman (ID_Accident)
INCLUDE (LastName, FirstName);

-- Фільтрований індекс для таблиці Victim, який включає тільки постраждалих з важкими травмами
CREATE NONCLUSTERED INDEX idx_Victim_Severe_Injury
ON Victim (Severity)
WHERE Severity = 'Severe';

-- Некластеризований індекс для таблиці Victim по полю ID_Accident
CREATE NONCLUSTERED INDEX idx_Victim_Accident ON Victim (ID_Accident);

-- Некластеризований індекс для таблиці Pedestrian по полю ID_Accident
CREATE NONCLUSTERED INDEX idx_Pedestrian_Accident ON Pedestrian (ID_Accident);

-- Некластеризований індекс для таблиці Pedestrian по полю LastName
CREATE NONCLUSTERED INDEX idx_Pedestrian_LastName ON Pedestrian (LastName);

-- Некластеризований індекс для таблиці Culprit по полю ID_Accident
CREATE NONCLUSTERED INDEX idx_Culprit_Accident ON Culprit (ID_Accident);

-- Некластеризований індекс для таблиці Culprit по полю ID_Related
CREATE NONCLUSTERED INDEX idx_Culprit_Related ON Culprit (ID_Related);
