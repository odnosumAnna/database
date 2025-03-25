-- ������ ��� ���, �� ������� ������������ ����� 2 � ��� ��� � "Rear-end"
SELECT * 
FROM Accident
WHERE Victim_Count > 2 AND Accident_Type = 'Rear-end';

-- ������ ��� ���, �� ��� ������� ������������ ����� 5, ��� ��� ��� � "Head-on"
SELECT * 
FROM Accident
WHERE Victim_Count > 5 OR Accident_Type = 'Head-on';

-- ������ ��� ���, �� ��� ��� �� � "Rear-end"
SELECT * 
FROM Accident
WHERE NOT Accident_Type = 'Rear-end';

-- ������ ��� ���, �� ������� ������������ �� ����� �� 5
SELECT * 
FROM Accident
WHERE Victim_Count >= 5;

-- ������ ��� ���, �� ���� ������� �� 2021 ����
SELECT * 
FROM Accident
WHERE Date < '2021-01-01';

-- ������ ��� ���, �� ������� ������������ �� ������� 0
SELECT * 
FROM Accident
WHERE Victim_Count <> 0;

-- ������ ��� ��� ���� 2020 ����, �� ����� �� 3 ������������ � ��� �� "Side-swipe"
SELECT * 
FROM Accident
WHERE Date > '2020-12-31' AND Victim_Count > 3 AND NOT Accident_Type = 'Side-swipe';
