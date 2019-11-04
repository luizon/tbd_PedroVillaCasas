create database comedor
go
use comedor
go

create table tutor(
	id_tutor int identity not null primary key,
	nombre nvarchar(30) not null,
	apaterno nvarchar(15) not null,
	amaterno nvarchar(15) not null,
	lugar_de_trabajo nvarchar(30) not null,
	telefono_trabajo int,
	telefono_celular int not null
)
go

create table ni�o(
	id_ni�o int identity not null primary key,
	nombre nvarchar(30) not null,
	apaterno nvarchar(15) not null,
	amaterno nvarchar(15) not null,
	nivel int not null,
	grado char(1) not null,
	id_tutor int not null,
	fecha_de_nacimiento date not null,
	especial bit not null default 0,
	foreign key (id_tutor) references tutor(id_tutor)
)
go

create table ni�oAlergias(
	id_ni�o int not null,
	nombre nvarchar(30),
	foreign key (id_ni�o) references ni�o(id_ni�o),
	primary key(id_ni�o, nombre)
)
go

create table adeudo(
	id_adeudo int identity not null primary key,
	id_tutor int not null,
	monto money not null,
	fecha_ultimo_abono datetime not null,
	fecha_de_ int,
	foreign key (id_tutor) references tutor(id_tutor)
)
go

create table menu(
	id_menu int identity not null primary key,
	fecha_inicio datetime not null,
	fecha_final datetime not null
)
go

create table alimento(
	id_alimento int identity not null primary key,
	nombre nvarchar(20) not null,
	tipo nvarchar(10) not null,
	calorias numeric not null,
	carbohidratos numeric not null,
	proteinas numeric not null,
	grasas numeric not null
)
go

create table menu_alimento( -- varios menus tienen varios alimentos
	id_menu int not null,
	id_alimento int not null,
	foreign key (id_menu) references menu(id_menu),
	foreign key (id_alimento) references alimento(id_alimento),
	primary key(id_menu, id_alimento),
)
go

create table ingrediente(
	id_ingrediente int identity not null primary key,
	nombre nvarchar(15) not null,
	caducidad date not null,
	existencias int not null
)
go

create table alimento_ingrediente(
	id_alimento int not null,
	id_ingrediente int not null,
	foreign key (id_alimento) references alimento(id_alimento),
	foreign key (id_ingrediente) references ingrediente(id_ingrediente),
	primary key(id_alimento, id_ingrediente)
)
go

create table listaDeCompras(
	id_lista int identity not null primary key,
	fecha date not null
)
go

create table ingrediente_listaDeCompras(
	id_ingrediente int not null,
	id_lista int not null,
	foreign key (id_ingrediente) references ingrediente(id_ingrediente),
	foreign key (id_lista) references listaDeCompras(id_lista),
	primary key(id_ingrediente, id_lista)
)
go

create table dieta(
	id_dieta int not null,
	id_ni�o int not null,
	fecha_inicio datetime not null,
	fecha_fin datetime not null,
	foreign key (id_ni�o) references ni�o(id_ni�o),
	primary key(id_dieta, id_ni�o)
)
go

create table alimento_dieta(
	id_alimento int not null,
	id_dieta int not null
	foreign key (id_alimento) references alimento(id_alimento),
	foreign key (id_dieta) references dieta(id_dieta),
	primary key(id_alimento, id_dieta)
)