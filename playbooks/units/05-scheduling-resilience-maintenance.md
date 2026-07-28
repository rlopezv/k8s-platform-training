# Playbook de la Unidad 05 - Scheduling, resiliencia y mantenimiento

## Identificación

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
Aprobado; regenerado contra el contrato documental en fase 4
```

### Propietario lógico

```text
Fundamentos Kubernetes
```

---

# Propósito de la unidad

La Unidad 05 evoluciona `platform-api` desde una aplicación con configuración, entrada HTTP y persistencia local hacia una aplicación que declara decisiones básicas de colocación, actualización gradual, recuperación de Pods y mantenimiento responsable.

La unidad aparece después de persistencia porque, una vez que el alumno ha visto Pods reemplazables y un PVC local, debe entender que la disponibilidad no nace solo de tener réplicas. Depende de dónde puede arrancar cada Pod, qué capacidad declara, qué ocurre durante un rollout, cuándo entra o sale de los endpoints y qué límites tiene un laboratorio MicroK8s de un solo nodo.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que ya han practicado `Deployment`, `Service`, `Ingress`, `ConfigMap`, `Secret`, probes, `resources` y PVC, pero que todavía no dominan scheduling, resiliencia ni mantenimiento operativo.

Se explican desde cero:

- cómo `kube-scheduler` pasa de un Pod `Pending` a un Pod asignado a nodo;
- filtrado y puntuación como modelo mental del scheduler, sin convertir la unidad en administración interna del control plane;
- `nodeSelector`, node affinity, pod affinity y pod anti-affinity;
- reglas estrictas y preferidas, especialmente `requiredDuringSchedulingIgnoredDuringExecution` y `preferredDuringSchedulingIgnoredDuringExecution`;
- taints y tolerations como rechazo desde el nodo y permiso desde el Pod;
- relación entre `requests`, capacidad disponible y Pods `Pending`;
- diferencia entre fallo involuntario, interrupción voluntaria, rollout, rollback y eviction;
- `PodDisruptionBudget` como límite para interrupciones voluntarias, no como protección ante caídas imprevistas;
- límites de resiliencia en un clúster local de un solo nodo con `hostpath-storage`.

Se retoman de unidades anteriores:

- MicroK8s local y `kubectl`;
- namespace funcional `platform-training`;
- aplicación evolutiva `platform-api`;
- manifiestos finales de `labs/05-scheduling-resilience-maintenance/solution/`;
- ConfigMap, Secret ficticio, probes, requests, limits, Service `ClusterIP`, Ingress HTTP local y PVC `platform-api-data`;
- diagnóstico con `kubectl get`, `describe`, eventos, EndpointSlice, logs y `rollout`.

Se mencionan solo para continuidad:

- Helm en Unidad 06;
- Terraform en Unidad 07;
- progressive delivery en Unidad 10;
- observabilidad, SLI/SLO y señales de rollout en Unidades 12 y 15;
- gobierno de recursos y aislamiento por equipo en Unidad 16;
- autoscaling, KEDA, capacidad y coste en Unidad 18;
- desacoplamiento de MicroK8s y cloud en Unidad 19;
- mantenimiento de clúster, upgrades, node pools y ciclo de vida en Unidades 22 y 23.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que dos réplicas garantizan alta disponibilidad en un clúster de un solo nodo;
- usar reglas estrictas de affinity cuando una preferencia sería suficiente;
- interpretar tolerations como una forma de atraer Pods;
- presentar un PDB como protección ante fallos involuntarios;
- diagnosticar logs de aplicación cuando el Pod ni siquiera fue programado;
- ignorar que un PVC local condiciona dónde puede arrancar un Pod;
- tratar `kubectl drain`, `cordon` o `uncordon` como operaciones inocuas de laboratorio.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- explicar cómo el scheduler filtra y puntúa nodos candidatos para un Pod;
- observar labels de nodo, `nodeName`, eventos de scheduling y Pods `Pending`;
- comparar `nodeSelector`, node affinity, pod anti-affinity, taints y tolerations;
- justificar por qué el laboratorio usa anti-affinity preferida y no obligatoria;
- interpretar cómo `requests` y PVC afectan a la colocación;
- describir qué controla `RollingUpdate` y qué no garantiza;
- ejecutar y razonar sobre rollout y rollback nativos de un Deployment;
- explicar qué protege un `PodDisruptionBudget` y qué no protege;
- distinguir resiliencia local de laboratorio frente a alta disponibilidad real multi-nodo;
- dejar preparada la base declarativa que la Unidad 06 empaqueta con Helm.

---

# Alcance

## Incluido

- saneamiento documental de la Unidad 05 contra el contrato cerrado;
- reutilización de `platform-api`, `platform-training` y `labs/05-scheduling-resilience-maintenance/solution/`;
- laboratorio existente en `labs/05-scheduling-resilience-maintenance/`, sin cambios durante fase 4;
- explicación de scheduler, filtrado, puntuación, eventos y nodo elegido;
- explicación de `nodeSelector`, node affinity, pod affinity y pod anti-affinity;
- cobertura de expresiones estrictas y preferidas de affinity como criterio, conservando preferencias no bloqueantes en el laboratorio;
- explicación de taints y tolerations como criterio profesional de segregación de workloads;
- cobertura de PDB como protección limitada ante interrupciones voluntarias;
- explicación de rollout, rollback, EndpointSlice, readiness y recuperación controlada de Pod;
- documentación de límites de MicroK8s local, nodo único, `hostpath-storage` y PVC local;
- actualización de `README.md`, `student-notes.md`, `student-reference.md`, `summary.md` y `project/project-state.md` al cierre documental.

## Excluido

- generación de Unidad 08;
- modificación de laboratorios de Unidades 01-07;
- modificación de manifiestos Kubernetes;
- modificación de scripts de `platform/environment`;
- ejecución de validaciones funcionales nuevas durante el saneamiento;
- creación de workloads nuevos;
- creación de charts Helm o módulos Terraform;
- instalación o configuración de Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- práctica real de `kubectl drain`, `cordon` o `uncordon`;
- modificación de labels o taints de nodos como estado final;
- autoscaling con HPA o KEDA;
- progressive delivery con canary, blue/green, Argo Rollouts o Flagger;
- chaos engineering;
- alta disponibilidad multi-nodo real;
- mantenimiento productivo de node pools;
- sustitución de `platform-api` o creación de namespaces funcionales alternativos;
- introducción de Minikube, kind o Docker Desktop Kubernetes como plataforma paralela.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Empaquetado con Helm | Unidad 06 | La Unidad 05 deja manifiestos estabilizados para empaquetar |
| Automatización local con Terraform | Unidad 07 | Requiere chart Helm funcional |
| CI/CD con Tekton | Unidad 08 | Requiere cierre del saneamiento documental antes de avanzar |
| GitOps y secretos reales | Unidad 09 | Requiere definir propiedad declarativa y gestión segura desde Git |
| Progressive delivery | Unidad 10 | Requiere automatización y señales operativas suficientes |
| Métricas, alertas, SLI/SLO y observabilidad integrada | Unidades 12 y 15 | Necesarias para evaluar rollouts y mantenimiento con criterio |
| Gobierno de recursos, namespaces y ownership | Unidad 16 | Retoma capacidad, cuotas, límites y segregación operativa |
| Autoscaling, KEDA, topology spread constraints, capacidad y coste | Unidad 18 | Requiere métricas y modelo de escalado |
| Desacoplamiento de MicroK8s y portabilidad cloud | Unidad 19 | Separa supuestos locales de Kubernetes estándar y AKS/EKS |
| Mantenimiento cloud, node pools, upgrades y ciclo de vida del clúster | Unidades 22 y 23 | Encaja en operación de plataformas gestionadas y fiabilidad avanzada |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar y diagnosticar el laboratorio: scheduler observado, labels de nodo, Pods `Pending`, rollout, rollback, EndpointSlice, PDB del laboratorio, eliminación controlada de un Pod y recuperación mediante Deployment.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: filtrado y puntuación del scheduler, affinity estricta frente a preferida, taints/tolerations como segregación, límites reales del PDB, alta disponibilidad multi-nodo, mantenimiento con `drain`/`cordon`/`uncordon`, topology spread constraints, cloud, node pools y límites de MicroK8s local.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta. El diagnóstico de fallos del laboratorio pertenece a `student-notes.md`; los errores de concepto pertenecen a `student-reference.md`.

## Laguna asignada

```text
Ninguna
```

La Unidad 05 no cierra una laguna nueva del registro. Sí debe respetar dos anclajes existentes:

- `GAP-007`: el ciclo de vida real del clúster, upgrades y mantenimiento fuerte quedan anclados a Unidades 22 y 23;
- `GAP-011`: topology spread constraints quedan anclados a Unidad 18, y chaos engineering a Unidad 15.

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 05 |
|---|---|
| Panorama | Situar scheduling, resiliencia, mantenimiento, alta disponibilidad, cloud y operación de nodos |
| Profundidad | Explicar la cadena Pod `Pending` -> nodo elegido -> kubelet -> probes -> EndpointSlice -> Service/Ingress |
| Criterio | Decidir entre constraints estrictos y preferidos, affinity frente a taints, PDB, rollout y mantenimiento |
| Práctica | Nombrar distancias con producción: nodo único, `hostpath-storage`, PDB limitado, sin drain real, sin HA multi-zona ni node pools |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| MicroK8s de un solo nodo | Confundir recuperación de Pod con alta disponibilidad | Múltiples nodos, zonas, capacidad suficiente, PDB, probes, observabilidad y procedimientos |
| Anti-affinity preferida | Creer que la intención garantiza reparto | Reglas estrictas solo cuando haya capacidad y dominios suficientes; topology spread constraints en Unidad 18 |
| PDB `minAvailable: 1` con dos réplicas | Presentarlo como protección ante caídas imprevistas | PDB solo limita interrupciones voluntarias; fallos involuntarios requieren arquitectura resiliente y recuperación |
| No se practica `drain`/`cordon`/`uncordon` | Convertir mantenimiento de nodo en comando mecánico | Runbooks, ventana de cambio, revisión de PDB, capacidad, PVC, observabilidad y rollback |
| PVC con `microk8s-hostpath` | Ignorar que el dato ata el Pod al nodo local | Storage cloud o CSI con topología entendida, backups y diseño de estado |
| Sin autoscaling ni observabilidad avanzada | Decidir rollouts o mantenimiento sin señales suficientes | HPA/KEDA y SLI/SLO en unidades posteriores |

## Uso de `project/coverage-map.md`

La sección de Unidad 05 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

| Punto de `project/coverage-map.md` | Clasificación | Tratamiento |
|---|---|---|
| Mecánica interna del planificador, filtrado, puntuación y `nodeSelector` | Criterio conceptual y práctica existente | Cubierto en referencia y notas; el laboratorio ya declara `nodeSelector` Linux |
| Reglas complejas de affinity y anti-affinity con expresiones estrictas y blandas | Criterio conceptual; práctica parcial existente | El laboratorio usa preferencias; la referencia explica `required...` y `preferred...` sin endurecer manifiestos |
| Taints y tolerations para segregación de workloads | Criterio conceptual | Cubierto en referencia; no se aplican taints a nodos ni se crean workloads nuevos |
| PDB para disponibilidad durante mantenimiento | Práctica existente con corrección conceptual | `pdb.yaml` existe; la referencia corrige que no mitiga caídas imprevistas, solo interrupciones voluntarias |
| `drain`, `cordon` y `uncordon` | Diagnóstico operativo y exclusión anclada | Explicados como mantenimiento profesional; no se ejecutan en fase 4 ni en la validación de laboratorio |

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
14. `playbooks/units/05-scheduling-resilience-maintenance.md`;
15. sección de Unidad 05 en `project/coverage-map.md`;
16. `tutorial/04-persistence-state/summary.md`;
17. `tutorial/05-scheduling-resilience-maintenance/README.md`;
18. `tutorial/05-scheduling-resilience-maintenance/student-notes.md`;
19. `tutorial/05-scheduling-resilience-maintenance/student-reference.md`;
20. `tutorial/05-scheduling-resilience-maintenance/summary.md`;
21. `labs/05-scheduling-resilience-maintenance/README.md`;
22. `labs/05-scheduling-resilience-maintenance/solution/`.

## Excepciones

Ninguna. La Unidad 04 está cerrada, existe `tutorial/04-persistence-state/summary.md` y la Unidad 05 ya dispone de laboratorio y documentos de alumno.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- plan de saneamiento vigente en `project/documentation-cleanup-plan.md`;
- `tutorial/04-persistence-state/summary.md`;
- artefactos actuales de la Unidad 05;
- registro de lagunas `project/content-gap-register.md`;
- `project/coverage-map.md` como checklist, no como estructura.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Entorno local | Heredado de Unidad 00 | Evidencia registrada en `tutorial/00-environment/summary.md` y `project/project-state.md` |
| `platform-api` persistente | Generada en Unidad 04 | Evidencia registrada en `tutorial/04-persistence-state/summary.md` |
| Namespace `platform-training` | Conservado | `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml` |
| Deployment `platform-api` | Disponible como manifiesto de solución | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` |
| PDB `platform-api` | Disponible como manifiesto de solución | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` |
| Validación de Unidad 05 | Existente, no ejecutada en saneamiento | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` |

Durante el saneamiento documental de fase 4 no se ejecutan validaciones funcionales nuevas.

## Dependencias pedagógicas

- el alumno entiende el modelo declarativo básico de Unidades 01 a 04;
- el alumno puede leer YAML de Kubernetes con guía;
- el alumno distingue configuración, salud, Service, Ingress y PVC;
- la referencia debe corregir extrapolaciones inseguras del laboratorio local.

---

# Entregables

## Documentación del alumno

| Entregable | Ruta | Responsabilidad |
|---|---|---|
| Tutorial principal | `tutorial/05-scheduling-resilience-maintenance/README.md` | Puerta de entrada conceptual de la unidad |
| Student notes | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` | Acompañamiento del laboratorio, observación y diagnóstico |
| Student reference | `tutorial/05-scheduling-resilience-maintenance/student-reference.md` | Referencia profesional autosuficiente según contrato |
| Summary | `tutorial/05-scheduling-resilience-maintenance/summary.md` | Contrato de continuidad con Unidad 06 y saneamiento |

## Artefactos de laboratorio existentes

| Entregable | Ruta | Responsabilidad |
|---|---|---|
| Laboratorio | `labs/05-scheduling-resilience-maintenance/README.md` | Instrucciones operativas |
| Starter | `labs/05-scheduling-resilience-maintenance/starter/` | Punto de partida guiado |
| Solution | `labs/05-scheduling-resilience-maintenance/solution/` | Estado final reutilizado por Unidad 06 |
| Validación | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Comprobación no destructiva existente |

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

`project/content-gap-register.md` solo debe cambiar si se ajusta una laguna existente. Para Unidad 05 no se prevé cambio obligatorio: `GAP-007` y `GAP-011` ya tienen destino asignado y se confirman sin reabrirlas.

---

# Criterios de aceptación del saneamiento

La Unidad 05 queda conforme cuando:

- el playbook declara `student-reference.md` como entregable y respeta la plantilla global;
- el playbook declara la frontera entre `student-notes.md` y `student-reference.md`;
- el playbook declara que no cierra una laguna nueva y que respeta los anclajes de `GAP-007` y `GAP-011`;
- la referencia conserva la estructura canónica de `playbooks/student-reference-template.md`;
- la referencia cubre scheduler, filtrado, puntuación, `nodeSelector`, affinity, anti-affinity, taints, tolerations, PDB, rollouts, rollback, mantenimiento, HA real, cloud y límites de MicroK8s local;
- la referencia no incluye `summary.md` como material didáctico en la tabla de artefactos;
- `student-notes.md` queda centrado en la práctica y diagnóstico del laboratorio;
- el `README.md` remite claramente a notas y referencia sin desarrollar errores conceptuales;
- `summary.md` registra el saneamiento documental y distingue validaciones históricas de validaciones no ejecutadas en esta fase;
- `project/project-state.md` registra el incremento y el siguiente paso permitido;
- no se modifica `labs/05-scheduling-resilience-maintenance/` ni laboratorios de otras unidades;
- no se modifican manifiestos Kubernetes ni scripts;
- no se crean workloads nuevos;
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
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/
kubectl -n platform-training rollout status deployment/platform-api
kubectl drain <node>
kubectl cordon <node>
kubectl uncordon <node>
microk8s status --wait-ready
kubectl get nodes
```

---

# Cierre esperado

Al cerrar el saneamiento de la Unidad 05:

- `playbooks/units/05-scheduling-resilience-maintenance.md` queda regenerado contra contrato documental;
- `tutorial/05-scheduling-resilience-maintenance/README.md` queda alineado con el playbook;
- `tutorial/05-scheduling-resilience-maintenance/student-notes.md` queda alineado con la frontera de notas;
- `tutorial/05-scheduling-resilience-maintenance/student-reference.md` queda ajustado contra la plantilla global;
- `tutorial/05-scheduling-resilience-maintenance/summary.md` registra el saneamiento y sus límites;
- `project/project-state.md` registra el incremento;
- `project/content-gap-register.md` queda sin cambios salvo que se detecte una laguna que deba ajustarse;
- Unidad 08 sigue congelada;
- el siguiente paso permitido es la auditoría de autosuficiencia `TD-022` y, después, el cierre funcional de Unidad 04 `TD-023` según `project/documentation-cleanup-plan.md`.

---

# Metadatos de mantenimiento

| Campo | Valor |
|---|---|
| Fecha de creación | 2026-07-19 |
| Última revisión | 2026-07-27 |
| Estado | Regenerado contra contrato documental |
| Siguiente acción esperada | Revisar y aprobar el saneamiento documental de Unidad 05; continuar con `TD-022` |
