-- 1. ������ ��� ��� � ����������� ��� ���������� ������ �� ��䳿�
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Accident_Type, 
       V.License_Plate, V.Model, V.Year, 
       D.LastName, D.FirstName, D.MiddleName, D.License_Number
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
LEFT JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
LEFT JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- 2. ��������� ��� ��������� �� ���� ����� �� ������� ���
SELECT A.ID_Accident, A.Date, A.Location, 
       V.LastName, V.FirstName, V.MiddleName, V.Injury_Type, V.Severity
FROM Accident A
RIGHT JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- 3. ³���������� ��� ����� �� �����������, �� �� �����������
SELECT A.ID_Accident, A.Date, A.Location, 
       P.LastName, P.FirstName, P.MiddleName, P.Rank, P.Department
FROM Accident A
FULL JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- 4. �� ���, � ���� ����� ������ ������� (�� ����������, �� �)
SELECT A.ID_Accident, A.Date, A.Location, 
       P.LastName, P.FirstName, P.MiddleName, P.Is_Victim
FROM Accident A
INNER JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- 5. ���, � ���� ������� ������������ �������� 3
SELECT A.ID_Accident, A.Date, A.Location, A.Victim_Count
FROM Accident A
WHERE A.Victim_Count > 3;

-- 6. �� ��䳿, �� ���� ����������� ���
SELECT D.LastName, D.FirstName, D.MiddleName, D.License_Number, A.ID_Accident, A.Date, A.Location
FROM Driver D
INNER JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
INNER JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE DI.Involvement_Status = 'Responsible';