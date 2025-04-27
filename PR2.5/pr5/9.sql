CREATE NONCLUSTERED INDEX IX_Filtered_InvestigationStatus_Open
ON Accident(Investigation_Status)
WHERE Investigation_Status = 'Open';

SELECT *
FROM Accident
WHERE Investigation_Status = 'Open';
