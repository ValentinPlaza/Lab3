CREATE DATABASE Blueprint
GO

USE Blueprint
GO

CREATE TABLE TipoCliente(
	ID int not null primary key identity (1, 1),
	Descripcion varchar(20) not null,	
)
GO

CREATE TABLE Clientes(
	ID int not null primary key identity(1,1),
	RazonSocial varchar(50) not null,
	IDTipoCliente int not null foreign key references TipoCliente(ID),
	CUIT varchar(13) not null unique,
	Mail varchar(40) null,
	Telefono varchar(16) null,
	Celular varchar(16) null
)
GO

CREATE TABLE Proyectos(
	ID varchar(4) not null primary key,
	IDCliente int not null foreign key references Clientes(ID),
	Nombre varchar(50) not null,
	Descripcion varchar(150) null,
	CostoEstimado int not null check(CostoEstimado >= 0),
	FechaInicio date not null,
	FechaFin date null,
	Estado bit not null default(1)	
)
