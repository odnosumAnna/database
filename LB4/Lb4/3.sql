---- 1. Власна функція для формування П.І.Б. водія
SELECT 
    dbo.GetDriverFullName(LastName, FirstName, MiddleName) AS FullName,
    License_Number
FROM Driver;

--2. Власна функція для перевірки прострочення водійського посвідчення
SELECT 
    LastName,
    FirstName,
    License_Number,
    dbo.CheckLicenseStatus(License_Expiry) AS License_Status
FROM Driver;

--3. Власна функція для класифікації рівня травмування
SELECT 
    LastName,
    FirstName,
    Injury_Type,
    dbo.ClassifyInjurySeverity(Severity) AS Severity_Level
FROM Victim;


