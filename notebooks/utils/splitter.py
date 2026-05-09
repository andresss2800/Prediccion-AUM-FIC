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
