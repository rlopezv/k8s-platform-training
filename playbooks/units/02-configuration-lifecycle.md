# Playbook de la Unidad 02 - Configuración, secretos y ciclo de vida

## Identificación

### Unidad

```text
02 - Configuración, secretos y ciclo de vida
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
Aprobado; regenerado contra el contrato documental en fase 4
```

### Propietario lógico

```text
Fundamentos Kubernetes
```

---

# Propósito de la unidad

La Unidad 02 evoluciona `platform-api` desde un `Deployment` y un `Service` básicos hacia un workload que expresa contratos operativos mínimos: configuración externa, secreto ficticio de laboratorio, señales de salud, consumo declarado de recursos y cierre controlado inicial.

La unidad aparece aquí porque, después de entender `Namespace`, `Deployment`, `ReplicaSet`, `Pod`, `Service`, labels y selectors en la Unidad 01, el alumno necesita aprender qué parte del comportamiento de una aplicación se declara dentro del template del Pod y qué efectos tiene esa declaración sobre rollouts, readiness, endpoints, scheduling, contención y recuperación.

## Supuesto pedagógico

La unidad se escribe para alumnos que ya pueden aplicar y observar manifiestos Kubernetes básicos, pero que todavía no dominan configuración externa, secretos, probes ni gestión de recursos.

Se explican desde cero:

- qué diferencia hay entre código, configuración no sensible, secreto, estado y manifiesto;
- cómo un `ConfigMap` puede consumirse mediante variables de entorno y mediante volumen;
- qué ofrece un `Secret` nativo y qué no ofrece por sí solo;
- por qué los valores de Secret del laboratorio son ficticios y no deben imprimirse ni decodificarse;
- cómo `startupProbe`, `readinessProbe` y `livenessProbe` afectan al ciclo de vida del contenedor y a los endpoints de Service;
- cómo `requests` participan en scheduling y cómo `limits` participan en contención;
- qué significan `CPU throttling`, `OOMKilled` y clases QoS;
- qué aporta `terminationGracePeriodSeconds` y qué queda fuera cuando no hay `preStop` ni lógica real de apagado en la aplicación;
- por qué un cambio en `.spec.template` genera rollout y un cambio aislado en un `ConfigMap` puede no hacerlo.

Se retoman de unidades anteriores:

- MicroK8s local, `kubectl` y namespace funcional `platform-training`;
- aplicación evolutiva `platform-api`;
- manifiestos base de `labs/01-kubernetes/solution/`;
- Service `ClusterIP`, selector por labels y observación de endpoints;
- contenedores, imagen pública versionada y `imagePullPolicy`;
- diagnóstico con `kubectl get`, `describe`, eventos y logs.

Se mencionan solo para continuidad:

- Ingress, Gateway API, DNS y TLS;
- persistencia, `PVC`, `StorageClass`, `StatefulSet` y `Headless Service`;
- `ResourceQuota`, `LimitRange`, autoscaling y coste cloud;
- Helm, Terraform, Tekton, Argo CD, observabilidad, seguridad avanzada, AKS y EKS.

Errores de razonamiento que debe prevenir `student-reference.md`:

- pensar que un `Secret` es cifrado, rotación o gestión corporativa de secretos;
- creer que cambiar un `ConfigMap` siempre reinicia Pods;
- usar `livenessProbe` para ocultar fallos de diseño de la aplicación;
- confundir readiness con disponibilidad real de negocio;
- creer que `requests` y `limits` son métricas observadas;
- interpretar CPU y memoria de forma simétrica;
- confundir QoS con prioridad absoluta;
- suponer que un `terminationGracePeriodSeconds` basta para un cierre graceful completo;
- extrapolar valores de MicroK8s local a producción.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- extender `platform-api` sin sustituir la aplicación, el namespace ni el Service base;
- crear y consumir un `ConfigMap` para configuración no sensible;
- crear y consumir un `Secret` con valores ficticios sin exponer su contenido;
- montar contenido desde un `ConfigMap` como archivo;
- explicar cuándo una modificación produce un nuevo `ReplicaSet`;
- diferenciar `startupProbe`, `readinessProbe` y `livenessProbe` por intención y efecto;
- observar la relación entre readiness y EndpointSlice;
- declarar `resources.requests` y `resources.limits` de CPU y memoria;
- explicar CPU throttling, `OOMKilled`, QoS `Guaranteed`, `Burstable` y `BestEffort`;
- interpretar `terminationGracePeriodSeconds` como una parte limitada del cierre controlado;
- diagnosticar fallos de ConfigMap, Secret, probes, endpoints y recursos sin revelar secretos;
- explicar qué deja preparado para la Unidad 03.

---

# Alcance

## Incluido

- evolución de `platform-api` en `labs/02-configuration-lifecycle/`;
- reutilización semántica de `labs/01-kubernetes/solution/`;
- `ConfigMap` para configuración no sensible y contenido HTML de laboratorio;
- `Secret` nativo de Kubernetes con valores ficticios;
- consumo de configuración mediante `env.valueFrom.configMapKeyRef`;
- consumo de secreto mediante `env.valueFrom.secretKeyRef`;
- montaje de `ConfigMap` como volumen de solo lectura;
- `startupProbe`, `readinessProbe` y `livenessProbe` HTTP sobre `/`;
- `resources.requests` y `resources.limits` de CPU y memoria;
- `terminationGracePeriodSeconds` como configuración básica de terminación;
- observación de rollout, `ReplicaSet`, Pods, Service y EndpointSlice;
- diagnóstico de fallos típicos sin imprimir valores sensibles;
- referencia profesional sobre límites de `Secret`, QoS, contención, coste y cierre graceful;
- actualización de `summary.md` y `project/project-state.md` al cierre documental.

## Excluido

- creación de aplicaciones o workloads nuevos;
- sustitución de `platform-api`;
- modificación de laboratorios, manifiestos Kubernetes, scripts de validación o workloads durante el saneamiento documental;
- ejecución de validaciones funcionales nuevas durante la fase 4;
- credenciales reales, tokens reales, kubeconfigs, certificados privados o secretos corporativos;
- cifrado en reposo, rotación, External Secrets, Vault, cloud secret managers o Sealed Secrets;
- `ResourceQuota`, `LimitRange`, `PriorityClass`, autoscaling o políticas de admisión;
- `preStop` práctico, lógica real de SIGTERM en aplicación o pruebas de drenaje;
- Ingress, Gateway API, DNS externo, TLS y certificados;
- persistencia, `StatefulSet`, Jobs, CronJobs y nuevos tipos de workload;
- charts Helm, módulos Terraform, Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS y EKS.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Entrada HTTP estable con Ingress, DNS local y TLS como referencia | Unidad 03 | Requiere Service y endpoints listos |
| Persistencia, `PVC`, `StorageClass`, `StatefulSet` y `Headless Service` | Unidad 04 | Requiere workload configurable y expuesto |
| Rollouts avanzados, PDB, mantenimiento y prácticas más completas de terminación | Unidad 05 | Requiere probes y recursos ya incorporados |
| Empaquetado con Helm | Unidad 06 | Requiere manifiestos acumulados estables |
| Automatización local con Terraform | Unidad 07 | Requiere chart Helm funcional |
| Gestión real de secretos, identidad, RBAC y políticas | Unidad 09 y seguridad posterior | Requiere GitOps, gobierno e integración de plataforma |
| Autoscaling y coste cloud | Unidades de escalado y cloud | Requiere métricas, políticas y plataforma gestionada |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar y diagnosticar el laboratorio: qué se aplica, cómo se observa, qué errores típicos aparecen con ConfigMap, Secret, readiness, liveness y recursos, y cómo recuperar el estado esperado sin exponer secretos.

`student-reference.md` explica lo que queda por encima del procedimiento: configuración como contrato, límites de seguridad de `Secret`, diferencias entre variables y volúmenes, semántica de probes, requests, limits, QoS, coste, terminación controlada y criterios para no extrapolar el laboratorio a producción.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta.

## Laguna asignada

```text
Ninguna.
```

La unidad no recibe una laguna nueva durante esta fase. Debe respetar, sin reabrir ni duplicar, estas decisiones ya registradas:

| ID | Tratamiento en esta unidad | Estado esperado |
|---|---|---|
| `GAP-002` | La referencia explica límites de `Secret`, valores ficticios, ausencia de gestión real de secretos y continuidad hacia Unidad 09 | Cerrada según `project/content-gap-register.md` |
| `GAP-006` | Requests, limits, QoS y coste se conectan como criterio, no como práctica de cuotas ni autoscaling | Abordada en el registro; continuidad posterior |
| `GAP-008` | La diferencia entre contención local y coste cloud se menciona como criterio profesional | Abordada en el registro; continuidad posterior |

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 02 |
|---|---|
| Panorama | Situar configuración, secretos, probes, recursos, QoS y terminación dentro del ciclo de vida de un Pod |
| Profundidad | Explicar consumo por env vars y volúmenes, Base64 en Secrets, rollout por template, efectos de probes, CPU throttling, `OOMKilled` y QoS |
| Criterio | Decidir qué va a ConfigMap, qué requiere Secret o gestor externo, cuándo usar cada probe y cómo elegir recursos iniciales |
| Práctica | Nombrar distancias con producción: Secret ficticio, MicroK8s local, recursos modestos, probes simples, sin quotas, sin autoscaling y sin `preStop` práctico |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| `Secret` nativo con valores ficticios en Git | Normalizar secretos versionados y sin rotación | Secret managers externos, cifrado en reposo, rotación, identidad y políticas |
| ConfigMap usado para HTML y variables simples | Confundir configuración con estado o contenido gestionado profesionalmente | Separar código, configuración, artefactos, datos persistentes y secretos |
| Probes HTTP sobre `/` en Nginx | Señales demasiado superficiales para disponibilidad real | Endpoints de salud diseñados por la aplicación y dependencias explícitas |
| `requests` y `limits` modestos en MicroK8s local | Extrapolar valores a producción o dimensionar sin métricas | Medición, SLOs, perfiles de carga, quotas y gobierno de capacidad |
| Sin `ResourceQuota`, `LimitRange` ni autoscaling | No enseña control de consumo por namespace ni escalado automático | Políticas de plataforma y autoscaling cuando existan métricas y objetivos |
| Solo `terminationGracePeriodSeconds`, sin `preStop` ni SIGTERM real de aplicación | Creer que Kubernetes puede garantizar cierre graceful sin cooperación del proceso | Aplicaciones que atienden SIGTERM, hooks, drenaje, PDB y pruebas de terminación |

## Uso de `project/coverage-map.md`

La sección de Unidad 02 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

| Punto de `project/coverage-map.md` | Clasificación | Tratamiento |
|---|---|---|
| Inyección de entorno base: ConfigMaps as env and files | Práctica existente del laboratorio | Cubierto por `configMapKeyRef` y volumen `platform-api-content` en la solución |
| Datos sensibles locales vs producción | Práctica y criterio | Secret ficticio practicado; límites de Base64, cifrado en reposo y gestores externos explicados en referencia |
| Ciclo de vida y resiliencia de procesos | Práctica existente y criterio | `startupProbe`, `readinessProbe` y `livenessProbe` practicadas; su semántica se desarrolla en referencia |
| Planificación de consumo y gobernanza de recursos | Práctica y criterio | `requests`/`limits` practicados; throttling, `OOMKilled`, cuotas y coste quedan como criterio |
| QoS classes `Guaranteed`, `Burstable`, `BestEffort` | Criterio profesional | Explicado en referencia; el laboratorio queda en `Burstable` y no fuerza comparativas artificiales |
| Graceful Shutdown: SIGTERM, `preStop`, `terminationGracePeriodSeconds` | Práctica parcial y exclusión | `terminationGracePeriodSeconds` está en la solución; SIGTERM y `preStop` se explican como límite y continuidad, sin modificar manifiestos |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `project/documentation-cleanup-plan.md`;
2. `README.md`;
3. `project/architecture.md`;
4. `project/project-state.md`;
5. `project/roadmap.md`;
6. `project/how-to.md`;
7. `project/project-planning.md`;
8. `project/content-gap-register.md`;
9. `playbooks/master.md`;
10. `playbooks/unit-template.md`;
11. `playbooks/student-reference-template.md`;
12. `playbooks/summary-template.md`;
13. `playbooks/project-state-template.md`;
14. `playbooks/units/02-configuration-lifecycle.md`;
15. `tutorial/01-kubernetes/summary.md`;
16. sección de Unidad 02 en `project/coverage-map.md`;
17. `tutorial/02-configuration-lifecycle/README.md`;
18. `tutorial/02-configuration-lifecycle/student-notes.md`;
19. `tutorial/02-configuration-lifecycle/student-reference.md`;
20. `tutorial/02-configuration-lifecycle/summary.md`;
21. `labs/02-configuration-lifecycle/README.md`;
22. `labs/02-configuration-lifecycle/solution/`.

## Excepciones

Ninguna. La Unidad 01 está cerrada y existe `tutorial/01-kubernetes/summary.md`.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- plan de saneamiento vigente en `project/documentation-cleanup-plan.md`;
- `tutorial/01-kubernetes/summary.md`;
- artefactos actuales de la Unidad 02;
- registro de lagunas `project/content-gap-register.md`;
- `project/coverage-map.md` como checklist, no como estructura.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Entorno local | Heredado de Unidad 00 | Evidencia registrada en `tutorial/00-environment/summary.md` |
| `platform-api` base | Generado en Unidad 01 | Evidencia registrada en `tutorial/01-kubernetes/summary.md` |
| Namespace `platform-training` | Conservado | `labs/02-configuration-lifecycle/solution/namespace.yaml` |
| ConfigMap y Secret | Disponibles como manifiestos de solución | `labs/02-configuration-lifecycle/solution/configmap.yaml`, `secret.yaml` |
| Deployment evolucionado | Disponible como manifiesto de solución | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| Validación de Unidad 02 | Existente, no ejecutada en saneamiento | `labs/02-configuration-lifecycle/validation/validate.sh` |

Durante el saneamiento documental de fase 4 no se ejecutan validaciones funcionales nuevas.

## Dependencias pedagógicas

- el alumno entiende el modelo declarativo básico de la Unidad 01;
- el alumno puede leer YAML de Kubernetes con guía;
- el instructor puede demostrar fallos de configuración sin exponer secretos;
- la referencia debe corregir extrapolaciones inseguras del laboratorio local.

---

# Entregables

## Documentación del alumno

| Entregable | Ruta | Responsabilidad |
|---|---|---|
| Tutorial principal | `tutorial/02-configuration-lifecycle/README.md` | Guía conceptual y práctica de la unidad |
| Student notes | `tutorial/02-configuration-lifecycle/student-notes.md` | Acompañamiento del laboratorio, observación y diagnóstico |
| Student reference | `tutorial/02-configuration-lifecycle/student-reference.md` | Referencia profesional autosuficiente según contrato |
| Summary | `tutorial/02-configuration-lifecycle/summary.md` | Contrato de continuidad con Unidad 03 |

## Artefactos de laboratorio existentes

| Entregable | Ruta | Responsabilidad |
|---|---|---|
| Laboratorio | `labs/02-configuration-lifecycle/README.md` | Instrucciones operativas |
| Starter | `labs/02-configuration-lifecycle/starter/` | Punto de partida guiado |
| Solution | `labs/02-configuration-lifecycle/solution/` | Estado final reutilizable por Unidad 03 |
| Validación | `labs/02-configuration-lifecycle/validation/validate.sh` | Comprobación no destructiva existente |

Durante esta fase no deben modificarse estos artefactos de laboratorio.

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

siguiendo:

```text
playbooks/project-state-template.md
```

`project/content-gap-register.md` solo debe cambiar si se ajusta una laguna existente. Para Unidad 02 no se prevé cambio: `GAP-002` ya está cerrada y `GAP-006`/`GAP-008` permanecen como continuidad registrada.

---

# Criterios de aceptación del saneamiento

La Unidad 02 queda conforme cuando:

- el playbook declara `student-reference.md` como entregable y respeta la plantilla global;
- el playbook declara la frontera entre `student-notes.md` y `student-reference.md`;
- la referencia conserva la estructura canónica de `playbooks/student-reference-template.md`;
- la referencia cubre ConfigMap, Secret, env vars, volúmenes, probes, requests, limits, QoS, coste y terminación controlada;
- `GAP-002` queda respetada como decisión cerrada, sin reabrirla;
- `GAP-006` y `GAP-008` quedan mencionadas como continuidad de recursos/coste, sin cerrarlas artificialmente;
- `student-notes.md` queda centrado en la práctica y diagnóstico de la unidad;
- el `README.md` remite claramente a notas y referencia sin duplicar toda la referencia;
- `summary.md` registra el saneamiento documental y distingue validaciones históricas de validaciones no ejecutadas en esta fase;
- `project/project-state.md` registra el incremento y el siguiente paso permitido;
- no se modifican `labs/02-configuration-lifecycle/`, laboratorios de otras unidades, scripts ni manifiestos Kubernetes;
- no se ejecutan validaciones funcionales nuevas.

---

# Validaciones permitidas durante fase 4

Permitidas:

```bash
git diff --check
git status --short
rg -n "..." <rutas documentales>
```

No permitidas en este incremento salvo instrucción posterior explícita:

```bash
bash labs/02-configuration-lifecycle/validation/validate.sh
kubectl apply -f labs/02-configuration-lifecycle/solution/
kubectl -n platform-training rollout status deployment/platform-api
kubectl get nodes
```

---

# Cierre esperado

Al cerrar el saneamiento de la Unidad 02:

- `playbooks/units/02-configuration-lifecycle.md` queda regenerado contra contrato documental;
- `tutorial/02-configuration-lifecycle/README.md` queda alineado con el playbook;
- `tutorial/02-configuration-lifecycle/student-notes.md` queda alineado con la frontera de notas;
- `tutorial/02-configuration-lifecycle/student-reference.md` queda ajustado contra la plantilla global;
- `tutorial/02-configuration-lifecycle/summary.md` registra el saneamiento y sus límites;
- `project/project-state.md` registra el incremento;
- `project/content-gap-register.md` queda sin cambios salvo que se detecte una laguna que deba ajustarse;
- Unidad 08 sigue congelada;
- la siguiente unidad de saneamiento permitida es la Unidad 03.
