BEGIN TRAN;

-- �������� ����� ����� ����������
SAVE TRANSACTION BeforeUpdate;

-- ��������� ������ ����
UPDATE Driver
SET Address = 'New Address, Kyiv'
WHERE ID_Driver = 2;

-- ³���� �� ����� ���������� (���� �� ������������)
ROLLBACK TRANSACTION BeforeUpdate;

-- ϳ���������� �� �������� 䳿 �� ����� ����������
COMMIT;
