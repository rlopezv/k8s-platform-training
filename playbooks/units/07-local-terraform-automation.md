# Playbook de la Unidad 07 - Automatización local con Terraform

## Identificación

### Unidad

```text
07 - Automatización local con Terraform
```

### Identificador

```text
07-local-terraform-automation
```

### Fase del roadmap

```text
Fase 3 - Empaquetado e infraestructura como código
```

### Estado del playbook

```text
Aprobado; regenerado contra el contrato documental en fase 4
```

### Propietario lógico

```text
Empaquetado e infraestructura como código
```

---

# Propósito de la unidad

La Unidad 07 introduce Terraform como capa declarativa local para gestionar el release Helm de `platform-api`. La unidad parte del chart funcional de la Unidad 06 y convierte una operación manual con `helm upgrade --install` en una configuración Terraform con providers, variables, plan, apply, outputs y state local.

Terraform aparece después de Helm porque no sustituye al paquete. Kubernetes ejecuta recursos, Helm empaqueta y renderiza `platform-api`, y Terraform declara la existencia del release `platform-api-local` y conserva estado sobre esa gestión. La unidad prepara la automatización posterior con CI/CD y abre la frontera de propiedad que será crítica cuando GitOps aparezca en la Unidad 09.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que ya han usado `kubectl` y Helm en el curso, pero que todavía no dominan Terraform, HCL, providers, state, variables, outputs, DAG, lifecycle ni la relación entre Terraform, Kubernetes, Helm y GitOps.

Se explican desde cero:

- qué problema resuelve Terraform frente a comandos imperativos;
- qué representan Terraform Core, HCL, provider, resource, data source, variable, output y state;
- qué ocurre en `terraform init`, `terraform plan`, `terraform apply`, `terraform destroy` y `terraform import`;
- cómo Terraform construye un grafo de dependencias;
- por qué el state no es un caché prescindible ni un archivo seguro por defecto;
- cómo se gestionan variables tipadas, `terraform.tfvars.example`, overrides y outputs;
- cómo se usa el provider Helm para gestionar un `helm_release`;
- cómo se usa el provider Kubernetes de forma no destructiva para observar estado;
- cómo reconocer drift básico entre Terraform state, Helm release y recursos Kubernetes.

Se retoman de unidades anteriores:

- `platform-api` como aplicación evolutiva;
- namespace funcional `platform-training`;
- chart Helm local `labs/06-helm-packaging/chart/platform-api/`;
- release local `platform-api-local`;
- separación entre ConfigMap, Secret ficticio, probes, resources, Service, Ingress, PVC, PDB, scheduling y rollout;
- validación con Helm, `kubectl` y scripts heredados.

Se mencionan solo para continuidad:

- backends remotos reales y locking productivo;
- módulos Terraform reutilizables de producción;
- creación de clústeres AKS o EKS, redes, node pools, IAM, registries y storage cloud;
- ejecución de Terraform desde CI/CD;
- GitOps con Argo CD y propiedad continua del estado deseado;
- gestión productiva de secretos.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que Terraform reemplaza Helm o Kubernetes;
- tratar `terraform.tfstate` como prescindible o versionable sin consecuencias;
- ejecutar `terraform apply` sin leer el plan;
- asumir que `set_sensitive` elimina secretos del state;
- usar `terraform destroy` como limpieza rutinaria;
- pensar que `force-unlock`, `state rm` o `import` son flujos normales;
- creer que Terraform y GitOps pueden reconciliar indefinidamente el mismo release sin acuerdo de propiedad.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- inicializar un proyecto Terraform local que gestiona el release Helm de `platform-api`;
- interpretar `init`, `plan`, `apply`, `destroy`, `import` y `state` en el contexto del laboratorio;
- configurar providers Helm y Kubernetes contra el contexto local existente;
- declarar `helm_release.platform_api` reutilizando el chart de Unidad 06;
- parametrizar el despliegue con variables tipadas, validaciones y un `terraform.tfvars.example` inocuo;
- explicar la jerarquía de valores de Terraform sin convertir `-var` en mecanismo habitual;
- exponer outputs no sensibles útiles para una automatización posterior;
- validar la coherencia entre Terraform, Helm y Kubernetes;
- diagnosticar drift básico sin borrar recursos persistentes;
- justificar qué responsabilidad corresponde a Terraform, cuál a Helm, cuál a Kubernetes y cuál quedará para GitOps.

---

# Alcance

## Incluido

- reutilización de `labs/06-helm-packaging/chart/platform-api/`;
- proyecto Terraform local en `labs/07-local-terraform-automation/terraform/`;
- providers Helm y Kubernetes con versiones acotadas;
- backend local de Terraform;
- `helm_release.platform_api` como recurso principal;
- variables tipadas, defaults, validaciones y `terraform.tfvars.example`;
- `templatefile()` para renderizar valores Helm desde Terraform;
- ejemplo de `set_sensitive` con secreto ficticio de laboratorio;
- outputs no sensibles;
- import controlado de un release existente, cuando proceda;
- explicación de drift básico entre state, Helm y Kubernetes;
- referencia del alumno conforme a `playbooks/student-reference-template.md`;
- cierre documental de `GAP-010`, declarando el límite de propiedad de Terraform y anclando la resolución operativa de Terraform frente a Argo CD en la Unidad 09.

## Excluido

- creación de recursos cloud reales;
- backends remotos reales en AWS S3, Azure Blob, HCP Terraform o Consul;
- bloqueo real de state con DynamoDB, Consul u otros mecanismos gestionados;
- aprovisionamiento de AKS, EKS, VPC, VNet, IAM, node groups, registries o storage cloud;
- CI/CD, Tekton, Argo CD o GitOps;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automático;
- gestores productivos de secretos como Vault, External Secrets Operator, SOPS o Sealed Secrets;
- publicación de charts en repositorios remotos u OCI;
- módulos Terraform productivos;
- sustitución de `platform-api`;
- cambio del namespace funcional `platform-training`;
- introducción de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Tekton y ejecución de plan/apply desde pipeline | Unidad 08 | Requiere primero un flujo Terraform local estable |
| Jobs y CronJobs | Unidad 08 | La Unidad 08 los introduce de forma natural para tareas de CI/CD |
| Argo CD, GitOps y resolución de propiedad continua | Unidad 09 | `GAP-010` se declara en la 07 y la 09 resuelve el reparto operativo |
| Gestión real de secretos en GitOps | Unidad 09 | Pertenece al flujo de secreto real sin guardarlo en Git |
| Promoción formal entre entornos | Unidad 10 | Requiere convenciones IaC, CI/CD y GitOps previas |
| Progressive delivery | Unidad 10 como referencia, práctica posterior | Requiere observabilidad y criterios de SLI/SLO |
| Backends remotos productivos | Unidades cloud | Requieren cuenta cloud, permisos, coste y gobierno |
| AKS y EKS | Unidades 19-25 | Pertenecen a plataformas gestionadas |
| Desacoplamiento formal de MicroK8s | Unidad 19 | Será el puente entre laboratorio local y cloud |
| Secret management productivo | Unidades 09 y 16 | Requiere herramientas, políticas e identidad |
| `topologySpreadConstraints` | Unidad 18 | Encaja con escalado, distribución y capacidad |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar el laboratorio: componentes del proyecto Terraform, flujo `init -> plan -> apply`, comprobaciones, diagnóstico de fallos operativos y recuperación básica.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: arquitectura de Terraform Core, state, jerarquía de variables, expresiones, módulos, backends remotos, secretos en state, lifecycle, operaciones de emergencia y frontera de propiedad entre Terraform y GitOps.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta.

## Laguna asignada

| ID | Tratamiento en esta unidad | Cierre esperado |
|---|---|---|
| `GAP-010` | La referencia declara el conflicto de propiedad entre `helm_release.platform_api` y una futura reconciliación GitOps del mismo release; fija que Terraform no debe competir indefinidamente con Argo CD sobre el mismo objeto | Cierre documental en `tutorial/07-local-terraform-automation/student-reference.md` y rastro en `summary.md`; la Unidad 09 resolverá el patrón operativo definitivo al introducir Argo CD |

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 07 |
|---|---|
| Panorama | Situar Terraform frente a Kubernetes, Helm, CI/CD y GitOps |
| Profundidad | Explicar Terraform Core, providers, state, plan, import, variables y `helm_release` hasta poder leer los `.tf` del laboratorio |
| Criterio | Decidir cuándo usar Terraform para gestionar un release Helm y cuándo delegar en GitOps |
| Práctica | Nombrar distancias con producción: backend local, state sensible, secretos ficticios, MicroK8s, ausencia de locking y ausencia de cloud |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| Backend local | State no compartido, sin locking real y dependiente de la máquina | Backend remoto con versionado, control de acceso y bloqueo |
| Secreto ficticio con `set_sensitive` | El valor puede persistir en state y en historiales según provider/configuración | Secret manager, variables sensibles protegidas, backend cifrado y rotación |
| Kubeconfig local de MicroK8s | Acopla la ejecución a una máquina y contexto concretos | Identidad dinámica o credenciales gestionadas desde la plataforma de ejecución |
| Un único clúster local | No demuestra HA, promoción ni aislamiento por entorno | Estructura por entornos, cuentas/proyectos separados y controles de acceso |
| `terraform destroy` disponible | Puede desinstalar el release y afectar recursos persistentes | Runbooks de destrucción, `prevent_destroy` donde aplique, backups y aprobación explícita |
| Terraform gestiona el release antes de GitOps | Dos reconciliadores podrían reclamar el mismo recurso | Transferencia o reparto explícito de ownership antes de introducir Argo CD |

## Uso de `project/coverage-map.md`

La sección de Unidad 07 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

- diseño base de Terraform y providers;
- despliegue con `helm_release` e idempotencia;
- variables complejas, validaciones, `for_each` y `dynamic` como referencia conceptual;
- gestión de state, secretos, backends y recuperación;
- outputs y lifecycle.

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
14. `playbooks/units/06-helm-packaging.md`;
15. `tutorial/06-helm-packaging/summary.md`;
16. este playbook;
17. `project/coverage-map.md`, solo sección de Unidad 07 y solo como checklist de cobertura;
18. `tutorial/07-local-terraform-automation/README.md`;
19. `tutorial/07-local-terraform-automation/student-notes.md`;
20. `tutorial/07-local-terraform-automation/student-reference.md`;
21. `tutorial/07-local-terraform-automation/instructor-notes.md`;
22. `tutorial/07-local-terraform-automation/summary.md`;
23. `labs/07-local-terraform-automation/README.md`;
24. `labs/07-local-terraform-automation/terraform/`;
25. `labs/07-local-terraform-automation/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 06 existe y deja `tutorial/06-helm-packaging/summary.md` y `labs/06-helm-packaging/chart/platform-api/` como base de entrada.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- plan de saneamiento vigente en `project/documentation-cleanup-plan.md`;
- summary de la Unidad 06;
- artefactos actuales de la Unidad 07.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| MicroK8s | Instalado y operativo según estado ya registrado | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` según estado ya registrado | `kubectl get nodes` |
| `kubectl` | Cliente operativo | `kubectl version --client` |
| Helm | CLI disponible y chart de Unidad 06 validable | `helm version --short` y `helm lint labs/06-helm-packaging/chart/platform-api` |
| Terraform | CLI disponible | `terraform version` |
| Chart `platform-api` | Disponible | `test -f labs/06-helm-packaging/chart/platform-api/Chart.yaml` |
| Proyecto Terraform Unidad 07 | Existente | `test -f labs/07-local-terraform-automation/terraform/main.tf` |

Durante la fase 4 de saneamiento documental no se declaran nuevas validaciones técnicas como ejecutadas.

## Dependencias pedagógicas

El alumno debe haber completado o dominar:

- Unidad 00: entorno local y herramientas;
- Unidad 01: Deployment, ReplicaSet, Pod, Service, labels y selectors;
- Unidad 02: ConfigMap, Secret ficticio, probes, requests y limits;
- Unidad 03: Service, EndpointSlice e Ingress;
- Unidad 04: PVC, PV, StorageClass y volumen montado;
- Unidad 05: scheduling, rollout, PDB, réplicas y disponibilidad;
- Unidad 06: chart, templates, values, release y rollback Helm.

## Dependencias del laboratorio

```text
tutorial/06-helm-packaging/summary.md
labs/06-helm-packaging/chart/platform-api/
labs/06-helm-packaging/validation/validate.sh
labs/07-local-terraform-automation/README.md
labs/07-local-terraform-automation/terraform/
labs/07-local-terraform-automation/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` empaquetada como chart Helm local y de un proyecto Terraform local ya existente en la rama actual del saneamiento. El laboratorio técnico de la Unidad 07 no se modifica en esta fase: solo se regeneran el playbook y los documentos del alumno necesarios para cumplir el contrato documental.

Estado verificable esperado:

- MicroK8s, Helm y Terraform figuran como disponibles en `project/project-state.md`;
- `labs/06-helm-packaging/chart/platform-api/` existe;
- `labs/07-local-terraform-automation/terraform/main.tf` declara `helm_release.platform_api`;
- `terraform.tfstate`, `.terraform/`, planes binarios y `terraform.tfvars` locales no están versionados;
- los secretos versionados son ficticios;
- `platform-api-data` no se borra en el flujo normal.

## Validación del estado inicial

Comprobaciones documentales permitidas en la fase 4:

```bash
test -f labs/07-local-terraform-automation/terraform/main.tf
test -f tutorial/07-local-terraform-automation/student-reference.md
test -f project/content-gap-register.md
```

Las validaciones funcionales heredadas quedan como estado histórico registrado en `tutorial/07-local-terraform-automation/summary.md`, no como validación nueva de este saneamiento.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 06 | `tutorial/06-helm-packaging/summary.md` | Continuidad técnica y pedagógica |
| Chart Helm | `labs/06-helm-packaging/chart/platform-api/` | Paquete gestionado por Terraform |
| Proyecto Terraform | `labs/07-local-terraform-automation/terraform/` | Artefacto técnico ya validado que no se modifica |
| Laboratorio Unidad 07 | `labs/07-local-terraform-automation/README.md` | Fuente operativa actual |
| Validación Unidad 07 | `labs/07-local-terraform-automation/validation/validate.sh` | Validación existente, no modificada |
| Registro de lagunas | `project/content-gap-register.md` | Trazabilidad de `GAP-010` |

## Reglas de reutilización

- conservar `platform-api`;
- conservar `platform-training`;
- conservar `platform-api-local`;
- no duplicar el chart Helm;
- no convertir Terraform en motor de templates Kubernetes paralelo a Helm;
- no modificar laboratorios ni validaciones en fase 4;
- mantener Secrets ficticios y no introducir credenciales reales;
- no borrar el PVC como parte normal del flujo.

---

# Cambios previstos sobre la solución

## Componentes nuevos

Ninguno en fase 4. La unidad ya existe.

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| Playbook Unidad 07 | Regeneración contra `playbooks/unit-template.md` y contrato de `student-reference.md` | Sustituye el molde anterior por módulos y elimina la contradicción documental |
| `student-reference.md` | Regeneración completa contra `playbooks/student-reference-template.md` | Mantiene cobertura de Terraform y cierra `GAP-010` |
| `README.md` | Ajuste de enlaces, ortografía y frontera con referencia | Conserva función de puerta de entrada |
| `student-notes.md` | Ajuste de alcance y remisión de errores conceptuales | Conserva diagnóstico operativo del laboratorio |
| `summary.md` | Registro del saneamiento y cierre documental de `GAP-010` | No declara validaciones técnicas nuevas |
| `project/project-state.md` | Registro del incremento documental | Mantiene Unidad 08 congelada |
| `project/content-gap-register.md` | Estado de `GAP-010` | Refleja cierre documental de la laguna |

## Componentes retirados

Ninguno.

---

# Decisiones de diseño de la unidad

## D-07-01 - Terraform orquesta el release Helm existente

### Decisión

Terraform gestiona `helm_release.platform_api` y no reescribe templates Kubernetes.

### Motivo

La Unidad 06 ya definió Helm como paquete de `platform-api`. Terraform debe añadir plan, state, variables y outputs sin duplicar responsabilidades.

### Consecuencias

- el chart de Unidad 06 sigue siendo la fuente del YAML Kubernetes;
- Terraform observa y muta el release Helm, no cada recurso Kubernetes por separado;
- el alumno distingue Kubernetes, Helm y Terraform antes de CI/CD y GitOps.

### Alternativas descartadas

- manifiestos Kubernetes planos gestionados por Terraform: duplican el chart y rompen continuidad;
- crear un chart nuevo para Terraform: introduce una aplicación paralela innecesaria.

## D-07-02 - Backend local en el laboratorio

### Decisión

La unidad usa backend local y documenta backends remotos como práctica profesional, sin configurarlos.

### Motivo

Configurar backends reales exige cuentas, credenciales, locking, permisos y costes fuera del alcance local.

### Consecuencias

- el laboratorio es reproducible en MicroK8s;
- la referencia debe explicar por qué el backend local no es suficiente en equipos o producción.

### Alternativas descartadas

- backend remoto simulado: puede crear falsa seguridad;
- backend cloud real: anticipa unidades cloud.

## D-07-03 - Proyecto Terraform plano

### Decisión

La Unidad 07 no crea módulos locales ejecutables.

### Motivo

El objetivo pedagógico es ver con claridad providers, variables, `helm_release`, outputs y state antes de encapsularlos.

### Consecuencias

- los archivos `.tf` son más directos para el alumno;
- los módulos quedan como referencia conceptual y práctica futura.

### Alternativas descartadas

- módulo local inicial: ocultaría decisiones que aún son objeto de aprendizaje.

## D-07-04 - Secrets ficticios y state no versionado

### Decisión

Los valores sensibles son ficticios y los artefactos locales de state, `.terraform/`, planes y `tfvars` reales se ignoran.

### Motivo

Terraform puede persistir valores sensibles en state. El laboratorio debe enseñar el riesgo sin introducir credenciales reales.

### Consecuencias

- `set_sensitive` se explica como reducción de exposición en CLI, no como cifrado del state;
- la referencia debe explicar alternativas productivas.

### Alternativas descartadas

- secretos reales de prueba: prohibidos por seguridad;
- omitir secretos: perdería una simplificación importante del laboratorio.

## D-07-05 - `GAP-010` se cierra como frontera de propiedad

### Decisión

La Unidad 07 declara que Terraform puede gestionar el release Helm local, pero que no debe competir indefinidamente con Argo CD sobre el mismo release cuando GitOps aparezca en la Unidad 09.

### Motivo

La laguna formativa no requiere cambiar el laboratorio; requiere que el alumno vea el problema antes de introducir GitOps.

### Consecuencias

- `student-reference.md` cierra `GAP-010` en esta unidad;
- la Unidad 09 conserva el compromiso de resolver el patrón operativo definitivo entre Terraform y Argo CD.

### Alternativas descartadas

- dejar la pregunta para la Unidad 09 sin avisar antes: el alumno llegaría sin modelo de ownership;
- instalar Argo CD en la Unidad 07: viola el roadmap y las restricciones activas.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/07-local-terraform-automation/README.md
```

Debe actuar como puerta de entrada y contener:

1. problema real;
2. por qué Terraform aparece después de Helm;
3. objetivos;
4. conocimientos previos;
5. relación con la Unidad 06;
6. estado inicial;
7. mapa de aprendizaje;
8. cómo usar `student-notes.md`, `student-reference.md` y el README del laboratorio;
9. decisiones principales;
10. conclusión;
11. lectura guiada.

Puede nombrar errores de razonamiento y debe remitir su desarrollo a `student-reference.md`.

## Notas del alumno

Ruta:

```text
tutorial/07-local-terraform-automation/student-notes.md
```

Debe ser la guía de aprendizaje de la unidad y explicar:

- propósito;
- qué se va a cubrir y qué queda fuera;
- qué representa cada componente del laboratorio;
- qué se construye;
- cómo se relacionan Terraform, Helm y Kubernetes;
- qué ocurre al aplicar Terraform;
- cómo comprobar que funciona;
- diagnóstico de fallos típicos del laboratorio;
- qué recordar para la Unidad 08;
- fuentes de referencia.

El diagnóstico operativo pertenece aquí, no a `student-reference.md`.

## Referencia del alumno

Ruta:

```text
tutorial/07-local-terraform-automation/student-reference.md
```

Debe seguir exactamente la estructura canónica de `playbooks/student-reference-template.md`:

1. título con número de unidad;
2. propósito de la referencia;
3. relación con la unidad;
4. mapa conceptual;
5. conceptos y mecanismos;
6. criterios de decisión;
7. relación con el laboratorio;
8. errores frecuentes de modelo mental;
9. continuidad;
10. fuentes de referencia.

Debe declarar `GAP-010` en su propósito y cerrar la laguna mediante explicación de ownership Terraform/GitOps. No debe incluir tabla de diagnóstico de fallos de laboratorio.

## Laboratorio

Ruta:

```text
labs/07-local-terraform-automation/
```

No se modifica en fase 4. Conserva el flujo operativo ya validado.

## Notas del instructor

Ruta:

```text
tutorial/07-local-terraform-automation/instructor-notes.md
```

Pueden conservar errores y recuperación con enfoque de facilitación. No están sujetas a la regla de no duplicación entre notas y referencia.

## Resumen

Ruta:

```text
tutorial/07-local-terraform-automation/summary.md
```

Debe registrar:

- que el laboratorio existente no se modificó;
- que el playbook y la referencia se regeneraron contra el contrato documental;
- que `GAP-010` queda cerrado documentalmente en la referencia;
- que no se ejecutaron nuevas validaciones técnicas durante el saneamiento;
- que la aprobación pedagógica del saneamiento queda pendiente del usuario si no se aporta en la sesión.

---

# Validaciones requeridas para esta fase

## Validaciones documentales

- comprobar que `student-reference.md` sigue las nueve secciones canónicas y en orden;
- comprobar que `student-reference.md` declara `GAP-010`;
- comprobar que no hay tabla de diagnóstico de fallos de laboratorio en la referencia;
- comprobar que los fallos operativos permanecen en `student-notes.md` o `labs/README.md`;
- comprobar que las exclusiones de `student-notes.md` aparecen cubiertas, ancladas o declaradas fuera del itinerario;
- comprobar que las simplificaciones productivas aparecen razonadas en la referencia;
- comprobar que `project/coverage-map.md` queda cubierto sin copiar su estructura;
- revisar ortografía de la prosa modificada.

## Validaciones técnicas

No se ejecutan nuevas validaciones técnicas en fase 4. Las validaciones funcionales de la Unidad 07 permanecen como evidencia histórica registrada el 2026-07-20.

---

# Criterios de aceptación

La fase 4 de saneamiento para la Unidad 07 se considera lista para revisión cuando:

- `playbooks/units/07-local-terraform-automation.md` ya no contradice `playbooks/student-reference-template.md`;
- `tutorial/07-local-terraform-automation/student-reference.md` está regenerado con la estructura canónica;
- `tutorial/07-local-terraform-automation/student-reference.md` declara y cierra `GAP-010`;
- README y notas enlazan la referencia sin duplicar su contenido conceptual;
- `tutorial/07-local-terraform-automation/summary.md` registra el saneamiento y distingue validaciones históricas de validaciones no ejecutadas en esta fase;
- `project/project-state.md` refleja el incremento documental;
- `project/content-gap-register.md` refleja el cierre documental de `GAP-010`;
- no se modifican laboratorios, validaciones ni artefactos Terraform;
- la Unidad 08 continúa congelada.

---

# Continuidad esperada

La siguiente sesión del saneamiento debe continuar con la Unidad 06, según el orden fijado en `project/documentation-cleanup-plan.md`:

```text
07 (piloto) -> 06 -> 01 -> 00 -> 02 -> 03 -> 05 -> 04 documental -> TD-022 -> 04 funcional (TD-023)
```

La Unidad 08 no se genera hasta cerrar las fases 4 y 5 del saneamiento.
