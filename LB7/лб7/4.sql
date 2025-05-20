-- Завдання 4: DDL тригери

-- Тригер для відстеження створення таблиць
CREATE TRIGGER tr_Database_CreateTable
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    PRINT 'Було створено нову таблицю'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') AS 'Нова таблиця'
END;
GO

-- Тригер для відстеження змін у структурі таблиць
CREATE TRIGGER tr_Database_AlterTable
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    PRINT 'Було змінено структуру таблиці'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') AS 'Змінена таблиця'
END;
GO

-- Тригер для відстеження видалення таблиць
CREATE TRIGGER tr_Database_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    PRINT 'Було видалено таблицю'
    SELECT EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)') AS 'Видалена таблиця'
END;
GO
