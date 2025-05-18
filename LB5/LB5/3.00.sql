-- ������ ��� �������� ������ ����� �� �����
CREATE NONCLUSTERED INDEX idx_Accident_Date ON Accident (Date);

-- ������ ��� ������ ����� �� �����
CREATE NONCLUSTERED INDEX idx_Accident_Location ON Accident (Location);

-- ����������� ������ ��� Driver_Involvement
CREATE NONCLUSTERED INDEX idx_DriverInvolvement_Combined
ON Driver_Involvement (ID_Accident, ID_Driver);

-- ��������� ������ �� ������ ����
CREATE UNIQUE NONCLUSTERED INDEX idx_Vehicle_License_Plate ON Vehicle (License_Plate);

-- ������ ��� �������� ���� �� �����
CREATE NONCLUSTERED INDEX idx_Vehicle_Accident ON Vehicle (ID_Accident);

-- ����� ��䳿� �� ��������
CREATE NONCLUSTERED INDEX idx_Driver_LastName ON Driver (LastName);

-- ����������� ������ ��� �����������:
-- ���������� �� �������, �����, � ���������� ϲ�
CREATE NONCLUSTERED INDEX idx_Policeman_Combined
ON Policeman (Rank, ID_Accident)
INCLUDE (LastName, FirstName);

-- ������ ���� �� ������� � ������� ��������
CREATE NONCLUSTERED INDEX idx_Victim_Severe_Injury
ON Victim (Severity)
WHERE Severity = 'Severe';

-- ����� ����� �� �����
CREATE NONCLUSTERED INDEX idx_Victim_Accident ON Victim (ID_Accident);

-- ����� ������� �� ��������
CREATE NONCLUSTERED INDEX idx_Pedestrian_LastName ON Pedestrian (LastName);

-- ����������� ������: �� ��� ������ ������� + �����
CREATE NONCLUSTERED INDEX idx_Pedestrian_IsVictim_Accident 
ON Pedestrian(Is_Victim, ID_Accident);

-- ������� ��� ��'���� ���������� � �������
CREATE NONCLUSTERED INDEX idx_Culprit_Accident ON Culprit (ID_Accident);
CREATE NONCLUSTERED INDEX idx_Culprit_Related ON Culprit (ID_Related);
