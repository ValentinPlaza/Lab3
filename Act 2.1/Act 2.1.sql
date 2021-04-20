--PUNTO 11
SELECT Nombre, CostoEstimado, FechaInicio, FechaFin FROM Proyectos WHERE IDCliente not in (1, 5, 10)
--PUNTO 12
SET DATEFORMAT 'DMY'
SELECT Nombre, CostoEstimado, Descripcion FROM Proyectos WHERE FechaInicio BETWEEN '1/1/2010' AND '24/6/2021'
--PUNTO 13
SELECT Nombre, CostoEstimado, Descripcion FROM Proyectos WHERE FechaFin BETWEEN '1/1/2019' AND '12/12/2019'
--PUNTO 14
SELECT Nombre, Descripcion FROM Proyectos WHERE FechaFin is null or FechaFin > GETDATE()
--PUNTO 15
SELECT Nombre, Descripcion FROM Proyectos WHERE FechaInicio is null or FechaInicio > GETDATE()
--PUNTO 16
SELECT * FROM Clientes WHERE RazonSocial LIKE '[AEIOU]%'
--PUNTO 17
SELECT * FROM Clientes WHERE RazonSocial LIKE '%[AEIOU]'
--PUNTO 18
SELECT * FROM Clientes WHERE RazonSocial LIKE '%INC'
--PUNTO 19
SELECT * FROM Clientes WHERE RazonSocial NOT LIKE '%[^AEIOU]'
--PUNTO 20
SELECT * FROM Clientes WHERE RazonSocial NOT LIKE '% %'
--PUNTO 21
SELECT * FROM Clientes WHERE RazonSocial LIKE '% % %'
--PUNTO 22
SELECT RazonSocial, CUIT, Mail, Celular FROM Clientes WHERE Mail IS NOT NULL OR Telefono IS NULL
--PUNTO 23
SELECT RazonSocial, CUIT, Mail, Celular FROM Clientes WHERE Mail IS NULL OR Telefono IS NOT NULL
--PUNTO 24
SELECT RazonSocial, CUIT, Mail, Telefono, Celular FROM Clientes WHERE Mail IS NOT NULL OR Telefono IS NOT NULL OR Celular IS NOT NULL
--PUNTO 25
SELECT RazonSocial, CUIT, CASE WHEN Mail IS NOT NULL THEN Mail WHEN Mail IS NULL THEN 'Sin mail' END FROM Clientes
--PUNTO 26
SELECT RazonSocial, CUIT, COALESCE(Mail, Celular, Telefono, 'Incontactable') AS Contacto FROM Clientes
--PUNTO 27
SELECT RazonSocial, CUIT, COALESCE(Mail, Celular, 'Incontactable') AS Contacto FROM Clientes

