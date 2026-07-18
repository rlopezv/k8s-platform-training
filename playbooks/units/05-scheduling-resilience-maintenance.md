# Playbook de la Unidad 05 - Scheduling, resiliencia y mantenimiento

## Identificacion

### Unidad

```text
05 - Scheduling, resiliencia y mantenimiento
```

### Identificador

```text
05-scheduling-resilience-maintenance
```

### Fase del roadmap

```text
Fase 2 - Fundamentos Kubernetes
```

### Estado del playbook

```text
En revision
```

### Propietario logico

```text
Fundamentos Kubernetes
```

---

# Proposito de la unidad

La Unidad 05 introduce como Kubernetes decide donde ejecutar los Pods, como una aplicacion se comporta durante fallos controlados y como se realizan operaciones basicas de mantenimiento sin perder de vista la continuidad del servicio. La unidad parte de `platform-api` con configuracion externa, Secret ficticio, probes, requests/limits, Service, Ingress y persistencia local de laboratorio ya validados en la Unidad 04.

La unidad aparece en este punto porque el alumno ya puede desplegar, configurar, exponer, observar y persistir datos de laboratorio. Ahora debe aprender que la disponibilidad no depende solo de tener replicas: tambien depende de scheduling, capacidad del cluster, probes, estrategia de despliegue, interrupciones voluntarias, limites de recursos, persistencia local y procedimientos de recuperacion.

## Supuesto pedagogico

La unidad debe escribirse para alumnos con perfil tecnico que todavia no dominan scheduling ni operacion de resiliencia en Kubernetes.

Se explicaran desde cero:

- scheduler, nodo candidato y decision de colocacion;
- diferencia entre fallo involuntario e interrupcion voluntaria;
- `nodeSelector`, node affinity y pod anti-affinity;
- taints y tolerations como mecanismo de rechazo o aceptacion de Pods;
- `PodDisruptionBudget` y limites de disponibilidad durante mantenimiento;
- `strategy`, `rollingUpdate`, rollout y rollback de un Deployment;
- relacion entre replicas, probes, resources, EndpointSlice, Service e Ingress durante cambios;
- limites de resiliencia en un cluster local de un solo nodo;
- impacto de PVC local sobre scheduling, replicas y mantenimiento.

Se retomaran de unidades anteriores:

- `platform-api` como aplicacion evolutiva;
- namespace `platform-training`;
- Deployment, ReplicaSet, Pods, labels, selectors, ConfigMap, Secret ficticio, probes y resources;
- Service `ClusterIP`, EndpointSlice e Ingress HTTP local;
- PVC `platform-api-data` montado en `/usr/share/nginx/html/persistent`;
- diagnostico con `kubectl get`, `describe`, `logs`, `exec`, eventos y rollout;
- separacion entre README de entrada, `student-notes.md` y README operativo del laboratorio.

Se mencionaran y diferiran:

- escalado automatico con HPA o KEDA;
- observabilidad avanzada con Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- estrategias blue/green, canary y progressive delivery;
- chaos engineering;
- mantenimiento multi-nodo real y drain productivo;
- alta disponibilidad cloud en AKS/EKS;
- politicas avanzadas de seguridad, admision y gobernanza.

Errores de razonamiento que deben prevenirse:

- creer que dos replicas garantizan alta disponibilidad en un cluster de un solo nodo;
- usar anti-affinity estricta en un entorno donde no hay nodos suficientes;
- confundir taints/tolerations con una forma de forzar colocacion;
- asumir que un PDB evita todos los fallos, cuando solo limita interrupciones voluntarias;
- ejecutar `drain` o borrar nodos como si fuera una limpieza inocua;
- ignorar que un PVC local puede condicionar donde puede arrancar un Pod;
- declarar resiliencia sin observar endpoints, rollout, eventos y recuperacion.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- explicar como el scheduler decide si un Pod puede ejecutarse en un nodo;
- aplicar constraints simples de scheduling sin romper `platform-api`;
- comparar `nodeSelector`, affinity, anti-affinity, taints y tolerations;
- configurar una estrategia de rolling update verificable para `platform-api`;
- ejecutar y diagnosticar un rollout y un rollback controlado;
- definir un `PodDisruptionBudget` coherente con replicas y entorno local;
- simular fallos controlados de Pod y validar recuperacion por Deployment;
- distinguir limites de resiliencia de MicroK8s local frente a un cluster multi-nodo;
- diagnosticar Pods `Pending`, rollouts bloqueados y disponibilidad degradada;
- registrar en `summary.md` el estado estable que reutilizara la Unidad 06.

---

# Alcance

## Incluido

- reutilizacion de `platform-api`, `platform-training` y `labs/04-persistence-state/solution/`;
- laboratorio de Unidad 05 en `labs/05-scheduling-resilience-maintenance/`;
- tutorial, `student-notes.md`, notas del instructor y summary de continuidad;
- explicacion de scheduler, constraints de colocacion y eventos de scheduling;
- uso controlado de labels de nodo para observar `nodeSelector` o node affinity;
- uso pedagogico de pod anti-affinity preferida, no obligatoria, para no bloquear el cluster local;
- introduccion de taints y tolerations como concepto y demostracion acotada cuando sea seguro;
- creacion de un `PodDisruptionBudget` para `platform-api`;
- ajuste explicito de estrategia de `RollingUpdate` en el Deployment;
- procedimientos de rollout, rollback, recreacion de Pods y diagnostico;
- simulacion controlada de fallos de Pods sin destruir el entorno;
- comparacion entre resiliencia local de un nodo y disponibilidad multi-nodo futura;
- validacion estatica y funcional de los manifiestos generados;
- actualizacion de `project/project-state.md` al generar y cerrar la unidad, no durante la creacion de este playbook.

## Excluido

- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automatico;
- NetworkPolicies, service mesh, mTLS o seguridad avanzada de red;
- TLS productivo, DNS publico o LoadBalancer cloud;
- estrategias canary, blue/green o progressive delivery con controladores externos;
- chaos engineering destructivo o pruebas de carga;
- mantenimiento real de nodos productivos;
- creacion de clusters multi-nodo, AKS o EKS;
- sustitucion de `platform-api` por otra aplicacion;
- cambio de namespace funcional;
- eliminacion de PVC o datos persistentes como parte normal de la unidad;
- introduccion de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Helm | Unidad 06 | La Unidad 05 debe estabilizar manifiestos antes de empaquetarlos |
| Terraform | Unidad 07 | Requiere chart y limites claros entre infraestructura y despliegue |
| Tekton | Unidad 08 | Requiere validaciones y artefactos versionados consolidados |
| Argo CD | Unidad 09 | Requiere layout declarativo estable y Helm |
| Promocion entre entornos | Unidad 10 | Requiere empaquetado y automatizacion previos |
| Observabilidad avanzada | Unidades 11-14 | La Unidad 05 usa senales nativas antes de stacks dedicados |
| Seguridad avanzada | Unidades 16-18 | Requiere baseline operativo estable |
| Autoscaling y KEDA | Unidades posteriores | Requiere metricas y observabilidad previas |
| AKS/EKS y mantenimiento cloud | Unidades 20-25 | Requiere decisiones de plataforma gestionada |

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
10. `tutorial/04-persistence-state/README.md`;
11. `tutorial/04-persistence-state/student-notes.md`;
12. `tutorial/04-persistence-state/summary.md`;
13. este playbook;
14. `labs/04-persistence-state/README.md`;
15. `labs/04-persistence-state/solution/namespace.yaml`;
16. `labs/04-persistence-state/solution/configmap.yaml`;
17. `labs/04-persistence-state/solution/secret.yaml`;
18. `labs/04-persistence-state/solution/pvc.yaml`;
19. `labs/04-persistence-state/solution/deployment.yaml`;
20. `labs/04-persistence-state/solution/service.yaml`;
21. `labs/04-persistence-state/solution/ingress.yaml`;
22. `labs/04-persistence-state/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 04 esta cerrada, validada funcionalmente, aprobada por el usuario y existe `tutorial/04-persistence-state/summary.md`.

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
playbooks/units/05-scheduling-resilience-maintenance.md
tutorial/04-persistence-state/summary.md
tutorial/04-persistence-state/student-notes.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| Ubuntu WSL objetivo | Validado como Ubuntu 24.04 LTS | `cat /etc/os-release` o validacion heredada |
| MicroK8s | Instalado y operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| Addon DNS | Habilitado | `microk8s status --wait-ready` y validacion heredada |
| Addon Ingress de MicroK8s | Activo para validar HTTP heredado | `bash labs/04-persistence-state/validation/validate.sh` |
| Addon `hostpath-storage` | Activo si se valida persistencia heredada | `kubectl get storageclass` |
| Namespace `platform-training` | Existente o aplicable desde manifiesto | `kubectl get namespace platform-training` |
| Deployment `platform-api` | Definido y desplegable desde Unidad 04 | `kubectl -n platform-training rollout status deployment/platform-api` |
| Service `platform-api` | `ClusterIP` interno con endpoints | `kubectl -n platform-training get service platform-api` y EndpointSlice |
| Ingress `platform-api` | Recurso HTTP local heredado | `kubectl -n platform-training get ingress platform-api` |
| PVC `platform-api-data` | `Bound` cuando la Unidad 04 este aplicada | `kubectl -n platform-training get pvc platform-api-data` |
| Helm | Instalado, pero no usado para desplegar la unidad | `helm version --short` |
| Terraform | Instalado, pero no usado para gestionar recursos | `terraform version` |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00 y validacion del entorno local;
- Unidad 01 y relacion entre Deployment, ReplicaSet, Pod, Service, labels y selectors;
- Unidad 02 y uso de ConfigMap, Secret ficticio, probes, requests y limits;
- Unidad 03 y relacion entre Service, EndpointSlice e Ingress;
- Unidad 04 y relacion entre PVC, PV, StorageClass, volumen montado y persistencia local;
- lectura basica de YAML;
- uso basico de `kubectl apply`, `get`, `describe`, `logs`, `exec`, `rollout status`, `rollout history`, `rollout undo` y `delete pod` con alcance controlado.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/04-persistence-state/summary.md
tutorial/04-persistence-state/student-notes.md
labs/04-persistence-state/README.md
labs/04-persistence-state/solution/namespace.yaml
labs/04-persistence-state/solution/configmap.yaml
labs/04-persistence-state/solution/secret.yaml
labs/04-persistence-state/solution/pvc.yaml
labs/04-persistence-state/solution/deployment.yaml
labs/04-persistence-state/solution/service.yaml
labs/04-persistence-state/solution/ingress.yaml
labs/04-persistence-state/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` desplegada sobre MicroK8s en el namespace `platform-training`, con configuracion externa, Secret ficticio, probes, resources, Service interno, Ingress HTTP local y PVC de laboratorio.

Estado verificable esperado:

- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` disponibles segun estado heredado;
- `kubectl` `v1.35.6` configurado como cliente principal;
- addon `dns` de MicroK8s habilitado;
- Ingress Controller local de MicroK8s activo;
- addon `hostpath-storage` habilitado y StorageClass `microk8s-hostpath` disponible si se valida la Unidad 04 aplicada;
- namespace `platform-training` definido en `labs/04-persistence-state/solution/namespace.yaml`;
- Deployment `platform-api` definido con dos replicas, imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`, ConfigMap, Secret de laboratorio, probes, resources y montaje de PVC;
- PVC `platform-api-data` definido y montado en `/usr/share/nginx/html/persistent`;
- Service `platform-api` de tipo `ClusterIP`;
- Ingress `platform-api` para host `platform-api.local`;
- no existen PDB, Jobs, CronJobs, charts Helm, modulos Terraform, pipelines ni recursos cloud del curso.

No debe asumirse que el laboratorio esta desplegado en el cluster si no se ejecuta validacion real o el usuario aporta evidencia.

## Validacion del estado inicial

Ejecutar desde Ubuntu WSL objetivo cuando se vaya a generar o validar funcionalmente la unidad:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/04-persistence-state/validation/validate.sh
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc
kubectl get nodes --show-labels
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
deployment/platform-api esta disponible.
service/platform-api existe como ClusterIP y selecciona Pods Ready.
ingress/platform-api conserva host platform-api.local.
persistentvolumeclaim/platform-api-data esta Bound.
El cluster local muestra al menos un nodo Ready.
```

Si la Unidad 04 no esta aplicada, la unidad puede documentar la recuperacion aplicando `labs/04-persistence-state/solution/`, sin declarar validacion funcional hasta ejecutarla.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 04 | `tutorial/04-persistence-state/summary.md` | Continuidad tecnica, decisiones y limitaciones |
| Student notes Unidad 04 | `tutorial/04-persistence-state/student-notes.md` | Continuidad pedagogica sobre persistencia y estado |
| Namespace base | `labs/04-persistence-state/solution/namespace.yaml` | Mantener `platform-training` como namespace funcional |
| ConfigMap base | `labs/04-persistence-state/solution/configmap.yaml` | Conservar configuracion no sensible y contenido HTML base |
| Secret de laboratorio | `labs/04-persistence-state/solution/secret.yaml` | Conservar valores ficticios sin imprimirlos |
| PVC de laboratorio | `labs/04-persistence-state/solution/pvc.yaml` | Mantener persistencia heredada y explicar impacto en scheduling |
| Deployment evolucionado | `labs/04-persistence-state/solution/deployment.yaml` | Base de `platform-api` para incorporar estrategia de rollout y constraints seguros |
| Service interno | `labs/04-persistence-state/solution/service.yaml` | Mantener contrato interno y backend del Ingress |
| Ingress local | `labs/04-persistence-state/solution/ingress.yaml` | Mantener acceso HTTP local a la aplicacion |
| Validacion Unidad 04 | `labs/04-persistence-state/validation/validate.sh` | Precondicion funcional |
| Labels base | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` | Selectors, continuidad operativa y diagnostico |
| Estado del proyecto | `project/project-state.md` | Registro de hechos generados y validados cuando se genere la unidad |

## Reglas de reutilizacion

- mantener `platform-api` como aplicacion evolutiva;
- mantener `platform-training` como namespace funcional;
- conservar `service/platform-api` como `ClusterIP`;
- conservar `ingress/platform-api` como punto de entrada HTTP local salvo defecto real y documentado;
- no cambiar selectors del Service salvo defecto real y documentado;
- no sustituir la imagen de `platform-api` salvo decision explicita y justificada;
- no exponer ni decodificar valores del Secret de laboratorio;
- conservar el PVC heredado y explicar sus limites de scheduling en MicroK8s local;
- crear artefactos de Unidad 05 en una ruta propia y declarar que extienden la solucion de Unidad 04;
- no usar Helm ni Terraform para aplicar los recursos;
- no ejecutar operaciones destructivas de nodos o almacenamiento como parte automatica de la validacion.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Responsabilidad | Ubicacion prevista |
|---|---|---|
| Tutorial de la Unidad 05 | Guiar conceptos de scheduling, resiliencia y mantenimiento | `tutorial/05-scheduling-resilience-maintenance/README.md` |
| Student notes | Material pedagogico profundo sobre colocacion, disponibilidad y mantenimiento | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` |
| Notas del instructor | Facilitar imparticion, simulaciones y evaluacion | `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md` |
| Summary | Registrar continuidad tecnica y pedagogica | `tutorial/05-scheduling-resilience-maintenance/summary.md` |
| Laboratorio | Contener instrucciones y artefactos declarativos | `labs/05-scheduling-resilience-maintenance/README.md` |
| PodDisruptionBudget | Proteger disponibilidad minima durante interrupciones voluntarias | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` |
| Manifiestos heredados versionados para Unidad 05 | Nueva base acumulativa con resiliencia declarada | `labs/05-scheduling-resilience-maintenance/solution/` |
| Validacion del laboratorio | Comprobacion del estado esperado y recuperacion controlada | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar existencia, generacion y cierre de Unidad 05 segun corresponda | Mantiene estado real como fuente de verdad |
| Deployment `platform-api` | Declarar estrategia de rolling update, revision history y constraints seguros | Debe conservar nombre, labels, PVC, probes, resources y variables heredadas |
| ConfigMap `platform-api-config` | Puede ajustar texto visible para reflejar Unidad 05 | Debe seguir siendo configuracion no sensible |
| Service `platform-api` | Debe conservarse como `ClusterIP` | Mantiene backend del Ingress |
| Ingress `platform-api` | Debe conservar host y backend salvo defecto documentado | Mantiene acceso HTTP local |

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseno de la unidad

## D-05-01 - Resiliencia explicada desde el Deployment existente

### Decision

La unidad incorporara scheduling y resiliencia extendiendo el Deployment `platform-api`, sin sustituir la aplicacion ni crear un workload alternativo como eje principal.

### Motivo

La continuidad del itinerario exige que el alumno observe como una misma aplicacion cambia de comportamiento operativo al introducir decisiones de scheduling, rollout y mantenimiento.

### Consecuencias

- `platform-api` conserva su contrato de red y persistencia;
- los cambios deben ser auditables en el Deployment;
- cualquier limitacion por PVC local o nodo unico debe explicarse como parte del modelo.

### Alternativas descartadas

- Crear una aplicacion nueva para scheduling: rompe continuidad pedagogica.
- Usar solo Pods sueltos: evita observar rollout, ReplicaSet y recuperacion real.

## D-05-02 - Preferir constraints no bloqueantes en laboratorio local

### Decision

La unidad usara constraints seguros para MicroK8s local. Cuando se muestre anti-affinity, debera ser preferida (`preferredDuringSchedulingIgnoredDuringExecution`) o demostrarse de forma controlada como fallo esperado, no como configuracion final que bloquee el despliegue.

### Motivo

El entorno validado es local y puede tener un solo nodo. Una anti-affinity obligatoria entre replicas puede dejar Pods `Pending` y convertir un concepto de resiliencia en una rotura permanente del laboratorio.

### Consecuencias

- el alumno aprende la diferencia entre preferencia y requisito;
- la validacion funcional debe poder completarse en un nodo;
- el summary debe registrar que la resiliencia multi-nodo queda limitada en MicroK8s local.

### Alternativas descartadas

- Exigir multi-nodo: anticipa infraestructura fuera de alcance.
- Omitir anti-affinity: deja sin marco una capacidad prevista en el roadmap.

## D-05-03 - PDB como proteccion ante interrupciones voluntarias

### Decision

La unidad creara un `PodDisruptionBudget` para `platform-api` y explicara que protege frente a interrupciones voluntarias compatibles con la API, no frente a fallos espontaneos de nodo o procesos.

### Motivo

El PDB permite introducir mantenimiento responsable antes de Helm y cloud, pero suele malinterpretarse como garantia absoluta de disponibilidad.

### Consecuencias

- el laboratorio debe comprobar el PDB sin depender de un drain destructivo;
- las notas deben distinguir `delete pod`, rollout, eviction y fallo involuntario;
- en un cluster de un nodo, el PDB puede limitar operaciones de mantenimiento y debe explicarse.

### Alternativas descartadas

- Ejecutar `kubectl drain` como validacion automatica: puede ser destructivo y poco portable.
- Diferir PDB: perderia una pieza esencial de mantenimiento seguro.

## D-05-04 - Rollout y rollback antes de Helm

### Decision

La unidad usara `kubectl rollout` y cambios declarativos de manifiestos para explicar actualizacion y rollback antes de introducir Helm en la Unidad 06.

### Motivo

El alumno necesita comprender el comportamiento nativo de Deployment y ReplicaSet antes de delegarlo en releases Helm.

### Consecuencias

- el laboratorio debe mostrar `rollout status`, `rollout history` y `rollout undo`;
- no se crearan charts ni releases;
- la Unidad 06 podra empaquetar un conjunto de manifiestos ya estabilizado.

### Alternativas descartadas

- Usar Helm rollback: anticipa Unidad 06.
- Usar Argo CD o Tekton: anticipa unidades posteriores.

## D-05-05 - Mantenimiento seguro, no destruccion del entorno

### Decision

La unidad documentara mantenimiento con simulaciones controladas, revision de PDB y recreacion de Pods, evitando automatizar `drain`, eliminacion de nodos, reset de MicroK8s o borrado de PVC.

### Motivo

El objetivo es aprender el modelo operativo sin poner en riesgo el entorno local ni los datos persistentes de laboratorio.

### Consecuencias

- cualquier operacion potencialmente destructiva debe quedar marcada como demostracion opcional y manual;
- `validate.sh` no debe drenar nodos ni borrar PVC;
- la recuperacion debe basarse en reaplicar manifiestos y observar eventos.

### Alternativas descartadas

- Usar reset de MicroK8s como prueba de resiliencia: pertenece a recuperacion de entorno, no a esta unidad.
- Borrar PVC para simular fallo: mezcla resiliencia de workload con perdida de datos.

## D-05-06 - Laboratorio acumulativo con ruta propia

### Decision

La Unidad 05 tendra su propio directorio `labs/05-scheduling-resilience-maintenance/` con la solucion evolucionada, reutilizando semanticamente los manifiestos de Unidad 04.

### Motivo

Mantiene trazabilidad por unidad sin modificar retroactivamente el estado final de la Unidad 04.

### Consecuencias

- `labs/04-persistence-state/solution/` queda como evidencia de salida de Unidad 04;
- `labs/05-scheduling-resilience-maintenance/solution/` sera la nueva base para Unidad 06;
- el summary debera indicar claramente que Unidad 06 reutiliza la solucion de Unidad 05.

### Alternativas descartadas

- Editar solo `labs/04-persistence-state/solution/`: dificulta auditar la evolucion entre unidades.
- Crear manifiestos sin relacion con la solucion previa: rompe continuidad.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/05-scheduling-resilience-maintenance/README.md
```

Debe actuar como puerta de entrada de la unidad. Debe incluir:

1. problema real que resuelve la unidad: colocacion, actualizacion y mantenimiento sin perder servicio;
2. por que aparece despues de persistencia;
3. contexto;
4. objetivos;
5. conocimientos previos;
6. relacion con la Unidad 04;
7. estado inicial;
8. mapa de aprendizaje;
9. modelo mental de scheduling, resiliencia e interrupciones;
10. conceptos explicados con profundidad progresiva;
11. como usar `student-notes.md`;
12. como usar el README del laboratorio;
13. decisiones de diseno y trade-offs;
14. validaciones conceptuales y tecnicas;
15. errores de razonamiento frecuentes;
16. resolucion de problemas de scheduling y rollout;
17. recuperacion y limpieza;
18. conclusion;
19. lectura guiada con referencias oficiales, conceptuales y complementarias;
20. conexion con la Unidad 06.

Las referencias deberan priorizar documentacion oficial de Kubernetes sobre scheduling, node affinity, inter-pod affinity, taints and tolerations, PodDisruptionBudget, Deployments, rolling updates, rollbacks, Jobs y CronJobs. Cualquier material secundario debera complementar esas fuentes, no sustituirlas.

El tutorial no debe escribirse como una guia de laboratorio extendida. Los comandos repetitivos, secuencias completas de despliegue, recuperacion operacional y validacion mecanica pertenecen al README del laboratorio, salvo comandos puntuales que ayuden a observar o razonar sobre un concepto.

## Notas del alumno

Ruta:

```text
tutorial/05-scheduling-resilience-maintenance/student-notes.md
```

Debe ser el material pedagogico profundo de la unidad. Debe construir comprension antes de pedir ejecucion. Debe incluir:

- modelo mental de scheduler, nodos, capacidad, restricciones y disponibilidad;
- glosario razonado de scheduler, node labels, `nodeSelector`, affinity, anti-affinity, taints, tolerations, PDB, eviction, rollout, rollback, Job y CronJob;
- diferencia entre recuperacion automatica de Pods y disponibilidad real;
- relacion entre replicas, Service, EndpointSlice, probes y rollout;
- relacion entre PVC local y restricciones de colocacion;
- lectura guiada de los manifiestos de Unidad 05;
- errores de razonamiento frecuentes;
- preguntas de comprobacion;
- limites de alcance y continuidad.

No debe duplicar el README del laboratorio. Puede incluir comandos puntuales de observacion, pero no secuencias operativas completas.

## Notas del instructor

Ruta:

```text
tutorial/05-scheduling-resilience-maintenance/instructor-notes.md
```

Debe incluir:

- intencion pedagogica;
- puntos de enfasis;
- demostraciones recomendadas;
- errores frecuentes;
- errores de razonamiento;
- preguntas de comprobacion;
- criterios de evaluacion;
- riesgos tecnicos;
- limites de alcance para no anticipar Helm, Terraform, autoscaling, observabilidad avanzada, progressive delivery, seguridad avanzada ni cloud.

## Resumen

Ruta:

```text
tutorial/05-scheduling-resilience-maintenance/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Laboratorio

Ruta normal:

```text
labs/05-scheduling-resilience-maintenance/
```

## Estado del proyecto

Actualizar durante la generacion y cierre de la unidad:

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
labs/05-scheduling-resilience-maintenance/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── pdb.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/05-scheduling-resilience-maintenance/README.md` | Referencia operativa del laboratorio |
| `labs/05-scheduling-resilience-maintenance/starter/` | Punto de partida guiado con manifiestos heredados y resiliencia incompleta |
| `labs/05-scheduling-resilience-maintenance/solution/` | Estado final reutilizable por Unidad 06 |
| `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` | Presupuesto de interrupcion para `platform-api` |
| `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | Workload `platform-api` evolucionado con estrategia de rollout y constraints seguros |
| `labs/05-scheduling-resilience-maintenance/solution/service.yaml` | Service interno conservado |
| `labs/05-scheduling-resilience-maintenance/solution/ingress.yaml` | Ingress local conservado |
| `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Validacion de recursos, rollout, PDB y recuperacion controlada |

---

# Flujo pedagogico obligatorio

La unidad debera seguir este orden conceptual:

1. recuperar el estado final de Unidad 04;
2. explicar que tener replicas no equivale automaticamente a alta disponibilidad;
3. construir el modelo del scheduler: Pod pendiente, nodos candidatos, constraints y eventos;
4. observar labels del nodo local y estado de Pods;
5. explicar constraints seguros: `nodeSelector`, affinity y anti-affinity preferida;
6. explicar taints y tolerations como rechazo/aceptacion, no como seleccion directa;
7. introducir PDB y diferencia entre fallo involuntario e interrupcion voluntaria;
8. revisar estrategia de rolling update del Deployment;
9. ejecutar rollout, observar ReplicaSets, endpoints y HTTP;
10. ejecutar rollback controlado;
11. simular fallo de Pod y comprobar recuperacion;
12. diagnosticar al menos un fallo realista de scheduling o rollout;
13. consolidar limites de MicroK8s local y estado que reutilizara Unidad 06.

Este orden es necesario porque el alumno debe entender primero que problema operativo intenta resolver. Saltar directamente a affinity o PDB convierte la unidad en una lista de campos YAML y oculta la relacion entre colocacion, disponibilidad, interrupciones, red, persistencia y actualizaciones.

---

# Procedimientos obligatorios

## Preparacion

- validar entorno heredado;
- validar que `platform-api` de Unidad 04 esta disponible o reaplicar `labs/04-persistence-state/solution/`;
- confirmar contexto actual de `kubectl`;
- revisar nodos y labels disponibles;
- revisar Pods, EndpointSlice, Service, Ingress y PVC;
- confirmar que no existen PDB previos de `platform-api`;
- documentar limitaciones del cluster local de un nodo.

## Implementacion

- copiar o evolucionar los manifiestos de Unidad 04 hacia `labs/05-scheduling-resilience-maintenance/solution/`;
- mantener `platform-api`, `platform-training`, labels principales, Service `ClusterIP`, Ingress local y PVC;
- anadir `pdb.yaml` para `platform-api`;
- ajustar el Deployment con estrategia de rolling update explicita;
- incorporar constraints de scheduling seguros y compatibles con MicroK8s local;
- mantener constraints que puedan bloquear el laboratorio solo como ejemplo diagnostico, no como estado final;
- aplicar manifiestos en orden explicito;
- documentar comandos exactos y resultados esperados.

## Validacion

- comprobar Deployment disponible;
- comprobar ReplicaSets durante rollout;
- comprobar Service `ClusterIP`;
- comprobar EndpointSlice con endpoints Ready;
- comprobar Ingress heredado;
- comprobar PVC `Bound` y persistencia heredada;
- comprobar PDB creado y estado esperado;
- comprobar que los Pods estan asignados a nodos;
- simular eliminacion controlada de un Pod y validar recreacion;
- ejecutar rollout y rollback controlados;
- ejecutar script de validacion de Unidad 05.

## Diagnostico

- identificar Pod `Pending` por constraints imposibles;
- revisar eventos del scheduler;
- distinguir falta de recursos de mismatch de labels o taints;
- diagnosticar rollout bloqueado por readiness, PDB o imagen incorrecta;
- diagnosticar perdida de endpoints durante actualizacion;
- distinguir fallo de aplicacion de fallo de Service o Ingress;
- revisar impacto del PVC local en scheduling.

## Recuperacion

- reaplicar manifiestos declarativos de Unidad 05;
- volver a la solucion de Unidad 04 si el laboratorio queda en un estado incoherente;
- eliminar o corregir constraints imposibles;
- ejecutar `kubectl rollout undo` cuando el rollout falle;
- recrear Pods de forma controlada;
- volver a ejecutar la validacion.

## Limpieza

- documentar limpieza de cambios temporales de diagnostico;
- documentar eliminacion del PDB como operacion reversible;
- no borrar PVC ni datos persistentes como limpieza normal;
- no ejecutar reset de MicroK8s;
- no automatizar `kubectl drain`;
- no eliminar nodos, namespaces completos ni addons compartidos sin confirmacion explicita.

---

# Validaciones obligatorias

## Validaciones estaticas

| Validacion | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | Revision de manifiestos y busqueda de patrones sensibles | Sin tokens, passwords reales, claves privadas, kubeconfigs ni datos sensibles |
| Sintaxis Bash de validacion | `bash -n labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Codigo de salida 0 |
| Ausencia de Helm charts | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

## Validaciones funcionales

| Validacion | Procedimiento | Resultado esperado |
|---|---|---|
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |
| Estado Unidad 04 | `bash labs/04-persistence-state/validation/validate.sh` | Sin fallos antes de evolucionar la solucion |
| Nodos disponibles | `kubectl get nodes --show-labels` | Al menos un nodo `Ready` |
| Aplicacion de manifiestos | `kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/` | Recursos aplicados sin errores |
| Deployment disponible | `kubectl -n platform-training rollout status deployment/platform-api` | Rollout completado |
| PDB creado | `kubectl -n platform-training get pdb platform-api` | PDB visible con estado coherente |
| Pods asignados | `kubectl -n platform-training get pods -o wide` | Pods de `platform-api` asignados a nodo |
| Eventos de scheduling | `kubectl -n platform-training get events --sort-by=.lastTimestamp` | Sin errores bloqueantes persistentes |
| Service interno | `kubectl -n platform-training get service platform-api` | `TYPE` igual a `ClusterIP` |
| EndpointSlice | `kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api` | Endpoints Ready para Pods disponibles |
| Ingress heredado | `kubectl -n platform-training get ingress platform-api` | Host y backend esperados |
| HTTP por Ingress | `curl` contra el punto de entrada local con host esperado | Respuesta de `platform-api` coherente con Unidad 05 |
| Persistencia heredada | Comprobacion de `/usr/share/nginx/html/persistent/message.txt` cuando exista dato de laboratorio | Dato accesible o ausencia explicada sin perdida accidental |
| Recuperacion de Pod | Eliminar un Pod de `platform-api` | Deployment recrea Pod y recupera disponibilidad |
| Rollout controlado | Cambio declarativo inocuo y `kubectl rollout status` | Nueva revision completada |
| Rollback controlado | `kubectl rollout undo deployment/platform-api` | Revision anterior restaurada |
| Validacion del laboratorio | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Sin fallos |

## Validaciones de continuidad

Comprobar que:

- `labs/04-persistence-state/solution/` permanece como evidencia de Unidad 04;
- `labs/05-scheduling-resilience-maintenance/solution/` contiene el estado que reutilizara Unidad 06;
- `platform-api` conserva nombre, namespace, selector, ConfigMap, Secret de laboratorio, probes, resources, PVC, Service e Ingress salvo ajuste documentado;
- el Service conserva tipo `ClusterIP`;
- el Ingress conserva backend hacia el Service existente;
- el PDB y la estrategia de rollout estan registrados en los manifiestos de Unidad 05;
- Helm y Terraform siguen sin gestionar recursos del curso;
- no existen credenciales reales ni datos sensibles versionados;
- `tutorial/05-scheduling-resilience-maintenance/summary.md` registra constraints, PDB, rollout, rollback, validaciones y limitaciones;
- `project/project-state.md` refleja solo recursos realmente creados y validados.

## Validaciones no ejecutables en el entorno de generacion

Declarar como pendientes cualquier validacion funcional que no se ejecute realmente en MicroK8s.

No afirmar que scheduling, PDB, rollout, rollback, recuperacion, persistencia heredada o HTTP funcionan si solo se revisaron los archivos.

---

# Escenarios de error obligatorios

| Escenario | Sintoma | Diagnostico | Recuperacion |
|---|---|---|---|
| Selector de nodo imposible | Pod queda `Pending` | `kubectl describe pod`, eventos del scheduler, labels de nodo | Corregir selector o label, reaplicar Deployment |
| Anti-affinity obligatoria en un solo nodo | Una replica queda `Pending` | Eventos del scheduler y numero de nodos | Cambiar a preferida o reducir constraint |
| Taint no tolerado | Pod no se programa | `kubectl describe node`, `kubectl describe pod` | Eliminar taint de laboratorio o anadir toleration justificada |
| Recursos insuficientes | Pod queda `Pending` por CPU o memoria | Eventos, `kubectl describe pod`, requests/limits | Ajustar requests de laboratorio o liberar recursos |
| Rollout bloqueado por readiness | `rollout status` no completa | `kubectl describe pod`, logs, probes | Corregir cambio, esperar startup o hacer rollback |
| Imagen erronea en prueba de rollout | Pods en `ImagePullBackOff` | `kubectl describe pod`, eventos | `kubectl rollout undo` y corregir imagen |
| PDB demasiado restrictivo | Eviction o mantenimiento no procede | `kubectl get pdb`, eventos de eviction | Ajustar `minAvailable` o replicas, explicar trade-off |
| Endpoints desaparecen durante actualizacion | Ingress responde error o timeout | EndpointSlice, Service, Pods Ready | Revisar estrategia rolling update y probes |
| PVC local condiciona scheduling | Pod no puede arrancar donde se espera | Eventos, PVC/PV, nodo asociado | Explicar limitacion local y volver a configuracion compatible |
| Contexto `kubectl` equivocado | Recursos no aparecen o se aplican a otro cluster | `kubectl config current-context` y `kubectl get nodes` | Cambiar contexto o reconfigurar desde Unidad 00 |

---

# Requisitos de seguridad

## Datos sensibles

La Unidad 05 no debe introducir credenciales reales ni datos reales de negocio.

Solo se permiten:

- datos de laboratorio no sensibles;
- placeholders no corporativos;
- valores ficticios ya heredados;
- configuracion publica de ejemplo.

No versionar:

- tokens;
- passwords reales;
- claves privadas;
- kubeconfigs personales;
- certificados privados;
- credenciales de proxy;
- datos corporativos;
- dumps de bases de datos reales;
- backups reales;
- informacion personal.

## Privilegios

Documentar:

- que `kubectl` opera contra el cluster local;
- que modificar labels o taints de nodos afecta al scheduling de otros Pods del cluster local;
- que cualquier cambio de taints debe ser acotado, reversible y explicado;
- que no se requieren credenciales cloud;
- que no deben usarse privilegios de administrador para introducir credenciales ni modificar recursos externos.

## Operaciones destructivas

| Operacion | Advertencia | Alcance | Recuperacion | Confirmacion requerida |
|---|---|---|---|---|
| `kubectl delete pod` de `platform-api` | Recrea Pods gestionados por Deployment | Pods de la aplicacion | Deployment crea nuevos Pods | No, si esta dentro de validacion guiada |
| `kubectl rollout undo` | Cambia revision activa del Deployment | Deployment `platform-api` | Reaplicar manifiestos de solution | No, si esta dentro del laboratorio |
| Modificar labels de nodo | Puede afectar a scheduling de otros Pods | Nodo local | Restaurar labels originales documentadas | Confirmacion explicita si afecta labels existentes |
| Anadir taints de laboratorio | Puede impedir scheduling de Pods | Nodo local | Eliminar taint aplicado | Confirmacion explicita |
| `kubectl drain` | Puede desalojar workloads y bloquearse por PDB/PVC | Nodo local y workloads | `kubectl uncordon` y reaplicar manifiestos | Confirmacion explicita; no automatizar |
| `kubectl delete pvc` | Puede eliminar o desconectar datos persistentes | PVC y datos asociados | Reaplicar PVC y restaurar copia si existe | Confirmacion explicita |
| `kubectl delete namespace platform-training` | Elimina aplicacion, configuracion, PVC y datos | Recursos funcionales del curso | Reaplicar solution y restaurar copia si existe | Confirmacion explicita |

No usar `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de Unidad 05.

---

# Requisitos de portabilidad

## Kubernetes estandar

- scheduler;
- node labels;
- `nodeSelector`;
- node affinity;
- pod affinity y anti-affinity;
- taints y tolerations;
- `PodDisruptionBudget`;
- Deployments, ReplicaSets, rolling updates y rollback;
- Jobs y CronJobs cuando se incluyan como demostracion acotada;
- eventos de scheduling;
- `kubectl apply`, `get`, `describe`, `logs`, `exec`, `rollout status`, `rollout history`, `rollout undo`.

## Especifico de MicroK8s

- cluster local normalmente de un solo nodo;
- labels y taints concretos pueden variar segun instalacion;
- `hostpath-storage` condiciona persistencia local y portabilidad;
- recursos disponibles dependen de WSL2 y del host;
- no representa alta disponibilidad multi-zona ni mantenimiento cloud.

## Especifico de AKS

No aplica en esta unidad. Mencionar solo de forma comparativa que AKS introduce node pools, zonas, upgrade de nodos, drain gestionado, storage classes cloud y restricciones de plataforma propias.

## Especifico de EKS

No aplica en esta unidad. Mencionar solo de forma comparativa que EKS introduce managed node groups, taints/labels de node groups, zonas, upgrades, storage classes CSI y restricciones de plataforma propias.

## Estrategia de desacoplamiento

- usar APIs Kubernetes estandar para scheduling, PDB y rollouts;
- no depender de nombres de nodo concretos como contrato permanente;
- usar labels de laboratorio claramente identificadas si se necesitan;
- preferir constraints no bloqueantes como estado final local;
- aislar pasos de MicroK8s en secciones especificas;
- mantener nombres y labels preparados para Helm futuro;
- registrar en summary cualquier dependencia concreta del entorno local.

---

# Restricciones de generacion

La IA no debe:

- generar contenido de Unidad 06 o posteriores;
- crear charts Helm;
- crear modulos Terraform;
- instalar Tekton;
- instalar Argo CD;
- desplegar Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- introducir KEDA, HPA o escalado automatico;
- crear recursos AKS o EKS;
- sustituir `platform-api`;
- crear namespaces funcionales alternativos;
- eliminar PVC, PV, namespace o datos persistentes como parte automatica del laboratorio;
- automatizar `kubectl drain`, reset de MicroK8s o modificacion destructiva de nodos;
- guardar credenciales reales, kubeconfigs, certificados privados ni secretos corporativos.

La IA si puede:

- extender manifiestos de `labs/04-persistence-state/solution/` en una ruta propia de Unidad 05;
- crear `pdb.yaml`;
- ajustar `deployment.yaml` con estrategia de rolling update, revision history y constraints seguros;
- documentar ejemplos de fallo controlado;
- crear validaciones no destructivas;
- actualizar `tutorial/05-scheduling-resilience-maintenance/summary.md` y `project/project-state.md` cuando se genere la unidad.

---

# Criterios de aceptacion

La unidad se considerara completada cuando:

- [ ] exista `tutorial/05-scheduling-resilience-maintenance/README.md`;
- [ ] exista `tutorial/05-scheduling-resilience-maintenance/student-notes.md`;
- [ ] exista `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md`;
- [ ] exista `tutorial/05-scheduling-resilience-maintenance/summary.md`;
- [ ] exista `labs/05-scheduling-resilience-maintenance/README.md`;
- [ ] existan `starter/`, `solution/` y `validation/validate.sh`;
- [ ] `solution/` reutilice semanticamente la salida validada de Unidad 04;
- [ ] exista un `PodDisruptionBudget` coherente con las replicas;
- [ ] el Deployment conserve probes, resources, PVC y red heredada;
- [ ] la estrategia de rolling update este declarada y validada;
- [ ] los constraints de scheduling finales no bloqueen MicroK8s local;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] las validaciones estaticas posibles se hayan ejecutado;
- [ ] las validaciones funcionales posibles se hayan ejecutado o declarado pendientes;
- [ ] no existan secretos reales;
- [ ] no existan charts Helm ni modulos Terraform;
- [ ] el tutorial incluya referencias oficiales o fuentes primarias relevantes;
- [ ] `project/project-state.md` este actualizado;
- [ ] el resultado prepare la Unidad 06;
- [ ] no existan contradicciones abiertas.

---

# Estado final esperado

## Plataforma

- MicroK8s local sigue siendo la plataforma activa.
- DNS, Ingress y hostpath-storage heredados se conservan si estaban habilitados.
- No se crean clusters, node pools, recursos cloud ni plataformas paralelas.

## Aplicacion

- `platform-api` sigue desplegada en `platform-training`.
- Deployment conserva dos replicas salvo decision documentada.
- PVC `platform-api-data`, Service `ClusterIP` e Ingress local se conservan.
- PDB protege disponibilidad minima durante interrupciones voluntarias.
- Estrategia de rollout y rollback queda documentada y validada.

## Automatizacion

- Manifiestos Kubernetes disponibles en `labs/05-scheduling-resilience-maintenance/solution/`.
- Script de validacion disponible en `labs/05-scheduling-resilience-maintenance/validation/validate.sh`.
- No existen charts Helm ni modulos Terraform del curso.

## Observabilidad

- Diagnostico mediante estado Kubernetes, eventos, logs, EndpointSlice, rollout history y PDB.
- No existe stack de observabilidad avanzada.

## Seguridad

- Secret heredado sigue siendo ficticio.
- No se versionan credenciales reales.
- Operaciones de nodo potencialmente destructivas quedan fuera de validacion automatica.

## Artefactos principales

```text
tutorial/05-scheduling-resilience-maintenance/README.md
tutorial/05-scheduling-resilience-maintenance/student-notes.md
tutorial/05-scheduling-resilience-maintenance/instructor-notes.md
tutorial/05-scheduling-resilience-maintenance/summary.md
labs/05-scheduling-resilience-maintenance/README.md
labs/05-scheduling-resilience-maintenance/starter/
labs/05-scheduling-resilience-maintenance/solution/
labs/05-scheduling-resilience-maintenance/validation/validate.sh
project/project-state.md
```

---

# Informacion obligatoria para el summary

El `summary.md` debera destacar:

- capacidad incorporada;
- artefactos creados;
- artefactos modificados;
- manifiestos reutilizados de Unidad 04;
- PDB creado y valores elegidos;
- estrategia de rolling update declarada;
- constraints de scheduling usados y motivo;
- comandos de validacion principales;
- resultados reales de validacion, si se ejecutan;
- operaciones no ejecutadas por seguridad;
- decisiones especificas;
- referencias principales utilizadas;
- limitaciones de MicroK8s local y PVC hostpath;
- estado que reutilizara Unidad 06.

---

# Metadatos de mantenimiento

| Campo | Valor |
|---|---|
| Fecha de creacion | 2026-07-19 |
| Ultima revision | 2026-07-19 |
| Estado | En revision |
| Siguiente accion esperada | Revision y aprobacion del usuario antes de generar la Unidad 05 |

