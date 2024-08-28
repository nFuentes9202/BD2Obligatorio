
use master

drop database CatHotel

CREATE DATABASE CatHotel
GO
USE CatHotel
GO
CREATE TABLE Propietario (
    propietarioDocumento CHAR(30) PRIMARY KEY,
    propietarioNombre VARCHAR(100) NOT NULL,
    propietarioTelefono VARCHAR(20) NULL,
    propietarioEmail VARCHAR(100) NULL,
    CONSTRAINT CHK_Propietario_TelefonoEmail CHECK (propietarioTelefono IS NOT NULL OR propietarioEmail IS NOT NULL) );
GO
CREATE TABLE Gato (
    gatoID INT IDENTITY(1,1) PRIMARY KEY,
    gatoNombre VARCHAR(50) NOT NULL,
    gatoRaza VARCHAR(50),
    gatoEdad INT,
    gatoPeso DECIMAL(5,2),
    propietarioDocumento CHAR(30) NOT NULL,
    CONSTRAINT CHK_Gato_Edad CHECK (gatoEdad >= 0),
    CONSTRAINT CHK_Gato_Peso CHECK (gatoPeso > 0),
    CONSTRAINT FK_Gato_Propietario FOREIGN KEY (propietarioDocumento) REFERENCES Propietario(propietarioDocumento) );
GO
CREATE TABLE Habitacion (
    habitacionNombre CHAR(30) PRIMARY KEY,
    habitacionCapacidad INT,
	habitacionPrecio DECIMAL(6,2),
    habitacionEstado VARCHAR(20),
    CONSTRAINT CHK_Habitacion_Capacidad CHECK (habitacionCapacidad > 0),
    CONSTRAINT CHK_Habitacion_Precio CHECK (habitacionPrecio > 0),
    CONSTRAINT CHK_Habitacion_Estado CHECK (habitacionEstado IN ('DISPONIBLE', 'LLENA', 'LIMPIANDO')) );
GO
CREATE TABLE Reserva (
    reservaID INT IDENTITY(1,1) PRIMARY KEY,
    gatoID INT NOT NULL,
    habitacionNombre CHAR(30) NOT NULL,
    reservaFechaInicio DATE NOT NULL,
    reservaFechaFin DATE NOT NULL,
    reservaMonto DECIMAL(7,2) NOT NULL,
    CONSTRAINT FK_Reserva_Gato FOREIGN KEY (gatoID) REFERENCES Gato(gatoID),
    CONSTRAINT FK_Reserva_Habitacion FOREIGN KEY (habitacionNombre) REFERENCES Habitacion(habitacionNombre),
    CONSTRAINT CHK_Reserva_Fecha CHECK (reservaFechaFin > reservaFechaInicio) );
GO
CREATE TABLE Servicio (
    servicioNombre CHAR(30) NOT NULL PRIMARY KEY,
    servicioPrecio DECIMAL(7,2),
    CONSTRAINT CHK_Servicio_Precio CHECK (servicioPrecio >= 0) );
GO
CREATE TABLE Reserva_Servicio (
    reservaID INT NOT NULL,
    servicioNombre CHAR(30) NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (reservaID, servicioNombre),
    CONSTRAINT CHK_ReservaServicio_Cantidad CHECK (cantidad > 0),
    CONSTRAINT FK_ReservaServicio_Reserva FOREIGN KEY (reservaID) REFERENCES Reserva(reservaID),
    CONSTRAINT FK_ReservaServicio_Servicio FOREIGN KEY (servicioNombre) REFERENCES Servicio(servicioNombre) );
GO


insert into Propietario (propietarioDocumento,propietarioEmail,propietarioNombre,propietarioTelefono) values ('60242466', 'nfuentes9202@gmail.com','Nahuel','096208361')
insert into Gato (gatoNombre,gatoRaza,gatoEdad,gatoPeso,propietarioDocumento) values ('Mia','Raza',5,30,'60242466')
insert into Habitacion (habitacionNombre,habitacionCapacidad,habitacionPrecio,habitacionEstado) values ('Habitacion 1', 6, 60.25,'DISPONIBLE')
insert into Reserva(gatoID,habitacionNombre,reservaFechaInicio,reservaFechaFin,reservaMonto) values (1,'Habitacion 1', '27/08/2023','30/08/2023', 500)
insert into Reserva(gatoID,habitacionNombre,reservaFechaInicio,reservaFechaFin,reservaMonto) values (1,'Habitacion 1', '20/08/2023','24/08/2023', 500)
insert into Reserva(gatoID,habitacionNombre,reservaFechaInicio,reservaFechaFin,reservaMonto) values (1,'Habitacion 1', '01/08/2023','15/08/2023', 500)
insert into Reserva(gatoID,habitacionNombre,reservaFechaInicio,reservaFechaFin,reservaMonto) values (1,'Habitacion 1', '27/07/2023','30/07/2023', 500)
insert into Servicio(servicioNombre, servicioPrecio) values ('Limado',50)
insert into Servicio(servicioNombre, servicioPrecio) values ('Lavado',20)
insert into Servicio(servicioNombre, servicioPrecio) values ('Caricias',15)
insert into Servicio(servicioNombre, servicioPrecio) values ('Bebidas',10)
insert into Servicio(servicioNombre, servicioPrecio) values ('Television',45)
insert into Servicio(servicioNombre, servicioPrecio) values ('PicadaPerruna',75)
insert into Reserva_Servicio(reservaID,servicioNombre,cantidad) values (1,'Limado',8)
insert into Reserva_Servicio(reservaID,servicioNombre,cantidad) values (1,'Lavado',3)
insert into Reserva_Servicio(reservaID,servicioNombre,cantidad) values (1,'Caricias',5)
insert into Reserva_Servicio(reservaID,servicioNombre,cantidad) values (1,'Bebidas',12)
insert into Reserva_Servicio(reservaID,servicioNombre,cantidad) values (1,'Television',9)
insert into Reserva_Servicio(reservaID,servicioNombre,cantidad) values (1,'PicadaPerruna',7)

update Habitacion

set habitacionCapacidad = 6

where habitacionNombre = 'Habitacion 1'

select * from Servicio
select * from Habitacion
select * from Reserva


select * from Gato

select * from Propietario prop join Gato gat on prop.propietarioDocumento = gat.propietarioDocumento

--Query 1 Obligatorio

select  gat.gatoNombre Gato,
		prop.propietarioNombre Propietario,
		hab.habitacionNombre,
		res.reservaMonto

from Reserva res

join Gato gat on res.gatoID = gat.gatoID
join Habitacion hab on res.habitacionNombre = hab.habitacionNombre
join Propietario prop on gat.propietarioDocumento = prop.propietarioDocumento

order by res.reservaFechaInicio desc, habitacionCapacidad desc

--Query 2 Obligatorio

select --top 3
		ser.servicioNombre,
        ser.servicioPrecio,
		resSer.cantidad

from Reserva_Servicio resSer

join Servicio ser on resSer.servicioNombre = ser.servicioNombre

where resSer.cantidad >= 5
	  and (YEAR(getDate()) -1 ) = YEAR((select reservaFechaInicio from Reserva where reservaID = resSer.reservaID))

order by resSer.cantidad DESC

--Query 3 Obligatorio

select  gat.gatoNombre,
		hab.habitacionNombre

from Reserva_Servicio resSer

join Reserva res on resSer.reservaID = res.reservaID
join Gato gat on res.gatoID = gat.gatoID
join Habitacion hab on res.habitacionNombre = hab.habitacionNombre	

group by gat.gatoNombre,
		 hab.habitacionNombre

having count(distinct resSer.servicioNombre) = (select count(*) from Servicio)

select * from Reserva_Servicio

--Query 4 Obligatorio
