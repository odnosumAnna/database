BEGIN TRAN;

-- ������ ��������� ���� ��� (������� ���������� ������)
UPDATE Accident
SET Date = '2025-01-01'
WHERE ID_Accident = 9999;

-- ���� ������� ������� � �������� ����������
IF @@ERROR <> 0
    ROLLBACK;
ELSE
    COMMIT;
