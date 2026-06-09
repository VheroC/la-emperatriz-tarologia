import pandas as pd
from sqlalchemy import create_engine
import os

# ── CONEXIÓN A POSTGRESQL ─────────────────────────────────────

engine = create_engine("postgresql+psycopg2://postgres:"tu_password_aqui"@localhost:5432/emperatriz_tarologia")

# ── ARCHIVOS A CARGAR ─────────────────────────────────────────
archivos = {
    "trafico_canal":        "datos_limpios/trafico_canal.csv",
    "dispositivos":         "datos_limpios/dispositivos.csv",
    "usuarios_tipo":        "datos_limpios/usuarios_tipo.csv",
    "estacionalidad":       "datos_limpios/estacionalidad.csv",
    "origen_visita":        "datos_limpios/origen_visita.csv",
    "geografia_pais":       "datos_limpios/geografia_pais.csv",
    "geografia_ciudad":     "datos_limpios/geografia_ciudad.csv",
    "geografia_recurrentes":"datos_limpios/geografia_recurrentes.csv",
    "paginas_visitadas":    "datos_limpios/paginas_visitadas.csv",
    "clics_salientes":      "datos_limpios/clics_salientes.csv",
    "seo_consultas":        "datos_limpios/seo_consultas.csv",
    "seo_paginas":          "datos_limpios/seo_paginas.csv",
    "seo_pais":             "datos_limpios/seo_pais.csv",
    "seo_dispositivo":      "datos_limpios/seo_dispositivo.csv",
    "fuente_medio":         "datos_limpios/fuente_medio.csv",
}

# ── CARGAR CADA ARCHIVO ───────────────────────────────────────
for tabla, archivo in archivos.items():
    df = pd.read_csv(archivo)
    df.to_sql(tabla, engine, if_exists="replace", index=False)
    print(f"✅ {tabla} — {len(df)} filas cargadas")

print("\n🎉 Todos los datos cargados en PostgreSQL")
