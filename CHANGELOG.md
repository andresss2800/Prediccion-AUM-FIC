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
