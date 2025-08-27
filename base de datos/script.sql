-- =====================================================================
-- ESQUEMA: Plataforma de colaboraciones / publicaciones / necesidades
-- Base de datos: PostgreSQL 13+
-- =====================================================================

-- Por prolijidad: borrar si existen (respetando dependencias)
DROP TABLE IF EXISTS entregable        CASCADE;
DROP TABLE IF EXISTS feedback          CASCADE;
DROP TABLE IF EXISTS colaboracion      CASCADE;
DROP TABLE IF EXISTS publicacion       CASCADE;
DROP TABLE IF EXISTS necesidad_habilidad CASCADE;
DROP TABLE IF EXISTS perfil_habilidad  CASCADE;
DROP TABLE IF EXISTS habilidad         CASCADE;
DROP TABLE IF EXISTS necesidad         CASCADE;
DROP TABLE IF EXISTS descartado        CASCADE;
DROP TABLE IF EXISTS match             CASCADE;
DROP TABLE IF EXISTS guardado          CASCADE;
DROP TABLE IF EXISTS perfil            CASCADE;
DROP TABLE IF EXISTS suscripcion       CASCADE;
DROP TABLE IF EXISTS plan              CASCADE;
DROP TABLE IF EXISTS usuario           CASCADE;

-- =====================================================================
-- Maestro: USUARIO / PLAN / SUSCRIPCION / PERFIL
-- =====================================================================

CREATE TABLE plan (
    id_plan        BIGSERIAL PRIMARY KEY,
    nombre         VARCHAR(80)        NOT NULL,
    techo          INTEGER            CHECK (techo IS NULL OR techo >= 0),
    precio         NUMERIC(12,2)      NOT NULL CHECK (precio >= 0)
);

CREATE TABLE usuario (
    id_usuario     BIGSERIAL PRIMARY KEY,
    id_plan        BIGINT REFERENCES plan(id_plan),
    nombre         VARCHAR(60)        NOT NULL,
    apellido       VARCHAR(60)        NOT NULL,
    email          VARCHAR(120)       NOT NULL UNIQUE,
    telefono       VARCHAR(30),
    contrasena     TEXT               NOT NULL,
    zona_horaria   VARCHAR(64),
    pais           VARCHAR(60)
);

CREATE TABLE suscripcion (
    id_suscripcion BIGSERIAL PRIMARY KEY,
    id_usuario     BIGINT NOT NULL REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    id_plan        BIGINT NOT NULL REFERENCES plan(id_plan),
    estado         VARCHAR(20) NOT NULL CHECK (estado IN ('activa','pendiente','pausada','vencida','cancelada')),
    inicio         DATE NOT NULL,
    fin            DATE
);

CREATE TABLE perfil (
    id_perfil      BIGSERIAL PRIMARY KEY,
    id_usuario     BIGINT NOT NULL UNIQUE REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    biografia      TEXT,
    whatsapp_url   TEXT,
    linkedin_url   TEXT,
    visibilidad    VARCHAR(20) NOT NULL DEFAULT 'publico' CHECK (visibilidad IN ('publico','privado')),
    reputacion     NUMERIC(3,2) CHECK (reputacion BETWEEN 0 AND 5)
);

-- =====================================================================
-- HABILIDADES y relaciones de N–M con Perfil y Necesidad
-- =====================================================================

CREATE TABLE habilidad (
    id_habilidad   BIGSERIAL PRIMARY KEY,
    nombre         VARCHAR(80) NOT NULL UNIQUE,
    descripcion    TEXT
);

CREATE TABLE perfil_habilidad (
    id_perfil_habilidad BIGSERIAL PRIMARY KEY,
    id_perfil      BIGINT NOT NULL REFERENCES perfil(id_perfil) ON DELETE CASCADE,
    id_habilidad   BIGINT NOT NULL REFERENCES habilidad(id_habilidad) ON DELETE CASCADE,
    UNIQUE (id_perfil, id_habilidad)
);

-- =====================================================================
-- PUBLICACION / NECESIDAD / MATCH / DESCARTADO / GUARDADO
-- =====================================================================


