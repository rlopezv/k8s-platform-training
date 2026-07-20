# Plantilla de estado del proyecto

## Propósito

Esta plantilla define la estructura, las reglas y los criterios de actualización de:

```text
project/project-state.md
```

El estado del proyecto debe representar exclusivamente hechos actuales, consolidados y verificables del repositorio y del laboratorio.

Su función es permitir que una nueva sesión determine con precisión:

- la fase activa;
- el último incremento completado;
- la unidad actual;
- los artefactos existentes;
- los componentes desplegados;
- las herramientas y versiones disponibles;
- las decisiones vigentes;
- los riesgos y la deuda técnica;
- el siguiente incremento permitido.

`project/project-state.md` no es:

- un roadmap;
- un changelog exhaustivo;
- un resumen de conversación;
- una lista de deseos;
- un inventario de capacidades futuras;
- un sustituto de los resúmenes de unidad.

---

# Reglas fundamentales

## Estado real, no previsto

Solo deben registrarse elementos que:

- existan en el repositorio;
- hayan sido desplegados y validados;
- estén documentados como disponibles;
- representen una decisión aprobada y vigente;
- correspondan con el estado dejado por el último incremento cerrado.

No se deben registrar como implementados:

- archivos aún no creados;
- herramientas previstas;
- componentes pendientes de instalación;
- validaciones no ejecutadas;
- unidades planificadas;
- decisiones propuestas pero no aprobadas.

## Evidencia verificable

Siempre que sea posible, cada estado técnico deberá poder relacionarse con:

- una ruta del repositorio;
- un comando de comprobación;
- un resultado observado;
- una versión;
- una decisión documentada.

## Actualización atómica

Cada incremento que cambie el estado real deberá actualizar `project/project-state.md` dentro del mismo commit lógico.

No se debe cerrar una unidad dejando el estado pendiente para una sesión posterior.

## Coherencia documental

El estado no debe contradecir:

- `project/architecture.md`;
- `project/roadmap.md`;
- `playbooks/master.md`;
- el último `summary.md`;
- los artefactos ejecutables.

Cuando exista una contradicción, prevalecerá la evidencia real, pero deberá corregirse el documento inconsistente antes de continuar.

---

# Cuándo actualizar project-state

Actualizar obligatoriamente:

- al completar un incremento del bootstrap;
- al iniciar formalmente una unidad;
- al completar una unidad;
- al bloquear o reabrir una unidad;
- al crear, retirar o sustituir un artefacto relevante;
- al instalar o actualizar una herramienta;
- al desplegar o retirar un componente;
- al cambiar una versión activa;
- al adoptar, revocar o sustituir una decisión;
- al identificar o resolver un riesgo;
- al crear o resolver deuda técnica;
- al cambiar el siguiente incremento permitido.

No es necesario actualizarlo por:

- correcciones ortográficas;
- cambios editoriales sin impacto técnico;
- reformateo;
- comentarios internos;
- cambios que no alteren el estado verificable.

---

# Estructura obligatoria

## 1. Propósito

Mantener una introducción breve que explique que el documento contiene el estado actual y verificable.

## 2. Resumen ejecutivo

Utilizar una tabla equivalente a:

| Campo | Estado |
|---|---|
| Fase actual | [fase] |
| Estado general | [estado] |
| Último incremento completado | [incremento] |
| Unidad activa | [unidad o ninguna] |
| Última unidad completada | [unidad o ninguna] |
| Laboratorio disponible | Sí/No/Parcial |
| Plataforma local desplegada | Sí/No/Parcial |
| Contenido formativo generado | Sí/No/Parcial |
| Siguiente incremento permitido | `[ruta o acción]` |

### Valores recomendados para estado general

- Bootstrap en progreso
- Preparado para iniciar unidad
- Unidad en progreso
- Unidad bloqueada
- Unidad completada
- Revisión en progreso
- Itinerario completado

Evitar valores ambiguos como “bien”, “avanzado” o “casi terminado”.

---

# Fase actual

Describir:

- fase activa;
- objetivo de la fase;
- qué trabajo está permitido;
- qué trabajo está prohibido;
- condición de salida.

Ejemplo:

```markdown
# Fase actual

El proyecto se encuentra en la fase **Plataforma local**.

Durante esta fase se permite:

- generar la Unidad 00;
- crear artefactos en `platform/environment/`;
- validar MicroK8s sobre WSL2.

No se permite:

- generar la Unidad 01;
- desplegar la aplicación evolutiva;
- introducir Argo CD o Tekton.
```

---

# Estado de artefactos

## Artefactos de gobierno

Utilizar una tabla:

| Artefacto | Estado | Última modificación relevante | Responsabilidad |
|---|---|---|---|
| `README.md` | Completo/Parcial/Pendiente | [unidad o incremento] | [responsabilidad] |

## Artefactos por unidad

| Unidad | Tutorial | Student notes | Student reference | Laboratorio | Instructor notes | Summary | Estado |
|---|---|---|---|---|---|---|---|
| NN — Nombre | Sí/No/Parcial | Sí/No/Parcial | Sí/No/No aplica | Sí/No/Parcial | Sí/No/Parcial | Sí/No/Parcial | [estado] |

## Artefactos principales existentes

Incluir únicamente rutas relevantes para continuar:

```text
[ruta]
[ruta]
```

No copiar el árbol completo del repositorio si no aporta información operativa.

---

# Estado de las unidades

Para cada unidad iniciada o completada registrar:

## Unidad NN — Nombre

| Campo | Estado |
|---|---|
| Estado | No iniciada/En progreso/Bloqueada/Completada/Reabierta |
| Fecha de inicio | YYYY-MM-DD o No aplica |
| Fecha de cierre | YYYY-MM-DD o No aplica |
| Playbook | `[ruta]` |
| Tutorial | `[ruta]` |
| Student notes | `[ruta]` |
| Laboratorio | `[ruta]` |
| Instructor notes | `[ruta]` |
| Summary | `[ruta]` |

### Capacidades incorporadas

- [capacidad].

### Limitaciones activas

- [limitación].

Las unidades futuras pueden aparecer en una tabla resumida, pero nunca como implementadas.

---

# Estado del laboratorio

## Host

| Componente | Estado | Versión o detalle | Evidencia |
|---|---|---|---|
| Windows | [estado] | [versión] | [método] |
| WSL2 | [estado] | [detalle] | `[comando]` |
| Ubuntu | [estado] | [versión] | `[comando]` |

## Plataforma Kubernetes

| Componente | Estado | Versión | Evidencia |
|---|---|---|---|
| MicroK8s | [estado] | [versión] | `[comando]` |
| Kubernetes | [estado] | [versión] | `[comando]` |
| Clúster | [estado] | [detalle] | `[comando]` |

## Addons

| Addon | Estado | Configuración relevante |
|---|---|---|
| [addon] | Habilitado/Deshabilitado/No instalado | [detalle] |

## Namespaces

| Namespace | Estado | Propósito | Definición |
|---|---|---|---|
| [namespace] | [estado] | [propósito] | `[ruta o creación manual documentada]` |

## Workloads

| Recurso | Namespace | Estado esperado | Definición |
|---|---|---|---|
| [recurso] | [namespace] | [estado] | `[ruta]` |

## Endpoints

| Servicio | Acceso | Estado | Propósito |
|---|---|---|---|
| [servicio] | [URL, host o puerto] | [estado] | [propósito] |

Eliminar subsecciones que todavía no apliquen, salvo durante bootstrap cuando sea útil declarar explícitamente que no existen.

---

# Herramientas y versiones

| Herramienta | Estado | Versión activa | Método de comprobación | Incorporada en |
|---|---|---|---|---|
| Helm | Disponible/No disponible/Parcial | [versión] | `[comando]` | [unidad] |
| Terraform | [estado] | [versión] | `[comando]` | [unidad] |

Reglas:

- no asumir una herramienta por estar prevista en el roadmap;
- registrar la versión observada, no solo la deseada;
- diferenciar instalación local de componente desplegado;
- indicar versiones pendientes de fijar.

---

# Estado de la aplicación evolutiva

## Identificación

| Campo | Valor |
|---|---|
| Nombre | [nombre] |
| Propósito | [propósito] |
| Versión actual | [versión o referencia] |
| Repositorio o ruta | `[ruta]` |

## Componentes

| Componente | Estado | Imagen o versión | Definición |
|---|---|---|---|
| [componente] | [estado] | [imagen] | `[ruta]` |

## Capacidades activas

- [capacidad].

## Capacidades todavía no incorporadas

Puede incluirse una referencia breve al roadmap, pero no una lista extensa.

Esta sección no debe existir hasta que la aplicación haya sido formalmente definida.

---

# Estado de automatización

## Helm

- charts existentes;
- releases activas;
- valores por entorno;
- comandos principales.

## Terraform

- módulos existentes;
- backend;
- workspaces o entornos;
- recursos gestionados.

## Tekton

- pipelines;
- tasks;
- triggers;
- estado de ejecución.

## Argo CD

- applications;
- projects;
- repositorios;
- estado de sincronización.

Incluir únicamente subsecciones aplicables.

---

# Estado de observabilidad

## Métricas

- componentes;
- targets;
- reglas;
- dashboards.

## Logs

- componentes;
- fuentes;
- retención;
- consultas principales.

## Trazas

- collector;
- backend;
- instrumentación;
- propagación.

## Alertas

- reglas;
- receptores;
- estado.

No registrar un stack previsto como si estuviera desplegado.

---

# Estado de seguridad

Registrar controles activos:

| Control | Estado | Ámbito | Evidencia |
|---|---|---|---|
| RBAC | [estado] | [ámbito] | `[ruta o comando]` |
| NetworkPolicy | [estado] | [ámbito] | `[ruta]` |

## Secretos y credenciales

Indicar:

- mecanismo usado;
- rutas ignoradas;
- placeholders;
- gestores externos;
- riesgos pendientes.

Nunca incluir valores sensibles.

---

# Plataformas gestionadas

## AKS

| Campo | Estado |
|---|---|
| Estado | No iniciado/Provisionado/Operativo/Retirado |
| Región | [región] |
| Terraform | `[ruta]` |
| Clúster | [referencia no sensible] |
| Validación | `[comando o evidencia]` |
| Coste residual posible | [detalle] |

## EKS

Utilizar la misma estructura.

No incluir esta sección con datos ficticios.

---

# Decisiones activas

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| ADR-NNN — Título | Activa/Sustituida/Revocada | `[ruta]` | [impacto] |

## Decisiones específicas de unidad

Registrar únicamente decisiones que afecten a unidades posteriores.

No duplicar toda la sección de decisiones de cada summary.

---

# Restricciones activas

Incluir restricciones que condicionen el siguiente trabajo:

- [restricción];
- [restricción].

Ejemplos:

- no iniciar una unidad posterior;
- no cambiar una convención;
- no eliminar un artefacto;
- no asumir credenciales cloud;
- no modificar un componente hasta completar una migración.

Eliminar restricciones resueltas.

---

# Riesgos y cuestiones abiertas

## Riesgos

| ID | Riesgo | Probabilidad | Impacto | Mitigación | Estado |
|---|---|---|---|---|---|
| R-NNN | [riesgo] | Baja/Media/Alta | Bajo/Medio/Alto | [mitigación] | Abierto/Mitigado/Cerrado |

## Cuestiones abiertas

| ID | Cuestión | Bloqueante | Resolución prevista | Estado |
|---|---|---|---|---|
| Q-NNN | [cuestión] | Sí/No | [unidad o incremento] | Abierta/Cerrada |

Reglas:

- conservar identificadores estables;
- no reutilizar IDs;
- cerrar explícitamente elementos resueltos;
- eliminar del estado activo los detalles históricos innecesarios.

---

# Deuda técnica

| ID | Descripción | Prioridad | Origen | Resolución prevista | Estado |
|---|---|---|---|---|---|
| TD-NNN | [deuda] | Baja/Media/Alta | [unidad] | [unidad o acción] | Abierta/En progreso/Cerrada |

La deuda técnica debe representar trabajo necesario, no ideas opcionales.

## Lagunas de contenido

Cuando exista `project/content-gap-register.md`, registrar su estado de forma compacta:

| Registro | Estado | Siguiente acción |
|---|---|---|
| `project/content-gap-register.md` | [estado] | [acción] |

---

# Validaciones globales disponibles

Registrar comprobaciones que permitan validar rápidamente el estado general:

| Validación | Comando o procedimiento | Resultado esperado |
|---|---|---|
| Estado del clúster | `[comando]` | [resultado] |
| Estado de la aplicación | `[comando]` | [resultado] |

Solo incluir comandos vigentes.

---

# Historial de incrementos

Mantener un historial compacto:

| Orden | Incremento | Estado | Resultado |
|---|---|---|---|
| N | `[archivo o unidad]` | Completado/Bloqueado | [resultado breve] |

Este historial:

- no sustituye al historial Git;
- no debe detallar cada archivo secundario;
- debe permitir reconstruir la secuencia lógica;
- puede compactarse por fases cuando crezca.

---

# Siguiente incremento permitido

Esta sección es obligatoria.

Debe indicar una única acción principal:

```text
[ruta, unidad o revisión]
```

## Precondiciones

- [precondición].

## Trabajo permitido

- [acción].

## Trabajo todavía prohibido

- [acción].

El siguiente incremento debe ser coherente con:

- roadmap;
- dependencias;
- estado de la unidad anterior;
- restricciones activas.

---

# Procedimiento de actualización

## Al iniciar una unidad

Actualizar:

- fase actual;
- estado general;
- unidad activa;
- fecha de inicio;
- siguiente incremento;
- restricciones temporales.

No marcar capacidades como disponibles.

## Al completar una unidad

Actualizar:

- última unidad completada;
- artefactos;
- laboratorio;
- herramientas;
- versiones;
- componentes desplegados;
- decisiones;
- riesgos;
- deuda;
- historial;
- siguiente incremento.

## Al bloquear una unidad

Actualizar:

- estado general;
- unidad activa;
- causa;
- riesgo o cuestión bloqueante;
- trabajo permitido para desbloquear;
- siguiente incremento.

## Al reabrir una unidad

Actualizar:

- estado de la unidad;
- motivo;
- artefactos afectados;
- unidades posteriores potencialmente impactadas;
- restricciones.

---

# Reglas de redacción

## Usar lenguaje verificable

Preferir:

```text
MicroK8s no ha sido instalado por los artefactos del repositorio.
```

Evitar:

```text
MicroK8s probablemente todavía no está listo.
```

## Diferenciar estados

Usar de forma consistente:

- Previsto: aparece en roadmap, no implementado.
- Pendiente: trabajo requerido todavía no realizado.
- Parcial: existe una parte verificable, falta otra.
- Disponible: instalado o accesible y validado.
- Operativo: funciona según validación funcional.
- Completado: cumple criterios de salida.
- Bloqueado: no puede continuar por una condición explícita.

## Utilizar fechas absolutas

Formato:

```text
YYYY-MM-DD
```

## Utilizar rutas exactas

Preferir:

```text
tutorial/01-kubernetes-foundations/summary.md
```

Evitar:

```text
el resumen anterior
```

---

# Errores que deben evitarse

- copiar el roadmap completo dentro del estado;
- registrar herramientas previstas como instaladas;
- mantener como abierto un riesgo ya resuelto;
- omitir una validación pendiente;
- incluir credenciales;
- usar estados ambiguos;
- mantener información únicamente histórica sin impacto actual;
- declarar un laboratorio completo cuando faltan entregables;
- permitir más de un “siguiente incremento” principal;
- actualizar el estado sin actualizar el summary correspondiente;
- afirmar que el entorno fue validado cuando la validación no se ejecutó.

---

# Checklist de actualización

Antes de cerrar un incremento:

- [ ] el resumen ejecutivo refleja el estado actual;
- [ ] la fase y la unidad activa son correctas;
- [ ] los artefactos existentes están inventariados;
- [ ] no aparecen artefactos futuros como implementados;
- [ ] las herramientas y versiones tienen evidencia;
- [ ] los componentes desplegados coinciden con el laboratorio;
- [ ] las decisiones activas están vigentes;
- [ ] los riesgos y cuestiones están actualizados;
- [ ] la deuda técnica está actualizada;
- [ ] las validaciones pendientes están declaradas;
- [ ] el historial incluye el incremento;
- [ ] existe un único siguiente incremento permitido;
- [ ] las restricciones son coherentes;
- [ ] no hay información sensible;
- [ ] no se depende del contexto de conversación.

---

# Esqueleto mínimo

El siguiente esquema puede utilizarse para inicializar o reconstruir `project/project-state.md`:

```markdown
# Estado del proyecto

## Propósito

[descripción]

# Resumen ejecutivo

| Campo | Estado |
|---|---|
| Fase actual | [fase] |
| Estado general | [estado] |
| Último incremento completado | [incremento] |
| Unidad activa | [unidad] |
| Última unidad completada | [unidad] |
| Laboratorio disponible | [estado] |
| Plataforma local desplegada | [estado] |
| Contenido formativo generado | [estado] |
| Siguiente incremento permitido | `[acción]` |

# Fase actual

[descripción]

# Estado de artefactos

[inventario]

# Estado de las unidades

[estado]

# Estado del laboratorio

[estado]

# Herramientas y versiones

[inventario]

# Decisiones activas

[decisiones]

# Restricciones activas

[restricciones]

# Riesgos y cuestiones abiertas

[riesgos]

# Deuda técnica

[deuda]

# Historial de incrementos

[historial]

# Siguiente incremento permitido

[acción y precondiciones]
```

Las secciones adicionales se incorporarán únicamente cuando existan componentes reales que las requieran.

---

# Metadatos de mantenimiento

## Documento gobernado

```text
project/project-state.md
```

## Última revisión de la plantilla

```text
YYYY-MM-DD
```

## Motivo de la última revisión

[descripción]
