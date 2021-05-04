USE Blueprint1
GO
-- 1) La cantidad de colaboradores
SELECT COUNT(*) AS CantidadColaboradores FROM Colaboradores
GO
-- 2) La cantidad de colaboradores nacidos entre 1990 y 2000.
SELECT COUNT(*) AS CantidadColaboradores90s FROM Colaboradores WHERE YEAR(FechaNacimiento) BETWEEN 1990 AND 2000
GO
-- 3) El promedio de precio hora base de los tipos de tareas
SELECT AVG(PrecioHoraBase) AS PromedioPrecioHoraBase FROM TiposTarea
GO
-- 4) El promedio de costo de los proyectos iniciados en el año 2019.
SELECT AVG(CostoEstimado) AS PromedioCostoProyectos FROM Proyectos WHERE YEAR(FechaInicio) = 2019
GO
-- 5) El costo más alto entre los proyectos de clientes de tipo 'Unicornio'
SELECT MAX(P.CostoEstimado) AS CostoMaxProyectosUnicornio FROM Proyectos AS P
INNER JOIN Clientes AS CL ON CL.ID = P.IDCliente
INNER JOIN TiposCliente AS TC ON TC.ID = CL.IdTipo
WHERE TC.Nombre LIKE 'Unicornio'
GO
-- 6) El costo más bajo entre los proyectos de clientes del país 'Argentina'
SELECT MIN(PR.CostoEstimado) AS CostoMinProyectosArgentinos FROM Proyectos AS PR
INNER JOIN Clientes AS CL ON CL.ID = PR.IDCliente
INNER JOIN Ciudades AS CI ON CI.ID = CL.IdTipo
INNER JOIN Paises AS PA ON PA.ID = CI.IdPais
WHERE PA.Nombre LIKE 'Argentina'
GO
-- 7) La suma total de los costos estimados entre todos los proyectos.
SELECT SUM(CostoEstimado) AS CostoTotalProyectos FROM Proyectos
GO
-- 8)Por cada ciudad, listar el nombre de la ciudad y la cantidad de clientes.
SELECT CI.Nombre, COUNT(CL.ID) AS CantClientes  FROM Ciudades AS CI
INNER JOIN Clientes AS CL ON CI.ID = CL.IdCiudad
GROUP BY CI.Nombre
GO
-- 9) Por cada país, listar el nombre del país y la cantidad de clientes.
SELECT PA.Nombre, COUNT(CL.ID) AS CantClientes FROM Paises AS PA
INNER JOIN Ciudades AS CI ON PA.ID = CI.IdPais
INNER JOIN Clientes AS CL ON CI.ID = CL.IdCiudad
GROUP BY PA.Nombre
GO
-- 10) Por cada tipo de tarea, la cantidad de colaboraciones registradas. Indicar el tipo de tarea y la cantidad calculada.
SELECT TT.Nombre, COUNT(C.ID) AS CantColaboraciones FROM TiposTarea AS TT
INNER JOIN Tareas AS T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
GROUP BY TT.Nombre

-- 11)Por cada tipo de tarea, la cantidad de colaboradores distintos que la hayan realizado. Indicar el tipo de tarea y la cantidad calculada.
SELECT TT.Nombre, COUNT(DISTINCT CO.ID) AS CantColaboraciones FROM TiposTarea AS TT
INNER JOIN Tareas AS T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
INNER JOIN Colaboradores AS CO ON CO.ID = C.IdColaborador
GROUP BY TT.Nombre

-- 12) Por cada módulo, la cantidad total de horas trabajadas. Indicar el ID, nombre del módulo y la cantidad totalizada. Mostrar los módulos sin horas registradas con 0.
SELECT M.Id, M.Nombre, ISNULL(SUM(C.Tiempo), 0) AS TotalHorasTrabajadas FROM Modulos AS M
LEFT JOIN Tareas AS T ON M.Id = T.IdModulo
LEFT JOIN Colaboraciones AS C ON T.ID = C.IdTarea
GROUP BY M.Nombre, M.ID
GO

-- 13) Por cada módulo y tipo de tarea, el promedio de horas trabajadas. Indicar el ID y nombre del módulo, el nombre del tipo de tarea y el total calculado.
SELECT M.Id, M.Nombre AS Modulo, TT.Nombre AS TipoTarea, ISNULL(AVG(C.Tiempo), 0) AS TotalHorasTrabajadas FROM Modulos AS M
INNER JOIN Tareas AS T ON M.Id = T.IdModulo
INNER JOIN TiposTarea AS TT ON T.IdTipo = TT.ID
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
GROUP BY M.Id, M.Nombre, TT.Nombre
ORDER BY TT.Nombre
GO

-- 14) Por cada módulo, indicar su ID, apellido y nombre del colaborador y total que se le debe abonar en concepto de colaboraciones realizadas en dicho módulo.
SELECT M.ID AS IdModulo, M.Nombre AS Modulo, CONCAT(CO.Nombre, ' ', CO.Apellido) AS Colaborador, SUM(C.Tiempo * C.PrecioHora) AS Salario FROM Modulos AS M
INNER JOIN Tareas AS T ON M.ID = T.IdModulo
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
GROUP BY M.ID, M.Nombre, CONCAT(CO.Nombre, ' ',CO.Apellido)
ORDER BY M.ID ASC
GO

-- 15) Por cada proyecto indicar el nombre del proyecto y la cantidad de horas registradas en concepto de colaboraciones y el total que debe abonar en concepto de colaboraciones.
SELECT P.Nombre AS Proyecto, SUM(C.Tiempo) AS HorasTrabajadas, SUM(C.Tiempo * C.PrecioHora) AS Salario FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IDProyecto
INNER JOIN Tareas AS T ON M.ID = T.IdModulo
INNER JOIN Colaboraciones AS C ON T.Id = C.IdTarea
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
GROUP BY P.Nombre
ORDER BY P.Nombre ASC
GO 

-- 16) Listar los nombres de los proyectos que hayan registrado menos de cinco colaboradores distintos y más de 100 horas total de trabajo.
SELECT P.Nombre AS Proyecto FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IDProyecto
INNER JOIN Tareas AS T ON M.ID = T.IdModulo
INNER JOIN Colaboraciones AS C ON T.Id = C.IdTarea
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
GROUP BY P.Nombre
HAVING SUM(C.Tiempo) > 100 AND COUNT(DISTINCT CO.ID) < 5
GO

-- 17) Listar los nombres de los proyectos que hayan comenzado en el año 2020 que hayan registrado más de tres módulos.
SELECT P.Nombre AS Proyecto FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IDProyecto
WHERE YEAR(P.FechaInicio) = 2020
GROUP BY P.Nombre
HAVING COUNT(M.ID) > 3
GO

-- 18) Listar para cada colaborador externo, el apellido y nombres y el tiempo máximo de horas que ha trabajo en una colaboración.
SELECT CONCAT(CO.Nombre, ' ', CO.Apellido) AS Colaborador, MAX(C.Tiempo) AS MayorColaboracion FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
WHERE CO.Tipo LIKE 'E'
GROUP BY CONCAT(CO.Nombre, ' ', CO.Apellido)
ORDER BY CONCAT(CO.Nombre, ' ', CO.Apellido) ASC
GO

-- 19) Listar para cada colaborador interno, el apellido y nombres y el promedio percibido en concepto de colaboraciones.
SELECT CONCAT(CO.Nombre, ' ', CO.Apellido) AS Colaborador, AVG(C.PrecioHora * C.Tiempo) AS SalarioPromedio FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
WHERE CO.Tipo LIKE 'I'
GROUP BY CONCAT(CO.Nombre, ' ', CO.Apellido)
ORDER BY CONCAT(CO.Nombre, ' ', CO.Apellido) ASC
GO

-- 20) Listar el promedio percibido en concepto de colaboraciones para colaboradores internos y el promedio percibido en concepto de colaboraciones para colaboradores externos.
SELECT CONCAT(CO.Nombre, ' ', CO.Apellido) AS Colaborador, AVG(C.PrecioHora * C.Tiempo) AS SalarioPromedio FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
GROUP BY CO.Tipo, CONCAT(CO.Nombre, ' ', CO.Apellido)
ORDER BY CONCAT(CO.Nombre, ' ', CO.Apellido) ASC
GO

-- 21) Listar el nombre del proyecto y el total neto estimado. Este último valor surge del costo estimado menos los pagos que requiera hacer en concepto de colaboraciones.
SELECT P.Nombre AS Proyecto, (P.CostoEstimado - C.PrecioHora * C.Tiempo) AS TotalNetoEstimado FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IDProyecto
INNER JOIN Tareas AS T ON M.ID = T.IdModulo
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
GROUP BY P.Nombre, P.CostoEstimado - C.PrecioHora * C.Tiempo
GO

-- 22) Listar la cantidad de colaboradores distintos que hayan colaborado en alguna tarea que correspondan a proyectos de clientes de tipo 'Unicornio'.
SELECT COUNT(DISTINCT CO.ID) AS CantidadColaboradores FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
INNER JOIN Tareas AS T ON C.IdTarea = T.ID
INNER JOIN Modulos AS M ON T.IdModulo = M.ID
INNER JOIN Proyectos AS P ON M.IDProyecto = P.ID
INNER JOIN Clientes AS CL ON P.IDCliente = CL.ID
INNER JOIN TiposCliente AS TC ON CL.IDTipo = TC.ID
WHERE TC.Nombre LIKE 'Unicornio'
GO

-- 23) La cantidad de tareas realizadas por colaboradores del país 'Argentina'
SELECT COUNT(T.ID) AS TareasHechasPorArgentinos FROM Tareas AS T
INNER JOIN Colaboraciones AS C ON T.ID = C.IdTarea
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
INNER JOIN Ciudades AS CI ON CO.IDCiudad = CI.ID
INNER JOIN Paises AS PA ON CI.IdPais = PA.ID
WHERE PA.Nombre LIKE 'Argentina'
GO

-- 24) Por cada proyecto, la cantidad de módulos que se haya estimado mal la fecha de fin. Es decir, que se haya finalizado antes o después que la fecha estimada. Indicar el nombre del proyecto y la cantidad calculada.
SELECT P.Nombre AS Proyecto, COUNT(M.ID) AS ModulosMalEstimados FROM Proyectos AS P
INNER JOIN Modulos AS M ON P.ID = M.IDProyecto
WHERE DATEDIFF(DAY, M.FechaFin, M.FechaEstimadaFin) <> 0
GROUP BY P.Nombre
ORDER BY COUNT(M.ID) DESC