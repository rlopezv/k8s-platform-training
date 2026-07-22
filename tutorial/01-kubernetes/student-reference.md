# Referencia del alumno - Unidad 01

## Propósito de la referencia

Esta referencia amplía `tutorial/01-kubernetes/student-notes.md` con un mapa general de workloads en Kubernetes.

La Unidad 01 practica `Deployment` porque es la forma más común de empezar a operar una aplicación HTTP replicada y sin identidad estable. Pero Kubernetes no tiene un único modo de ejecutar trabajo. Tiene varias APIs que crean y mantienen Pods con contratos distintos.

La idea importante es esta:

```text
Deployment no significa "la forma de ejecutar cosas en Kubernetes".
Deployment significa "mantener Pods equivalentes para un servicio replicado".
```

Esta referencia no cambia el laboratorio de Unidad 01. No crea `StatefulSet`, `Job`, `CronJob` ni `DaemonSet`. Su función es que puedas situar esas APIs cuando aparezcan en unidades posteriores.

## Relación con la unidad

En el laboratorio de Unidad 01 se declara:

```text
labs/01-kubernetes/solution/deployment.yaml
```

Ese manifiesto crea un `Deployment` llamado `platform-api`. Kubernetes usa ese `Deployment` para crear un `ReplicaSet`, y el `ReplicaSet` crea los Pods reales.

La Unidad 01 se concentra en esa cadena:

```text
Deployment -> ReplicaSet -> Pod
```

Esta referencia abre el mapa:

```text
Controladores de workload -> Pods
```

Un controlador de workload es una API que describe cómo deben existir los Pods: si deben ser reemplazables, tener identidad estable, ejecutarse una vez, repetirse en un calendario o existir en cada nodo.

## Mapa conceptual

Kubernetes ejecuta aplicaciones mediante Pods, pero rara vez se gestionan Pods sueltos en producción. Lo habitual es usar un controlador que exprese el comportamiento deseado.

| API | Tipo de trabajo | Pregunta que responde |
|---|---|---|
| `Pod` | Unidad mínima de ejecución | ¿Qué contenedores se ejecutan juntos? |
| `ReplicaSet` | Réplicas equivalentes | ¿Cuántos Pods equivalentes deben existir? |
| `Deployment` | Servicio stateless replicado | ¿Cómo mantengo y actualizo una aplicación reemplazable? |
| `StatefulSet` | Servicio con identidad estable | ¿Cómo mantengo Pods con nombre, orden e identidad persistente? |
| `DaemonSet` | Agente por nodo | ¿Cómo ejecuto un Pod en cada nodo o en un conjunto de nodos? |
| `Job` | Tarea finita | ¿Cómo ejecuto trabajo hasta completarlo correctamente? |
| `CronJob` | Tarea periódica | ¿Cómo ejecuto Jobs siguiendo un calendario? |

La elección no depende solo de la imagen que se ejecuta. Depende del contrato operativo que necesitas.

## `Pod`: unidad mínima, no unidad habitual de operación

Un `Pod` es la unidad mínima que Kubernetes puede programar en un nodo. Puede contener uno o varios contenedores que comparten red, almacenamiento temporal y ciclo de vida.

En la práctica profesional no se suelen crear Pods directamente para aplicaciones duraderas. Si el Pod desaparece, no hay un controlador superior que lo reemplace, salvo que lo haya creado otra API.

En Unidad 01 observas Pods, pero no los declaras como artefacto principal.

## `ReplicaSet`: mantener cantidad, no gestionar releases

Un `ReplicaSet` mantiene un número deseado de Pods equivalentes.

En Unidad 01 aparece como objeto derivado del `Deployment`. Esto es deliberado: el `ReplicaSet` es importante para entender la cadena de reconciliación, pero no suele ser la API que un equipo edita directamente.

Su responsabilidad es estrecha:

- asegurar que existe una cantidad de Pods;
- seleccionar Pods mediante labels;
- crear Pods cuando faltan.

No modela por sí solo una estrategia completa de actualización de aplicación. Para eso se usa `Deployment`.

## `Deployment`: servicios stateless y reemplazables

`Deployment` es la API adecuada para muchas aplicaciones HTTP, APIs internas, frontends, workers stateless y servicios donde las réplicas son equivalentes.

Encaja cuando:

- cualquier réplica puede sustituir a otra;
- los Pods no necesitan nombres estables;
- el estado importante vive fuera del Pod o se puede reconstruir;
- quieres rolling updates y rollback de versiones;
- el tráfico puede repartirse entre réplicas equivalentes.

En Unidad 01, `platform-api` cumple ese patrón. Por eso se declara como `Deployment`.

Lo que `Deployment` no resuelve:

- identidad estable por réplica;
- orden estricto de arranque;
- almacenamiento persistente asociado a cada réplica;
- ejecución de tareas finitas;
- ejecución de agentes por nodo.

## `StatefulSet`: identidad estable y estado con nombre

`StatefulSet` se usa cuando los Pods no son intercambiables sin más.

Aporta:

- nombres estables como `app-0`, `app-1`, `app-2`;
- identidad de red estable cuando se combina con un `Headless Service`;
- creación, actualización y terminación con orden;
- asociación habitual con `volumeClaimTemplates` para almacenamiento por réplica.

Es útil para ciertas bases de datos, colas, sistemas distribuidos o componentes que necesitan identidad estable.

Pero no convierte automáticamente una aplicación stateful en segura o fácil de operar. Ejecutar estado real en Kubernetes también implica backups, recuperación, afinidad, tolerancia a fallos, upgrades y procedimientos de operación.

En este itinerario, `StatefulSet` y `Headless Service` se retomarán en el contexto natural de persistencia y estado, especialmente alrededor de la Unidad 04.

## `DaemonSet`: un Pod por nodo

`DaemonSet` se usa cuando quieres que haya una copia de un Pod en cada nodo, o en un subconjunto de nodos.

Es típico para:

- agentes de logs;
- exporters de métricas;
- agentes de seguridad;
- componentes de red;
- herramientas de observación del nodo.

La diferencia clave frente a `Deployment` es que el número de Pods no se expresa como una réplica deseada global. Depende de los nodos que cumplen el selector.

```text
Deployment: quiero N réplicas.
DaemonSet: quiero una réplica por nodo aplicable.
```

En este curso, `DaemonSet` encaja mejor cuando aparezcan observabilidad y agentes de plataforma.

## `Job`: trabajo finito

`Job` representa una tarea que debe ejecutarse hasta completarse.

Encaja cuando:

- quieres ejecutar una acción puntual;
- el éxito se mide por finalización;
- el Pod no debe vivir indefinidamente;
- necesitas reintentos controlados si falla.

Ejemplos habituales:

- migraciones de esquema;
- tareas de inicialización;
- validaciones;
- procesamiento batch;
- acciones auxiliares de release.

Un `Job` no es una API adecuada para servir tráfico HTTP de forma continua. Para eso se usa normalmente `Deployment`.

En este itinerario, `Job` se conectará de forma natural con CI/CD y tareas finitas, especialmente en Unidad 08.

## `CronJob`: trabajo finito programado

`CronJob` crea Jobs siguiendo una planificación temporal.

Sirve para tareas periódicas:

- limpiezas;
- informes;
- sincronizaciones;
- comprobaciones recurrentes;
- procesos batch con calendario.

Su riesgo principal es operativo: una planificación mal definida puede solapar ejecuciones, acumular fallos o consumir recursos de forma inesperada.

Por eso no basta con saber escribir una expresión cron. También hay que entender concurrencia, historial, reintentos y límites.

## Criterios de decisión

Puedes usar esta tabla como primera orientación:

| Necesidad | API candidata | Motivo |
|---|---|---|
| Servir tráfico con réplicas equivalentes | `Deployment` | Gestiona rollout, replicas y Pods reemplazables |
| Mantener identidad estable por réplica | `StatefulSet` | Conserva nombres, orden y asociación con almacenamiento |
| Ejecutar un agente en cada nodo | `DaemonSet` | Su escala depende de los nodos aplicables |
| Ejecutar una tarea hasta completarse | `Job` | El objetivo es finalizar correctamente |
| Ejecutar una tarea periódica | `CronJob` | Crea Jobs según calendario |
| Probar un contenedor de forma aislada | `Pod` temporal | Puede servir para diagnóstico, no como patrón de operación duradera |

La pregunta profesional no es “¿qué API conozco?”, sino:

```text
¿Qué contrato de ciclo de vida necesita este trabajo?
```

## Relación con el laboratorio

El laboratorio de Unidad 01 declara solo:

- `Namespace`;
- `Deployment`;
- `Service`.

No se añaden otros workloads porque el objetivo es aprender la primera cadena de reconciliación sin mezclar varios modelos de ciclo de vida.

Cuando observes:

```bash
kubectl -n platform-training get deploy,rs,pods
```

debes leerlo así:

```text
Deployment: intención de aplicación replicada.
ReplicaSet: mecanismo derivado para mantener Pods.
Pod: ejecución real.
```

Los demás controladores quedan como mapa para unidades posteriores.

## Errores frecuentes

### Pensar que todo debe ser un `Deployment`

`Deployment` es común, pero no universal. Si necesitas identidad estable, tareas finitas o agentes por nodo, otra API puede expresar mejor el contrato.

### Confundir estado persistente con `StatefulSet`

Tener un volumen no siempre implica usar `StatefulSet`. Una aplicación puede usar un PVC y seguir siendo un `Deployment` si sus réplicas son reemplazables y no necesitan identidad propia.

### Crear Pods manuales como diseño principal

Un Pod manual puede ayudar a diagnosticar, pero para una aplicación duradera normalmente falta el controlador que lo reponga, actualice o coordine.

### Ver `ReplicaSet` como objeto de autoría principal

En la mayoría de flujos, el equipo declara el `Deployment` y observa el `ReplicaSet` como consecuencia.

### Elegir una API por herramienta, no por ciclo de vida

Helm, Terraform, Argo CD o Tekton pueden aplicar manifiestos, pero no cambian el contrato del workload. Primero se decide qué comportamiento necesita el trabajo; después se decide cómo gestionarlo.

## Continuidad

Esta referencia se retomará en varios puntos del itinerario:

| Tema | Unidad prevista | Cómo se retomará |
|---|---:|---|
| Configuración, probes y recursos | 02 | Se añadirán capacidades al `Deployment` existente |
| Persistencia y estado | 04 | Se diferenciará estado en volumen de identidad estable; `StatefulSet` y `Headless Service` quedan como práctica natural futura |
| CI/CD | 08 | `Job` y `CronJob` servirán como base conceptual para tareas finitas, validaciones y migraciones |
| Observabilidad | 13-15 | `DaemonSet` aparecerá como patrón habitual para agentes por nodo |
| Seguridad de workloads | 16 | Los controladores se combinarán con ServiceAccounts, policies y contexto de seguridad |

## Fuentes de referencia

Kubernetes Documentation - Workloads:

- Qué leer: la sección general de workloads y controladores.
- Por qué importa: presenta la familia completa de APIs que gestionan Pods.
- Pregunta que deberías responder: ¿qué diferencia hay entre un Pod y un controlador de workload?

Kubernetes Documentation - Deployments:

- Qué leer: conceptos de Deployment, rollout y rollback.
- Por qué importa: es la API que usa Unidad 01 para `platform-api`.
- Pregunta que deberías responder: ¿por qué un Deployment crea ReplicaSets?

Kubernetes Documentation - StatefulSets:

- Qué leer: identidad estable, ordinales, `Headless Service` y almacenamiento.
- Por qué importa: evita pensar que estado persistente y Deployment son siempre suficientes.
- Pregunta que deberías responder: ¿qué aporta un StatefulSet que no aporta un Deployment?

Kubernetes Documentation - DaemonSet:

- Qué leer: ejecución por nodo y selección de nodos.
- Por qué importa: prepara la lectura de agentes de observabilidad y plataforma.
- Pregunta que deberías responder: ¿por qué un DaemonSet no se escala igual que un Deployment?

Kubernetes Documentation - Jobs and CronJobs:

- Qué leer: finalización, reintentos, concurrencia y planificación.
- Por qué importa: conecta Kubernetes con tareas finitas y automatización.
- Pregunta que deberías responder: ¿cuándo una tarea debe ser Job o CronJob en lugar de Deployment?
