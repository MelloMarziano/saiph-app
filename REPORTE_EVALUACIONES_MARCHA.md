# Reporte de Evaluaciones de Marcha (Ejemplos)

Este documento muestra ejemplos de cómo estructurar y presentar los datos de evaluaciones de marcha para:
- Identificar quién realizó cada evaluación
- Resumir resultados por pelotón
- Desglosar las exhibiciones y métricas registradas
- Exportar a CSV para Excel o ver como tabla

## Campos clave para identificar al evaluador
- `evaluadorNombre` y `evaluadorEmail`: identidad principal del evaluador
- `coEvaluadores`: lista con hasta 2 co‑evaluadores (nombre o email)
- `docId`: `pelotonId + '_' + (evaluadorEmail || evaluadorNombre)`
- Referencia: `lib/screens/marcha/evaluacion_screen.dart:814-827` (identidad) y `lib/screens/marcha/evaluacion_screen.dart:819` (payload)

## Estructura del documento (Firestore: `evaluaciones_marcha`)
```json
{
  "pelotonId": "PEL-001",
  "pelotonNombre": "Leones del Norte",
  "instructor": "Juan Pérez",
  "tipoMarcha": "MILITARY",
  "cantidadMiembros": 25,
  "evaluadorNombre": "Ana Gómez",
  "evaluadorEmail": "ana@example.com",
  "coEvaluadores": ["Carlos Mello", "maria@example.com"],
  "items": [
    { "name": "Instructor", "value": 12, "max": 12, "comment": "Muy claro" },
    { "name": "Reglamentaria", "value": 10, "max": 10, "comment": "Cumple" }
  ],
  "exhibiciones": [
    { "type": "FS", "index": 1, "pliegueRepliegue": 2, "deformaciones": 1, "maxPorExhibicion": 4,
      "comment": "Buena presencia", "commentPliegueRepliegue": "Correcto", "commentDeformaciones": "Leve" },
    { "type": "FI", "index": 1, "originalidad": 2, "ejecucion": 2, "composicion": 2, "maxPorExhibicion": 6,
      "comment": "Innovación equilibrada", "commentOriginalidad": "Creativo", "commentEjecucion": "Preciso", "commentComposicion": "Ordenado" }
  ],
  "totalParcial": 132,
  "faltasGenerales": ["Uso de celular"],
  "faltasEstiloFancy": [],
  "faltasEstiloMilitary": ["Paso fuera de tiempo"],
  "faltasEstiloSilent": [],
  "faltasEstiloSoundtrack": [],
  "descalificadoPorFaltasGenerales": false,
  "createdAt": "2025-11-21T18:45:13Z"
}
```

## Ejemplo CSV (para Excel)
```csv
Peloton,Instructor,Tipo,Miembros,Total,Evaluador,Email,CoEvaluadores,Fecha
Leones del Norte,Juan Pérez,MILITARY,25,132,Ana Gómez,ana@example.com,"Carlos Mello; maria@example.com",2025-11-21T18:45:13Z
Centinelas del Sur,Carmen Rivas,SOUNDTRACK,18,145,Carlos Mello,carlos@example.com,,2025-11-21T19:02:48Z
Halcones,Fernando Díaz,FANCY,22,128,María Luisa,maria@example.com,"Luis Pérez",2025-11-20T16:20:04Z
```

## Grid de resumen por evaluación
| Pelotón           | Instructor     | Tipo       | Miembros | Total | Evaluador     | Email             | Co‑evaluadores                         | Fecha                |
|-------------------|----------------|------------|----------|-------|---------------|-------------------|----------------------------------------|----------------------|
| Leones del Norte  | Juan Pérez     | MILITARY   | 25       | 132   | Ana Gómez     | ana@example.com   | Carlos Mello; maria@example.com        | 2025-11-21 18:45:13 |
| Centinelas del Sur| Carmen Rivas   | SOUNDTRACK | 18       | 145   | Carlos Mello  | carlos@example.com|                                        | 2025-11-21 19:02:48 |
| Halcones          | Fernando Díaz  | FANCY      | 22       | 128   | María Luisa   | maria@example.com | Luis Pérez                             | 2025-11-20 16:20:04 |

## Grid: Criterios generales (items)
| Ítem            | Valor | Máximo | Comentario   |
|-----------------|-------|--------|--------------|
| Instructor      | 12    | 12     | Muy claro    |
| Reglamentaria   | 10    | 10     | Cumple       |
| Participación   | 8     | 10     | Buena energía|

## Grid: Exhibiciones FS (Fancy/Soundtrack)
| # | Pliegue/Repliegue | Deformaciones | Máx. | Comentario     | Comentario (Pliegue) | Comentario (Deformaciones) |
|---|-------------------|---------------|------|----------------|----------------------|-----------------------------|
| 1 | 2                 | 1             | 4    | Buena presencia| Correcto             | Leve                        |
| 2 | 1                 | 0             | 4    | Buena línea    | Correcto             | Sin deformaciones          |

## Grid: Exhibiciones MS (Military/Silent)
| # | Pliegue/Repliegue | Creatividad | Máx. | Comentario          | Comentario (Pliegue) | Comentario (Creatividad) |
|---|-------------------|------------|------|---------------------|----------------------|---------------------------|
| 1 | 2                 | 3          | 6    | Creativo en silencio| Firme                | Variedad                  |

## Grid: Innovación FI (Fancy)
| # | Originalidad | Ejecución | Composición | Máx. | Comentario            | C. Originalidad | C. Ejecución | C. Composición |
|---|--------------|-----------|-------------|------|-----------------------|-----------------|-------------|----------------|
| 1 | 2            | 2         | 2           | 6    | Innovación equilibrada| Creativo        | Preciso      | Ordenado       |

## Grid: Innovación MI (Military)
| # | Originalidad | Plenas | Cadencias | Intervalos | ContraMarcha | Máx. | Comentario | C. Originalidad | C. Plenas | C. Cadencias | C. Intervalos | C. ContraMarcha |
|---|--------------|--------|----------|-----------|--------------|------|------------|------------------|-----------|--------------|---------------|------------------|
| 1 | 2            | 2      | 2        | 2         | 2            | 10   | Completa   | Creativo         | Buenas    | Precisas     | Correctas     | Bien ejecutada  |

## Grid: Grado de dificultad FD/MD/SD/TD
FD (Fancy) / TD (Soundtrack)
| # | Pasos dif. tiempos | Grado dif. deformación | Máx. | Comentario | C. Pasos dif. | C. Grado dif. |
|---|--------------------|------------------------|------|------------|---------------|---------------|
| 1 | 3                  | 2                      | 6    | Retador    | Buen control  | Poca deform.  |

MD (Military) / SD (Silent)
| # | Grado de dificultad | Máx. | Comentario |
|---|---------------------|------|------------|
| 1 | 1                   | 1    | Base       |

## Grid: Impacto del juez FJ/TJ
| # | Impacto | Máx. | Comentario |
|---|---------|------|------------|
| 1 | 2       | 2    | Notorio    |

## Grid: Precisión FP/MP/SP/TP
| # | Precisión | Máx. | Comentario |
|---|-----------|------|------------|
| 1 | 5         | 5    | Excelente  |

## Grid: Sincronización TS (Soundtrack)
| # | Sincronización | Máx. | Comentario |
|---|----------------|------|------------|
| 1 | 4              | 4    | Muy bien   |

## Desglose por exhibiciones (abreviaturas)
- Las abreviaturas y su significado están documentadas en `ABREVIATURAS_MARCHA.md`.
- A continuación, cómo se ven algunas entradas del arreglo `exhibiciones`:

```json
[
  { "type": "FS", "index": 2, "pliegueRepliegue": 1, "deformaciones": 0, "maxPorExhibicion": 4,
    "comment": "Buena línea", "commentPliegueRepliegue": "Correcto", "commentDeformaciones": "Sin deformaciones" },
  { "type": "MS", "index": 1, "pliegueRepliegue": 2, "creatividad": 3, "maxPorExhibicion": 6,
    "comment": "Creativo en silencio", "commentPliegueRepliegue": "Firme", "commentCreatividad": "Variedad" },
  { "type": "FI", "index": 1, "originalidad": 2, "ejecucion": 2, "composicion": 2, "maxPorExhibicion": 6 },
  { "type": "FD", "index": 1, "pasosDiferentesTiempos": 3, "gradoDificultadDeformacion": 2, "maxPorExhibicion": 6 },
  { "type": "FP", "index": 1, "precision": 5, "maxPorExhibicion": 5 },
  { "type": "TS", "index": 1, "sincronizacion": 4, "maxPorExhibicion": 4 }
]
```

Campos por tipo:
- `FS` (Exhibición Fancy/Soundtrack): `pliegueRepliegue`, `deformaciones`
- `MS` (Exhibición Military/Silent): `pliegueRepliegue`, `creatividad`
- `FI`/`MI`/`SI`/`SO` (Innovación): combinaciones de `originalidad`, `ejecucion`, `composicion`, `plenas`, `cadenciasNumericas`, `intervalos`, `contraMarcha`, etc.
- `FD`/`MD`/`SD`/`TD` (Grado de dificultad): `pasosDiferentesTiempos`, `gradoDificultadDeformacion` o `gradoDificultad`
- `FJ`/`TJ` (Impacto del juez): `impactoJuez`
- `FP`/`MP`/`SP`/`TP` (Precisión): `precision`
- `TS` (Sincronización música Soundtrack): `sincronizacion`

## Cálculo del total y comentarios
- `totalParcial` suma los valores de `items` y de cada exhibición, restando las faltas seleccionadas.
- `items[].comment` y `exhibiciones[].comment*` registran los comentarios específicos por punto.
- Referencia: cálculo `lib/screens/marcha/evaluacion_screen.dart:916-923`, comentarios en payload `lib/screens/marcha/evaluacion_screen.dart:827-915`.

## Dónde se guardan y cómo se evitan duplicados
- Colección Firestore: `evaluaciones_marcha`
- Escritura transaccional para evitar duplicados por pelotón/evaluador: `lib/screens/marcha/evaluacion_screen.dart:748-930`
- `docId` único por combinación pelotón-evaluador: `lib/screens/marcha/evaluacion_screen.dart:741`

## Notas
- Si no hay conexión, la evaluación se guarda localmente en una cola (`GetStorage` bajo `pending_sync_evaluaciones`) y se sincroniza más tarde.
- Confirmaciones y mensajes de éxito/duplicado usan `CoolAlert`: botn guardar `lib/screens/marcha/evaluacion_screen.dart:703-716`, y resultados `lib/screens/marcha/evaluacion_screen.dart:1053-1069`.