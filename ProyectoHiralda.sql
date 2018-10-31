-- Autor: Castro Cisneros Hiralda
-- Correo: castroc.hiralda@gmail.com
-- Fecha: 31 de octubre del 2018
-- Descripcion: Script de una base de datos, donde se
-- 		implementa un juego de rol en el que los jugadores participan en batallas contra
-- 		campeones que alquilan para cada ocasión.

CREATE DATABASE IF NOT EXISTS juego;

-- or

DROP DATABASE IF EXISTS juego;
CREATE DATABASE juego;


USE juego;
-- Crea la tabla jugadores
CREATE TABLE jugadores(
    idJugador INT NOT NULL AUTO_INCREMENT,
    nombreJugador VARCHAR(45) NOT NULL,
    nivel INT NULL,
    fecha DATE NOT NULL,
    edad INT NOT NULL,
    CONSTRAINT jugadores_pk PRIMARY KEY(idJugador)
);
-- Crea la tabla campeones
CREATE TABLE campeones(
    idCampeon INT NOT NULL AUTO_INCREMENT,
    nombreCampeon VARCHAR(45) NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    precio DECIMAL(8,2) NULL,
    fecha DATE NOT NULL,
    edad INT NOT NULL,
    CONSTRAINT campeones_clave_alt UNIQUE (nombreCampeon),
    CONSTRAINT campeones_pk PRIMARY KEY(idCampeon)
);
-- Crea la tabla batallas
CREATE TABLE batallas(
    jugadorId INT NOT NULL,
    campeonId INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT batallas_jugadores FOREIGN KEY (jugadorId)
        REFERENCES jugadores (idJugador)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT batallas_campeones FOREIGN KEY (campeonId)
        REFERENCES campeones (idCampeon)
        ON DELETE RESTRICT
        ON UPDATE CASCADE, 
        CONSTRAINT batallas_pk PRIMARY KEY  (jugadorId, campeonId)
);

-- 1. Proceso almacenado para crear un registro jugador
DELIMITER //
CREATE PROCEDURE `spCrearRegistroJugador` (
	IN _nombreJugador VARCHAR (45),
    IN _nivel INT,
    IN _fecha DATE,
    IN _edad INT
)
BEGIN
	INSERT INTO jugadores (
		nombreJugador, 
        nivel, 
        fecha,
        edad
	)
	VALUES(
		_nombreJugador,
        _nivel,
        _fecha,
        _edad
    );
END //
DELIMITER ;

-- 2. Proceso almacenado para crear un registro campeon
DELIMITER //
CREATE PROCEDURE `spCrearRegistroCampeon` (
	IN _nombreCampeon VARCHAR (45),
    IN _tipo VARCHAR(20),
    IN _precio DECIMAL(8,2),
    IN _fecha DATE,
    IN _edad INT
)
BEGIN
	INSERT INTO campeones (
		nombreCampeon, 
        tipo, 
        precio,
        fecha,
        edad
	)
	VALUES(
		_nombreCampeon,
        _tipo,
        _precio,
        _fecha,
        _edad
    );
END //
DELIMITER ;

-- 3. Proceso almacenado para crear un registro batalla
DELIMITER //
CREATE PROCEDURE `spCrearRegistroBatallas` (
	IN _jugadorId INT,
    IN _campeonId INT,
    IN _cantidad INT
)
BEGIN
	INSERT INTO batallas (
		jugadorId, 
        campeonId, 
        cantidad
	)
	VALUES(
		_jugadorId,
        _campeonId,
        _cantidad
    );
END //
DELIMITER ;

-- 4.Proceso almacenado para actualizar un registro jugador
DELIMITER //
CREATE PROCEDURE `spActualizarRegistroJugador` (
	IN _idJugador INT,
	IN _nombreJugador VARCHAR (45),
    IN _nivel INT,
    IN _fecha DATE,
    IN _edad INT
)
BEGIN
	UPDATE jugadores 
    SET nombreJugador=_nombreJugador,
		nivel=_nivel,
		fecha=_fecha,
        edad=_edad
        WHERE idJugador=_idJugador;
END //
DELIMITER ;

-- 5.Proceso almacenado para actualizar un registro campeon
DELIMITER //
CREATE PROCEDURE `spActualizarRegistroCampeon` (
	IN _idCampeon INT,
	IN _nombreCampeon VARCHAR (45),
    IN _tipo VARCHAR(20),
    IN _precio DECIMAL(8,2),
    IN _fecha DATE,
    IN _edad INT
)
BEGIN
	UPDATE campeones
    SET nombreCampeon=_nombreCampeon,
        tipo=_tipo,
        precio=_precio,
        fecha=_fecha,
        edad=_edad
        WHERE idCampeon=_idCampeon;
END //
DELIMITER ;

-- 6.Proceso almacenado para actualizar un registro batalla
DELIMITER //
CREATE PROCEDURE `spActualizarRegistroBatallas` (
	IN _jugadorId INT,
    IN _campeonId INT,
    IN _cantidad INT
)
BEGIN
	UPDATE batallas
    SET jugadorId=_jugadorId,
        campeonId=_campeonId,
        cantidad=_cantidad
        WHERE campeonId=_campeonId and jugadorId=_jugadorId;
END //
DELIMITER ;

-- 7.Proceso almacenado para eliminar un registro jugador
DELIMITER //
CREATE PROCEDURE `spEliminarRegistroJugador` (
	IN _idJugador INT
)
BEGIN
	DELETE FROM jugadores
    WHERE idJugador=_idJugador;
END //
DELIMITER ;  

-- 8.Proceso almacenado para eliminar un registro campeon
DELIMITER //
CREATE PROCEDURE `spEliminarRegistroCampeon` (
	IN _idCampeon INT
)
BEGIN
	DELETE FROM campeones
    WHERE idCampeon=_idCampeon;
END //
DELIMITER ;  

-- 9.Proceso almacenado para eliminar un registro batalla
DELIMITER //
CREATE PROCEDURE `spEliminarRegistroBatallas` (
	IN _jugadorId INT,
    IN _campeonId INT
)
BEGIN
	DELETE FROM batallas 
    WHERE campeonesId =_campeonId
    AND jugadoresId=_jugadorId;
END //
DELIMITER ;

-- 10.Proceso almacenado para ver los registros de la tabla jugador
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroJugador` ()
BEGIN
	SELECT * FROM jugadores;
END //
DELIMITER ; 

-- 11.Proceso almacenado para ver los registros de la tabla campeon
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroCampeon` ()
BEGIN
	SELECT * FROM campeones;
END //
DELIMITER ; 

-- 12.Proceso almacenado para ver los registros de la tabla batallas
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroBatallas` ()
BEGIN
	SELECT c.nombreCampeon,c.precio,b.cantidad FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador=b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId=c.idCampeon;
END //
DELIMITER ;

-- 13.Proceso almacenado que devuelve un jugador en especifico
DELIMITER //
CREATE PROCEDURE `spObtenerUnRegistroJugador` (
	in _idJugador int)
BEGIN
	SELECT * FROM jugadores j where j.idJugador=_idJugador;
END //
DELIMITER ;

-- 14.Proceso almacenado que devuelve un campeon en especifico
DELIMITER //
CREATE PROCEDURE `spObtenerUnRegistroCampeon` (
	in _idCampeon int)
BEGIN
	SELECT * FROM campeon c where c.idCampeon=_idCampeon;
END //
DELIMITER ;

-- 15.Proceso almacenado que muestra los jugadores, que han combatido o no, y campeones 
DELIMITER //
CREATE PROCEDURE `spObtenerJugadoresConOSinBatallas`()
begin
	SELECT 
		j.nombreJugador, 
		c.nombreCampeon,
        b.cantidad
	FROM jugadores j
    LEFT JOIN batallas b
    ON j.idJugador = b.jugadorId
    LEFT JOIN campeones c
    ON b.campeonId = c.idCampeon
    ORDER BY j.nombreJugador;
end //
DELIMITER ;

-- 16.Proceso almacenado que muestra los jugadores y campeones que han combatido 
DELIMITER //
CREATE PROCEDURE `spObtenerJugadoresConBatallas`()
begin
	SELECT 
		j.nombreJugador, 
		c.nombreCampeon,
        b.cantidad
	FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    ORDER BY j.nombreJugador;
end //
DELIMITER ;

-- 17.Proceso almacenado que devuelve el campeon mas contratado
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroCampeonMasContratado` ()
BEGIN
	SELECT c.nombreCampeon, sum(b.cantidad) as total_batallas
    FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by b.campeonId 
    having total_batallas>= all
	(SELECT sum(b.cantidad) FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.idCampeon);
END //
DELIMITER ;

-- 18.Proceso almacenado que devuelve el campeon menos contratado
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroCampeonMenosContratado` ()
BEGIN
	SELECT c.nombreCampeon, sum(b.cantidad) as total_batallas
    FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by b.campeonId 
    having total_batallas<= all
	(SELECT sum(b.cantidad) FROM campeones c 
    INNER JOIN batallas b
    ON c.idCampeon = b.campeonId
    group by c.idCampeon);
END //
DELIMITER ;

-- 19.Proceso almacenado que devuelve el jugador que mas ha gastado
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroJugadorMasGasto` ()
BEGIN
	SELECT j.nombreJugador, sum(b.cantidad*c.precio) as total
    FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    group by j.idJugador
    having total>= all
	(SELECT sum(b.cantidad*c.precio) FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    INNER JOIN campeones c
    ON b.campeonId = c.idCampeon
    group by j.idJugador);
END //
DELIMITER ;

-- 20.Proceso almacenado que devuelve el jugador que menos ha contratado
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroJugadorMenosContrata` ()
BEGIN
	SELECT j.nombreJugador, sum(b.cantidad) as total
    FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    group by j.idJugador
    having total<= all
	(SELECT sum(b.cantidad) FROM jugadores j
    INNER JOIN batallas b
    ON j.idJugador = b.jugadorId
    group by j.idJugador);
END //
DELIMITER ;

-- 21.Proceso almacenado que devuelve a los jugadores jovenes
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroJugadorJoven` ()
BEGIN
	SELECT nombreJugador,edad FROM jugadores
    WHERE edad<18 ;
END //
DELIMITER ; 

-- 22.Proceso almacenado que devuelve a los jugadores adultos
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroJugadorAdulto` ()
BEGIN
	SELECT nombreJugador,edad FROM jugadores
    WHERE edad>=18 ;
END //
DELIMITER ; 

-- 23.Proceso almacenado que muestra los jugadores que no han combatido
DELIMITER //
CREATE PROCEDURE `spObtenerJugadoresSinBatallas`()
begin
	SELECT 
		j.nombreJugador
	FROM jugadores j
    LEFT JOIN batallas b
    on j.idJugador = b.jugadorId
    where b.campeonId is null;
end //
DELIMITER ;

-- 24.Proceso almacenado que muestra los campeones que no han combatido
DELIMITER //
CREATE PROCEDURE `spObtenerCampeonesSinBatallas`()
begin
	SELECT c.nombreCampeon
	FROM campeones c
    LEFT JOIN batallas b
    ON c.idCampeon= b.campeonId
    where b.jugadorId is null;
end //
DELIMITER ;

-- 25.Proceso almacenado que devuelve el jugador de nivel mas alto
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroJugadorMayorNivel` ()
BEGIN
	SELECT nombreJugador, nivel
    FROM jugadores
    where nivel = (SELECT MAX( nivel ) FROM jugadores); 
END //
DELIMITER ;

-- 26.Proceso almacenado que devuelve los campeones que no cobran
DELIMITER //
CREATE PROCEDURE `spObtenerRegistroCampeonNoCobra` ()
BEGIN
	SELECT nombreCampeon
    FROM campeones
    where precio is null;
END //
DELIMITER ;

-- 27.Funcion que devuelve el total de jugadores
DELIMITER //
CREATE FUNCTION `fnTotalJugador` ()
	RETURNS int
	BEGIN
    DECLARE total int;
	SET total=(SELECT count(*) 
    FROM jugadores);
    RETURN total;
END //
DELIMITER ; 

-- 28.Funcion que devuelve el total de campeones
DELIMITER //
CREATE FUNCTION `fnTotalCampeones` ()
	RETURNS int
	BEGIN
    DECLARE total int;
	SET total=(SELECT count(*) 
    FROM campeones);
    RETURN total;
END //
DELIMITER ; 

-- 29.Funcion que devuelve el gasto de un jugador
DELIMITER //
CREATE FUNCTION `fnPagoTotalJugador` (_idJugador INT)
	RETURNS DECIMAL(8,2)
    BEGIN
		DECLARE total DECIMAL(8,2);
        SET total = (SELECT 
			 SUM(c.precio * b.cantidad)
			 FROM jugadores j
			 INNER JOIN batallas b
			 ON j.idJugador = b.jugadorId
			 INNER JOIN campeones c
			 ON b.campeonId = c.idCampeon
			 WHERE j.idJugador = _idJugador
			 );
        RETURN total;
    END //
DELIMITER ; 

-- 30.Funcion que devuelve si un jugador es joven o adulto
DELIMITER //
CREATE FUNCTION `fnJugadorEsAdulto` ( _IdJugador int)
	RETURNS VARCHAR (10)
	BEGIN
	DECLARE mensaje  VARCHAR (10);
    DECLARE _edad int;
	SET _edad=(SELECT edad FROM jugadores
    WHERE idJugador = _IdJugador);
    if _edad>=18 then
		set mensaje='Adulto';
	else 
		set mensaje='Joven';
	end if;
    RETURN mensaje;
END //
DELIMITER ; 

-- 31.Funcion que devuelve si un campeon es joven o adulto
DELIMITER //
CREATE FUNCTION `fnCampeonEsAdulto` ( _IdCampeon int)
	RETURNS VARCHAR (10)
	BEGIN
	DECLARE mensaje  VARCHAR (10);
    DECLARE _edad int;
	SET _edad=(SELECT edad FROM campeones
    WHERE idCampeon = _IdCampeon);
    if _edad>=18 then
		set mensaje='Adulto';
	else 
		set mensaje='Joven';
	end if;
    RETURN mensaje;
END //
DELIMITER ; 

-- 32.Funcion que devuelve el gasto de un jugador y un campeon en especifico
DELIMITER //
CREATE FUNCTION `fnPagoTotalJugadorCampeon` (_idJugador INT,_idCampeon INT)
	RETURNS DECIMAL(8,2)
    BEGIN
		DECLARE total DECIMAL(8,2);
        SET total = (SELECT 
			 SUM(c.precio * b.cantidad)
			 FROM jugadores j
			 INNER JOIN batallas b
			 ON j.idJugador = b.jugadorId
			 INNER JOIN campeones c
			 ON b.campeonId = c.idCampeon
			 WHERE j.idJugador = _idJugador
             and c.idCampeon= _idCampeon
			 );
        RETURN total;
    END //
DELIMITER ; 

-- 33.Funcion que devuelve cuantes veces a jugado un jugador con un campeon en especifico
DELIMITER //
CREATE FUNCTION `fnBatallasJugadorCampeon` (_idJugador INT,_idCampeon INT)
	RETURNS INT
    BEGIN
		DECLARE total INT;
        SET total = (SELECT 
			 b.cantidad
			 FROM jugadores j
			 INNER JOIN batallas b
			 ON j.idJugador = b.jugadorId
			 INNER JOIN campeones c
			 ON b.campeonId = c.idCampeon
			 WHERE j.idJugador = _idJugador
             and c.idCampeon= _idCampeon
			 );
        RETURN total;
    END //
DELIMITER ; 

CALL spCrearRegistroJugador('Salazar', 20, '2018-06-29',28);
CALL spCrearRegistroJugador('Jalmes', 10, '2018-07-15',16);
CALL spCrearRegistroJugador('Bernal', 30, '2018-09-24',18);
CALL spCrearRegistroJugador('Corona', NULL, '2018-12-25',22);

CALL spCrearRegistroCampeon('Akali', 'Aseseino', 790, '2018-05-11',12);
CALL spCrearRegistroCampeon('Brand', 'Aseseino', NULL, '2018-09-10',22);
CALL spCrearRegistroCampeon('Caitlyn', 'mago', 880, '2018-01-01',32);
CALL spCrearRegistroCampeon('Karpov', 'Aseseino', 1880, '2018-01-01',17);

CALL spCrearRegistroBatallas(1, 1, 300);
CALL spCrearRegistroBatallas(1, 2, 200);
CALL spCrearRegistroBatallas(1, 3, 400);
CALL spCrearRegistroBatallas(2, 1, 300);
CALL spCrearRegistroBatallas(2, 2, 400);
CALL spCrearRegistroBatallas(3, 1, 200);
call spObtenerRegistroJugadorMayorNivel();