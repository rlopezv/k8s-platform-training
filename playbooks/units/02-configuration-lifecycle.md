# Playbook de la Unidad 02 - Configuracion, secretos y ciclo de vida

## Identificacion

### Unidad

```text
02 - Configuracion, secretos y ciclo de vida
```

### Identificador

```text
02-configuration-lifecycle
```

### Fase del roadmap

```text
Fase 2 - Fundamentos Kubernetes
```

### Estado del playbook

```text
Aprobado para iniciar la generacion de la Unidad 02
```

### Propietario logico

```text
Fundamentos Kubernetes
```

---

# Proposito de la unidad

La Unidad 02 evoluciona `platform-api` desde un Deployment funcional minimo hacia una aplicacion configurable y operable mediante recursos Kubernetes estandar.

La unidad aparece despues de que la Unidad 01 haya dejado una aplicacion desplegada, un namespace funcional y manifiestos base. Su responsabilidad es separar configuracion de imagen, introducir secretos de laboratorio sin valores reales, declarar salud de contenedores, acotar consumo inicial de recursos y mostrar como Kubernetes gestiona cambios de ciclo de vida mediante rollouts, reinicios controlados y terminacion ordenada.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- extender manifiestos existentes sin sustituir la aplicacion evolutiva;
- crear y aplicar ConfigMaps para configurar comportamiento y contenido de `platform-api`;
- crear y aplicar Secrets de laboratorio con valores no reales y explicar sus limites;
- consumir configuracion como variables de entorno y como volumen montado;
- configurar `startupProbe`, `readinessProbe` y `livenessProbe` sobre el contenedor HTTP;
- justificar diferencias entre disponibilidad, arranque y recuperacion de contenedores;
- definir requests y limits iniciales para CPU y memoria;
- observar rollouts provocados por cambios declarativos;
- diagnosticar fallos de configuracion, probes, secretos y recursos;
- recuperar el laboratorio a un estado conocido sin resetear MicroK8s;
- registrar en `summary.md` el estado que reutilizara la Unidad 03.

---

# Alcance

## Incluido

- reutilizacion de `platform-api`, `platform-training` y `labs/01-kubernetes/solution/`;
- laboratorio de Unidad 02 en `labs/02-configuration-lifecycle/`;
- tutorial de alumno, notas del instructor y summary de continuidad;
- ConfigMaps de laboratorio para configuracion no sensible;
- Secrets de laboratorio con valores ficticios o placeholders no corporativos;
- consumo de ConfigMaps y Secrets mediante variables de entorno;
- consumo de ConfigMaps mediante volumen de configuracion cuando sea viable con la imagen actual;
- probes HTTP: `startupProbe`, `readinessProbe` y `livenessProbe`;
- requests y limits iniciales de CPU y memoria;
- explicacion de rollout al modificar templates de Pod;
- diagnostico con `kubectl describe`, eventos, logs y estado de rollout;
- validacion no destructiva del estado esperado;
- actualizacion de `project/project-state.md` al generar y cerrar la unidad.

## Excluido

- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automatico;
- Ingress, Gateway API, TLS o exposicion externa estable;
- almacenamiento persistente con PV, PVC o StorageClass;
- NetworkPolicies, RBAC avanzado, Pod Security o politicas de admission;
- credenciales reales, tokens, kubeconfigs, certificados privados o secretos corporativos;
- sustitucion de `platform-api` por otra aplicacion sin decision documentada;
- cambio de plataforma local o introduccion de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Ingress, DNS de aplicacion, Gateway API y TLS local | Unidad 03 | Requiere una aplicacion ya configurable y con probes claros |
| Persistencia con PV, PVC y StorageClass | Unidad 04 | La configuracion montada no debe confundirse con estado persistente |
| Rolling updates avanzados, rollback y mantenimiento | Unidad 05 | Unidad 02 solo observa ciclo de vida basico al cambiar configuracion |
| Helm | Unidad 06 | Requiere manifiestos acumulados y estables |
| Terraform | Unidad 07 | Requiere chart o limites claros entre herramientas |
| Tekton | Unidad 08 | Requiere artefactos de aplicacion y validacion ya consolidados |
| Argo CD | Unidad 09 | Requiere layout declarativo estable |
| Observabilidad avanzada | Unidades 11-15 | Unidad 02 usa estado, eventos y logs nativos |
| Seguridad avanzada | Unidades 16-17 | Unidad 02 solo introduce tratamiento basico y seguro de Secrets de laboratorio |
| KEDA | Unidad 18 | Requiere metricas y eventos definidos |
| AKS y EKS | Unidades 20-21 | Requieren baseline local consolidado |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `project/project-planning.md`;
6. `project/how-to.md`;
7. `playbooks/unit-template.md`;
8. `playbooks/summary-template.md`;
9. `playbooks/project-state-template.md`;
10. `tutorial/01-kubernetes/summary.md`;
11. este playbook;
12. `labs/01-kubernetes/README.md`;
13. `labs/01-kubernetes/solution/namespace.yaml`;
14. `labs/01-kubernetes/solution/deployment.yaml`;
15. `labs/01-kubernetes/solution/service.yaml`;
16. `labs/01-kubernetes/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 01 esta cerrada, aprobada por el usuario y existe `tutorial/01-kubernetes/summary.md`.

---

# Dependencias

## Dependencias documentales

Deben existir y estar revisados:

```text
README.md
project/architecture.md
project/project-state.md
project/roadmap.md
project/project-planning.md
project/how-to.md
playbooks/master.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
playbooks/units/02-configuration-lifecycle.md
tutorial/01-kubernetes/summary.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| Ubuntu WSL objetivo | Validado como Ubuntu 24.04 LTS | `cat /etc/os-release` o validacion heredada |
| MicroK8s | Instalado y operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| Namespace `platform-training` | Existente o aplicable desde manifiesto | `kubectl get namespace platform-training` |
| Deployment `platform-api` | Definido y desplegable | `kubectl -n platform-training rollout status deployment/platform-api` |
| Service `platform-api` | Definido y seleccionando Pods | `kubectl -n platform-training get service platform-api` |
| Helm | Instalado, pero no usado para desplegar la unidad | `helm version --short` |
| Terraform | Instalado, pero no usado para gestionar recursos | `terraform version` |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00 y validacion del entorno local;
- Unidad 01 y despliegue inicial de `platform-api`;
- uso basico de `kubectl apply`, `get`, `describe`, `logs` y `rollout status`;
- relacion entre Deployment, ReplicaSet, Pod y Service;
- lectura basica de YAML;
- diferencia inicial entre configuracion, secretos y estado observado.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/01-kubernetes/summary.md
labs/01-kubernetes/README.md
labs/01-kubernetes/solution/namespace.yaml
labs/01-kubernetes/solution/deployment.yaml
labs/01-kubernetes/solution/service.yaml
labs/01-kubernetes/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` desplegada sobre MicroK8s en el namespace `platform-training`.

Estado verificable esperado:

- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` disponibles segun estado heredado;
- `kubectl` `v1.35.6` configurado como cliente principal;
- Helm y Terraform instalados como CLI heredadas, sin gestionar recursos del curso;
- namespace `platform-training` definido en `labs/01-kubernetes/solution/namespace.yaml`;
- Deployment `platform-api` definido con dos replicas y contenedor `nginxinc/nginx-unprivileged:1.27.4-alpine`;
- Service `platform-api` de tipo `ClusterIP` definido en `labs/01-kubernetes/solution/service.yaml`;
- sin ConfigMaps, Secrets, probes, requests ni limits implementados para la aplicacion;
- sin charts Helm, modulos Terraform, pipelines, observabilidad avanzada ni recursos cloud.

No debe asumirse que el laboratorio esta desplegado en el cluster si no se ejecuta validacion real o el usuario aporta evidencia.

## Validacion del estado inicial

Ejecutar desde Ubuntu WSL objetivo cuando se vaya a generar o validar funcionalmente la unidad:

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
service/platform-api existe y selecciona Pods.
No existen ConfigMaps ni Secrets de aplicacion creados por unidades anteriores.
```

Si el Deployment o Service no existen, la unidad puede documentar la recuperacion aplicando `labs/01-kubernetes/solution/`, sin declarar validacion funcional hasta ejecutarla.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 01 | `tutorial/01-kubernetes/summary.md` | Continuidad tecnica, decisiones y limitaciones |
| Namespace base | `labs/01-kubernetes/solution/namespace.yaml` | Mantener `platform-training` como namespace funcional |
| Deployment base | `labs/01-kubernetes/solution/deployment.yaml` | Punto de partida para configuracion, probes y recursos |
| Service base | `labs/01-kubernetes/solution/service.yaml` | Validacion HTTP y selector de Pods |
| Validacion Unidad 01 | `labs/01-kubernetes/validation/validate.sh` | Precondicion y posible referencia para nueva validacion |
| Labels base | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` | Selectors y continuidad operativa |
| Estado del proyecto | `project/project-state.md` | Registro de hechos generados y validados |

## Reglas de reutilizacion

- mantener `platform-api` como aplicacion evolutiva;
- mantener `platform-training` como namespace funcional;
- conservar labels y selectors que usa el Service existente;
- no modificar `platform/environment/` salvo defecto real y justificado;
- no crear un segundo laboratorio independiente con otra aplicacion;
- crear artefactos de Unidad 02 en una ruta propia y declarar que extienden la solucion de Unidad 01;
- si se copia un manifiesto base a `labs/02-configuration-lifecycle/solution/`, documentar que es la version evolucionada de la solucion anterior;
- no usar Helm ni Terraform para aplicar los recursos.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Responsabilidad | Ubicacion prevista |
|---|---|---|
| Tutorial de la Unidad 02 | Guiar conceptos y laboratorio del alumno | `tutorial/02-configuration-lifecycle/README.md` |
| Notas del instructor | Facilitar imparticion, diagnostico y evaluacion | `tutorial/02-configuration-lifecycle/instructor-notes.md` |
| Summary | Registrar continuidad tecnica y pedagogica | `tutorial/02-configuration-lifecycle/summary.md` |
| Laboratorio | Contener instrucciones y artefactos declarativos | `labs/02-configuration-lifecycle/README.md` |
| ConfigMap de aplicacion | Configuracion no sensible de `platform-api` | `labs/02-configuration-lifecycle/solution/configmap.yaml` |
| Secret de laboratorio | Valores ficticios para practicar consumo seguro | `labs/02-configuration-lifecycle/solution/secret.yaml` |
| Deployment evolucionado | Variables de entorno, volumenes, probes y recursos | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| Service conservado | Exposicion interna estable | `labs/02-configuration-lifecycle/solution/service.yaml` |
| Namespace conservado | Aislamiento funcional del curso | `labs/02-configuration-lifecycle/solution/namespace.yaml` |
| Validacion del laboratorio | Comprobacion no destructiva del estado esperado | `labs/02-configuration-lifecycle/validation/validate.sh` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar existencia del playbook, generacion y cierre de Unidad 02 segun corresponda | Mantiene estado real como fuente de verdad |
| Manifiesto de Deployment evolucionado | Incorporar referencias a ConfigMap, Secret, volumen de configuracion, probes y resources | Mantiene nombre, namespace, labels y selector del Service |
| Validacion del laboratorio | Ampliar comprobaciones de Unidad 01 con ConfigMaps, Secrets, probes y recursos | Sigue siendo no destructiva |

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseno de la unidad

## D-02-01 - Configuracion externa sin cambiar la aplicacion evolutiva

### Decision

La unidad extendera `platform-api` mediante recursos Kubernetes declarativos y configuracion externa, sin sustituir la aplicacion ni cambiar su namespace funcional.

### Motivo

El itinerario exige un laboratorio unico y evolutivo. La Unidad 02 debe mostrar desacoplamiento de configuracion usando el workload existente.

### Consecuencias

- el Deployment evolucionado debe mantener nombre, selector y Service compatibles;
- los cambios en el template de Pod deben observarse como rollouts;
- cualquier limitacion de la imagen actual debe documentarse en el tutorial y summary.

### Alternativas descartadas

- Crear una aplicacion nueva: rompe continuidad.
- Introducir codigo propio de aplicacion en esta unidad: amplia el alcance y distrae de Kubernetes.

## D-02-02 - Secrets solo de laboratorio y sin sensibilidad real

### Decision

Los Secrets de la unidad contendran unicamente valores ficticios, didacticos y no reutilizables.

### Motivo

La unidad debe enseñar la API de Secret y sus limites sin normalizar el versionado de credenciales reales.

### Consecuencias

- el tutorial debe advertir que un Secret no es un gestor de secretos corporativo;
- no se deben incluir tokens, passwords reales, claves privadas, certificados privados ni credenciales de proxy;
- se debe revisar explicitamente ausencia de secretos reales antes de cerrar la unidad.

### Alternativas descartadas

- Usar credenciales reales locales: riesgo de seguridad.
- Diferir por completo Secrets: dejaria incompleta la capacidad prevista en roadmap.

## D-02-03 - Probes HTTP sobre el Service interno y el contenedor existente

### Decision

Las probes se definiran sobre endpoints HTTP disponibles en el contenedor `nginxinc/nginx-unprivileged:1.27.4-alpine`, preferentemente en el puerto nombrado `http`.

### Motivo

Permite practicar salud y disponibilidad sin introducir Ingress, Gateway API ni una aplicacion nueva.

### Consecuencias

- `readinessProbe` debe afectar a la seleccion de endpoints del Service;
- `livenessProbe` debe explicarse como recuperacion de contenedor, no como prueba de dependencia externa;
- `startupProbe` debe justificarse aunque el contenedor arranque rapido, para mostrar el patron.

### Alternativas descartadas

- Probes TCP genericas sin contexto HTTP: menos expresivas para la aplicacion actual.
- Checks contra servicios externos: introduce dependencias fuera de alcance.

## D-02-04 - Requests y limits iniciales conservadores

### Decision

La unidad definira requests y limits modestos para CPU y memoria, adecuados para un laboratorio local.

### Motivo

El alumno debe ver como Kubernetes usa requests para scheduling y limits para contencion sin agotar recursos del host.

### Consecuencias

- los valores deben ser suficientemente bajos para MicroK8s local;
- no se debe introducir escalado automatico;
- el tutorial debe diferenciar requests, limits y consumo real observado.

### Alternativas descartadas

- No definir recursos hasta observabilidad: retrasa un concepto operativo basico.
- Usar valores altos: aumenta riesgo de fallos por recursos en equipos modestos.

## D-02-05 - Laboratorio acumulativo con ruta propia

### Decision

La Unidad 02 tendra su propio directorio `labs/02-configuration-lifecycle/` con la solucion evolucionada, reutilizando semanticamente los manifiestos de Unidad 01.

### Motivo

Mantiene trazabilidad por unidad sin modificar retroactivamente el estado final de la Unidad 01.

### Consecuencias

- `labs/01-kubernetes/solution/` queda como evidencia de salida de Unidad 01;
- `labs/02-configuration-lifecycle/solution/` sera la nueva base para Unidad 03;
- el summary debera indicar claramente que Unidad 03 reutiliza la solucion de Unidad 02.

### Alternativas descartadas

- Editar solo `labs/01-kubernetes/solution/`: dificulta auditar la evolucion entre unidades.
- Crear manifests sin relacion con la solucion previa: rompe continuidad.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/02-configuration-lifecycle/README.md
```

Debe incluir:

1. contexto;
2. objetivos;
3. conocimientos previos;
4. relacion con la Unidad 01;
5. estado inicial;
6. configuracion en Kubernetes: ConfigMaps, Secrets, env vars y volumenes;
7. limites de seguridad de Secrets y tratamiento de valores ficticios;
8. ciclo de vida de Pods y rollouts al cambiar templates;
9. probes: startup, readiness y liveness;
10. requests, limits y efectos en scheduling y contencion;
11. procedimiento declarativo;
12. validaciones;
13. diagnostico con `describe`, eventos, logs, rollout y endpoints;
14. recuperacion o limpieza;
15. conclusion;
16. referencias oficiales y lectura recomendada;
17. conexion con la Unidad 03.

Las referencias deberan priorizar documentacion oficial de Kubernetes sobre ConfigMaps, Secrets, probes, recursos de contenedor y ciclo de vida de Pods. Cualquier material secundario debera complementar esas fuentes, no sustituirlas.

## Notas del instructor

Ruta:

```text
tutorial/02-configuration-lifecycle/instructor-notes.md
```

Debe incluir:

- intencion pedagogica;
- puntos de enfasis;
- demostraciones recomendadas;
- errores frecuentes;
- preguntas de comprobacion;
- criterios de evaluacion;
- riesgos tecnicos;
- limites de alcance para no anticipar networking, Helm, Terraform ni seguridad avanzada.

## Resumen

Ruta:

```text
tutorial/02-configuration-lifecycle/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Laboratorio

Ruta normal:

```text
labs/02-configuration-lifecycle/
```

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

siguiendo:

```text
playbooks/project-state-template.md
```

---

# Estructura prevista del laboratorio

```text
labs/02-configuration-lifecycle/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── secret.yaml
├── solution/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── configmap.yaml
│   └── secret.yaml
└── validation/
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/02-configuration-lifecycle/README.md` | Referencia operativa del laboratorio |
| `labs/02-configuration-lifecycle/starter/` | Punto de partida guiado con huecos o configuracion incompleta |
| `labs/02-configuration-lifecycle/solution/` | Estado final reutilizable por Unidad 03 |
| `labs/02-configuration-lifecycle/validation/validate.sh` | Validacion no destructiva de recursos esperados |

---

# Flujo pedagogico obligatorio

La unidad debera seguir este orden conceptual:

1. recuperar el estado final de Unidad 01;
2. explicar por que no conviene hornear configuracion en la imagen;
3. diferenciar configuracion no sensible, valores sensibles y secretos reales;
4. crear ConfigMap para configuracion visible;
5. consumir ConfigMap como variables de entorno;
6. consumir ConfigMap como volumen de configuracion;
7. crear Secret de laboratorio con valores ficticios;
8. consumir Secret sin imprimir ni exponer valores completos en el tutorial;
9. explicar que cambios en el template de Pod provocan rollout;
10. incorporar probes en orden: startup, readiness y liveness;
11. observar como readiness afecta a endpoints del Service;
12. incorporar requests y limits;
13. validar estado final;
14. diagnosticar al menos un fallo realista de ConfigMap, Secret o probe;
15. consolidar el estado que reutilizara la Unidad 03.

---

# Procedimientos obligatorios

## Preparacion

- validar entorno heredado;
- validar que `platform-api` de Unidad 01 esta disponible o reaplicar `labs/01-kubernetes/solution/`;
- confirmar contexto actual de `kubectl`;
- revisar recursos existentes en `platform-training`;
- confirmar que no existen secretos reales versionados.

## Implementacion

- crear manifiestos de ConfigMap y Secret;
- extender el Deployment con variables de entorno desde ConfigMap y Secret;
- montar configuracion desde ConfigMap como volumen cuando sea compatible con la imagen;
- declarar probes HTTP;
- declarar requests y limits;
- aplicar manifiestos en orden explicito;
- documentar comandos exactos y resultados esperados.

## Validacion

- comprobar ConfigMap y Secret creados;
- comprobar que el Deployment referencia ConfigMap y Secret;
- comprobar rollout completado;
- comprobar Pods listos;
- comprobar que el Service conserva endpoints;
- comprobar probes y resources en la especificacion del Pod;
- validar acceso HTTP por Service con `kubectl port-forward` o Pod temporal de diagnostico;
- ejecutar script de validacion de Unidad 02.

## Diagnostico

- identificar ConfigMap ausente o clave inexistente;
- identificar Secret ausente o clave inexistente;
- interpretar fallos de readiness y su efecto sobre endpoints;
- distinguir reinicio por liveness de fallo de despliegue;
- revisar eventos antes de modificar manifiestos;
- comparar template esperado y Pod observado.

## Recuperacion

- reaplicar manifiestos declarativos de Unidad 02;
- corregir referencias a claves de ConfigMap o Secret;
- restaurar probes a valores funcionales;
- esperar rollout con `kubectl rollout status`;
- volver a ejecutar la validacion.

## Limpieza

- documentar limpieza del namespace como operacion opcional;
- advertir que eliminar `platform-training` borra el estado que Unidad 03 espera reutilizar;
- no destruir MicroK8s ni ejecutar resets de Unidad 00;
- no eliminar recursos de sistema.

---

# Validaciones obligatorias

## Validaciones estaticas

| Validacion | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/02-configuration-lifecycle/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | Revision de manifiestos y busqueda de patrones sensibles | Sin tokens, passwords reales, claves privadas ni kubeconfigs |
| Sintaxis Bash de validacion | `bash -n labs/02-configuration-lifecycle/validation/validate.sh` | Codigo de salida 0 |
| Ausencia de Helm charts | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

## Validaciones funcionales

| Validacion | Procedimiento | Resultado esperado |
|---|---|---|
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |
| Estado Unidad 01 | `bash labs/01-kubernetes/validation/validate.sh` | Sin fallos antes de evolucionar la solucion |
| Aplicacion de manifiestos | `kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml -f labs/02-configuration-lifecycle/solution/configmap.yaml -f labs/02-configuration-lifecycle/solution/secret.yaml -f labs/02-configuration-lifecycle/solution/deployment.yaml -f labs/02-configuration-lifecycle/solution/service.yaml` | Recursos aplicados sin errores |
| ConfigMap creado | `kubectl -n platform-training get configmap platform-api-config` | Recurso presente |
| Secret creado | `kubectl -n platform-training get secret platform-api-secret` | Recurso presente sin exponer valores |
| Deployment disponible | `kubectl -n platform-training rollout status deployment/platform-api` | Rollout completado |
| Pods listos | `kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api` | Pods `Running` y `Ready` |
| Service selecciona Pods listos | `kubectl -n platform-training get endpoints platform-api` o EndpointSlice equivalente | Endpoints presentes |
| Probes declaradas | `kubectl -n platform-training get deploy platform-api -o yaml` | `startupProbe`, `readinessProbe` y `livenessProbe` presentes |
| Resources declarados | `kubectl -n platform-training get deploy platform-api -o yaml` | `requests` y `limits` presentes |
| Validacion del laboratorio | `bash labs/02-configuration-lifecycle/validation/validate.sh` | Sin fallos |

## Validaciones de continuidad

Comprobar que:

- `labs/01-kubernetes/solution/` permanece como evidencia de Unidad 01;
- `labs/02-configuration-lifecycle/solution/` contiene el estado que reutilizara Unidad 03;
- `platform-api` conserva nombre, namespace, selector y Service interno;
- Helm y Terraform siguen sin gestionar recursos del curso;
- no existen credenciales reales versionadas;
- `tutorial/02-configuration-lifecycle/summary.md` registra configuracion, secretos de laboratorio, probes, resources, validaciones y limitaciones;
- `project/project-state.md` refleja solo recursos realmente creados y validados.

## Validaciones no ejecutables en el entorno de generacion

Declarar como pendientes cualquier validacion funcional que no se ejecute realmente en MicroK8s.

No afirmar que ConfigMaps, Secrets, probes, resources o rollouts funcionan si solo se revisaron los archivos.

---

# Escenarios de error obligatorios

| Escenario | Sintoma | Diagnostico | Recuperacion |
|---|---|---|---|
| ConfigMap ausente | Pod no arranca o env var no se resuelve | `kubectl describe pod` y eventos | Aplicar `configmap.yaml` y reiniciar rollout si procede |
| Clave de ConfigMap incorrecta | Pod queda pendiente o configuracion no aparece | Revisar `envFrom`, `configMapKeyRef` o volumen | Corregir clave y reaplicar Deployment |
| Secret ausente | Pod no arranca por referencia invalida | `kubectl describe pod` y eventos | Aplicar `secret.yaml` o corregir referencia |
| Exposicion accidental de secreto | Valor sensible aparece en docs, logs o manifiestos | Revision manual y busqueda de patrones | Sustituir por valor ficticio y rotar si fuera real |
| Readiness falla | Pods `Running` pero no `Ready`; Service sin endpoints | `kubectl describe pod`, eventos y endpoints | Corregir path, puerto o tiempos de probe |
| Liveness demasiado agresiva | Reinicios continuos | `kubectl get pods`, `kubectl describe pod` y restart count | Aumentar delays, periods o thresholds |
| Requests demasiado altos | Pod queda `Pending` | `kubectl describe pod` y eventos de scheduling | Reducir requests o liberar recursos |
| Limit demasiado bajo | Contenedor reinicia por OOMKilled o throttling severo | `kubectl describe pod`, estado de contenedor | Ajustar limits y explicar trade-off |
| Contexto `kubectl` equivocado | Recursos no aparecen o se aplican a otro cluster | `kubectl config current-context` y `kubectl get nodes` | Cambiar contexto o reconfigurar desde Unidad 00 |

---

# Requisitos de seguridad

## Datos sensibles

La Unidad 02 introduce Secrets, pero no debe usar secretos reales.

Solo se permiten:

- valores ficticios de laboratorio;
- placeholders no corporativos;
- datos publicos de ejemplo;
- nombres que indiquen claramente su caracter didactico.

No versionar:

- tokens;
- passwords reales;
- claves privadas;
- kubeconfigs personales;
- certificados privados;
- credenciales de proxy;
- datos corporativos;
- cadenas de conexion reales.

## Tratamiento didactico de Secrets

Documentar que:

- un Secret de Kubernetes no equivale por si solo a un gestor de secretos empresarial;
- los valores pueden estar codificados pero no deben tratarse como invulnerables;
- no se deben imprimir valores sensibles completos durante validaciones;
- la gestion avanzada de secretos se difiere a unidades de seguridad y GitOps.

## Privilegios

Documentar:

- que `kubectl` opera contra el cluster local;
- que no se requieren credenciales cloud;
- que no deben usarse privilegios de administrador para crear recursos Kubernetes;
- que los permisos locales de MicroK8s pertenecen a Unidad 00.

## Operaciones destructivas

| Operacion | Advertencia | Alcance | Recuperacion | Confirmacion requerida |
|---|---|---|---|---|
| `kubectl delete namespace platform-training` | Elimina la aplicacion y configuracion acumulada | Recursos funcionales del curso | Reaplicar `labs/02-configuration-lifecycle/solution/` | Confirmacion explicita en tutorial |
| `kubectl delete secret platform-api-secret` | Puede impedir que nuevos Pods arranquen | Secret de laboratorio | Reaplicar `secret.yaml` | No, si esta dentro de un ejercicio guiado |
| `kubectl delete configmap platform-api-config` | Puede impedir que nuevos Pods arranquen o pierdan configuracion | Configuracion de laboratorio | Reaplicar `configmap.yaml` | No, si esta dentro de un ejercicio guiado |

No usar `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de Unidad 02.

---

# Requisitos de portabilidad

## Kubernetes estandar

- `ConfigMap`;
- `Secret`;
- `Deployment`;
- `Service`;
- variables de entorno desde `configMapKeyRef`, `secretKeyRef` o `envFrom`;
- volumenes desde ConfigMap;
- `startupProbe`, `readinessProbe`, `livenessProbe`;
- `resources.requests` y `resources.limits`;
- `kubectl apply`, `get`, `describe`, `logs`, `rollout status`.

## Especifico de MicroK8s

- validacion de disponibilidad del cluster local;
- contexto local heredado de Unidad 00;
- posible fallback con `microk8s kubectl` para diagnostico;
- recursos disponibles dependen del host WSL.

## Especifico de AKS

No aplica en esta unidad.

## Especifico de EKS

No aplica en esta unidad.

## Estrategia de desacoplamiento

- usar APIs Kubernetes estandar;
- evitar dependencias de addons MicroK8s fuera de la baseline heredada;
- mantener nombres y labels preparados para Helm;
- no depender de servicios externos;
- documentar cualquier valor de recurso elegido para laboratorio como baseline inicial, no como recomendacion universal de produccion.

---

# Restricciones de generacion

La IA no debe:

- generar contenido de Unidad 03 o posteriores;
- crear charts Helm;
- crear modulos Terraform;
- instalar o configurar Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- introducir Ingress o Gateway API practicos;
- introducir PV, PVC o StorageClass;
- redefinir la plataforma local ni sustituir MicroK8s;
- introducir Minikube, kind o Docker Desktop Kubernetes como plataforma paralela;
- usar Secrets con valores reales;
- exponer valores de Secret completos en logs, tutorial o salida de validacion;
- crear dependencias obligatorias de servicios cloud o corporativos;
- asumir que un recurso fue desplegado sin ejecutar validacion real o recibir evidencia del usuario;
- modificar scripts de Unidad 00 salvo correccion justificada;
- resolver la deuda de hardening pedagogico global salvo decision explicita.

La IA si puede:

- crear manifiestos Kubernetes declarativos que extiendan `platform-api`;
- crear ConfigMaps y Secrets de laboratorio;
- definir probes y resources en el Deployment;
- crear scripts de validacion del laboratorio;
- documentar comandos de diagnostico y recuperacion;
- registrar decisiones, limitaciones y evidencias en `summary.md` y `project/project-state.md`;
- usar `kubectl` contra MicroK8s validado.

---

# Criterios de aceptacion

La unidad se considerara completada cuando:

- [ ] exista `tutorial/02-configuration-lifecycle/README.md`;
- [ ] exista `tutorial/02-configuration-lifecycle/instructor-notes.md`;
- [ ] exista `tutorial/02-configuration-lifecycle/summary.md`;
- [ ] exista `labs/02-configuration-lifecycle/README.md`;
- [ ] existan manifiestos en `labs/02-configuration-lifecycle/starter/`;
- [ ] existan manifiestos en `labs/02-configuration-lifecycle/solution/`;
- [ ] exista `labs/02-configuration-lifecycle/validation/validate.sh`;
- [ ] `platform-api` se mantenga como aplicacion evolutiva;
- [ ] `platform-training` se mantenga como namespace funcional;
- [ ] el Service conserve selectors compatibles con los Pods;
- [ ] existan ConfigMap y Secret de laboratorio;
- [ ] el Deployment consuma configuracion mediante variables de entorno;
- [ ] el Deployment consuma configuracion mediante volumen cuando sea viable;
- [ ] el Deployment declare `startupProbe`, `readinessProbe` y `livenessProbe`;
- [ ] el Deployment declare requests y limits;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] las validaciones estaticas y funcionales posibles hayan sido ejecutadas;
- [ ] las validaciones no ejecutadas esten declaradas;
- [ ] no existan secretos reales;
- [ ] el tutorial incluya referencias oficiales o fuentes primarias relevantes;
- [ ] Helm y Terraform no gestionen todavia recursos del curso;
- [ ] `project/project-state.md` este actualizado;
- [ ] el resultado prepare la Unidad 03;
- [ ] no existan contradicciones abiertas.

---

# Estado final esperado

## Plataforma

- MicroK8s local sigue disponible y validado;
- `kubectl` sigue siendo el cliente principal;
- no se han introducido cambios estructurales en `platform/environment/`;
- Helm y Terraform siguen instalados pero no gestionan recursos del curso.

## Aplicacion

- `platform-api` sigue desplegada en `platform-training`;
- Deployment operativo con dos replicas salvo que el tutorial justifique otro valor;
- Service interno `ClusterIP` conserva endpoints;
- configuracion no sensible gestionada por ConfigMap;
- valores sensibles ficticios gestionados por Secret de laboratorio;
- probes declaradas y observables;
- requests y limits iniciales declarados.

## Automatizacion

- manifiestos Kubernetes declarativos disponibles en `labs/02-configuration-lifecycle/solution/`;
- validacion ejecutable disponible para comprobar el estado del laboratorio;
- sin charts Helm, releases Helm, modulos Terraform ni estado Terraform.

## Observabilidad

- estado, eventos, logs, probes y endpoints inspeccionables con `kubectl`;
- sin Prometheus, Grafana, Loki, Tempo ni OpenTelemetry;
- sin metricas avanzadas ni dashboards.

## Seguridad

- sin credenciales reales;
- Secret de laboratorio con valores ficticios;
- riesgos y limites de Secrets documentados.

## Artefactos principales

```text
tutorial/02-configuration-lifecycle/README.md
tutorial/02-configuration-lifecycle/instructor-notes.md
tutorial/02-configuration-lifecycle/summary.md
labs/02-configuration-lifecycle/README.md
labs/02-configuration-lifecycle/starter/
labs/02-configuration-lifecycle/solution/
labs/02-configuration-lifecycle/validation/validate.sh
project/project-state.md
```

---

# Informacion obligatoria para el summary

El `summary.md` debera destacar:

- ConfigMaps creados y claves relevantes no sensibles;
- Secrets de laboratorio creados y tratamiento seguro aplicado;
- forma de consumo de configuracion por `platform-api`;
- probes declaradas y endpoints o paths usados;
- requests y limits definidos;
- recursos desplegados;
- comandos de validacion principales;
- decisiones especificas;
- referencias principales utilizadas;
- dependencias nuevas, si existen;
- validaciones ejecutadas y pendientes;
- limitaciones;
- deuda tecnica;
- elementos que debe reutilizar la Unidad 03;
- estado final verificable.

---

# Impacto esperado en project-state

Al crear este playbook, actualizar como minimo:

- artefactos de gobierno para registrar `playbooks/units/02-configuration-lifecycle.md`;
- estado de la Unidad 02 como pendiente de generacion o pendiente de aprobacion del playbook;
- siguiente incremento permitido.

Al cerrar la unidad, actualizar como minimo:

- fase actual;
- ultimo incremento completado;
- unidad activa;
- ultima unidad completada;
- siguiente incremento permitido;
- estructura actual del repositorio;
- estado de la Unidad 02;
- estado de la aplicacion evolutiva;
- ConfigMaps y Secrets de laboratorio;
- probes y resources;
- decisiones especificas de Unidad 02;
- riesgos y deuda tecnica;
- validaciones globales disponibles.

No registrar componentes previstos como si estuvieran implementados.

---

# Conexion con la siguiente unidad

## Siguiente unidad prevista

```text
03 - Networking e ingreso
```

## Capacidades que deja preparadas

- aplicacion configurable;
- ConfigMap y Secret de laboratorio;
- probes que permiten razonar sobre endpoints listos;
- requests y limits iniciales;
- validacion ampliada del workload;
- manifiestos acumulados listos para exponer la aplicacion de manera controlada.

## Elementos que la siguiente unidad debera reutilizar

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Manifiestos de solucion | `labs/02-configuration-lifecycle/solution/` | Base para Ingress, Gateway API o diagnostico de networking |
| Summary Unidad 02 | `tutorial/02-configuration-lifecycle/summary.md` | Fuente de continuidad |
| Namespace funcional | `platform-training` | Aislamiento de recursos del curso |
| Aplicacion evolutiva | `platform-api` | Debe evolucionar sin reemplazarse |
| Service interno | `service/platform-api` | Punto de partida para ingreso |
| Readiness probe | Deployment `platform-api` | Relacionar endpoints listos con entrada HTTP |

## Elementos que no deben modificarse todavia

- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- stacks de observabilidad;
- recursos cloud;
- almacenamiento persistente.

---

# Riesgos especificos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|---|---|---|---|
| Secret de laboratorio se confunde con secreto productivo | Media | Alto | Usar valores ficticios y documentar limites claramente |
| Probes demasiado agresivas provocan reinicios o falta de endpoints | Media | Medio | Valores conservadores y escenario de diagnostico guiado |
| Requests demasiado altos no planifican en hosts modestos | Media | Medio | Baseline bajo y validacion de eventos de scheduling |
| Montaje de ConfigMap pisa archivos necesarios de la imagen | Media | Medio | Montar rutas concretas y validar HTTP |
| Modificar selectors rompe el Service heredado | Media | Medio | Mantener labels base y validar endpoints |
| Uso prematuro de Helm o Terraform | Baja | Medio | Restricciones explicitas y revision de artefactos |
| Contenido sigue siendo demasiado exigente como entrada | Media | Medio | Mantener deuda de hardening global y cuidar progresion local sin resolverla por completo |

---

# Cuestiones abiertas

| Cuestion | Bloqueante | Momento de resolucion |
|---|---|---|
| Confirmacion de nombres `platform-api-config` y `platform-api-secret` | No para aprobar este playbook; si para generar la Unidad 02 | Generacion de la Unidad 02 |
| Claves exactas de configuracion | No para aprobar este playbook; si para validar el laboratorio | Generacion de la Unidad 02 |
| Paths HTTP exactos de probes | No para aprobar este playbook; si para validar el laboratorio | Generacion y validacion de Unidad 02 |
| Valores exactos de requests y limits | No para aprobar este playbook; si para ejecutar en MicroK8s | Generacion y validacion de Unidad 02 |
| Uso de EndpointSlice en lugar de Endpoints para validacion | No | Unidad 02 puede conservar Endpoints con advertencia o introducir EndpointSlice como observacion tecnica |

---

# Checklist de revision del playbook

Antes de aprobar este documento:

- [x] la unidad existe en `project/roadmap.md`;
- [x] el identificador y las rutas son consistentes;
- [x] el alcance no invade unidades posteriores;
- [x] las dependencias son verificables;
- [x] los artefactos previos estan identificados;
- [x] los entregables estan definidos;
- [x] las validaciones son suficientes;
- [x] los escenarios de error son realistas;
- [x] las restricciones de seguridad estan declaradas;
- [x] la portabilidad esta considerada;
- [x] los criterios de aceptacion son objetivos;
- [x] el estado final esta claramente definido;
- [x] la conexion con la siguiente unidad es explicita;
- [x] no contradice arquitectura, estado, roadmap ni playbook maestro.

---

# Metadatos de mantenimiento

## Fecha de creacion

```text
2026-07-18
```

## Ultima revision

```text
2026-07-18
```

## Motivo de la ultima revision

```text
Playbook aprobado por el usuario para iniciar la generacion de la Unidad 02.
```

## Documentos afectados por cambios futuros

Cambios de alcance, rutas, entregables, validaciones o estado de aprobacion de este playbook deberan revisar tambien:

```text
project/project-state.md
project/roadmap.md
project/project-planning.md
playbooks/master.md
tutorial/01-kubernetes/summary.md
```
