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
