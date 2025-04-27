--Видалити поточний кластеризований індекс (PK):
ALTER TABLE Accident_Investigation
DROP CONSTRAINT PK__Accident__57E7E5C453782ADE;

-- Створення нового кластеризованого індексу на стовпці InvestigationDate
CREATE CLUSTERED INDEX IX_AccidentInvestigation_InvestigationDate
ON Accident_Investigation (InvestigationDate);

