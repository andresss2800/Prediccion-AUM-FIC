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
