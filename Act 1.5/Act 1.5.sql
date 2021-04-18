USE Blueprint
GO

CREATE TABLE TipoTareas(
	ID int not null primary key identity(1,1),
	Nombre varchar(50) not null,
	PrecioHoraBase money null
)
GO

CREATE TABLE Tareas(
	ID int not null Primary key identity(1,1),
	IdModulo int not null foreign key references Modulos(ID),
	IdTipoTarea int not null foreign key references TipoTareas(ID),
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
	ValorHora smallmoney not null check(ValorHora > 0),
	DuracionHoras smallint null check(DuracionHoras > 0),
	Estado bit not null default(1)
)