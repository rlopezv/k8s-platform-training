# Unidad 02 - Configuración, secretos y ciclo de vida

## Guía pedagógica de la unidad

Esta unidad trata sobre el contrato entre una aplicación y la plataforma que la ejecuta.

En la Unidad 01 Kubernetes ya podía mantener dos Pods y darles un Service interno. Eso demuestra que el workload existe, pero todavía dice poco sobre cómo debe operar. Una plataforma necesita más información para tomar buenas decisiones: qué datos recibe la aplicación, qué valores no deben tratarse como configuración pública, cuándo una instancia está lista para recibir tráfico, cuándo debe reiniciarse y cuántos recursos necesita para ser planificada.

La Unidad 02 cubre esa capa de madurez:

- configuración externa mediante ConfigMap;
- valores sensibles simulados mediante Secret de laboratorio;
- inyección de datos por variables de entorno y volumen;
- probes como lenguaje de salud entre kubelet y contenedor;
- readiness como condición para entrar o salir de EndpointSlice;
- requests y limits como primer contrato de capacidad;
- `terminationGracePeriodSeconds` como práctica inicial de terminación;
- rollouts cuando cambia el template de Pod;
- recuperación declarativa sin resetear el clúster.

El laboratorio muestra todos esos conceptos en `platform-api`, pero el objetivo no es aprender "un YAML más largo". El objetivo es entender que un Pod no debería ser una caja negra. Debe declarar sus necesidades y sus señales para que Kubernetes pueda operarlo.

Para estudiar con más detalle la práctica de ConfigMap, Secret, probes, requests, limits, rollouts y EndpointSlice, usa `tutorial/02-configuration-lifecycle/student-notes.md`.

Para profundizar en criterios profesionales, límites de `Secret`, diferencias entre variables y volúmenes, QoS, coste, terminación controlada y continuidad hacia GitOps, Helm y escalado, usa `tutorial/02-configuration-lifecycle/student-reference.md`.

## Mapa de aprendizaje

| Concepto | Pregunta que responde | Error que evita |
|---|---|---|
| ConfigMap | ¿Qué datos no sensibles cambian por despliegue? | Reconstruir imágenes por cada cambio de configuración |
| Secret | ¿Qué datos no deberían tratarse como texto público? | Versionar credenciales reales o imprimirlas para diagnosticar |
| Variables de entorno | ¿Qué valores necesita el proceso al arrancar? | Ocultar configuración dentro de la imagen |
| Volumen de configuración | ¿Qué archivo debe montar Kubernetes en el contenedor? | Confundir configuración montada con estado persistente |
| Startup probe | ¿La aplicación ha terminado de arrancar? | Reiniciar demasiado pronto aplicaciones lentas |
| Readiness probe | ¿Esta instancia debe recibir tráfico? | Enviar peticiones a Pods que aún no están preparados |
| Liveness probe | ¿El contenedor debe reiniciarse? | Dejar vivo un proceso bloqueado sin recuperación local |
| Requests | ¿Qué reserva mínima necesita el scheduler? | Planificar sin declarar necesidades |
| Limits | ¿Qué consumo máximo se permite al contenedor? | Dejar consumo sin ningún límite en el nodo |
| Terminación | ¿Cuánto tiempo tiene el proceso para cerrar? | Confundir grace period con cierre graceful completo |

## Pregunta central

La pregunta de la unidad es:

```text
¿Qué debe declarar un workload para que Kubernetes pueda configurarlo, observar su salud y tomar decisiones básicas de ejecución?
```

Si el alumno puede responderla, la Unidad 03 puede centrarse en red e ingreso sin tener que corregir primero una aplicación muda, sin salud y sin límites.

## Contexto

La Unidad 01 dejó una primera versión de `platform-api`: un Deployment con dos réplicas y un Service interno en el namespace `platform-training`. Ese estado ya permite comprobar que Kubernetes crea Pods, mantiene réplicas y expone una dirección estable dentro del clúster.

En una plataforma real, sin embargo, desplegar una imagen no basta. Una aplicación necesita configuración, algún tratamiento de valores sensibles, señales de salud y límites iniciales de consumo. Esta unidad incorpora esas capacidades sin cambiar de aplicación, sin crear otro namespace funcional y sin introducir Helm, Terraform, Ingress ni observabilidad avanzada.

La idea central es:

```text
La imagen contiene el binario o servidor base.
Kubernetes inyecta configuración y reglas de operación.
El Deployment cambia su template de Pod.
Kubernetes ejecuta un rollout para acercarse al nuevo estado deseado.
```

## Problema real que resuelve

Una aplicación empaquetada en una imagen no debería reconstruirse cada vez que cambia un mensaje, un modo de ejecución, un endpoint o una credencial. Tampoco debería recibir tráfico antes de estar lista, reiniciarse por un arranque lento normal ni consumir recursos sin ningún contrato con el nodo.

La Unidad 02 convierte el Deployment mínimo de la Unidad 01 en un workload operable. La aplicación empieza a declarar qué necesita de la plataforma y la plataforma empieza a tomar decisiones con esa información.

## Por qué aparece en este punto

Primero hacía falta entender que Kubernetes mantiene Pods mediante Deployments y los expone mediante Services. Ahora que esa base existe, tiene sentido introducir los contratos que hacen que un workload sea configurable, observable desde Kubernetes y menos ambiguo ante fallos.

Ingress, Gateway API, Helm, Terraform y gestores externos de secretos aparecen más adelante porque todos ellos dependen de una idea previa: el Pod debe declarar correctamente su configuración, salud y recursos.

## Objetivos

Al finalizar la unidad podrás:

- extender los manifiestos existentes de `platform-api` sin sustituir la aplicación;
- crear un ConfigMap para configuración no sensible;
- crear un Secret de laboratorio con valores ficticios;
- consumir configuración mediante variables de entorno y volumen montado;
- configurar `startupProbe`, `readinessProbe` y `livenessProbe`;
- explicar cómo readiness afecta a los endpoints de un Service;
- declarar requests y limits iniciales de CPU y memoria;
- observar rollouts producidos por cambios declarativos;
- diagnosticar errores de ConfigMap, Secret, probes y recursos;
- recuperar el laboratorio a un estado conocido sin resetear MicroK8s.

## Conocimientos previos

Necesitas haber completado:

- Unidad 00, con MicroK8s y `kubectl` operativos;
- Unidad 01, con `platform-api` desplegada;
- comandos básicos `kubectl apply`, `get`, `describe`, `logs` y `rollout status`;
- relación entre Deployment, ReplicaSet, Pod y Service.

Trabaja desde la raíz del repositorio:

```bash
pwd
```

Resultado esperado:

```text
/home/ramon/git/k8s-platform-training
```

## Relación con la Unidad 01

Esta unidad no modifica `labs/01-kubernetes/solution/`. Esa ruta sigue siendo la evidencia del cierre de la Unidad 01.

La nueva base queda en:

```text
labs/02-configuration-lifecycle/solution/
```

Se conservan:

| Elemento | Valor |
|---|---|
| Aplicación | `platform-api` |
| Namespace | `platform-training` |
| Imagen | `nginxinc/nginx-unprivileged:1.27.4-alpine` |
| Service | `platform-api`, `ClusterIP`, puerto `80` |
| Labels selector | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` |

Se incorporan:

| Capacidad | Recurso o campo |
|---|---|
| Configuración no sensible | `ConfigMap/platform-api-config` |
| Valores sensibles de laboratorio | `Secret/platform-api-secret` |
| Variables de entorno | `env.valueFrom.configMapKeyRef` y `env.valueFrom.secretKeyRef` |
| Contenido montado | volumen desde ConfigMap |
| Salud | `startupProbe`, `readinessProbe`, `livenessProbe` |
| Recursos | `resources.requests` y `resources.limits` |
| Terminación básica | `terminationGracePeriodSeconds: 20` |

## Modelo mental de la unidad

La Unidad 02 organiza el Deployment como un contrato entre aplicación y plataforma:

```text
Imagen
  -> qué software se ejecuta
ConfigMap y Secret
  -> qué datos recibe el software al arrancar o leer archivos
Probes
  -> cómo informa salud y disponibilidad
Requests y limits
  -> qué recursos pide y qué consumo queda acotado
Terminación
  -> cuánto tiempo tiene el proceso para cerrar
Deployment
  -> cómo cambia el template de Pod y se ejecuta el rollout
Service
  -> qué Pods listos reciben tráfico
```

Cuando el contrato cambia dentro de `.spec.template`, Kubernetes crea una nueva revisión del Deployment. Cuando cambia un dato consumido por volumen desde ConfigMap, puede actualizarse en los Pods existentes, pero eso no equivale automáticamente a un rollout trazable. En operación real se suele preferir un cambio declarativo visible y una estrategia de despliegue controlada.

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
La validación heredada no muestra fallos bloqueantes.
deployment/platform-api está disponible.
service/platform-api existe.
Antes de aplicar esta unidad no hay ConfigMaps ni Secrets de aplicación creados por el curso.
```

Si el Deployment no existe, recupera la Unidad 01:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
bash labs/01-kubernetes/validation/validate.sh
```

## Configuración en Kubernetes

Una imagen de contenedor debería ser portable. Si cada entorno necesita una imagen diferente solo para cambiar un mensaje, un endpoint o un modo de ejecución, la plataforma pierde trazabilidad y empieza a mezclar construcción con operación.

Kubernetes separa esa responsabilidad con varios mecanismos:

| Necesidad | Mecanismo en esta unidad | Uso |
|---|---|---|
| Configuración visible y no sensible | ConfigMap | Modo de entorno, nivel de log y contenido HTML de laboratorio. |
| Valor que simula información sensible | Secret | Identificador y token ficticios para practicar referencias. |
| Parámetro leído al arrancar | Variable de entorno | Valores disponibles dentro del contenedor. |
| Archivo de configuración | Volumen desde ConfigMap | `index.html` montado sobre el contenido servido por nginx. |

Un ConfigMap no es para credenciales. Un Secret tampoco convierte automáticamente un dato en seguro para cualquier contexto. En esta unidad los valores del Secret son ficticios y están versionados solo porque son material didáctico.

## Configuración, secreto, estado y código

Una confusión habitual es llamar "configuración" a cualquier dato que no está dentro del binario. Para operar plataformas conviene separar responsabilidades:

| Tipo | Qué representa | Ejemplo | Tratamiento en esta unidad |
|---|---|---|---|
| Código o imagen | Software construido y versionado como artefacto ejecutable. | Imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`. | No cambia. |
| Configuración | Dato no sensible que cambia por entorno o despliegue. | `APP_ENV`, `LOG_LEVEL`, `index.html` de laboratorio. | ConfigMap. |
| Secreto | Dato sensible o simulado como sensible. | Token ficticio de laboratorio. | Secret con valores no reales. |
| Estado | Datos producidos por la aplicación durante su ejecución. | Base de datos, archivos persistentes, cola. | No se implementa; se difiere a persistencia. |

El criterio práctico es preguntar: si cambia este dato, ¿debo reconstruir la imagen?, ¿puedo versionarlo visible?, ¿se puede regenerar?, ¿debe sobrevivir al Pod? Cada respuesta lleva a un mecanismo distinto.

## Antecedente Twelve-Factor

El enfoque de configuración externa conecta con el principio de Twelve-Factor App que recomienda separar configuración del código. Kubernetes no inventa esa idea, pero la convierte en recursos declarativos: ConfigMaps, Secrets, variables de entorno y volúmenes.

El matiz importante es que Kubernetes no decide por sí solo qué es seguro, qué es secreto o qué debe rotar. La plataforma ofrece mecanismos; el equipo define políticas. Por eso esta unidad usa Secrets solo como primer contacto y deja gestores externos, rotación, cifrado operativo y RBAC avanzado para unidades posteriores.

## Manifiestos de la unidad

La solución final contiene:

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

Observa que contiene claves sencillas y un `index.html`. Ese archivo se montará dentro del contenedor como contenido servido por `nginx`.

Revisa el Secret sin tratar sus valores como credenciales reales:

```bash
sed -n '1,120p' labs/02-configuration-lifecycle/solution/secret.yaml
```

Los valores usan `stringData` para que el manifiesto sea legible en el laboratorio. Kubernetes los almacenará en el campo `data` al crear el recurso. No uses este patrón para versionar secretos reales.

## Deployment evolucionado

El Deployment de Unidad 02 conserva la identidad operativa de la aplicación, pero cambia el template de Pod. Ese detalle importa: cuando cambia `.spec.template`, Kubernetes crea un nuevo ReplicaSet y ejecuta un rollout.

Revisa los cambios principales:

```bash
sed -n '1,220p' labs/02-configuration-lifecycle/solution/deployment.yaml
```

Fíjate en:

- `env`, con valores desde ConfigMap y Secret;
- `volumeMounts`, con `index.html` desde ConfigMap;
- `startupProbe`, para proteger aplicaciones con arranque lento;
- `readinessProbe`, para decidir si un Pod debe recibir tráfico;
- `livenessProbe`, para reiniciar un contenedor que queda vivo pero no sano;
- `resources`, para declarar requests y limits;
- `terminationGracePeriodSeconds`, para dar margen de cierre antes de forzar la terminación.

## Probes

Las probes son preguntas que el kubelet hace al contenedor.

| Probe | Pregunta | Efecto |
|---|---|---|
| `startupProbe` | ¿La aplicación ya terminó de arrancar? | Mientras falla, evita que liveness mate el contenedor demasiado pronto. |
| `readinessProbe` | ¿Esta instancia puede recibir tráfico ahora? | Si falla, el Pod deja de aparecer como endpoint listo del Service. |
| `livenessProbe` | ¿El contenedor sigue sano o debe reiniciarse? | Si falla repetidamente, el kubelet reinicia el contenedor. |

En esta unidad las tres probes consultan `/` en el puerto nombrado `http`. La aplicación arranca rápido, pero el patrón queda preparado para workloads más lentos.

## Ciclo de vida de Pods

Un Pod no pasa simplemente de "creado" a "funcionando". Kubernetes observa fases, condiciones, eventos y terminación. En esta unidad interesan cuatro momentos:

| Momento | Qué ocurre | Señal relevante |
|---|---|---|
| Arranque | El contenedor empieza y puede necesitar tiempo antes de responder. | `startupProbe` y eventos. |
| Entrada en servicio | El Pod puede estar `Running` pero todavía no debe recibir tráfico. | `readinessProbe`, condición `Ready` y EndpointSlice. |
| Recuperación local | Un contenedor puede quedar vivo pero no sano. | `livenessProbe` y contador `RESTARTS`. |
| Terminación | Kubernetes da un margen antes de forzar el cierre. | `terminationGracePeriodSeconds`. |

Readiness es un contrato de tráfico: afecta a si el Service considera el Pod como endpoint listo. Liveness es un contrato de recuperación local: decide si el kubelet reinicia un contenedor. Startup protege el arranque para que liveness no castigue una aplicación que todavía está inicializando.

`terminationGracePeriodSeconds` no sustituye una aplicación que atienda SIGTERM ni un hook `preStop`. La Unidad 02 solo practica el campo básico; el patrón completo de cierre graceful se retoma más adelante.

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

El request indica lo que Kubernetes reserva para planificar el Pod. El limit acota cuánto puede consumir el contenedor. No es una medición de consumo real ni un mecanismo de escalado automático.

Como modelo mental:

- `requests` hablan principalmente con el scheduler;
- `limits` hablan principalmente con el nodo y el runtime;
- el consumo real se observará con métricas en unidades posteriores;
- HPA y KEDA no aparecen todavía porque requieren señales de escalado y política adicional.

Un request demasiado alto puede dejar Pods en `Pending`. Un limit demasiado bajo puede provocar lentitud, throttling de CPU o terminaciones por memoria. En esta unidad se eligen valores conservadores porque el objetivo es aprender el contrato, no optimizar capacidad.

## Decisiones de diseño y trade-offs

| Decisión | Motivo | Trade-off |
|---|---|---|
| Mantener `platform-api` | Conserva continuidad del laboratorio evolutivo. | La imagen simple no cubre todos los casos reales de aplicación. |
| Usar ConfigMap para contenido HTML | Permite ver un efecto observable sin reconstruir imagen. | No representa aún una estrategia completa de release de frontend. |
| Usar Secret ficticio versionado | Practica la API sin riesgo de credenciales reales. | No enseña todavía rotación ni integración con vault externo. |
| Configurar probes HTTP a `/` | Mantiene el ejemplo legible y validable. | En sistemas reales cada probe debería mapear una condición más específica. |
| Definir requests y limits modestos | Evita saturar el laboratorio local. | No sustituye capacity planning ni observabilidad de consumo. |
| Declarar `terminationGracePeriodSeconds: 20` | Muestra que la terminación también es parte del contrato del Pod. | No implementa `preStop` ni lógica real de cierre graceful. |

## Procedimiento declarativo

Aplica primero el namespace:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
```

Aplica configuración y secreto ficticio:

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

Ejecuta la validación automatizada:

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

Detén el port-forward con `Ctrl+C`.

## Diagnóstico

Antes de corregir, identifica qué contrato se rompió:

| Síntoma | Contrato sospechoso |
|---|---|
| Pod no se crea o queda esperando | Recursos, scheduling, ConfigMap o Secret ausente. |
| Pod `Running` pero no `Ready` | Readiness o dependencia de arranque. |
| Service sin endpoints listos | Readiness o selector. |
| Reinicios repetidos | Liveness, proceso del contenedor o límite de memoria. |
| Cambio aplicado pero sin nuevo ReplicaSet | Cambio fuera de `.spec.template`, por ejemplo solo ConfigMap. |

No imprimas ni decodifiques Secrets para diagnosticar esta unidad. `get` y `describe` bastan para confirmar existencia y claves.

### ConfigMap ausente

Síntoma posible:

```text
Pods nuevos no arrancan porque falta platform-api-config.
```

Diagnóstico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Recuperación:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

### Secret ausente

Síntoma posible:

```text
Pods nuevos no arrancan porque falta platform-api-secret o una clave esperada.
```

Diagnóstico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get secret platform-api-secret
```

Recuperación:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

### Readiness falla

Síntoma posible:

```text
Pods Running pero no Ready; el Service no tiene endpoints listos.
```

Diagnóstico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Recuperación:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

### Liveness demasiado agresiva

Síntoma posible:

```text
El contador RESTARTS aumenta.
```

Diagnóstico:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

Recuperación:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
```

### Requests demasiado altos

Síntoma posible:

```text
Pods Pending por falta de recursos asignables.
```

Diagnóstico:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl describe node
```

Recuperación:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
```

## Recuperación general

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

Eliminar el namespace borra la aplicación y la configuración que la Unidad 03 espera reutilizar. Hazlo solo si quieres limpiar los recursos funcionales del curso:

```bash
kubectl delete namespace platform-training
```

No ejecutes scripts de reset de MicroK8s para limpiar esta unidad.

## Conclusión

`platform-api` ya no es solo un Deployment mínimo. Ahora tiene configuración externa, un Secret ficticio de laboratorio, contenido servido desde ConfigMap, señales de salud, límites iniciales de recursos y un margen explícito de terminación.

El siguiente paso natural es exponer la aplicación de una forma más cercana a un entorno real. La Unidad 03 podrá partir de `labs/02-configuration-lifecycle/solution/` para incorporar entrada HTTP estable mediante Ingress, Gateway API, DNS local o TLS según el playbook aprobado.

## Referencias

Estas referencias son lectura guiada. Prioriza las fuentes oficiales para comportamiento de Kubernetes y usa las referencias conceptuales para conectar decisiones de diseño.

### Referencias oficiales

| Tema | Referencia | Uso recomendado |
|---|---|---|
| ConfigMaps | [Configure a Pod to Use a ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) | Comparar variables de entorno y volúmenes desde ConfigMap. |
| Secrets | [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) | Identificar límites de seguridad y usos recomendados. |
| Probes | [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) | Diferenciar efecto de startup, readiness y liveness. |
| Recursos de contenedor | [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Entender requests, limits, scheduling y contención. |
| Ciclo de vida de Pods | [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) | Situar fases, condiciones, reinicios y terminación. |
| Deployments | [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | Relacionar cambios del template de Pod con rollouts. |

Preguntas para la lectura:

- ¿Qué datos deberían ir a ConfigMap y cuáles no?
- ¿Qué garantía de seguridad da un Secret por sí solo y cuál no da?
- ¿Qué efecto tiene readiness sobre EndpointSlice?
- ¿Qué componente usa requests para decidir ubicación de Pods?
- ¿Por qué cambiar un ConfigMap no siempre crea una nueva revisión del Deployment?
- ¿Qué falta para que un grace period sea cierre graceful real?

### Referencias conceptuales

| Tema | Referencia | Uso recomendado |
|---|---|---|
| Twelve-Factor App | [The Twelve-Factor App - Config](https://12factor.net/config) | Entender el antecedente conceptual de separar configuración de código. |
