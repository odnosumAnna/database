-- �������� 4: ������������ WHERE
-- ��������� ��� ���, � ���� ����������� ����� ���� ���
SELECT * FROM Accident WHERE Victim_Count > 2;

-- ��������� ���, �� ������� � ����������� ����
SELECT * FROM Accident WHERE Location = 'Kyiv';

-- ��������� ��� ������� ����
SELECT * FROM Accident WHERE Accident_Type = 'Collision';

-- ��������� ��� �� ���������� �����
SELECT * FROM Accident WHERE Date = '2025-01-01';

-- ��������� ��� � �������� �������� ������������
SELECT * FROM Accident WHERE Investigation_Status = 'Open';

-- �������� 5: ������������ ������� ���������
-- ��� � ���� �� ����� �������������, ���� ������������ �� �� �������
SELECT * FROM Accident WHERE Victim_Count > 2 AND Investigation_Status = 'Open';

-- ���, �� ������� ��� � ���, ��� � �����
SELECT * FROM Accident WHERE Location = 'Kyiv' OR Location = 'Lviv';

-- ��� � ����������� �� ����� �������
SELECT * FROM Accident WHERE Victim_Count > 1 AND Date > '2025-01-01';

-- ��� ��� ������������
SELECT * FROM Accident WHERE NOT Victim_Count > 0;

-- ���, �� ������� � ���������� �����
SELECT * FROM Accident WHERE Date BETWEEN '2025-01-01' AND '2025-03-01';

-- �������� 6: ������������ LIKE
-- ���, �� ������� �� �������, �� ����������� �� "Street" ��� "St"
SELECT * FROM Accident WHERE Location LIKE '% Street' OR Location LIKE '% St';

-- ��� � �������, �� ����������� �� "North"
SELECT * FROM Accident WHERE Location LIKE 'North%';

-- ���, �� ������ � ���� ���� ����� "Avenue"
SELECT * FROM Accident WHERE Location LIKE '%Avenue%';

-- ��� � ������, �� ����������� �� "C"
SELECT * FROM Accident WHERE Accident_Type LIKE 'C%';

-- ��� � ������� ��� � ������� �� �����
SELECT * FROM Accident WHERE Location LIKE '_yiv';

-- �������� 7: INNER JOIN
-- ��������� ��� ��� ����� � ������� ������������
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName 
FROM Accident A
INNER JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- ��������� ��� �� ��䳿�, �� � ��� ����� ������
SELECT A.*, D.LastName AS Driver_LastName, D.FirstName AS Driver_FirstName
FROM Accident A
INNER JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
INNER JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- ��� �� ������� ���������� ������
SELECT A.*, V.License_Plate, V.Model 
FROM Accident A
INNER JOIN Vehicle V ON A.ID_Accident = V.ID_Accident;

-- ��� � �������� ��� ���������, �� ��������
SELECT A.*, P.LastName AS Policeman_LastName, P.Rank
FROM Accident A
INNER JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- ��� � ������ ��� �������
SELECT A.*, P.LastName AS Pedestrian_LastName
FROM Accident A
INNER JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- �������� 8: LEFT JOIN
-- ��� �� ������ ������ (���� ���� � NULL)
SELECT A.*, COALESCE(V.LastName, 'No Victim') AS Victim_LastName 
FROM Accident A
LEFT JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- ��� �� ���������, �� ����� ��������
SELECT A.*, COALESCE(P.LastName, 'No Officer') AS Policeman_LastName
FROM Accident A
LEFT JOIN Policeman P ON A.ID_Accident = P.ID_Accident;

-- ��� �� ��䳿, �� ����� ����� ������
SELECT A.*, COALESCE(D.LastName, 'Unknown') AS Driver_LastName
FROM Accident A
LEFT JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
LEFT JOIN Driver D ON DI.ID_Driver = D.ID_Driver;

-- ��� �� ������� (���� ����)
SELECT A.*, COALESCE(P.LastName, 'No Pedestrian') AS Pedestrian_LastName
FROM Accident A
LEFT JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident;

-- ��� �� �� ���������� ������
SELECT A.*, COALESCE(V.License_Plate, 'No Vehicle') AS License_Plate
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident;

-- �������� 9: ������������ SUBQUERY
-- ���, � ���� � ���� � ���� ��������� �� ������� ��������
SELECT * FROM Accident 
WHERE EXISTS (
    SELECT 1 FROM Victim WHERE Victim.ID_Accident = Accident.ID_Accident AND Victim.Severity = 'Severe'
);

-- ���, �� ������� ����� �������� ������ ��������
SELECT * FROM Accident 
WHERE Victim_Count > (SELECT AVG(Victim_Count) FROM Accident);

-- ��䳿, �� ����� ������ ����� �� � ���� ���
SELECT * FROM Driver 
WHERE ID_Driver IN (
    SELECT ID_Driver FROM Driver_Involvement GROUP BY ID_Driver HAVING COUNT(*) > 1
);

-- ���, �� ����� ����� 2 ������������ ������
SELECT * FROM Accident 
WHERE ID_Accident IN (
    SELECT ID_Accident FROM Vehicle GROUP BY ID_Accident HAVING COUNT(*) > 2
);

-- ��� � ��������� ������� ������������
SELECT * FROM Accident 
WHERE Victim_Count = (SELECT MAX(Victim_Count) FROM Accident);

-- �������� 10: GROUP BY �� HAVING
-- ϳ�������� ������� ��� �� �����, ���� ����� 1, � ����������� �������
SELECT A.Accident_Type, COUNT(*) AS Total_Accidents
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
GROUP BY A.Accident_Type
HAVING COUNT(*) > 1;

-- ���������� ������� ��� �� �����, ���� � ��� ����������� ��䳿
SELECT A.Location, COUNT(*) AS Accident_Count
FROM Accident A
JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
GROUP BY A.Location
HAVING COUNT(*) > 1;

-- ʳ������ ���, � ���� � ����������, ��������� �� �����, ���� �� ����� 2
SELECT A.Location, COUNT(*) AS Accident_With_Victims
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Victim_Count > 0
GROUP BY A.Location
HAVING COUNT(*) > 2;

-- ���������� ������� ��� �� ������, ���� � ��� ����� ������ ��������� ������� ������
SELECT YEAR(A.Date) AS Year, COUNT(*) AS Total_Accidents
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain'
GROUP BY YEAR(A.Date)
HAVING COUNT(*) > 1;

-- ʳ������ ���, �� ������� ������������ ������ �������� 2
SELECT A.ID_Accident, COUNT(V.ID_Vehicle) AS Vehicle_Count
FROM Accident A
JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
GROUP BY A.ID_Accident
HAVING COUNT(V.ID_Vehicle) > 2;

-- �������� 11: ������ ������������� ������

-- 1. ��������� ��� ��� ����� � ������� ��������� ������������ ������
SELECT 
    A.ID_Accident, A.Date, A.Location, A.Accident_Type, 
    COUNT(V.ID_Vehicle) AS Vehicle_Count
FROM Accident A
LEFT JOIN Vehicle V ON A.ID_Accident = V.ID_Accident
GROUP BY A.ID_Accident, A.Date, A.Location, A.Accident_Type;

-- 2. ���������� ����, �� ������� �������� ���
SELECT TOP 1 Location, COUNT(*) AS Total_Accidents
FROM Accident
GROUP BY Location
ORDER BY Total_Accidents DESC;

-- 3. ������ ��䳿�, �� ����� ������ � ��� ����� �� ���� ��� �� ������ �����
SELECT D.ID_Driver, D.LastName, D.FirstName, COUNT(DI.ID_Accident) AS Accident_Count
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Date BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY D.ID_Driver, D.LastName, D.FirstName
HAVING COUNT(DI.ID_Accident) > 1;

-- 4. ���������� ������� ������������ ���� ��� (� ��������� ��������� ������� ������������)
SELECT TOP 1 Accident_Type, AVG(Victim_Count) AS Avg_Victims
FROM Accident
GROUP BY Accident_Type
ORDER BY Avg_Victims DESC;

-- 5. ��������� ���, �� �� �������� ��������� ������� ������
SELECT 
    A.ID_Accident, A.Date, A.Location, A.Accident_Type, 
    P.LastName AS Policeman_LastName, P.Rank
FROM Accident A
JOIN Policeman P ON A.ID_Accident = P.ID_Accident
WHERE P.Rank = 'Captain';


-- �������� 12: WHERE � ������� � JOIN

-- 1. ��������� ��� �������� ��� ����� � ������� ������������
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Investigation_Status = 'Open';

-- 2. ��� � ���� ������� �� ������ �����
SELECT A.*
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2025-01-01' AND '2025-12-31';

-- 3. ��� � ���� �� ����� �������������, ���� ������������ �� �� �������
SELECT * FROM Accident 
WHERE Victim_Count > 2 AND Investigation_Status = 'Open';

-- 4. ���������� ������� ��� �� �����, ���� �� ����� 3
SELECT Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
HAVING COUNT(*) > 3;

-- 5. ��䳿, �� ����� ������ � ��� � ������� ���������
SELECT DISTINCT D.*
FROM Driver D
JOIN Driver_Involvement DI ON D.ID_Driver = DI.ID_Driver
JOIN Accident A ON DI.ID_Accident = A.ID_Accident
WHERE A.Victim_Count > 3;

