# Student notes - Unidad 02

## Proposito

Estas notas explican como una aplicacion Kubernetes deja de ser solo un contenedor en marcha y empieza a ser un workload configurable, observable y gobernado por ciclo de vida. El laboratorio extiende `platform-api`; estas notas explican que representa cada pieza antes de ver como se usa.

Para una capa de referencia más amplia, con criterios profesionales y límites de los mecanismos, consulta `tutorial/02-configuration-lifecycle/student-reference.md`.

La idea central es:

```text
La imagen contiene el software.
El Deployment declara como debe ejecutarse.
ConfigMaps, Secrets, probes y resources describen lo que necesita para operar.
```

## Que se va a cubrir

| Bloque | Que aporta | Nivel en esta unidad |
|---|---|---|
| Configuracion externa | Separar valores modificables de la imagen | Practico |
| ConfigMap | Guardar configuracion no sensible | Practico |
| Secret | Representar datos sensibles de laboratorio | Practico, con limites explicitos |
| Variables de entorno | Inyectar valores al proceso al arrancar | Practico |
| Volumen de configuracion | Entregar ficheros desde un ConfigMap | Practico |
| Probes | Declarar arranque, disponibilidad y salud | Practico |
| Requests y limits | Declarar necesidades y fronteras de CPU/memoria | Practico |
| Rollout | Observar cambios del template del Pod | Practico |
| Eventos y logs | Diagnosticar configuracion, salud y recursos | Practico |

No se cubren Ingress, DNS externo, persistencia real, Helm, Terraform, observabilidad avanzada ni gestion productiva de secretos. Todo eso aparece mas adelante.

## Que representa cada componente

### Componentes de configuracion y datos

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| ConfigMap | Configuracion no sensible almacenada como objeto Kubernetes | Permite cambiar valores o ficheros sin reconstruir la imagen | No es almacenamiento persistente ni lugar para secretos |
| Secret | Datos sensibles o credenciales representados como objeto Kubernetes | Separa secretos de la imagen y del manifiesto principal del Deployment | No es seguridad completa por si mismo; no deben guardarse valores reales en el repo |
| Variable de entorno | Valor entregado al proceso al arrancar | Permite que la aplicacion lea configuracion simple | No se actualiza dentro de un proceso ya arrancado |
| Volumen de ConfigMap | Ficheros proyectados dentro del contenedor | Permite entregar configuracion como archivo | No conserva datos escritos por la aplicacion |
| `stringData` | Forma legible de declarar datos de un Secret en laboratorio | Evita escribir base64 manualmente | No cambia la obligacion de no versionar secretos reales |

### Componentes de salud y recursos

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| `startupProbe` | Comprobacion de arranque inicial | Da tiempo a una aplicacion lenta antes de aplicar otras probes | No decide trafico estable por si sola |
| `readinessProbe` | Comprobacion de disponibilidad para recibir trafico | Evita enviar peticiones a Pods que aun no estan listos | No reinicia contenedores |
| `livenessProbe` | Comprobacion de que el contenedor sigue vivo | Permite reiniciar un contenedor bloqueado | No debe comprobar dependencias externas fragiles |
| `requests` | Recursos minimos que el scheduler reserva conceptualmente | Ayuda a decidir si un Pod cabe en un nodo | No limita el consumo maximo |
| `limits` | Frontera maxima de consumo | Evita que un contenedor consuma sin limite | No garantiza rendimiento |
| Rollout | Transicion controlada entre versiones del template | Permite reemplazar Pods cuando cambia la declaracion | No ocurre por cualquier cambio del cluster |

Una forma corta de recordarlo:

```text
ConfigMap y Secret entregan datos.
Probes deciden trafico y reinicio.
Requests hablan con el scheduler.
Limits hablan con el nodo y el runtime.
Rollout reemplaza Pods cuando cambia el template.
```

## Que vas a construir

Extenderas el `Deployment` de `platform-api` que venia de la Unidad 01.

| Elemento | Valor o cambio |
|---|---|
| ConfigMap | `platform-api-config` |
| Secret de laboratorio | `platform-api-secret` |
| Variables de entorno | `APP_ENV`, `LOG_LEVEL`, `FEATURE_GREETING`, `LAB_CLIENT_ID`, `LAB_API_TOKEN` |
| Fichero configurado | `index.html` montado desde ConfigMap |
| Probes | `startupProbe`, `readinessProbe`, `livenessProbe` HTTP sobre `/` |
| Recursos | `requests` de `25m` CPU y `64Mi`; `limits` de `100m` CPU y `128Mi` |
| Terminacion | `terminationGracePeriodSeconds: 20` |

El resultado sigue siendo la misma aplicacion, el mismo namespace y el mismo Service interno. La diferencia es que ahora el Pod declara de forma explicita como recibe configuracion, como expone salud y con que recursos opera.

## Como se relacionan

La Unidad 02 modifica el template del Pod dentro del Deployment:

```text
ConfigMap ----\
Secret --------\
Probes ---------> Deployment.spec.template -> ReplicaSet -> Pods
Resources -----/
```

El Service sigue seleccionando Pods por labels, pero ahora hay una condicion adicional:

```text
Service selecciona Pods por labels
EndpointSlice solo incluye destinos que estan listos
readinessProbe influye en esa disponibilidad
```

Por eso un Pod puede estar `Running` y aun asi no recibir trafico: ejecutarse no es lo mismo que estar listo.

## Que ocurre cuando aplicas los manifiestos

Cuando aplicas ConfigMap o Secret, creas objetos de datos. Cuando aplicas el Deployment, su template referencia esos objetos y Kubernetes crea Pods que los consumen.

Flujo mental:

```text
1. La API guarda ConfigMap y Secret.
2. La API guarda el Deployment actualizado.
3. Como cambia el template, el Deployment inicia un rollout.
4. Se crea un ReplicaSet nuevo.
5. Los Pods nuevos arrancan con variables, volumen, probes y resources.
6. La startup probe protege el arranque.
7. La readiness probe decide si entran en endpoints.
8. La liveness probe puede reiniciar contenedores bloqueados.
9. Requests influyen en scheduling; limits en consumo durante ejecucion.
```

No todos los cambios tienen el mismo efecto. Cambiar el template del Deployment provoca rollout. Cambiar solo el contenido de un ConfigMap puede no recrear Pods automaticamente; depende de como se consuma y de si reaplicas o reinicias el workload.

## Como comprobar que funciona

Comprueba que existen los objetos nuevos:

```bash
kubectl -n platform-training get configmap platform-api-config
kubectl -n platform-training get secret platform-api-secret
```

Comprueba el rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
```

Comprueba que las probes y recursos estan declarados:

```bash
kubectl -n platform-training describe deployment platform-api
```

Comprueba Pods y endpoints:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training get endpoints platform-api
```

Comprueba logs:

```bash
kubectl -n platform-training logs deployment/platform-api --tail=50
```

La validacion automatizada de la unidad es:

```bash
bash labs/02-configuration-lifecycle/validation/validate.sh
```

## Como diagnosticar los 4 fallos tipicos

### 1. El Pod no arranca por configuracion ausente

Sintoma: Pods en error o eventos indicando que falta una clave de ConfigMap o Secret.

Comprueba:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get configmap platform-api-config -o yaml
kubectl -n platform-training get secret platform-api-secret -o yaml
```

Idea clave: el template referencia nombres y claves. Si el objeto o la clave no existen, el Pod no puede construirse correctamente.

### 2. Cambio el ConfigMap y no veo el cambio

Sintoma: el objeto ConfigMap cambio, pero la aplicacion sigue mostrando contenido anterior.

Comprueba:

```bash
kubectl -n platform-training get configmap platform-api-config -o yaml
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get pods
```

Idea clave: una variable de entorno queda fijada al arrancar el proceso. Un fichero montado puede actualizarse, pero la aplicacion tiene que leerlo de nuevo. Si quieres recrear Pods, cambia el template o reinicia el Deployment de forma controlada.

### 3. El Service no tiene endpoints aunque hay Pods

Sintoma: Pods `Running`, pero endpoints vacios.

Comprueba:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get endpoints platform-api
```

Idea clave: readiness decide si un Pod esta listo para trafico. `Running` solo indica que el contenedor existe.

### 4. El Pod queda `Pending` o el contenedor muere por recursos

Sintoma: Pod pendiente, eventos de scheduling, `OOMKilled` o aplicacion lenta.

Comprueba:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Idea clave: `requests` influyen antes de arrancar, durante scheduling. `limits` actuan durante ejecucion. CPU suele degradar; memoria puede terminar el contenedor.

## Que debes recordar para la Unidad 03

La Unidad 03 introducira entrada HTTP estable desde fuera del cluster. Para entenderla necesitas conservar tres ideas de esta unidad:

| Idea | Por que importa despues |
|---|---|
| Readiness decide trafico | Ingress solo podra enviar trafico util si el Service tiene destinos listos |
| Service sigue siendo interno | Ingress no reemplaza al Service; lo usa como backend |
| Configuracion y probes viven en el template | Cambios relevantes siguen provocando rollouts |

Resumen:

```text
Deployment configura Pods.
Readiness decide si esos Pods entran en endpoints.
Ingress, en la Unidad 03, dependera de esa cadena.
```

## Fuentes de referencia

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Kubernetes - Configuration](https://kubernetes.io/docs/concepts/configuration/) | ConfigMaps, Secrets y resources | Ubicar los mecanismos de configuracion |
| [Kubernetes - ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) | Uso de ConfigMaps en Pods | Entender configuracion no sensible |
| [Kubernetes - Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) | Tipos y consumo de Secrets | Entender limites de seguridad |
| [Kubernetes - Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) | Probes HTTP y comportamiento | Distinguir arranque, disponibilidad y salud |
| [Kubernetes - Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Requests y limits | Entender scheduling y consumo |
| [Kubernetes - Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Rollouts y ReplicaSets | Relacionar cambios de template con Pods nuevos |
