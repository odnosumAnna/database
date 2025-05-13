BEGIN TRAN;

-- ������ ���
INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type)
VALUES ('2025-04-10', '10:45', 'Dnipro Central', 2, 'Collision');

-- �������� ID ����� ������ ���
DECLARE @AccidentID INT = SCOPE_IDENTITY();

-- ������ ���������, ���� ����� �� �� ���
INSERT INTO Policeman (ID_Accident, LastName, FirstName, Rank)
VALUES (@AccidentID, 'Shevchenko', 'Oleh', 'Lieutenant');

-- ��������� ������� ������������ (���������, ��������� ������ 2, � ������� 1)
UPDATE Accident
SET Victim_Count = 1
WHERE ID_Accident = @AccidentID;

COMMIT;
