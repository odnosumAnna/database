BEGIN TRAN;

-- ќновлюЇмо статус розсл≥дуванн€ дл€ ƒ“ѕ з ID = 1
UPDATE Accident
SET Investigation_Status = 'Closed'
WHERE ID_Accident = 1;

-- якщо немаЇ жодного п≥шохода, €кий Ї винуватцем Ч в≥дкат
IF (SELECT COUNT(*) FROM Culprit WHERE Type = 'Pedestrian') = 0
    ROLLBACK;
ELSE
    COMMIT;
