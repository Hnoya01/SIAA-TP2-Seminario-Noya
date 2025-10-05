-- =========================================================
-- SIAA - Script de Base de Datos (MySQL 8.x, InnoDB)
-- Guardar como: NOYA-HERNAN-AP2.sql
-- Nota: En prototipo se deja ON DELETE CASCADE en bitácora; en productivo usar RESTRICT.
-- =========================================================

/* 1) Esquema */
CREATE DATABASE IF NOT EXISTS siaa_db
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE siaa_db;

/* 2) Entidades básicas */
CREATE TABLE afiliado (
  dni         VARCHAR(20)  PRIMARY KEY,
  nombre      VARCHAR(120) NOT NULL,
  plan        VARCHAR(40)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE prestador (
  id          BIGINT       PRIMARY KEY AUTO_INCREMENT,
  nombre      VARCHAR(120) NOT NULL,
  en_cartilla BOOLEAN      NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE prestacion (
  codigo      VARCHAR(20)   PRIMARY KEY,
  descripcion VARCHAR(160)  NOT NULL,
  precio      DECIMAL(12,2) NOT NULL,
  CONSTRAINT chk_prestacion_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

/* 3) Solicitud y composición (ítems) */
CREATE TABLE solicitud (
  id            BIGINT       PRIMARY KEY AUTO_INCREMENT,
  fecha         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  orden_fecha   DATE         NULL,
  estado        ENUM('EN_EVALUACION','SOLICITAR_DOC','EN_CORRECCION','ELEVADA',
                     'AUTORIZADA','RECHAZADA','ANULADA','INFORMAR_AFILIADO','ARCHIVADA')
                NOT NULL DEFAULT 'EN_EVALUACION',
  afiliado_dni  VARCHAR(20)  NOT NULL,
  prestador_id  BIGINT       NOT NULL,
  tomado_por    VARCHAR(60)  NULL,
  tomado_ts     DATETIME     NULL,
  version       INT          NOT NULL DEFAULT 0,

  CONSTRAINT fk_sol_afiliado   FOREIGN KEY (afiliado_dni) REFERENCES afiliado(dni),
  CONSTRAINT fk_sol_prestador  FOREIGN KEY (prestador_id) REFERENCES prestador(id)
) ENGINE=InnoDB;

CREATE TABLE item_solicitud (
  id             BIGINT        PRIMARY KEY AUTO_INCREMENT,
  solicitud_id   BIGINT        NOT NULL,
  prestacion_cod VARCHAR(20)   NOT NULL,
  cantidad       INT           NOT NULL,
  precio_unit    DECIMAL(12,2) NOT NULL,

  CONSTRAINT chk_item_cant  CHECK (cantidad > 0),
  CONSTRAINT chk_item_prec  CHECK (precio_unit >= 0),
  CONSTRAINT fk_item_sol    FOREIGN KEY (solicitud_id)   REFERENCES solicitud(id)        ON DELETE CASCADE,
  CONSTRAINT fk_item_pres   FOREIGN KEY (prestacion_cod) REFERENCES prestacion(codigo)
) ENGINE=InnoDB;

/* 4) Bitácora (append-only; CASCADE sólo para prototipo) */
CREATE TABLE bitacora (
  id            BIGINT      PRIMARY KEY AUTO_INCREMENT,
  solicitud_id  BIGINT      NOT NULL,
  fecha         DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actor         VARCHAR(80) NOT NULL,
  evento        VARCHAR(80) NOT NULL,
  detalle       TEXT        NULL,

  CONSTRAINT fk_bit_sol FOREIGN KEY (solicitud_id) REFERENCES solicitud(id) ON DELETE CASCADE
) ENGINE=InnoDB;

/* 5) Dictamen (1:1 opcional con solicitud) */
CREATE TABLE dictamen (
  id            BIGINT      PRIMARY KEY AUTO_INCREMENT,
  solicitud_id  BIGINT      NOT NULL,
  resultado     ENUM('APROBADO','OBSERVADO') NOT NULL,
  observaciones TEXT        NULL,
  fecha         DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT uq_dictamen_solicitud UNIQUE (solicitud_id),
  CONSTRAINT fk_dic_sol FOREIGN KEY (solicitud_id) REFERENCES solicitud(id) ON DELETE CASCADE
) ENGINE=InnoDB;

/* 6) Antecedentes (control de duplicidad por ventana) */
CREATE TABLE antecedentes (
  id              BIGINT      PRIMARY KEY AUTO_INCREMENT,
  afiliado_dni    VARCHAR(20) NOT NULL,
  prestacion_cod  VARCHAR(20) NOT NULL,
  fecha           DATE        NOT NULL,

  CONSTRAINT fk_ant_afili FOREIGN KEY (afiliado_dni)   REFERENCES afiliado(dni),
  CONSTRAINT fk_ant_prest FOREIGN KEY (prestacion_cod) REFERENCES prestacion(codigo)
) ENGINE=InnoDB;

/* 7) Índices */
CREATE INDEX idx_sol_afiliado        ON solicitud(afiliado_dni);
CREATE INDEX idx_sol_estado          ON solicitud(estado);
CREATE INDEX idx_sol_estado_fecha    ON solicitud(estado, fecha);
CREATE INDEX idx_item_sol            ON item_solicitud(solicitud_id);
CREATE INDEX idx_bit_sol_fecha       ON bitacora(solicitud_id, fecha);
CREATE INDEX idx_ant_lookup          ON antecedentes(afiliado_dni, prestacion_cod, fecha);
/* Opcional: evitar duplicidad exacta mismo día
   CREATE UNIQUE INDEX uq_ant_dia ON antecedentes(afiliado_dni, prestacion_cod, fecha);
*/

/* 8) Vista de totales (incluye solicitudes sin ítems => total = 0) */
CREATE OR REPLACE VIEW vw_solicitud_total AS
SELECT s.id,
       COALESCE(SUM(i.cantidad * i.precio_unit), 0) AS total
  FROM solicitud s
  LEFT JOIN item_solicitud i ON i.solicitud_id = s.id
 GROUP BY s.id;

/* 9) Datos de ejemplo mínimos */
INSERT INTO afiliado (dni, nombre, plan) VALUES
('30111222', 'Ana Gómez', 'P1'),
('32123456', 'Luis Pérez', 'P2');

INSERT INTO prestador (nombre, en_cartilla) VALUES
('SANAR S.A.', TRUE),
('CENTRO IMAGENES', TRUE),
('CLINICA PRIVADA X', FALSE);

INSERT INTO prestacion (codigo, descripcion, precio) VALUES
('P-001', 'Consulta clínica',       12000.00),
('P-050', 'Estudio RM',            600000.00),
('P-200', 'Tratamiento intensivo', 900000.00);

/* Antecedente para probar duplicidad (30 días) */
INSERT INTO antecedentes (afiliado_dni, prestacion_cod, fecha) VALUES
('30111222', 'P-001', DATE_SUB(CURDATE(), INTERVAL 10 DAY));

/* 10) Ejemplo de alta + ítem + bitácora (para evidencias) */
INSERT INTO solicitud (estado, afiliado_dni, prestador_id, orden_fecha)
VALUES ('EN_EVALUACION', '30111222', 1, CURDATE());

SET @id_sol := LAST_INSERT_ID();

INSERT INTO item_solicitud (solicitud_id, prestacion_cod, cantidad, precio_unit)
VALUES (@id_sol, 'P-001', 1, 12000.00);

INSERT INTO bitacora (solicitud_id, actor, evento, detalle)
VALUES (@id_sol, 'administrativo', 'ALTA', 'Alta inicial');

/* 11) Consultas de evidencia (para el informe)
   -- SHOW TABLES;
   -- DESCRIBE solicitud;
   -- SELECT id, estado, orden_fecha FROM solicitud WHERE id = @id_sol;
   -- SELECT fecha, actor, evento, detalle FROM bitacora WHERE solicitud_id = @id_sol ORDER BY fecha;
   -- SELECT * FROM vw_solicitud_total WHERE id = @id_sol;
   -- SELECT COUNT(*) AS cant FROM antecedentes
   --   WHERE afiliado_dni='30111222' AND prestacion_cod='P-001'
   --     AND fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);
*/

/* 12) Limpieza rápida (sólo si necesitás re-ejecutar)
-- DROP DATABASE siaa_db;
*/

