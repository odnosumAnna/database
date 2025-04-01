--�������� 4: ������ � ������������� ������� �������
--����� 1: ��������� ��� �� �����
SELECT ID_Accident, Date, 
       ROW_NUMBER() OVER (ORDER BY Date) AS AccidentNumber
FROM Accident;
--����� 2: ���������� ������� ������������ � ����� ��� �� �������� ������� �� ��� �������
SELECT ID_Accident, Victim_Count, 
       AVG(Victim_Count) OVER () AS AvgVictimCount
FROM Accident;
--����� 3: ���������� ������� ��� �� ��������� ����� (� ������������)
SELECT ID_Accident, Date, 
       COUNT(ID_Accident) OVER (ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeAccidents
FROM Accident;
