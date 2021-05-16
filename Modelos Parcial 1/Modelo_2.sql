-- 1) Listar por cada viaje: El ID, el fecha, la capacidad del camión que lo realiza y la cantidad de paquetes de hasta 50 kilos y la cantidad de paquetes
-- que superen los 50 kilos que transportó dicho viaje.

SELECT V.ID, V.Fecha, C.Capacidad, 
(
SELECT COUNT(PA.ID) FROM Paquetes PA
WHERE PA.Peso <= 50
), 
(
SELECT COUNT(PA.ID) FROM Paquetes PA
WHERE PA.Peso > 50
),
FROM Viajes V
INNER JOIN Camiones C ON V.Patente = C.Patente
GO

-- 2) Listar la información de los camiones que hayan realizado viajes el año pasado y que hayan llevado al menos un paquete de más de 150 kilos.
SELECT DISTINCT * FROM Camiones C
INNER JOIN Viajes V ON C.Patente = V.Patente
INNER JOIN Paquete PA ON V.Id = PA.IDViaje
WHERE YEAR(V.Fecha) = YEAR(DATEADD(YEAR, -1, GETDATE())) AND PA.Peso > 150
GO

-- 3) Listar la información del viaje más largo. Incluir en el listado el ID, la fecha del viaje y los Kms.
SELECT TOP(1) WITH TIES V.ID, V.Fecha, V.Kms FROM Viajes V
ORDER BY V.Kms
GO

-- 4) Listar los ID de los viajes que hayan llevado en el año 2019, en promedio, más de 40 kilos por encomienda.
SELECT V.ID FROM Viajes V
WHERE YEAR(V.Fecha) = 2019 AND (SELECT AVG(PA.Peso) FROM Paquetes PA WHERE PA.IDViaje = V.ID) > 40
GO


-- PARTE 2
--Realizar la normalización, creación de tablas y relaciones de una base de datos que permita registrar subastas y que muchos usuarios puedan realizar muchas ofertas a dicha subasta.

--Se debe asegurar que:
--Una subasta tenga una descripción, un precio base, un usuario y una fecha de inicio y fin.
--Un usuario no pueda repetir su mail y además registre su DNI, apellidos y nombres.
--Una oferta tenga una subasta, un usuario, una fecha y un precio.
--Aplicar las restricciones que considere necesarias.

CREATE DATABASE REMATES
GO

USE REMATES
GO

CREATE TABLE Usuarios (
	DNI INT NOT NULL PRIMARY KEY,
	Nombre VARCHAR(40) NOT NULL,
	Apellido VARCHAR(40) NOT NULL,
	EMail VARCHAR(60) NULL UNIQUE,
)
GO

CREATE TABLE Subastas (
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Descripcion VARCHAR(150) NOT NULL,
	PrecioBase MONEY NULL CHECK(PrecioBase > 0),
	DNI INT NOT NULL FOREIGN KEY REFERENCES Usuarios(DNI),
	FechaInicio DATE NULL,
	FechaFin DATE NULL
)
ALTER TABLE Subastas ADD CONSTRAINT CHK_FechaInicio CHECK(FechaInicio >= GETDATE())
ALTER TABLE Subastas ADD CONSTRAINT CHK_FechaFin CHECK(FechaFin >= FechaInicio)
GO


CREATE TABLE Ofertas (
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	IDSubasta INT NOT NULL FOREIGN KEY REFERENCES Subastas(ID),
	DNI INT NOT NULL FOREIGN KEY REFERENCES Usuarios(DNI),
	Fecha DATE NOT NULL,
	Precio MONEY NOT NULL CHECK(Precio > 0)
)
ALTER TABLE Ofertas ADD CONSTRAINT CHK_Fecha CHECK(Fecha >= GETDATE())
GO
