# Student notes - Unidad 01

## Proposito

Estas notas explican lo que necesitas entender para completar la Unidad 01 con criterio, no solo siguiendo comandos. El laboratorio despliega `platform-api`; estas notas explican que piezas de Kubernetes aparecen, como se relacionan y como razonar cuando algo no queda como esperabas.

La imagen usada por `platform-api` se apoya en la referencia de la Unidad 00 sobre contenedores, imagenes y registros: `tutorial/00-environment/student-reference.md`. El laboratorio de acompañamiento `platform/environment/container-images/README.md` ayuda a leer esa referencia de imagen antes de desplegar. Aqui se explica como Kubernetes consume esa imagen, no como se construye.

La idea central es sencilla:

```text
No arrancas contenedores directamente.
Declaras objetos en la API de Kubernetes.
Kubernetes intenta mantener el estado real alineado con esa declaracion.
```

## Que se va a cubrir

La Unidad 01 introduce Kubernetes como sistema declarativo para operar aplicaciones. No cubre todo Kubernetes; cubre el conjunto minimo de conceptos que necesitas para desplegar la primera aplicacion del curso y observarla.

| Bloque | Que aporta | Nivel en esta unidad |
|---|---|---|
| Cluster Kubernetes | Vision general de los componentes que coordinan la plataforma | Conceptual |
| API Server | Entrada unica para `kubectl` y para los controladores | Conceptual y observado indirectamente |
| `etcd` o datastore del cluster | Lugar donde se conserva el estado del cluster | Conceptual |
| Scheduler | Decide en que nodo se ejecuta un Pod | Conceptual |
| Controller Manager | Ejecuta bucles de reconciliacion | Conceptual |
| Kubelet | Agente del nodo que ejecuta Pods | Conceptual |
| Container runtime | Ejecuta los contenedores | Conceptual |
| Namespace | Agrupa los recursos funcionales del curso | Practico |
| Deployment | Declara la aplicacion y sus replicas | Practico |
| ReplicaSet | Mantiene el numero de Pods de una version | Observado |
| Pod | Ejecuta el contenedor real | Observado |
| Service | Da un acceso interno estable hacia los Pods | Practico |
| Labels y selectors | Conectan recursos sin depender de nombres efimeros | Practico |
| Estado, eventos y logs | Primeras herramientas de diagnostico | Practico |

No se implementan todavia ConfigMaps, Secrets, probes, requests, limits, Ingress, persistencia, Helm ni Terraform. Apareceran en unidades posteriores sobre la misma aplicacion.

## Que representa cada componente

Antes de pensar en `platform-api`, conviene entender que representa cada pieza en Kubernetes. Esta seccion es academica: no describe todavia lo que vas a construir, sino el papel conceptual de cada componente.

### Componentes del cluster

Un cluster Kubernetes no es solo un grupo de maquinas. Es un sistema de coordinacion que recibe declaraciones, guarda estado, toma decisiones y ejecuta workloads.

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| Cluster Kubernetes | El sistema completo de control y ejecucion | Permite operar aplicaciones como estado declarado, no como procesos sueltos en una maquina | No es un unico servidor, aunque en MicroK8s todo viva en una maquina |
| `kube-apiserver` | La puerta de entrada y contrato comun del cluster | Centraliza todas las operaciones: usuarios, controladores y nodos hablan mediante la API | No ejecuta contenedores |
| `etcd` o datastore | La memoria persistente del cluster | Conserva objetos, configuracion y estado necesario para que el cluster recuerde que debe existir | No es una base de datos de la aplicacion |
| `kube-scheduler` | El decisor de ubicacion de Pods | Responde a la pregunta "en que nodo puede ejecutarse este Pod?" | No mantiene Pods vivos una vez asignados |
| `kube-controller-manager` | El conjunto de bucles de control | Compara estado deseado y observado, y actua para reducir diferencias | No es un operador humano ni ejecuta comandos una sola vez |
| `kubelet` | El agente de cada nodo | Convierte una asignacion de Pod en contenedores reales ejecutandose en ese nodo | No decide por si solo que aplicaciones desplegar |
| Container runtime | El motor que ejecuta contenedores | Descarga imagenes y arranca contenedores siguiendo lo que pide el kubelet | No entiende Deployments ni Services |
| `kube-proxy` | La pieza de red asociada a Services | Hace posible que un Service tenga una direccion estable hacia Pods cambiantes | No publica por si solo la aplicacion fuera del cluster |

La division importante es esta:

```text
Control plane
  recibe declaraciones, guarda estado y toma decisiones

Nodos
  ejecutan Pods y reportan lo que ocurre
```

En un laboratorio local esa separacion puede parecer artificial porque todo corre cerca. En un cluster real permite escalar, recuperar fallos y mover workloads sin que el operador gestione procesos uno a uno.

### Objetos de Kubernetes

Los objetos son registros en la API de Kubernetes. Algunos describen lo que quieres que exista; otros aparecen como consecuencia de controladores.

| Objeto | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| `Namespace` | Un ambito logico dentro del cluster | Agrupa recursos y evita mezclar nombres y operaciones | No es un cluster separado ni una frontera completa de seguridad |
| `Deployment` | La declaracion de una aplicacion replicada | Permite decir que version, plantilla y numero de replicas quieres mantener | No es el proceso que ejecuta la aplicacion |
| `ReplicaSet` | Un conjunto de Pods equivalentes de una misma plantilla | Mantiene el numero de Pods que pertenecen a una version concreta | No suele ser el objeto que editas directamente |
| `Pod` | La unidad minima desplegable de Kubernetes | Agrupa uno o mas contenedores que comparten ciclo de vida y red | No es simplemente "un contenedor" |
| `Service` | Una identidad de red estable para un conjunto de Pods | Evita depender de IPs o nombres de Pods efimeros | No apunta al Deployment ni crea Pods |
| `Endpoints` / `EndpointSlice` | La lista calculada de destinos reales de un Service | Permite observar que Pods recibiran trafico | No se declara como intencion principal en esta unidad |
| Label | Un par clave-valor asociado a un objeto | Permite clasificar y seleccionar recursos | No es un identificador unico |
| Selector | Una consulta sobre labels | Permite que un objeto encuentre otros objetos sin conocer sus nombres | No es una referencia directa |

Una forma sencilla de recordarlo:

```text
Deployment expresa intencion.
ReplicaSet mantiene cantidad.
Pod ejecuta.
Service da estabilidad.
Labels conectan.
Endpoints muestran el resultado.
```

Esta diferencia entre representacion conceptual y uso practico es importante. En el laboratorio veras estos objetos con nombres concretos, pero esos nombres no son el concepto. `platform-api` es solo el caso de estudio.

## Que vas a construir

Vas a convertir un cluster MicroK8s ya preparado en la primera version funcional de la solucion evolutiva del curso.

El resultado final sera:

| Elemento | Valor |
|---|---|
| Aplicacion | `platform-api` |
| Namespace | `platform-training` |
| Workload principal | `deployment/platform-api` |
| Replicas | `2` |
| Imagen inicial | `nginxinc/nginx-unprivileged:1.27.4-alpine` |
| Puerto del contenedor | `8080` |
| Service interno | `service/platform-api` |
| Puerto del Service | `80` |

La aplicacion es deliberadamente simple. Eso permite que el foco este en Kubernetes: declaracion, reconciliacion, seleccion por labels, estado observado y diagnostico.

La construccion de imagenes propias, el uso de registros locales o privados, tags inmutables, digests, SBOM y firma quedan fuera de esta unidad. La base conceptual esta en `tutorial/00-environment/student-reference.md` y se retomara cuando el itinerario llegue a CI/CD y supply chain security.

## Las piezas del cluster en esta unidad

Antes de mirar los objetos del laboratorio, conviene ubicar las responsabilidades principales de Kubernetes.

```text
kubectl
  -> kube-apiserver
       -> estado persistido en etcd/datastore
       -> controladores
       -> scheduler
            -> nodo
                 -> kubelet
                 -> container runtime
                 -> Pods
```

| Componente | Responsabilidad | Que debes recordar ahora |
|---|---|---|
| `kube-apiserver` | Recibe y valida peticiones contra la API de Kubernetes | `kubectl apply` habla con la API, no con el nodo directamente |
| `etcd` o datastore | Guarda el estado del cluster | El cluster conserva objetos; los ficheros YAML son solo la declaracion que envias |
| `kube-scheduler` | Asigna Pods pendientes a nodos adecuados | En esta unidad solo hay un nodo local, pero la decision sigue existiendo |
| `kube-controller-manager` | Ejecuta controladores que comparan estado deseado y observado | Aqui veras el efecto en Deployment, ReplicaSet y Pods |
| `kubelet` | Agente del nodo que materializa Pods asignados | Es quien se ocupa de que el Pod exista en el nodo |
| Container runtime | Ejecuta los contenedores dentro de los Pods | Kubernetes no ejecuta contenedores "a mano"; delega en el runtime |
| `kube-proxy` | Mantiene reglas de red para Services | Permite que el Service tenga una IP y un puerto estables dentro del cluster |

En MicroK8s local muchas de estas piezas conviven en la misma maquina. Eso no cambia el modelo: conceptualmente siguen siendo responsabilidades separadas. Esa separacion sera importante cuando el curso evolucione hacia clusters gestionados.

## Las piezas que aparecen en el laboratorio

La Unidad 01 usa seis piezas principales. Algunas las declaras en YAML; otras las crea Kubernetes como consecuencia.

| Pieza | La declaras? | Para que sirve | Como la observas |
|---|---|---|---|
| `Namespace` | Si | Agrupa los recursos del curso | `kubectl get ns` |
| `Deployment` | Si | Declara la aplicacion, imagen, template y numero de replicas | `kubectl -n platform-training get deploy` |
| `ReplicaSet` | No directamente | Mantiene el numero de Pods de una version del template | `kubectl -n platform-training get rs` |
| `Pod` | No directamente | Ejecuta el contenedor real | `kubectl -n platform-training get pods` |
| `Service` | Si | Ofrece un acceso interno estable hacia Pods seleccionados | `kubectl -n platform-training get svc` |
| `Endpoints` | No | Muestra los destinos reales del Service | `kubectl -n platform-training get endpoints` |

La diferencia entre "declarar" y "observar" es clave. En esta unidad no escribes manifiestos de Pods ni de ReplicaSets porque quieres aprender a trabajar con controladores de nivel superior.

## Como se relacionan

La cadena principal es esta:

```text
Namespace
  contiene
Deployment
  crea y controla
ReplicaSet
  crea y controla
Pods

Service
  selecciona Pods por labels
Endpoints
  muestran los Pods seleccionados
```

Otra forma de verlo:

```text
Deployment -> ReplicaSet -> Pods
Service --labels/selectors--> Pods
Service -> Endpoints
```

Hay dos tipos de relacion que no debes mezclar.

| Relacion | Ejemplo | Implicacion |
|---|---|---|
| Creacion y control | Deployment -> ReplicaSet -> Pods | Si un Pod desaparece, Kubernetes intenta reemplazarlo |
| Seleccion por labels | Service -> Pods | El Service no crea Pods; solo encuentra los que coinciden |

Este punto explica muchos fallos iniciales. Un Service no apunta al Deployment, aunque se llamen igual. El Service mira labels de Pods. Si el selector del Service no coincide con las labels reales de los Pods, el Service existe pero no tiene destinos.

## Que ocurre cuando aplicas los manifiestos

Cuando ejecutas:

```bash
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
```

no estas arrancando contenedores directamente. Estas enviando una declaracion a la API de Kubernetes.

El flujo mental es:

```text
1. `kubectl` envia el manifiesto al kube-apiserver.
2. La API valida el objeto y lo guarda como estado deseado.
3. El controlador de Deployment observa que existe un Deployment nuevo.
4. El controlador crea o actualiza un ReplicaSet.
5. El ReplicaSet crea Pods hasta alcanzar el numero declarado.
6. El scheduler asigna esos Pods a un nodo.
7. El kubelet del nodo pide al runtime que ejecute los contenedores.
8. Los Pods reportan estado.
9. El Service selecciona Pods por labels.
10. Kubernetes calcula endpoints para el Service.
```

Por eso `kubectl apply` puede terminar correctamente aunque los Pods aun esten creandose. El comando confirma que la API acepto la declaracion, no que todo el sistema haya terminado de converger.

## Estado deseado y estado observado

Kubernetes trabaja comparando dos cosas:

| Concepto | Donde aparece | Quien lo escribe |
|---|---|---|
| Estado deseado | `spec` | Tu, en el manifiesto |
| Estado observado | `status` | Kubernetes |

Ejemplo:

```text
spec.replicas: 2
```

significa "quiero dos replicas". No significa "hay dos replicas funcionando ahora mismo". Para saber que ocurre de verdad necesitas consultar el estado observado:

```bash
kubectl -n platform-training get deployment platform-api
kubectl -n platform-training get pods
```

Esta separacion es la base del diagnostico. Si el manifiesto no dice lo que creias, el problema esta en la declaracion. Si el manifiesto dice lo correcto pero el estado observado no converge, hay que mirar eventos, Pods, imagen, scheduling o labels.

## Como comprobar que funciona

Primero comprueba que los objetos existen:

```bash
kubectl -n platform-training get deploy,rs,pods,svc,endpoints
```

Despues comprueba el rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
```

Resultado esperado:

```text
deployment "platform-api" successfully rolled out
```

Comprueba que hay Pods:

```bash
kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api
```

Resultado esperado:

```text
Dos Pods de platform-api aparecen en estado Running.
```

Comprueba que el Service tiene destinos:

```bash
kubectl -n platform-training get endpoints platform-api
```

Resultado esperado:

```text
El Service tiene una o mas direcciones de Pod asociadas.
```

Para probar HTTP desde tu maquina, el laboratorio usa un port-forward temporal:

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

El Service de esta unidad es interno (`ClusterIP`). Que no puedas abrirlo directamente desde el navegador sin `port-forward` no es un fallo; es el alcance normal de la unidad.

## Como diagnosticar los 4 fallos tipicos

### 1. No aparece nada

Sintoma:

```bash
kubectl get pods
```

no muestra los Pods esperados.

Primera comprobacion:

```bash
kubectl get namespaces
kubectl -n platform-training get pods
```

Causa habitual: estas mirando el namespace equivocado o el namespace aun no existe.

Idea clave: los recursos de la unidad viven en `platform-training`. Acostumbrate a indicar `-n platform-training` de forma explicita.

### 2. El Deployment existe, pero no hay dos Pods Running

Sintoma:

```bash
kubectl -n platform-training get deployment platform-api
kubectl -n platform-training get pods
```

muestra menos Pods de los esperados, Pods en `Pending`, `ImagePullBackOff` o reinicios.

Primera comprobacion:

```bash
kubectl -n platform-training describe deployment platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

Causas habituales:

- la imagen no se puede descargar;
- el Pod no puede programarse en el nodo;
- el contenedor arranca y termina;
- el rollout aun no ha terminado.

Idea clave: `apply` aceptado no significa "aplicacion funcionando"; significa "declaracion registrada".

### 3. Los Pods estan Running, pero el Service no tiene endpoints

Sintoma:

```bash
kubectl -n platform-training get endpoints platform-api
```

no muestra direcciones.

Primera comprobacion:

```bash
kubectl -n platform-training get pods --show-labels
kubectl -n platform-training get service platform-api -o yaml
```

Causa habitual: el selector del Service no coincide con las labels reales de los Pods.

Idea clave: el Service no apunta al Deployment. El Service selecciona Pods por labels. Si las labels y el selector no coinciden, no hay trafico aunque todo parezca creado.

### 4. Todo parece correcto, pero la aplicacion no responde

Sintoma:

```bash
curl -i http://127.0.0.1:8080/
```

no responde o falla durante la prueba con port-forward.

Primera comprobacion:

```bash
kubectl -n platform-training get endpoints platform-api
kubectl -n platform-training logs deployment/platform-api --tail=50
kubectl -n platform-training port-forward service/platform-api 8080:80
```

Causas habituales:

- el port-forward no esta activo;
- el puerto local ya esta ocupado;
- el Service no tiene endpoints;
- el contenedor no esta sirviendo en el puerto esperado.

Idea clave: no empieces por logs si aun no sabes si el Service tiene destinos. Primero comprueba la cadena: Deployment, Pods, Service, endpoints, respuesta HTTP.

## Que debes recordar para la Unidad 02

La Unidad 02 no empieza desde cero. Extiende exactamente esta base:

```text
Deployment -> ReplicaSet -> Pods
Service -> endpoints
```

Lo que viene despues encaja asi:

| Unidad 02 introduce | Donde encaja |
|---|---|
| ConfigMaps | En la configuracion que consume el Pod |
| Secrets de laboratorio | En datos sensibles simulados que consume el Pod |
| Variables de entorno | En el template del Pod dentro del Deployment |
| Volumenes de configuracion | En el template del Pod |
| Probes | En la decision de si un Pod esta arrancado, vivo o listo |
| Requests y limits | En la planificacion y control de recursos del Pod |

La idea mas importante para continuar:

```text
Cambiar el template del Deployment cambia el molde de los Pods.
Cuando cambia el molde, Kubernetes crea Pods nuevos mediante un rollout.
```

Si entiendes eso, ConfigMaps, Secrets, probes y recursos dejaran de parecer campos YAML sueltos y empezaran a verse como modificaciones concretas del mismo modelo.

## Fuentes de referencia

Estas referencias sirven para reforzar los conceptos de la unidad. No sustituyen al laboratorio.

| Fuente | Que leer | Para que sirve |
|---|---|---|
| Kubernetes Documentation - Concepts | Secciones introductorias de arquitectura y objetos | Ubicar API, estado deseado, control plane y nodos |
| Kubernetes Documentation - Deployments | Concepto de Deployment, ReplicaSet y rollout | Entender por que no gestionamos Pods manualmente |
| Kubernetes Documentation - Pods | Modelo de Pod y ciclo de vida | Distinguir Pod de contenedor |
| Kubernetes Documentation - Services | Service, selectors y endpoints | Entender como se da acceso estable a Pods efimeros |
| Kubernetes Documentation - Labels and Selectors | Labels, selectors y consultas | Evitar el error de pensar que los recursos se conectan por nombre |
| Kubernetes Documentation - `kubectl` | `get`, `describe`, `logs`, `rollout status` | Mejorar la observacion y diagnostico |

Preguntas que deberias poder responder despues de estas lecturas:

- Que parte del objeto expresa estado deseado?
- Que componente recibe las peticiones de `kubectl`?
- Por que un Deployment crea ReplicaSets?
- Por que no debes depender del nombre ni de la IP de un Pod?
- Como decide un Service que Pods reciben trafico?
- Que diferencia hay entre estado, eventos y logs?
