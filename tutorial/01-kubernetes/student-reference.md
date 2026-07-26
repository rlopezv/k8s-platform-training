# Referencia del alumno — Unidad 01: Fundamentos operativos y workloads

## Propósito de la referencia

Esta referencia amplía `tutorial/01-kubernetes/student-notes.md`. Las notas explican cómo completar y diagnosticar el laboratorio de `platform-api`; esta referencia sitúa esa práctica dentro del mapa profesional de Kubernetes para que no confundas la primera API usada con todo el modelo de workloads.

Aplica cobertura de panorama, profundidad, criterio y práctica. Cierra documentalmente la parte de `GAP-004` asignada a la Unidad 01: mapa de workloads no `Deployment`, criterio de elección y anclaje de práctica futura. La práctica de `StatefulSet` y `Headless Service` sigue pendiente en la Unidad 04 como `TD-023`.

Esta referencia no modifica `labs/01-kubernetes/`, no crea workloads nuevos, no cambia manifiestos Kubernetes, no instala herramientas, no ejecuta validaciones funcionales y no sustituye el README operativo del laboratorio.

## Relación con la unidad

La Unidad 01 practica:

- crear el namespace `platform-training`;
- declarar `deployment/platform-api`;
- observar ReplicaSet y Pods derivados;
- crear `service/platform-api` de tipo `ClusterIP`;
- comprobar labels, selectors, endpoints, eventos y logs.

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Namespace final | `labs/01-kubernetes/solution/namespace.yaml` | Aislamiento lógico y labels de trazabilidad |
| Deployment final | `labs/01-kubernetes/solution/deployment.yaml` | Réplicas, selector, template del Pod, imagen y labels |
| Service final | `labs/01-kubernetes/solution/service.yaml` | Tipo `ClusterIP`, puerto estable y selector hacia Pods |
| Laboratorio operativo | `labs/01-kubernetes/README.md` | Secuencia de despliegue, validación y recuperación |
| Notas del alumno | `tutorial/01-kubernetes/student-notes.md` | Diagnóstico de fallos que ocurren dentro del laboratorio |

La cadena practicada es:

```text
Deployment -> ReplicaSet -> Pods
Service --selector--> Pods
Service -> endpoints
```

Esta referencia abre el mapa:

```text
Controladores de workload -> Pods -> red interna -> descubrimiento
```

## Mapa conceptual

Kubernetes ejecuta contenedores dentro de Pods, pero una plataforma profesional rara vez opera Pods sueltos como diseño principal. Lo normal es declarar un controlador de workload que expresa el contrato de ciclo de vida: mantener réplicas, conservar identidad, ejecutar una tarea finita, repetirla por calendario o asegurar una copia por nodo.

```text
kubectl
  -> kube-apiserver
    -> estado deseado en el datastore
      -> controladores y scheduler
        -> kubelet
          -> container runtime
            -> Pods
              -> Service, endpoints y DNS interno
```

Las distinciones importantes son:

| Distinción | Criterio |
|---|---|
| Pod frente a contenedor | El Pod es la unidad de planificación de Kubernetes; el contenedor es el proceso empaquetado que ejecuta el runtime |
| Deployment frente a ReplicaSet | El Deployment expresa la intención de aplicación y rollout; el ReplicaSet mantiene una cantidad de Pods de una plantilla |
| Label frente a anotación | La label sirve para selección y agrupación; la anotación añade metadata para herramientas o gobierno |
| Service frente a Ingress | El Service da identidad interna estable; Ingress/Gateway gobierna entrada HTTP desde fuera del clúster |
| DNS interno frente a exposición externa | CoreDNS resuelve nombres dentro del clúster; no publica la aplicación fuera |
| `RollingUpdate` frente a disponibilidad real | La estrategia ayuda al reemplazo gradual, pero necesita readiness, capacidad y observabilidad para sostener expectativas profesionales |

En MicroK8s local muchas responsabilidades conviven en la misma máquina. Conceptualmente siguen separadas. Esa separación será visible cuando el curso avance hacia mantenimiento, observabilidad y plataformas gestionadas.

## Conceptos y mecanismos

### Flujo de `kubectl` a Pods reales

`kubectl apply` no arranca contenedores directamente. Envía un objeto al `kube-apiserver`; la API lo valida y lo guarda como estado deseado. Después intervienen controladores, scheduler, kubelet y runtime.

En un clúster Kubernetes clásico, `etcd` actúa como almacén distribuido del estado. En MicroK8s local puede haber un datastore embebido de la distribución. Para el alumno, el modelo mental es el mismo: Kubernetes conserva objetos y sus controladores reconcilian estado deseado contra estado observado.

Lo que no resuelve este mecanismo por sí solo: no garantiza que la imagen exista, que la aplicación esté lista, que haya capacidad suficiente o que el Service seleccione Pods correctos. Para eso necesitas observar `status`, eventos, logs y endpoints.

### Pod: unidad mínima, no patrón principal

Un `Pod` agrupa uno o varios contenedores que comparten red, almacenamiento temporal y ciclo de vida. Es la unidad que el scheduler coloca en un nodo y que el kubelet materializa mediante el container runtime, en este laboratorio `containerd` como implementación habitual bajo Kubernetes.

En Unidad 01 observas Pods, pero no los declaras como artefacto principal. Si un Pod manual desaparece, no hay un controlador superior que lo reponga como parte de una aplicación duradera.

Lo que no resuelve un Pod aislado: rollout, rollback, escalado declarativo, reemplazo coordinado y gestión de versiones.

### Deployment y ReplicaSet

`Deployment` es la API adecuada para servicios reemplazables, stateless y replicados. En `labs/01-kubernetes/solution/deployment.yaml`, `platform-api` declara dos réplicas y una plantilla de Pod. Kubernetes crea un ReplicaSet derivado y el ReplicaSet mantiene los Pods.

El ReplicaSet importa porque explica la reconciliación, pero no suele ser el objeto de autoría principal. Editarlo directamente rompe el flujo mental que el curso quiere enseñar: declarar intención en una API de más alto nivel y observar recursos derivados.

Lo que no resuelve un Deployment: identidad estable por réplica, almacenamiento persistente por ordinal, tareas finitas, ejecución por nodo o dependencias de arranque complejas.

### StatefulSet

`StatefulSet` aparece cuando los Pods no son equivalentes e intercambiables. Aporta nombres estables, ordinales, orden de creación/terminación y asociación frecuente con `volumeClaimTemplates`. Normalmente se combina con un `Headless Service` para identidad de red estable.

Es útil para ciertas bases de datos, colas y sistemas distribuidos que necesitan identidad. No convierte automáticamente una aplicación con estado en segura: siguen haciendo falta backups, restores, afinidad, actualizaciones, observabilidad y procedimientos de operación.

En este itinerario, su práctica queda anclada a Unidad 04 como parte de `TD-023`, sin migrar `platform-api`.

### DaemonSet

`DaemonSet` mantiene un Pod en cada nodo aplicable. Su escala depende del número de nodos que cumplen el selector, no de un número global de réplicas.

Es típico en agentes de logs, métricas, seguridad, red o almacenamiento. En un clúster de un solo nodo se ve poco su valor, porque parece un Deployment de una réplica. En producción importa porque expresa proximidad al nodo.

Lo que no resuelve un DaemonSet: servir una API replicada con balanceo normal ni ejecutar tareas finitas.

### Job y CronJob

`Job` ejecuta trabajo hasta completarlo correctamente. Encaja con migraciones, validaciones, cargas batch o tareas de release. El éxito se mide por finalización, no por mantenerse vivo.

`CronJob` crea Jobs siguiendo un calendario. Añade criterios operativos de concurrencia, reintentos, historial y ventanas de ejecución. Una mala planificación puede solapar tareas o consumir recursos de forma inesperada.

Lo que no resuelven Job y CronJob: servir tráfico HTTP continuo.

### Labels, selectors y anotaciones

Las labels son metadata seleccionable. En Unidad 01 unen tres zonas críticas:

- `spec.selector.matchLabels` del Deployment;
- `metadata.labels` del template del Pod;
- `spec.selector` del Service.

Si esos campos no coinciden, Kubernetes puede estar funcionando bien y aun así el Service no tendrá endpoints.

Las anotaciones también son metadata, pero no se usan como selector. Suelen transportar información para herramientas: ownership, ciclo de vida, políticas, catálogos, controladores externos o integraciones. La Unidad 01 no añade anotaciones corporativas porque eso implicaría un modelo de gobierno todavía no introducido.

### Service, CoreDNS y FQDN interno

`Service` da una identidad de red estable a Pods efímeros. En esta unidad es `ClusterIP`: accesible dentro del clúster y probado desde la máquina local con `kubectl port-forward`.

Cuando el addon DNS está disponible, Kubernetes crea nombres internos para Services. El patrón general es:

```text
<service>.<namespace>.svc.cluster.local
```

Para esta unidad, el FQDN conceptual sería:

```text
platform-api.platform-training.svc.cluster.local
```

Esto no equivale a entrada externa. CoreDNS resuelve nombres internos; Ingress, Gateway API, certificados y DNS público pertenecen a unidades posteriores.

### Estrategias de despliegue

Un Deployment puede usar estrategias como `Recreate` o `RollingUpdate`.

`Recreate` termina Pods antiguos antes de crear nuevos. Es simple, pero puede causar indisponibilidad.

`RollingUpdate` reemplaza Pods gradualmente. Sus parámetros `maxSurge` y `maxUnavailable` controlan cuántos Pods extra pueden existir y cuántos pueden faltar durante el rollout. Pero sin readiness probes, capacidad suficiente y observabilidad, un rolling update no garantiza por sí solo experiencia sin impacto.

La Unidad 01 no ajusta esos campos. Los sitúa para que las unidades 02 y 05 tengan sentido cuando incorporen probes, recursos y resiliencia.

## Criterios de decisión

### Cuándo usar Deployment

Usa `Deployment` cuando:

- las réplicas son equivalentes;
- el estado importante no depende del nombre de cada Pod;
- quieres rollout y rollback declarativos;
- el tráfico puede distribuirse entre Pods reemplazables.

`platform-api` encaja aquí porque es un servicio HTTP mínimo, sin identidad estable ni almacenamiento propio.

### Cuándo no usar Deployment

No uses Deployment solo porque sea conocido. Si necesitas identidad estable, considera `StatefulSet`. Si necesitas un agente por nodo, `DaemonSet`. Si el trabajo termina, `Job`. Si se repite por calendario, `CronJob`.

La pregunta profesional es:

```text
¿Qué contrato de ciclo de vida necesita este trabajo?
```

### Cuándo usar labels o anotaciones

Usa labels para selección, agrupación y consultas operativas. Deben ser estables y deliberadas, porque controlan relaciones reales como Service -> Pods.

Usa anotaciones para metadata que consumen herramientas o humanos, pero que no debe decidir pertenencia a conjuntos. Ejemplos futuros: ownership, políticas, integraciones de ingress controllers, catálogos o trazabilidad.

### Cómo evaluar una estrategia de rollout

`RollingUpdate` suele ser el punto de partida para servicios HTTP, pero evalúalo junto con:

- readiness probes;
- capacidad de nodos;
- requests y limits;
- PDB;
- observabilidad;
- compatibilidad entre versiones;
- estrategia de rollback.

Unidad 01 solo enseña el concepto. La práctica profesional aparece cuando el Deployment tiene señales de salud y restricciones operativas.

### Cómo distinguir Kubernetes estándar de MicroK8s

`Namespace`, `Deployment`, `Service`, labels, selectors, Pods y ReplicaSets son Kubernetes estándar.

El clúster local de un nodo, el datastore embebido observado en MicroK8s y la forma de habilitar addons pertenecen a la distribución local. Esa diferencia evita diseñar una plataforma cloud como si fuera una reproducción ampliada del laboratorio.

## Relación con el laboratorio

El laboratorio practica:

- `Namespace`;
- `Deployment`;
- observación de `ReplicaSet`;
- observación de Pods;
- `Service` `ClusterIP`;
- labels, selectors y endpoints;
- validación con estado, eventos, logs y `port-forward`.

El laboratorio menciona, pero no practica:

- anotaciones corporativas de ciclo de vida: se retoman en unidades de gobierno, seguridad y GitOps;
- `StatefulSet` y `Headless Service`: Unidad 04, con práctica pendiente `TD-023`;
- `DaemonSet`: Unidades 13-15, asociado a agentes de observabilidad;
- `Job` y `CronJob`: Unidad 08, asociado a CI/CD y tareas finitas;
- `Recreate`, `RollingUpdate`, `maxSurge` y `maxUnavailable`: Unidad 05 y continuidad posterior, con probes y resiliencia;
- CoreDNS y FQDN interno profundo: Unidad 03 para red y Unidad 19 para desacoplamiento local/cloud;
- Ingress, Gateway API, TLS y DNS externo: Unidad 03 y continuidad posterior;
- ConfigMaps, Secrets, probes, requests y limits: Unidad 02.

Restricción de la unidad: no se modifica el laboratorio para cubrir esos puntos. Añadirlos como práctica cambiaría el alcance, exigiría validaciones nuevas y rompería la función de Unidad 01 como primer contacto con reconciliación.

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Pensar que todo debe ser un `Deployment` | Oculta contratos de ciclo de vida que Kubernetes modela con otras APIs |
| Confundir Pod con contenedor | Lleva a ignorar planificación, red compartida y ciclo de vida del Pod |
| Editar ReplicaSets como flujo normal | Rompe la autoría declarativa del Deployment y dificulta rollouts |
| Creer que el Service apunta al Deployment | El Service selecciona Pods por labels; nombres iguales no bastan |
| Tratar labels como decoración | Una label incorrecta puede dejar un Service sin endpoints |
| Usar anotaciones como si fueran selectors | Las anotaciones no gobiernan pertenencia a conjuntos |
| Pensar que `apply` significa aplicación lista | La API aceptó el objeto; la convergencia se observa después |
| Creer que `RollingUpdate` garantiza cero impacto | Sin readiness, capacidad y observabilidad puede haber indisponibilidad real |
| Tomar MicroK8s de un nodo como modelo de producción | No muestra alta disponibilidad, zonas, operación cloud ni mantenimiento real |

## Continuidad

Unidad 02 retoma el Deployment de `platform-api` para añadir ConfigMaps, Secrets de laboratorio, variables de entorno, volúmenes de configuración, probes, requests y limits. Ahí empieza a verse cómo cambiar el template del Pod produce un rollout.

Unidad 03 retoma el Service como base para entrada HTTP local con Ingress y para separar red interna, entrada externa, DNS y TLS.

Unidad 04 retoma almacenamiento, identidad y estado. Ahí debe cerrarse la práctica pendiente de `GAP-004` mediante `TD-023`, con `StatefulSet` y `Headless Service` sobre workload auxiliar desechable, sin migrar `platform-api`.

Unidad 05 retoma rollout y disponibilidad con scheduling, constraints, PDB y mantenimiento. Los conceptos `RollingUpdate`, capacidad y disponibilidad pasan de mapa a criterio operativo.

Unidad 08 retoma `Job` y `CronJob` como APIs naturales para tareas finitas, validaciones, migraciones o automatización en CI/CD.

Unidades 13-15 retoman `DaemonSet` como patrón habitual para agentes de observabilidad, logs, métricas o componentes de plataforma por nodo.

Unidad 19 retoma la diferencia entre Kubernetes estándar y supuestos locales de MicroK8s antes de migrar hacia AKS y EKS.

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/) | Componentes de control plane y nodo | ¿Qué componente recibe la petición de `kubectl` y cuál ejecuta el Pod en el nodo? |
| [Workloads](https://kubernetes.io/docs/concepts/workloads/) | Panorama de Pods y controladores | ¿Por qué Kubernetes ofrece varias APIs para crear Pods? |
| [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Deployment, ReplicaSet y rollout | ¿Por qué Unidad 01 declara un Deployment y observa ReplicaSets? |
| [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) | Identidad estable, ordinales y almacenamiento | ¿Qué necesidad obliga a usar StatefulSet en lugar de Deployment? |
| [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) | Ejecución por nodo | ¿Por qué la escala de un DaemonSet depende de los nodos? |
| [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) | Trabajo finito y reintentos | ¿Cuándo una tarea debe terminar en vez de mantenerse viva? |
| [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) | Planificación temporal de Jobs | ¿Qué riesgo operativo añade ejecutar tareas por calendario? |
| [Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) | Labels, selectors y consultas | ¿Por qué un Service sin endpoints puede ser un problema de selector? |
| [Service](https://kubernetes.io/docs/concepts/services-networking/service/) | Service, endpoints y descubrimiento | ¿Qué identidad estable ofrece un Service y qué no expone por sí solo? |
| [DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) | Nombres DNS internos | ¿Qué significa `platform-api.platform-training.svc.cluster.local` y dónde funciona? |
