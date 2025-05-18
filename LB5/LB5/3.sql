-- ����������������� ������ ��� ������� Accident �� ���� Date
CREATE NONCLUSTERED INDEX idx_Accident_Date ON Accident (Date);

-- ����������������� ������ ��� ������� Driver_Involvement �� ���� ID_Accident
CREATE NONCLUSTERED INDEX idx_Driver_Involvement_Accident ON Driver_Involvement (ID_Accident);

-- ����������������� ������ ��� ������� Driver_Involvement �� ���� ID_Driver
CREATE NONCLUSTERED INDEX idx_Driver_Involvement_Driver ON Driver_Involvement (ID_Driver);

-- ��������� ������ ��� ������� Vehicle �� ���� License_Plate
CREATE UNIQUE NONCLUSTERED INDEX idx_Vehicle_License_Plate ON Vehicle (License_Plate);

-- ����������������� ������ ��� ������� Vehicle �� ���� ID_Accident
CREATE NONCLUSTERED INDEX idx_Vehicle_Accident ON Vehicle (ID_Accident);

-- ����������������� ������ ��� ������� Driver �� ���� LastName
CREATE NONCLUSTERED INDEX idx_Driver_LastName ON Driver (LastName);

-- ����������������� ������ ��� ������� Policeman �� ���� ID_Accident
CREATE NONCLUSTERED INDEX idx_Policeman_Accident ON Policeman (ID_Accident);

-- ������ � ���������� ��������� ��� ������� Policeman
CREATE NONCLUSTERED INDEX idx_Policeman_Accident_ID
ON Policeman (ID_Accident)
INCLUDE (LastName, FirstName);

-- Գ���������� ������ ��� ������� Victim, ���� ������ ����� ������������ � ������� ��������
CREATE NONCLUSTERED INDEX idx_Victim_Severe_Injury
ON Victim (Severity)
WHERE Severity = 'Severe';

-- ����������������� ������ ��� ������� Victim �� ���� ID_Accident
CREATE NONCLUSTERED INDEX idx_Victim_Accident ON Victim (ID_Accident);

-- ����������������� ������ ��� ������� Pedestrian �� ���� ID_Accident
CREATE NONCLUSTERED INDEX idx_Pedestrian_Accident ON Pedestrian (ID_Accident);

-- ����������������� ������ ��� ������� Pedestrian �� ���� LastName
CREATE NONCLUSTERED INDEX idx_Pedestrian_LastName ON Pedestrian (LastName);

-- ����������������� ������ ��� ������� Culprit �� ���� ID_Accident
CREATE NONCLUSTERED INDEX idx_Culprit_Accident ON Culprit (ID_Accident);

-- ����������������� ������ ��� ������� Culprit �� ���� ID_Related
CREATE NONCLUSTERED INDEX idx_Culprit_Related ON Culprit (ID_Related);
