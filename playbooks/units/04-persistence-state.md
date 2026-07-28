# Playbook de la Unidad 04 - Persistencia y estado

> Nota de estado: `TD-023` fue implementado y validado el 2026-07-27 como incremento funcional posterior al saneamiento documental. La sección de diseño se conserva como decisión aplicada.

## Identificación

### Unidad

```text
04 - Persistencia y estado
```

### Identificador

```text
04-persistence-state
```

### Fase del roadmap

```text
Fase 2 - Fundamentos Kubernetes
```

### Estado del playbook

```text
Aprobado
```

### Propietario lógico

```text
Fundamentos Kubernetes
```

---

# Propósito de la unidad

La Unidad 04 evoluciona `platform-api` desde una aplicación configurable y expuesta por HTTP local hacia una aplicación que conserva datos de laboratorio fuera del ciclo de vida de un Pod.

La unidad aparece después de networking porque el alumno ya puede desplegar, configurar, exponer y diagnosticar la aplicación. Ahora debe separar tres cosas que suelen confundirse: configuración declarada, secretos ficticios de laboratorio y datos escritos durante la ejecución. La unidad introduce `Volume`, `PersistentVolume`, `PersistentVolumeClaim` y `StorageClass` como contrato de almacenamiento, sin convertir todavía la aplicación en un sistema stateful completo.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que ya han practicado `Deployment`, `Service`, `Ingress`, `ConfigMap`, `Secret`, probes y `resources`, pero que todavía no dominan almacenamiento en Kubernetes.

Se explican desde cero:

- diferencia entre filesystem efímero de contenedor, volumen efímero y volumen persistente;
- relación entre `volumeMount`, `volume`, `PersistentVolumeClaim`, `PersistentVolume` y `StorageClass`;
- aprovisionamiento dinámico mediante una StorageClass local;
- significado operativo de `accessModes`, capacidad solicitada, binding y `reclaimPolicy`;
- diferencia entre persistencia, durabilidad, backup y recuperación;
- límites de `microk8s-hostpath` frente a almacenamiento gestionado con CSI;
- por qué `StatefulSet` y headless Service son criterio profesional de workloads con identidad estable, no sustitución automática de un `Deployment`.

Se retoman de unidades anteriores:

- MicroK8s local, `kubectl` y namespace funcional `platform-training`;
- aplicación evolutiva `platform-api`;
- manifiestos finales de `labs/04-persistence-state/solution/`;
- ConfigMap, Secret ficticio, probes, requests, limits, Service `ClusterIP` e Ingress HTTP local;
- diagnóstico con `kubectl get`, `describe`, `exec`, eventos, EndpointSlice, logs y `rollout`.

Se mencionan solo para continuidad:

- scheduling, resiliencia y mantenimiento en Unidad 05;
- Helm en Unidad 06;
- Terraform en Unidad 07;
- Jobs y CronJobs en Unidad 08;
- seguridad, ownership, RBAC y políticas en Unidad 16;
- desacoplamiento de MicroK8s y portabilidad cloud en Unidad 19;
- AKS, EKS, CSI cloud, snapshots, backup, restore, RPO/RTO y ciclo de vida en Unidades 20, 21 y 23.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que un PVC es el dato;
- confundir ConfigMap o Secret con persistencia de aplicación;
- asumir que reiniciar un Pod conserva escrituras fuera de un volumen montado;
- presentar `hostpath-storage` como patrón productivo general;
- interpretar `ReadWriteOnce` como garantía de concurrencia segura de aplicación;
- decir que hay backup porque existe un volumen;
- elegir `StatefulSet` por reflejo cada vez que aparece un PVC;
- ignorar que la política de reclamación puede borrar o retener el soporte del dato.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- explicar qué datos se pierden y qué datos sobreviven cuando Kubernetes recrea un Pod;
- distinguir filesystem de contenedor, `emptyDir`, volúmenes proyectados y volumen persistente;
- leer un PVC y justificar `storageClassName`, `accessModes` y capacidad solicitada;
- observar el vínculo entre PVC, PV y StorageClass;
- montar un PVC en `platform-api` sin cambiar Service ni Ingress;
- validar que un dato de laboratorio sobrevive a la recreación de Pods;
- ejecutar una copia y restauración básica de un fichero inocuo;
- diagnosticar PVC `Pending`, fallo de montaje y permisos de escritura;
- explicar las limitaciones de `microk8s-hostpath` frente a almacenamiento cloud;
- justificar cuándo un `Deployment` sigue siendo suficiente y cuándo considerar `StatefulSet`.

---

# Alcance

## Incluido

- saneamiento documental de la Unidad 04 contra el contrato cerrado;
- reutilización de `platform-api`, `platform-training` y `labs/04-persistence-state/solution/`;
- laboratorio existente en `labs/04-persistence-state/`, sin cambios durante fase 4;
- explicación de filesystem efímero, `emptyDir`, volumen proyectado y volumen persistente;
- explicación de PV, PVC, StorageClass, binding, access modes y `reclaimPolicy`;
- uso de `microk8s-hostpath` como detalle local ya existente del laboratorio;
- criterio profesional sobre CSI, discos cloud, topología, snapshots, backup y restore;
- cobertura documental de `StatefulSet`, headless Service y `volumeClaimTemplates` como parte de `GAP-004`;
- registro explícito de que la práctica funcional de `StatefulSet` queda implementada y validada en `TD-023`;
- actualización de `README.md`, `student-notes.md`, `student-reference.md`, `summary.md` y `project/project-state.md` al cierre documental.

## Excluido

- generación de Unidad 08;
- modificación de laboratorios de Unidades 01-07 durante el saneamiento documental;
- modificación de manifiestos Kubernetes durante fase 4;
- modificación de scripts de `platform/environment`;
- ejecución de validaciones funcionales nuevas durante fase 4;
- creación de workloads nuevos durante fase 4;
- creación de charts Helm o módulos Terraform;
- instalación o configuración de Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- práctica funcional de `StatefulSet`, headless Service y `volumeClaimTemplates` dentro de esta sesión documental;
- bases de datos reales, operadores, replicación, cifrado productivo, Velero o snapshots CSI;
- sustitución de `platform-api` o creación de namespaces funcionales alternativos;
- introducción de Minikube, kind o Docker Desktop Kubernetes como plataforma paralela.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Scheduling, resiliencia y mantenimiento | Unidad 05 | Retoma el impacto de PVC local sobre colocación, interrupciones y mantenimiento |
| Empaquetado con Helm | Unidad 06 | Requiere manifiestos acumulados y estables |
| Automatización local con Terraform | Unidad 07 | Requiere chart Helm funcional |
| Jobs y CronJobs | Unidad 08 | Parte del mapa de workloads no Deployment |
| Gestión real de secretos y GitOps | Unidad 09 | Requiere propiedad declarativa y tratamiento seguro fuera de Git |
| Práctica de `StatefulSet`, headless Service y `volumeClaimTemplates` | `TD-023` sobre Unidad 04 | Cierre funcional de `GAP-004`; implica crear workload auxiliar y validar en MicroK8s |
| Seguridad de workloads, ownership, RBAC y políticas | Unidad 16 | Requiere baseline funcional antes de gobierno y seguridad avanzada |
| Desacoplamiento de MicroK8s | Unidad 19 | Separa supuestos locales de Kubernetes estándar y cloud |
| Storage cloud gestionado, CSI, zonas y cifrado | Unidades 20 y 21 | Depende de AKS/EKS y de sus drivers |
| Backup, restore, RPO/RTO y continuidad | Unidad 23 | Requiere operación avanzada y runbooks |

## Diseño acordado para `TD-023`

`TD-023` queda fuera del saneamiento documental, pero su diseño funcional ya está decidido y aplicado para que futuras sesiones no reabran `Q-010`:

- el workload auxiliar se llamará `scratch-stateful`, con prefijo que lo señale como desechable;
- usará la misma imagen y tag que `platform-api`, con comando sobrescrito para escribir la identidad de la réplica;
- tendrá dos réplicas, para observar un PVC por ordinal;
- vivirá en `labs/04-persistence-state/statefulset-demo/`, fuera de `solution/`, para no propagarse a Unidades 05, 06 y 07;
- no migrará `platform-api` a StatefulSet;
- la limpieza borrará PVC por nombre exacto, nunca por selector ni con `--all`, y no tocará `platform-api-data`;
- la validación heredada `labs/04-persistence-state/validation/validate.sh` no se modificará; la práctica tendrá validación independiente.

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar y diagnosticar el laboratorio: PVC `platform-api-data`, StorageClass local, montaje en `/usr/share/nginx/html/persistent`, escritura de dato inocuo, recreación controlada de Pods, copia/restauración básica y fallos típicos de PVC, mount y permisos.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: PV/PVC/StorageClass como contrato, CSI y proveedores, access modes y concurrencia, `reclaimPolicy`, `volumeBindingMode`, `StatefulSet`, headless Service, `volumeClaimTemplates`, snapshots, backup, restore, cloud y límites de `hostpath-storage`.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta. El diagnóstico de fallos del laboratorio pertenece a `student-notes.md`; los errores de concepto pertenecen a `student-reference.md`.

## Laguna asignada

```text
GAP-004 - Workloads no Deployment
```

La Unidad 04 cubre documentalmente el criterio profesional de `StatefulSet`, headless Service y volumen por réplica en `tutorial/04-persistence-state/student-reference.md`. La práctica de `StatefulSet`, headless Service y `volumeClaimTemplates` quedó registrada como `TD-023` y fue implementada y validada en `labs/04-persistence-state/statefulset-demo/`.

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 04 |
|---|---|
| Panorama | Situar almacenamiento Kubernetes, persistencia, durabilidad, recuperación, cloud y workloads con identidad estable |
| Profundidad | Explicar la cadena aplicación -> `volumeMount` -> `volume` -> PVC -> PV -> StorageClass -> proveedor |
| Criterio | Decidir entre `Deployment` y `StatefulSet`, evaluar StorageClass, access modes, reclaim, CSI, snapshot y backup |
| Práctica | Nombrar distancias con producción: `hostpath-storage`, nodo único, sin CSI cloud, sin snapshot productivo, sin backup real y sin workload stateful práctico |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| `microk8s-hostpath` | Confundir almacenamiento local con durabilidad cloud | CSI del proveedor, zonas, rendimiento, cifrado, backup y pruebas de restore |
| PVC único montado por un `Deployment` | Creer que todo estado se resuelve con Deployment + PVC | `StatefulSet`, headless Service y volumen por réplica cuando haya identidad estable |
| `ReadWriteOnce` en laboratorio local | Interpretarlo como bloqueo lógico de escritura concurrente | Diseñar concurrencia en la aplicación y elegir storage compatible |
| Copia manual de fichero inocuo | Confundir copia de laboratorio con backup productivo | Políticas, retención, RPO/RTO, cifrado, ownership y restauraciones probadas |
| Sin snapshots CSI | Pensar que snapshot y backup son equivalentes o siempre disponibles | Verificar soporte CSI, consistencia de aplicación y restauración |
| Sin parametrización real de StorageClass en manifiestos planos | Dificultar migración cloud si se copia literalmente | Parametrización con Helm en Unidad 06 y decisiones cloud en Unidades 20/21 |
| Sin práctica de `reclaimPolicy` `Retain` | No detectar PV retenidos o huérfanos tras borrar claims | Explicar diferencia entre `Delete`, `Retain`, dato residual, ownership y limpieza operada |
| `emptyDir` solo como contraste conceptual | Usarlo por error para estado que debe sobrevivir al Pod | Explicar cuándo sirve para scratch space y por qué no es persistencia |

## Uso de `project/coverage-map.md`

La sección de Unidad 04 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

| Punto de `project/coverage-map.md` | Clasificación | Tratamiento |
|---|---|---|
| Diferencias entre almacenamiento efímero y persistente; `emptyDir`; access modes | Práctica existente y criterio conceptual | Cubierto en notas y referencia; access modes se explican como contrato Kubernetes, no como garantía de concurrencia |
| PVC y aprovisionamiento dinámico mediante `microk8s-hostpath` | Práctica existente del laboratorio | Cubierto por `pvc.yaml`, notas y referencia; se declara como detalle local de MicroK8s |
| Desacoplamiento cloud y parametrización de StorageClass | Criterio profesional y continuidad | Cubierto como criterio; la parametrización ejecutable queda para Helm y cloud |
| Políticas de reciclaje y estado huérfano; `Retain` frente a `Delete` | Criterio conceptual y laguna real de modelo operativo | Reforzado en referencia; no se cambia `reclaimPolicy` ni PV del laboratorio |
| Pruebas de resistencia y consistencia de datos | Práctica existente con corrección conceptual | El laboratorio recrea Pods y valida persistencia; no simula fallos físicos catastróficos ni pérdida de nodo |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `project/project-state.md`;
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
14. `playbooks/units/04-persistence-state.md`;
15. sección de Unidad 04 en `project/coverage-map.md`;
16. `tutorial/03-networking-ingress/summary.md`;
17. `tutorial/04-persistence-state/README.md`;
18. `tutorial/04-persistence-state/student-notes.md`;
19. `tutorial/04-persistence-state/student-reference.md`;
20. `tutorial/04-persistence-state/summary.md`;
21. `labs/04-persistence-state/README.md`;
22. `labs/04-persistence-state/solution/`.

## Excepciones

Ninguna. La Unidad 03 está cerrada y existe `tutorial/03-networking-ingress/summary.md`.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- historial del saneamiento consolidado en `project/project-state.md`;
- `tutorial/03-networking-ingress/summary.md`;
- artefactos actuales de la Unidad 04;
- registro de lagunas `project/content-gap-register.md`;
- `project/coverage-map.md` como checklist, no como estructura.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Entorno local | Heredado de Unidad 00 | Evidencia registrada en `tutorial/00-environment/summary.md` y `project/project-state.md` |
| `platform-api` expuesta por Ingress | Generada en Unidad 03 | Evidencia registrada en `tutorial/03-networking-ingress/summary.md` |
| PVC `platform-api-data` | Generado en Unidad 04 | `labs/04-persistence-state/solution/pvc.yaml` |
| StorageClass `microk8s-hostpath` | Habilitada y validada en la generación original | Evidencia registrada en `tutorial/04-persistence-state/summary.md` |

Durante fase 4 no se ejecutan validaciones funcionales nuevas.

## Dependencias pedagógicas

El alumno debe haber completado o dominar:

- Unidad 00 y validación del entorno local;
- Unidad 01 y despliegue inicial de `platform-api`;
- Unidad 02 y separación entre configuración, secretos ficticios, probes y resources;
- Unidad 03 y relación entre Deployment, Service, EndpointSlice e Ingress;
- lectura básica de YAML;
- uso básico de `kubectl apply`, `get`, `describe`, `exec`, `logs`, `rollout status` y `delete` con alcance controlado.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/03-networking-ingress/summary.md
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

La fase 4 parte de la Unidad 04 ya generada, validada funcionalmente y aprobada pedagógicamente. `platform-api` conserva Service e Ingress de Unidad 03 y añade un PVC local montado en una ruta servida por Nginx.

Durante el saneamiento documental no se cambia ese estado técnico. El objetivo es alinear playbook, README, notas, referencia y summary con el contrato documental cerrado.

## Validación del estado inicial

La evidencia funcional ya está registrada en `tutorial/04-persistence-state/summary.md`.

Comprobaciones permitidas durante fase 4:

```bash
git diff --check
git status --short
rg "<patrón>" <rutas documentales>
```

Resultado esperado:

```text
Cambios limitados a documentación permitida; sin modificaciones funcionales.
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Estado anterior y continuidad |
| Laboratorio Unidad 04 | `labs/04-persistence-state/` | Evidencia técnica existente, sin cambios en fase 4 |
| Solution Unidad 04 | `labs/04-persistence-state/solution/` | Base funcional ya validada y reutilizada por Unidad 05 |
| Referencia actual | `tutorial/04-persistence-state/student-reference.md` | Documento conforme a ajustar, no regenerar por completo |
| Registro de lagunas | `project/content-gap-register.md` | Estado de `GAP-004` y `TD-023` |

## Reglas de reutilización

- conservar `platform-api` como aplicación evolutiva;
- conservar `platform-training` como namespace funcional;
- no modificar `labs/04-persistence-state/` durante fase 4;
- no cambiar `storageClassName: microk8s-hostpath` ni los manifiestos existentes;
- conservar la práctica de `StatefulSet` fuera de `solution/`;
- no declarar `GAP-004` como cerrada funcionalmente sin evidencia de validación de `TD-023`.

---

# Cambios esperados en la unidad

## Documentación del alumno

Actualizar:

```text
tutorial/04-persistence-state/README.md
tutorial/04-persistence-state/student-notes.md
tutorial/04-persistence-state/student-reference.md
tutorial/04-persistence-state/summary.md
```

Reglas:

- el README conserva su función de puerta de entrada;
- `student-notes.md` conserva diagnóstico y práctica de laboratorio;
- `student-reference.md` conserva estructura canónica y desarrolla criterio profesional;
- `summary.md` registra cierre documental, cobertura y validaciones no ejecutadas;
- `summary.md` distingue la validación funcional original de la revisión documental de fase 4.

## Laboratorio

No se modifica durante fase 4:

```text
labs/04-persistence-state/
```

`TD-023` modifica el laboratorio después de `TD-022` mediante la práctica funcional de `StatefulSet`, headless Service y `volumeClaimTemplates`, situada fuera de `solution/`.

## Estado del proyecto

Actualizar `project/project-state.md` para registrar:

- Unidad 04 saneada documentalmente;
- `GAP-004` cubierto documentalmente en Unidad 04 y cerrado funcionalmente en `TD-023`;
- `TD-023` como fase funcional posterior cerrada con validación real;
- siguiente incremento permitido: auditoría de autosuficiencia `TD-022`.

---

# Criterios de aceptación documental

La unidad queda saneada documentalmente cuando:

- el playbook declara frontera entre `student-notes.md` y `student-reference.md`;
- el playbook declara `GAP-004` y `TD-023`;
- `project/coverage-map.md` queda cubierto punto por punto como checklist;
- `student-reference.md` no incluye `summary.md` en la tabla de artefactos del alumno;
- `student-reference.md` explica `reclaimPolicy`, access modes, CSI, StatefulSet, headless Service, `volumeClaimTemplates`, snapshots, backup y restore sin proponer cambios ejecutables;
- `student-notes.md` mantiene el diagnóstico del laboratorio y ancla sus exclusiones a la referencia;
- `README.md` remite a notas y referencia sin duplicarlas;
- `summary.md` registra el saneamiento y conserva separada la validación funcional original;
- `project/project-state.md` registra que el siguiente trabajo permitido es `TD-022`;
- no hay cambios en laboratorios, manifiestos, scripts de plataforma ni workloads.

---

# Validación

Durante esta fase solo se permiten comprobaciones documentales y estáticas:

```bash
git diff --check
git status --short
rg "<patrón>" <rutas documentales>
```

No se deben ejecutar:

- `bash labs/04-persistence-state/validation/validate.sh`;
- validaciones funcionales de unidades 01-07;
- comandos que creen, borren o modifiquen recursos Kubernetes;
- `kubectl apply`, `kubectl delete`, `kubectl drain`, `kubectl cordon` o `kubectl uncordon`;
- scripts de `platform/environment`.

---

# Cierre

Al cerrar el saneamiento documental:

1. actualizar `tutorial/04-persistence-state/summary.md`;
2. actualizar `project/project-state.md`;
3. revisar `git diff --check`;
4. revisar que `git diff -- labs/04-persistence-state platform/environment` no muestra cambios;
5. reportar cobertura punto por punto contra `project/coverage-map.md`;
6. declarar que la aprobación específica del usuario queda pendiente hasta que el usuario la confirme.

La Unidad 08 continúa congelada hasta cerrar `TD-022` y ejecutar con éxito la fase 5 `TD-023`; ambas condiciones quedaron satisfechas el 2026-07-27.
