CREATE DATABASE Litenbokhandel;
USE Litenbokhandel;

CREATE TABLE Bocker (
    ISBN VARCHAR(100) PRIMARY KEY,
    Titel VARCHAR(255) NOT NULL,
    Forfattare VARCHAR(255) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL CHECK (Pris > 0), -- Krav 5: Constraint Pris > 0
    Lagerstatus INT NOT NULL CHECK (Lagerstatus >= 0)
);

CREATE TABLE Kunder (
    KundID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Epost VARCHAR(255) NOT NULL UNIQUE,
    Telefon VARCHAR(20) NOT NULL,
    Adress VARCHAR(255) NOT NULL
);

-- Krav 5: Skapa index på e-post
CREATE INDEX idx_epost ON Kunder(Epost);

CREATE TABLE Bestallningar (
    Ordernummer INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT NOT NULL,
    Datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Totalbelopp DECIMAL(10,2) NOT NULL CHECK (Totalbelopp >= 0),
    FOREIGN KEY (KundID) REFERENCES Kunder (KundID) ON DELETE CASCADE
);

CREATE TABLE Orderrader (
    OrderradID INT AUTO_INCREMENT PRIMARY KEY,
    Ordernummer INT NOT NULL,
    BokISBN VARCHAR(100) NOT NULL,
    Antal INT NOT NULL CHECK (Antal > 0),
    Enhetspris DECIMAL(10,2) NOT NULL CHECK (Enhetspris >= 0),
    UNIQUE (Ordernummer, BokISBN),
    FOREIGN KEY (Ordernummer) REFERENCES Bestallningar(Ordernummer) ON DELETE CASCADE,
    FOREIGN KEY (BokISBN) REFERENCES Bocker(ISBN)
);

-- Tabell för Trigger-loggning
CREATE TABLE KundLogg (
    LogID INT AUTO_INCREMENT PRIMARY KEY, 
    Meddelande VARCHAR(255), 
    Datum DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
-- Minskar lagersaldo efter en order
CREATE TRIGGER UpdateLager AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    UPDATE Bocker SET Lagerstatus = Lagerstatus - NEW.Antal WHERE ISBN = NEW.BokISBN;
END; //

-- Loggar när en ny kund registreras
CREATE TRIGGER LoggaNyKund AFTER INSERT ON Kunder
FOR EACH ROW
BEGIN
    INSERT INTO KundLogg (Meddelande) VALUES (CONCAT('Ny kund: ', NEW.Namn));
END; //
DELIMITER ;

INSERT INTO Kunder (Namn, Epost, Telefon, Adress) VALUES
('Karl Marx', 'Karl@email.com', '0725963059', 'Rödavägen 2'),
('John Ark', 'John@email.com', '0720538322', 'Blåvägen 4'),
('Mike Kock', 'Mike@email.com', '0729231490', 'Gulavägen 6'),
('Olle Oplacerad', 'olle@email.com', '0701112233', 'Tomtegatan 1');

INSERT INTO Bocker (Titel, ISBN, Forfattare, Pris, Lagerstatus) VALUES
('The Witcher', '95-646-75-87', 'Andrzej Sapkowski', 699.00, 10),
('Dune', '45-646-35-86', 'Frank Herbert', 299.00, 6),
('Star Wars', '25-456-35-85', 'George Lucas', 499.00, 5);

INSERT INTO Bestallningar (KundID, Datum, Totalbelopp) VALUES
(2, '2025-03-12', 699.00),
(3, '2025-06-24', 798.00),
(1, '2024-11-04', 1198.00),
(1, '2024-11-05', 299.00); 

INSERT INTO Orderrader (Ordernummer, BokISBN, Antal, Enhetspris) VALUES
(1, '95-646-75-87', 1, 699.00),
(2, '45-646-35-86', 1, 299.00),
(2, '25-456-35-85', 1, 499.00),
(3, '95-646-75-87', 1, 699.00),
(4, '45-646-35-86', 1, 299.00);




-- Hämta, filtrera och sortera
SELECT * FROM Kunder WHERE Namn LIKE 'K%' OR Epost = 'John@email.com';
SELECT * FROM Bocker ORDER BY Pris DESC;

-- Transaktioner (Update & Delete)
START TRANSACTION;
UPDATE Kunder SET Epost = 'karl.ny@email.com' WHERE Namn = 'Karl Marx';
DELETE FROM Kunder WHERE KundID = 3; 
ROLLBACK; 
COMMIT;

-- INNER JOIN (Bara de som handlat)
SELECT Kunder.Namn, Bestallningar.Ordernummer FROM Kunder 
INNER JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID;

-- LEFT JOIN 
SELECT Kunder.Namn, Bestallningar.Ordernummer FROM Kunder 
LEFT JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID;

-- GROUP BY & HAVING 
SELECT Kunder.Namn, COUNT(Bestallningar.Ordernummer) AS AntalOrder
FROM Kunder
JOIN Bestallningar ON Kunder.KundID = Bestallningar.KundID
GROUP BY Kunder.Namn
HAVING AntalOrder > 1;

SELECT * FROM KundLogg; -- Kolla att logg-triggern kördes
SELECT Titel, Lagerstatus FROM Bocker; -- Kolla att lager-triggern drog av böcker

