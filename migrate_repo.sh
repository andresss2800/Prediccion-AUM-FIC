#!/bin/bash
# =====================================================
# Script de migración: Prediccion-AUM-FIC
# Ejecutar desde la RAÍZ del repositorio local
# =====================================================
set -e  # detener si cualquier comando falla

echo "================================================"
echo " MIGRACIÓN DE ESTRUCTURA - Prediccion-AUM-FIC"
echo "================================================"
echo ""

# ── 0. Verificar que estamos en la raíz del repo ──
if [ ! -f "README.md" ] || [ ! -d ".git" ]; then
  echo "ERROR: Ejecuta este script desde la raíz del repositorio."
  exit 1
fi

echo "[1/8] Creando estructura de carpetas..."
mkdir -p data/raw
mkdir -p data/processed
mkdir -p data/extended
mkdir -p notebooks/v1
mkdir -p notebooks/v2
mkdir -p notebooks/utils
mkdir -p src/data
mkdir -p src/features
mkdir -p src/models
mkdir -p results/metrics
mkdir -p results/figures
mkdir -p results/models
mkdir -p docs/thesis
mkdir -p docs/decisions
mkdir -p docs/setup
echo "      ✓ Carpetas creadas"

# ── 1. Mover fuentes de datos a data/raw/ ──
echo ""
echo "[2/8] Moviendo fuentes de datos a data/raw/..."
git mv "Fuentes de datos/AGREGADOS MONETARIOS.xlsx"              data/raw/AGREGADOS_MONETARIOS.xlsx
git mv "Fuentes de datos/AUM_FIC.zip"                            data/raw/AUM_FIC.zip
git mv "Fuentes de datos/COLTES.xlsx"                            data/raw/COLTES.xlsx
git mv "Fuentes de datos/HOMOLOGACION CATEGORÍAS.xlsx"           data/raw/HOMOLOGACION_CATEGORIAS.xlsx
git mv "Fuentes de datos/IPC.csv"                                data/raw/IPC.csv
git mv "Fuentes de datos/TASAS DE CAPTACION CDT BANCOS.xlsx"     data/raw/TASAS_CAPTACION_CDT.xlsx
git mv "Fuentes de datos/TASA_INTERES_POLITICA_MONETARIA.csv"    data/raw/TASA_INTERES_POLITICA_MONETARIA.csv
git mv "Fuentes de datos/TRM.csv"                                data/raw/TRM.csv
echo "      ✓ Fuentes de datos movidas"

# ── 2. Mover notebook de unificación a v1/ ──
echo ""
echo "[3/8] Moviendo notebook de unificación..."
git mv "Fuentes de datos/UNIFICAR DATASETS.ipynb"  notebooks/v1/02_data_unification.ipynb
echo "      ✓ Notebook de unificación movido"

# ── 3. Mover EDA a v1/ ──
echo ""
echo "[4/8] Moviendo EDA y modelos clásicos..."
git mv "Analisis Exploratorio/EDA Y MODELOS SARIMA.ipynb"      notebooks/v1/01_eda_sarima.ipynb
echo "      ✓ EDA movido"

# ── 4. Mover notebooks de modelado a v1/ ──
echo ""
echo "[5/8] Moviendo notebooks de modelado a notebooks/v1/..."
git mv "Modelado de Datos/MODELOS AUTOREGRESIVOS.ipynb"   notebooks/v1/03_autoregressive.ipynb
git mv "Modelado de Datos/SUAVIZADO EXPONENCIAL.ipynb"    notebooks/v1/05_exp_smoothing.ipynb
git mv "Modelado de Datos/LSTM.ipynb"                     notebooks/v1/06_lstm.ipynb
git mv "Modelado de Datos/LIGHTBM.ipynb"                  notebooks/v1/07_lightgbm.ipynb
git mv "Modelado de Datos/XGBOOST.ipynb"                  notebooks/v1/08_xgboost.ipynb
git mv "Modelado de Datos/PROPHET.ipynb"                  notebooks/v1/09_prophet.ipynb
git mv "Modelado de Datos/MODELO MEDIA MOVIL.ipynb"       notebooks/v1/10_moving_avg_baseline.ipynb
echo "      ✓ Notebooks de modelado movidos"

# ── 5. Eliminar carpetas vacías ──
echo ""
echo "[6/8] Eliminando carpetas vacías..."
rmdir "Analisis Exploratorio" 2>/dev/null || true
rmdir "Fuentes de datos"      2>/dev/null || true
rmdir "Modelado de Datos"     2>/dev/null || true
echo "      ✓ Carpetas antiguas eliminadas"

# ── 6. Crear archivos base ──
echo ""
echo "[7/8] Creando archivos base del proyecto..."

# .gitignore
cat > .gitignore << 'EOF'
# Datos grandes (no versionar, documentar en README cómo obtenerlos)
data/raw/*.zip
data/processed/*.csv
data/extended/*.csv

# Modelos serializados pesados
results/models/*.h5
results/models/*.pkl

# Entornos y credenciales
.env
*.env
__pycache__/
.ipynb_checkpoints/
*.pyc
.DS_Store

# Jupyter
.jupyter/

# VSCode
.vscode/
EOF

# CHANGELOG.md
cat > CHANGELOG.md << 'EOF'
# Changelog

## [Unreleased] — Fase 0: Correcciones metodológicas
- Pendiente: corrección data leakage en scaler LSTM
- Pendiente: unificación splits 80/10/10 en todos los modelos
- Pendiente: corrección bug RMSE/MAE en VAR
- Pendiente: corrección función predecir() sobreescrita
- Pendiente: ejecución SHAP en boosting
- Pendiente: validación estadística de lags en XGBoost/LightGBM
- Pendiente: semilla global en modelos boosting
- Pendiente: cross-validation temporal en Prophet

## [1.0.0] — 2025 — Fase original (2018–2024)
### Modelos evaluados
- ARIMA, ARIMAX, VAR, Suavizado Exponencial (Holt-Winters multiplicativo)
- LSTM univariado unistep, LSTM multivariado unistep (Efectivo + CDT)
- LightGBM univariado y multivariado
- XGBoost (configuración preliminar)
- Prophet univariado y multivariado (variable exógena: COLTES)
- Media Móvil (baseline)

### Mejor modelo
- LSTM multivariado: RMSE 7.7e+5, mejora 61% vs baseline

### Variables exógenas identificadas
- Efectivo (M1), CDT — correlación fuerte con AUM FIC
EOF

# requirements.txt base
cat > requirements.txt << 'EOF'
# Manipulación de datos
pandas>=2.0.0
numpy>=1.24.0
openpyxl>=3.1.0

# Series de tiempo y econometría
statsmodels>=0.14.0
pmdarima>=2.0.0
arch>=6.0.0

# Machine Learning
scikit-learn>=1.3.0
xgboost>=2.0.0
lightgbm>=4.0.0
catboost>=1.2.0
skforecast>=0.11.0

# Deep Learning
tensorflow>=2.13.0

# Prophet
prophet>=1.1.4

# Visualización
matplotlib>=3.7.0
seaborn>=0.12.0

# Interpretabilidad
shap>=0.43.0

# Entorno
python-dotenv>=1.0.0
jupyter>=1.0.0
EOF

# notebooks/utils/config.py
cat > notebooks/utils/config.py << 'EOF'
"""
config.py — Configuración global compartida entre todos los notebooks.
Importar al inicio de cada notebook: from utils.config import *
"""
import numpy as np
import random
import os

# ── Semilla global ──────────────────────────────────────
RANDOM_SEED = 42

def set_global_seed(seed: int = RANDOM_SEED):
    """Fijar semilla en numpy, random y TensorFlow si está disponible."""
    np.random.seed(seed)
    random.seed(seed)
    os.environ["PYTHONHASHSEED"] = str(seed)
    try:
        import tensorflow as tf
        tf.random.set_seed(seed)
    except ImportError:
        pass

# ── Rutas de datos ──────────────────────────────────────
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
DATA_RAW       = ROOT / "data" / "raw"
DATA_PROCESSED = ROOT / "data" / "processed"
DATA_EXTENDED  = ROOT / "data" / "extended"
RESULTS        = ROOT / "results"

# ── Splits ──────────────────────────────────────────────
TRAIN_SIZE = 0.80
VAL_SIZE   = 0.10
TEST_SIZE  = 0.10
EOF

# notebooks/utils/metrics.py
cat > notebooks/utils/metrics.py << 'EOF'
"""
metrics.py — Métricas de evaluación estandarizadas.
Uso: from utils.metrics import calculate_metrics
"""
import numpy as np
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

def calculate_metrics(y_true, y_pred, model_name: str = "") -> dict:
    """
    Calcula RMSE, MAE, MAPE y R² ajustado.
    Devuelve dict listo para construir tabla comparativa.
    """
    y_true = np.array(y_true)
    y_pred = np.array(y_pred)

    rmse = np.sqrt(mean_squared_error(y_true, y_pred))
    mae  = mean_absolute_error(y_true, y_pred)
    mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
    r2   = r2_score(y_true, y_pred)

    # R² ajustado requiere n y p; se calcula fuera si se necesita
    metrics = {
        "model":  model_name,
        "RMSE":   rmse,
        "MAE":    mae,
        "MAPE_%": round(mape, 4),
        "R2":     round(r2, 4),
    }

    if model_name:
        print(f"{'─'*40}")
        print(f"Modelo : {model_name}")
        print(f"RMSE   : {rmse:,.0f}")
        print(f"MAE    : {mae:,.0f}")
        print(f"MAPE   : {mape:.2f}%")
        print(f"R²     : {r2:.4f}")

    return metrics
EOF

# notebooks/utils/splitter.py
cat > notebooks/utils/splitter.py << 'EOF'
"""
splitter.py — Split temporal estandarizado 80/10/10.
Un solo lugar para cambiar la proporción en todo el proyecto.
"""
import numpy as np

def train_val_test_split(serie, train=0.80, val=0.10, test=0.10):
    """
    Divide una serie temporal manteniendo el orden cronológico.
    Retorna (train, val, test) como arrays de numpy.
    """
    assert abs(train + val + test - 1.0) < 1e-9, "Los splits deben sumar 1.0"
    N      = len(serie)
    n_tr   = int(train * N)
    n_val  = int(val   * N)
    return serie[:n_tr], serie[n_tr:n_tr+n_val], serie[n_tr+n_val:]
EOF

# docs/decisions/001_split_strategy.md
cat > docs/decisions/001_split_strategy.md << 'EOF'
# ADR-001: Estrategia unificada de splits temporales

**Fecha:** 2025  
**Estado:** Aprobado  

## Contexto
La versión 1 del proyecto usó proporciones inconsistentes entre modelos
(90/10 en algunos, 80/10/10 en otros), lo que invalida las comparaciones.

## Decisión
Todos los modelos en v2 usan 80% train / 10% validación / 10% test
implementado a través de `notebooks/utils/splitter.py`.

## Consecuencias
- Los resultados de v1 y v2 **no son directamente comparables** en splits.
- La tabla comparativa final debe indicar la versión del split usado.
EOF

echo "      ✓ Archivos base creados"

# ── 7. Commit ──
echo ""
echo "[8/8] Haciendo commit de la migración..."
git add -A
git status --short
echo ""
echo "================================================"
echo " Todo listo para hacer commit."
echo ""
echo " Ejecuta el siguiente comando para confirmar:"
echo ""
echo "   git commit -m 'refactor: reorganizar estructura del repositorio'"
echo "   git push origin main"
echo ""
echo " O para crear la rama de fase 0 antes:"
echo ""
echo "   git checkout -b phase/0-fixes"
echo "   git commit -m 'refactor: reorganizar estructura del repositorio'"
echo "   git push -u origin phase/0-fixes"
echo "================================================"
