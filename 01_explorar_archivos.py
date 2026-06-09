import os
import pandas as pd

carpeta = "."

archivos = [f for f in os.listdir(carpeta) if f.endswith(".csv")]

print(f"Encontré {len(archivos)} archivos CSV:\n")

for archivo in sorted(archivos):
    ruta = os.path.join(carpeta, archivo)
    try:
        # Intento 1: lectura normal
        df = pd.read_csv(ruta, encoding="utf-8-sig")
    except:
        try:
            # Intento 2: saltear filas del encabezado del sistema
            df = pd.read_csv(ruta, encoding="utf-8-sig", skiprows=9)
        except:
            print(f"❌ {archivo} — no se pudo leer")
            continue

    print(f"✅ {archivo}")
    print(f"   Filas: {len(df)}  |  Columnas: {len(df.columns)}")
    print(f"   Columnas: {list(df.columns)}")
    print()