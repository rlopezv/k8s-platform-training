# Summary - Unidad 02

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 02 - Configuracion, secretos y ciclo de vida |
| Identificador | `02-configuration-lifecycle` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada con limitaciones |
| Fecha de cierre o actualizacion | 2026-07-18 |
| Revision pedagogica del usuario | Aprobada |

## Resumen ejecutivo

La Unidad 02 evoluciona `platform-api` desde el Deployment minimo de la Unidad 01 hacia un workload configurable y operable mediante recursos Kubernetes estandar.

La solucion final queda en `labs/02-configuration-lifecycle/solution/` e incorpora ConfigMap, Secret de laboratorio con valores ficticios, variables de entorno, volumen de configuracion, `startupProbe`, `readinessProbe`, `livenessProbe`, requests y limits iniciales.

El contenido y los artefactos han sido generados, aplicados y validados funcionalmente contra el MicroK8s local. El usuario reviso y aprobo la unidad el 2026-07-18.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Extender manifiestos existentes sin sustituir `platform-api` | Alcanzado | `labs/02-configuration-lifecycle/solution/deployment.yaml` conserva nombre, namespace, imagen y selectors base |
| Crear ConfigMap para configuracion no sensible | Alcanzado | `labs/02-configuration-lifecycle/solution/configmap.yaml` |
| Crear Secret de laboratorio con valores ficticios | Alcanzado | `labs/02-configuration-lifecycle/solution/secret.yaml` |
| Consumir configuracion como variables de entorno | Alcanzado | `env.valueFrom.configMapKeyRef` y `env.valueFrom.secretKeyRef` en `deployment.yaml` |
| Consumir ConfigMap como volumen | Alcanzado | Volumen `platform-api-content` montado en `/usr/share/nginx/html/index.html` |
| Configurar startup, readiness y liveness probes | Alcanzado | `startupProbe`, `readinessProbe` y `livenessProbe` en `deployment.yaml` |
| Definir requests y limits iniciales | Alcanzado | `resources.requests` y `resources.limits` en `deployment.yaml` |
| Documentar rollouts y ciclo de vida basico | Alcanzado | `tutorial/02-configuration-lifecycle/README.md` |
| Crear validacion no destructiva | Alcanzado | `labs/02-configuration-lifecycle/validation/validate.sh` |
| Validar funcionalmente en MicroK8s | Alcanzado | `bash labs/02-configuration-lifecycle/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` heredados de Unidad 00.
- `kubectl` `v1.35.6` configurado como cliente principal.
- Helm `v3.21.0+ge0878d4` y Terraform `1.15.7` instalados como CLI, sin gestionar recursos del curso.

## Aplicacion

- `platform-api` existia como Deployment con dos replicas y Service `ClusterIP`.
- La imagen heredada era `nginxinc/nginx-unprivileged:1.27.4-alpine`.
- No existian ConfigMaps, Secrets, probes, requests ni limits de aplicacion.

## Automatizacion

- Existia `labs/01-kubernetes/solution/` como estado final de Unidad 01.
- Existia `labs/01-kubernetes/validation/validate.sh` como precondicion no destructiva.
- No existian charts Helm ni modulos Terraform.

## Observabilidad

- Solo estaban disponibles estado, eventos, logs y endpoints nativos de Kubernetes.
- No existia stack de observabilidad avanzada.

## Seguridad

- No existian Secrets de aplicacion.
- No se versionaron credenciales reales.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 01 | `tutorial/01-kubernetes/summary.md` | Continuidad tecnica, decisiones y limitaciones |
| Namespace base | `labs/01-kubernetes/solution/namespace.yaml` | Mantener `platform-training` |
| Deployment base | `labs/01-kubernetes/solution/deployment.yaml` | Punto de partida para evolucionar el template de Pod |
| Service base | `labs/01-kubernetes/solution/service.yaml` | Mantener exposicion interna estable |
| Validacion Unidad 01 | `labs/01-kubernetes/validation/validate.sh` | Precondicion funcional |
| Playbook Unidad 02 | `playbooks/units/02-configuration-lifecycle.md` | Alcance y restricciones |

## Cambios introducidos

## Capacidades incorporadas

- configuracion no sensible mediante ConfigMap;
- Secret de laboratorio con valores ficticios;
- variables de entorno desde ConfigMap y Secret;
- volumen de configuracion desde ConfigMap;
- probes HTTP de startup, readiness y liveness;
- requests y limits iniciales de CPU y memoria;
- diagnostico de ConfigMap, Secret, probes, endpoints y recursos;
- validacion no destructiva de Unidad 02.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 02 | `tutorial/02-configuration-lifecycle/README.md` | Guia conceptual y practica del alumno |
| Instructor notes | `tutorial/02-configuration-lifecycle/instructor-notes.md` | Guia de imparticion y evaluacion |
| Summary Unidad 02 | `tutorial/02-configuration-lifecycle/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 02 | `labs/02-configuration-lifecycle/README.md` | Referencia operativa |
| Starter | `labs/02-configuration-lifecycle/starter/` | Punto de partida guiado |
| Solution | `labs/02-configuration-lifecycle/solution/` | Estado final reutilizable |
| Validacion | `labs/02-configuration-lifecycle/validation/validate.sh` | Comprobacion no destructiva |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Registrado que la Unidad 02 fue generada, validada funcionalmente y aprobada por el usuario |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/02-configuration-lifecycle/
├── README.md
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

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Heredado; no modificado por Unidad 02 | `platform/environment/README.md` |
| Kubernetes | Requerido para validar funcionalmente la unidad | `kubectl get nodes` |
| Helm | Disponible pero no usado para desplegar | `project/project-state.md` |
| Terraform | Disponible pero no usado para gestionar recursos | `project/project-state.md` |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Conservada como `platform-api` | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| Namespace | Declarado como `platform-training` | `labs/02-configuration-lifecycle/solution/namespace.yaml` |
| Deployment | Declarado con 2 replicas, ConfigMap, Secret, probes y resources | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| Service | Declarado como `ClusterIP` | `labs/02-configuration-lifecycle/solution/service.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles | `labs/02-configuration-lifecycle/solution/` |
| Validacion de laboratorio | Disponible y ejecutable | `labs/02-configuration-lifecycle/validation/validate.sh` |
| Helm charts | No creados | Revision del repositorio |
| Terraform modules | No creados | Revision del repositorio |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `tutorial/02-configuration-lifecycle/README.md` |
| Eventos | Documentados para diagnostico | `tutorial/02-configuration-lifecycle/README.md` |
| Logs | Documentados y comprobados por script cuando el Deployment existe | `labs/02-configuration-lifecycle/validation/validate.sh` |
| EndpointSlice | Usado como comprobacion principal de endpoints | `labs/02-configuration-lifecycle/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Declarado con valores ficticios | `labs/02-configuration-lifecycle/solution/secret.yaml` |
| Credenciales reales | No versionadas | Revision de manifiestos |
| Gestion avanzada de secretos | No incorporada | Diferida a unidades posteriores |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/02-configuration-lifecycle/solution/deployment.yaml` | 2 replicas disponibles tras despliegue |
| `replicaset` generado | `platform-training` | Generado por Deployment | Mantiene Pods del Deployment |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running` y `Ready` tras despliegue correcto |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable a Pods listos |
| EndpointSlice de `platform-api` | Interno del cluster | Evidencia preferente de seleccion de Pods listos |
| Port-forward local | `http://127.0.0.1:8080/` durante la prueba manual | Validacion HTTP desde la maquina local |

## Configuracion y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/02-configuration-lifecycle/solution/configmap.yaml` | Configuracion no sensible y contenido HTML de laboratorio |
| Secret | `platform-api-secret`, `labs/02-configuration-lifecycle/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Kubernetes | `v1.35.6` heredado de Unidad 00 | `kubectl get nodes` aportado previamente |
| `kubectl` | `v1.35.6` heredado de Unidad 00 | `kubectl version --client` aportado previamente |
| Helm | `v3.21.0+ge0878d4` heredado de Unidad 00 | `helm version --short` |
| Terraform | `1.15.7` heredado de Unidad 00 | `terraform version` |

## Decisiones tomadas

## D-02-01 - Configuracion externa sin cambiar la aplicacion evolutiva

### Decision

La unidad extiende `platform-api` mediante recursos Kubernetes declarativos y configuracion externa, sin sustituir la aplicacion ni cambiar su namespace funcional.

### Motivo

El itinerario exige un laboratorio unico y evolutivo.

### Consecuencias

- `labs/01-kubernetes/solution/` queda como evidencia historica de Unidad 01;
- `labs/02-configuration-lifecycle/solution/` es la nueva base para Unidad 03.

### Ambito

Especifica de la unidad y registrada en `project/project-state.md`.

## D-02-02 - Secrets solo de laboratorio

### Decision

El Secret de la unidad contiene unicamente valores ficticios.

### Motivo

Permite practicar la API de Secret sin versionar credenciales reales.

### Consecuencias

- no se deben imprimir ni decodificar valores de Secret en validaciones;
- la gestion avanzada de secretos queda diferida.

### Ambito

Especifica de la unidad.

## D-02-03 - EndpointSlice como comprobacion principal de endpoints

### Decision

La Unidad 02 usa EndpointSlice como comprobacion principal de endpoints del Service.

### Motivo

Kubernetes reciente mantiene EndpointSlice como API preferente frente al recurso `Endpoints` clasico.

### Consecuencias

- la validacion de Unidad 02 consulta EndpointSlice;
- se conserva fallback a `Endpoints` en el script para diagnostico.

### Ambito

Especifica de la unidad.

## Validaciones

## Validaciones ejecutadas

| Validacion | Comando o procedimiento | Resultado observado |
|---|---|---|
| Generacion de artefactos | Revision de rutas creadas | Tutorial, instructor notes, summary, laboratorio, starter, solution y validacion creados |
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | 0 fallos, 0 avisos fuera del sandbox |
| Estado Unidad 01 | `bash labs/01-kubernetes/validation/validate.sh` | 0 fallos, 0 avisos fuera del sandbox |
| Aplicacion de manifiestos | `kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml -f labs/02-configuration-lifecycle/solution/configmap.yaml -f labs/02-configuration-lifecycle/solution/secret.yaml -f labs/02-configuration-lifecycle/solution/deployment.yaml -f labs/02-configuration-lifecycle/solution/service.yaml` | Namespace y recursos aplicados; ConfigMap y Secret creados; Deployment y Service configurados |
| Rollout Unidad 02 | `kubectl -n platform-training rollout status deployment/platform-api --timeout=120s` | `deployment "platform-api" successfully rolled out` |
| Validacion funcional Unidad 02 | `bash labs/02-configuration-lifecycle/validation/validate.sh` | 0 fallos, 0 avisos |
| Prueba HTTP local | `kubectl -n platform-training port-forward service/platform-api 18080:80` y `curl -i http://127.0.0.1:18080/` | `HTTP/1.1 200 OK`; respuesta HTML con contenido de Unidad 02 desde ConfigMap |

## Validaciones estaticas realizadas

| Validacion | Metodo | Resultado |
|---|---|---|
| Sintaxis Bash de validacion | `bash -n labs/02-configuration-lifecycle/validation/validate.sh` | Codigo de salida 0 |
| Sintaxis YAML cliente | `kubectl apply --dry-run=client -f labs/02-configuration-lifecycle/solution/` | Manifiestos aceptados por el cliente fuera del sandbox |
| Ausencia de charts Helm | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |
| Ausencia de secretos reales | `rg -n "(BEGIN (RSA\|OPENSSH\|EC\|DSA) PRIVATE KEY\|kubeconfig\|AKIA[0-9A-Z]{16}\|ghp_[A-Za-z0-9_]{20,}\|xox[baprs]-\|password:\|client_secret\|access_token)" labs/02-configuration-lifecycle tutorial/02-configuration-lifecycle --glob '!summary.md'` | Sin resultados; el Secret contiene solo valores ficticios de laboratorio |

## Validaciones no ejecutadas

| Validacion pendiente | Motivo | Responsable o momento |
|---|---|---|
| `shellcheck labs/02-configuration-lifecycle/validation/validate.sh` | `shellcheck` no esta instalado en el entorno actual | Futuro hardening tecnico o entorno con ShellCheck disponible |
| Revision pedagogica del usuario | Aprobada el 2026-07-18 | Usuario responsable del curso |

## Comandos operativos principales

## Comprobacion

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/02-configuration-lifecycle/validation/validate.sh
```

## Operacion

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

## Diagnostico

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
kubectl -n platform-training logs deployment/platform-api --tail=50
```

## Recuperacion

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

## Limitaciones y deuda

- Validacion funcional en MicroK8s ejecutada con 0 fallos y 0 avisos.
- Revision pedagogica del usuario aprobada el 2026-07-18.
- La deuda de hardening pedagogico global detectada tras Unidad 01 sigue abierta.
- La gestion avanzada de secretos, cifrado en reposo, RBAC y gestores externos quedan diferidos.
- Ingress, Gateway API, DNS y TLS quedan diferidos a Unidad 03.
- Helm y Terraform siguen sin gestionar recursos del curso.

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
