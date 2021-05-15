USE Blueprint
GO

-- 1) Listar los nombres de proyecto y costo estimado de aquellos proyectos cuyo costo estimado sea mayor al promedio de costos.
SELECT P.Nombre AS Proyecto, P.CostoEstimado FROM Proyectos AS P
WHERE p.CostoEstimado > (SELECT AVG(CostoEstimado) AS PromedioCosto FROM Proyectos)
GO

-- 2) Listar razón social, cuit y contacto (email, celular o teléfono) de aquellos clientes que no tengan proyectos que comiencen en el año 2020.
SELECT CL.RazonSocial, CL.CUIT, ISNULL(Cl.EMail, ISNULL(CL.Celular, ISNULL(CL.Telefono, 'Incontactable'))) AS Contacto FROM Clientes AS CL
WHERE CL.ID NOT IN (
SELECT IDCliente FROM Proyectos
WHERE YEAR(FechaInicio) > 2020
)
GO

-- 3) Listado de países que no tengan clientes relacionados.
SELECT P.Nombre AS Pais FROM Paises AS P
WHERE P.ID NOT IN (
SELECT CI.IDPais FROM Ciudades AS CI
INNER JOIN Clientes AS CL ON CI.ID = CL.IDCiudad
)
GO 

-- 4) Listado de proyectos que no tengan tareas registradas. 
SELECT PR.Nombre AS Proyecto FROM Proyectos AS PR
WHERE PR.ID NOT IN (
SELECT M.IDProyecto FROM Modulos AS M
INNER JOIN Tareas AS T ON M.ID = T.IdModulo
)
GO

-- 5) Listado de tipos de tareas que no registren tareas pendientes.
SELECT TT.Nombre AS TipoDeTarea FROM TiposTarea AS TT
WHERE TT.ID NOT IN (
SELECT T.IdTipo FROM Tareas AS T
WHERE T.FechaFin IS NULL
)
GO 

-- 6) Listado con ID, nombre y costo estimado de proyectos cuyo costo estimado sea menor al costo estimado de cualquier proyecto de clientes nacionales (clientes que sean de Argentina o no tengan asociado un país).
SELECT P.ID, P.Nombre, P.CostoEstimado FROM Proyectos AS P
WHERE P.CostoEstimado < (
SELECT MIN(CostoEstimado) FROM Proyectos
INNER JOIN Clientes AS CL ON CL.IDCiudad = IDCliente
INNER JOIN Ciudades AS CI ON CL.IDCiudad = CI.ID
INNER JOIN Paises AS PA ON CI.IdPais = PA.ID
WHERE PA.Nombre LIKE 'Argentina'
)
GO 

-- 7) Listado de apellido y nombres de colaboradores que hayan demorado más en una tarea que el colaborador de la ciudad de 'Buenos Aires' que más haya demorado.
SELECT CONCAT(CO.Nombre, ' ', CO.Apellido) AS Colaboradores FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
WHERE C.Tiempo > (
SELECT MAX(C2.Tiempo) FROM Colaboraciones AS C2
INNER JOIN Colaboradores AS CO2 ON C2.IdColaborador = CO2.ID
INNER JOIN Ciudades AS CI ON CO2.IDCiudad = CI.ID
WHERE CI.Nombre LIKE 'Buenos Aires'
)
ORDER BY CONCAT(CO.Nombre, ' ', CO.Apellido)
GO 

-- 8) Listado de clientes indicando razón social, nombre del país (si tiene) y cantidad de proyectos comenzados y cantidad de proyectos por comenzar.
SELECT CL.RazonSocial AS Cliente, PA.Nombre AS Pais, (
SELECT COUNT(PR.ID)  FROM Proyectos AS PR
WHERE PR.FechaInicio <= GETDATE() AND PR.IDCliente = CL.ID
)AS ProyectosComenzados,
(
SELECT COUNT(PR.ID) FROM Proyectos AS PR
WHERE PR.FechaInicio > GETDATE() AND PR.IDCliente = CL.ID
) AS ProyectosPorComenzar
FROM Clientes AS CL
LEFT JOIN Ciudades AS CI ON CL.IDCiudad = CI.ID
LEFT JOIN Paises AS PA ON CI.IdPais = PA.ID
GO 

-- 9) Listado de tareas indicando nombre del módulo, nombre del tipo de tarea, cantidad de colaboradores externos que la realizaron y cantidad de colaboradores internos que la realizaron.
SELECT M.Nombre AS Modulo, TT.Nombre AS Tarea, 
(
SELECT COUNT(CO.ID) FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
WHERE CO.Tipo LIKE 'E' AND C.IdTarea = T.Id
) AS ColaboradoresExternos, 
(
SELECT COUNT(CO.ID) FROM Colaboradores AS CO
INNER JOIN Colaboraciones AS C ON CO.ID = C.IdColaborador
WHERE CO.Tipo LIKE 'I' AND C.IdTarea = T.Id
) AS ColaboradoresInternos
FROM Tareas AS T
INNER JOIN Modulos AS M ON T.IdModulo = M.ID
INNER JOIN TiposTarea AS TT ON T.IdTipo = TT.ID
GO

-- 10) Listado de proyectos indicando nombre del proyecto, costo estimado, cantidad de módulos cuya estimación de fin haya sido exacta, cantidad de módulos con estimación adelantada y cantidad de módulos con estimación demorada.
-- Adelantada ->  estimación de fin haya sido inferior a la real.
-- Demorada   ->  estimación de fin haya sido superior a la real.
SELECT P.Nombre, P.CostoEstimado, 
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin = FechaFin AND M.IDProyecto = P.ID
) AS ModulosPuntuales,
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin < FechaFin AND M.IDProyecto = P.ID
) AS ModulosAdelantados,
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin > FechaFin AND M.IDProyecto = P.ID
) AS ModulosAtrasados
FROM Proyectos AS P
GO

-- 11) Listado con nombre del tipo de tarea y total abonado en concepto de honorarios para colaboradores internos y total abonado en concepto de honorarios para colaboradores externos.
SELECT TT.Nombre AS Tarea, 
(
SELECT SUM(C.PrecioHora * C.Tiempo) FROM Colaboraciones AS C
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
INNER JOIN Tareas AS T ON C.IdTarea = T.ID
WHERE TT.ID = T.IdTipo AND CO.Tipo LIKE 'I'
) AS HonorariosColaboradoresInternos, 
(
SELECT SUM(C.PrecioHora * C.Tiempo) FROM Colaboraciones AS C
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
INNER JOIN Tareas AS T ON C.IdTarea = T.ID
WHERE TT.ID = T.IdTipo AND CO.Tipo LIKE 'E'
) AS HonorariosColaboradoresExternos
FROM TiposTarea AS TT
GO

-- 12) Listado con nombre del proyecto, razón social del cliente y saldo final del proyecto. El saldo final surge de la siguiente fórmula: 
-- Costo estimado - E(HCE) - E(HCI) * 0.1
-- Siendo HCE -> Honorarios de colaboradores externos y HCI -> Honorarios de colaboradores internos.
SELECT PR.Nombre AS Proyecto, CL.RazonSocial AS Cliente, 
(
SELECT PR.CostoEstimado 
- (SELECT ISNULL(SUM(C.PrecioHora * C.Tiempo), 0) FROM Colaboraciones AS C
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
INNER JOIN Tareas AS T ON C.IdTarea = T.ID
INNER JOIN Modulos AS M ON T.IDModulo = M.ID
WHERE M.IdProyecto = PR.ID AND CO.Tipo LIKE 'E')
- (SELECT ISNULL(SUM(C.PrecioHora * C.Tiempo),0) FROM Colaboraciones AS C
INNER JOIN Colaboradores AS CO ON C.IdColaborador = CO.ID
INNER JOIN Tareas AS T ON C.IdTarea = T.ID
INNER JOIN Modulos AS M ON T.IDModulo = M.ID
WHERE M.IdProyecto = PR.ID AND CO.Tipo LIKE 'I') 
* 0.1
) AS SaldoFinal
FROM Proyectos AS PR
INNER JOIN Clientes AS CL ON PR.IDCliente = CL.ID
GO

-- 13) Para cada módulo listar el nombre del proyecto, el nombre del módulo, el total en tiempo que demoraron las tareas de ese módulo y qué porcentaje de tiempo representaron las 
-- tareas de ese módulo en relación al tiempo total de tareas del proyecto.
SELECT PR.Nombre AS Proyecto, M.Nombre AS Modulo,
(
SELECT SUM(C.Tiempo) FROM Colaboraciones C
INNER JOIN Tareas T ON C.IdTarea = T.ID
WHERE PR.ID = M.IDProyecto AND T.IdModulo = M.ID
) AS TiempoPorModulo,
(
SELECT CONVERT(MONEY,ISNULL(SUM(C.Tiempo)*100,0)) FROM Colaboraciones C
INNER JOIN Tareas T ON C.IdTarea = T.ID
WHERE PR.ID = M.IDProyecto AND T.IdModulo = M.ID
)
/
(
SELECT CONVERT(MONEY,SUM(Csub2.Tiempo))FROM Colaboraciones Csub2
INNER JOIN Tareas Tsub2 ON Csub2.IdTarea = Tsub2.ID
INNER JOIN Modulos Msub2 ON Tsub2.IdModulo = Msub2.ID
WHERE PR.ID = Msub2.IDProyecto
) AS TotalPorProyecto
FROM Proyectos AS PR
INNER JOIN Modulos M ON PR.ID = M.IDProyecto
GO

-- 14) Por cada colaborador indicar el apellido, el nombre, 'Interno' o 'Externo' según su tipo y la cantidad de tareas de tipo 'Testing' que haya realizado y la cantidad de tareas de tipo 'Programación' que haya realizado.
-- NOTA: Se consideran tareas de tipo 'Testing' a las tareas que contengan la palabra 'Testing' en su nombre. Ídem para Programación.
SELECT CO.Apellido, CO.Nombre, 
CASE 
WHEN CO.Tipo LIKE 'I' THEN 'Interno'
WHEN CO.Tipo LIKE 'E' THEN 'Externo'
ELSE NULL
END AS Tipo,
(
SELECT COUNT(TT.ID) FROM TiposTarea TT
INNER JOIN Tareas T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones C ON T.ID = C.IdTarea
WHERE CO.ID = C.IdColaborador
AND TT.Nombre LIKE '%testing%'
) AS Testing,
(
SELECT COUNT(TT.ID) FROM TiposTarea TT
INNER JOIN Tareas T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones C ON T.ID = C.IdTarea
WHERE CO.ID = C.IdColaborador
AND TT.Nombre LIKE '%programación%'
) AS Programacion
FROM Colaboradores CO
GO

-- 15) Listado apellido y nombres de los colaboradores que no hayan realizado tareas de 'Diseño de base de datos'.
SELECT CO.Apellido AS Nombre, CO.Nombre AS Apellido FROM Colaboradores CO
WHERE CO.ID NOT IN
(
SELECT COsub2.ID FROM Colaboradores COsub2
INNER JOIN Colaboraciones C ON COsub2.ID = C.IdColaborador
INNER JOIN Tareas T ON C.IdTarea = T.ID
INNER JOIN TiposTarea TT ON T.IdTipo = TT.ID
WHERE TT.Nombre LIKE 'Diseño de base de datos'
)
GO

-- 16) Por cada país listar el nombre, la cantidad de clientes y la cantidad de colaboradores.
SELECT PA.Nombre AS Pais, 
(
SELECT COUNT(CL.ID) FROM Clientes CL
INNER JOIN Ciudades CI ON CL.IDCiudad = CI.ID
WHERE PA.ID = CI.IdPais
) Clientes, 
(
SELECT COUNT(CO.Id) FROM Colaboradores CO
INNER JOIN Ciudades CI ON CO.IDCiudad = CI.ID
WHERE PA.ID = CI.IdPais
) Colaboradores
FROM Paises PA
GO

-- 17) Listar por cada país el nombre, la cantidad de clientes y la cantidad de colaboradores de aquellos países que no tengan clientes pero sí colaboradores.
SELECT PA.Nombre AS Pais, 
(
SELECT COUNT(CL.ID) FROM Clientes CL
INNER JOIN Ciudades CI ON CL.IDCiudad = CI.ID
WHERE PA.ID = CI.IdPais
) Clientes, 
(
SELECT COUNT(CO.Id) FROM Colaboradores CO
INNER JOIN Ciudades CI ON CO.IDCiudad = CI.ID
WHERE PA.ID = CI.IdPais
) Colaboradores
FROM Paises PA
WHERE 
(
SELECT COUNT(CL.ID) FROM Clientes CL
INNER JOIN Ciudades CI ON CL.IDCiudad = CI.ID
WHERE PA.ID = CI.IdPais
) = 0 
AND (
SELECT COUNT(CO.Id) FROM Colaboradores CO
INNER JOIN Ciudades CI ON CO.IDCiudad = CI.ID
WHERE PA.ID = CI.IdPais
) > 0
GO

-- 18) Listar apellidos y nombres de los colaboradores internos que hayan realizado más tareas de tipo 'Testing' que tareas de tipo 'Programación'.
SELECT CO.Apellido, CO.Nombre, 
CASE 
WHEN CO.Tipo LIKE 'I' THEN 'Interno'
ELSE NULL
END Tipo
FROM Colaboradores CO
WHERE 
(
SELECT COUNT(TT.ID) FROM TiposTarea TT
INNER JOIN Tareas T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones C ON T.ID = C.IdTarea
WHERE CO.ID = C.IdColaborador
AND TT.Nombre LIKE '%testing%'
)
>
(
SELECT COUNT(TT.ID) FROM TiposTarea TT
INNER JOIN Tareas T ON TT.ID = T.IdTipo
INNER JOIN Colaboraciones C ON T.ID = C.IdTarea
WHERE CO.ID = C.IdColaborador
AND TT.Nombre LIKE '%programación%'
)
GO

-- 19) Listar los nombres de los tipos de tareas que hayan abonado más del cuádruple en colaboradores internos que externos.
SELECT TT.Nombre Tareas FROM TiposTarea TT
WHERE 
(
SELECT SUM(C.Tiempo * C.PrecioHora) FROM Colaboraciones C
INNER JOIN Colaboradores CO ON C.IdColaborador = CO.ID
INNER JOIN Tareas T ON C.IdTarea = T.ID
INNER JOIN TiposTarea TTsub ON T.IdTipo = TTsub.ID
WHERE CO.Tipo LIKE 'I' AND TTsub.ID = TT.ID
)
> 
(
SELECT SUM(C.Tiempo * C.PrecioHora) FROM Colaboraciones C
INNER JOIN Colaboradores CO ON C.IdColaborador = CO.ID
INNER JOIN Tareas T ON C.IdTarea = T.ID
INNER JOIN TiposTarea TTsub ON T.IdTipo = TTsub.ID
WHERE CO.Tipo LIKE 'E' AND TTsub.ID = TT.ID
) *4
GO

-- 20) Listar los proyectos que hayan registrado igual cantidad de estimaciones demoradas que adelantadas 
-- y que al menos hayan registrado alguna estimación adelantada y que no hayan registrado ninguna estimación exacta.

SELECT PR.Nombre Proyectos FROM Proyectos PR
WHERE 
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin < FechaFin AND M.IDProyecto = PR.ID
)
= 
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin > FechaFin AND M.IDProyecto = PR.ID
)
AND 
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin < FechaFin AND M.IDProyecto = PR.ID
) > 0
AND
(
SELECT COUNT(M.ID) AS Modulo FROM Modulos AS M
WHERE M.FechaEstimadaFin = FechaFin AND M.IDProyecto = PR.ID
) = 0
GO