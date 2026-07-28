# Playbook de la Unidad 06 - Empaquetado con Helm

## Identificación

### Unidad

```text
06 - Empaquetado con Helm
```

### Identificador

```text
06-helm-packaging
```

### Fase del roadmap

```text
Fase 3 - Empaquetado e infraestructura como código
```

### Estado del playbook

```text
Aprobado
```

### Propietario lógico

```text
Empaquetado e infraestructura como código
```

---

# Propósito de la unidad

La Unidad 06 introduce Helm como mecanismo de empaquetado, parametrización y gestión de releases para la aplicación evolutiva `platform-api`. La unidad parte de los manifiestos Kubernetes estables de `labs/05-scheduling-resilience-maintenance/solution/`, que ya incluyen configuración externa, Secret ficticio, probes, requests/limits, Service, Ingress, PVC, estrategia `RollingUpdate`, constraints seguros de scheduling y `PodDisruptionBudget`.

Helm aparece después de scheduling y resiliencia porque no debe ocultar decisiones de Kubernetes que el alumno todavía no haya practicado. El objetivo es convertir manifiestos conocidos en un chart mantenible, explicar cómo el motor de plantillas transforma values y templates en YAML Kubernetes, y preparar la frontera con Terraform que se ejecuta en la Unidad 07.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que ya han aplicado manifiestos Kubernetes, pero que todavía no dominan Helm, Go templates, jerarquía de valores, helpers, release history ni rollback de releases.

Se explican desde cero:

- qué representan chart, template, values file y release;
- cómo Helm renderiza templates hacia manifiestos Kubernetes;
- cómo se relacionan `Chart.yaml`, `values.yaml`, `values-local.yaml`, `templates/` y `_helpers.tpl`;
- qué contienen `.Values`, `.Chart`, `.Release` y `.Capabilities`;
- cómo funcionan el contexto `.`, el contexto raíz `$`, `if`, `range` y `with`;
- cómo usar pipelines, `quote`, `toYaml`, `indent`, `nindent` e `include` para producir YAML legible;
- cómo se fusionan valores por defecto, archivos `-f` y overrides puntuales de CLI;
- cómo instalar, actualizar, inspeccionar y revertir un release local;
- cómo validar con `helm lint`, `helm template`, dry-run cliente y comprobaciones Kubernetes.

Se retoman de unidades anteriores:

- `platform-api` como aplicación evolutiva;
- namespace funcional `platform-training`;
- Deployment, ReplicaSet, Pods, ConfigMap, Secret ficticio, Service, EndpointSlice, Ingress, PVC y PDB;
- probes, requests/limits, labels, selectors, rollout y scheduling;
- diagnóstico operativo con `kubectl get`, `describe`, `logs`, `rollout status` y eventos;
- separación entre documentación formativa, referencia profesional y README operativo del laboratorio.

Se mencionan solo para continuidad:

- gestión del release Helm mediante Terraform;
- `helm_release`, `templatefile()` y `set_sensitive`;
- módulos Terraform;
- publicación de charts en repositorios remotos u OCI;
- subcharts y patrón umbrella;
- hooks y `helm test`;
- firma, provenance, políticas de supply chain y admisión;
- integración con Argo CD, Tekton y promoción entre entornos;
- gestión real de secretos productivos.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que Helm reemplaza Kubernetes;
- creer que un chart válido garantiza una aplicación disponible;
- convertir todos los campos en variables sin criterio;
- confundir defaults del chart con valores de entorno;
- usar `--set` como mecanismo principal para estructuras complejas;
- perder el contexto dentro de `range` o `with`;
- romper YAML por sangría o control incorrecto de espacios;
- duplicar nombres, labels y selectors en cada template en lugar de usar helpers;
- guardar secretos reales en `values.yaml`, `values-local.yaml` o comandos;
- tratar hooks, subcharts, umbrella charts y repositorios remotos como parte ejecutable de esta unidad.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- convertir los manifiestos acumulados de `platform-api` en un chart Helm funcional;
- explicar el flujo desde values y templates hasta YAML Kubernetes renderizado;
- parametrizar imagen, réplicas, Ingress, resources, scheduling, PVC y PDB sin ocultar su significado;
- leer `_helpers.tpl` para identificar nombres, labels y selectors reutilizables;
- justificar qué valores deben exponerse y cuáles deben permanecer fijos;
- separar valores por defecto, valores locales y overrides puntuales;
- instalar, actualizar, inspeccionar y revertir un release local;
- validar un chart con `helm lint`, `helm template`, dry-run cliente y comprobaciones Kubernetes;
- reconocer errores de modelo mental sobre Helm, Kubernetes, values, releases y secretos;
- explicar dónde termina Helm y dónde empieza Terraform en la Unidad 07.

---

# Alcance

## Incluido

- reutilización de `labs/05-scheduling-resilience-maintenance/solution/` como entrada técnica;
- chart local para `platform-api` en `labs/06-helm-packaging/chart/platform-api/`;
- estructura de chart con `Chart.yaml`, `values.yaml`, `values-local.yaml`, `templates/` y `_helpers.tpl`;
- templates para Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB;
- helpers para nombres, labels, selectors y nombres derivados;
- values por defecto seguros para laboratorio y values locales para MicroK8s;
- instalación y upgrade local con Helm CLI;
- rollback de release Helm;
- inspección con `helm status`, `helm get values`, `helm get manifest` y `helm history`;
- validación con `helm lint`, `helm template`, dry-run cliente y script heredado de la unidad;
- referencia del alumno conforme a `playbooks/student-reference-template.md`;
- explicación conceptual de subcharts, umbrella charts, hooks, `helm test`, repositorios remotos y Terraform sin práctica nueva.

## Excluido

- creación o modificación de módulos Terraform;
- ejecución de `helm_release` mediante Terraform en esta unidad;
- gestión real de secretos productivos;
- integración con External Secrets Operator, Sealed Secrets, SOPS o Vault;
- repositorios remotos de charts, OCI registry o publicación de paquetes;
- subcharts ejecutables o umbrella chart ejecutable;
- hooks ejecutables y `helm test` ejecutable;
- Tekton, Argo CD, GitOps o CI/CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automático;
- AKS, EKS o clústeres multi-nodo cloud;
- sustitución de `platform-api`;
- cambio del namespace funcional `platform-training`;
- introducción de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Terraform `helm_release` ejecutable | Unidad 07 | Requiere chart Helm funcional y frontera clara entre empaquetado e IaC |
| Módulos Terraform | Unidad 07 como criterio; práctica posterior si procede | Primero se necesita proyecto Terraform plano y legible |
| Tekton y CI/CD | Unidad 08 | Requiere chart y automatización local previos |
| Argo CD y GitOps | Unidad 09 | Requiere chart y layout declarativo estable |
| Gestión real de secretos en GitOps | Unidad 09 | Pertenece al flujo de secretos sin guardarlos en Git |
| Promoción formal entre entornos | Unidad 10 | Requiere Helm, Terraform, CI/CD y GitOps previos |
| Service mesh | Unidad 16 | Anclaje de `GAP-011`; se tratará como criterio frente a NetworkPolicy y mTLS |
| Topology spread constraints | Unidad 18 | Anclaje de `GAP-011`; encaja con distribución, escalado y capacidad |
| Desacoplamiento de MicroK8s | Unidad 19 | Será el puente hacia AKS/EKS |
| Repositorios remotos u OCI | Unidades cloud o CI/CD posteriores | Requiere registry, credenciales, publicación y gobierno |
| Hooks, `helm test`, subcharts y umbrella charts | Unidades posteriores de CI/CD, datos u operación | Requieren workloads auxiliares, dependencias y validaciones nuevas |
| Secret management productivo | Unidades 09 y 16 | Requiere herramientas, políticas e identidad |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar el laboratorio: qué se construye, cómo se relacionan chart, templates, values y release, cómo observar el renderizado, cómo comprobar el release y cómo diagnosticar fallos operativos del laboratorio.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: arquitectura de Helm, contexto de templates, jerarquía de values, helpers, criterios de parametrización, límites de `--set`, releases frente a recursos Kubernetes, subcharts, umbrella charts, hooks, `helm test`, repositorios remotos, seguridad de values y frontera con Terraform.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta.

## Laguna asignada

| ID | Tratamiento en esta unidad | Cierre esperado |
|---|---|---|
| Ninguna | Unidad 06 no tiene una laguna propia asignada en `project/content-gap-register.md` | No se actualiza el registro salvo que una revisión posterior cambie el estado de una laguna |

`GAP-011` ya figura cerrado en `project/content-gap-register.md`; la Unidad 06 debe respetarlo anclando los elementos excluidos con número de unidad o declarándolos fuera del itinerario.

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 06 |
|---|---|
| Panorama | Situar Helm frente a Kubernetes, Terraform, CI/CD, GitOps y empaquetado de aplicaciones |
| Profundidad | Explicar templates, contexto, values, helpers y release history hasta poder leer el chart de `platform-api` |
| Criterio | Decidir qué parametrizar, cuándo usar `--set`, cuándo usar files, cuándo usar helpers y cuándo evitar complejidad |
| Práctica | Nombrar distancias con producción: Secret ficticio, chart local, HTTP sin TLS, `microk8s-hostpath`, ausencia de registry, hooks y repositorios remotos |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| Chart local en el repositorio | No hay distribución, versionado de paquete ni control de publicación | Repositorio Helm u OCI registry con autenticación, versionado y proceso de promoción |
| Secret ficticio en values | Values y releases pueden quedar almacenados y expuestos según permisos e historial | Secret manager, External Secrets, SOPS, Sealed Secrets o Vault según contexto |
| `values-local.yaml` orientado a MicroK8s | Acopla Ingress, storage y supuestos locales | Values por entorno y matriz clara de diferencias entre local, AKS y EKS |
| `microk8s-hostpath` | Almacenamiento local, de nodo único y sin garantías cloud | CSI gestionado, StorageClass cloud, backups y políticas de retención |
| HTTP local sin TLS | No demuestra certificados, rotación ni terminación segura | TLS con `cert-manager`, Ingress/Gateway y gestión de certificados |
| Rollback Helm local | No equivale a promoción, rollback GitOps ni recuperación de datos | Estrategia de releases, backups, health checks, observabilidad y runbooks |
| Sin subcharts, hooks ni `helm test` ejecutables | No cubre dependencias ni comprobaciones posdespliegue reales | Pruebas y dependencias diseñadas cuando existan workloads auxiliares y CI/CD |

## Uso de `project/coverage-map.md`

La sección de Unidad 06 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

- fundamentos de empaquetado con `templates/`, `values.yaml` y `Chart.yaml`;
- ciclo de vida con `helm lint`, `helm template`, `helm install` y `helm upgrade`;
- parametrización con `.Values`, `.Release.Name`, condicionales y bucles;
- procesamiento de datos con `toYaml`, `indent`, `nindent`, `tpl`, `merge` y control de nulos;
- subcharts, values globales y patrón umbrella como criterio conceptual, no práctica ejecutable;
- hooks, `helm test`, release state y rollback como frontera entre lo practicado y lo profesional.

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
14. `tutorial/05-scheduling-resilience-maintenance/summary.md`;
15. este playbook;
16. `project/coverage-map.md`, solo sección de Unidad 06 y solo como checklist de cobertura;
17. `tutorial/06-helm-packaging/README.md`;
18. `tutorial/06-helm-packaging/student-notes.md`;
19. `tutorial/06-helm-packaging/student-reference.md`;
20. `tutorial/06-helm-packaging/instructor-notes.md`;
21. `tutorial/06-helm-packaging/summary.md`;
22. `labs/06-helm-packaging/README.md`.

## Excepciones

Ninguna. La Unidad 05 existe y deja `tutorial/05-scheduling-resilience-maintenance/summary.md` y `labs/05-scheduling-resilience-maintenance/solution/` como base prevista para Unidad 06.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- historial del saneamiento consolidado en `project/project-state.md`;
- summary de la Unidad 05;
- artefactos actuales de la Unidad 06;
- registro de lagunas para comprobar que la unidad no tiene laguna propia asignada.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| MicroK8s | Instalado y operativo según estado ya registrado | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` según estado ya registrado | `kubectl get nodes` |
| `kubectl` | Cliente operativo | `kubectl version --client` |
| Helm | CLI disponible y chart de Unidad 06 existente | `helm version --short` |
| Namespace `platform-training` | Existente o aplicable desde chart | `kubectl get namespace platform-training` |
| Chart `platform-api` | Disponible en el repositorio | `test -f labs/06-helm-packaging/chart/platform-api/Chart.yaml` |
| Release `platform-api-local` | Gestionado históricamente por Helm y después por Terraform desde Unidad 07 | `helm status platform-api-local --namespace platform-training` |

Durante la fase 4 de saneamiento documental no se declaran nuevas validaciones técnicas como ejecutadas.

## Dependencias pedagógicas

El alumno debe haber completado o dominar:

- Unidad 00: entorno local y herramientas;
- Unidad 01: Deployment, ReplicaSet, Pod, Service, labels y selectors;
- Unidad 02: ConfigMap, Secret ficticio, probes, requests y limits;
- Unidad 03: Service, EndpointSlice e Ingress;
- Unidad 04: PVC, PV, StorageClass y volumen montado;
- Unidad 05: scheduling, rollout, PDB, réplicas y disponibilidad;
- lectura básica de YAML y uso de `kubectl apply`, `get`, `describe`, `logs`, `rollout status` y `rollout history`.

## Dependencias del laboratorio

```text
tutorial/05-scheduling-resilience-maintenance/summary.md
labs/05-scheduling-resilience-maintenance/solution/
labs/06-helm-packaging/README.md
labs/06-helm-packaging/chart/platform-api/
labs/06-helm-packaging/validation/adopt-existing-resources.sh
labs/06-helm-packaging/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` desplegada sobre MicroK8s en el namespace `platform-training`, con configuración externa, Secret ficticio, probes, resources, Service interno, Ingress HTTP local, PVC de laboratorio, estrategia `RollingUpdate`, constraints seguros de scheduling y PDB.

En la fase 4 de saneamiento documental, la Unidad 06 ya existe. El laboratorio técnico no se modifica: solo se regenera el playbook y se ajustan los documentos del alumno necesarios para cumplir el contrato documental.

Estado verificable esperado:

- MicroK8s, Kubernetes y Helm figuran como disponibles en `project/project-state.md`;
- `labs/06-helm-packaging/chart/platform-api/Chart.yaml` existe;
- `labs/06-helm-packaging/chart/platform-api/templates/` contiene templates para los recursos acumulados;
- `labs/06-helm-packaging/validation/validate.sh` existe;
- los secretos versionados son ficticios;
- `platform-api-data` no se borra en el flujo normal;
- la Unidad 07 ya puede gestionar el release Helm desde Terraform, pero eso no cambia el alcance documental de Unidad 06.

## Validación del estado inicial

Comprobaciones documentales permitidas en la fase 4:

```bash
test -f labs/06-helm-packaging/chart/platform-api/Chart.yaml
test -f tutorial/06-helm-packaging/student-reference.md
test -f labs/06-helm-packaging/README.md
```

Las validaciones funcionales heredadas quedan como estado histórico registrado en `tutorial/06-helm-packaging/summary.md`, no como validación nueva de este saneamiento.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/summary.md` | Continuidad técnica y pedagógica |
| Manifiestos Unidad 05 | `labs/05-scheduling-resilience-maintenance/solution/` | Base acumulada convertida en templates Helm |
| Chart Helm Unidad 06 | `labs/06-helm-packaging/chart/platform-api/` | Artefacto técnico ya validado que no se modifica en fase 4 |
| Laboratorio Unidad 06 | `labs/06-helm-packaging/README.md` | Fuente operativa actual |
| Validación Unidad 06 | `labs/06-helm-packaging/validation/validate.sh` | Validación existente, no modificada |
| Script de adopción | `labs/06-helm-packaging/validation/adopt-existing-resources.sh` | Migración controlada desde recursos aplicados con `kubectl` |
| Registro de lagunas | `project/content-gap-register.md` | Confirmar que no hay laguna propia asignada a Unidad 06 |

## Reglas de reutilización

- conservar `platform-api`;
- conservar `platform-training`;
- conservar `platform-api-local`;
- no duplicar el chart Helm;
- no modificar laboratorios ni validaciones en fase 4;
- mantener Secrets ficticios y no introducir credenciales reales;
- preservar Service, Ingress, PVC, PDB, probes, resources, rollout y scheduling de Unidad 05;
- no borrar el PVC como parte normal de instalación, upgrade, rollback o limpieza;
- no crear Terraform en Unidad 06.

---

# Cambios previstos sobre la solución

## Componentes nuevos

Ninguno en fase 4. La unidad ya existe.

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| Playbook Unidad 06 | Regeneración contra `playbooks/unit-template.md` y contrato de `student-reference.md` | Sustituye el molde por módulos y elimina la contradicción documental |
| `student-reference.md` | Regeneración completa contra `playbooks/student-reference-template.md` | Mantiene cobertura de Helm y separa errores conceptuales de diagnóstico operativo |
| `README.md` | Ajuste de enlaces, ortografía y frontera con referencia | Conserva función de puerta de entrada |
| `student-notes.md` | Ajuste de alcance y remisión de errores conceptuales | Conserva diagnóstico operativo del laboratorio |
| `summary.md` | Registro del saneamiento documental de Unidad 06 | No declara validaciones técnicas nuevas |
| `project/project-state.md` | Registro del incremento documental | Mantiene Unidad 08 congelada |

## Componentes retirados

Ninguno.

---

# Decisiones de diseño de la unidad

## D-06-01 - Helm empaqueta `platform-api`

### Decisión

El primer chart del curso empaqueta la aplicación evolutiva existente. No se crea una aplicación de ejemplo independiente.

### Motivo

El curso es acumulativo y Helm debe organizar recursos ya comprendidos por el alumno.

### Consecuencias

- el chart conserva el contrato funcional de Unidad 05;
- la lectura de templates se hace sobre recursos conocidos;
- Terraform y GitOps posteriores reutilizan el mismo paquete.

### Alternativas descartadas

- chart de ejemplo mínimo: rompe continuidad pedagógica;
- aplicación alternativa: contradice la arquitectura del repositorio.

## D-06-02 - Parametrización con criterio

### Decisión

Se parametrizan valores con variabilidad real o valor pedagógico: imagen, réplicas, Ingress, configuración visible, Secret ficticio, PVC, resources, rollout, probes, scheduling y PDB.

### Motivo

Un chart útil no convierte todo el YAML en values. Expone diferencias legítimas y mantiene fijo lo que forma parte del contrato del recurso.

### Consecuencias

- el alumno puede distinguir configuración de estructura;
- se reduce riesgo de values excesivamente frágiles;
- la referencia debe explicar cuándo no parametrizar.

### Alternativas descartadas

- parametrizar cada campo: aumenta complejidad sin criterio;
- mantener manifiestos planos: no introduce el aprendizaje de Helm.

## D-06-03 - Referencia conforme al contrato documental

### Decisión

`tutorial/06-helm-packaging/student-reference.md` sigue `playbooks/student-reference-template.md` y no un índice propio por módulos.

### Motivo

La fase 4 corrige precisamente la contradicción previa: la referencia no puede contener diagnóstico de laboratorio ni una estructura divergente del contrato cerrado.

### Consecuencias

- los errores de modelo mental quedan en la referencia;
- el diagnóstico operativo queda en `student-notes.md`;
- la cobertura avanzada de Helm se conserva dentro de las secciones canónicas.

### Alternativas descartadas

- mantener el molde por módulos: contradice el contrato documental;
- duplicar diagnóstico en referencia y notas: incumple la frontera global.

## D-06-04 - Terraform queda diferido como ejecución

### Decisión

La referencia puede explicar la frontera conceptual con Terraform, pero la Unidad 06 no crea archivos Terraform ni gestiona releases desde Terraform.

### Motivo

Terraform pertenece a la Unidad 07 y necesita un chart funcional como entrada.

### Consecuencias

- `helm_release`, `templatefile()` y `set_sensitive` pueden aparecer solo como continuidad;
- no se ejecuta ninguna validación Terraform en Unidad 06;
- la Unidad 07 conserva la responsabilidad de IaC.

### Alternativas descartadas

- crear Terraform en Unidad 06: anticipa la unidad siguiente;
- omitir la frontera: dificulta entender el paso a Unidad 07.

## D-06-05 - Renderizado antes de instalación

### Decisión

El alumno debe inspeccionar YAML renderizado antes de instalar o actualizar el release.

### Motivo

Helm no debe tratarse como caja negra. El renderizado muestra qué Kubernetes recibirá realmente el API server.

### Consecuencias

- `helm template` y dry-run son parte central del flujo;
- los errores de template se separan de los errores de Kubernetes;
- el laboratorio conserva comandos de inspección del release.

### Alternativas descartadas

- instalar directamente sin renderizar: reduce capacidad de diagnóstico;
- usar solo `helm lint`: no basta para validar el manifiesto final.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/06-helm-packaging/README.md
```

Debe actuar como puerta de entrada de la unidad y remitir a:

- `tutorial/06-helm-packaging/student-notes.md` para la guía de aprendizaje;
- `tutorial/06-helm-packaging/student-reference.md` para errores de modelo mental, criterios y profundidad profesional;
- `labs/06-helm-packaging/README.md` para pasos ejecutables.

## Notas del alumno

Ruta:

```text
tutorial/06-helm-packaging/student-notes.md
```

Debe explicar el laboratorio y diagnosticar fallos operativos: renderizado inválido, YAML rechazado, Service sin endpoints y upgrade roto.

Debe enlazar a `student-reference.md` para errores conceptuales sobre Helm, parametrización, values, releases, secretos y frontera con Terraform.

## Referencia del alumno

Ruta:

```text
tutorial/06-helm-packaging/student-reference.md
```

Crear este archivo siempre. Debe seguir `playbooks/student-reference-template.md` y contener las nueve secciones canónicas en orden.

Debe cubrir:

- panorama de Helm frente a Kubernetes, Terraform, CI/CD y GitOps;
- profundidad suficiente para leer el chart real de `platform-api`;
- criterios de parametrización, values, helpers, `--set`, subcharts, umbrella charts, hooks, `helm test`, repositorios y rollback;
- prácticas profesionales que sustituyen las simplificaciones del laboratorio;
- anclaje explícito de elementos no practicados hacia unidades futuras o declaración fuera del itinerario.

No debe incluir tablas de diagnóstico operativo del laboratorio.

## Notas del instructor

Ruta:

```text
tutorial/06-helm-packaging/instructor-notes.md
```

El saneamiento de fase 4 no modifica este archivo salvo instrucción explícita.

## Resumen

Ruta:

```text
tutorial/06-helm-packaging/summary.md
```

Debe registrar la actualización documental de fase 4, distinguirla de las validaciones funcionales históricas y no declarar validaciones nuevas.

## Laboratorio

Ruta:

```text
labs/06-helm-packaging/
```

El laboratorio no se modifica en fase 4.

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

para registrar el saneamiento documental de Unidad 06 y mantener congelada la Unidad 08.

---

# Estructura prevista del laboratorio

La estructura existente se conserva:

```text
labs/06-helm-packaging/
├── README.md
├── chart/
│   └── platform-api/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-local.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── namespace.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── pvc.yaml
│           ├── pdb.yaml
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
└── validation/
    ├── adopt-existing-resources.sh
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/06-helm-packaging/README.md` | Secuencia operativa del laboratorio |
| `labs/06-helm-packaging/chart/platform-api/Chart.yaml` | Metadatos del chart |
| `labs/06-helm-packaging/chart/platform-api/values.yaml` | Defaults del chart |
| `labs/06-helm-packaging/chart/platform-api/values-local.yaml` | Overrides locales de MicroK8s |
| `labs/06-helm-packaging/chart/platform-api/templates/` | Templates que renderizan recursos Kubernetes |
| `labs/06-helm-packaging/chart/platform-api/templates/_helpers.tpl` | Helpers de nombres, labels y selectors |
| `labs/06-helm-packaging/validation/adopt-existing-resources.sh` | Adopción de recursos heredados por metadata Helm |
| `labs/06-helm-packaging/validation/validate.sh` | Validación existente de chart, release y recursos |

---

# Flujo pedagógico obligatorio

La unidad sigue este orden:

1. problema real: varios manifiestos acumulados empiezan a ser difíciles de instalar y parametrizar;
2. por qué ahora: el alumno ya comprende los recursos Kubernetes que Helm empaquetará;
3. modelo mental: chart, template, values, renderizado y release;
4. lectura de artefactos: `Chart.yaml`, values, templates y helpers;
5. decisiones de diseño: qué parametrizar y qué mantener fijo;
6. observación: renderizar antes de instalar;
7. implementación en laboratorio: adopción, install, upgrade, inspección y rollback;
8. validación: Helm, Kubernetes y script existente;
9. diagnóstico: fallos operativos en `student-notes.md`;
10. consolidación: errores de modelo mental y práctica profesional en `student-reference.md`;
11. continuidad: Terraform en Unidad 07.

Este orden evita saltar desde definiciones de Helm a comandos sin explicar primero qué problema resuelve el empaquetado.

---

# Procedimientos obligatorios

## Preparación

- comprobar entorno local y salida de Unidad 05 según el laboratorio existente;
- revisar que el chart local existe en fase 4;
- confirmar que no se modificarán laboratorios ni validaciones durante saneamiento.

## Implementación

- en la generación histórica, convertir los manifiestos de Unidad 05 en templates Helm;
- en fase 4, regenerar el contrato documental y los documentos del alumno necesarios.

## Validación

- conservar las validaciones históricas registradas en `summary.md`;
- durante fase 4, ejecutar solo comprobaciones documentales o estáticas que no desplieguen ni modifiquen el clúster.

## Diagnóstico

- documentar fallos de laboratorio solo en `student-notes.md` y `labs/06-helm-packaging/README.md`;
- documentar errores conceptuales solo en `student-reference.md`.

## Recuperación

- mantener rollback Helm y reinstalación del estado versionado como recuperación operativa en el laboratorio;
- no usar la referencia como runbook.

## Limpieza

- no borrar el PVC como limpieza normal;
- no añadir nuevas operaciones destructivas en fase 4.

---

# Validaciones obligatorias

## Validaciones estáticas

| Validación | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis Bash | `bash -n labs/06-helm-packaging/validation/validate.sh` | Sin errores |
| Sintaxis Bash de adopción | `bash -n labs/06-helm-packaging/validation/adopt-existing-resources.sh` | Sin errores |
| Helm lint | `helm lint labs/06-helm-packaging/chart/platform-api` | 0 charts failed |
| Renderizado Helm | `helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml` | Manifiestos renderizados |
| Dry-run cliente | `helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml | kubectl apply --dry-run=client -f -` | Recursos aceptados por cliente |

## Validaciones funcionales

| Validación | Procedimiento | Resultado esperado |
|---|---|---|
| Instalación o upgrade | `helm upgrade --install platform-api-local ...` | Release `deployed` |
| Rollout | `kubectl -n platform-training rollout status deployment/platform-api` | Deployment disponible |
| Validación de unidad | `bash labs/06-helm-packaging/validation/validate.sh` | 0 fallos y 0 avisos |
| Rollback | `helm rollback platform-api-local <revision> --namespace platform-training` | Release vuelve a una revisión anterior y Deployment queda disponible |

## Validaciones de continuidad

Comprobar que:

- el chart de Unidad 06 sigue disponible para Unidad 07;
- `platform-api`, `platform-training` y `platform-api-local` conservan sus nombres;
- las rutas documentadas existen;
- el laboratorio no borra `platform-api-data`;
- no se crean `.tf`, `.tfvars` ni módulos Terraform en Unidad 06.

## Validaciones no ejecutables en el entorno de generación

En la fase 4 de saneamiento documental no se ejecutan validaciones funcionales nuevas. Las validaciones históricas permanecen registradas en `summary.md` y `project/project-state.md`.

---

# Escenarios de error obligatorios

| Escenario | Síntoma | Diagnóstico | Recuperación |
|---|---|---|---|
| Template inválido | `helm template` falla | Revisar sintaxis Go template, contexto, `quote`, `toYaml`, `nindent` y espacios | Corregir template y volver a renderizar |
| YAML rechazado por Kubernetes | Dry-run cliente falla | Revisar API, kind, spec y campos renderizados | Ajustar template o values sin saltar la validación |
| Service sin endpoints | HTTP falla o EndpointSlice vacío | Revisar labels y selectors renderizados | Corregir helpers o values de labels |
| Upgrade rompe la aplicación | Rollout no progresa o respuesta HTTP incorrecta | Revisar `helm history`, manifiesto renderizado y eventos Kubernetes | `helm rollback` a revisión válida y reinstalar estado versionado |

Estos escenarios pertenecen a `student-notes.md` y al README del laboratorio. `student-reference.md` debe cubrir errores de modelo mental, no runbooks de recuperación.

---

# Requisitos de seguridad

## Datos sensibles

- usar solo Secrets ficticios de laboratorio;
- no guardar credenciales reales en `values.yaml`, `values-local.yaml`, historial de shell ni ejemplos;
- explicar que values y release history no son un sistema de secret management productivo;
- mantener fuera de alcance External Secrets, SOPS, Sealed Secrets, Vault y secret managers cloud salvo como criterio conceptual.

## Privilegios

- Helm y `kubectl` requieren permisos suficientes sobre `platform-training`;
- el script de adopción añade metadata Helm a recursos existentes;
- no se requieren roles cloud;
- no se añaden permisos nuevos en fase 4.

## Operaciones destructivas

| Operación | Advertencia | Alcance | Recuperación | Confirmación requerida |
|---|---|---|---|---|
| `helm uninstall platform-api-local` | Puede retirar recursos del release y dejar continuidad rota | Release Helm local | Reinstalar con `helm upgrade --install` | Sí, operación manual |
| Borrado de PVC | No es limpieza normal y puede perder datos del laboratorio | `platform-api-data` | Restaurar solo si existe backup o recrear dato de laboratorio | Sí, fuera del flujo normal |

---

# Requisitos de portabilidad

## Kubernetes estándar

- Deployment, Service, ConfigMap, Secret, PVC, Ingress y PDB son APIs estándar o extensiones Kubernetes habituales;
- labels, selectors, probes, resources y rollout siguen siendo decisiones Kubernetes aunque se rendericen con Helm.

## Específico de MicroK8s

- `values-local.yaml` refleja supuestos locales;
- `microk8s-hostpath` es almacenamiento de laboratorio;
- Ingress local usa la configuración disponible en MicroK8s.

## Específico de AKS

- no aplica en esta unidad;
- values de cloud deberán ajustar StorageClass, Ingress Controller, certificados, identidad y DNS en unidades posteriores.

## Específico de EKS

- no aplica en esta unidad;
- values de cloud deberán ajustar StorageClass, Ingress Controller, certificados, identidad y DNS en unidades posteriores.

## Estrategia de desacoplamiento

- separar defaults del chart y overrides locales;
- centralizar nombres y labels en helpers;
- no acoplar templates a un único entorno cuando pueda expresarse como values;
- documentar las diferencias locales en la referencia, no esconderlas en el laboratorio.

---

# Restricciones de generación

La IA no debe:

- modificar `labs/06-helm-packaging/` durante la fase 4;
- crear Unidad 08;
- ejecutar validaciones funcionales nuevas;
- crear módulos Terraform;
- crear, modificar o ejecutar `helm_release` en Unidad 06;
- introducir secretos reales;
- publicar charts en repositorios remotos u OCI;
- añadir subcharts, hooks o `helm test` ejecutables;
- instalar Tekton, Argo CD, observabilidad avanzada, KEDA ni recursos cloud;
- sustituir `platform-api`;
- cambiar `platform-training`;
- borrar PVCs o documentar su borrado como limpieza normal.

La IA sí puede:

- regenerar este playbook;
- regenerar `tutorial/06-helm-packaging/student-reference.md`;
- ajustar `README.md`, `student-notes.md` y `summary.md`;
- actualizar `project/project-state.md`;
- actualizar `project/content-gap-register.md` solo si se cierra o ajusta una laguna.

---

# Criterios de aceptación

La unidad se considerará saneada documentalmente cuando:

- [ ] `playbooks/units/06-helm-packaging.md` esté regenerado contra el contrato vigente;
- [ ] `tutorial/06-helm-packaging/student-reference.md` siga las nueve secciones canónicas de `playbooks/student-reference-template.md`;
- [ ] `README.md` enlace a notas, referencia y laboratorio sin desarrollar contenido que pertenece a la referencia;
- [ ] `student-notes.md` conserve diagnóstico operativo y remita errores conceptuales a la referencia;
- [ ] cada exclusión declarada en `student-notes.md` esté cubierta, anclada con número de unidad o declarada fuera del itinerario en `student-reference.md`;
- [ ] ningún contenido esté duplicado entre `student-notes.md` y `student-reference.md`;
- [ ] el diagnóstico de fallos del laboratorio esté solo en `student-notes.md` y los errores de concepto solo en `student-reference.md`;
- [ ] la referencia nombre las simplificaciones de laboratorio y la alternativa profesional;
- [ ] `project/coverage-map.md` haya sido usado solo como checklist de cobertura;
- [ ] `summary.md` registre el saneamiento sin declarar validaciones funcionales nuevas;
- [ ] `project/project-state.md` refleje el estado real y mantenga Unidad 08 congelada;
- [ ] no se hayan modificado labs, chart Helm ni validaciones;
- [ ] no existan secretos reales;
- [ ] no existan contradicciones abiertas.

---

# Estado final esperado

## Plataforma

- sin cambios técnicos por fase 4;
- MicroK8s, Kubernetes y Helm conservan el estado histórico registrado.

## Aplicación

- `platform-api` se conserva como aplicación evolutiva;
- namespace `platform-training` se conserva;
- release `platform-api-local` sigue siendo el nombre del release local documentado.

## Automatización

- chart Helm local conservado en `labs/06-helm-packaging/chart/platform-api/`;
- Terraform continúa perteneciendo a Unidad 07.

## Seguridad

- Secrets ficticios de laboratorio;
- sin credenciales reales versionadas;
- sin nuevos permisos ni operaciones destructivas.

## Artefactos principales

```text
playbooks/units/06-helm-packaging.md
tutorial/06-helm-packaging/README.md
tutorial/06-helm-packaging/student-notes.md
tutorial/06-helm-packaging/student-reference.md
tutorial/06-helm-packaging/summary.md
project/project-state.md
```

---

# Información obligatoria para el summary

El `summary.md` deberá destacar:

- que la Unidad 06 fue saneada documentalmente en fase 4;
- que el playbook fue regenerado contra el contrato vigente;
- que `student-reference.md` fue regenerado con estructura canónica;
- que README y notas fueron ajustados para respetar la frontera entre notas y referencia;
- que no se modificaron laboratorios, chart Helm ni validaciones;
- que no se ejecutaron validaciones funcionales nuevas;
- que Unidad 07 sigue reutilizando el chart y que la congelación histórica de Unidad 08 quedó cerrada antes de generar su playbook.
