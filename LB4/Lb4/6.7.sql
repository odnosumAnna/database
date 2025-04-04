-- 7. Видалити відомості про ДТП, які сталися раніше вказаної дати:

CREATE PROCEDURE dbo.DeleteAccidentsBeforeDate
(
    @Date DATE
)
AS
BEGIN
    -- Спочатку видаляємо залежні записи з таблиці Vehicle
    DELETE FROM Vehicle
    WHERE ID_Accident IN (SELECT ID_Accident FROM Accident WHERE Date < @Date);

    -- Потім видаляємо залежні записи з таблиці Driver_Involvement
    DELETE FROM Driver_Involvement
    WHERE ID_Accident IN (SELECT ID_Accident FROM Accident WHERE Date < @Date);

    -- Тепер видаляємо записи з таблиці Accident
    DELETE FROM Accident
    WHERE Date < @Date;
END;