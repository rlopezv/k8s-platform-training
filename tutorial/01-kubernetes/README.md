# Unidad 01 - Fundamentos operativos y primera aplicacion

## Contexto

La Unidad 00 dejo preparado un entorno local con Ubuntu 24.04 LTS sobre WSL2, MicroK8s, Kubernetes, `kubectl`, Helm y Terraform. Hasta este punto el cluster existe, pero el curso no tiene todavia una aplicacion, un namespace funcional ni workloads propios.

Esta unidad convierte ese cluster vacio en la primera version operativa de la solucion evolutiva del curso. El resultado sera una aplicacion HTTP minima llamada `platform-api`, desplegada mediante manifiestos Kubernetes declarativos en el namespace `platform-training`.

Helm y Terraform seguirán instalados como herramientas base, pero no se usan para desplegar esta unidad. Primero se trabaja con YAML y `kubectl` para ver directamente que recursos crea Kubernetes y como se diagnostican.

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

Kubernetes funciona como un sistema de reconciliacion. El usuario declara un estado deseado mediante objetos. El cluster compara continuamente ese deseo con el estado real y ejecuta cambios hasta aproximarlos.

En un cluster hay dos planos de responsabilidad:

| Plano | Responsabilidad |
|---|---|
| Control plane | Recibe declaraciones, guarda estado, decide ubicacion de Pods y ejecuta controladores. |
| Nodos worker | Ejecutan contenedores, conectan red de Pods y reportan estado al control plane. |

En MicroK8s local, esas responsabilidades conviven normalmente en la misma maquina. Conceptualmente siguen siendo responsabilidades separadas, y esa separacion sera importante cuando el laboratorio evolucione hacia AKS y EKS.

## Componentes principales

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
