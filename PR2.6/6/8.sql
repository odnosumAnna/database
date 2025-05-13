
CREATE TABLE audit_log (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Action VARCHAR(255) NOT NULL,
    Timestamp DATETIME NOT NULL
);


BEGIN TRAN;

-- Оновлення даних водія ( змінюємо ім'я водія)
UPDATE Driver
SET FirstName = 'Ivan'
WHERE ID_Driver = 1;  

-- Логування змін
INSERT INTO Audit_Log (Action, Timestamp)
VALUES ('Updated driver first name to Ivan', GETDATE());

COMMIT;
