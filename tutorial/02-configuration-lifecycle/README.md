# Unidad 02 - Configuracion, secretos y ciclo de vida

## Guia pedagogica de la unidad

Esta unidad trata sobre el contrato entre una aplicacion y la plataforma que la ejecuta.

En la Unidad 01 Kubernetes ya podia mantener dos Pods y darles un Service interno. Eso demuestra que el workload existe, pero todavia dice muy poco sobre como debe operar. Una plataforma necesita mas informacion para tomar buenas decisiones: que datos recibe la aplicacion, que valores no deben tratarse como configuracion publica, cuando una instancia esta lista para recibir trafico, cuando debe reiniciarse y cuantos recursos necesita para ser planificada.

La Unidad 02 cubre esa capa de madurez:

- configuracion externa mediante ConfigMap;
- valores sensibles simulados mediante Secret de laboratorio;
- inyeccion de datos por variables de entorno y volumen;
- probes como lenguaje de salud entre kubelet y contenedor;
- readiness como condicion para entrar o salir de EndpointSlice;
- requests y limits como primer contrato de capacidad;
- rollouts cuando cambia el template de Pod;
- recuperacion declarativa sin resetear el cluster.

El laboratorio muestra todos esos conceptos en `platform-api`, pero el objetivo no es aprender "un YAML mas largo". El objetivo es entender que un Pod no deberia ser una caja negra. Debe declarar sus necesidades y sus senales para que Kubernetes pueda operarlo.

Para estudiar con mas detalle ConfigMap, Secret, probes, requests, limits, rollouts y EndpointSlice, usa `tutorial/02-configuration-lifecycle/student-notes.md`.

## Mapa de aprendizaje

| Concepto | Pregunta que responde | Error que evita |
|---|---|---|
| ConfigMap | Que datos no sensibles cambian por despliegue? | Reconstruir imagenes por cada cambio de configuracion |
| Secret | Que datos no deberian tratarse como texto publico? | Versionar credenciales reales o imprimirlas para diagnosticar |
| Variables de entorno | Que valores necesita el proceso al arrancar? | Ocultar configuracion dentro de la imagen |
| Volumen de configuracion | Que archivo debe montar Kubernetes en el contenedor? | Confundir configuracion montada con estado persistente |
| Startup probe | La aplicacion ha terminado de arrancar? | Reiniciar demasiado pronto aplicaciones lentas |
| Readiness probe | Esta instancia debe recibir trafico? | Enviar peticiones a Pods que aun no estan preparados |
| Liveness probe | El contenedor debe reiniciarse? | Dejar vivo un proceso bloqueado sin recuperacion local |
| Requests | Que reserva minima necesita el scheduler? | Planificar sin declarar necesidades |
| Limits | Que consumo maximo se permite al contenedor? | Dejar consumo sin ningun limite en el nodo |

## Pregunta central

La pregunta de la unidad es:

```text
Que debe declarar un workload para que Kubernetes pueda configurarlo, observar su salud y tomar decisiones basicas de ejecucion?
```

Si el alumno puede responderla, la Unidad 03 puede centrarse en red e ingreso sin tener que corregir primero una aplicacion muda, sin salud y sin limites.

## Contexto

La Unidad 01 dejo una primera version de `platform-api`: un Deployment con dos replicas y un Service interno en el namespace `platform-training`. Ese estado ya permite comprobar que Kubernetes crea Pods, mantiene replicas y expone una direccion estable dentro del cluster.

En una plataforma real, sin embargo, desplegar una imagen no basta. Una aplicacion necesita configuracion, algun tratamiento de valores sensibles, senales de salud y limites iniciales de consumo. Esta unidad incorpora esas capacidades sin cambiar de aplicacion, sin crear otro namespace funcional y sin introducir Helm, Terraform, Ingress ni observabilidad avanzada.

La idea central es:

```text
La imagen contiene el binario o servidor base.
Kubernetes inyecta configuracion y reglas de operacion.
El Deployment cambia su template de Pod.
Kubernetes ejecuta un rollout para acercarse al nuevo estado deseado.
```

## Problema real que resuelve

Una aplicacion empaquetada en una imagen no deberia reconstruirse cada vez que cambia un mensaje, un modo de ejecucion, un endpoint o una credencial. Tampoco deberia recibir trafico antes de estar lista, reiniciarse por un arranque lento normal ni consumir recursos sin ningun contrato con el nodo.

La Unidad 02 convierte el Deployment minimo de la Unidad 01 en un workload operable. La aplicacion empieza a declarar que necesita de la plataforma y la plataforma empieza a tomar decisiones con esa informacion.

## Por que aparece en este punto

Primero hacia falta entender que Kubernetes mantiene Pods mediante Deployments y los expone mediante Services. Ahora que esa base existe, tiene sentido introducir los contratos que hacen que un workload sea configurable, observable desde Kubernetes y menos ambiguo ante fallos.

Ingress, Gateway API, Helm, Terraform y gestores externos de secretos aparecen mas adelante porque todos ellos dependen de una idea previa: el Pod debe declarar correctamente su configuracion, salud y recursos.

## Objetivos

Al finalizar la unidad podras:

- extender los manifiestos existentes de `platform-api` sin sustituir la aplicacion;
- crear un ConfigMap para configuracion no sensible;
- crear un Secret de laboratorio con valores ficticios;
- consumir configuracion mediante variables de entorno y volumen montado;
- configurar `startupProbe`, `readinessProbe` y `livenessProbe`;
- explicar como readiness afecta a los endpoints de un Service;
- declarar requests y limits iniciales de CPU y memoria;
- observar rollouts producidos por cambios declarativos;
- diagnosticar errores de ConfigMap, Secret, probes y recursos;
- recuperar el laboratorio a un estado conocido sin resetear MicroK8s.

## Conocimientos previos

Necesitas haber completado:

- Unidad 00, con MicroK8s y `kubectl` operativos;
- Unidad 01, con `platform-api` desplegada;
- comandos basicos `kubectl apply`, `get`, `describe`, `logs` y `rollout status`;
- relacion entre Deployment, ReplicaSet, Pod y Service.

Trabaja desde la raiz del repositorio:

```bash
pwd
```

Resultado esperado:

```text
/home/ramon/git/k8s-platform-training
```

## Relacion con la Unidad 01

Esta unidad no modifica `labs/01-kubernetes/solution/`. Esa ruta sigue siendo la evidencia del cierre de la Unidad 01.

La nueva base queda en:

```text
labs/02-configuration-lifecycle/solution/
```

Se conservan:

| Elemento | Valor |
|---|---|
| Aplicacion | `platform-api` |
| Namespace | `platform-training` |
| Imagen | `nginxinc/nginx-unprivileged:1.27.4-alpine` |
| Service | `platform-api`, `ClusterIP`, puerto `80` |
| Labels selector | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` |

Se incorporan:

| Capacidad | Recurso o campo |
|---|---|
| Configuracion no sensible | `ConfigMap/platform-api-config` |
| Valores sensibles de laboratorio | `Secret/platform-api-secret` |
| Variables de entorno | `env.valueFrom.configMapKeyRef` y `env.valueFrom.secretKeyRef` |
| Contenido montado | volumen desde ConfigMap |
| Salud | `startupProbe`, `readinessProbe`, `livenessProbe` |
| Recursos | `resources.requests` y `resources.limits` |

## Modelo mental de la unidad

La Unidad 02 organiza el Deployment como un contrato entre aplicacion y plataforma:

```text
Imagen
  -> que software se ejecuta
ConfigMap y Secret
  -> que datos recibe el software al arrancar o leer archivos
Probes
  -> como informa salud y disponibilidad
Requests y limits
  -> que recursos pide y que consumo queda acotado
Deployment
  -> como cambia el template de Pod y se ejecuta el rollout
Service
  -> que Pods listos reciben trafico
```

Cuando el contrato cambia dentro de `.spec.template`, Kubernetes crea una nueva revision del Deployment. Cuando cambia un dato consumido por volumen desde ConfigMap, puede actualizarse en los Pods existentes, pero eso no equivale automaticamente a un rollout trazable. En operacion real se suele preferir un cambio declarativo visible y una estrategia de despliegue controlada.

## Estado inicial

Valida el entorno heredado:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/01-kubernetes/validation/validate.sh
kubectl -n platform-training get deploy,rs,pods,svc,endpoints
kubectl -n platform-training get configmap,secret
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
deployment/platform-api esta disponible.
service/platform-api existe.
Antes de aplicar esta unidad no hay ConfigMaps ni Secrets de aplicacion creados por el curso.
```

Si el Deployment no existe, recupera la Unidad 01:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
bash labs/01-kubernetes/validation/validate.sh
```

## Configuracion en Kubernetes

Una imagen de contenedor deberia ser portable. Si cada entorno necesita una imagen diferente solo para cambiar un mensaje, un endpoint o un modo de ejecucion, la plataforma pierde trazabilidad y empieza a mezclar construccion con operacion.

Kubernetes separa esa responsabilidad con varios mecanismos:

| Necesidad | Mecanismo en esta unidad | Uso |
|---|---|---|
| Configuracion visible y no sensible | ConfigMap | Modo de entorno, nivel de log y contenido HTML de laboratorio. |
| Valor que simula informacion sensible | Secret | Identificador y token ficticios para practicar referencias. |
| Parametro leido al arrancar | Variable de entorno | Valores disponibles dentro del contenedor. |
| Archivo de configuracion | Volumen desde ConfigMap | `index.html` montado sobre el contenido servido por nginx. |

Un ConfigMap no es para credenciales. Un Secret tampoco convierte automaticamente un dato en seguro para cualquier contexto. En esta unidad los valores del Secret son ficticios y estan versionados solo porque son material didactico.

## Configuracion, secreto, estado y codigo

Una confusion habitual es llamar "configuracion" a cualquier dato que no esta dentro del binario. Para operar plataformas conviene separar responsabilidades:

| Tipo | Que representa | Ejemplo | Tratamiento en esta unidad |
|---|---|---|---|
| Codigo o imagen | Software construido y versionado como artefacto ejecutable. | Imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`. | No cambia. |
| Configuracion | Dato no sensible que cambia por entorno o despliegue. | `APP_ENV`, `LOG_LEVEL`, `index.html` de laboratorio. | ConfigMap. |
| Secreto | Dato sensible o simulado como sensible. | Token ficticio de laboratorio. | Secret con valores no reales. |
| Estado | Datos producidos por la aplicacion durante su ejecucion. | Base de datos, archivos persistentes, cola. | No se implementa; se difiere a persistencia. |

El criterio practico es preguntar: si cambia este dato, debo reconstruir la imagen?, puedo versionarlo visible?, se puede regenerar?, debe sobrevivir al Pod? Cada respuesta lleva a un mecanismo distinto.

## Antecedente Twelve-Factor

El enfoque de configuracion externa conecta con el principio de Twelve-Factor App que recomienda separar configuracion del codigo. Kubernetes no inventa esa idea, pero la convierte en recursos declarativos: ConfigMaps, Secrets, variables de entorno y volumenes.

El matiz importante es que Kubernetes no decide por si solo que es seguro, que es secreto o que debe rotar. La plataforma ofrece mecanismos; el equipo define politicas. Por eso esta unidad usa Secrets solo como primer contacto y deja gestores externos, rotacion, cifrado operativo y RBAC avanzado para unidades posteriores.

## Manifiestos de la unidad

La solucion final contiene:

```text
labs/02-configuration-lifecycle/solution/namespace.yaml
labs/02-configuration-lifecycle/solution/configmap.yaml
labs/02-configuration-lifecycle/solution/secret.yaml
labs/02-configuration-lifecycle/solution/deployment.yaml
labs/02-configuration-lifecycle/solution/service.yaml
```

Revisa el ConfigMap:

```bash
sed -n '1,120p' labs/02-configuration-lifecycle/solution/configmap.yaml
```

Observa que contiene claves sencillas y un `index.html`. Ese archivo se montara dentro del contenedor como contenido servido por `nginx`.

Revisa el Secret sin tratar sus valores como credenciales reales:

```bash
sed -n '1,120p' labs/02-configuration-lifecycle/solution/secret.yaml
```

Los valores usan `stringData` para que el manifiesto sea legible en el laboratorio. Kubernetes los almacenara en el campo `data` al crear el recurso. No uses este patron para versionar secretos reales.

## Deployment evolucionado

El Deployment de Unidad 02 conserva la identidad operativa de la aplicacion, pero cambia el template de Pod. Ese detalle importa: cuando cambia `.spec.template`, Kubernetes crea un nuevo ReplicaSet y ejecuta un rollout.

Revisa los cambios principales:

```bash
sed -n '1,220p' labs/02-configuration-lifecycle/solution/deployment.yaml
```

Fijate en:

- `env`, con valores desde ConfigMap y Secret;
- `volumeMounts`, con `index.html` desde ConfigMap;
- `startupProbe`, para proteger aplicaciones con arranque lento;
- `readinessProbe`, para decidir si un Pod debe recibir trafico;
- `livenessProbe`, para reiniciar un contenedor que queda vivo pero no sano;
- `resources`, para declarar requests y limits.

## Probes

Las probes son preguntas que el kubelet hace al contenedor.

| Probe | Pregunta | Efecto |
|---|---|---|
| `startupProbe` | La aplicacion ya termino de arrancar? | Mientras falla, evita que liveness mate el contenedor demasiado pronto. |
| `readinessProbe` | Esta instancia puede recibir trafico ahora? | Si falla, el Pod deja de aparecer como endpoint listo del Service. |
| `livenessProbe` | El contenedor sigue sano o debe reiniciarse? | Si falla repetidamente, el kubelet reinicia el contenedor. |

En esta unidad las tres probes consultan `/` en el puerto nombrado `http`. La aplicacion arranca rapido, pero el patron queda preparado para workloads mas lentos.

## Ciclo de vida de Pods

Un Pod no pasa simplemente de "creado" a "funcionando". Kubernetes observa fases, condiciones y eventos. En esta unidad interesan tres momentos:

| Momento | Que ocurre | Senal relevante |
|---|---|---|
| Arranque | El contenedor empieza y puede necesitar tiempo antes de responder. | `startupProbe` y eventos. |
| Entrada en servicio | El Pod puede estar `Running` pero todavia no debe recibir trafico. | `readinessProbe`, condicion `Ready` y EndpointSlice. |
| Recuperacion local | Un contenedor puede quedar vivo pero no sano. | `livenessProbe` y contador `RESTARTS`. |

Readiness es un contrato de trafico: afecta a si el Service considera el Pod como endpoint listo. Liveness es un contrato de recuperacion local: decide si el kubelet reinicia un contenedor. Startup protege el arranque para que liveness no castigue una aplicacion que todavia esta inicializando.

## Requests y limits

Los recursos iniciales son modestos para un laboratorio local:

```yaml
resources:
  requests:
    cpu: 25m
    memory: 64Mi
  limits:
    cpu: 100m
    memory: 128Mi
```

El request indica lo que Kubernetes reserva para planificar el Pod. El limit acota cuanto puede consumir el contenedor. No es una medicion de consumo real ni un mecanismo de escalado automatico.

Como modelo mental:

- `requests` hablan principalmente con el scheduler;
- `limits` hablan principalmente con el nodo y el runtime;
- el consumo real se observara con metricas en unidades posteriores;
- HPA y KEDA no aparecen todavia porque requieren senales de escalado y politica adicional.

Un request demasiado alto puede dejar Pods en `Pending`. Un limit demasiado bajo puede provocar lentitud, throttling de CPU o terminaciones por memoria. En esta unidad se eligen valores conservadores porque el objetivo es aprender el contrato, no optimizar capacidad.

## Decisiones de diseno y trade-offs

| Decision | Motivo | Trade-off |
|---|---|---|
| Mantener `platform-api` | Conserva continuidad del laboratorio evolutivo. | La imagen simple no cubre todos los casos reales de aplicacion. |
| Usar ConfigMap para contenido HTML | Permite ver un efecto observable sin reconstruir imagen. | No representa aun una estrategia completa de release de frontend. |
| Usar Secret ficticio versionado | Practica la API sin riesgo de credenciales reales. | No enseña todavia rotacion ni integracion con vault externo. |
| Configurar probes HTTP a `/` | Mantiene el ejemplo legible y validable. | En sistemas reales cada probe deberia mapear una condicion mas especifica. |
| Definir requests y limits modestos | Evita saturar el laboratorio local. | No sustituye capacity planning ni observabilidad de consumo. |

## Procedimiento declarativo

Aplica primero el namespace:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
```

Aplica configuracion y secreto ficticio:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
```

Aplica el Deployment y el Service:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
```

Observa el rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training rollout history deployment/platform-api
kubectl -n platform-training get deploy,rs,pods
```

Resultado esperado:

```text
deployment "platform-api" successfully rolled out
Nuevos Pods quedan Running y Ready.
```

## Validaciones

Comprueba ConfigMap y Secret sin imprimir valores sensibles:

```bash
kubectl -n platform-training get configmap platform-api-config
kubectl -n platform-training describe configmap platform-api-config
kubectl -n platform-training get secret platform-api-secret
kubectl -n platform-training describe secret platform-api-secret
```

Comprueba probes y resources declarados:

```bash
kubectl -n platform-training get deployment platform-api -o yaml
```

Comprueba que el Service conserva endpoints listos:

```bash
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Ejecuta la validacion automatizada:

```bash
bash labs/02-configuration-lifecycle/validation/validate.sh
```

Resultado esperado:

```text
Unit 02 validation summary: 0 failure(s), 0 warning(s).
```

## Prueba HTTP local

Abre un port-forward:

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

El cuerpo de la respuesta debe incluir:

```text
Unidad 02: configuracion externa desde ConfigMap.
```

Deten el port-forward con `Ctrl+C`.

## Diagnostico

Antes de corregir, identifica que contrato se rompio:

| Sintoma | Contrato sospechoso |
|---|---|
| Pod no se crea o queda esperando | Recursos, scheduling, ConfigMap o Secret ausente. |
| Pod `Running` pero no `Ready` | Readiness o dependencia de arranque. |
| Service sin endpoints listos | Readiness o selector. |
| Reinicios repetidos | Liveness, proceso del contenedor o limite de memoria. |
| Cambio aplicado pero sin nuevo ReplicaSet | Cambio fuera de `.spec.template`, por ejemplo solo ConfigMap. |

No imprimas ni decodifiques Secrets para diagnosticar esta unidad. `get` y `describe` bastan para confirmar existencia y claves.

### ConfigMap ausente

Sintoma posible:

```text
Pods nuevos no arrancan porque falta platform-api-config.
```

Diagnostico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Recuperacion:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

### Secret ausente

Sintoma posible:

```text
Pods nuevos no arrancan porque falta platform-api-secret o una clave esperada.
```

Diagnostico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get secret platform-api-secret
```

Recuperacion:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

### Readiness falla

Sintoma posible:

```text
Pods Running pero no Ready; el Service no tiene endpoints listos.
```

Diagnostico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Recuperacion:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

### Liveness demasiado agresiva

Sintoma posible:

```text
El contador RESTARTS aumenta.
```

Diagnostico:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

Recuperacion:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
```

### Requests demasiado altos

Sintoma posible:

```text
Pods Pending por falta de recursos asignables.
```

Diagnostico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl describe node
```

Recuperacion:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
```

## Recuperacion general

Para volver al estado esperado de la Unidad 02:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
bash labs/02-configuration-lifecycle/validation/validate.sh
```

## Limpieza opcional

Eliminar el namespace borra la aplicacion y la configuracion que la Unidad 03 espera reutilizar. Hazlo solo si quieres limpiar los recursos funcionales del curso:

```bash
kubectl delete namespace platform-training
```

No ejecutes scripts de reset de MicroK8s para limpiar esta unidad.

## Conclusion

`platform-api` ya no es solo un Deployment minimo. Ahora tiene configuracion externa, un Secret ficticio de laboratorio, contenido servido desde ConfigMap, senales de salud y limites iniciales de recursos.

El siguiente paso natural es exponer la aplicacion de una forma mas cercana a un entorno real. La Unidad 03 podra partir de `labs/02-configuration-lifecycle/solution/` para incorporar entrada HTTP estable mediante Ingress, Gateway API, DNS local o TLS segun el playbook aprobado.

## Referencias

Estas referencias son lectura guiada. Prioriza las fuentes oficiales para comportamiento de Kubernetes y usa las referencias conceptuales para conectar decisiones de diseno.

### Referencias oficiales

| Tema | Referencia | Uso recomendado |
|---|---|---|
| ConfigMaps | [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) | Comparar variables de entorno y volumenes desde ConfigMap. |
| Secrets | [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) | Identificar limites de seguridad y usos recomendados. |
| Probes | [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) | Diferenciar efecto de startup, readiness y liveness. |
| Recursos de contenedor | [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Entender requests, limits, scheduling y contencion. |
| Deployments | [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Relacionar cambios del template de Pod con rollouts. |
| Ciclo de vida de Pods | [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) | Situar fases, condiciones y reinicios. |

Preguntas para la lectura:

- Que datos deberian ir a ConfigMap y cuales no?
- Que garantia de seguridad da un Secret por si solo y cual no da?
- Que efecto tiene readiness sobre EndpointSlice?
- Que componente usa requests para decidir ubicacion de Pods?
- Por que cambiar un ConfigMap no siempre crea una nueva revision del Deployment?

### Referencias conceptuales

| Tema | Referencia | Uso recomendado |
|---|---|---|
| Twelve-Factor App | [The Twelve-Factor App - Config](https://12factor.net/config) | Entender el antecedente conceptual de separar configuracion de codigo. |
