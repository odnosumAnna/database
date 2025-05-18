EXEC InsertAccidentWithTransaction
    @Location = 'Kyiv, Hrushevskoho Street',
    @Date = '2025-04-30',
    @Time = '15:30:00',
    @Victim_Count = 2,
    @Accident_Type = 'Rear-end collision',
    @Investigation_Status = 'Under investigation';

	SELECT * FROM dbo.Accident;
