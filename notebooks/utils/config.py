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
