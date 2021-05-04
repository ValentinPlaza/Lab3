CREATE DATABASE Blueprint1
GO

USE Blueprint1
GO

CREATE TABLE TiposCliente(
	ID int not null primary key identity (1, 1),
	Nombre varchar(30) not null,	
)
GO

CREATE TABLE Clientes(
	ID int not null primary key identity(1,1),
	RazonSocial varchar(50) not null,
	IDTipo int not null foreign key references TiposCliente(ID),
	CUIT varchar(13) not null unique,
	EMail varchar(40) null,
	Telefono varchar(16) null,
	Celular varchar(16) null
)
GO

CREATE TABLE Proyectos(
	ID varchar(5) not null primary key,
	IDCliente int not null foreign key references Clientes(ID),
	Nombre varchar(50) not null,
	Descripcion varchar(150) null,
	CostoEstimado int not null check(CostoEstimado >= 0),
	FechaInicio date not null,
	FechaFin date null,
	Estado bit not null default(1)	
)
GO

CREATE TABLE Modulos (
	ID int not null primary key identity(1,1),
	Nombre varchar(30) not null,
	Descripcion varchar(100) null,
	IDProyecto varchar(5) not null foreign key references Proyectos(ID),
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
	IdPais tinyint foreign key references Paises(ID),
	Nombre varchar(30)
)
GO

CREATE TABLE Colaboradores(
	ID int not null primary key identity(1,1),
	Apellido varchar(40) not null,
	Nombre varchar(40) not null, 
	EMail varchar(60) null,
	Celular varchar(15) null,
	FechaNacimiento date not null,
	Tipo char(1) not null check(Tipo = 'I' OR Tipo = 'E'),
	Domicilio varchar(50) null,
	IDCiudad int null foreign key references Ciudades(ID)
)
GO

ALTER TABLE Modulos ADD CONSTRAINT CHK_FechaEstimadaFin CHECK(FechaEstimadaFin >= FechaInicio)
ALTER TABLE Modulos ADD CONSTRAINT CHK_FechaFin CHECK(FechaFin >= FechaInicio)
GO

ALTER TABLE Clientes ADD IDCiudad INT NULL foreign key references Ciudades(ID)
GO

ALTER TABLE Colaboradores ADD CONSTRAINT CHK_MailOCelular CHECK (EMail is not null or Celular is not null)
GO

CREATE TABLE TiposTarea(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null,
	PrecioHoraBase money null
)
GO

CREATE TABLE Tareas(
	ID int not null Primary key identity(1,1),
	IdModulo int not null foreign key references Modulos(ID),
	IdTipo int not null foreign key references TiposTarea(ID),
	FechaInicio datetime null,
	FechaFin datetime null,
	Estado bit not null default(1)
)
GO

ALTER TABLE Tareas ADD CONSTRAINT CHK_FechaFinTareas CHECK(FechaFin>=FechaInicio)
GO

CREATE TABLE Colaboraciones(
	ID bigint not null primary key identity(1,1),
	IdTarea int not null foreign key references Tareas(ID),
	IdColaborador int not null foreign key references Colaboradores(ID),
	PrecioHora money not null check(PrecioHora > 0),
	Tiempo int null check(Tiempo > 0),
	Estado bit not null default(1)
)