-- Створення таблиці Розслідування ДТП
CREATE TABLE Accident_Investigation (
    ID_Investigation INT PRIMARY KEY IDENTITY(1,1),
    ID_Accident INT NOT NULL,
    InvestigationDate DATE NOT NULL,
    InvestigationStatus VARCHAR(50) NOT NULL,
    InvestigatorName VARCHAR(100) NOT NULL,
    InvestigationDetails TEXT,
    FOREIGN KEY (ID_Accident) REFERENCES Accident(ID_Accident) ON DELETE CASCADE
);

-- Автоматичне вставлення тестових даних у таблицю Accident_Investigation
DECLARE @i INT = 1;

-- Вставка 100 записів у таблицю Accident_Investigation
WHILE @i <= 100
BEGIN
    INSERT INTO Accident_Investigation (ID_Accident, InvestigationDate, InvestigationStatus, InvestigatorName, InvestigationDetails)
    VALUES (
        @i, -- ID_Accident (збільшується на одиницю)
        DATEADD(DAY, -@i, GETDATE()), -- InvestigationDate (сьогодні - i днів)
        CASE 
            WHEN @i % 2 = 0 THEN 'Completed' 
            ELSE 'In Progress' 
        END, -- InvestigationStatus (чергується між 'Completed' і 'In Progress')
        CONCAT('Investigator ', @i), -- InvestigatorName (простий конкатенація 'Investigator' і ID)
        CONCAT('Investigation details for accident ', @i) -- InvestigationDetails (простий текст)
    );
    
    SET @i = @i + 1;
END;