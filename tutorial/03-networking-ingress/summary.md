# Summary - Unidad 03

## Identificación

| Campo | Valor |
|---|---|
| Unidad | 03 - Networking e ingreso |
| Identificador | `03-networking-ingress` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada, validada técnicamente y aprobada con limitaciones; saneamiento documental de fase 4 aplicado y aprobado |
| Fecha de cierre o actualización | 2026-07-27 |
| Revisión pedagógica del usuario | Unidad aprobada el 2026-07-19; saneamiento documental de fase 4 aprobado el 2026-07-27 |

## Resumen ejecutivo

La Unidad 03 evoluciona `platform-api` desde una aplicación accesible solo mediante Service interno y port-forward hacia una aplicación expuesta por HTTP en el laboratorio local mediante un recurso `Ingress`.

La solución final queda en `labs/03-networking-ingress/solution/` y conserva namespace, Deployment, ConfigMap, Secret ficticio, probes, resources y Service `ClusterIP` heredados de Unidad 02. La unidad añade `ingress/platform-api` para el host `platform-api.local`, con `ingressClassName: public`, backend `service/platform-api` y puerto `80`.

Gateway API queda documentada como comparación conceptual. El addon Ingress de MicroK8s instala CRDs de Gateway API como efecto de plataforma local, pero el curso no crea `GatewayClass`, `Gateway` ni `HTTPRoute` como artefactos gestionados. TLS productivo, DNS público, LoadBalancer cloud, NetworkPolicies, Helm, Terraform, CI/CD, GitOps, observabilidad avanzada y cloud siguen diferidos.

El 2026-07-22 se añadió `tutorial/03-networking-ingress/student-reference.md` como backfill documental del nuevo contrato global de unidades y resolución material de `GAP-003`. La referencia profundiza en networking de Kubernetes, Service, EndpointSlice, DNS interno, Ingress Controller, TLS, certificados, `cert-manager`, Gateway API, entrada cloud y criterios de migración. No modifica manifiestos, scripts, laboratorios ni estado técnico del clúster.

El 2026-07-27 se aplicó y aprobó el saneamiento documental de fase 4 sobre la Unidad 03. Se regeneró `playbooks/units/03-networking-ingress.md` contra el contrato documental cerrado, se ajustaron `tutorial/03-networking-ingress/README.md`, `student-notes.md` y `student-reference.md` desde ese playbook, y se añadió cobertura explícita de CNI, MetalLB, anotaciones de controlador, TLS, certificados, `cert-manager` y Gateway API como criterio profesional. `.work/detail.md` se usó solo como checklist de cobertura. No se modificaron laboratorios, manifiestos Kubernetes, scripts ni estado técnico del clúster, y no se ejecutaron validaciones funcionales nuevas. `GAP-003` queda confirmado como cerrado documentalmente.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Reutilizar `platform-api` y `platform-training` | Alcanzado | `labs/03-networking-ingress/solution/` conserva nombres y selectors base |
| Conservar Service `ClusterIP` | Alcanzado | `labs/03-networking-ingress/solution/service.yaml` |
| Crear Ingress HTTP hacia el Service existente | Alcanzado | `labs/03-networking-ingress/solution/ingress.yaml` |
| Documentar DNS interno y EndpointSlice | Alcanzado | `tutorial/03-networking-ingress/README.md` |
| Documentar Ingress Controller local de MicroK8s | Alcanzado | `tutorial/03-networking-ingress/README.md` y `labs/03-networking-ingress/README.md` |
| Comparar Ingress y Gateway API sin migración | Alcanzado | `tutorial/03-networking-ingress/README.md` |
| Crear referencia profesional del alumno | Alcanzado documentalmente y aprobado | `tutorial/03-networking-ingress/student-reference.md` |
| Ajustar referencia profesional del alumno al contrato documental | Alcanzado documentalmente | `tutorial/03-networking-ingress/student-reference.md`; cierre de `GAP-003` registrado |
| Crear validación de Unidad 03 | Alcanzado | `labs/03-networking-ingress/validation/validate.sh` |
| Validar funcionalmente en MicroK8s | Alcanzado | `bash labs/03-networking-ingress/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` heredados.
- Addon `dns` registrado como habilitado.
- Helm y Terraform disponibles como CLI, sin gestionar recursos del curso.

## Aplicación

- `platform-api` existía como Deployment con dos réplicas.
- El Service `platform-api` era `ClusterIP`.
- Existian ConfigMap, Secret ficticio, probes y resources desde Unidad 02.
- No existía Ingress de aplicación generado por unidades anteriores.

## Automatización

- Existía `labs/02-configuration-lifecycle/solution/` como estado final de Unidad 02.
- Existía `labs/02-configuration-lifecycle/validation/validate.sh` como precondición funcional.
- No existían charts Helm ni módulos Terraform del curso.

## Observabilidad

- Estado, eventos, logs y EndpointSlice estaban disponibles como diagnóstico nativo.
- No existía stack de observabilidad avanzada.

## Seguridad

- El Secret heredado contiene valores ficticios.
- No se versionaron credenciales reales, certificados privados ni kubeconfigs.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 02 | `tutorial/02-configuration-lifecycle/summary.md` | Continuidad técnica y decisiones |
| Manifiestos Unidad 02 | `labs/02-configuration-lifecycle/solution/` | Base acumulativa de Unidad 03 |
| Validación Unidad 02 | `labs/02-configuration-lifecycle/validation/validate.sh` | Precondición funcional |
| Playbook Unidad 03 | `playbooks/units/03-networking-ingress.md` | Alcance, restricciones y criterios |

## Cambios introducidos

## Capacidades incorporadas

- Ingress HTTP local para `platform-api`;
- host de laboratorio `platform-api.local`;
- validación de DNS interno mediante Pod temporal;
- diagnóstico por capas de red;
- comparación conceptual entre Ingress y Gateway API;
- validación no destructiva con comprobación de Ingress Controller.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 03 | `tutorial/03-networking-ingress/README.md` | Guía conceptual del alumno |
| Student notes Unidad 03 | `tutorial/03-networking-ingress/student-notes.md` | Material pedagógico profundo sobre Pod IP, Service, EndpointSlice, DNS interno, Ingress Controller, Ingress, host HTTP y Gateway API conceptual |
| Student reference Unidad 03 | `tutorial/03-networking-ingress/student-reference.md` | Referencia profesional sobre networking, TLS, certificados, cert-manager, Gateway API, entrada cloud y criterios de decisión |
| Instructor notes | `tutorial/03-networking-ingress/instructor-notes.md` | Guía de impartición y evaluación |
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 03 | `labs/03-networking-ingress/README.md` | Referencia operativa |
| Starter | `labs/03-networking-ingress/starter/` | Punto de partida |
| Solution | `labs/03-networking-ingress/solution/` | Estado final reutilizable |
| Ingress | `labs/03-networking-ingress/solution/ingress.yaml` | Regla HTTP hacia el Service |
| Validación | `labs/03-networking-ingress/validation/validate.sh` | Comprobación del estado esperado |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Registrado que la Unidad 03 fue generada, validada tecnicamente y aprobada pedagogicamente |
| Manifiestos heredados | `labs/03-networking-ingress/solution/` | Copiados desde Unidad 02 y etiquetados como Unidad 03 |
| Saneamiento documental de fase 4 | `playbooks/units/03-networking-ingress.md`, `tutorial/03-networking-ingress/README.md`, `tutorial/03-networking-ingress/student-notes.md`, `tutorial/03-networking-ingress/student-reference.md`, `tutorial/03-networking-ingress/summary.md` | Regeneración del playbook y ajuste documental contra el contrato cerrado; sin cambios funcionales |

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

## Estado técnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Heredado; no modificado por los archivos generados | `project/project-state.md` |
| Addon DNS | Requerido y heredado | `microk8s status --wait-ready` |
| Ingress Controller | Habilitado y validado mediante addon MicroK8s; Traefik `v3.6.2` desplegado en namespace `ingress` | `microk8s enable ingress`, `kubectl -n ingress get pods` |
| Gateway API CRDs | Instalados por el addon Ingress de MicroK8s como efecto de plataforma; no gestionados por el curso | Salida de `microk8s enable ingress` |
| Helm | Disponible; MicroK8s lo usa internamente para desplegar Traefik, pero el curso no crea charts ni releases propios | `project/project-state.md` |
| Terraform | Disponible pero no usado | `project/project-state.md` |

## Aplicación

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicación evolutiva | Conservada como `platform-api` | `labs/03-networking-ingress/solution/deployment.yaml` |
| Namespace | Conservado como `platform-training` | `labs/03-networking-ingress/solution/namespace.yaml` |
| Deployment | Conserva dos réplicas, ConfigMap, Secret, probes y resources | `labs/03-networking-ingress/solution/deployment.yaml` |
| Service | Conservado como `ClusterIP` | `labs/03-networking-ingress/solution/service.yaml` |
| Ingress | Declarado para `platform-api.local` hacia `service/platform-api:80` | `labs/03-networking-ingress/solution/ingress.yaml` |

## Automatización

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles y aplicados | `kubectl apply -f labs/03-networking-ingress/solution/` |
| Validación de laboratorio | Disponible y ejecutada | `bash labs/03-networking-ingress/validation/validate.sh`: 0 fallos, 0 avisos |
| Helm charts | No creados | Revisión del repositorio |
| Terraform modules | No creados | Revisión del repositorio |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `tutorial/03-networking-ingress/README.md` |
| Eventos | Documentados para diagnóstico | `tutorial/03-networking-ingress/README.md` |
| Logs | Documentados para aplicación y controlador | `labs/03-networking-ingress/README.md` |
| EndpointSlice | Usado como comprobación principal de endpoints | `labs/03-networking-ingress/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Conservado con valores ficticios | `labs/03-networking-ingress/solution/secret.yaml` |
| Credenciales reales | No versionadas | Revisión de manifiestos |
| TLS productivo | No incorporado | Diferido |
| Seguridad avanzada de red | No incorporada | Diferida |

## Inventario relevante

## Namespaces

| Namespace | Propósito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |
| `ingress` | Ejecutar controlador local de MicroK8s cuando el addon está habilitado | No por manifiestos del curso |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/03-networking-ingress/solution/deployment.yaml` | 2 réplicas disponibles |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running` y `Ready` |
| Controlador de Ingress | `ingress` | Gestionado por MicroK8s | Pods Ready cuando el addon está activo |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Propósito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable |
| EndpointSlice de `platform-api` | Interno del clúster | Evidencia preferente de Pods Ready |
| `ingress/platform-api` | Host `platform-api.local`, path `/` | Entrada HTTP local hacia el Service |
| Prueba HTTP local | `curl -H 'Host: platform-api.local' http://127.0.0.1/` | Validación de ingreso |

## Configuracion y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/03-networking-ingress/solution/configmap.yaml` | Configuracion no sensible y contenido HTML |
| Secret | `platform-api-secret`, `labs/03-networking-ingress/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |

## Herramientas y versiones

| Herramienta | Versión validada | Método de comprobación |
|---|---|---|
| Kubernetes | `v1.35.6` heredado | `project/project-state.md` |
| `kubectl` | `v1.35.6` heredado | `project/project-state.md` |
| MicroK8s | `v1.35.6` heredado | `project/project-state.md` |
| Helm | `v3.21.0+ge0878d4` heredado | `project/project-state.md` |
| Terraform | `1.15.7` heredado | `project/project-state.md` |

## Decisiones tomadas

## D-03-01 - Service interno conservado como backend estable

### Decisión

La unidad conserva `service/platform-api` como `ClusterIP` y lo usa como backend del recurso `Ingress`.

### Motivo

Ingress complementa al Service como capa de entrada HTTP, no lo sustituye.

### Consecuencias

- los diagnosticos empiezan por Pods, Service y EndpointSlice;
- la Unidad 04 hereda un Service interno estable y una entrada HTTP local.

### Ámbito

Especifica de la unidad y registrada en `project/project-state.md`.

## D-03-02 - Ingress Controller local como dependencia explícita de MicroK8s

### Decisión

El laboratorio documenta el addon Ingress de MicroK8s como controlador local y usa `ingressClassName: public`.

### Motivo

Permite validar la API `Ingress` sin introducir Helm, cloud ni controladores externos.

### Consecuencias

- el paso es específico de MicroK8s;
- no se extrapola a AKS, EKS o plataformas corporativas.

### Ámbito

Especifica de la unidad.

## D-03-03 - HTTP local antes que TLS productivo

### Decisión

La unidad usa HTTP local con host `platform-api.local`.

### Motivo

TLS introduce identidad, certificados, confianza y renovación, fuera del alcance actual.

### Consecuencias

- no se versionan claves privadas ni certificados;
- TLS queda diferido.

### Ámbito

Especifica de la unidad.

## D-03-04 - Gateway API como comparación, no como eje operativo

### Decisión

Gateway API se explica conceptualmente y no se crean `GatewayClass`, `Gateway` ni `HTTPRoute`.

### Motivo

Mantener complejidad controlada y depender solo de capacidades locales ya planificadas.

### Consecuencias

- la migración o práctica con Gateway API queda diferida;
- el alumno entiende por que existe sin mezclar APIs en el laboratorio.

### Ámbito

Especifica de la unidad.

## Validaciones

## Validaciones ejecutadas

| Validación | Comando o procedimiento | Resultado observado |
|---|---|---|
| Generación de artefactos | Revisión de rutas creadas | Tutorial, instructor notes, summary, laboratorio, starter, solution y validación creados |
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | 0 fallos, 0 avisos |
| Estado Unidad 02 | `bash labs/02-configuration-lifecycle/validation/validate.sh` | 0 fallos, 0 avisos |
| Addon Ingress de MicroK8s | `microk8s enable ingress` y `microk8s status --wait-ready` | `ingress` habilitado; Traefik `v3.6.2` desplegado; `IngressClass/public` disponible |
| Aplicación de manifiestos | `kubectl apply -f labs/03-networking-ingress/solution/` | Namespace, ConfigMap, Secret, Deployment, Service e Ingress aplicados sin errores |
| Rollout Unidad 03 | `kubectl -n platform-training rollout status deployment/platform-api --timeout=120s` | `deployment "platform-api" successfully rolled out` |
| Validación funcional Unidad 03 | `bash labs/03-networking-ingress/validation/validate.sh` | 0 fallos, 0 avisos; DNS interno, EndpointSlice, Ingress Controller, Ingress y HTTP validados |

## Validaciones estáticas realizadas

| Validación | Método | Resultado |
|---|---|---|
| Sintaxis Bash | `bash -n labs/03-networking-ingress/validation/validate.sh` | Código de salida 0 |
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/03-networking-ingress/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | `rg` sobre `labs/03-networking-ingress` y `tutorial/03-networking-ingress` | Sin credenciales reales; solo una frase documental sobre no versionar credenciales |
| Ausencia de charts Helm del curso | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform del curso | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

## Validaciones no ejecutadas

| Validación pendiente | Motivo | Responsable o momento |
|---|---|---|
| ShellCheck | `shellcheck` no está instalado en el entorno actual | Cuando la herramienta esté disponible |
| Validaciones funcionales nuevas de fase 4 | Alcance documental del saneamiento; el usuario pidió no ejecutarlas | No aplica en este incremento |
| Revisión pedagógica específica del saneamiento | Aprobada por el usuario el 2026-07-27 | Cerrada |

## Limitaciones y continuidad

- `labs/03-networking-ingress/solution/` es la nueva base para Unidad 04.
- `labs/02-configuration-lifecycle/solution/` permanece como evidencia histórica de Unidad 02.
- La validación funcional del Ingress se ejecutó con MicroK8s y addon Ingress activo.
- La prueba HTTP funciono con `http://127.0.0.1/`; en otros entornos WSL puede requerir ajustar `INGRESS_URL`.
- El addon Ingress instala CRDs de Gateway API, pero la Unidad 03 no crea recursos Gateway API como parte del laboratorio.
- La deuda pedagógica profunda de los README sigue abierta para una fase posterior.
- El saneamiento documental no modificó `labs/03-networking-ingress/`, no creó workloads nuevos y no cambió manifiestos Kubernetes.
