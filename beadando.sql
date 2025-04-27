-- ÜGYFEL_MASZKOLT tábla létrehozása maszkolással ahol az érzékeny adatok
-- azaz az EMAIL, NEV, és CIM mezők kerülnek maszkolásra.
-- A maszkolt ügyfél tábla az eredeti ÜGYFEL tábla adataiból készül.

-- Az oszlopokat a megfelelő függvényekkel maszkoljuk:
-- Email címhez az email() függvény stb.
CREATE TABLE dbo.ÜGYFEL_MASZKOLT (
    LOGIN VARCHAR(32) INT PRIMARY KEY,
    EMAIL VARCHAR(64) MASKED WITH (FUNCTION = 'email()') NULL,
    NEV VARCHAR(64) MASKED WITH (FUNCTION = 'partial(1,"xxx",0)') NULL,
    NEM VARCHAR(1), -- A nem nem kerül maszkolásra
    CIM VARCHAR(128) MASKED WITH (FUNCTION = 'partial(0,"X",0)') NULL
);

-- Maszkolt tábla feltöltése
INSERT INTO dbo.ÜGYFEL_MASZKOLT (ID, EMAIL, NEV, NEM, CIM)
SELECT ID, EMAIL, NEV, NEM, CIM FROM dbo.ÜGYFEL;

-- User létrehozása
CREATE LOGIN MaskoltUser WITH PASSWORD = 'ValamiJelszo@2025';
USE Webshop;
CREATE USER MaskoltUser FOR LOGIN MaskoltUser;
GRANT SELECT ON dbo.ÜGYFEL_MASZKOLT TO MaskoltUser;

-- Lekérdezés teszt mint MaskoltUser
EXECUTE AS USER = 'MaskoltUser';
SELECT EMAIL, NEV, NEM, CIM FROM dbo.ÜGYFEL_MASZKOLT;

REVERT;

