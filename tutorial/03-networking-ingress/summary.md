# Summary - Unidad 03

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 03 - Networking e ingreso |
| Identificador | `03-networking-ingress` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada, validada tecnicamente y aprobada con limitaciones |
| Fecha de cierre o actualizacion | 2026-07-22 |
| Revision pedagogica del usuario | Unidad aprobada; `student-reference.md` añadido posteriormente con aprobación pedagógica específica pendiente |

## Resumen ejecutivo

La Unidad 03 evoluciona `platform-api` desde una aplicacion accesible solo mediante Service interno y port-forward hacia una aplicacion expuesta por HTTP en el laboratorio local mediante un recurso `Ingress`.

La solucion final queda en `labs/03-networking-ingress/solution/` y conserva namespace, Deployment, ConfigMap, Secret ficticio, probes, resources y Service `ClusterIP` heredados de Unidad 02. La unidad añade `ingress/platform-api` para el host `platform-api.local`, con `ingressClassName: public`, backend `service/platform-api` y puerto `80`.

Gateway API queda documentada como comparacion conceptual. El addon Ingress de MicroK8s instala CRDs de Gateway API como efecto de plataforma local, pero el curso no crea `GatewayClass`, `Gateway` ni `HTTPRoute` como artefactos gestionados. TLS productivo, DNS publico, LoadBalancer cloud, NetworkPolicies, Helm, Terraform, CI/CD, GitOps, observabilidad avanzada y cloud siguen diferidos.

El 2026-07-22 se añadió `tutorial/03-networking-ingress/student-reference.md` como backfill documental del nuevo contrato global de unidades y resolución material de `GAP-003`. La referencia profundiza en networking de Kubernetes, Service, EndpointSlice, DNS interno, Ingress Controller, TLS, certificados, `cert-manager`, Gateway API, entrada cloud y criterios de migración. No modifica manifiestos, scripts, laboratorios ni estado técnico del clúster.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Reutilizar `platform-api` y `platform-training` | Alcanzado | `labs/03-networking-ingress/solution/` conserva nombres y selectors base |
| Conservar Service `ClusterIP` | Alcanzado | `labs/03-networking-ingress/solution/service.yaml` |
| Crear Ingress HTTP hacia el Service existente | Alcanzado | `labs/03-networking-ingress/solution/ingress.yaml` |
| Documentar DNS interno y EndpointSlice | Alcanzado | `tutorial/03-networking-ingress/README.md` |
| Documentar Ingress Controller local de MicroK8s | Alcanzado | `tutorial/03-networking-ingress/README.md` y `labs/03-networking-ingress/README.md` |
| Comparar Ingress y Gateway API sin migracion | Alcanzado | `tutorial/03-networking-ingress/README.md` |
| Crear referencia profesional del alumno | Alcanzado documentalmente con aprobación pendiente | `tutorial/03-networking-ingress/student-reference.md` |
| Crear validacion de Unidad 03 | Alcanzado | `labs/03-networking-ingress/validation/validate.sh` |
| Validar funcionalmente en MicroK8s | Alcanzado | `bash labs/03-networking-ingress/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` heredados.
- Addon `dns` registrado como habilitado.
- Helm y Terraform disponibles como CLI, sin gestionar recursos del curso.

## Aplicacion

- `platform-api` existia como Deployment con dos replicas.
- El Service `platform-api` era `ClusterIP`.
- Existian ConfigMap, Secret ficticio, probes y resources desde Unidad 02.
- No existia Ingress de aplicacion generado por unidades anteriores.

## Automatizacion

- Existia `labs/02-configuration-lifecycle/solution/` como estado final de Unidad 02.
- Existia `labs/02-configuration-lifecycle/validation/validate.sh` como precondicion funcional.
- No existian charts Helm ni modulos Terraform del curso.

## Observabilidad

- Estado, eventos, logs y EndpointSlice estaban disponibles como diagnostico nativo.
- No existia stack de observabilidad avanzada.

## Seguridad

- El Secret heredado contiene valores ficticios.
- No se versionaron credenciales reales, certificados privados ni kubeconfigs.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 02 | `tutorial/02-configuration-lifecycle/summary.md` | Continuidad tecnica y decisiones |
| Manifiestos Unidad 02 | `labs/02-configuration-lifecycle/solution/` | Base acumulativa de Unidad 03 |
| Validacion Unidad 02 | `labs/02-configuration-lifecycle/validation/validate.sh` | Precondicion funcional |
| Playbook Unidad 03 | `playbooks/units/03-networking-ingress.md` | Alcance, restricciones y criterios |

## Cambios introducidos

## Capacidades incorporadas

- Ingress HTTP local para `platform-api`;
- host de laboratorio `platform-api.local`;
- validacion de DNS interno mediante Pod temporal;
- diagnostico por capas de red;
- comparacion conceptual entre Ingress y Gateway API;
- validacion no destructiva con comprobacion de Ingress Controller.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 03 | `tutorial/03-networking-ingress/README.md` | Guia conceptual del alumno |
| Student notes Unidad 03 | `tutorial/03-networking-ingress/student-notes.md` | Material pedagogico profundo sobre Pod IP, Service, EndpointSlice, DNS interno, Ingress Controller, Ingress, host HTTP y Gateway API conceptual |
| Student reference Unidad 03 | `tutorial/03-networking-ingress/student-reference.md` | Referencia profesional sobre networking, TLS, certificados, cert-manager, Gateway API, entrada cloud y criterios de decisión |
| Instructor notes | `tutorial/03-networking-ingress/instructor-notes.md` | Guia de imparticion y evaluacion |
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 03 | `labs/03-networking-ingress/README.md` | Referencia operativa |
| Starter | `labs/03-networking-ingress/starter/` | Punto de partida |
| Solution | `labs/03-networking-ingress/solution/` | Estado final reutilizable |
| Ingress | `labs/03-networking-ingress/solution/ingress.yaml` | Regla HTTP hacia el Service |
| Validacion | `labs/03-networking-ingress/validation/validate.sh` | Comprobacion del estado esperado |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Registrado que la Unidad 03 fue generada, validada tecnicamente y aprobada pedagogicamente |
| Manifiestos heredados | `labs/03-networking-ingress/solution/` | Copiados desde Unidad 02 y etiquetados como Unidad 03 |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/03-networking-ingress/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/03-networking-ingress/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Heredado; no modificado por los archivos generados | `project/project-state.md` |
| Addon DNS | Requerido y heredado | `microk8s status --wait-ready` |
| Ingress Controller | Habilitado y validado mediante addon MicroK8s; Traefik `v3.6.2` desplegado en namespace `ingress` | `microk8s enable ingress`, `kubectl -n ingress get pods` |
| Gateway API CRDs | Instalados por el addon Ingress de MicroK8s como efecto de plataforma; no gestionados por el curso | Salida de `microk8s enable ingress` |
| Helm | Disponible; MicroK8s lo usa internamente para desplegar Traefik, pero el curso no crea charts ni releases propios | `project/project-state.md` |
| Terraform | Disponible pero no usado | `project/project-state.md` |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Conservada como `platform-api` | `labs/03-networking-ingress/solution/deployment.yaml` |
| Namespace | Conservado como `platform-training` | `labs/03-networking-ingress/solution/namespace.yaml` |
| Deployment | Conserva dos replicas, ConfigMap, Secret, probes y resources | `labs/03-networking-ingress/solution/deployment.yaml` |
| Service | Conservado como `ClusterIP` | `labs/03-networking-ingress/solution/service.yaml` |
| Ingress | Declarado para `platform-api.local` hacia `service/platform-api:80` | `labs/03-networking-ingress/solution/ingress.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles y aplicados | `kubectl apply -f labs/03-networking-ingress/solution/` |
| Validacion de laboratorio | Disponible y ejecutada | `bash labs/03-networking-ingress/validation/validate.sh`: 0 fallos, 0 avisos |
| Helm charts | No creados | Revision del repositorio |
| Terraform modules | No creados | Revision del repositorio |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `tutorial/03-networking-ingress/README.md` |
| Eventos | Documentados para diagnostico | `tutorial/03-networking-ingress/README.md` |
| Logs | Documentados para aplicacion y controlador | `labs/03-networking-ingress/README.md` |
| EndpointSlice | Usado como comprobacion principal de endpoints | `labs/03-networking-ingress/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Conservado con valores ficticios | `labs/03-networking-ingress/solution/secret.yaml` |
| Credenciales reales | No versionadas | Revision de manifiestos |
| TLS productivo | No incorporado | Diferido |
| Seguridad avanzada de red | No incorporada | Diferida |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |
| `ingress` | Ejecutar controlador local de MicroK8s cuando el addon esta habilitado | No por manifiestos del curso |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/03-networking-ingress/solution/deployment.yaml` | 2 replicas disponibles |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running` y `Ready` |
| Controlador de Ingress | `ingress` | Gestionado por MicroK8s | Pods Ready cuando el addon esta activo |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable |
| EndpointSlice de `platform-api` | Interno del cluster | Evidencia preferente de Pods Ready |
| `ingress/platform-api` | Host `platform-api.local`, path `/` | Entrada HTTP local hacia el Service |
| Prueba HTTP local | `curl -H 'Host: platform-api.local' http://127.0.0.1/` | Validacion de ingreso |

## Configuracion y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/03-networking-ingress/solution/configmap.yaml` | Configuracion no sensible y contenido HTML |
| Secret | `platform-api-secret`, `labs/03-networking-ingress/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Kubernetes | `v1.35.6` heredado | `project/project-state.md` |
| `kubectl` | `v1.35.6` heredado | `project/project-state.md` |
| MicroK8s | `v1.35.6` heredado | `project/project-state.md` |
| Helm | `v3.21.0+ge0878d4` heredado | `project/project-state.md` |
| Terraform | `1.15.7` heredado | `project/project-state.md` |

## Decisiones tomadas

## D-03-01 - Service interno conservado como backend estable

### Decision

La unidad conserva `service/platform-api` como `ClusterIP` y lo usa como backend del recurso `Ingress`.

### Motivo

Ingress complementa al Service como capa de entrada HTTP, no lo sustituye.

### Consecuencias

- los diagnosticos empiezan por Pods, Service y EndpointSlice;
- la Unidad 04 hereda un Service interno estable y una entrada HTTP local.

### Ambito

Especifica de la unidad y registrada en `project/project-state.md`.

## D-03-02 - Ingress Controller local como dependencia explicita de MicroK8s

### Decision

El laboratorio documenta el addon Ingress de MicroK8s como controlador local y usa `ingressClassName: public`.

### Motivo

Permite validar la API `Ingress` sin introducir Helm, cloud ni controladores externos.

### Consecuencias

- el paso es especifico de MicroK8s;
- no se extrapola a AKS, EKS o plataformas corporativas.

### Ambito

Especifica de la unidad.

## D-03-03 - HTTP local antes que TLS productivo

### Decision

La unidad usa HTTP local con host `platform-api.local`.

### Motivo

TLS introduce identidad, certificados, confianza y renovacion, fuera del alcance actual.

### Consecuencias

- no se versionan claves privadas ni certificados;
- TLS queda diferido.

### Ambito

Especifica de la unidad.

## D-03-04 - Gateway API como comparacion, no como eje operativo

### Decision

Gateway API se explica conceptualmente y no se crean `GatewayClass`, `Gateway` ni `HTTPRoute`.

### Motivo

Mantener complejidad controlada y depender solo de capacidades locales ya planificadas.

### Consecuencias

- la migracion o practica con Gateway API queda diferida;
- el alumno entiende por que existe sin mezclar APIs en el laboratorio.

### Ambito

Especifica de la unidad.

## Validaciones

## Validaciones ejecutadas

| Validacion | Comando o procedimiento | Resultado observado |
|---|---|---|
| Generacion de artefactos | Revision de rutas creadas | Tutorial, instructor notes, summary, laboratorio, starter, solution y validacion creados |
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | 0 fallos, 0 avisos |
| Estado Unidad 02 | `bash labs/02-configuration-lifecycle/validation/validate.sh` | 0 fallos, 0 avisos |
| Addon Ingress de MicroK8s | `microk8s enable ingress` y `microk8s status --wait-ready` | `ingress` habilitado; Traefik `v3.6.2` desplegado; `IngressClass/public` disponible |
| Aplicacion de manifiestos | `kubectl apply -f labs/03-networking-ingress/solution/` | Namespace, ConfigMap, Secret, Deployment, Service e Ingress aplicados sin errores |
| Rollout Unidad 03 | `kubectl -n platform-training rollout status deployment/platform-api --timeout=120s` | `deployment "platform-api" successfully rolled out` |
| Validacion funcional Unidad 03 | `bash labs/03-networking-ingress/validation/validate.sh` | 0 fallos, 0 avisos; DNS interno, EndpointSlice, Ingress Controller, Ingress y HTTP validados |

## Validaciones estaticas realizadas

| Validacion | Metodo | Resultado |
|---|---|---|
| Sintaxis Bash | `bash -n labs/03-networking-ingress/validation/validate.sh` | Codigo de salida 0 |
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/03-networking-ingress/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | `rg` sobre `labs/03-networking-ingress` y `tutorial/03-networking-ingress` | Sin credenciales reales; solo una frase documental sobre no versionar credenciales |
| Ausencia de charts Helm del curso | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform del curso | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

## Validaciones no ejecutadas

| Validacion pendiente | Motivo | Responsable o momento |
|---|---|---|
| ShellCheck | `shellcheck` no esta instalado en el entorno actual | Cuando la herramienta este disponible |
| Revision pedagogica del usuario | El usuario aun no ha revisado la unidad generada | Usuario responsable del curso |

## Limitaciones y continuidad

- `labs/03-networking-ingress/solution/` es la nueva base para Unidad 04.
- `labs/02-configuration-lifecycle/solution/` permanece como evidencia historica de Unidad 02.
- La validacion funcional del Ingress se ejecuto con MicroK8s y addon Ingress activo.
- La prueba HTTP funciono con `http://127.0.0.1/`; en otros entornos WSL puede requerir ajustar `INGRESS_URL`.
- El addon Ingress instala CRDs de Gateway API, pero la Unidad 03 no crea recursos Gateway API como parte del laboratorio.
- La deuda pedagogica profunda de los README sigue abierta para una fase posterior.
