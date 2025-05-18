-- ������� ���������� ����
SET STATISTICS TIME ON;

-- ������� ������ ������ ���, �� ������� � ���� �������, �� �������� ����� � ������� ���������� ��� ���
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       P.LastName AS Pedestrian_LastName, P.FirstName AS Pedestrian_FirstName, P.MiddleName AS Pedestrian_MiddleName,
       P.Address AS Pedestrian_Address, P.Passport_Number AS Pedestrian_Passport
FROM Accident A
JOIN Pedestrian P ON A.ID_Accident = P.ID_Accident
WHERE P.Is_Victim = 1 AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

-- ������ ����, �� ������� ����������� ������� ���
SELECT Location, COUNT(*) AS Accident_Count
FROM Accident
GROUP BY Location
ORDER BY Accident_Count DESC;

-- ������� ������ ������ ���, �� �� �������� ��������� �� ���������� ������� �� �������� ����� ����
SELECT A.ID_Accident, A.Date, A.Time, A.Location, A.Victim_Count, A.Accident_Type, A.Investigation_Status,
       Po.LastName AS Policeman_LastName, Po.FirstName AS Policeman_FirstName, Po.MiddleName AS Policeman_MiddleName,
       Po.Rank AS Policeman_Rank
FROM Accident A
JOIN Policeman Po ON A.ID_Accident = Po.ID_Accident
WHERE Po.Rank = 'Lieutenant' AND A.Date BETWEEN '2022-01-01' AND '2024-01-01'
ORDER BY A.Date DESC;

-- �������� ���� ����
SET STATISTICS TIME OFF;

