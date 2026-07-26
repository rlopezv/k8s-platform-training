# Unidad 01 - Fundamentos operativos y primera aplicación

## Guía pedagógica de la unidad

Esta unidad es el primer contacto real con Kubernetes como sistema de operación de aplicaciones. No busca que el alumno memorice una lista de objetos, sino que cambie de modelo mental.

Antes de Kubernetes, muchas operaciones se piensan como acciones directas: arrancar un proceso, abrir un puerto, copiar un fichero, reiniciar un servicio. Kubernetes introduce otra forma de trabajar: declaras objetos en una API y un conjunto de controladores intenta mantener el estado real cerca del estado deseado.

La unidad cubre esa transición:

- de ejecutar un contenedor a declarar un workload;
- de pensar en una máquina a pensar en un clúster;
- de mirar un proceso a observar objetos, estado y eventos;
- de usar nombres manuales a usar labels y selectors;
- de acceder a un Pod concreto a usar un Service estable;
- de "ha fallado el comando" a "¿qué parte de la reconciliación no coincide?".

El laboratorio despliega `platform-api`, pero la aplicacion es un vehiculo. Lo importante es entender las responsabilidades que aparecen por primera vez: `Namespace`, `Deployment`, `ReplicaSet`, `Pod`, `Service`, labels, selectors, eventos y logs.

Para estudiar esos conceptos desde cero, especialmente `Pod`, Deployment, ReplicaSet, Service, labels y reconciliación, usa `tutorial/01-kubernetes/student-notes.md`.

Para ampliar el mapa profesional y entender por qué esta unidad usa `Deployment` pero Kubernetes también ofrece `StatefulSet`, `DaemonSet`, `Job` y `CronJob`, usa `tutorial/01-kubernetes/student-reference.md`. Esa referencia también cubre la diferencia entre labels y anotaciones, estrategias `Recreate` frente a `RollingUpdate`, CoreDNS y FQDN internos como criterio conceptual, sin cambiar el laboratorio.

Si necesitas repasar qué es una imagen de contenedor, un runtime o un registro antes de leer el campo `image` del Deployment, vuelve a `tutorial/00-environment/student-reference.md`. Para una práctica breve de lectura, usa `platform/environment/container-images/README.md`.

La frontera documental de la unidad es deliberada: el README orienta, `student-notes.md` explica y diagnostica el laboratorio, `student-reference.md` corrige modelos mentales y cubre lo que existe fuera de esta práctica inicial.

## Mapa de aprendizaje

| Concepto | Problema que resuelve | Limite en esta unidad |
|---|---|---|
| Cluster | Ejecutar workloads como sistema coordinado | Solo se usa un nodo local en MicroK8s |
| API Kubernetes | Guardar y exponer estado deseado y observado | No se profundiza en autenticacion ni autorizacion |
| Deployment | Mantener replicas de una aplicacion | No se configuran probes ni recursos hasta Unidad 02 |
| Pod | Ejecutar uno o mas contenedores juntos | No se gestionan Pods manualmente |
| ReplicaSet | Mantener numero de Pods para un Deployment | Se observa como objeto derivado |
| Service | Dar entrada estable interna hacia Pods seleccionados | No expone la aplicacion fuera del cluster |
| Labels y selectors | Relacionar recursos sin depender de nombres efimeros | Todavia no hay politicas ni segmentacion avanzada |
| Eventos y logs | Explicar estado y fallos basicos | No hay observabilidad centralizada |

## Pregunta central

La pregunta de la unidad no es "¿cómo despliego nginx?". La pregunta es:

```text
¿Cómo convierte Kubernetes una declaración versionada en Pods reales y en un punto de acceso interno estable?
```

Si el alumno puede responder esa pregunta con `platform-api`, está preparado para que la Unidad 02 añada configuración, salud y recursos sobre la misma base.

## Contexto

La Unidad 00 dejo preparado un entorno local con Ubuntu 24.04 LTS sobre WSL2, MicroK8s, Kubernetes, `kubectl`, Helm y Terraform. Hasta este punto el cluster existe, pero el curso no tiene todavia una aplicacion, un namespace funcional ni workloads propios.

Esta unidad convierte ese cluster vacio en la primera version operativa de la solucion evolutiva del curso. El resultado sera una aplicacion HTTP minima llamada `platform-api`, desplegada mediante manifiestos Kubernetes declarativos en el namespace `platform-training`.

Helm y Terraform seguirán instalados como herramientas base, pero no se usan para desplegar esta unidad. Primero se trabaja con YAML y `kubectl` para ver directamente que recursos crea Kubernetes y como se diagnostican.

## Problema real que resuelve

Kubernetes aparece cuando ejecutar contenedores uno a uno deja de ser suficiente. En una plataforma real no basta con "arrancar algo": hay que declarar cuantas instancias deben existir, donde viven sus recursos, como se sustituyen si fallan, como se les da una direccion estable y como se observa si el estado real coincide con lo pedido.

La Unidad 01 introduce ese cambio de mirada. El alumno pasa de pensar en comandos imperativos sobre una maquina a razonar sobre objetos declarativos que Kubernetes mantiene mediante reconciliacion.

## Por que aparece en este punto

La Unidad 00 preparo la plataforma, pero todavia no habia nada propio del curso ejecutandose en ella. Esta unidad crea la primera pieza funcional porque las unidades posteriores necesitan un workload estable al que anadir configuracion, salud, red, empaquetado, automatizacion y observabilidad.

Empezar con `Namespace`, `Deployment` y `Service` mantiene el alcance pequeno y permite entender las relaciones basicas antes de incorporar mas objetos.

## Como leer esta unidad

No necesitas memorizar todos los componentes de Kubernetes antes de empezar. Esta unidad usa una idea central y vuelve a ella varias veces:

```text
Declaro lo que quiero
   ↓
Kubernetes lo guarda como estado deseado
   ↓
Sus controladores intentan hacerlo realidad
   ↓
Yo observo el estado real y diagnostico diferencias
```

Cuando aparezca un nombre nuevo, intenta responder tres preguntas:

- que responsabilidad tiene;
- que otro componente o recurso toca;
- que comando permite observarlo.

Si una tabla parece demasiado densa en una primera lectura, sigue el laboratorio y vuelve a ella despues de ver los recursos reales con `kubectl`.

## Modelo mental de la unidad

El laboratorio se puede resumir como una cadena de responsabilidad:

```text
Manifiesto YAML
  -> API de Kubernetes
    -> estado deseado persistido
      -> controladores
        -> Pods reales en nodos
          -> Service que selecciona Pods listos por labels
```

La clave no es que el alumno recuerde todos los nombres, sino que pueda explicar donde mirar cuando algo no coincide. Si hay dos replicas declaradas y solo una Pod corriendo, la pregunta no es "que comando falta?", sino "que diferencia hay entre estado deseado, estado observado y eventos?".

## Objetivos

Al finalizar la unidad podras:

- validar que el MicroK8s heredado de la Unidad 00 esta listo para recibir workloads;
- explicar el recorrido de una declaracion desde `kubectl apply` hasta el estado observado;
- situar los componentes principales de control plane, nodo, runtime, red y almacenamiento;
- crear un `Namespace`, un `Deployment` y un `Service` mediante manifiestos;
- relacionar Deployment, ReplicaSet y Pods;
- comprobar labels, selectors, eventos, logs y endpoints;
- diagnosticar errores basicos como imagen no descargable, selector incorrecto o namespace ausente;
- dejar una base reutilizable para la Unidad 02.

## Conocimientos previos

Necesitas haber completado la Unidad 00 y estar trabajando dentro de Ubuntu WSL, en la raiz del repositorio:

```bash
pwd
```

Resultado esperado:

```text
/home/ramon/git/k8s-platform-training
```

## Relacion con la Unidad 00

La Unidad 00 preparo la plataforma. Esta unidad no reinstala MicroK8s, no cambia el cluster y no modifica `platform/environment/`.

La Unidad 00 tambien deja una referencia conceptual sobre contenedores, imagenes y registros en `tutorial/00-environment/student-reference.md`. Esta unidad usa esa base sin construir imagenes propias todavia.

Antes de desplegar la aplicacion, valida el estado heredado:

```bash
bash platform/environment/validation/validate-environment.sh
kubectl config current-context
kubectl get nodes
kubectl get namespaces
find labs -type f -not -name .gitkeep -print
```

Resultado esperado:

```text
La validacion integrada no muestra fallos bloqueantes.
El nodo local aparece en Ready.
Antes de aplicar esta unidad no existen laboratorios funcionales previos.
```

Si `microk8s status` falla por pertenencia a grupos en una terminal antigua, cierra y vuelve a abrir la sesion Ubuntu. `kubectl` debe seguir siendo el cliente principal.

## Estado inicial

El punto de partida verificable es:

- MicroK8s local operativo;
- `kubectl` configurado contra el cluster local;
- namespaces de sistema y `default`;
- sin workloads funcionales del curso;
- sin charts Helm, releases Helm, modulos Terraform ni estado Terraform;
- sin aplicacion evolutiva definida antes de esta unidad.

## Arquitectura del cluster

Kubernetes funciona como un sistema de reconciliacion. Esto significa que no le damos una lista cerrada de pasos tipo "arranca este contenedor y termina"; le entregamos objetos que describen el estado deseado.

Por ejemplo, un Deployment dira: "quiero dos replicas de esta aplicacion usando esta imagen". Kubernetes guarda esa declaracion y sus controladores trabajan para que el estado real se parezca a ella. Si un Pod desaparece, el sistema intenta crear otro. Si cambias la imagen del Deployment, inicia un rollout para acercarse al nuevo estado deseado.

En esta unidad interesa distinguir cuatro ideas:

| Idea | Explicacion corta | Ejemplo en la unidad |
|---|---|---|
| Estado deseado | Lo que escribes en YAML y aplicas con `kubectl apply`. | `replicas: 2` en el Deployment. |
| Estado observado | Lo que el cluster informa en cada momento. | `kubectl -n platform-training get pods`. |
| Reconciliacion | Trabajo continuo para acercar lo observado a lo deseado. | Crear Pods hasta tener dos replicas. |
| Diagnostico | Comparar deseo, estado y eventos para explicar una diferencia. | Un Service sin endpoints por selector incorrecto. |

En un cluster hay dos planos de responsabilidad:

| Plano | Responsabilidad |
|---|---|
| Control plane | Recibe declaraciones, guarda estado, decide ubicacion de Pods y ejecuta controladores. |
| Nodos worker | Ejecutan contenedores, conectan red de Pods y reportan estado al control plane. |

En MicroK8s local, esas responsabilidades conviven normalmente en la misma maquina. Conceptualmente siguen siendo responsabilidades separadas, y esa separacion sera importante cuando el laboratorio evolucione hacia AKS y EKS.

## Modelo declarativo y reconciliacion

En un flujo imperativo, el operador decide el siguiente paso: crear un contenedor, reiniciarlo, exponer un puerto o borrar una instancia. En un flujo declarativo, el operador declara el resultado esperado y el sistema trabaja continuamente para acercarse a el.

Esa diferencia cambia el diagnostico:

| Pregunta | Enfoque imperativo | Enfoque declarativo de Kubernetes |
|---|---|---|
| Que queria conseguir? | El comando que ejecute. | El objeto almacenado en la API. |
| Que esta pasando? | Salida inmediata del comando. | `status`, eventos y objetos generados. |
| Quien corrige una desviacion? | El operador. | Un controlador, si existe uno responsable. |
| Como recupero el estado? | Repito pasos manuales. | Reaplico la declaracion versionada. |

El Deployment es el primer ejemplo importante. El alumno no crea ReplicaSets ni Pods manualmente porque el contrato del Deployment ya dice cuantas replicas quiere. El controlador de Deployment y el ReplicaSet se encargan de materializar ese deseo.

## Componentes principales

Los componentes siguientes no son comandos que tengas que ejecutar en esta unidad. Son el mapa que explica por que los comandos del laboratorio producen cambios.

| Componente | Papel operativo |
|---|---|
| `kube-apiserver` | Entrada del cluster. `kubectl` habla con esta API. |
| `etcd` | Almacen de estado del cluster. En MicroK8s puede estar reemplazado internamente por el datastore de la distribucion, pero cumple la misma funcion conceptual. |
| `kube-scheduler` | Decide en que nodo puede ejecutarse un Pod pendiente. |
| `kube-controller-manager` | Ejecuta bucles de reconciliacion para objetos como Deployments, ReplicaSets y nodos. |
| `kubelet` | Agente del nodo. Crea y supervisa Pods asignados a ese nodo. |
| `kube-proxy` | Mantiene reglas de red para Services. |
| Container runtime | Ejecuta los contenedores que forman los Pods. |

Interfaces relacionadas:

| Interfaz | Que desacopla |
|---|---|
| CRI | Kubernetes del runtime de contenedores. |
| CNI | Kubernetes de la implementacion de red de Pods. |
| CSI | Kubernetes de la implementacion de almacenamiento. |

En esta unidad no se instala ni sustituye CRI, CNI ni CSI. Solo se ubican en el mapa mental de operacion.

## Mapa de objetos

Un objeto Kubernetes es un documento enviado a la API del cluster. Algunos objetos representan cosas que quieres gestionar directamente, como un Deployment o un Service. Otros aparecen como consecuencia de esa gestion, como ReplicaSets y Pods.

| Objeto | Uso en esta unidad |
|---|---|
| `Namespace` | Aisla los recursos funcionales del curso. |
| `Deployment` | Declara la aplicacion y el numero deseado de replicas. |
| `ReplicaSet` | Lo crea el Deployment para mantener el numero de Pods. |
| `Pod` | Unidad minima que ejecuta el contenedor. Se observa, no se gestiona manualmente. |
| `Service` | Da una direccion estable interna hacia los Pods seleccionados. |

Los recursos de configuracion, salud, recursos, ingreso y almacenamiento se explican ahora para ubicarlos, pero se implementan despues:

| Capacidad | Objeto o mecanismo | Unidad |
|---|---|---|
| Configuracion no sensible | `ConfigMap`, variables de entorno, volumenes de configuracion | 02 |
| Informacion sensible de laboratorio | `Secret` con valores no reales | 02 |
| Salud de aplicacion | `startupProbe`, `readinessProbe`, `livenessProbe` | 02 |
| CPU y memoria | `requests` y `limits` | 02 |
| Entrada HTTP desde fuera del cluster | `Ingress` y Gateway API | 03 |
| Persistencia | Volumenes, `PersistentVolume`, `PersistentVolumeClaim`, `StorageClass`, CSI | 04 |

## Labels y selectors como contrato

Los nombres ayudan a los humanos, pero muchos recursos Kubernetes se relacionan por labels y selectors. Esa relacion es deliberada: permite que un Service no dependa de un Pod concreto, porque los Pods cambian de nombre cuando se reemplazan.

En esta unidad hay tres sitios que deben contar la misma historia:

- el selector del Deployment decide que Pods pertenecen al conjunto gestionado;
- las labels del template se copian a los Pods creados;
- el selector del Service decide que Pods reciben trafico.

Si esos campos se separan, Kubernetes puede estar funcionando correctamente aunque la aplicacion no reciba trafico. Un Service sin endpoints suele ser un problema de contrato, no de red.

## Decisiones de diseno

| Decision | Motivo | Trade-off |
|---|---|---|
| Usar manifiestos YAML y `kubectl` | Hace visibles las APIs base antes de abstraerlas. | Hay mas detalle manual que con Helm. |
| Mantener un unico namespace funcional | Facilita aislamiento y limpieza del curso. | No modela todavia separacion por entornos o equipos. |
| Usar `ClusterIP` | Permite estudiar seleccion interna sin introducir Ingress. | No hay entrada HTTP estable desde fuera del cluster. |
| Usar una imagen HTTP simple sin privilegios | Reduce dependencias y permite validar HTTP y logs. | No representa todavia una aplicacion de negocio completa. |

## Observabilidad

En esta unidad se usan las señales basicas que Kubernetes ya ofrece:

- `status`, para ver el estado actual de objetos;
- eventos, para explicar decisiones y errores del cluster;
- logs, para leer salida de la aplicacion.

Las metricas, dashboards, logs centralizados, trazas, correlacion, OpenTelemetry y OpenMetrics se incorporaran en las unidades 11 a 15.

## Aplicacion evolutiva

La primera aplicacion del curso queda definida asi:

| Campo | Valor |
|---|---|
| Nombre | `platform-api` |
| Proposito | Servicio HTTP minimo para evolucionar configuracion, red, salud, observabilidad, seguridad, escalado y despliegue cloud. |
| Namespace | `platform-training` |
| Imagen | `nginxinc/nginx-unprivileged:1.27.4-alpine` |
| Puerto de contenedor | `8080` |
| Service | `platform-api`, `ClusterIP`, puerto `80` |

La imagen se ejecuta sin privilegios y expone HTTP sin requerir base de datos, cola, credenciales, Ingress ni almacenamiento persistente.

## Manifiestos

La unidad contiene dos rutas:

| Ruta | Uso |
|---|---|
| `labs/01-kubernetes/starter/` | Punto de partida para comparar campos y practicar lectura de manifiestos. |
| `labs/01-kubernetes/solution/` | Estado final que debe quedar aplicado y reutilizar la Unidad 02. |

La solucion final contiene:

```text
labs/01-kubernetes/solution/namespace.yaml
labs/01-kubernetes/solution/deployment.yaml
labs/01-kubernetes/solution/service.yaml
```

## Procedimiento declarativo

Aplica primero el namespace:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl get namespace platform-training
```

Aplica el Deployment:

```bash
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

Observa lo que ha creado Kubernetes:

```bash
kubectl -n platform-training get deployment platform-api
kubectl -n platform-training get rs -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api -o wide
```

Aplica el Service:

```bash
kubectl apply -f labs/01-kubernetes/solution/service.yaml
kubectl -n platform-training get service platform-api
kubectl -n platform-training get endpoints platform-api
```

El Service no crea Pods. Selecciona Pods existentes mediante labels. Si el selector no coincide, el Service existe pero no tendra endpoints.

Antes de avanzar, merece la pena hacer esta lectura cruzada:

```bash
kubectl -n platform-training get deployment platform-api -o yaml
kubectl -n platform-training get service platform-api -o yaml
kubectl -n platform-training get pods --show-labels
```

Busca la misma pareja de labels en tres sitios:

- `spec.selector.matchLabels` del Deployment;
- `metadata.labels` de la plantilla del Pod;
- `spec.selector` del Service.

Esa relacion es la que une la declaracion de alto nivel con los Pods reales y con la red interna.

## Validaciones

Validacion automatizada:

```bash
bash labs/01-kubernetes/validation/validate.sh
```

Validacion HTTP mediante port-forward:

```bash
kubectl -n platform-training port-forward service/platform-api 8080:80
```

En otra terminal:

```bash
curl -i http://127.0.0.1:8080/
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

Despues, detener el port-forward con `Ctrl+C`.

## Logs y eventos

Leer logs del Deployment:

```bash
kubectl -n platform-training logs deployment/platform-api --tail=50
```

Listar eventos recientes:

```bash
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Ver detalle de un Pod:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

## Diagnostico guiado

Antes de resolver un error, clasificalo:

| Pregunta | Si la respuesta es no, mirar primero |
|---|---|
| Existe el objeto declarativo? | `kubectl get` y namespace correcto. |
| El controlador creo objetos derivados? | ReplicaSet, Pods y eventos. |
| Los Pods pueden arrancar? | Imagen, scheduling, eventos y `describe pod`. |
| El Service selecciona Pods? | Labels, selector y endpoints. |
| La aplicacion responde? | Logs y prueba HTTP con port-forward. |

Evita saltar directamente a borrar recursos. En Kubernetes, borrar puede ocultar la diferencia entre estado deseado y estado observado.

### Imagen no descargable

Sintoma:

```text
ImagePullBackOff
ErrImagePull
```

Comandos:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Recuperacion:

1. Corregir `image` en `labs/01-kubernetes/solution/deployment.yaml`.
2. Reaplicar el manifiesto.
3. Revisar el rollout.

```bash
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

### Selector incorrecto

Sintoma:

```text
El Service existe, pero no tiene endpoints.
```

Comandos:

```bash
kubectl -n platform-training get service platform-api -o yaml
kubectl -n platform-training get pods --show-labels
kubectl -n platform-training get endpoints platform-api
```

Recuperacion:

1. Alinear `spec.selector` del Service con las labels de los Pods.
2. Reaplicar `service.yaml`.
3. Validar endpoints.

### Namespace ausente

Sintoma:

```text
namespaces "platform-training" not found
```

Recuperacion:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
```

### CrashLoopBackOff

Sintoma:

```text
El contenedor arranca y termina repetidamente.
```

Comandos:

```bash
kubectl -n platform-training logs deployment/platform-api --previous
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

Recuperacion:

- revisar argumentos, imagen y configuracion inicial;
- reaplicar el manifiesto corregido;
- validar el rollout.

### Contexto equivocado

Sintoma:

```text
Los recursos no aparecen o se aplican a otro cluster.
```

Comandos:

```bash
kubectl config current-context
kubectl get nodes
```

Recuperacion:

- volver al contexto local configurado en la Unidad 00;
- si es necesario, ejecutar de nuevo `platform/environment/microk8s/configure.sh`.

## Limpieza opcional

No limpies el laboratorio si vas a continuar con la Unidad 02 inmediatamente.

La limpieza elimina el namespace y todos los recursos funcionales de la aplicacion:

```bash
kubectl delete namespace platform-training
```

Para reconstruir el estado esperado:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
bash labs/01-kubernetes/validation/validate.sh
```

No uses `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de esta unidad. Ese reset pertenece a recuperacion de plataforma, no al ciclo normal del laboratorio.

## Resultado esperado

Al cerrar la unidad deben existir:

- namespace `platform-training`;
- Deployment `platform-api`;
- ReplicaSet creado por el Deployment;
- dos Pods `Running`;
- Service `platform-api` con endpoints;
- logs inspeccionables;
- manifiestos declarativos en `labs/01-kubernetes/solution/`.

## Conexion con la Unidad 02

La Unidad 02 reutilizara `platform-api`, el namespace `platform-training` y los manifiestos de `labs/01-kubernetes/solution/`.

El siguiente incremento incorporara ConfigMaps, Secrets de laboratorio, variables de entorno, volumenes de configuracion, probes y primeras decisiones de recursos sin cambiar de aplicacion ni introducir Helm todavia.

## Referencias

Estas referencias son lectura guiada. No hace falta leerlas completas antes del laboratorio; usalas para responder las preguntas indicadas y para contrastar comportamiento con fuentes primarias.

### Referencias oficiales

| Tema | Referencia | Uso recomendado |
|---|---|---|
| Conceptos generales | [Kubernetes Concepts](https://kubernetes.io/docs/concepts/) | Identificar que problemas intenta resolver Kubernetes. |
| Arquitectura del cluster | [Cluster Architecture](https://kubernetes.io/docs/concepts/architecture/) | Separar responsabilidades de control plane y nodos. |
| Componentes | [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/) | Relacionar `kubectl apply` con API server, scheduler, controllers y kubelet. |
| Workloads | [Workloads](https://kubernetes.io/docs/concepts/workloads/) | Situar Pods, Deployments y ReplicaSets en la misma familia. |
| Services | [Services, Load Balancing, and Networking](https://kubernetes.io/docs/concepts/services-networking/service/) | Explicar por que el Service selecciona Pods y no Deployments. |
| Labels y selectors | [Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) | Validar el contrato entre Deployment, Pods y Service. |
| `kubectl` | [kubectl reference](https://kubernetes.io/docs/reference/kubectl/) | Consultar comandos de inspeccion y diagnostico. |

Preguntas para la lectura:

- Que parte del control plane recibe una declaracion?
- Que objeto deberia gestionar directamente el alumno y cual deberia observar?
- Por que cambiar labels puede romper trafico aunque los Pods esten `Running`?
- Que senal usarias primero: estado, eventos o logs?

### Referencias conceptuales y complementarias

| Tema | Referencia | Uso recomendado |
|---|---|---|
| Glosario Kubernetes | [Kubernetes Glossary](https://kubernetes.io/docs/reference/glossary/) | Resolver terminos puntuales sin convertirlos en memorieta. |
| MicroK8s | [MicroK8s documentation](https://microk8s.io/docs) | Consultar detalles de la distribucion local, separandolos de la API estandar. |
