--����� 1: ϳ�������� �������� ������� ������������ � ��� ���
SELECT SUM(Victim_Count) AS TotalVictims FROM Accident;

--����� 2: ������� �� ������� ������������ ������
SELECT AVG(Year) AS AverageVehicleYear FROM Vehicle;

--����� 3: ����� ���������� �� ����������� ������������� ������
SELECT MAX(Year) AS NewestVehicle, MIN(Year) AS OldestVehicle FROM Vehicle;

