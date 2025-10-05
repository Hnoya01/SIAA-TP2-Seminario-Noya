# SIAA-TP2-Seminario-Noya
Sistema Integral de Autorizaciones Ambulatorias (SIAA) - TP2 Seminario de Práctica
**Universidad Siglo 21**  
Autor: **Hernán Ricardo Noya**  
Año: **2025**

---

## 🧩 Sobre este repositorio

Este repositorio reúne los artefactos que forman parte del **prototipo del Sistema Integral de Autorizaciones Ambulatorias (SIAA)**, desarrollado como parte del TP2 de la materia *Seminario de Práctica* en la Universidad Siglo 21.

El objetivo principal es mostrar de forma integrada cómo se diseñó e implementó el modelo de datos, el diseño en capas y las consultas principales del sistema.  
Incluye el **script SQL completo**, la **estructura base en Java (MVC)** y material de apoyo (diagramas y capturas).

> Este proyecto es de carácter académico y representa un **prototipo funcional**.

---

## 📁 Estructura del repositorio

/
├── README.md

├── NOYA-HERNAN-AP2.sql # Script de la base de datos (MySQL 8.x)

├── /java/ # Estructura base del proyecto (MVC)

│ ├── /domain/ # Entidades y enums del dominio

│ ├── /application/ # Servicios y reglas de negocio

│ ├── /persistence/ # Interfaces e implementación JDBC

│ ├── /ui/ # Interfaz o punto de entrada (JavaFX/Swing)

│ └── /infrastructure/ # Configuración y utilitarios

│ └── config.properties.example # Plantilla de conexión

├── /imagenes/ # Diagramas y capturas del informe

└── /sql/ # Consultas de evidencia


## ⚙️ Requisitos y entorno

- **MySQL 8.x** (InnoDB, `utf8mb4`)  
- **Java 17 o superior**  
- Cliente MySQL (Workbench o CLI)  
- IDE recomendado: IntelliJ, Eclipse o NetBeans  

---

## 🚀 Cómo reproducir la base de datos

1. Abrir MySQL y ejecutar el script:

sql
   SOURCE NOYA-HERNAN-AP2.sql;


2. Verificar estructura:

sql
   USE siaa_db;
   SHOW TABLES;
   DESCRIBE solicitud;
   SELECT * FROM vw_solicitud_total LIMIT 5;


> El script crea el esquema `siaa_db`, genera las tablas, índices, vista de totales y carga un pequeño conjunto de datos de prueba (incluyendo un expediente con bitácora e ítems).

En este prototipo se deja **ON DELETE CASCADE** en algunas relaciones (por ejemplo, ítems y dictamen) para simplificar las pruebas.
En un entorno productivo, la relación con la **bitácora** debería ser **RESTRICT** para no perder trazabilidad.


## 🔌 Conexión desde Java (JDBC)

**URL base:**

jdbc:mysql://<host>:3306/siaa_db?useSSL=true&requireSSL=true&characterEncoding=utf8&serverTimezone=UTC

**¿Qué colocar en `<host>`?**

* Si MySQL y la aplicación están en la **misma PC** → `127.0.0.1` o `localhost`.
* Si la base está en **otro equipo o servidor** → usar la IP correspondiente (por ejemplo, `192.168.1.50`).

**Ejemplo de `config.properties.example`:**

properties
db.host=127.0.0.1
db.port=3306
db.schema=siaa_db
db.user=app_siaa
db.pass=********
db.ssl=true


> Este archivo se deja como plantilla y no incluye credenciales reales.
> Recomiendo copiarlo como `config.properties` fuera del control de versiones.


## 🧠 Principales decisiones de diseño

* **Modelo normalizado (3FN)**, con trazabilidad mediante bitácora *append-only*.
* **Vista `vw_solicitud_total`** para evitar redundancia en los totales.
* **Campos ENUM** para estados y dictámenes, mapeados directamente con los enums de Java.
* **Campo `orden_fecha`** en solicitudes para controlar la vigencia (≤ 30 días).
* **Índices** en afiliado, estado y fecha para optimizar consultas y tiempos de respuesta.
* **Campo `version`** en solicitudes, para permitir control optimista (casos de toma/cesión).


## 📸 Evidencias incluidas

En la carpeta `/imagenes/` se encuentran las capturas utilizadas en el informe:

* Diagrama Entidad-Relación (DER)
* Diagrama de clases y de despliegue
* Consultas SQL de evidencia (estado, bitácora, totales, duplicidad)



## 🏫 Información académica

**Carrera:** Licenciatura en Informática
**Materia:** Seminario de Práctica
**Institución:** Universidad Siglo 21

---

## 🔐 Licencia y uso

Proyecto de uso académico.
Puede utilizarse como referencia o material de estudio, citando al autor.

---
