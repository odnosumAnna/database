-- ��������� ������� ������������ ���
CREATE TABLE Accident_Investigation (
    ID_Investigation INT PRIMARY KEY IDENTITY(1,1),
    ID_Accident INT NOT NULL,
    InvestigationDate DATE NOT NULL,
    InvestigationStatus VARCHAR(50) NOT NULL,
    InvestigatorName VARCHAR(100) NOT NULL,
    InvestigationDetails TEXT,
    FOREIGN KEY (ID_Accident) REFERENCES Accident(ID_Accident) ON DELETE CASCADE
);

-- ����������� ���������� �������� ����� � ������� Accident_Investigation
DECLARE @i INT = 1;

-- ������� 100 ������ � ������� Accident_Investigation
WHILE @i <= 100
BEGIN
    INSERT INTO Accident_Investigation (ID_Accident, InvestigationDate, InvestigationStatus, InvestigatorName, InvestigationDetails)
    VALUES (
        @i, -- ID_Accident (���������� �� �������)
        DATEADD(DAY, -@i, GETDATE()), -- InvestigationDate (������� - i ���)
        CASE 
            WHEN @i % 2 = 0 THEN 'Completed' 
            ELSE 'In Progress' 
        END, -- InvestigationStatus (��������� �� 'Completed' � 'In Progress')
        CONCAT('Investigator ', @i), -- InvestigatorName (������� ������������ 'Investigator' � ID)
        CONCAT('Investigation details for accident ', @i) -- InvestigationDetails (������� �����)
    );
    
    SET @i = @i + 1;
END;