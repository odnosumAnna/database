-- Створюємо глобальну тимчасову таблицю для тестових інцидентів
IF OBJECT_ID('tempdb..##Global_Accidents') IS NOT NULL
    DROP TABLE ##Global_Accidents;
GO

CREATE TABLE ##Global_Accidents (
    Accident_ID INT,
    Date_Accident DATE,
    Location NVARCHAR(100)
);
GO

-- Процедура 1: Додавання інциденту в глобальну тимчасову таблицю
IF OBJECT_ID('tempdb..##Insert_Global_Accident', 'P') IS NOT NULL
    DROP PROCEDURE ##Insert_Global_Accident;
GO

CREATE PROCEDURE ##Insert_Global_Accident
    @Accident_ID INT,
    @Date_Accident DATE,
    @Location NVARCHAR(100)
AS
BEGIN
    INSERT INTO ##Global_Accidents (Accident_ID, Date_Accident, Location)
    VALUES (@Accident_ID, @Date_Accident, @Location);
END;
GO

-- Процедура 2: Отримання всіх записів з глобальної таблиці
IF OBJECT_ID('tempdb..##Get_Global_Accidents', 'P') IS NOT NULL
    DROP PROCEDURE ##Get_Global_Accidents;
GO

CREATE PROCEDURE ##Get_Global_Accidents
AS
BEGIN
    SELECT * FROM ##Global_Accidents;
END;
GO

-- Процедура 3: Очищення глобальної тимчасової таблиці
IF OBJECT_ID('tempdb..##Clear_Global_Accidents', 'P') IS NOT NULL
    DROP PROCEDURE ##Clear_Global_Accidents;
GO

CREATE PROCEDURE ##Clear_Global_Accidents
AS
BEGIN
    DELETE FROM ##Global_Accidents;
END;
GO
