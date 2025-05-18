-- �������� 4: ������������ �������� �������� ��������
-- ������� ��� ������ ������� ����������� ���������:
-- PRIMARY KEY, FOREIGN KEY, CHECK, NOT NULL

-- �������� ����������� ��������:

-- ��������� ���������� ������ �������� �������������
ALTER TABLE Victim
ADD CONSTRAINT UQ_Victim_Passport UNIQUE (Passport_Number);

-- ��������� ���������� ������ �������� �������
ALTER TABLE Pedestrian
ADD CONSTRAINT UQ_Pedestrian_Passport UNIQUE (Passport_Number);

-- ��������� NOT NULL ��� Injury_Type
ALTER TABLE Victim
ALTER COLUMN Injury_Type VARCHAR(100) NOT NULL;

-- ��������� �� ��� ���������
ALTER TABLE Culprit
ADD CONSTRAINT CHK_Culprit_Type CHECK (Type IN ('Driver', 'Pedestrian'));