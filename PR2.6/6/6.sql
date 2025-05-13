BEGIN TRAN;

-- Зберігаємо точку перед оновленням
SAVE TRANSACTION BeforeUpdate;

-- Оновлення адреси водія
UPDATE Driver
SET Address = 'New Address, Kyiv'
WHERE ID_Driver = 2;

-- Відкат до точки збереження (зміни не застосуються)
ROLLBACK TRANSACTION BeforeUpdate;

-- Підтверджуємо всі попередні дії до точки збереження
COMMIT;
