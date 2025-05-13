BEGIN TRAN;

-- Спроба оновлення дати ДТП (можливо неіснуючого запису)
UPDATE Accident
SET Date = '2025-01-01'
WHERE ID_Accident = 9999;

-- Якщо сталася помилка — відкочуємо транзакцію
IF @@ERROR <> 0
    ROLLBACK;
ELSE
    COMMIT;
