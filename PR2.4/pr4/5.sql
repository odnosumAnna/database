--Завдання 5: Запити з використанням рядкових функцій
--Запит 1: Перетворення імен водіїв у верхній регістр
SELECT ID_Driver, FirstName, LastName, 
       UPPER(FirstName) AS UpperFirstName, 
       UPPER(LastName) AS UpperLastName
FROM Driver;

--Запит 2: Витягування серії та номера водійського посвідчення
SELECT ID_Driver, License_Number, 
       LEFT(License_Number, 2) AS LicenseSeries, 
       RIGHT(License_Number, 6) AS LicenseNumber
FROM Driver;
--Запит 3: Видалення пробілів з номера автомобіля
SELECT ID_Vehicle, License_Plate, 
       TRIM(License_Plate) AS TrimmedLicensePlate
FROM Vehicle;
