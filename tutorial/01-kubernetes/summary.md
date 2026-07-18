# Summary - Unidad 01

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 01 - Fundamentos operativos y primera aplicacion |
| Identificador | `01-kubernetes` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada y aprobada con limitaciones |
| Fecha de cierre o actualizacion | 2026-07-18 |
| Revision pedagogica del usuario | Aprobada; hardening pedagogico global inicial aplicado posteriormente y aceptado como cambio minimo |

## Resumen ejecutivo

La Unidad 01 define la primera aplicacion evolutiva del curso, `platform-api`, y crea sus primeros manifiestos Kubernetes declarativos. La solucion queda modelada con un namespace funcional unico, un Deployment y un Service `ClusterIP`.

La unidad incorpora el primer laboratorio funcional en `labs/01-kubernetes/`, con rutas `starter/`, `solution/` y una validacion no destructiva. Los manifiestos de `solution/` son la base que debera reutilizar la Unidad 02 para incorporar configuracion, secretos de laboratorio, probes y recursos.

Las validaciones estaticas y funcionales principales se ejecutaron sobre los artefactos generados y contra el MicroK8s local. La prueba HTTP mediante `port-forward` devolvio `HTTP/1.1 200 OK`.

El contenido queda generado, tecnicamente validado y aprobado por el usuario. El usuario ha observado que el nivel de entrada es exigente y que la unidad esta mas orientada a explicar el laboratorio que a proporcionar una vision amplia del tema tratado. Esta observacion se registra como deuda para una futura sesion de hardening pedagogico global, preferiblemente cuando haya varias unidades generadas y pueda revisarse la progresion completa.

El 2026-07-18 se aplico un hardening pedagogico global inicial sobre la Unidad 01. El tutorial refuerza ahora el problema que resuelve Kubernetes, el modelo declarativo, reconciliacion, control plane frente a nodos, abstracciones basicas, labels/selectors, diagnostico por diferencias entre estado deseado y observado, decisiones de diseno, errores de razonamiento y lectura guiada. No se modificaron manifiestos ni scripts. El usuario acepta estos cambios como minimo y registra que el nivel pedagogico de los README sigue siendo pobre para alumnos que todavia no conocen el tema.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Definir aplicacion evolutiva inicial | Alcanzado | `platform-api` registrada en `tutorial/01-kubernetes/README.md` y `labs/01-kubernetes/solution/deployment.yaml` |
| Crear namespace funcional | Alcanzado | `labs/01-kubernetes/solution/namespace.yaml` |
| Crear Deployment declarativo | Alcanzado | `labs/01-kubernetes/solution/deployment.yaml` |
| Crear Service declarativo | Alcanzado | `labs/01-kubernetes/solution/service.yaml` |
| Crear laboratorio reutilizable | Alcanzado | `labs/01-kubernetes/README.md`, `starter/`, `solution/`, `validation/validate.sh` |
| Documentar arquitectura, componentes y flujo de reconciliacion | Alcanzado | `tutorial/01-kubernetes/README.md` |
| Documentar diagnostico y recuperacion | Alcanzado | `tutorial/01-kubernetes/README.md`, `labs/01-kubernetes/README.md` |
| Añadir referencias para ampliar conceptos | Alcanzado | `tutorial/01-kubernetes/README.md` |
| Reforzar el tutorial como material pedagogico principal | Alcanzado documentalmente | `tutorial/01-kubernetes/README.md`, `tutorial/01-kubernetes/instructor-notes.md` |
| Validar funcionalmente en MicroK8s | Alcanzado | `bash labs/01-kubernetes/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` validados por el usuario en Unidad 00.
- `kubectl` `v1.35.6` configurado como cliente principal.
- Helm `v3.21.0+ge0878d4` y Terraform `1.15.7` instalados y validados como CLI, sin gestionar recursos del curso.

## Aplicacion

- No existia aplicacion evolutiva definida antes de la Unidad 01.
- No existian workloads funcionales del curso.

## Automatizacion

- No existian laboratorios funcionales en `labs/`.
- No existian charts Helm, releases Helm, modulos Terraform ni estado Terraform.

## Observabilidad

- Solo estaban disponibles las capacidades basicas de Kubernetes: estado, eventos y logs.
- No existia stack de Prometheus, Grafana, Loki, Tempo ni OpenTelemetry.

## Seguridad

- No existian Secrets de aplicacion.
- No se versionaron credenciales reales.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 00 | `tutorial/00-environment/summary.md` | Versiones, limitaciones y continuidad |
| Validacion integrada | `platform/environment/validation/validate-environment.sh` | Precondicion del entorno |
| Validacion MicroK8s | `platform/environment/microk8s/validate.sh` | Precondicion del cluster |
| Validacion herramientas | `platform/environment/tools/validate-tools.sh` | Baseline CLI heredada |
| Playbook Unidad 01 | `playbooks/units/01-kubernetes.md` | Alcance y restricciones |

## Cambios introducidos

## Capacidades incorporadas

- primera aplicacion evolutiva del curso;
- namespace funcional unico `platform-training`;
- manifiestos declarativos para `Namespace`, `Deployment` y `Service`;
- convenciones iniciales de labels y selectors;
- validacion no destructiva de estado esperado;
- diagnostico basico con estado, eventos y logs.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 01 | `tutorial/01-kubernetes/README.md` | Guia conceptual y practica del alumno |
| Student notes Unidad 01 | `tutorial/01-kubernetes/student-notes.md` | Material pedagogico profundo sobre cluster, API, Namespace, Pod, Deployment, ReplicaSet, Service, labels, selectors y reconciliacion |
| Instructor notes | `tutorial/01-kubernetes/instructor-notes.md` | Guia de imparticion y evaluacion |
| Summary Unidad 01 | `tutorial/01-kubernetes/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 01 | `labs/01-kubernetes/README.md` | Referencia operativa |
| Starter | `labs/01-kubernetes/starter/` | Punto de partida guiado |
| Solution | `labs/01-kubernetes/solution/` | Estado final reutilizable |
| Validacion | `labs/01-kubernetes/validation/validate.sh` | Comprobacion no destructiva |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Registrado cierre documental y tecnico de Unidad 01 segun validaciones disponibles |
| Flujo de trabajo | `project/how-to.md`, `playbooks/master.md` | Separada validacion tecnica de aprobacion del usuario |
| Hardening pedagogico inicial | `tutorial/01-kubernetes/README.md`, `tutorial/01-kubernetes/instructor-notes.md` | Refuerzo conceptual, decisiones de diseno, diagnostico razonado y lectura guiada |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/01-kubernetes/
├── README.md
├── student-notes.md
├── instructor-notes.md
└── summary.md

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

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Heredado de Unidad 00; no modificado por Unidad 01 | `platform/environment/README.md` |
| Kubernetes | Requerido para validar funcionalmente la unidad | `kubectl get nodes` |
| Helm | Disponible pero no usado para desplegar | `platform/environment/tools/validate-tools.sh` |
| Terraform | Disponible pero no usado para desplegar | `platform/environment/tools/validate-tools.sh` |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Definida como `platform-api` | `labs/01-kubernetes/solution/deployment.yaml` |
| Namespace | Declarado como `platform-training` | `labs/01-kubernetes/solution/namespace.yaml` |
| Deployment | Declarado con 2 replicas | `labs/01-kubernetes/solution/deployment.yaml` |
| Service | Declarado como `ClusterIP` | `labs/01-kubernetes/solution/service.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles | `labs/01-kubernetes/solution/` |
| Validacion de laboratorio | Disponible y ejecutable | `labs/01-kubernetes/validation/validate.sh` |
| Helm charts | No creados | Revision del repositorio |
| Terraform modules | No creados | Revision del repositorio |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `tutorial/01-kubernetes/README.md` |
| Eventos | Documentados | `tutorial/01-kubernetes/README.md` |
| Logs | Documentados y validados por script cuando el Deployment existe | `labs/01-kubernetes/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secrets reales | No usados | Revision de manifiestos |
| Namespace de aislamiento | Declarado | `labs/01-kubernetes/solution/namespace.yaml` |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | Si, declarado en manifiestos |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/01-kubernetes/solution/deployment.yaml` | 2 replicas disponibles tras despliegue |
| `replicaset` generado | `platform-training` | Generado por Deployment | Mantiene Pods del Deployment |
| Pods `platform-api` | `platform-training` | Generados por ReplicaSet | `Running` tras despliegue correcto |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable a Pods |
| Port-forward local | `http://127.0.0.1:8080/` durante la prueba manual | Validacion HTTP desde la maquina local |

## Configuracion y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMaps | No implementados | Diferido a Unidad 02 |
| Secrets | No implementados | Diferido a Unidad 02; no hay valores reales |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Kubernetes | `v1.35.6` heredado de Unidad 00 | `kubectl get nodes` aportado por el usuario |
| `kubectl` | `v1.35.6` heredado de Unidad 00 | `kubectl version --client` aportado por el usuario |
| Helm | `v3.21.0+ge0878d4` heredado de Unidad 00 | `helm version --short` |
| Terraform | `1.15.7` heredado de Unidad 00 | `terraform version` |

## Decisiones tomadas

## D-01-05 - Nombre y alcance de la aplicacion evolutiva

### Decision

La aplicacion evolutiva inicial se llama `platform-api`.

### Motivo

El nombre es neutro respecto a proveedor cloud y permite evolucionar hacia API, configuracion, ingreso, observabilidad, seguridad y escalado sin crear una aplicacion distinta por unidad.

### Consecuencias

- las unidades posteriores deben extender `platform-api` en lugar de reemplazarla sin justificacion;
- el namespace inicial asociado es `platform-training`;
- los labels `app.kubernetes.io/name=platform-api` y `app.kubernetes.io/instance=platform-api-local` son selectores base.

### Ambito

Registrada en `summary.md` y `project/project-state.md`.

## D-01-06 - Imagen HTTP inicial versionada

### Decision

La primera version usa `nginxinc/nginx-unprivileged:1.27.4-alpine`.

### Motivo

Permite validar HTTP y logs sin credenciales, sin privilegios de root dentro del contenedor, sin base de datos y sin componentes externos.

### Consecuencias

- la configuracion practica de contenido, probes y recursos queda diferida a Unidad 02;
- la disponibilidad real de la imagen debe validarse mediante despliegue o pull efectivo;
- si la imagen deja de estar disponible, debe sustituirse por otra imagen HTTP publica versionada y registrar el cambio.

### Ambito

Registrada en `summary.md` y `project/project-state.md`.

## D-01-07 - Service interno como primera exposicion

### Decision

La Unidad 01 usa un Service `ClusterIP` y valida acceso HTTP mediante `kubectl port-forward`.

### Motivo

Permite comprobar seleccion de Pods y conectividad sin introducir Ingress, Gateway API ni addons adicionales.

### Consecuencias

- no hay endpoint externo permanente;
- Ingress y Gateway API quedan diferidos a Unidad 03.

### Ambito

Especifica de la unidad.

## D-01-08 - Validacion pedagogica por el usuario y hardening global

### Decision

La IA puede generar contenido, ejecutar validaciones tecnicas y revisar coherencia documental, pero la aprobacion final del contenido formativo corresponde al usuario responsable del curso. La revision inicial del usuario identifica una deuda pedagogica: la unidad es exigente como entrada y esta demasiado enfocada en explicar el laboratorio.

### Motivo

La calidad pedagogica, el nivel de profundidad esperado y la adecuacion al estilo del itinerario requieren revision humana explicita. Resolver esta deuda sera mas eficaz en una sesion de hardening global cuando existan varias unidades y pueda analizarse la progresion completa.

### Consecuencias

- la Unidad 01 queda generada y tecnicamente validada;
- la Unidad 01 queda aprobada por el usuario;
- se permite continuar con el playbook de Unidad 02;
- queda abierta una deuda de hardening pedagogico global;
- futuras unidades deberan distinguir entre validacion tecnica, revision del usuario y aprobacion del contenido.

### Ambito

Registrada tambien en `project/how-to.md`, `playbooks/master.md` y `project/project-state.md`.

## Validaciones

## Validaciones ejecutadas

| Validacion | Comando o procedimiento | Resultado observado |
|---|---|---|
| Despliegue en orden explicito | `kubectl apply -f labs/01-kubernetes/solution/namespace.yaml -f labs/01-kubernetes/solution/deployment.yaml -f labs/01-kubernetes/solution/service.yaml` | Namespace sin cambios, Deployment creado, Service sin cambios |
| Validacion funcional del laboratorio | `bash labs/01-kubernetes/validation/validate.sh` | 0 fallos, 0 avisos; nodo `gmktecg2` Ready; Deployment 2/2; 2 Pods Running; Service con 2 endpoints; logs legibles |
| Validacion heredada Unidad 00 | `bash platform/environment/validation/validate-environment.sh` | Completada sin fallos bloqueantes |
| Prueba HTTP local | `kubectl -n platform-training port-forward service/platform-api 8080:80` y `curl -i http://127.0.0.1:8080/` | `HTTP/1.1 200 OK`, `Server: nginx/1.27.4` |

## Validaciones estaticas realizadas

| Validacion | Metodo | Resultado |
|---|---|---|
| Sintaxis Bash | `bash -n labs/01-kubernetes/validation/validate.sh` | Codigo de salida 0 |
| Sintaxis YAML cliente | `kubectl apply --dry-run=client -f labs/01-kubernetes/solution/` | Manifiestos aceptados por el cliente; `created (dry run)` |
| Ausencia de secretos reales | Revision de manifiestos | Sin tokens, passwords, claves privadas ni kubeconfigs |

## Validaciones no ejecutadas

| Validacion pendiente | Motivo | Responsable o momento |
|---|---|---|
| ShellCheck | `shellcheck` no esta disponible en este entorno | Ejecutar cuando la herramienta este instalada |
| Validacion Windows/WSL desde PowerShell | Esta sesion opera desde Ubuntu WSL, no desde el host Windows | Validacion por equipo al replicar el laboratorio |
| Hardening pedagogico global | Se difiere para revisar progresion, vision conceptual y referencias con varias unidades generadas | Sesion futura especifica |

## Limitaciones y deuda tecnica

| ID | Descripcion | Estado |
|---|---|---|
| L-01-01 | La imagen externa fue descargada y ejecutada correctamente en esta validacion; sigue existiendo riesgo futuro de disponibilidad externa o rate limit | Mitigada |
| L-01-02 | La aplicacion aun no tiene configuracion externa, secretos de laboratorio, probes ni recursos | Diferido a Unidad 02 |
| L-01-03 | El Service es interno; no hay ingreso permanente | Diferido a Unidad 03 |
| L-01-04 | El contenido tiene un nivel de entrada exigente y prioriza la explicacion del laboratorio sobre una vision conceptual amplia | Diferido a hardening pedagogico global |

## Elementos que debe reutilizar la Unidad 02

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Manifiestos finales | `labs/01-kubernetes/solution/` | Base para incorporar ConfigMaps, Secrets, probes y recursos |
| Aplicacion | `platform-api` | Mantener laboratorio evolutivo unico |
| Namespace | `platform-training` | Aislamiento funcional inicial |
| Labels base | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` | Selectors y continuidad de Service |
| Validacion | `labs/01-kubernetes/validation/validate.sh` | Puede ampliarse tras incorporar nuevas capacidades |

## Siguiente incremento recomendado

Generar el playbook de la Unidad 02 - Configuracion, secretos y ciclo de vida, conservando la deuda de hardening pedagogico global registrada.

```text
Generar el playbook de la Unidad 02 - Configuracion, secretos y ciclo de vida
```
