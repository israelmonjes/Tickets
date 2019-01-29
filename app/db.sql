DROP DATABASE IF EXISTS edtickets;

CREATE DATABASE IF NOT EXISTS edtickets;

USE edtickets;

DROP TABLE IF EXISTS actividades;

CREATE TABLE IF NOT EXISTS actividades(
    actividad_id CHAR(2) PRIMARY KEY,
    bloque ENUM('Bloque 1','Bloque 2','Bloque 3') NOT NULL,
    disciplina ENUM('YOGA', 'KICKBOXIN', 'PILATES', 'ZUMBA'),
    horario VARCHAR(20) NOT NULL,
    cupo INTEGER NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO actividades(actividad_id, bloque, disciplina, horario, cupo) VALUES ('1Y', 'Bloque 1', 'YOGA', '9:00 A 12:00', 20),
('1K', 'Bloque 1', 'KICKBOXIN', '9:00 A 12:00', 10),
('1P', 'Bloque 1', 'PILATES', '9:00 A 12:00', 10),
('1Z', 'Bloque 1', 'ZUMBA', '9:00 A 12:00', 10),
('2Y', 'Bloque 2', 'YOGA', '14:00 A 17:00', 20),
('2K', 'Bloque 2', 'KICKBOXIN', '14:00 A 17:00', 10),
('2P', 'Bloque 2', 'PILATES', '14:00 A 17:00', 10),
('2Z', 'Bloque 2', 'ZUMBA', '14:00 A 17:00', 10),
('3Y', 'Bloque 3', 'YOGA', '18:00 A 21:00', 20),
('3K', 'Bloque 3', 'KICKBOXIN', '18:00 A 21:00', 10),
('3P', 'Bloque 3', 'PILATES', '18:00 A 21:00', 10),
('3Z', 'Bloque 3', 'ZUMBA', '18:00 A 21:00', 10);

DROP TABLE IF EXISTS participantes;

CREATE TABLE IF NOT EXISTS participantes (
    email VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    nacimiento DATE NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS registros;

CREATE TABLE IF NOT EXISTS registros (
    registro_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) UNIQUE NOT NULL,
    actividad CHAR(2) NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (email) REFERENCES participantes(email)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (actividad) REFERENCES actividades (actividad_id)
        ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP PROCEDURE IF EXISTS registrar_participantes;

DELIMITER $$

CREATE PROCEDURE registrar_participantes(
    IN _email VARCHAR(50),
    IN _nombre VARCHAR(50),
    IN _apellidos VARCHAR(50),
    IN _nacimiento DATE,
    IN _actividad CHAR(2)
)

BEGIN
    DECLARE existe_registro INT DEFAULT 0;
    DECLARE limite INT DEFAULT 0;
    DECLARE registrados INT DEFAULT 0;
    DECLARE actividad_llena VARCHAR(255) DEFAULT 'El bloque y actividad seleccionados, ya no tienen lugares disponibles';
    DECLARE respuesta VARCHAR(50) DEFAULT 'OK';

    START TRANSACTION;
        SELECT COUNT(*) INTO existe_registro FROM registros
        WHERE email = _email;

        IF existe_registro = 1 THEN
            
            SELECT 'Tu correo electronico ya ha sido registrado previamente, Solo puedes Registrarte una vez' 
            AS respuesta;

        ELSE

            SELECT cupo INTO limite FROM actividades
            WHERE actividad_id = _actividad;

            SELECT COUNT(*) INTO registrados FROM registros
            WHERE actividad = _actividad;

            IF registrados < limite THEN
                INSERT INTO participantes (email, nombre, apellidos, nacimiento)
                VALUES (_email, _nombre, _apellidos, _nacimiento);

                INSERT INTO registros(email, actividad, fecha) VALUES (_email, _actividad, NOW());

            ELSE
                SELECT actividad_llena;

            END IF;
        
        END IF;

    COMMIT;

END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS eliminar_participante;

DELIMITER $$

    CREATE PROCEDURE eliminar_participante(
        IN _email VARCHAR(50)
    )

    BEGIN
        DECLARE existe_email INT DEFAULT 0;
        DECLARE respuestas VARCHAR(50) DEFAULT 'No se encontro email';

        START TRANSACTION;
            SELECT COUNT(*) INTO existe_email FROM registros
            WHERE email = _email; 

           IF existe_email = 1 THEN

                DELETE FROM participantes 
                WHERE email = _email;

                DELETE FROM registros
                WHERE email = _email;

            ELSE    

                SELECT respuestas; 

            END IF;

        COMMIT;

    END $$

DELIMITER ;

/*CALL registrar_participantes ('prueba15@gmail.com', 'Eliseo Israel', 'Monjes Reyes', '1998-01-09', '1Y')*/