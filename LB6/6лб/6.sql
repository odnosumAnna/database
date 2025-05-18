BEGIN TRANSACTION;

DECLARE @i INT = 1;

WHILE @i <= 10000 -- or more, up to 100000
BEGIN
    INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
    VALUES (
        DATEADD(DAY, -@i, GETDATE()),  -- Date of the accident
        CAST(DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % 86400, 0) AS TIME),  -- Random time of day
        CONCAT('Location #', @i),  -- Location name with number
        ABS(CHECKSUM(NEWID()) % 5),  -- Number of victims (0-4)
        CASE ABS(CHECKSUM(NEWID()) % 3)  -- Type of accident
            WHEN 0 THEN 'Collision'
            WHEN 1 THEN 'Hit'
            ELSE 'Other'
        END,
        CASE ABS(CHECKSUM(NEWID()) % 2)  -- Investigation status
            WHEN 0 THEN 'Open'
            ELSE 'Closed'
        END
    );

    SET @i += 1;
END

COMMIT TRANSACTION;
