-- ��������� ������� ������������
UPDATE Accident
SET Investigation_Status = 'Closed'
WHERE ID_Accident = 1;

-- ��������� ������������� ������
DELETE FROM Vehicle
WHERE ID_Vehicle = 1;

-- ��������� ���������� ��� �������������
UPDATE Victim
SET Hospitalization_Status = 'Discharged'
WHERE ID_Victim = 1;
