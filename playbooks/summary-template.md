# Plantilla de resumen de unidad

## Propósito

Esta plantilla define el contenido obligatorio de:

```text
tutorial/NN-unit-name/summary.md
```

El resumen constituye el contrato de continuidad entre:

- la unidad completada;
- la siguiente unidad;
- futuras sesiones de IA;
- `project/project-state.md`;
- los artefactos ejecutables del repositorio.

No es un resumen pedagógico abreviado del tutorial. Debe describir de forma precisa el estado técnico y documental dejado por la unidad.

---

# Reglas de uso

El `summary.md` deberá:

- generarse al cerrar cada unidad;
- basarse en artefactos verificables;
- utilizar rutas exactas;
- diferenciar lo implementado de lo únicamente documentado;
- declarar validaciones ejecutadas y no ejecutadas;
- registrar limitaciones y deuda técnica;
- indicar qué debe reutilizar la siguiente unidad;
- ser comprensible sin acceder a la conversación donde se generó la unidad.

No deberá:

- anticipar capacidades no implementadas;
- repetir íntegramente el tutorial;
- sustituir a `project/project-state.md`;
- incluir decisiones relevantes que no estén reflejadas en los archivos correspondientes;
- afirmar que una prueba se ejecutó cuando solo se diseñó.

---

# Identificación de la unidad

## Unidad

```text
NN — Nombre de la unidad
```

## Identificador

```text
NN-unit-name
```

## Fase del roadmap

```text
Fase X — Nombre de la fase
```

## Estado

Seleccionar uno:

- Completada
- Completada con limitaciones
- Bloqueada
- Reabierta

## Fecha de cierre o actualización

```text
YYYY-MM-DD
```

---

# Resumen ejecutivo

Describir en un máximo de tres párrafos:

- qué capacidad se incorporó;
- cómo evolucionó la solución;
- cuál es el estado final;
- qué deja preparado para la siguiente unidad.

El resumen debe utilizar hechos concretos y evitar descripciones genéricas.

---

# Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| [objetivo] | Alcanzado/Parcial/No alcanzado | `[ruta, comando o resultado]` |

Los objetivos deben corresponder con el playbook específico de la unidad.

---

# Estado inicial utilizado

Describir el estado real desde el que comenzó la unidad.

## Plataforma

- [estado inicial].

## Aplicación

- [estado inicial].

## Automatización

- [estado inicial].

## Observabilidad

- [estado inicial].

## Seguridad

- [estado inicial].

Eliminar categorías no aplicables.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| [artefacto] | `[ruta]` | [uso] |

---

# Cambios introducidos

## Capacidades incorporadas

- [capacidad];
- [capacidad].

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| [componente] | `[ruta]` | [responsabilidad] |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| [componente] | `[ruta]` | [cambio] |

## Componentes retirados

| Componente | Motivo | Sustitución o migración |
|---|---|---|
| [componente] | [motivo] | [sustitución] |

Escribir `Ninguno` cuando una subsección no aplique.

---

# Estructura final de artefactos

Incluir únicamente los archivos y directorios relevantes creados o modificados por la unidad.

```text
tutorial/NN-unit-name/
├── README.md
├── instructor-notes.md
└── summary.md

labs/NN-unit-name/
└── ...
```

Para la Unidad 0 utilizar:

```text
platform/environment/
└── ...
```

No copiar el árbol completo del repositorio salvo que sea necesario para comprender el resultado.

---

# Estado técnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| [elemento] | [estado] | `[comando, ruta o resultado]` |

## Aplicación

| Elemento | Estado final | Evidencia |
|---|---|---|
| [elemento] | [estado] | `[comando, ruta o resultado]` |

## Automatización

| Elemento | Estado final | Evidencia |
|---|---|---|
| [elemento] | [estado] | `[comando, ruta o resultado]` |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| [elemento] | [estado] | `[comando, ruta o resultado]` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| [elemento] | [estado] | `[comando, ruta o resultado]` |

Eliminar categorías no aplicables.

---

# Inventario relevante

## Namespaces

| Namespace | Propósito | Creado en esta unidad |
|---|---|---|
| [namespace] | [propósito] | Sí/No |

## Workloads

| Recurso | Namespace | Ruta de definición | Estado esperado |
|---|---|---|---|
| [recurso] | [namespace] | `[ruta]` | [estado] |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Propósito |
|---|---|---|
| [servicio] | [URL, puerto o método] | [propósito] |

## Configuración y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| [elemento] | `[ruta o nombre]` | [placeholder, secreto local, etc.] |

## Herramientas y versiones

| Herramienta | Versión validada | Método de comprobación |
|---|---|---|
| [herramienta] | [versión] | `[comando]` |

Incluir solo inventario relevante para continuar el itinerario.

---

# Decisiones tomadas

## D-01 — [Título]

### Decisión

[decisión]

### Motivo

[justificación]

### Consecuencias

- [consecuencia];
- [consecuencia].

### Ámbito

Indicar uno:

- específica de la unidad;
- registrada también en arquitectura;
- registrada en roadmap;
- registrada en project-state.

Añadir tantas decisiones como sea necesario.

No dejar decisiones importantes exclusivamente en este resumen.

---

# Validaciones

## Validaciones ejecutadas

| Validación | Comando o procedimiento | Resultado observado |
|---|---|---|
| [validación] | `[comando]` | [resultado real] |

## Validaciones estáticas realizadas

| Validación | Método | Resultado |
|---|---|---|
| [validación] | [método] | [resultado] |

## Validaciones no ejecutadas

| Validación pendiente | Motivo | Responsable o momento |
|---|---|---|
| [validación] | [motivo] | [quién o cuándo] |

No utilizar expresiones ambiguas como “todo funciona correctamente” sin evidencias.

---

# Comandos operativos principales

Incluir los comandos mínimos que una sesión posterior necesitará para comprobar o utilizar el estado dejado.

## Comprobación

```bash
[comando]
```

## Operación

```bash
[comando]
```

## Diagnóstico

```bash
[comando]
```

## Recuperación

```bash
[comando]
```

No repetir todos los comandos del tutorial.

---

# Reutilización obligatoria

La siguiente unidad deberá reutilizar:

| Elemento | Ruta o referencia | Forma de reutilización |
|---|---|---|
| [elemento] | `[ruta]` | [extender, configurar, importar, etc.] |

## Elementos que no deben duplicarse

- [elemento];
- [elemento].

## Convenciones que deben conservarse

- [nombres];
- [labels];
- [estructura];
- [variables];
- [patrones].

---

# Dependencias incorporadas

| Dependencia | Tipo | Estado | Impacto futuro |
|---|---|---|---|
| [dependencia] | Técnica/Documental/Pedagógica | [estado] | [impacto] |

---

# Especificidades de plataforma

## Kubernetes estándar

- [comportamiento o artefacto portable].

## MicroK8s

- [configuración específica].

## AKS

- [consideración futura o no aplica].

## EKS

- [consideración futura o no aplica].

## Acoplamientos pendientes

| Acoplamiento | Impacto | Estrategia futura |
|---|---|---|
| [acoplamiento] | [impacto] | [estrategia] |

---

# Seguridad

## Controles incorporados

- [control].

## Datos sensibles

Describir cómo se trataron:

- secretos;
- credenciales;
- ficheros locales;
- placeholders;
- exclusiones de Git.

## Riesgos de seguridad pendientes

| Riesgo | Impacto | Tratamiento previsto |
|---|---|---|
| [riesgo] | [impacto] | [unidad o acción] |

---

# Limitaciones conocidas

| Limitación | Impacto | Motivo | Resolución prevista |
|---|---|---|---|
| [limitación] | [impacto] | [motivo] | [unidad o acción] |

Las limitaciones deben ser concretas y verificables.

---

# Deuda técnica

| Identificador | Deuda | Prioridad | Unidad o momento previsto |
|---|---|---|---|
| TD-NN-01 | [descripción] | Baja/Media/Alta | [momento] |

Escribir `Ninguna` cuando no exista deuda técnica identificada.

---

# Problemas encontrados y resolución

| Problema | Causa | Resolución | Impacto residual |
|---|---|---|---|
| [problema] | [causa] | [resolución] | [impacto] |

Esta sección registra incidencias relevantes, no cada error tipográfico corregido.

---

# Diferencias respecto al playbook

| Diferencia | Motivo | Aprobación o registro |
|---|---|---|
| [diferencia] | [motivo] | [documento o decisión] |

Escribir `Ninguna` si la unidad se generó conforme al playbook aprobado.

Una diferencia no autorizada impide marcar la unidad como completada.

---

# Estado de los entregables

| Entregable | Ruta | Estado |
|---|---|---|
| Tutorial | `tutorial/NN-unit-name/README.md` | Completo/Parcial/No creado |
| Instructor notes | `tutorial/NN-unit-name/instructor-notes.md` | Completo/Parcial/No creado |
| Summary | `tutorial/NN-unit-name/summary.md` | Completo/Parcial |
| Laboratorio | `[ruta]` | Completo/Parcial/No creado |
| Project state | `project/project-state.md` | Actualizado/Pendiente |

---

# Actualización de project-state

Confirmar qué apartados de `project/project-state.md` se actualizaron:

- [ ] resumen ejecutivo;
- [ ] fase actual;
- [ ] estado de unidades;
- [ ] inventario de artefactos;
- [ ] plataforma;
- [ ] herramientas y versiones;
- [ ] decisiones;
- [ ] riesgos;
- [ ] deuda técnica;
- [ ] historial de incrementos;
- [ ] siguiente incremento permitido.

## Cambios principales registrados

- [cambio];
- [cambio].

---

# Preparación de la siguiente unidad

## Siguiente unidad prevista

```text
NN — Nombre de la unidad
```

## Estado de entrada que puede asumir

- [estado verificable];
- [estado verificable].

## Archivos que deberá leer

Además de las fuentes obligatorias:

```text
[ruta]
[ruta]
```

## Artefactos que deberá modificar o extender

| Artefacto | Ruta | Cambio previsto |
|---|---|---|
| [artefacto] | `[ruta]` | [cambio] |

## Restricciones para la siguiente unidad

- no sustituir [componente];
- no cambiar [convención];
- no introducir [capacidad futura];
- conservar [estado].

## Cuestiones que deberá resolver

| Cuestión | Bloqueante | Contexto |
|---|---|---|
| [cuestión] | Sí/No | [contexto] |

---

# Criterio de continuidad

La siguiente unidad puede comenzar cuando:

- [ ] todos los entregables obligatorios estén presentes;
- [ ] `project/project-state.md` refleje el estado final;
- [ ] las validaciones bloqueantes hayan sido ejecutadas;
- [ ] no existan contradicciones abiertas;
- [ ] las dependencias necesarias estén disponibles;
- [ ] las limitaciones estén aceptadas o planificadas;
- [ ] el playbook de la siguiente unidad esté aprobado.

## Resultado

Seleccionar uno:

- La siguiente unidad puede comenzar.
- La siguiente unidad puede comenzar con limitaciones declaradas.
- La siguiente unidad permanece bloqueada.

## Motivo

[explicación concreta]

---

# Checklist de cierre

- [ ] los objetivos están evaluados;
- [ ] los artefactos creados y modificados están inventariados;
- [ ] el estado técnico final está descrito;
- [ ] las validaciones ejecutadas contienen resultados reales;
- [ ] las validaciones pendientes están declaradas;
- [ ] las decisiones relevantes están registradas;
- [ ] las limitaciones y deuda técnica están identificadas;
- [ ] la seguridad está documentada;
- [ ] la portabilidad está documentada;
- [ ] los entregables están completos;
- [ ] `project/project-state.md` está actualizado;
- [ ] la siguiente unidad sabe qué reutilizar;
- [ ] no existe información necesaria únicamente en el chat.

---

# Metadatos de mantenimiento

## Generado a partir de

```text
playbooks/units/NN-unit-name.md
```

## Última revisión

```text
YYYY-MM-DD
```

## Motivo de la última revisión

[descripción]
