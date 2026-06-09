import pandas as pd

# Archivos que queremos revisar en detalle
archivos_revisar = [
    "Trafico_por_canal.csv",
    "dispositivos.csv",
    "estacionalidad.csv",
    "usuarios_nuevos_vs_recurrentes.csv",
]

for archivo in archivos_revisar:
    try:
        df = pd.read_csv(archivo, encoding="utf-8-sig")
    except:
        df = pd.read_csv(archivo, encoding="utf-8-sig", skiprows=9)

    print(f"\n{'='*60}")
    print(f"ARCHIVO: {archivo}")
    print(f"{'='*60}")
    print(df.to_string())