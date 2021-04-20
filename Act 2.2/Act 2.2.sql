--PUNTO 1
SELECT C.RazonSocial, C.CUIT, T.Descripcion FROM Clientes AS C INNER JOIN TipoCliente AS T
ON C.IDTipoCliente = T.ID

--PUNTO 2
SELECT CL.RazonSocial, CL.CUIT, CI.Nombre, P.Nombre 
FROM Clientes AS CL
	INNER JOIN Ciudades AS CI
ON CL.IDCiudad = CI.ID
	INNER JOIN Paises AS P
ON CI.IdPaises = P.ID

--PUNTO 3
SELECT CL.RazonSocial, CL.CUIT, CI.Nombre, P.Nombre
FROM Clientes AS CL
	LEFT JOIN Ciudades AS CI
ON CL.IDCiudad = CI.ID
	LEFT JOIN Paises AS P
ON CI.IdPaises = P.ID

--PUNTO 4
SELECT CL.RazonSocial, CL.CUIT, CI.Nombre, P.Nombre
FROM Clientes AS CL
	RIGHT JOIN Ciudades AS CI
ON CL.IDCiudad = CI.ID
	RIGHT JOIN Paises AS P
ON CI.IdPaises = P.ID

--PUNTO 5
SELECT CI.Nombre AS Ciudad, P.Nombre AS Pais FROM Clientes AS CL
	RIGHT JOIN Ciudades AS CI
ON CI.ID = CL.IDCiudad
	INNER JOIN Paises AS P
ON CI.IdPaises = P.ID
WHERE CL.IDCiudad IS NULL

--PUNTO 6
SELECT PR.Nombre AS Proyeto, PR.CostoEstimado AS Costo, CL.RazonSocial, TC.Descripcion, CI.Nombre FROM Proyectos AS PR
	LEFT JOIN Clientes AS CL
ON PR.IDCliente = CL.ID
	INNER JOIN TipoCliente AS TC
ON CL.IDTipoCliente = TC.ID
	LEFT JOIN Ciudades AS CI
ON CL.IDCiudad = CI.ID
WHERE TC.ID IN (2,3)

--PUNTO 7
SELECT PR.Nombre FROM Proyectos AS PR
	INNER JOIN Clientes AS CL
ON PR.IDCliente = CL.ID
	INNER JOIN Ciudades AS CI
ON CL.IDCiudad = CI.ID
	INNER JOIN Paises AS PA
ON CI.IdPaises = PA.ID
WHERE PA.Nombre in ('Argentina', 'Italia')

--PUNTO 8
SELECT MD.Nombre, MD.CostoEstimado, PR.Nombre, PR.Descripcion, PR.CostoEstimado FROM Modulos AS MD
	LEFT JOIN Proyectos AS PR
ON MD.IDProyecto = PR.ID
WHERE PR.FechaFin IS NOT NULL OR PR.FechaFin < GETDATE()