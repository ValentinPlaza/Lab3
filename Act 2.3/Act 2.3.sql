USE Blueprint1
GO
-- 1) La cantidad de colaboradores
SELECT COUNT(*) AS CantidadColaboradores FROM Colaboradores
GO
-- 2) La cantidad de colaboradores nacidos entre 1990 y 2000.
SELECT COUNT(YEAR(FechaNacimiento) BETWEEN 1990 AND 2000) AS CantidadColaboradores90s FROM Colaboradores
GO
-- 3) El promedio de precio hora base de los tipos de tareas
SELECT AVG(TT.PrecioHoraBase) AS PromedioPrecioHoraBase FROM TiposTarea AS TT
GO
-- 4) El promedio de costo de los proyectos iniciados en el año 2019.
SELECT AVG(P.Costo) AS PromedioCostoProyectos FROM Proyectos AS P WHERE YEAR(FechaInicio) = 2019
GO
-- 5) El costo más alto entre los proyectos de clientes de tipo 'Unicornio'
SELECT MAX(P.Costo) AS CostoMaxProyectosUnicornio FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IdProyecto
INNER JOIN Clientes AS CL ON CL.ID = M.IdCliente
INNER JOIN TiposCliente AS TC ON TC.ID = CL.IdTipo
WHERE TC.Nombre LIKE 'Unicornio'
GO
-- 6) El costo más bajo entre los proyectos de clientes del país 'Argentina'
SELECT MIN(PR.Costo) AS CostoMinProyectosArgentinos FROM Proyectos AS PR
INNER JOIN Modulos AS M ON P.ID = M.IdProyecto
INNER JOIN Clientes AS CL ON CL.ID = M.IdCliente
INNER JOIN Ciudad AS CI ON CI.ID = CL.IdTipo
INNER JOIN Pais AS PA ON PA.ID = CI.IdPais
WHERE PA.Nombre LIKE 'Argentina'
GO
-- 7) La suma total de los costos estimados entre todos los proyectos.
SELECT SUM(P.CostoEstimado) AS CostoTotalProyectos FROM Proyectos AS P
GO
-- 8)Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.
SELECT CI.Nombre, COUNT(Clientes) AS CantClientes  FROM Ciudades AS CI
INNER JOIN Clientes AS CL ON CI.ID = CL.IdCiudad
GROUP BY CI.Nombre
GO
-- 9) Por cada país, listar el nombre del país y la cantidad de clientes.
SELECT PA.Nombre, COUNT(Clientes) AS CantClientes FROM Paises AS PA
INNER JOIN Ciudades AS CI ON PA.ID = CI.IdPais
INNER JOIN Clientes AS CL ON CI.ID = CL.IdCiudad
GROUP BY PA.Nombre
GO
-- 10) Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el tipo de tarea y la cantidad calculada.
SELECT TT.Nombre, COUNT(Colaboraciones) AS CantColaboraciones FROM TiposTarea AS TT
INNER JOIN Tarea AS T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
GROUP BY TT.Nombre

-- 11)Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.
SELECT TT.Nombre, COUNT(Distinct Colaboradores) AS CantColaboraciones FROM TiposTarea AS TT
INNER JOIN Tarea AS T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
INNER JOIN Colaboradores AS CO ON CO.ID = C.IdColaborador
GROUP BY TT.Nombre

-- 12) Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre del módulo y la cantidad totalizada. Mostrar los módulos sin horas registradas con 0.
SELECT M.Id, M.Nombre, 