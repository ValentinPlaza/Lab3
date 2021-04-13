CREATE DATABASE Blueprint
GO

USE Blueprint
GO

CREATE TABLE TipoCliente(
	ID int not null primary key identity (1, 1),
	Descripcion varchar(20) not null,	
)
GO

CREATE TABLE Cliente(
	ID int not null primary key identity(1000,1),
	CUIT varchar(13) not null unique,
	RazonSocial varchar(50) not null,
	IDTipoCliente int not null foreign key references TipoCliente(ID),
	Mail varchar(40) null unique,
	Telefono varchar(16) null,
	Celular varchar(16) null
)
GO

CREATE TABLE Proyecto(
	ID varchar(4) not null primary key,
	Nombre varchar(30) not null,
	Descripcion varchar(150) null,
	IDCliente int not null foreign key references Cliente(ID),
	FechaInicio datetime not null,
	FechaFin datetime null,
	CostoEstimado decimal(12,2) not null check(CostoEstimado >= 0),
	Estado bit not null default(1)
)