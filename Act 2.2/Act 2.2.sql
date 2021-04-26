USE Blueprint
GO
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
WHERE PR.FechaFin IS NOT NULL AND PR.FechaFin < GETDATE()

--PUNTO 9
SELECT M.Nombre AS nombreModulo, P.Nombre AS nombreProyecto FROM Modulos AS M 
	INNER JOIN Proyectos AS P
ON M.IDProyecto = P.id
WHERE M.TiempoEstimado > 100

--PUNTO 10
SELECT M.Nombre AS nombreModulo, P.Nombre AS nombreProyecto, M.TiempoEstimado FROM Modulos AS M
	INNER JOIN Proyectos AS P
ON M.IDProyecto = P.ID
WHERE FechaEstimadaFin > M.FechaFin AND P.CostoEstimado > 100000

--PUNTO 11
SELECT DISTINCT P.Nombre FROM Proyectos AS P
	INNER JOIN Modulos AS M
ON M.IDProyecto = P.Id
WHERE M.FechaFin < M.FechaEstimadaFin

--PUNTO 12
SELECT DISTINCT CI.Nombre FROM CIUDADES AS CI
	LEFT JOIN Clientes AS CL
ON CI.ID = CL.IDCiudad
	INNER JOIN Colaboradores AS CO
ON CI.ID = CO.Localidad
WHERE CO.Localidad IS NOT NULL AND CL.IDCiudad IS NULL

--PUNTO 13
SELECT P.Nombre AS nombreProyecto, M.Nombre AS nombreModulo FROM Proyectos AS P
	INNER JOIN Modulos AS M
ON P.ID = M.IDProyecto
WHERE M.Nombre LIKE 'Login' OR M.Descripcion LIKE '%Login%'

--PUNTO 14
SELECT P.Nombre AS nombreProyecto, CO.Nombre, CO.Apellidos FROM Proyectos AS P
	LEFT JOIN Modulos AS M
ON P.Id = M.IDProyecto
	LEFT JOIN Tareas AS T
ON M.ID = T.IdModulo
	LEFT JOIN TipoTareas AS TT
ON TT.ID = T.IdTipoTarea
	LEFT JOIN Colaboraciones AS C
ON T.ID = C.IdTarea
	LEFT JOIN Colaboradores AS CO
ON CO.ID = C.IdColaborador
WHERE TT.Nombre LIKE '%Programacion%' OR TT.Nombre LIKE '%Testing%'
ORDER BY P.Nombre ASC

--PUNTO 15
SELECT CO.Nombre, CO.Apellidos, M.Nombre AS nombreModulo, TT.Nombre, C.ValorHora, TT.PrecioHoraBase FROM Colaboradores AS CO
	LEFT JOIN Colaboraciones AS C
ON CO.ID = C.IdColaborador
	LEFT JOIN Tareas AS T
ON C.IdTarea = T.ID
	LEFT JOIN TipoTareas AS TT
ON T.IdTipoTarea = TT.ID
	LEFT JOIN Modulos AS M
ON T.IdModulo = M.Id
WHERE C.ValorHora > (TT.PrecioHoraBase/2)

--PUNTO 16
SELECT TOP (3) CO.Nombre, CO.Apellidos FROM Colaboradores AS CO
	LEFT JOIN Colaboraciones AS C
ON CO.ID = C.IdColaborador
	LEFT JOIN Tareas AS T
ON C.IdTarea = T.ID
	LEFT JOIN TipoTareas AS TT
ON T.IdTipoTarea = TT.ID
WHERE TT.Nombre LIKE '%Testing%' AND CO.Tipo = 'E'
ORDER BY C.DuracionHoras DESC

--PUNTO 17
SELECT CO.Apellidos, CO.Nombre, CO.Mail FROM Colaboradores AS CO
	INNER JOIN Ciudades AS CI
ON CO.Localidad = CI.ID
	LEFT JOIN Paises AS P
ON CI.IdPaises = P.ID
WHERE P.Nombre LIKE 'Argentina' AND CO.Tipo LIKE 'I' AND CO.Mail LIKE '%.com%'

--PUNTO 18
SELECT P.Nombre AS nombreProycto, M.Nombre AS nombreModulo, TT.Nombre AS TipoTarea FROM Proyectos AS P
	LEFT JOIN Modulos AS M
ON P.ID = M.IDProyecto
	LEFT JOIN Tareas AS T
ON M.ID = T.IdModulo
	LEFT JOIN TipoTareas AS TT
ON T.IdTipoTarea = TT.ID
	LEFT JOIN Colaboraciones AS C
ON T.ID = C.IdTarea
	LEFT JOIN Colaboradores AS CO
ON C.IdColaborador	= CO.ID
WHERE CO.Tipo LIKE 'E'

--PUNTO 19
SELECT P.Nombre FROM Proyectos AS P
	INNER JOIN Modulos AS M
ON P.ID = M.IDProyecto
	INNER JOIN Tareas AS T
ON M.ID = T.IdModulo
WHERE T.ID IS NULL

--PUNTO 20
SELECT DISTINCT CO.Nombre, CO.Apellidos FROM Colaboradores AS CO
	INNER JOIN Colaboraciones AS C
ON CO.ID = C.IdColaborador
	INNER JOIN Tareas AS T
ON C.IdTarea = T.ID
	INNER JOIN Modulos AS M
ON T.IdModulo = M.ID
	INNER JOIN Proyectos AS P
ON M.IDProyecto = P.ID
WHERE P.FechaFin IS NULL