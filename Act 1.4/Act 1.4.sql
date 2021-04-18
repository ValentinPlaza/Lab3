USE Blueprint

CREATE TABLE Modulos (
	ID int not null primary key identity(1,1),
	Nombre varchar(30) not null,
	Descripcion varchar(100) null,
	IDProyecto varchar(4) not null foreign key references Proyectos(ID),
	TiempoEstimado int not null check(TiempoEstimado>0),
	CostoEstimado int not null check(CostoEstimado>0),
	FechaInicio date null,
	FechaEstimadaFin date null,
	FechaFin date null
)
GO

CREATE TABLE Paises(
	ID tinyint not null primary key identity (1,1),
	Nombre varchar(20)
)
GO

CREATE TABLE Ciudades(
	ID int not null primary key identity(1,1),
	IdPaises tinyint foreign key references Paises(ID),
	Nombre varchar(30)
)
GO

CREATE TABLE Colaboradores(
	ID int not null primary key identity(1,1),
	Apellidos varchar(40) not null,
	Nombre varchar(40) not null, 
	Mail varchar(60) null,
	Celular varchar(15) null,
	FechaNac date not null,
	Tipo char(1) not null check(Tipo = 'I' OR Tipo = 'E'),
	Domicilio varchar(50) null,
	Localidad int null foreign key references Ciudades(ID)
)
GO

ALTER TABLE Modulos ADD CONSTRAINT CHK_FechaEstimadaFin CHECK(FechaEstimadaFin >= FechaInicio)
ALTER TABLE Modulos ADD CONSTRAINT CHK_FechaFin CHECK(FechaFin >= FechaInicio)
GO

ALTER TABLE Clientes ADD IDCiudad INT NULL foreign key references Ciudades(ID)
GO

ALTER TABLE Colaboradores ADD CONSTRAINT CHK_MailOCelular CHECK (Mail is not null or Celular is not null)