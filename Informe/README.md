# La Emperatriz Tarología — Análisis de Tráfico Web

**Autora:** Verónica Canzani  
**Período analizado:** Mayo 2025 – Junio 2026  
**Sitio analizado:** [laemperatriztarot.com](https://laemperatriztarot.com)

---

## Descripción del proyecto

Análisis completo de tráfico web para **La Emperatriz Tarología**, sitio de tarología y esoterismo con 37.000 seguidores en Instagram. El objetivo fue diagnosticar el comportamiento del tráfico, identificar problemas y oportunidades, y proporcionar recomendaciones concretas para aumentar la audiencia y la monetización.

El proyecto cubre desde la extracción de datos crudos de Google Analytics 4 y Google Search Console hasta la visualización en Power BI y la redacción de un informe ejecutivo para la cliente.

---

## Herramientas utilizadas

| Herramienta | Uso |
|---|---|
| **Google Analytics 4** | Fuente de datos de tráfico web |
| **Google Search Console** | Datos de posicionamiento SEO |
| **Looker Studio** | Extracción y exportación de datos a CSV |
| **Python (pandas)** | Limpieza y transformación de datos |
| **PostgreSQL** | Base de datos relacional |
| **DBeaver** | Cliente SQL para gestión de la base de datos |
| **Power BI Desktop** | Visualización de datos y dashboard |
| **VS Code** | Editor de código |
| **Claude (Anthropic)** | Asistente de IA para análisis, redacción de código SQL/Python y estructura del informe |
| **reportlab** | Generación del informe en PDF |

---

## Estructura del repositorio

```
la-emperatriz-tarologia/
│
├── datos/
│   └── (CSVs originales exportados desde GA4 y Search Console)
│
├── scripts/
│   ├── 01_explorar_archivos.py
│   ├── 02_revisar_datos.py
│   ├── 03_limpiar_datos.py
│   └── 04_cargar_datos.py
│
├── sql/
│   └── 05_vistas_sql.sql
│
├── imagenes/
│   └── (Capturas de los 9 gráficos de Power BI)
│
├── informe/
│   └── Informe_LaEmperatrizTarologia.pdf
│
└── README.md
```

---

## Proceso paso a paso

### 1. Extracción de datos
Los datos se extrajeron manualmente desde **Google Analytics 4** y **Google Search Console** usando **Looker Studio** como intermediario. Se exportaron 15 archivos CSV con información de:
- Tráfico por canal
- Estacionalidad diaria y mensual
- Páginas más visitadas
- Geografía por país y ciudad
- Dispositivos
- Usuarios nuevos vs recurrentes
- Clics salientes hacia plataformas de monetización
- SEO: impresiones, clics, CTR y posición media por página y por palabra clave

### 2. Exploración y limpieza de datos
Con **Python y pandas** se exploraron los archivos, se detectaron problemas de formato (encabezados de GA4, filas de totales, caracteres especiales) y se limpiaron los datos. Los scripts están numerados para seguir el orden lógico del proceso.

### 3. Carga a base de datos
Los datos limpios se cargaron en **PostgreSQL** local usando **SQLAlchemy**. Se crearon 15 tablas organizadas por tema.

### 4. Vistas SQL
Se crearon 12 vistas SQL sobre las tablas para simplificar las consultas y preparar los datos para Power BI. Las vistas incluyen:
- Participación por canal con porcentajes
- Mejores días de la semana (promedio de usuarios, excluyendo picos anómalos)
- Estacionalidad mensual
- Páginas más visitadas con títulos limpios
- Oportunidades SEO
- Monetización por plataforma
- Retención de usuarios

### 5. Dashboard en Power BI
Se conectó **Power BI Desktop** a PostgreSQL y se construyeron 9 visualizaciones:

1. **Participación por canal** — barras horizontales con etiquetas de número y porcentaje
2. **Estacionalidad por mes** — barras por mes con colores según volumen
3. **Mejores días de la semana** — columnas con colores por rendimiento (verde/ámbar/coral)
4. **Páginas más visitadas** — Top 12 con etiquetas
5. **SEO: Impresiones vs Clics** — barras agrupadas (ámbar + verde)
6. **Usuarios por país** — Top 8 con colores por país
7. **Dispositivos** — dona de distribución + barras de duración de sesión
8. **Monetización** — barras por plataforma
9. **Retención** — dona nuevos/recurrentes + barras de sesiones y duración

### 6. Informe ejecutivo
Se redactó un informe profesional en PDF usando **reportlab** con:
- Portada con métricas clave
- Resumen ejecutivo con 5 hallazgos principales
- 9 secciones de análisis con gráficos de Power BI
- Tabla de palabras clave SEO con recomendaciones
- Plan de acción en 3 bloques (esta semana / 30 días / 3 meses)

---

## Hallazgos principales

- **Diciembre 2025** concentró el 54% del tráfico total (779 usuarios) gracias al Ritual de la Nuez
- **El Ritual de la Nuez** tiene posición media 9.6 en Google — a un paso del top 5
- **93% de los usuarios** no vuelve al sitio — problema crítico de retención
- **Google Drive recibe más clics que Gumroad** — ingresos perdidos en cada descarga
- **Threads tiene mejor engagement** que Instagram por usuario
- El sitio tiene **37K seguidores en Instagram** pero convierte menos del 1% en visitas web

---

## Recomendaciones prioritarias

1. Agregar UTMs al link de la bio de Instagram (5 minutos)
2. Migrar archivos de Google Drive a Gumroad (30 minutos)
3. Mover el formulario de newsletter al inicio visible de la página
4. Optimizar el artículo del Ritual de la Nuez para SEO antes de octubre 2026
5. Excluir la IP de Philadelphia en GA4 para datos más precisos

---

## Nota metodológica

Este proyecto fue realizado de forma independiente como analista de datos externa. Los datos pertenecen al sitio laemperatriztarot.com y fueron utilizados con autorización de la propietaria. El análisis se realizó con fines profesionales y de portfolio.

La inteligencia artificial (Claude de Anthropic) fue utilizada como herramienta de trabajo durante el proceso: para estructurar consultas SQL, depurar código Python, redactar el informe y organizar los hallazgos. El criterio analítico, las decisiones metodológicas y la interpretación de los datos son de la autora.

---

*Verónica Canzani — Analista de Datos — 2026*

