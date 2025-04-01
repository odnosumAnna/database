--�������� 6: ������ � ������������� ������� ��� ������� ����
--����� 1: ���������� ������� ���������� ���������� �� ������� ��� �� ���� ���������
SELECT ID_Driver, License_Number, License_Expiry, 
       DATEDIFF(DAY, GETDATE(), License_Expiry) AS DaysUntilExpiry,
       CASE 
           WHEN DATEDIFF(DAY, GETDATE(), License_Expiry) < 0 THEN 'Expired'
           ELSE 'Valid'
       END AS Status
FROM Driver;

--����� 2: ���������� ��� ����� ��� ������� ���
SELECT ID_Accident, Date, 
       DATENAME(WEEKDAY, Date) AS AccidentDay
FROM Accident;

--����� 3: ��������� 7 ��� �� ���� ��� (��� �������� �������)
SELECT ID_Accident, Date, 
       DATEADD(DAY, 7, Date) AS FollowUpDate
FROM Accident;
