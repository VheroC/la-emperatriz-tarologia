import pandas as pd
import os

# Carpeta donde van a quedar los archivos limpios
os.makedirs("datos_limpios", exist_ok=True)

# ── FUNCIÓN AUXILIAR ──────────────────────────────────────────
def leer_csv(archivo):
    """Lee un CSV manejando distintos formatos de exportación."""
    try:
        return pd.read_csv(archivo, encoding="utf-8-sig")
    except:
        return pd.read_csv(archivo, encoding="utf-8-sig", skiprows=9)

# ── 1. TRÁFICO POR CANAL ──────────────────────────────────────
print("Limpiando tráfico por canal...")
df = leer_csv("Trafico_por_canal.csv")

df.columns = ["canal", "usuarios_activos", "sesiones", 
              "sesiones_con_interaccion", "porcentaje_rebote"]

df["porcentaje_rebote"] = (df["porcentaje_rebote"] * 100).round(1)

df.to_csv("datos_limpios/trafico_canal.csv", index=False)
print(df.to_string())
print()

# ── 2. DISPOSITIVOS ───────────────────────────────────────────
print("Limpiando dispositivos...")
df = leer_csv("dispositivos.csv")

df.columns = ["dispositivo", "usuarios_activos", "sesiones",
              "porcentaje_rebote", "duracion_media_seg"]

df["porcentaje_rebote"] = (df["porcentaje_rebote"] * 100).round(1)
df["duracion_media_seg"] = df["duracion_media_seg"].round(0)

df.to_csv("datos_limpios/dispositivos.csv", index=False)
print(df.to_string())
print()

# ── 3. USUARIOS NUEVOS VS RECURRENTES ─────────────────────────
print("Limpiando usuarios nuevos vs recurrentes...")
df = leer_csv("usuarios_nuevos_vs_recurrentes.csv")

df.columns = ["tipo_usuario", "usuarios_activos", 
              "sesiones_con_interaccion", "duracion_media_seg"]

# Eliminar fila (not set)
df = df[df["tipo_usuario"] != "(not set)"]
df["duracion_media_seg"] = df["duracion_media_seg"].round(0)

df.to_csv("datos_limpios/usuarios_tipo.csv", index=False)
print(df.to_string())
print()

# ── 4. ESTACIONALIDAD ─────────────────────────────────────────
print("Limpiando estacionalidad...")
df = leer_csv("estacionalidad.csv")

df.columns = ["fecha", "usuarios_activos", "sesiones", "usuarios_nuevos"]

# Diccionario para convertir meses en español a número
meses = {
    "ene": "01", "feb": "02", "mar": "03", "abr": "04",
    "may": "05", "jun": "06", "jul": "07", "ago": "08",
    "sep": "09", "oct": "10", "nov": "11", "dic": "12"
}

def convertir_fecha(fecha_str):
    partes = fecha_str.strip().split()
    dia = partes[0].zfill(2)
    mes = meses[partes[1].lower()]
    anio = partes[2]
    return f"{anio}-{mes}-{dia}"

df["fecha"] = df["fecha"].apply(convertir_fecha)
df["fecha"] = pd.to_datetime(df["fecha"])
df["dia_semana"] = df["fecha"].dt.day_name()

df.to_csv("datos_limpios/estacionalidad.csv", index=False)
print(df.head(5).to_string())
print(f"... {len(df)} filas en total")
print()

print("✅ Limpieza completada. Archivos guardados en carpeta 'datos_limpios'")
# ── 5. TRÁFICO POR FUENTE/MEDIO ───────────────────────────────
print("Limpiando origen de la visita...")
df = leer_csv("origen_de_la_visita_detallado.csv")

df.columns = ["fuente_medio", "usuarios_activos", "sesiones_con_interaccion",
              "duracion_media_seg", "sesiones", "porcentaje_rebote"]

df["porcentaje_rebote"] = (df["porcentaje_rebote"] * 100).round(1)
df["duracion_media_seg"] = df["duracion_media_seg"].round(0)

df.to_csv("datos_limpios/origen_visita.csv", index=False)
print(df.head(5).to_string())
print()

# ── 6. GEOGRAFÍA POR PAÍS ─────────────────────────────────────
print("Limpiando geografía por país...")
df = leer_csv("geografia_por_pais.csv")

df.columns = ["pais", "usuarios_activos", "sesiones", "usuarios_nuevos"]

df.to_csv("datos_limpios/geografia_pais.csv", index=False)
print(df.head(5).to_string())
print()

# ── 7. GEOGRAFÍA POR CIUDAD ───────────────────────────────────
print("Limpiando geografía por ciudad...")
df = leer_csv("geografia_por_ciudad.csv")

df.columns = ["ciudad", "usuarios_activos", "sesiones", "usuarios_nuevos"]

df.to_csv("datos_limpios/geografia_ciudad.csv", index=False)
print(df.head(5).to_string())
print()

# ── 8. GEOGRAFÍA POR TIPO DE USUARIO ─────────────────────────
print("Limpiando geografía por tipo de usuario...")
df = leer_csv("geografia_por_tipo_de_usuario.csv")

df.columns = ["tipo_usuario", "pais", "usuarios_activos",
              "sesiones_con_interaccion", "duracion_media_seg"]

df["duracion_media_seg"] = df["duracion_media_seg"].round(0)

df.to_csv("datos_limpios/geografia_recurrentes.csv", index=False)
print(df.head(5).to_string())
print()

# ── 9. PÁGINAS MÁS VISITADAS ──────────────────────────────────
print("Limpiando páginas más visitadas...")
df = leer_csv("paginas_mas_visitadas.csv")

df.columns = ["titulo_pagina", "vistas", "usuarios_activos"]

df.to_csv("datos_limpios/paginas_visitadas.csv", index=False)
print(df.head(5).to_string())
print()

# ── 10. CLICS SALIENTES ───────────────────────────────────────
print("Limpiando clics salientes...")
df = leer_csv("Clics_salientes_etsy_amazon_gumroad.csv")

df.columns = ["url_enlace", "numero_eventos", "usuarios_activos"]

df.to_csv("datos_limpios/clics_salientes.csv", index=False)
print(df.head(5).to_string())
print()
# ── CORRECCIONES ──────────────────────────────────────────────

# Eliminar fila NaN de clics salientes
print("Corrigiendo clics salientes...")
df = pd.read_csv("datos_limpios/clics_salientes.csv")
df = df[df["url_enlace"].notna()]
df.to_csv("datos_limpios/clics_salientes.csv", index=False)
print(f"Filas después de limpiar: {len(df)}")
print()

# Eliminar (not set) de geografía por ciudad
print("Corrigiendo geografía por ciudad...")
df = pd.read_csv("datos_limpios/geografia_ciudad.csv")
df = df[df["ciudad"] != "(not set)"]
df.to_csv("datos_limpios/geografia_ciudad.csv", index=False)
print(f"Filas después de limpiar: {len(df)}")
print()

print("✅ Correcciones aplicadas.")
# ── 11. SEO - CONSULTAS ───────────────────────────────────────
print("Limpiando consultas SEO...")
df = leer_csv("Consultas_Consulta_de_la_Búsqueda_de_Google_orgánica.csv")

df.columns = ["consulta", "clics", "impresiones", "ctr", "posicion_media"]

df["ctr"] = (df["ctr"] * 100).round(2)
df["posicion_media"] = df["posicion_media"].round(1)

df.to_csv("datos_limpios/seo_consultas.csv", index=False)
print(df.head(5).to_string())
print()

# ── 12. SEO - PÁGINAS ─────────────────────────────────────────
print("Limpiando SEO por página...")
df = leer_csv("Tráfico_de_búsqueda_orgánica_de_Google_Página_de_destino_y_cadena_de_consulta.csv")

df.columns = ["pagina", "clics", "impresiones", "ctr", "posicion_media",
              "usuarios_activos", "sesiones_con_interaccion", "pct_interacciones",
              "tiempo_interaccion", "num_eventos", "eventos_clave", "ingresos"]

df["ctr"] = (df["ctr"] * 100).round(2)
df["posicion_media"] = df["posicion_media"].round(1)

df.to_csv("datos_limpios/seo_paginas.csv", index=False)
print(df.head(5).to_string())
print()

# ── 13. SEO - PAÍS ────────────────────────────────────────────
print("Limpiando SEO por país...")
df = leer_csv("Tráfico_de_búsqueda_orgánica_de_Google_País.csv")

df.columns = ["pais", "clics", "impresiones", "ctr", "posicion_media",
              "usuarios_activos", "sesiones_con_interaccion", "pct_interacciones",
              "tiempo_interaccion", "num_eventos", "eventos_clave", "ingresos"]

df["ctr"] = (df["ctr"] * 100).round(2)
df["posicion_media"] = df["posicion_media"].round(1)

df.to_csv("datos_limpios/seo_pais.csv", index=False)
print(df.head(5).to_string())
print()

# ── 14. SEO - DISPOSITIVO ─────────────────────────────────────
print("Limpiando SEO por dispositivo...")
df = leer_csv("Tráfico_de_búsqueda_orgánica_de_Google_Categoría_de_dispositivo.csv")

df.columns = ["dispositivo", "clics", "impresiones", "ctr", "posicion_media",
              "usuarios_activos", "sesiones_con_interaccion", "pct_interacciones",
              "tiempo_interaccion", "num_eventos", "eventos_clave", "ingresos"]

df["ctr"] = (df["ctr"] * 100).round(2)
df["posicion_media"] = df["posicion_media"].round(1)

df.to_csv("datos_limpios/seo_dispositivo.csv", index=False)
print(df.to_string())
print()

# ── 15. FUENTE MEDIO (archivo adicional) ──────────────────────
print("Limpiando fuente medio...")
df = leer_csv("Origen_de_la_vista_fuente_medio.csv")

df.columns = ["fuente_medio", "usuarios_activos", "sesiones",
              "sesiones_con_interaccion", "porcentaje_rebote", "duracion_media_seg"]

df["porcentaje_rebote"] = (df["porcentaje_rebote"] * 100).round(1)
df["duracion_media_seg"] = df["duracion_media_seg"].round(0)

df.to_csv("datos_limpios/fuente_medio.csv", index=False)
print(df.head(5).to_string())
print()

print("🎉 Todos los archivos limpiados y guardados en 'datos_limpios'")