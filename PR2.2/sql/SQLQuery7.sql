--�������� 3: ������������ ��������� WHERE
SELECT * FROM Accident WHERE Victim_Count > 2;

--�������� 4: ������������ ������� ��������� � WHERE
SELECT * FROM Accident 
WHERE Victim_Count > 2 
AND Investigation_Status = 'Open';

--��������  5: ������������ ��������� LIKE
SELECT * FROM Accident 
WHERE Location LIKE '% Street' 
   OR Location LIKE '% St';

-- �������� 6: ������������ INNER JOIN
SELECT A.*, V.LastName AS Victim_LastName, V.FirstName AS Victim_FirstName
FROM Accident A
INNER JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- �������� 7: ������������ LEFT JOIN
SELECT A.*, 
       COALESCE(V.LastName, 'No Victim') AS Victim_LastName, 
       COALESCE(V.FirstName, 'No Victim') AS Victim_FirstName
FROM Accident A
LEFT JOIN Victim V ON A.ID_Accident = V.ID_Accident;

-- �������� 8: ������������ ���������� ������ (SUBQUERY)
SELECT * 
FROM Accident 
WHERE EXISTS (
    SELECT 1 
    FROM Victim 
    WHERE Victim.ID_Accident = Accident.ID_Accident
    AND Victim.Severity = 'Severe'
);

-- �������� 9: ������������ GROUP BY �� HAVING
SELECT Accident_Type, COUNT(*) AS Total_Accidents 
FROM Accident 
GROUP BY Accident_Type 
HAVING COUNT(*) > 1;

-- �������� 10: �������� ��������������� JOIN
SELECT A.*, 
       V.LastName AS Victim_LastName, 
       V.FirstName AS Victim_FirstName, 
       D.LastName AS Driver_LastName, 
       D.FirstName AS Driver_FirstName
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
JOIN Driver_Involvement DI ON A.ID_Accident = DI.ID_Accident
JOIN Driver D ON DI.ID_Driver = D.ID_Driver
WHERE A.Victim_Count > 1;

-- �������� 11: WHERE � ������� � JOIN
SELECT A.*, 
       V.LastName AS Victim_LastName, 
       V.FirstName AS Victim_FirstName
FROM Accident A
JOIN Victim V ON A.ID_Accident = V.ID_Accident
WHERE A.Investigation_Status = 'Open';
