BEGIN TRAN;

-- ��������� ������ ������������ ��� ��� � ID = 1
UPDATE Accident
SET Investigation_Status = 'Closed'
WHERE ID_Accident = 1;

-- ���� ���� ������� �������, ���� � ���������� � �����
IF (SELECT COUNT(*) FROM Culprit WHERE Type = 'Pedestrian') = 0
    ROLLBACK;
ELSE
    COMMIT;
