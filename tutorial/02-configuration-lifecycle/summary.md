# Summary - Unidad 02

## Identificación

| Campo | Valor |
|---|---|
| Unidad | 02 - Configuración, secretos y ciclo de vida |
| Identificador | `02-configuration-lifecycle` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada con limitaciones |
| Fecha de cierre o actualización | 2026-07-27 |
| Revisión pedagógica del usuario | Unidad aprobada el 2026-07-18; saneamiento documental de fase 4 aprobado el 2026-07-27 |

## Resumen ejecutivo

La Unidad 02 evoluciona `platform-api` desde el Deployment mínimo de la Unidad 01 hacia un workload configurable y operable mediante recursos Kubernetes estándar.

La solución final queda en `labs/02-configuration-lifecycle/solution/` e incorpora ConfigMap, Secret de laboratorio con valores ficticios, variables de entorno, volumen de configuración, `startupProbe`, `readinessProbe`, `livenessProbe`, requests y limits iniciales.

El contenido y los artefactos han sido generados, aplicados y validados funcionalmente contra el MicroK8s local. El usuario revisó y aprobó la unidad el 2026-07-18.

El 2026-07-18 se aplicó un hardening pedagógico global inicial sobre la Unidad 02. El tutorial refuerza ahora configuración como contrato entre aplicación y plataforma, diferencia entre configuración, secreto, estado y código, antecedente Twelve-Factor, ciclo de vida de Pods, probes como contratos operativos, requests/limits como contrato con scheduler y nodo, límites de seguridad de Secrets y razón por la que gestores externos de secretos quedan diferidos. El usuario acepta estos cambios como mínimo y mantiene abierta la necesidad de elevar sustancialmente el nivel pedagógico de los README.

El 2026-07-22 se añadió `tutorial/02-configuration-lifecycle/student-reference.md` como backfill documental del nuevo contrato global de unidades. La referencia profundiza en configuración como contrato, límites de `Secret`, consumo mediante variables y volúmenes, probes, requests, limits, QoS, coste y continuidad hacia Helm, GitOps, seguridad, escalado y cloud. No modifica manifiestos, scripts, laboratorios ni estado técnico del clúster.

El 2026-07-27 se aplicó el saneamiento documental de fase 4 sobre la Unidad 02. Se regeneró `playbooks/units/02-configuration-lifecycle.md` contra el contrato documental cerrado, se ajustaron `tutorial/02-configuration-lifecycle/README.md`, `student-notes.md` y `student-reference.md` desde ese playbook, y se añadió cobertura explícita de terminación básica, QoS, límites de `Secret` y frontera entre práctica y referencia profesional. `.work/detail.md` se usó solo como checklist de cobertura. No se modificaron laboratorios, manifiestos Kubernetes, scripts ni estado técnico del clúster, y no se ejecutaron validaciones funcionales nuevas. El usuario confirmó la aprobación específica del saneamiento documental de la Unidad 02 el 2026-07-27.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Extender manifiestos existentes sin sustituir `platform-api` | Alcanzado | `labs/02-configuration-lifecycle/solution/deployment.yaml` conserva nombre, namespace, imagen y selectors base |
| Crear ConfigMap para configuración no sensible | Alcanzado | `labs/02-configuration-lifecycle/solution/configmap.yaml` |
| Crear Secret de laboratorio con valores ficticios | Alcanzado | `labs/02-configuration-lifecycle/solution/secret.yaml` |
| Consumir configuración como variables de entorno | Alcanzado | `env.valueFrom.configMapKeyRef` y `env.valueFrom.secretKeyRef` en `deployment.yaml` |
| Consumir ConfigMap como volumen | Alcanzado | Volumen `platform-api-content` montado en `/usr/share/nginx/html/index.html` |
| Configurar startup, readiness y liveness probes | Alcanzado | `startupProbe`, `readinessProbe` y `livenessProbe` en `deployment.yaml` |
| Definir requests y limits iniciales | Alcanzado | `resources.requests` y `resources.limits` en `deployment.yaml` |
| Documentar terminación básica del Pod | Alcanzado documentalmente | `terminationGracePeriodSeconds: 20` en `deployment.yaml`; límites de `preStop` y SIGTERM real en `student-reference.md` |
| Documentar rollouts y ciclo de vida básico | Alcanzado | `tutorial/02-configuration-lifecycle/README.md` |
| Reforzar el tutorial como material pedagógico principal | Alcanzado documentalmente | `tutorial/02-configuration-lifecycle/README.md`, `tutorial/02-configuration-lifecycle/instructor-notes.md` |
| Ajustar referencia profesional del alumno al contrato documental | Alcanzado y aprobado | `tutorial/02-configuration-lifecycle/student-reference.md`; aprobación específica del usuario el 2026-07-27 |
| Crear validación no destructiva | Alcanzado | `labs/02-configuration-lifecycle/validation/validate.sh` |
| Validar funcionalmente en MicroK8s | Alcanzado | `bash labs/02-configuration-lifecycle/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` heredados de Unidad 00.
- `kubectl` `v1.35.6` configurado como cliente principal.
- Helm `v3.21.0+ge0878d4` y Terraform `1.15.7` instalados como CLI, sin gestiónar recursos del curso.

## Aplicación

- `platform-api` existía como Deployment con dos réplicas y Service `ClusterIP`.
- La imagen heredada era `nginxinc/nginx-unprivileged:1.27.4-alpine`.
- No existían ConfigMaps, Secrets, probes, requests ni limits de aplicación.

## Automatizacion

- Existia `labs/01-kubernetes/solution/` como estado final de Unidad 01.
- Existia `labs/01-kubernetes/validation/validate.sh` como precondicion no destructiva.
- No existían charts Helm ni módulos Terraform.

## Observabilidad

- Solo estaban disponibles estado, eventos, logs y endpoints nativos de Kubernetes.
- No existía stack de observabilidad avanzada.

## Seguridad

- No existían Secrets de aplicación.
- No se versionaron credenciales reales.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 01 | `tutorial/01-kubernetes/summary.md` | Continuidad técnica, decisiones y limitaciones |
| Namespace base | `labs/01-kubernetes/solution/namespace.yaml` | Mantener `platform-training` |
| Deployment base | `labs/01-kubernetes/solution/deployment.yaml` | Punto de partida para evolucionar el template de Pod |
| Service base | `labs/01-kubernetes/solution/service.yaml` | Mantener exposición interna estable |
| Validación Unidad 01 | `labs/01-kubernetes/validation/validate.sh` | Precondición funcional |
| Playbook Unidad 02 | `playbooks/units/02-configuration-lifecycle.md` | Alcance y restricciones |

## Cambios introducidos

## Capacidades incorporadas

- configuración no sensible mediante ConfigMap;
- Secret de laboratorio con valores ficticios;
- variables de entorno desde ConfigMap y Secret;
- volumen de configuración desde ConfigMap;
- probes HTTP de startup, readiness y liveness;
- requests y limits iniciales de CPU y memoria;
- diagnóstico de ConfigMap, Secret, probes, endpoints y recursos;
- validación no destructiva de Unidad 02.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 02 | `tutorial/02-configuration-lifecycle/README.md` | Guia conceptual y practica del alumno |
| Student notes Unidad 02 | `tutorial/02-configuration-lifecycle/student-notes.md` | Material pedagógico profundo sobre ConfigMap, Secret, variables, volúmenes, probes, requests, limits, rollouts y EndpointSlice |
| Student reference Unidad 02 | `tutorial/02-configuration-lifecycle/student-reference.md` | Referencia profesional sobre configuración, secretos, probes, recursos, QoS, coste y continuidad |
| Instructor notes | `tutorial/02-configuration-lifecycle/instructor-notes.md` | Guia de imparticion y evaluacion |
| Summary Unidad 02 | `tutorial/02-configuration-lifecycle/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 02 | `labs/02-configuration-lifecycle/README.md` | Referencia operativa |
| Starter | `labs/02-configuration-lifecycle/starter/` | Punto de partida guiado |
| Solution | `labs/02-configuration-lifecycle/solution/` | Estado final reutilizable |
| Validación | `labs/02-configuration-lifecycle/validation/validate.sh` | Comprobación no destructiva |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Registrado que la Unidad 02 fue generada, validada funcionalmente y aprobada por el usuario |
| Hardening pedagógico inicial | `tutorial/02-configuration-lifecycle/README.md`, `tutorial/02-configuration-lifecycle/instructor-notes.md` | Refuerzo conceptual, decisiones de diseño, errores de razónamiento y lectura guiada |
| Saneamiento documental de fase 4 | `playbooks/units/02-configuration-lifecycle.md`, `tutorial/02-configuration-lifecycle/README.md`, `tutorial/02-configuration-lifecycle/student-notes.md`, `tutorial/02-configuration-lifecycle/student-reference.md`, `tutorial/02-configuration-lifecycle/summary.md` | Regeneración del playbook y ajuste documental contra el contrato cerrado; sin cambios funcionales |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/02-configuration-lifecycle/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/02-configuration-lifecycle/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── validation/
    └── validate.sh
```

## Estado técnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Heredado; no modificado por Unidad 02 | `platform/environment/README.md` |
| Kubernetes | Requerido para validar funcionalmente la unidad | `kubectl get nodes` |
| Helm | Disponible pero no usado para desplegar | `project/project-state.md` |
| Terraform | Disponible pero no usado para gestiónar recursos | `project/project-state.md` |

## Aplicación

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicación evolutiva | Conservada como `platform-api` | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| Namespace | Declarado como `platform-training` | `labs/02-configuration-lifecycle/solution/namespace.yaml` |
| Deployment | Declarado con 2 réplicas, ConfigMap, Secret, probes y resources | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| Service | Declarado como `ClusterIP` | `labs/02-configuration-lifecycle/solution/service.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles | `labs/02-configuration-lifecycle/solution/` |
| Validación de laboratorio | Disponible y ejecutable | `labs/02-configuration-lifecycle/validation/validate.sh` |
| Helm charts | No creados | Revisión del repositorio |
| Terraform modules | No creados | Revisión del repositorio |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `tutorial/02-configuration-lifecycle/README.md` |
| Eventos | Documentados para diagnóstico | `tutorial/02-configuration-lifecycle/README.md` |
| Logs | Documentados y comprobados por script cuando el Deployment existe | `labs/02-configuration-lifecycle/validation/validate.sh` |
| EndpointSlice | Usado como comprobación principal de endpoints | `labs/02-configuration-lifecycle/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Declarado con valores ficticios | `labs/02-configuration-lifecycle/solution/secret.yaml` |
| Credenciales reales | No versionadas | Revisión de manifiestos |
| Gestión avanzada de secretos | No incorporada | Diferida a unidades posteriores |
| `preStop` y gestión real de SIGTERM | No incorporados | Diferidos a unidades posteriores |

## Inventario relevante

## Namespaces

| Namespace | Propósito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/02-configuration-lifecycle/solution/deployment.yaml` | 2 réplicas disponibles tras despliegue |
| `réplicaset` generado | `platform-training` | Generado por Deployment | Mantiene Pods del Deployment |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running` y `Ready` tras despliegue correcto |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Propósito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable a Pods listos |
| EndpointSlice de `platform-api` | Interno del clúster | Evidencia preferente de selección de Pods listos |
| Port-forward local | `http://127.0.0.1:8080/` durante la prueba manual | Validación HTTP desde la máquina local |

## Configuración y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/02-configuration-lifecycle/solution/configmap.yaml` | Configuración no sensible y contenido HTML de laboratorio |
| Secret | `platform-api-secret`, `labs/02-configuration-lifecycle/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |

## Herramientas y versiones

| Herramienta | Versión validada | Método de comprobación |
|---|---|---|
| Kubernetes | `v1.35.6` heredado de Unidad 00 | `kubectl get nodes` aportado previamente |
| `kubectl` | `v1.35.6` heredado de Unidad 00 | `kubectl version --client` aportado previamente |
| Helm | `v3.21.0+ge0878d4` heredado de Unidad 00 | `helm version --short` |
| Terraform | `1.15.7` heredado de Unidad 00 | `terraform version` |

## Decisiónes tomadas

## D-02-01 - Configuración externa sin cambiar la aplicación evolutiva

### Decisión

La unidad extiende `platform-api` mediante recursos Kubernetes declarativos y configuración externa, sin sustituir la aplicación ni cambiar su namespace funcional.

### Motivo

El itinerario exige un laboratorio unico y evolutivo.

### Consecuencias

- `labs/01-kubernetes/solution/` queda como evidencia historica de Unidad 01;
- `labs/02-configuration-lifecycle/solution/` es la nueva base para Unidad 03.

### Ámbito

Especifica de la unidad y registrada en `project/project-state.md`.

## D-02-02 - Secrets solo de laboratorio

### Decisión

El Secret de la unidad contiene únicamente valores ficticios.

### Motivo

Permite practicar la API de Secret sin versionar credenciales reales.

### Consecuencias

- no se deben imprimir ni decodificar valores de Secret en validaciones;
- la gestión avanzada de secretos queda diferida.

### Ámbito

Especifica de la unidad.

## D-02-03 - EndpointSlice como comprobación principal de endpoints

### Decisión

La Unidad 02 usa EndpointSlice como comprobación principal de endpoints del Service.

### Motivo

Kubernetes reciente mantiene EndpointSlice como API preferente frente al recurso `Endpoints` clásico.

### Consecuencias

- la validación de Unidad 02 consulta EndpointSlice;
- se conserva fallback a `Endpoints` en el script para diagnóstico.

### Ámbito

Especifica de la unidad.

## Validaciónes

## Validaciónes ejecutadas

| Validación | Comando o procedimiento | Resultado observado |
|---|---|---|
| Generación de artefactos | Revisión de rutas creadas | Tutorial, instructor notes, summary, laboratorio, starter, solution y validación creados |
| Saneamiento documental fase 4 | Revisión documental contra `playbooks/student-reference-template.md`, `playbooks/units/02-configuration-lifecycle.md` y checklist de Unidad 02 en `.work/detail.md` | Playbook regenerado; README, notes, reference y summary ajustados; laboratorios y manifiestos sin cambios |
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | 0 fallos, 0 avisos fuera del sandbox |
| Estado Unidad 01 | `bash labs/01-kubernetes/validation/validate.sh` | 0 fallos, 0 avisos fuera del sandbox |
| Aplicación de manifiestos | `kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml -f labs/02-configuration-lifecycle/solution/configmap.yaml -f labs/02-configuration-lifecycle/solution/secret.yaml -f labs/02-configuration-lifecycle/solution/deployment.yaml -f labs/02-configuration-lifecycle/solution/service.yaml` | Namespace y recursos aplicados; ConfigMap y Secret creados; Deployment y Service configurados |
| Rollout Unidad 02 | `kubectl -n platform-training rollout status deployment/platform-api --timeout=120s` | `deployment "platform-api" successfully rolled out` |
| Validación funcional Unidad 02 | `bash labs/02-configuration-lifecycle/validation/validate.sh` | 0 fallos, 0 avisos |
| Prueba HTTP local | `kubectl -n platform-training port-forward service/platform-api 18080:80` y `curl -i http://127.0.0.1:18080/` | `HTTP/1.1 200 OK`; respuesta HTML con contenido de Unidad 02 desde ConfigMap |

## Validaciónes estaticas realizadas

| Validación | Método | Resultado |
|---|---|---|
| Sintaxis Bash de validación | `bash -n labs/02-configuration-lifecycle/validation/validate.sh` | Código de salida 0 |
| Sintaxis YAML cliente | `kubectl apply --dry-run=client -f labs/02-configuration-lifecycle/solution/` | Manifiestos aceptados por el cliente fuera del sandbox |
| Ausencia de charts Helm | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |
| Ausencia de secretos reales | `rg -n "(BEGIN (RSA\|OPENSSH\|EC\|DSA) PRIVATE KEY\|kubeconfig\|AKIA[0-9A-Z]{16}\|ghp_[A-Za-z0-9_]{20,}\|xox[baprs]-\|password:\|client_secret\|access_token)" labs/02-configuration-lifecycle tutorial/02-configuration-lifecycle --glob '!summary.md'` | Sin resultados; el Secret contiene solo valores ficticios de laboratorio |

## Validaciónes no ejecutadas

| Validación pendiente | Motivo | Responsable o momento |
|---|---|---|
| Validaciónes funcionales nuevas durante saneamiento documental | Prohibidas por el alcance de fase 4 | No aplica a este incremento |
| `shellcheck labs/02-configuration-lifecycle/validation/validate.sh` | `shellcheck` no está instalado en el entorno actual | Futuro hardening técnico o entorno con ShellCheck disponible |
| Revisión pedagógica específica del saneamiento Unit 02 | Aprobada el 2026-07-27 | Usuario responsable del curso |

## Comandos operativos principales

## Comprobación

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/02-configuration-lifecycle/validation/validate.sh
```

## Operación

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

## Diagnóstico

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
kubectl -n platform-training logs deployment/platform-api --tail=50
```

## Recuperación

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

## Limitaciones y deuda

- Validación funcional en MicroK8s ejecutada con 0 fallos y 0 avisos.
- Revisión pedagógica original del usuario aprobada el 2026-07-18.
- Saneamiento documental de fase 4 aplicado y aprobado el 2026-07-27.
- Hardening pedagógico global inicial aplicado el 2026-07-18 y aceptado como cambio mínimo; deuda pedagógica profunda sigue abierta.
- La gestión avanzada de secretos, cifrado en reposo, RBAC y gestores externos quedan diferidos.
- `preStop`, atención real de SIGTERM y cierre graceful completo quedan diferidos.
- Ingress, Gateway API, DNS y TLS quedan diferidos a Unidad 03.
- Helm y Terraform siguen sin gestiónar recursos del curso.

## Continuidad para la siguiente unidad

La Unidad 03 debe reutilizar:

```text
tutorial/02-configuration-lifecycle/summary.md
labs/02-configuration-lifecycle/solution/namespace.yaml
labs/02-configuration-lifecycle/solution/configmap.yaml
labs/02-configuration-lifecycle/solution/secret.yaml
labs/02-configuration-lifecycle/solution/deployment.yaml
labs/02-configuration-lifecycle/solution/service.yaml
labs/02-configuration-lifecycle/validation/validate.sh
```

No debe volver a `labs/01-kubernetes/solution/` como base activa salvo para comparar evolucion historica.
