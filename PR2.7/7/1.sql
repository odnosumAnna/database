-- 1. Спочатку перевіримо наявність дублікатів номерів посвідчень
SELECT 
    License_Number,
    COUNT(*) AS DuplicateCount,
    STRING_AGG(CAST(ID_Driver AS VARCHAR), ', ') AS DuplicateIDs
FROM Driver
GROUP BY License_Number
HAVING COUNT(*) > 1;

-- 2. Виправимо дублікати, додаючи суфікс до номерів посвідчень (крім першого запису)
WITH Duplicates AS (
    SELECT 
        ID_Driver,
        License_Number,
        ROW_NUMBER() OVER (PARTITION BY License_Number ORDER BY ID_Driver) AS rn
    FROM Driver
)
UPDATE d
SET d.License_Number = d.License_Number + '_' + CAST(dup.rn AS VARCHAR(2))
FROM Driver d
JOIN Duplicates dup ON d.ID_Driver = dup.ID_Driver
WHERE dup.rn > 1;

-- 3. Перевіримо, чи залишились дублікати
SELECT 
    License_Number,
    COUNT(*) AS Count
FROM Driver
GROUP BY License_Number
HAVING COUNT(*) > 1;

