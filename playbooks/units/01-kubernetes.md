# Playbook de la Unidad 01 - Fundamentos operativos y primera aplicación

## Identificación

### Unidad

```text
01 - Fundamentos operativos y primera aplicación
```

### Identificador

```text
01-kubernetes
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

La Unidad 01 transforma el clúster MicroK8s validado en la Unidad 00 en la primera base funcional del itinerario: la aplicación evolutiva `platform-api`, desplegada de forma declarativa mediante `Namespace`, `Deployment` y `Service`.

La unidad aparece aquí porque antes de incorporar configuración, secretos, red de entrada, persistencia, Helm, Terraform o GitOps el alumno necesita ver directamente cómo Kubernetes recibe declaraciones, persiste estado deseado, reconcilia objetos y expone una aplicación mediante selección por labels. También deja las convenciones iniciales de namespace, nombres, labels, selectors, imagen y validación que reutiliza la Unidad 02.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que han preparado el entorno local, pero que todavía no dominan Kubernetes, sus recursos principales ni su modelo declarativo.

Se explican desde cero:

- qué representa un clúster Kubernetes;
- qué papel tienen `kube-apiserver`, datastore del clúster, scheduler, controller manager, kubelet, kube-proxy y container runtime;
- qué diferencia hay entre estado deseado y estado observado;
- qué son `Namespace`, `Deployment`, `ReplicaSet`, `Pod`, `Service`, labels, selectors, endpoints y eventos;
- cómo una petición de `kubectl apply` llega a la API y acaba produciendo Pods;
- cómo un Service `ClusterIP` selecciona Pods sin depender de sus nombres efímeros;
- cómo usar estado, eventos y logs para diagnosticar fallos básicos del laboratorio.

Se retoman de unidades anteriores:

- Ubuntu WSL, MicroK8s y `kubectl` como entorno local operativo;
- Helm y Terraform como herramientas ya instaladas, sin usarlas todavía;
- contenedores, imágenes, runtime y registros desde `tutorial/00-environment/student-reference.md`;
- lectura de comandos desde la raíz del repositorio.

Se mencionan solo para continuidad:

- ConfigMaps, Secrets, probes, requests, limits y rollout por cambios en el template del Pod;
- Ingress, Gateway API, DNS externo y TLS;
- almacenamiento persistente, `StatefulSet` y `Headless Service`;
- estrategias avanzadas de despliegue, incluidas diferencias entre `Recreate` y `RollingUpdate`;
- CoreDNS y resolución FQDN interna;
- Helm, Terraform, Tekton, Argo CD, observabilidad, seguridad, escalado y cloud.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que todo workload debe ser un `Deployment`;
- confundir Pod con contenedor;
- tratar `ReplicaSet` como artefacto principal de autoría;
- pensar que el Service apunta al Deployment por nombre;
- creer que `kubectl apply` equivale a aplicación disponible;
- asumir que un único nodo MicroK8s representa disponibilidad de producción;
- confundir etiquetas y anotaciones;
- interpretar `RollingUpdate` como garantía suficiente de despliegue sin indisponibilidad;
- pensar que DNS interno, Ingress y exposición externa son lo mismo.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- validar que el entorno MicroK8s heredado de la Unidad 00 está listo para recibir workloads;
- desplegar `platform-api` con manifiestos declarativos de `Namespace`, `Deployment` y `Service`;
- explicar el recorrido de una declaración desde `kubectl` hasta Pods reales y endpoints de Service;
- distinguir qué responsabilidades pertenecen al control plane, al nodo, al runtime, a la red y al almacenamiento;
- relacionar Deployment, ReplicaSet y Pods sin gestionar Pods manuales como diseño principal;
- justificar por qué el laboratorio usa un `Deployment` y no `StatefulSet`, `DaemonSet`, `Job` o `CronJob`;
- validar estado, rollout, Pods, labels, selectors, endpoints, eventos y logs;
- diagnosticar fallos básicos de namespace, imagen, selector, contexto y arranque de contenedor;
- explicar qué queda preparado para que la Unidad 02 añada configuración, secretos de laboratorio, probes y recursos.

---

# Alcance

## Incluido

- primera aplicación evolutiva `platform-api`;
- namespace funcional `platform-training`;
- manifiestos declarativos en `labs/01-kubernetes/starter/` y `labs/01-kubernetes/solution/`;
- `Deployment` con dos réplicas de `nginxinc/nginx-unprivileged:1.27.4-alpine`;
- `Service` `ClusterIP` para acceso interno estable;
- labels y selectors como contrato entre Deployment, Pods y Service;
- observación de ReplicaSet, Pods, endpoints, eventos y logs;
- explicación conceptual del control plane, nodos, datastore, scheduler, controladores, kubelet, kube-proxy, runtime, CRI, CNI y CSI;
- diferencia entre etiquetas y anotaciones, dejando las anotaciones corporativas como criterio, no práctica;
- mapa profesional de workloads en `student-reference.md` para cerrar la parte documental de `GAP-004`;
- explicación conceptual de `Recreate` frente a `RollingUpdate`, sin cambiar la estrategia del laboratorio;
- explicación conceptual de CoreDNS y FQDN internos, sin crear recursos DNS nuevos;
- validación no destructiva mediante `labs/01-kubernetes/validation/validate.sh`;
- actualización de `summary.md` y `project/project-state.md` al cierre documental.

## Excluido

- implementación práctica de ConfigMaps, Secrets, variables de entorno y volúmenes de configuración;
- implementación práctica de probes, requests y limits;
- implementación práctica de Ingress, Gateway API, TLS o DNS externo;
- implementación práctica de almacenamiento persistente, `StatefulSet` o `Headless Service`;
- configuración manual de ReplicaSets como artefacto principal;
- creación de Jobs, CronJobs, DaemonSets u otros workloads nuevos;
- cambio de estrategia del Deployment o ajuste práctico de `maxSurge` y `maxUnavailable`;
- instalación, sustitución o configuración avanzada de CRI, CNI, CSI, CoreDNS o container runtime;
- anotaciones corporativas obligatorias de ciclo de vida;
- charts Helm, módulos Terraform, pipelines Tekton o aplicaciones Argo CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry, OpenMetrics o KEDA;
- recursos AKS, EKS o cloud;
- modificación de laboratorios, manifiestos Kubernetes o workloads durante el saneamiento documental.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| ConfigMaps, Secrets, variables, volúmenes de configuración, probes, requests y limits | Unidad 02 | Requieren un Deployment base ya existente |
| Ingress HTTP local | Unidad 03 | Requiere Service y workload operativo |
| Gateway API, TLS y certificados | Unidad 03 como referencia; práctica posterior si procede | Son frontera de entrada y seguridad perimetral, no fundamento inicial |
| Persistencia, PVC, StorageClass, `StatefulSet` y `Headless Service` | Unidad 04 | `GAP-004` mantiene práctica de estado en su unidad natural |
| Estrategias de rollout avanzadas y ajuste fino de `maxSurge`/`maxUnavailable` | Unidad 05 y continuidad posterior | Requiere probes, recursos y criterios de disponibilidad ya tratados |
| Helm | Unidad 06 | Requiere manifiestos Kubernetes estables |
| Terraform | Unidad 07 | Requiere chart Helm funcional |
| Jobs y CronJobs | Unidad 08 | Encajan como tareas finitas y periódicas de CI/CD |
| Argo CD y GitOps | Unidad 09 | Requiere layout declarativo estable |
| CoreDNS avanzado, servicios entre namespaces y DNS operativo profundo | Unidades 03, 19 y cloud | Se retoma al tratar red, migración y plataformas gestionadas |
| DaemonSet | Unidades 13-15 | Encaja con agentes de observabilidad y plataforma |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar el laboratorio: qué representa cada componente usado, qué se construye con `platform-api`, cómo se relacionan Deployment, ReplicaSet, Pods y Service, cómo aplicar y observar manifiestos, y cómo diagnosticar fallos reales del laboratorio.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: mapa profesional de workloads, criterios de elección entre controladores, diferencias entre etiquetas y anotaciones, estrategias de despliegue, límites del laboratorio local, CoreDNS/FQDN interno y continuidad hacia unidades posteriores.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta.

## Laguna asignada

| ID | Tratamiento en esta unidad | Cierre esperado |
|---|---|---|
| `GAP-004` | La referencia cierra documentalmente el mapa conceptual de workloads no Deployment: `StatefulSet`, `DaemonSet`, `Job` y `CronJob`; la práctica de `StatefulSet` y `Headless Service` permanece anclada a Unidad 04 como `TD-023` | Cierre documental de la parte de Unidad 01 en `student-reference.md` y rastro en `summary.md`; `project/content-gap-register.md` sigue en estado `Abordada` mientras `TD-023` no esté implementada y validada |

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 01 |
|---|---|
| Panorama | Situar `Deployment` dentro del mapa completo de workloads y de la arquitectura Kubernetes |
| Profundidad | Explicar controladores, relación Deployment/ReplicaSet/Pod, selector de Service, CoreDNS/FQDN y rollout conceptual |
| Criterio | Decidir cuándo usar `Deployment`, `StatefulSet`, `DaemonSet`, `Job`, `CronJob`, labels o anotaciones |
| Práctica | Nombrar distancias con producción: un nodo local, `ClusterIP` con `port-forward`, imagen pública, ausencia de probes/resources/TLS y estrategia de despliegue no ajustada |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| MicroK8s local de un nodo | No demuestra alta disponibilidad, distribución entre nodos ni fallos zonales | Clústeres multi-nodo, gestión de capacidad, mantenimiento y plataformas gestionadas |
| Imagen pública versionada | Depende de disponibilidad externa y no demuestra control de supply chain | Registro gobernado, tags inmutables, digests, escaneo, firma y promoción |
| Sin probes | El Service puede seleccionar Pods que ejecutan proceso pero no están listos funcionalmente | `startupProbe`, `readinessProbe` y `livenessProbe` desde Unidad 02 |
| Sin requests ni limits | No hay contrato explícito de scheduling, capacidad ni contención | Requests, limits, QoS y políticas de recursos desde Unidad 02 |
| Service `ClusterIP` probado con `port-forward` | No representa exposición estable ni entrada productiva | Ingress/Gateway, TLS, DNS y balanceadores en unidades posteriores |
| Estrategia de Deployment no ajustada | Un rollout puede no cumplir expectativas de disponibilidad sin probes ni presupuesto | Estrategias revisadas junto a probes, PDB, observabilidad y progressive delivery |
| Labels básicos sin anotaciones de gobierno | No codifican ownership, ciclo de vida ni integración con herramientas corporativas | Convenciones de metadata, anotaciones de tooling y gobierno de plataforma |

## Uso de `project/coverage-map.md`

La sección de Unidad 01 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

- arquitectura del plano de control, flujo de `kubectl` hacia la API y diferencia entre datastore local embebido y `etcd` distribuido;
- namespaces, labels y anotaciones como aislamiento lógico y metadata de ciclo de vida;
- anatomía de Pod, kubelet y container runtime `containerd`;
- Deployment como autoría principal y ReplicaSet como controlador derivado observado;
- estrategias `Recreate` y `RollingUpdate`, incluyendo `maxSurge` y `maxUnavailable` como criterio conceptual;
- Service `ClusterIP`, CoreDNS y FQDN interno como descubrimiento interno.

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
14. `playbooks/units/01-kubernetes.md`;
15. `tutorial/00-environment/summary.md`;
16. sección de Unidad 01 en `project/coverage-map.md`;
17. `tutorial/01-kubernetes/README.md`;
18. `tutorial/01-kubernetes/student-notes.md`;
19. `tutorial/01-kubernetes/student-reference.md`;
20. `tutorial/01-kubernetes/summary.md`;
21. `labs/01-kubernetes/README.md`;
22. `labs/01-kubernetes/solution/`.

## Excepciones

Ninguna. La Unidad 00 está cerrada y existe `tutorial/00-environment/summary.md`.

---

# Dependencias

## Dependencias documentales

- `tutorial/00-environment/summary.md`;
- `tutorial/00-environment/student-reference.md`;
- `platform/environment/container-images/README.md`;
- `labs/01-kubernetes/README.md`;
- `labs/01-kubernetes/solution/`;
- `project/content-gap-register.md`.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Ubuntu WSL objetivo | Validado como Ubuntu 24.04 LTS | Evidencia registrada en `tutorial/00-environment/summary.md` |
| MicroK8s | Instalado y operativo | Evidencia registrada en `tutorial/00-environment/summary.md` |
| Kubernetes local | Nodo `Ready` | Evidencia registrada en `tutorial/01-kubernetes/summary.md` |
| `kubectl` | Cliente principal operativo | Evidencia registrada en `tutorial/01-kubernetes/summary.md` |
| Helm | Instalado, no usado en Unidad 01 | Evidencia heredada de Unidad 00 |
| Terraform | Instalado, no usado en Unidad 01 | Evidencia heredada de Unidad 00 |

Durante el saneamiento documental no se ejecutan validaciones funcionales nuevas.

## Dependencias pedagógicas

El alumno debe haber completado o dominar:

- preparación y validación del entorno de Unidad 00;
- conceptos básicos de contenedor, imagen y registro desde `tutorial/00-environment/student-reference.md`;
- uso básico de shell Linux;
- lectura de YAML y salidas tabulares de `kubectl`.

## Dependencias del laboratorio

Artefactos que deben existir:

```text
labs/01-kubernetes/README.md
labs/01-kubernetes/starter/namespace.yaml
labs/01-kubernetes/starter/deployment.yaml
labs/01-kubernetes/starter/service.yaml
labs/01-kubernetes/solution/namespace.yaml
labs/01-kubernetes/solution/deployment.yaml
labs/01-kubernetes/solution/service.yaml
labs/01-kubernetes/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de un entorno MicroK8s local validado por la Unidad 00 y de un repositorio que ya contiene la Unidad 01 generada, validada funcionalmente y aprobada pedagógicamente antes del saneamiento documental.

En el saneamiento documental, el estado inicial esperado es:

- `platform-api` ya definida como aplicación evolutiva;
- namespace funcional `platform-training` ya declarado en manifiestos;
- Deployment y Service ya definidos en `labs/01-kubernetes/solution/`;
- `student-reference.md` existente pero no conforme al contrato canónico;
- `GAP-004` registrada como abordada en `project/content-gap-register.md`;
- Unidad 08 congelada hasta cerrar el saneamiento.

## Validación del estado inicial

Para generación original de la unidad:

```bash
bash platform/environment/validation/validate-environment.sh
kubectl get nodes
kubectl get namespaces
```

Para el saneamiento documental:

```bash
git status --short
test -f tutorial/01-kubernetes/student-reference.md
test -f labs/01-kubernetes/README.md
```

Resultado esperado:

```text
Los documentos y laboratorios de Unidad 01 existen.
No se ejecutan validaciones funcionales nuevas durante el saneamiento.
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 00 | `tutorial/00-environment/summary.md` | Continuidad de entorno, versiones y límites |
| Referencia de imágenes | `tutorial/00-environment/student-reference.md` | Base conceptual para `image` e `imagePullPolicy` |
| Laboratorio de lectura de imágenes | `platform/environment/container-images/README.md` | Apoyo opcional para entender consumo de imágenes |
| Laboratorio Unidad 01 | `labs/01-kubernetes/README.md` | Árbitro de lo que se practica realmente |
| Manifiestos finales | `labs/01-kubernetes/solution/` | Base técnica que no debe modificarse en este saneamiento |
| Registro de lagunas | `project/content-gap-register.md` | Estado de `GAP-004` |

## Reglas de reutilización

- no modificar `labs/01-kubernetes/`;
- no crear workloads nuevos;
- no cambiar manifiestos Kubernetes;
- no crear un segundo namespace funcional;
- conservar `platform-api` y `platform-training`;
- conservar `kubectl` como herramienta operativa de Unidad 01;
- tratar `project/coverage-map.md` como cobertura y checklist, no como estructura.

---

# Cambios previstos sobre la solución

## Componentes nuevos

Ninguno durante el saneamiento documental.

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| Playbook Unidad 01 | Regeneración contra contrato documental cerrado | Conserva alcance técnico y añade frontera notas/referencia |
| `student-reference.md` | Regeneración con estructura canónica | Cierra documentalmente el mapa de workloads de `GAP-004` |
| `README.md` | Ajuste de enlaces, propósito y frontera documental | Mantiene función de puerta de entrada |
| `student-notes.md` | Ajuste de alcance para remitir errores conceptuales a la referencia | Mantiene diagnóstico operativo del laboratorio |
| `summary.md` | Registro del saneamiento documental | No cambia estado técnico validado |
| `project/project-state.md` | Registro del incremento y siguiente trabajo permitido | Mantiene Unidad 08 congelada |

## Componentes retirados

Ninguno.

---

# Decisiones de diseño de la unidad

## D-01-01 - Manifiestos Kubernetes como artefacto primario

### Decisión

La Unidad 01 gestiona `platform-api` mediante manifiestos Kubernetes YAML aplicados con `kubectl`.

### Motivo

El alumno necesita ver las APIs base antes de que Helm, Terraform o GitOps añadan capas de gestión.

### Consecuencias

- Helm y Terraform no gestionan recursos en esta unidad;
- los manifiestos de `solution/` son la base de Unidad 02;
- los documentos deben distinguir Kubernetes estándar de particularidades de MicroK8s.

### Alternativas descartadas

- Helm desde Unidad 01: ocultaría las APIs base.
- Terraform desde Unidad 01: introduciría state e IaC antes de entender workloads.

## D-01-02 - `Deployment` como workload principal inicial

### Decisión

`platform-api` se modela como `Deployment` porque es una aplicación HTTP simple, replicada y reemplazable.

### Motivo

Permite estudiar reconciliación, ReplicaSet, Pods, rollout y Service sin introducir identidad estable ni tareas finitas.

### Consecuencias

- `StatefulSet`, `DaemonSet`, `Job` y `CronJob` se cubren como criterio en la referencia;
- la práctica de otros workloads queda anclada a unidades naturales;
- `GAP-004` se cierra documentalmente en Unidad 01, pero su parte práctica permanece en Unidad 04 como `TD-023`.

### Alternativas descartadas

- Pod manual como aplicación principal: carece de controlador de ciclo de vida.
- StatefulSet desde el inicio: introduce estado e identidad antes de persistencia.

## D-01-03 - Metadata mínima y portable

### Decisión

La unidad usa labels estandarizados `app.kubernetes.io/*` y una label de unidad; las anotaciones corporativas se explican como criterio, pero no se implementan.

### Motivo

Las labels son necesarias para seleccionar Pods y mantener continuidad. Las anotaciones de ciclo de vida dependen de herramientas de gobierno todavía no introducidas.

### Consecuencias

- el laboratorio mantiene metadata suficiente para selección y trazabilidad básica;
- ownership, catálogos, políticas y automatización avanzada se difieren;
- la referencia debe explicar la diferencia entre label y anotación.

### Alternativas descartadas

- Añadir anotaciones corporativas ficticias al saneamiento: modificaría manifiestos fuera de alcance.

## D-01-04 - Service interno antes de entrada externa

### Decisión

La Unidad 01 usa un Service `ClusterIP` y validación HTTP temporal con `kubectl port-forward`.

### Motivo

Permite aprender selección por labels, endpoints y acceso interno antes de introducir Ingress o Gateway API.

### Consecuencias

- no hay endpoint externo permanente;
- CoreDNS y FQDN internos se explican como criterio conceptual;
- entrada HTTP estable, TLS y DNS externo quedan para unidades posteriores.

### Alternativas descartadas

- Ingress desde Unidad 01: invade Unidad 03.
- LoadBalancer local desde Unidad 01: introduce dependencias de red antes del Service básico.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/01-kubernetes/README.md
```

Debe actuar como puerta de entrada. Debe incluir:

1. problema real que resuelve la unidad;
2. relación con la Unidad 00;
3. objetivo de desplegar `platform-api`;
4. mapa de aprendizaje;
5. lectura guiada de `student-notes.md`, `student-reference.md` y README del laboratorio;
6. explicación introductoria de clúster, API, reconciliación, workloads, Service, labels y observabilidad básica;
7. decisiones de diseño principales;
8. referencias oficiales guiadas;
9. conexión con Unidad 02.

## Notas del alumno

Ruta:

```text
tutorial/01-kubernetes/student-notes.md
```

Debe explicar y diagnosticar el laboratorio: componentes usados, aplicación concreta, manifiestos, aplicación declarativa, observación, validación, fallos típicos y recuperación.

No debe desarrollar errores de modelo mental ni convertir la referencia en prerrequisito del laboratorio. Puede remitir a `tutorial/01-kubernetes/student-reference.md` para el mapa profesional de workloads, estrategias y prácticas fuera del laboratorio.

## Referencia del alumno

Ruta:

```text
tutorial/01-kubernetes/student-reference.md
```

Debe seguir `playbooks/student-reference-template.md` y contener exactamente la estructura canónica:

1. propósito de la referencia;
2. relación con la unidad;
3. mapa conceptual;
4. conceptos y mecanismos;
5. criterios de decisión;
6. relación con el laboratorio;
7. errores frecuentes;
8. continuidad;
9. fuentes de referencia.

Debe declarar `GAP-004`, los tipos de cobertura aplicados y las negaciones verificables: no modifica laboratorios, no crea workloads nuevos, no cambia manifiestos, no instala herramientas y no ejecuta validaciones funcionales.

## Notas del instructor

Ruta:

```text
tutorial/01-kubernetes/instructor-notes.md
```

Quedan fuera del alcance de este saneamiento salvo que una contradicción bloqueante obligue a corregirlas. El usuario no las incluyó en el alcance permitido.

## Resumen

Ruta:

```text
tutorial/01-kubernetes/summary.md
```

Debe registrar:

- que la Unidad 01 ya estaba generada, validada funcionalmente y aprobada antes del saneamiento;
- que el saneamiento documental no ejecuta validaciones funcionales nuevas;
- que `student-reference.md` queda regenerado contra contrato;
- que `GAP-004` queda cerrado documentalmente para Unidad 01, con práctica de `StatefulSet` pendiente en Unidad 04 (`TD-023`);
- que `labs/01-kubernetes/` no cambió.

## Laboratorio

Ruta:

```text
labs/01-kubernetes/
```

No se modifica durante este saneamiento.

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

La estructura existente se conserva:

```text
labs/01-kubernetes/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── solution/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── validation/
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/01-kubernetes/README.md` | Referencia operativa del laboratorio |
| `labs/01-kubernetes/starter/` | Punto de partida guiado |
| `labs/01-kubernetes/solution/` | Estado final reutilizable por unidades posteriores |
| `labs/01-kubernetes/validation/validate.sh` | Validación no destructiva del estado esperado |

---

# Flujo pedagógico obligatorio

La unidad debe seguir este orden conceptual:

1. recuperar el estado dejado por Unidad 00;
2. presentar Kubernetes como API declarativa y bucle de reconciliación;
3. separar control plane, datastore, nodos, kubelet, runtime, red y almacenamiento;
4. introducir `Namespace` como aislamiento lógico inicial;
5. introducir `Deployment` como autoría principal de `platform-api`;
6. observar `ReplicaSet` y Pods como recursos derivados;
7. conectar Service, labels, selectors, endpoints, CoreDNS y FQDN interno;
8. validar estado, rollout, logs y eventos;
9. diagnosticar fallos operativos del laboratorio;
10. situar otros workloads y estrategias en la referencia;
11. dejar preparado el Deployment para Unidad 02.

Este orden evita saltar de definiciones a comandos sin explicar la necesidad que conecta cada abstracción con la siguiente.

---

# Procedimientos obligatorios

## Preparación

- confirmar que el alumno trabaja desde la raíz del repositorio;
- validar el entorno heredado cuando se ejecute la unidad;
- distinguir validación técnica histórica de saneamiento documental actual;
- revisar `labs/01-kubernetes/README.md` antes de clasificar cobertura.

## Implementación

- aplicar namespace, Deployment y Service en orden cuando se ejecute el laboratorio;
- explicar el recorrido de una declaración desde `kubectl` hasta Pods y endpoints;
- no introducir cambios en manifiestos durante el saneamiento.

## Validación

- validar Deployment, ReplicaSet, Pods, Service, endpoints, logs y eventos cuando se ejecute la unidad;
- registrar que el saneamiento documental actual no ejecuta validaciones funcionales nuevas.

## Diagnóstico

- cubrir namespace ausente, contexto equivocado, imagen no descargable, selector incorrecto y contenedor en reinicio en `student-notes.md`;
- reservar errores de modelo mental para `student-reference.md`.

## Recuperación

- recuperar el estado esperado reaplicando los manifiestos de `solution/`;
- no usar reset de MicroK8s como limpieza de esta unidad;
- advertir que borrar el namespace elimina la base que reutiliza Unidad 02.

## Limpieza

- documentar limpieza como opcional;
- no ejecutarla durante saneamiento documental.

---

# Validaciones obligatorias

## Validaciones estáticas

| Validación | Herramienta o comando | Resultado esperado |
|---|---|---|
| Coherencia documental | Revisión de rutas y enlaces | Rutas existentes y sin referencias a artefactos nuevos |
| Ausencia de cambios en labs | `git diff -- labs/01-kubernetes` | Sin cambios |
| Sintaxis Bash histórica | `bash -n labs/01-kubernetes/validation/validate.sh` | Solo aplicable cuando se valide técnicamente, no en este saneamiento |

## Validaciones funcionales

| Validación | Procedimiento | Resultado esperado |
|---|---|---|
| Laboratorio Unidad 01 | `bash labs/01-kubernetes/validation/validate.sh` | 0 fallos y 0 avisos según validación histórica registrada |
| Prueba HTTP | `kubectl port-forward` y `curl` | `HTTP/1.1 200 OK` según validación histórica registrada |

No se ejecutan validaciones funcionales nuevas durante la fase 4 documental.

## Validaciones de continuidad

Comprobar que:

- `labs/01-kubernetes/solution/` sigue sin cambios;
- `student-reference.md` declara y cubre `GAP-004`;
- toda exclusión relevante de `student-notes.md` queda cubierta, anclada o declarada fuera del itinerario;
- `project/coverage-map.md` queda cruzado punto por punto en el cierre;
- Unidad 02 puede seguir reutilizando `platform-api`, `platform-training` y `labs/01-kubernetes/solution/`.

## Validaciones no ejecutables en el entorno de generación

Las validaciones funcionales del clúster, Windows, WSL2 y MicroK8s no se ejecutan durante este saneamiento y no deben registrarse como nuevas evidencias.

---

# Escenarios de error obligatorios

| Escenario | Síntoma | Diagnóstico | Recuperación |
|---|---|---|---|
| Namespace ausente | Recursos no aparecen o `platform-training` no existe | `kubectl get namespaces` | Aplicar `namespace.yaml` antes del resto |
| Imagen no descargable | Pod en `ImagePullBackOff` o `ErrImagePull` | `kubectl describe pod` y eventos | Corregir imagen o tag, reaplicar Deployment |
| Selector incorrecto | Service sin endpoints | Comparar labels de Pods y selector del Service | Corregir selector o labels y reaplicar |
| Contenedor falla al iniciar | Pod en `CrashLoopBackOff` | `kubectl logs`, `--previous` y `describe pod` | Corregir imagen, argumentos o configuración inicial |
| Contexto `kubectl` equivocado | Recursos no aparecen o se aplican en otro clúster | `kubectl config current-context` y `kubectl get nodes` | Reconfigurar `kubectl` según Unidad 00 |

---

# Requisitos de seguridad

## Datos sensibles

La Unidad 01 no usa Secrets ni credenciales reales.

No versionar:

- tokens;
- passwords;
- claves privadas;
- kubeconfigs personales;
- certificados privados;
- credenciales de proxy;
- datos corporativos.

## Privilegios

- `kubectl` opera contra el clúster local;
- no se requieren privilegios cloud;
- no se usan comandos con `sudo` para crear recursos Kubernetes;
- los permisos locales de MicroK8s pertenecen a Unidad 00.

## Operaciones destructivas

| Operación | Advertencia | Alcance | Recuperación | Confirmación requerida |
|---|---|---|---|---|
| `kubectl delete namespace platform-training` | Elimina la aplicación que reutiliza Unidad 02 | Recursos funcionales de Unidad 01 | Reaplicar `labs/01-kubernetes/solution/` | Confirmación explícita en laboratorio |

---

# Requisitos de portabilidad

## Kubernetes estándar

- `Namespace`;
- `Deployment`;
- `ReplicaSet`;
- `Pod`;
- `Service`;
- labels y selectors;
- endpoints y EndpointSlice como resultado observado;
- `kubectl apply`, `get`, `describe`, `logs`, `rollout status`;
- DNS interno de Services como comportamiento estándar del clúster cuando DNS está disponible.

## Específico de MicroK8s

- clúster local de un nodo;
- contexto local heredado de Unidad 00;
- datastore embebido de MicroK8s como implementación local frente a `etcd` distribuido en producción;
- addon `dns` heredado como baseline.

## Específico de AKS

No aplica en esta unidad.

## Específico de EKS

No aplica en esta unidad.

## Estrategia de desacoplamiento

- usar APIs Kubernetes estándar;
- conservar nombres y labels portables;
- documentar qué parte es MicroK8s y qué parte es Kubernetes;
- no depender de addons fuera del baseline heredado;
- diferir storage, Ingress, identidad y balanceo cloud a unidades posteriores.

---

# Restricciones de generación

La IA no debe:

- generar Unidad 08;
- tocar `labs/01-kubernetes/`;
- ejecutar validaciones funcionales nuevas;
- crear workloads nuevos;
- modificar manifiestos Kubernetes;
- crear charts Helm;
- crear módulos Terraform;
- instalar o configurar Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- sustituir `platform-api`;
- crear namespaces funcionales alternativos;
- registrar validaciones no ejecutadas como superadas;
- usar `project/coverage-map.md` como contrato o estructura.

La IA sí puede:

- regenerar este playbook contra el contrato documental;
- regenerar `tutorial/01-kubernetes/student-reference.md`;
- ajustar `tutorial/01-kubernetes/README.md`, `student-notes.md`, `summary.md` y `project/project-state.md`;
- ajustar `project/content-gap-register.md` solo si cambia el tratamiento de `GAP-004`;
- reportar cobertura punto por punto contra `project/coverage-map.md`.

---

# Criterios de aceptación

La unidad saneada se considerará lista cuando:

- [ ] `playbooks/units/01-kubernetes.md` declare frontera, laguna, tipos de cobertura, simplificaciones, exclusiones y uso de `project/coverage-map.md`;
- [ ] `tutorial/01-kubernetes/student-reference.md` siga la estructura canónica de `playbooks/student-reference-template.md`;
- [ ] `student-reference.md` declare `GAP-004` y cubra el mapa de workloads sin crear práctica nueva;
- [ ] `student-notes.md` conserve diagnóstico operativo del laboratorio y remita errores conceptuales a la referencia;
- [ ] `README.md` funcione como puerta de entrada y no como segunda guía extensa de laboratorio;
- [ ] `summary.md` registre el saneamiento documental y la ausencia de nuevas validaciones funcionales;
- [ ] `project/project-state.md` refleje el incremento y mantenga Unidad 08 congelada;
- [ ] `project/content-gap-register.md` quede coherente con `GAP-004`;
- [ ] `labs/01-kubernetes/` no tenga cambios;
- [ ] no se hayan ejecutado validaciones funcionales nuevas;
- [ ] la cobertura de `project/coverage-map.md` se reporte punto por punto.

---

# Estado final esperado

## Plataforma

- Sin cambios técnicos respecto al estado validado previamente.

## Aplicación

- `platform-api` sigue siendo la aplicación evolutiva.
- `platform-training` sigue siendo el namespace funcional.
- Deployment y Service permanecen definidos en `labs/01-kubernetes/solution/`.

## Automatización

- Sin charts Helm ni módulos Terraform nuevos.
- Sin cambios en scripts de validación.

## Seguridad

- Sin Secrets reales.
- Sin credenciales nuevas.

## Artefactos principales

```text
playbooks/units/01-kubernetes.md
tutorial/01-kubernetes/README.md
tutorial/01-kubernetes/student-notes.md
tutorial/01-kubernetes/student-reference.md
tutorial/01-kubernetes/summary.md
project/project-state.md
project/content-gap-register.md
```

---

# Información obligatoria para el summary

El `summary.md` deberá destacar:

- playbook regenerado contra contrato documental;
- `student-reference.md` regenerado con estructura canónica;
- `GAP-004` cerrado documentalmente para Unidad 01 y práctica de `StatefulSet` pendiente en Unidad 04 (`TD-023`);
- documentos de alumno ajustados sin modificar laboratorio;
- ausencia de validaciones funcionales nuevas;
- Unidad 02 mantiene la misma base técnica de entrada.

---

# Impacto esperado en project-state

Actualizar como mínimo:

- resumen ejecutivo;
- fase actual;
- último incremento completado;
- artefactos de gobierno y Unidad 01;
- registro narrativo de la fase 4;
- siguiente incremento permitido.

No registrar componentes previstos como implementados ni validaciones funcionales como ejecutadas.

---

# Conexión con la siguiente unidad

## Siguiente unidad prevista tras este saneamiento

```text
Continuar fase 4 con saneamiento documental de la Unidad 00
```

La Unidad 08 permanece congelada hasta cerrar las fases 4 y 5 del saneamiento.

## Capacidades que deja preparadas para Unidad 02

- aplicación evolutiva desplegada;
- namespace funcional del curso;
- manifiestos base de Kubernetes;
- convenciones iniciales de labels y selectors;
- validación básica de estado, logs y eventos.

## Elementos que la Unidad 02 reutiliza

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Manifiestos de solución | `labs/01-kubernetes/solution/` | Base para ConfigMaps, Secrets, probes y recursos |
| Summary Unidad 01 | `tutorial/01-kubernetes/summary.md` | Fuente de continuidad |
| Namespace funcional | `platform-training` | Aislamiento de recursos del curso |
| Aplicación evolutiva | `platform-api` | Debe evolucionar sin reemplazarse |

---

# Riesgos específicos

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Confundir `project/coverage-map.md` con contrato | Media | Alto | Declarar su uso solo como checklist y reportar cobertura |
| Reabrir alcance técnico de labs | Media | Alto | Mantener `labs/` sin cambios y no ejecutar validaciones funcionales |
| Cerrar `GAP-004` como si la práctica estuviera implementada | Media | Alto | Registrar cierre documental de Unidad 01 y mantener `TD-023` en Unidad 04 |
| Duplicar diagnóstico entre notas y referencia | Media | Medio | Notas para fallos de laboratorio; referencia para errores conceptuales |
| Anticipar Unidad 08 | Baja | Alto | Mantenerla congelada en playbook y estado |

---

# Cuestiones abiertas

| Cuestión | Bloqueante | Momento de resolución |
|---|---|---|
| Aprobación específica del saneamiento documental de Unidad 01 | No bloquea la entrega documental; sí el cierre pedagógico final | Revisión del usuario |
| Práctica de `StatefulSet` y `Headless Service` asociada a `GAP-004` | No para Unidad 01 | Fase 5 / Unidad 04 (`TD-023`) |

---

# Checklist de revisión del playbook

Antes de cerrar el saneamiento:

- [x] la unidad existe en `project/roadmap.md`;
- [x] el identificador y las rutas son consistentes;
- [x] la frontera entre notas y referencia está declarada;
- [x] `GAP-004` está declarado con tratamiento y límite;
- [x] los tipos de cobertura están declarados;
- [x] las simplificaciones que obligan a práctica profesional están declaradas;
- [x] las exclusiones tienen destino o quedan fuera del itinerario;
- [x] `project/coverage-map.md` se usa solo como cobertura y checklist;
- [x] el saneamiento no autoriza cambios de laboratorio;
- [x] no contradice arquitectura, estado, roadmap ni playbook maestro.

---

# Metadatos de mantenimiento

## Fecha de creación

```text
2026-07-18
```

## Última revisión

```text
2026-07-27
```

## Nota de saneamiento

```text
Regenerado en fase 4 contra el contrato documental cerrado. No modifica laboratorios ni estado técnico del clúster.
```
