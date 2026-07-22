# Referencia del alumno - Unidad 02

## Propósito de la referencia

Esta referencia amplía `tutorial/02-configuration-lifecycle/student-notes.md` con una visión profesional sobre configuración, secretos de Kubernetes, probes, recursos y ciclo de vida de un `Deployment`.

El laboratorio de la unidad enseña a aplicar esos mecanismos sobre `platform-api`. Esta referencia explica por qué existen, qué límites tienen y qué decisiones aparecen cuando el mismo patrón se lleva a un entorno real.

No sustituye al laboratorio ni introduce herramientas nuevas. La Unidad 02 sigue usando un `Secret` ficticio, no instala gestores externos de secretos, no cambia la imagen de la aplicación y no modifica el estado técnico del clúster.

## Relación con la unidad

La Unidad 02 convierte el `Deployment` mínimo de la Unidad 01 en un workload más operable. La aplicación sigue siendo `platform-api`, pero su `Pod template` ahora declara:

- configuración no sensible con `ConfigMap`;
- valores sensibles simulados con `Secret`;
- variables de entorno desde objetos Kubernetes;
- contenido montado como fichero desde un volumen de configuración;
- `startupProbe`, `readinessProbe` y `livenessProbe`;
- `resources.requests` y `resources.limits`;
- un nuevo rollout cuando cambia `.spec.template`.

Los artefactos principales para leer esta referencia son:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| ConfigMap | `labs/02-configuration-lifecycle/solution/configmap.yaml` | Datos no sensibles y fichero `index.html` |
| Secret de laboratorio | `labs/02-configuration-lifecycle/solution/secret.yaml` | Uso didáctico de `stringData` con valores ficticios |
| Deployment | `labs/02-configuration-lifecycle/solution/deployment.yaml` | Referencias a ConfigMap, Secret, probes y resources |
| Validación | `labs/02-configuration-lifecycle/validation/validate.sh` | Comprobaciones no destructivas de la unidad |

Parte del contenido se practica en la unidad. Otra parte queda solo como referencia para preparar Helm, GitOps, seguridad, escalado, gobierno de recursos y coste.

## Mapa conceptual

La unidad gira alrededor de una separación básica:

```text
Imagen
  -> software construido

ConfigMap y Secret
  -> datos entregados por la plataforma

Probes
  -> señales de arranque, disponibilidad y salud

Requests y limits
  -> contrato de capacidad con scheduler, nodo y runtime

Deployment
  -> ciclo de vida declarativo del template de Pod
```

Esta separación evita que la imagen contenga decisiones de entorno. Una imagen debe poder moverse entre entornos; la configuración, los secretos, las señales de salud y las restricciones de recursos pertenecen al despliegue.

En Kubernetes, todo esto se expresa como API declarativa. El objetivo no es escribir más YAML, sino darle a la plataforma información suficiente para operar la aplicación con menos ambigüedad.

## Conceptos y mecanismos

### Configuración de build, despliegue y ejecución

No toda la configuración vive en el mismo momento del ciclo de vida.

| Momento | Qué decide | Ejemplo | Riesgo si se mezcla |
|---|---|---|---|
| Build | Qué software contiene la imagen | Paquetes, binario, servidor base | Reconstruir imágenes por cambios de entorno |
| Despliegue | Cómo se ejecuta en un entorno | `APP_ENV`, endpoints, flags | Despliegues poco trazables |
| Ejecución | Qué ocurre durante el proceso | Lectura de variables o ficheros | Cambios que no se aplican como se espera |

La Unidad 02 trabaja sobre la configuración de despliegue y ejecución. No reconstruye la imagen de `platform-api`.

### ConfigMap

Un `ConfigMap` almacena configuración no sensible como pares clave-valor o como contenido de ficheros. En esta unidad contiene `APP_ENV`, `LOG_LEVEL`, `FEATURE_GREETING` y `index.html`.

Puede consumirse de varias formas:

| Forma | Uso típico | Comportamiento relevante |
|---|---|---|
| Variable de entorno | Valores simples leídos al arrancar | El proceso no recibe cambios automáticamente |
| Volumen | Ficheros de configuración | Kubernetes puede actualizar el fichero proyectado, pero la aplicación debe releerlo |
| Argumentos o comandos | Parámetros de arranque | Deben aparecer en el template del Pod |

Un `ConfigMap` no es almacenamiento persistente. Si la aplicación escribe datos que deben sobrevivir al Pod, el tema pertenece a persistencia y estado, no a configuración.

### Secret de Kubernetes

Un `Secret` separa datos sensibles del manifiesto principal del workload. En Kubernetes no significa, por sí solo, que el dato esté protegido de extremo a extremo.

Detalles importantes:

- `data` contiene valores codificados en base64, no cifrados por ese hecho;
- `stringData` permite escribir valores legibles y Kubernetes los convierte al formato interno;
- el acceso real depende de RBAC, configuración del clúster, cifrado de `etcd`, auditoría y prácticas de entrega;
- montar o exponer un secreto como variable de entorno lo hace accesible al proceso;
- versionar secretos reales en Git sigue siendo una mala práctica aunque el recurso se llame `Secret`.

La Unidad 02 usa `platform-api-secret` con valores ficticios para aprender la API. La gestión real de secretos se difiere a la Unidad 09, donde encaja mejor con GitOps y con herramientas como External Secrets Operator, Sealed Secrets, SOPS, Vault o secret managers cloud.

### Variables de entorno y volúmenes de configuración

Las variables de entorno son simples y habituales, pero tienen una propiedad importante: se fijan al arrancar el proceso. Si cambia el `ConfigMap` o el `Secret`, el proceso no vuelve a leer automáticamente esas variables.

Los volúmenes de configuración sirven cuando la aplicación espera ficheros. Kubernetes puede actualizar el contenido proyectado, pero eso no garantiza que la aplicación recargue el fichero ni que exista un rollout auditable.

En plataformas reales suele preferirse que los cambios relevantes del comportamiento del workload queden reflejados en el `Pod template`. Más adelante, Helm permitirá expresar patrones como anotaciones de checksum para provocar rollouts controlados cuando cambie una configuración empaquetada.

### Probes

Las probes son el lenguaje mínimo con el que el contenedor informa al `kubelet` sobre su estado operativo.

| Probe | Pregunta | Efecto |
|---|---|---|
| `startupProbe` | ¿El proceso terminó su arranque inicial? | Mientras falla, protege frente a reinicios prematuros por `livenessProbe` |
| `readinessProbe` | ¿Esta instancia debe recibir tráfico? | Si falla, el Pod sale de los endpoints del Service |
| `livenessProbe` | ¿El proceso debe reiniciarse? | Si falla repetidamente, el contenedor se reinicia |

La diferencia entre `readinessProbe` y `livenessProbe` es crítica. Una dependencia externa caída puede hacer que la instancia no deba recibir tráfico, pero no siempre significa que reiniciar el contenedor resuelva el problema.

### Requests, limits y QoS

Los recursos conectan la aplicación con la capacidad real del nodo.

| Campo | Quién lo usa | Qué representa |
|---|---|---|
| `requests.cpu` | Scheduler | CPU mínima solicitada para planificar el Pod |
| `requests.memory` | Scheduler | Memoria mínima solicitada para planificar el Pod |
| `limits.cpu` | Nodo y runtime | Frontera de consumo de CPU, normalmente mediante throttling |
| `limits.memory` | Nodo y runtime | Frontera de memoria; superarla puede terminar el contenedor |

Kubernetes usa requests y limits para clasificar Pods en clases de QoS: `Guaranteed`, `Burstable` y `BestEffort`. Esa clasificación influye en decisiones de presión de recursos y desalojo.

La Unidad 02 usa valores conservadores para laboratorio: `25m` de CPU y `64Mi` de memoria como requests, `100m` de CPU y `128Mi` de memoria como limits. Son valores didácticos, no una recomendación productiva universal.

### Ciclo de vida declarativo del Deployment

Un `Deployment` no ejecuta directamente contenedores. Declara un estado deseado y gestiona `ReplicaSet` y Pods para aproximarse a ese estado.

Cuando cambia `.spec.template`, Kubernetes crea una nueva revisión del `Deployment`. Eso incluye cambios en imagen, variables, probes, recursos, labels del template, volúmenes o anotaciones del template.

Cambiar un objeto referenciado, como un `ConfigMap`, no siempre cambia el template del Pod. Por eso puede existir una diferencia entre "la configuración cambió" y "la aplicación está ejecutándose con una nueva revisión trazable".

### EndpointSlice y readiness

La Unidad 02 prepara la Unidad 03 porque enseña que un Pod `Running` no equivale a un destino apto para tráfico. El Service selecciona Pods por labels, pero los destinos útiles dependen de readiness.

En Kubernetes moderno, `EndpointSlice` representa los endpoints que respaldan un Service. Si `readinessProbe` falla, el Pod puede seguir vivo, pero dejar de aparecer como destino listo.

## Criterios de decisión

### Cuándo usar ConfigMap o Secret

Usa `ConfigMap` para datos no sensibles que pueden verse en Git y en revisiones de código.

Usa `Secret` para datos que conceptualmente son sensibles, pero recuerda que el objeto no sustituye a una estrategia completa de secretos. En el repositorio del curso solo se aceptan valores ficticios.

Si el dato es real, sensible y debe llegar a producción, la decisión debe incluir al menos:

- quién puede leerlo en Git;
- quién puede leerlo en Kubernetes;
- cómo se rota;
- dónde se audita;
- cómo se evita que aparezca en logs;
- qué ocurre si se filtra.

### Cuándo usar variable de entorno o fichero montado

Usa variables de entorno para valores pequeños y simples que la aplicación lee al arrancar.

Usa ficheros montados cuando:

- la aplicación espera un archivo de configuración;
- el contenido tiene estructura;
- quieres separar varias claves de un bloque de configuración;
- necesitas montar contenido en una ruta concreta.

No asumas que un cambio de fichero implica recarga de aplicación. Esa capacidad depende del proceso que se ejecuta dentro del contenedor.

### Cómo elegir probes

Empieza por `readinessProbe` cuando el problema sea controlar tráfico. Añade `livenessProbe` solo cuando reiniciar el proceso sea una recuperación razonable. Usa `startupProbe` cuando el arranque pueda tardar más que el comportamiento normal en régimen estable.

Una mala `livenessProbe` puede convertir un incidente externo en un bucle de reinicios. Una mala `readinessProbe` puede sacar de servicio Pods sanos o enviar tráfico a Pods que todavía no están preparados.

### Cómo aproximar requests y limits

En laboratorio se usan valores pequeños para observar el mecanismo. En producción, los valores deberían partir de mediciones:

- consumo real bajo carga normal;
- picos esperados;
- tiempo de arranque;
- comportamiento ante throttling de CPU;
- memoria usada por heap, buffers, cachés y runtime;
- coste de reservar capacidad que no se consume.

Requests demasiado altos reducen densidad y elevan coste. Requests demasiado bajos provocan mala planificación y ruido operativo. Limits demasiado bajos pueden degradar o matar la aplicación; limits inexistentes trasladan el riesgo al nodo y a otros workloads.

## Relación con el laboratorio

El laboratorio practica:

- creación de `platform-api-config`;
- creación de `platform-api-secret` con valores ficticios;
- consumo de configuración mediante `env.valueFrom`;
- montaje de `index.html` desde ConfigMap;
- probes HTTP sobre `/` en el puerto `http`;
- requests y limits iniciales;
- observación de rollout y endpoints.

El laboratorio no practica:

- cifrado de secretos en repositorio;
- External Secrets Operator, Sealed Secrets, SOPS o Vault;
- rotación real de credenciales;
- `ResourceQuota` o `LimitRange`;
- autoscaling;
- coste cloud;
- patrones Helm de checksum de configuración.

No debe modificarse `platform-api` ni sustituirse la imagen en esta unidad. El objetivo es aprender el contrato operativo que Kubernetes necesita alrededor de una imagen ya existente.

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Tratar `Secret` como una caja fuerte completa | Puede llevar a versionar credenciales reales o relajar RBAC y auditoría |
| Confundir base64 con cifrado | Base64 es una codificación reversible, no una protección criptográfica |
| Usar `livenessProbe` para comprobar dependencias externas frágiles | Puede causar reinicios masivos sin resolver la causa |
| Omitir `readinessProbe` | El Service puede enviar tráfico a Pods que todavía no están listos |
| Pensar que `Running` equivale a disponible | Un Pod puede estar vivo y fuera de endpoints |
| Esperar que una variable de entorno cambie en caliente | Las variables se fijan al arrancar el proceso |
| Poner requests y limits como números decorativos | Afectan scheduling, densidad, rendimiento, coste y desalojos |
| Copiar valores de laboratorio a producción | Los valores de esta unidad son didácticos y conservadores |

## Continuidad

La Unidad 03 reutiliza readiness y Service para explicar tráfico de entrada mediante Ingress.

La Unidad 06 retomará configuración en Helm: `values`, templates, helpers, upgrades y patrones para provocar rollouts trazables cuando cambia la configuración empaquetada.

La Unidad 09 deberá tratar la gestión real de secretos en un flujo GitOps: qué puede ir a Git, qué debe cifrarse, qué se sincroniza desde un gestor externo y qué controles evitan filtraciones.

La Unidad 16 retomará requests y limits junto con `ResourceQuota`, `LimitRange`, RBAC, `ServiceAccount`, `NetworkPolicy` y Pod Security Standards como parte del gobierno de workloads.

La Unidad 18 usará requests, limits y métricas como base para HPA y KEDA.

La Unidad 22 conectará requests, limits, densidad de nodos, autoscaling, observabilidad y coste operativo comparado entre MicroK8s, AKS y EKS.

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Kubernetes - ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) | Qué es un ConfigMap y cómo se consume desde Pods | ¿Qué datos pertenecen a un ConfigMap y cuáles no? |
| [Kubernetes - Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) | Tipos de Secret, consumo y límites de seguridad | ¿Por qué un Secret no basta como estrategia completa de secretos? |
| [Kubernetes - Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) | Diferencias entre probes y ejemplos de configuración | ¿Qué probe controla tráfico y cuál provoca reinicios? |
| [Kubernetes - Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Requests, limits y comportamiento de CPU y memoria | ¿Cómo afectan requests y limits al scheduler y al nodo? |
| [Kubernetes - Pod Quality of Service Classes](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/) | Clases `Guaranteed`, `Burstable` y `BestEffort` | ¿Cómo clasifica Kubernetes un Pod según sus recursos? |
| [Kubernetes - Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Rollouts, ReplicaSets y revisiones | ¿Qué cambios provocan una nueva revisión del Deployment? |
| [Kubernetes - EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/) | Relación entre Services y destinos | ¿Cómo se representa que un Pod está disponible para tráfico? |
