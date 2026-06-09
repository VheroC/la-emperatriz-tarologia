-- ============================================================
-- VISTAS SQL - LA EMPERATRIZ TAROLOGÍA
-- Análisis de tráfico web mayo 2025 - junio 2026
-- Fuente: Google Analytics 4 + Google Search Console
-- ============================================================

-- Vista 1: Participación por canal de tráfico
CREATE OR REPLACE VIEW v_participacion_canal AS
SELECT 
    canal,
    usuarios_activos,
    ROUND(usuarios_activos * 100.0 / SUM(usuarios_activos) OVER (), 1) AS pct_del_total,
    porcentaje_rebote
FROM trafico_canal
ORDER BY usuarios_activos DESC;

-- Vista 2: Promedio de usuarios por día de la semana
CREATE VIEW v_mejores_dias_semana AS
SELECT 
    CASE dia_semana
        WHEN 'Monday' THEN 'Lunes'
        WHEN 'Tuesday' THEN 'Martes'
        WHEN 'Wednesday' THEN 'Miércoles'
        WHEN 'Thursday' THEN 'Jueves'
        WHEN 'Friday' THEN 'Viernes'
        WHEN 'Saturday' THEN 'Sábado'
        WHEN 'Sunday' THEN 'Domingo'
    END AS dia_semana,
    COUNT(*) AS cantidad_dias,
    SUM(usuarios_activos) AS total_usuarios,
    ROUND(AVG(usuarios_activos), 1) AS promedio_usuarios
FROM estacionalidad
WHERE fecha != '2025-11-23'
GROUP BY dia_semana
ORDER BY promedio_usuarios DESC;
-- Vista 3: Usuarios por mes
CREATE OR REPLACE VIEW v_estacionalidad_mensual AS
SELECT 
    TO_CHAR(fecha::date, 'YYYY-MM') AS mes,
    SUM(usuarios_activos) AS usuarios,
    SUM(sesiones) AS sesiones,
    SUM(usuarios_nuevos) AS nuevos,
    SUM(usuarios_activos) - SUM(usuarios_nuevos) AS recurrentes
FROM estacionalidad
GROUP BY TO_CHAR(fecha::date, 'YYYY-MM')
ORDER BY mes;

-- Vista 4: Páginas más visitadas con porcentaje del total
CREATE VIEW v_paginas_top AS
SELECT 
    CASE 
        WHEN titulo_pagina LIKE 'La Emperatriz Tarología –%' THEN 'Inicio'
        WHEN titulo_pagina LIKE '%E-books%' OR titulo_pagina LIKE 'Ebooks%' THEN 'Ebooks'
        WHEN titulo_pagina LIKE '%Ritual de la Nuez%' THEN 'Ritual de la Nuez'
        WHEN titulo_pagina LIKE '%Tarot Rider Waite%' THEN 'Tarot Rider Waite'
        WHEN titulo_pagina LIKE '%Recomendados%' OR titulo_pagina LIKE '%Amazon%' THEN 'Recomendados Amazon'
        WHEN titulo_pagina LIKE '%Hierbas y Rituales%' THEN 'Hierbas y Rituales'
        WHEN titulo_pagina LIKE '%Calendario%' THEN 'Calendario Mágico'
        WHEN titulo_pagina LIKE '%Suma Sacerdotisa%' THEN 'La Suma Sacerdotisa'
        ELSE TRIM(SPLIT_PART(titulo_pagina, ' - La Emperatriz Tarología', 1))
    END AS titulo_pagina,
    SUM(vistas) AS vistas,
    SUM(usuarios_activos) AS usuarios_activos,
    ROUND(SUM(vistas) * 100.0 / (SELECT SUM(vistas) FROM paginas_visitadas), 1) AS pct_del_total
FROM paginas_visitadas
GROUP BY 1
ORDER BY vistas DESC;
-- Vista 5: Oportunidades SEO
CREATE VIEW v_seo_oportunidades AS
SELECT 
    CASE
        WHEN pagina = '/' THEN 'Inicio'
        WHEN pagina LIKE '%ritual-de-la-nuez%' THEN 'Ritual de la Nuez'
        WHEN pagina LIKE '%arcanos-mayores%' THEN '22 Arcanos Mayores'
        WHEN pagina LIKE '%agrippa%' THEN 'H.C. Agrippa'
        WHEN pagina LIKE '%suma-sacerdotisa%' THEN 'La Suma Sacerdotisa'
        WHEN pagina LIKE '%la-emperatriz%' THEN 'La Emperatriz'
        WHEN pagina LIKE '%marsella%' THEN 'Tarot de Marsella'
        WHEN pagina LIKE '%tarot%coleccion%' THEN 'Colección Mazos Tarot'
        WHEN pagina LIKE '%tarot%universal%' THEN 'Tarot Universal'
        ELSE pagina
    END AS pagina,
    impresiones,
    clics,
    ROUND(ctr::numeric, 2) AS ctr,
    ROUND(posicion_media::numeric, 1) AS posicion_media,
    CASE 
        WHEN posicion_media <= 10 AND clics = 0 THEN 'Urgente'
        WHEN posicion_media <= 20 AND impresiones > 50 THEN 'Oportunidad'
        WHEN clics > 0 THEN 'Funciona'
        ELSE 'Baja prioridad'
    END AS diagnostico
FROM seo_paginas
ORDER BY impresiones DESC
LIMIT 8;
-- Vista 6: Monetización — clics clasificados por plataforma
CREATE OR REPLACE VIEW v_monetizacion AS
SELECT 
    url_enlace,
    numero_eventos AS clics,
    usuarios_activos,
    CASE
        WHEN url_enlace LIKE '%etsy%'           THEN 'Etsy'
        WHEN url_enlace LIKE '%gumroad%'        THEN 'Gumroad'
        WHEN url_enlace LIKE '%amzn%' 
          OR url_enlace LIKE '%amazon%'         THEN 'Amazon'
        WHEN url_enlace LIKE '%drive.google%'   THEN 'Google Drive'
        WHEN url_enlace LIKE '%buymeacoffee%'   THEN 'Buy Me a Coffee'
        WHEN url_enlace LIKE '%instagram%'      THEN 'Instagram'
        ELSE 'Otro'
    END AS plataforma
FROM clics_salientes
ORDER BY clics DESC;

-- Vista 7: Retención — nuevos vs recurrentes
CREATE OR REPLACE VIEW v_retencion AS
SELECT 
    tipo_usuario,
    usuarios_activos,
    sesiones_con_interaccion,
    duracion_media_seg,
    ROUND(usuarios_activos * 100.0 / SUM(usuarios_activos) OVER (), 1) AS pct_del_total
FROM usuarios_tipo
ORDER BY usuarios_activos DESC;

-- Vista 8: Geografía — países con porcentaje del total y recurrentes correctos
CREATE VIEW v_geografia_ranking AS
SELECT 
    CASE g.pais
        WHEN 'Spain' THEN 'España'
        WHEN 'United States' THEN 'EE.UU.'
        WHEN 'Argentina' THEN 'Argentina'
        WHEN 'Mexico' THEN 'México'
        WHEN 'Colombia' THEN 'Colombia'
        WHEN 'Chile' THEN 'Chile'
        WHEN 'Uruguay' THEN 'Uruguay'
        WHEN 'Venezuela' THEN 'Venezuela'
        WHEN 'Germany' THEN 'Alemania'
        WHEN 'France' THEN 'Francia'
        WHEN 'Peru' THEN 'Perú'
        WHEN 'Paraguay' THEN 'Paraguay'
        WHEN 'Bolivia' THEN 'Bolivia'
        WHEN 'Costa Rica' THEN 'Costa Rica'
        WHEN 'Dominican Republic' THEN 'Rep. Dominicana'
        WHEN 'Puerto Rico' THEN 'Puerto Rico'
        WHEN 'Panama' THEN 'Panamá'
        WHEN 'Cuba' THEN 'Cuba'
        WHEN 'Portugal' THEN 'Portugal'
        WHEN 'Italy' THEN 'Italia'
        WHEN 'Switzerland' THEN 'Suiza'
        WHEN 'Sweden' THEN 'Suecia'
        WHEN 'Poland' THEN 'Polonia'
        WHEN 'Canada' THEN 'Canadá'
        WHEN 'China' THEN 'China'
        ELSE g.pais
    END AS pais,
    g.usuarios_activos,
    ROUND(g.usuarios_activos * 100.0 / SUM(g.usuarios_activos) OVER (), 1) AS pct_del_total,
    g.sesiones,
    g.usuarios_nuevos,
    COALESCE(r.usuarios_activos, 0) AS recurrentes
FROM geografia_pais g
LEFT JOIN geografia_recurrentes r 
    ON r.pais = g.pais 
    AND r.tipo_usuario = 'returning'
ORDER BY g.usuarios_activos DESC;
-- Vista 9: Calidad de fuentes de tráfico
CREATE OR REPLACE VIEW v_fuentes_calidad AS
SELECT 
    fuente_medio,
    usuarios_activos,
    sesiones,
    sesiones_con_interaccion,
    duracion_media_seg,
    porcentaje_rebote,
    ROUND(sesiones_con_interaccion * 100.0 / sesiones, 1) AS pct_sesiones_interaccion,
    CASE
        WHEN porcentaje_rebote < 40 AND duracion_media_seg > 200 THEN 'Alta calidad'
        WHEN porcentaje_rebote < 60 AND duracion_media_seg > 100 THEN 'Calidad media'
        ELSE 'Baja calidad'
    END AS calidad
FROM fuente_medio
ORDER BY usuarios_activos DESC;

-- Vista 11: Dispositivos con nombres en español
CREATE VIEW v_dispositivos AS
SELECT 
    CASE dispositivo
        WHEN 'mobile' THEN 'Móvil'
        WHEN 'desktop' THEN 'Escritorio'
        WHEN 'tablet' THEN 'Tablet'
        ELSE dispositivo
    END AS dispositivo,
    usuarios_activos,
    sesiones,
    ROUND(porcentaje_rebote::numeric, 1) AS porcentaje_rebote,
    ROUND(duracion_media_seg::numeric, 0) AS duracion_media_seg
FROM dispositivos;
-- ============================================================
-- QUERIES DE ANÁLISIS — CRUCES ENTRE TABLAS
-- ============================================================

-- ¿Qué canal trae mejor calidad de tráfico?
SELECT 
    t.canal,
    t.usuarios_activos,
    t.porcentaje_rebote,
    f.duracion_media_seg,
    f.pct_sesiones_interaccion
FROM v_participacion_canal t
LEFT JOIN v_fuentes_calidad f 
    ON f.fuente_medio LIKE '%' || LOWER(t.canal) || '%'
ORDER BY t.usuarios_activos DESC;
-- NOTA: El cruce entre trafico_canal y fuente_medio genera NULLs
-- porque GA4 agrupa múltiples fuentes bajo un mismo canal.
-- Por ejemplo "Organic Social" incluye Instagram, Threads e ig/social.
-- Para un análisis más preciso se recomienda usar fuente_medio directamente.
-- ¿Qué países tienen mejor engagement?
SELECT 
    g.pais,
    g.usuarios_activos,
    g.pct_del_total,
    COALESCE(r.usuarios_activos, 0) AS recurrentes,
    ROUND(COALESCE(r.usuarios_activos, 0) * 100.0 / NULLIF(g.usuarios_activos, 0), 1) AS pct_recurrentes,
    COALESCE(r.sesiones_con_interaccion, 0) AS sesiones_con_interaccion,
    COALESCE(r.duracion_media_seg, 0) AS duracion_media_seg
FROM v_geografia_ranking g
LEFT JOIN geografia_recurrentes r 
    ON r.pais = g.pais 
    AND r.tipo_usuario = 'returning'
ORDER BY recurrentes DESC NULLS LAST;
-- NOTA: Los recurrentes se toman de geografia_recurrentes y no se calculan
-- como usuarios_activos - usuarios_nuevos porque Looker Studio exportó
-- todos los usuarios como nuevos en la tabla geografia_pais.

-- ¿Qué páginas tienen más potencial de monetización?
SELECT 
    p.titulo_pagina,
    p.vistas,
    p.usuarios_activos,
    p.pct_del_total,
    CASE
        WHEN p.titulo_pagina LIKE '%Ebook%' 
          OR p.titulo_pagina LIKE '%ebook%'    THEN 'Venta directa'
        WHEN p.titulo_pagina LIKE '%Amazon%' 
          OR p.titulo_pagina LIKE '%amazon%'   THEN 'Afiliados Amazon'
        WHEN p.titulo_pagina LIKE '%Ritual%' 
          OR p.titulo_pagina LIKE '%ritual%'   THEN 'Contenido orgánico'
        WHEN p.titulo_pagina LIKE '%Tarot%' 
          OR p.titulo_pagina LIKE '%tarot%'    THEN 'Contenido orgánico'
        ELSE 'Otro'
    END AS tipo_contenido
FROM v_paginas_top p
ORDER BY p.vistas DESC
LIMIT 15;

-- ¿El SEO del Ritual de la Nuez tiene potencial real?
-- Nota: SEO y páginas visitadas no se pueden cruzar directamente
-- porque SEO usa URLs y páginas usa títulos — son formatos distintos.
SELECT 
    pagina,
    impresiones,
    clics,
    ctr,
    posicion_media,
    diagnostico
FROM v_seo_oportunidades
ORDER BY impresiones DESC;

-- Resumen ejecutivo del negocio
SELECT 'Total usuarios' AS metrica, 
    SUM(usuarios_activos)::text AS valor
FROM trafico_canal

UNION ALL

SELECT 'Usuarios nuevos',
    usuarios_activos::text
FROM usuarios_tipo 
WHERE tipo_usuario = 'new'

UNION ALL

SELECT 'Usuarios recurrentes',
    usuarios_activos::text
FROM usuarios_tipo 
WHERE tipo_usuario = 'returning'

UNION ALL

SELECT 'Tasa de retención (%)',
    ROUND(99 * 100.0 / 1433, 1)::text
FROM usuarios_tipo 
WHERE tipo_usuario = 'returning'

UNION ALL

SELECT 'Total clics monetización',
    SUM(clics)::text
FROM v_monetizacion

UNION ALL

SELECT 'Mejor mes',
    mes || ' (' || usuarios::text || ' usuarios)'
FROM v_estacionalidad_mensual
WHERE usuarios = (SELECT MAX(usuarios) FROM v_estacionalidad_mensual);
-- Vista 10: Sesiones por usuario por canal, país y dispositivo
CREATE OR REPLACE VIEW v_sesiones_por_usuario AS
SELECT 'Canal' AS dimension, 
    canal AS valor,
    usuarios_activos,
    sesiones,
    ROUND(sesiones * 1.0 / usuarios_activos, 2) AS sesiones_por_usuario
FROM trafico_canal

UNION ALL

SELECT 'País',
    pais,
    usuarios_activos,
    sesiones,
    ROUND(sesiones * 1.0 / usuarios_activos, 2) AS sesiones_por_usuario
FROM geografia_pais

UNION ALL

SELECT 'Dispositivo',
    dispositivo,
    usuarios_activos,
    sesiones,
    ROUND(sesiones * 1.0 / usuarios_activos, 2) AS sesiones_por_usuario
FROM dispositivos;