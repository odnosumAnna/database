-- Заповнення таблиці Accident (10000 записів)
DECLARE @i INT = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Accident (Date, Time, Location, Victim_Count, Accident_Type, Investigation_Status)
    VALUES (
        DATEADD(day, -ABS(CHECKSUM(NEWID())) % 1825, GETDATE()), -- Випадкова дата за останні 5 років
        CONVERT(TIME, DATEADD(minute, ABS(CHECKSUM(NEWID())) % 1440, 0)), -- Випадковий час
        CASE ABS(CHECKSUM(NEWID())) % 10 
            WHEN 0 THEN 'Main St' WHEN 1 THEN 'Oak Ave' WHEN 2 THEN 'Pine St' 
            WHEN 3 THEN 'Elm St' WHEN 4 THEN 'Maple Dr' WHEN 5 THEN 'Cedar Ln' 
            WHEN 6 THEN 'Birch Rd' WHEN 7 THEN 'Highway 101' WHEN 8 THEN '5th Avenue' 
            ELSE 'Park Blvd' END,
        ABS(CHECKSUM(NEWID())) % 6, -- Кількість постраждалих (0-5)
        CASE ABS(CHECKSUM(NEWID())) % 5 
            WHEN 0 THEN 'Rear-end' WHEN 1 THEN 'Side-impact' WHEN 2 THEN 'Head-on' 
            WHEN 3 THEN 'Roll-over' ELSE 'Pedestrian' END,
        CASE ABS(CHECKSUM(NEWID())) % 3 
            WHEN 0 THEN 'Open' WHEN 1 THEN 'Closed' ELSE 'Under Investigation' END
    );
    SET @i = @i + 1;
END;

-- Заповнення таблиці Driver 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Driver (LastName, FirstName, MiddleName, Address, License_Number, License_Expiry, Phone)
    VALUES (
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' 
            WHEN 3 THEN 'Brown' WHEN 4 THEN 'Jones' WHEN 5 THEN 'Garcia' 
            WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis' WHEN 8 THEN 'Rodriguez' 
            WHEN 9 THEN 'Martinez' WHEN 10 THEN 'Wilson' WHEN 11 THEN 'Anderson' 
            WHEN 12 THEN 'Taylor' WHEN 13 THEN 'Thomas' WHEN 14 THEN 'Hernandez' 
            WHEN 15 THEN 'Moore' WHEN 16 THEN 'Martin' WHEN 17 THEN 'Jackson' 
            WHEN 18 THEN 'Thompson' ELSE 'White' END,
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'John' WHEN 1 THEN 'Robert' WHEN 2 THEN 'Michael' 
            WHEN 3 THEN 'William' WHEN 4 THEN 'David' WHEN 5 THEN 'Richard' 
            WHEN 6 THEN 'Joseph' WHEN 7 THEN 'Thomas' WHEN 8 THEN 'Charles' 
            WHEN 9 THEN 'Daniel' WHEN 10 THEN 'Matthew' WHEN 11 THEN 'Anthony' 
            WHEN 12 THEN 'Donald' WHEN 13 THEN 'Mark' WHEN 14 THEN 'Paul' 
            WHEN 15 THEN 'Steven' WHEN 16 THEN 'Andrew' WHEN 17 THEN 'Kenneth' 
            WHEN 18 THEN 'Joshua' ELSE 'Kevin' END,
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26),
        CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR) + ' ' + 
        CASE ABS(CHECKSUM(NEWID())) % 10 
            WHEN 0 THEN 'Main' WHEN 1 THEN 'Oak' WHEN 2 THEN 'Pine' 
            WHEN 3 THEN 'Elm' WHEN 4 THEN 'Maple' WHEN 5 THEN 'Cedar' 
            WHEN 6 THEN 'Birch' WHEN 7 THEN 'Spruce' WHEN 8 THEN 'Willow' 
            ELSE 'Ash' END + ' ' +
        CASE ABS(CHECKSUM(NEWID())) % 5 
            WHEN 0 THEN 'St' WHEN 1 THEN 'Ave' WHEN 2 THEN 'Dr' 
            WHEN 3 THEN 'Ln' ELSE 'Blvd' END,
        'AB' + RIGHT('00000' + CAST(ABS(CHECKSUM(NEWID())) % 100000 AS VARCHAR(5)), 5),
        DATEADD(day, ABS(CHECKSUM(NEWID())) % 1825, GETDATE()),
        '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4)
    );
    SET @i = @i + 1;
END;







-- Заповнення таблиці Vehicle 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Vehicle (ID_Accident, License_Plate, Model, Year)
    VALUES (
        (SELECT TOP 1 ID_Accident FROM Accident ORDER BY NEWID()),
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + 
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26) + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4),
        CASE ABS(CHECKSUM(NEWID())) % 10 
            WHEN 0 THEN 'Toyota Camry' WHEN 1 THEN 'Honda Accord' WHEN 2 THEN 'Ford F-150' 
            WHEN 3 THEN 'Chevrolet Silverado' WHEN 4 THEN 'Nissan Altima' WHEN 5 THEN 'Toyota Corolla' 
            WHEN 6 THEN 'Honda Civic' WHEN 7 THEN 'Ram 1500' WHEN 8 THEN 'Chevrolet Equinox' 
            ELSE 'Ford Explorer' END,
        2000 + ABS(CHECKSUM(NEWID())) % 23 -- Рік випуску 2000-2023
    );
    SET @i = @i + 1;
END;

-- Заповнення таблиці Driver_Involvement 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Driver_Involvement (ID_Accident, ID_Driver, Role, Involvement_Status, Fixation_Time)
    VALUES (
        (SELECT TOP 1 ID_Accident FROM Accident ORDER BY NEWID()),
        (SELECT TOP 1 ID_Driver FROM Driver ORDER BY NEWID()),
        CASE ABS(CHECKSUM(NEWID())) % 3 WHEN 0 THEN 'Driver' WHEN 1 THEN 'Passenger' ELSE 'Witness' END,
        CASE ABS(CHECKSUM(NEWID())) % 4 
            WHEN 0 THEN 'Responsible' WHEN 1 THEN 'Injured' WHEN 2 THEN 'Not Involved' ELSE 'Witness' END,
        DATEADD(minute, -ABS(CHECKSUM(NEWID())) % 10080, GETDATE()) -- До 7 днів тому
    );
    SET @i = @i + 1;
END;

-- Заповнення таблиці Victim 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Victim (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Injury_Type, Severity, Hospitalization_Status)
    VALUES (
        (SELECT TOP 1 ID_Accident FROM Accident ORDER BY NEWID()),
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' 
            WHEN 3 THEN 'Brown' WHEN 4 THEN 'Jones' WHEN 5 THEN 'Garcia' 
            WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis' WHEN 8 THEN 'Rodriguez' 
            WHEN 9 THEN 'Martinez' WHEN 10 THEN 'Wilson' WHEN 11 THEN 'Anderson' 
            WHEN 12 THEN 'Taylor' WHEN 13 THEN 'Thomas' WHEN 14 THEN 'Hernandez' 
            WHEN 15 THEN 'Moore' WHEN 16 THEN 'Martin' WHEN 17 THEN 'Jackson' 
            WHEN 18 THEN 'Thompson' ELSE 'White' END,
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'John' WHEN 1 THEN 'Robert' WHEN 2 THEN 'Michael' 
            WHEN 3 THEN 'William' WHEN 4 THEN 'David' WHEN 5 THEN 'Richard' 
            WHEN 6 THEN 'Joseph' WHEN 7 THEN 'Thomas' WHEN 8 THEN 'Charles' 
            WHEN 9 THEN 'Daniel' WHEN 10 THEN 'Matthew' WHEN 11 THEN 'Anthony' 
            WHEN 12 THEN 'Donald' WHEN 13 THEN 'Mark' WHEN 14 THEN 'Paul' 
            WHEN 15 THEN 'Steven' WHEN 16 THEN 'Andrew' WHEN 17 THEN 'Kenneth' 
            WHEN 18 THEN 'Joshua' ELSE 'Kevin' END,
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26),
        CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR) + ' ' + 
        CASE ABS(CHECKSUM(NEWID())) % 10 
            WHEN 0 THEN 'Main' WHEN 1 THEN 'Oak' WHEN 2 THEN 'Pine' 
            WHEN 3 THEN 'Elm' WHEN 4 THEN 'Maple' WHEN 5 THEN 'Cedar' 
            WHEN 6 THEN 'Birch' WHEN 7 THEN 'Spruce' WHEN 8 THEN 'Willow' 
            ELSE 'Ash' END + ' ' +
        CASE ABS(CHECKSUM(NEWID())) % 5 
            WHEN 0 THEN 'St' WHEN 1 THEN 'Ave' WHEN 2 THEN 'Dr' 
            WHEN 3 THEN 'Ln' ELSE 'Blvd' END,
        'AB' + RIGHT('0000000' + CAST(ABS(CHECKSUM(NEWID())) % 10000000 AS VARCHAR(7)), 7),
        CASE ABS(CHECKSUM(NEWID())) % 6 
            WHEN 0 THEN 'Head injury' WHEN 1 THEN 'Broken bones' WHEN 2 THEN 'Internal bleeding' 
            WHEN 3 THEN 'Lacerations' WHEN 4 THEN 'Spinal injury' ELSE 'Burns' END,
        CASE ABS(CHECKSUM(NEWID())) % 3 WHEN 0 THEN 'Mild' WHEN 1 THEN 'Moderate' ELSE 'Severe' END,
        CASE ABS(CHECKSUM(NEWID())) % 3 WHEN 0 THEN 'Hospitalized' WHEN 1 THEN 'Outpatient' ELSE 'No Hospitalization' END
    );
    SET @i = @i + 1;
END;



-- Заповнення таблиці Pedestrian 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Pedestrian (ID_Accident, LastName, FirstName, MiddleName, Address, Passport_Number, Is_Victim, Phone)
    VALUES (
        (SELECT TOP 1 ID_Accident FROM Accident ORDER BY NEWID()),
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' 
            WHEN 3 THEN 'Brown' WHEN 4 THEN 'Jones' WHEN 5 THEN 'Garcia' 
            WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis' WHEN 8 THEN 'Rodriguez' 
            WHEN 9 THEN 'Martinez' WHEN 10 THEN 'Wilson' WHEN 11 THEN 'Anderson' 
            WHEN 12 THEN 'Taylor' WHEN 13 THEN 'Thomas' WHEN 14 THEN 'Hernandez' 
            WHEN 15 THEN 'Moore' WHEN 16 THEN 'Martin' WHEN 17 THEN 'Jackson' 
            WHEN 18 THEN 'Thompson' ELSE 'White' END,
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'John' WHEN 1 THEN 'Robert' WHEN 2 THEN 'Michael' 
            WHEN 3 THEN 'William' WHEN 4 THEN 'David' WHEN 5 THEN 'Richard' 
            WHEN 6 THEN 'Joseph' WHEN 7 THEN 'Thomas' WHEN 8 THEN 'Charles' 
            WHEN 9 THEN 'Daniel' WHEN 10 THEN 'Matthew' WHEN 11 THEN 'Anthony' 
            WHEN 12 THEN 'Donald' WHEN 13 THEN 'Mark' WHEN 14 THEN 'Paul' 
            WHEN 15 THEN 'Steven' WHEN 16 THEN 'Andrew' WHEN 17 THEN 'Kenneth' 
            WHEN 18 THEN 'Joshua' ELSE 'Kevin' END,
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26),
        CAST(ABS(CHECKSUM(NEWID())) % 1000 AS VARCHAR) + ' ' + 
        CASE ABS(CHECKSUM(NEWID())) % 10 
            WHEN 0 THEN 'Main' WHEN 1 THEN 'Oak' WHEN 2 THEN 'Pine' 
            WHEN 3 THEN 'Elm' WHEN 4 THEN 'Maple' WHEN 5 THEN 'Cedar' 
            WHEN 6 THEN 'Birch' WHEN 7 THEN 'Spruce' WHEN 8 THEN 'Willow' 
            ELSE 'Ash' END + ' ' +
        CASE ABS(CHECKSUM(NEWID())) % 5 
            WHEN 0 THEN 'St' WHEN 1 THEN 'Ave' WHEN 2 THEN 'Dr' 
            WHEN 3 THEN 'Ln' ELSE 'Blvd' END,
        'CD' + RIGHT('0000000' + CAST(ABS(CHECKSUM(NEWID())) % 10000000 AS VARCHAR(7)), 7),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 3 = 0 THEN 0 ELSE 1 END,
        '555-' + RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS VARCHAR(4)), 4)
    );
    SET @i = @i + 1;
END;

-- Заповнення таблиці Policeman 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    INSERT INTO Policeman (ID_Accident, LastName, FirstName, MiddleName, Rank, Department)
    VALUES (
        (SELECT TOP 1 ID_Accident FROM Accident ORDER BY NEWID()),
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' 
            WHEN 3 THEN 'Brown' WHEN 4 THEN 'Jones' WHEN 5 THEN 'Garcia' 
            WHEN 6 THEN 'Miller' WHEN 7 THEN 'Davis' WHEN 8 THEN 'Rodriguez' 
            WHEN 9 THEN 'Martinez' WHEN 10 THEN 'Wilson' WHEN 11 THEN 'Anderson' 
            WHEN 12 THEN 'Taylor' WHEN 13 THEN 'Thomas' WHEN 14 THEN 'Hernandez' 
            WHEN 15 THEN 'Moore' WHEN 16 THEN 'Martin' WHEN 17 THEN 'Jackson' 
            WHEN 18 THEN 'Thompson' ELSE 'White' END,
        CASE ABS(CHECKSUM(NEWID())) % 20 
            WHEN 0 THEN 'John' WHEN 1 THEN 'Robert' WHEN 2 THEN 'Michael' 
            WHEN 3 THEN 'William' WHEN 4 THEN 'David' WHEN 5 THEN 'Richard' 
            WHEN 6 THEN 'Joseph' WHEN 7 THEN 'Thomas' WHEN 8 THEN 'Charles' 
            WHEN 9 THEN 'Daniel' WHEN 10 THEN 'Matthew' WHEN 11 THEN 'Anthony' 
            WHEN 12 THEN 'Donald' WHEN 13 THEN 'Mark' WHEN 14 THEN 'Paul' 
            WHEN 15 THEN 'Steven' WHEN 16 THEN 'Andrew' WHEN 17 THEN 'Kenneth' 
            WHEN 18 THEN 'Joshua' ELSE 'Kevin' END,
        CHAR(65 + ABS(CHECKSUM(NEWID())) % 26),
        CASE ABS(CHECKSUM(NEWID())) % 5 
            WHEN 0 THEN 'Officer' WHEN 1 THEN 'Sergeant' WHEN 2 THEN 'Lieutenant' 
            WHEN 3 THEN 'Captain' ELSE 'Detective' END,
        CASE ABS(CHECKSUM(NEWID())) % 3 
            WHEN 0 THEN 'Traffic Division' WHEN 1 THEN 'Patrol Division' ELSE 'Special Operations' END
    );
    SET @i = @i + 1;
END;

-- Заповнення таблиці Culprit 
SET @i = 1;
WHILE @i <= 10000
BEGIN
    DECLARE @RelatedID INT;
    DECLARE @Type VARCHAR(20);
    
    -- Визначаємо тип винуватця (50% водії, 50% пішоходи)
    IF ABS(CHECKSUM(NEWID())) % 2 = 0 
    BEGIN
        SET @Type = 'Driver';
        -- Отримуємо випадковий ID водія, який точно існує
        SELECT @RelatedID = ID_Driver FROM Driver 
        WHERE ID_Driver = (SELECT TOP 1 ID_Driver FROM Driver ORDER BY NEWID());
    END
    ELSE
    BEGIN
        SET @Type = 'Pedestrian';
        -- Отримуємо випадковий ID пішохода, який точно існує
        SELECT @RelatedID = ID_Pedestrian FROM Pedestrian 
        WHERE ID_Pedestrian = (SELECT TOP 1 ID_Pedestrian FROM Pedestrian ORDER BY NEWID());
    END
    
    -- Вставляємо запис тільки якщо знайшли відповідний ID
    IF @RelatedID IS NOT NULL
    BEGIN
        INSERT INTO Culprit (ID_Related, ID_Accident, Type)
        VALUES (
            @RelatedID,
            (SELECT TOP 1 ID_Accident FROM Accident ORDER BY NEWID()),
            @Type
        );
    END
    
    SET @i = @i + 1;
END;