-- Індекс для швидкого пошуку аварій за датою
CREATE NONCLUSTERED INDEX idx_Accident_Date ON Accident (Date);

-- Індекс для пошуку аварій за місцем
CREATE NONCLUSTERED INDEX idx_Accident_Location ON Accident (Location);

-- Комбінований індекс для Driver_Involvement
CREATE NONCLUSTERED INDEX idx_DriverInvolvement_Combined
ON Driver_Involvement (ID_Accident, ID_Driver);

-- Унікальний індекс по номеру авто
CREATE UNIQUE NONCLUSTERED INDEX idx_Vehicle_License_Plate ON Vehicle (License_Plate);

-- Індекс для прив’язки авто до аварій
CREATE NONCLUSTERED INDEX idx_Vehicle_Accident ON Vehicle (ID_Accident);

-- Пошук водіїв за прізвищем
CREATE NONCLUSTERED INDEX idx_Driver_LastName ON Driver (LastName);

-- Комбінований індекс для поліцейських:
-- фільтрація за званням, аварією, з включенням ПІБ
CREATE NONCLUSTERED INDEX idx_Policeman_Combined
ON Policeman (Rank, ID_Accident)
INCLUDE (LastName, FirstName);

-- Індекс лише по жертвах з тяжкими травмами
CREATE NONCLUSTERED INDEX idx_Victim_Severe_Injury
ON Victim (Severity)
WHERE Severity = 'Severe';

-- Пошук жертв за аварією
CREATE NONCLUSTERED INDEX idx_Victim_Accident ON Victim (ID_Accident);

-- Пошук пішоходів за прізвищем
CREATE NONCLUSTERED INDEX idx_Pedestrian_LastName ON Pedestrian (LastName);

-- Комбінований індекс: чи був пішохід жертвою + аварія
CREATE NONCLUSTERED INDEX idx_Pedestrian_IsVictim_Accident 
ON Pedestrian(Is_Victim, ID_Accident);

-- Індекси для зв'язку винуватців з аваріями
CREATE NONCLUSTERED INDEX idx_Culprit_Accident ON Culprit (ID_Accident);
CREATE NONCLUSTERED INDEX idx_Culprit_Related ON Culprit (ID_Related);
