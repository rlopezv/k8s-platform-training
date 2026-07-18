# Unidad 02 - Configuracion, secretos y ciclo de vida

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

Estas referencias sirven para ampliar o contrastar lo explicado en la unidad. Prioriza la documentacion oficial cuando haya dudas de comportamiento.

| Tema | Referencia | Uso recomendado |
|---|---|---|
| ConfigMaps | [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) | Profundizar en configuracion no sensible, variables de entorno y volumenes desde ConfigMap. |
| Secrets | [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) | Revisar usos, limites y advertencias de seguridad de los Secrets de Kubernetes. |
| Probes | [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) | Comparar `startupProbe`, `readinessProbe` y `livenessProbe`. |
| Recursos de contenedor | [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Entender requests, limits, scheduling y contencion de recursos. |
| Deployments | [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Relacionar cambios del template de Pod con rollouts y ReplicaSets. |
| Ciclo de vida de Pods | [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) | Situar estados, condiciones y comportamiento de contenedores. |
