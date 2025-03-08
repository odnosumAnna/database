-- Створення таблиці ДТП
CREATE TABLE Accident (
    ID_Accident INT PRIMARY KEY IDENTITY(1,1),
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Victim_Count INT CHECK (Victim_Count >= 0),
    Accident_Type VARCHAR(50) NOT NULL,
    Investigation_Status VARCHAR(20)
);

-- Створення таблиці Участь водія у ДТП
CREATE TABLE Driver_Involvement (
    ID_Accident INT NOT NULL FOREIGN KEY REFERENCES Accident(ID_Accident),
    ID_Driver INT NOT NULL,
    Role VARCHAR(20) NOT NULL,
    Involvement_Status VARCHAR(20),
    Fixation_Time DATETIME NOT NULL,
    PRIMARY KEY (ID_Accident, ID_Driver)
);

-- Створення таблиці Транспортний засіб
CREATE TABLE Vehicle (
    ID_Vehicle INT PRIMARY KEY IDENTITY(1,1),
    ID_Accident INT NOT NULL FOREIGN KEY REFERENCES Accident(ID_Accident),
    License_Plate VARCHAR(10) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Year INT CHECK (Year >= 1900 AND Year <= YEAR(GETDATE()))
);

-- Створення таблиці Водій
CREATE TABLE Driver (
    ID_Driver INT PRIMARY KEY IDENTITY(1,1),
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    Address VARCHAR(100) NOT NULL,
    License_Number VARCHAR(10) NOT NULL,
    License_Expiry DATE NOT NULL,
    Phone VARCHAR(15)
);

-- Створення таблиці Міліціонер
CREATE TABLE Policeman (
    ID_Policeman INT PRIMARY KEY IDENTITY(1,1),
    ID_Accident INT NOT NULL FOREIGN KEY REFERENCES Accident(ID_Accident),
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    Rank VARCHAR(30) NOT NULL,
    Department VARCHAR(50)
);

-- Створення таблиці Постраждалий
CREATE TABLE Victim (
    ID_Victim INT PRIMARY KEY IDENTITY(1,1),
    ID_Accident INT NOT NULL FOREIGN KEY REFERENCES Accident(ID_Accident),
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    Address VARCHAR(100) NOT NULL,
    Passport_Number VARCHAR(9) NOT NULL,
    Injury_Type VARCHAR(100) NOT NULL,
    Severity VARCHAR(20),
    Hospitalization_Status VARCHAR(20)
);

-- Створення таблиці Пішохід
CREATE TABLE Pedestrian (
    ID_Pedestrian INT PRIMARY KEY IDENTITY(1,1),
    ID_Accident INT NOT NULL FOREIGN KEY REFERENCES Accident(ID_Accident),
    LastName VARCHAR(50) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50),
    Address VARCHAR(100) NOT NULL,
    Passport_Number VARCHAR(9) NOT NULL,
    Is_Victim BIT NOT NULL
);
