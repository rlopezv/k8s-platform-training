# Roadmap del itinerario

## Propósito

Este documento define la evolución prevista del itinerario de formación Kubernetes.

Su función es establecer:

- la secuencia de unidades;
- las dependencias entre unidades;
- las capacidades técnicas incorporadas progresivamente;
- los resultados esperados de cada etapa;
- la transición desde el laboratorio local hasta AKS y EKS;
- los límites de alcance de cada unidad.

El roadmap describe trabajo previsto. El estado real de implementación se mantiene exclusivamente en `project/project-state.md`.

---

# Principios del roadmap

## 1. Laboratorio único y evolutivo

Todas las unidades deben ampliar una única solución técnica.

Cada unidad reutilizará:

- el entorno preparado anteriormente;
- la aplicación o sistema funcional existente;
- los manifiestos, charts y módulos ya creados;
- las convenciones adoptadas;
- las validaciones disponibles;
- el estado consolidado del proyecto.

No se crearán aplicaciones independientes por unidad salvo justificación técnica o pedagógica explícita.

## 2. Complejidad progresiva

El itinerario avanzará desde:

1. preparación del entorno;
2. fundamentos operativos de Kubernetes;
3. despliegue y configuración de workloads;
4. empaquetado y automatización;
5. entrega continua y GitOps;
6. observabilidad;
7. seguridad y escalado;
8. operación en plataformas gestionadas.

Cada unidad debe introducir únicamente la complejidad necesaria para sus objetivos.

## 3. Portabilidad

Las primeras unidades se ejecutarán sobre MicroK8s, pero los artefactos deberán diseñarse para facilitar su migración posterior a AKS y EKS.

Las dependencias específicas de plataforma deberán:

- identificarse;
- aislarse;
- parametrizarse cuando sea posible;
- documentarse en los resúmenes y en el estado del proyecto.

## 4. Infraestructura y aplicación evolucionan conjuntamente

El curso no debe limitarse a explicar recursos Kubernetes de forma aislada.

La plataforma, la aplicación, la automatización y la operación deberán evolucionar de manera coordinada.

## 5. Roadmap adaptable

La secuencia podrá revisarse cuando:

- una dependencia técnica lo requiera;
- una unidad resulte demasiado amplia;
- sea necesario introducir una unidad intermedia;
- cambien las herramientas corporativas;
- se identifique una mejora pedagógica relevante.

Los cambios deberán actualizar también:

- `project/architecture.md`, cuando afecten a decisiones estructurales;
- `project/project-state.md`;
- los playbooks afectados.

---

# Fases del itinerario

| Fase | Objetivo |
|---|---|
| 0 — Bootstrap | Construir el framework del repositorio |
| 1 — Plataforma local | Preparar y validar MicroK8s sobre WSL2 |
| 2 — Fundamentos Kubernetes | Desplegar y operar la primera versión de la solución |
| 3 — Empaquetado e infraestructura como código | Introducir Helm y Terraform |
| 4 — Entrega continua y GitOps | Incorporar Tekton y Argo CD |
| 5 — Observabilidad | Incorporar métricas, logs, trazas y telemetría |
| 6 — Seguridad y escalado | Endurecer la plataforma y añadir escalado avanzado |
| 7 — Plataformas gestionadas | Migrar y operar la solución en AKS y EKS |
| 8 — Operación avanzada | Consolidar fiabilidad, gobierno y evolución |

---

# Secuencia prevista de unidades

## Fase 0 — Bootstrap del repositorio

Esta fase no contiene formación para alumnos.

### Bootstrap-01 — README

Estado actual: completado.

Resultado:

- propósito del repositorio;
- estructura general;
- mecanismo de generación;
- criterios de bootstrap.

### Bootstrap-02 — Arquitectura

Estado actual: completado.

Resultado:

- arquitectura lógica;
- responsabilidades;
- restricciones;
- decisiones iniciales.

### Bootstrap-03 — Estado del proyecto

Estado actual: completado.

Resultado:

- estado consolidado inicial;
- restricciones activas;
- siguiente incremento permitido.

### Bootstrap-04 — Roadmap

Estado actual: completado.

Resultado:

- secuencia prevista de unidades;
- dependencias;
- capacidades incorporadas;
- criterios de evolución.

### Bootstrap-05 — Playbook maestro

Estado actual: completado.

Resultado:

- reglas obligatorias de generación;
- proceso de lectura de contexto;
- validación;
- actualización del estado;
- tratamiento de inconsistencias.

### Bootstrap-06 — Plantilla de unidad

Estado actual: completado.

Resultado:

- estructura común para los playbooks específicos.

### Bootstrap-07 — Plantilla de resumen

Estado actual: completado.

Resultado:

- contrato de continuidad entre unidades.

### Bootstrap-08 — Plantilla de estado

Estado actual: completado.

Resultado:

- formato y reglas para mantener `project/project-state.md`.

### Bootstrap-09 — Playbook de la Unidad 0

Estado actual: completado.

Resultado:

- alcance, entradas, entregables y validaciones de la preparación del entorno.

---

# Fase 1 — Plataforma local

## Unidad 00 — Preparación del entorno

Ruta prevista del tutorial:

```text
tutorial/00-environment/
```

Ruta de artefactos:

```text
platform/environment/
```

### Objetivos

- validar Windows 11 como host;
- preparar WSL2;
- utilizar Ubuntu LTS;
- instalar y configurar MicroK8s;
- configurar acceso a Kubernetes;
- instalar herramientas base;
- establecer procedimientos de validación y diagnóstico.

### Capacidades previstas

- configuración de WSL2;
- instalación reproducible de MicroK8s;
- gestión de permisos y grupos;
- acceso mediante `kubectl` o alias compatible;
- addons mínimos;
- Helm;
- Terraform;
- scripts de comprobación;
- procedimientos de reset y recuperación.

### Dependencias

- bootstrap completo;
- versiones de herramientas definidas;
- playbook específico aprobado.

### Resultado de salida

Un entorno local validado y preparado para desplegar la solución evolutiva.

---

# Fase 2 — Fundamentos Kubernetes

## Unidad 01 — Fundamentos operativos y primera aplicación

### Objetivos

- comprender la arquitectura básica de Kubernetes;
- introducir la aplicación evolutiva del curso;
- desplegar el primer workload;
- utilizar recursos declarativos;
- validar estado y eventos.

### Capacidades previstas

- namespaces;
- Pods;
- Deployments;
- ReplicaSets;
- Services;
- labels y selectors;
- comandos de inspección;
- logs;
- eventos;
- primera versión de la aplicación.

### Dependencias

- Unidad 00 completada.

### Resultado de salida

Primera versión funcional de la solución desplegada en MicroK8s.

## Unidad 02 — Configuración, secretos y ciclo de vida

### Objetivos

- desacoplar configuración e imagen;
- gestionar información sensible de laboratorio;
- controlar health checks y terminación.

### Capacidades previstas

- ConfigMaps;
- Secrets con valores no reales;
- variables de entorno;
- volúmenes de configuración;
- liveness probes;
- readiness probes;
- startup probes;
- requests y limits iniciales;
- graceful shutdown.

### Dependencias

- aplicación desplegada en la Unidad 01.

### Resultado de salida

Aplicación configurable, verificable y preparada para operación básica.

## Unidad 03 — Networking e ingreso

### Objetivos

- exponer la aplicación de manera controlada;
- comprender el networking interno;
- introducir entrada HTTP al clúster.

### Capacidades previstas

- ClusterIP;
- DNS interno;
- Ingress Controller;
- Ingress;
- TLS local cuando sea razonable;
- reglas de enrutamiento;
- diagnóstico de conectividad.

### Dependencias

- Services existentes;
- addons de red validados.

### Resultado de salida

Aplicación accesible mediante un punto de entrada estable.

## Unidad 04 — Persistencia y estado

### Objetivos

- introducir workloads con persistencia;
- comprender abstracciones de almacenamiento;
- documentar diferencias entre entorno local y cloud.

### Capacidades previstas

- volumes;
- PersistentVolumes;
- PersistentVolumeClaims;
- StorageClasses;
- StatefulSets cuando la solución lo requiera;
- backup y recuperación básica;
- particularidades de almacenamiento en MicroK8s.

### Dependencias

- aplicación y networking operativos.

### Resultado de salida

Solución capaz de manejar datos persistentes con procedimientos básicos de recuperación.

## Unidad 05 — Scheduling, resiliencia y mantenimiento

### Objetivos

- controlar la colocación de workloads;
- mejorar disponibilidad;
- introducir operaciones de mantenimiento.

### Capacidades previstas

- affinities y anti-affinities;
- taints y tolerations;
- PodDisruptionBudgets;
- rolling updates;
- rollback;
- Jobs y CronJobs cuando sean aplicables;
- estrategias de despliegue;
- simulación controlada de fallos.

### Dependencias

- workloads configurados y observables mediante herramientas nativas.

### Resultado de salida

Solución con comportamiento de despliegue y recuperación documentado.

---

# Fase 3 — Empaquetado e infraestructura como código

## Unidad 06 — Empaquetado con Helm

### Objetivos

- convertir los manifiestos acumulados en un chart mantenible;
- parametrizar diferencias de entorno;
- gestionar releases.

### Capacidades previstas

- estructura de charts;
- templates;
- values;
- helpers;
- linting;
- instalación y upgrade;
- rollback;
- gestión de versiones;
- separación de valores por entorno.

### Dependencias

- conjunto estable de manifiestos acumulados.

### Resultado de salida

La solución se despliega y actualiza mediante Helm.

## Unidad 07 — Automatización local con Terraform

### Objetivos

- introducir infraestructura como código;
- automatizar componentes compatibles del entorno y del despliegue;
- definir límites entre Terraform, Helm y Kubernetes.

### Capacidades previstas

- providers;
- estado de Terraform;
- variables y outputs;
- módulos iniciales;
- provider Kubernetes;
- provider Helm;
- gestión de dependencias;
- validación y plan;
- tratamiento seguro de valores sensibles.

### Dependencias

- chart Helm funcional;
- decisiones sobre responsabilidades de cada herramienta.

### Resultado de salida

Infraestructura y releases principales gestionables mediante Terraform.

---

# Fase 4 — Entrega continua y GitOps

## Unidad 08 — Integración continua con Tekton

### Objetivos

- crear un pipeline Kubernetes-native;
- preparar la sustitución progresiva de Azure Pipelines;
- automatizar validación y construcción.

### Capacidades previstas

- Tasks;
- Pipelines;
- Workspaces;
- Params;
- Results;
- PipelineRuns;
- validación de manifiestos, Helm y Terraform;
- construcción de imágenes cuando el laboratorio lo permita;
- gestión de credenciales mediante mecanismos seguros de laboratorio.

### Dependencias

- aplicación y artefactos versionados;
- estrategia de imágenes definida;
- Helm y Terraform disponibles.

### Resultado de salida

Pipeline Tekton capaz de validar y preparar una nueva versión de la solución.

## Unidad 09 — GitOps con Argo CD

### Objetivos

- separar integración continua y entrega;
- convertir Git en fuente declarativa del despliegue;
- gestionar sincronización y drift.

### Capacidades previstas

- instalación de Argo CD;
- Applications;
- Projects;
- sincronización manual y automática;
- health y sync status;
- rollback GitOps;
- gestión inicial de secretos;
- integración con artefactos Helm;
- relación con Tekton.

### Dependencias

- chart Helm;
- repositorio estructurado;
- pipeline CI inicial.

### Resultado de salida

Despliegue de la solución controlado mediante GitOps.

## Unidad 10 — Promoción entre entornos

### Objetivos

- introducir entornos lógicos;
- promover cambios sin duplicar la solución;
- establecer estrategia de configuración.

### Capacidades previstas

- valores por entorno;
- overlays o composición cuando proceda;
- promoción basada en Git;
- políticas de aprobación;
- versionado de imágenes y charts;
- separación de configuración y secretos;
- trazabilidad de releases.

### Dependencias

- Tekton y Argo CD operativos.

### Resultado de salida

Flujo reproducible para promover una versión entre entornos definidos.

---

# Fase 5 — Observabilidad

## Unidad 11 — Métricas con Prometheus y OpenMetrics

### Objetivos

- desplegar monitorización de métricas;
- instrumentar o exponer métricas de la aplicación;
- comprender el modelo OpenMetrics.

### Capacidades previstas

- Prometheus;
- exporters;
- ServiceMonitor o mecanismo equivalente;
- métricas de aplicación;
- métricas de plataforma;
- consultas PromQL;
- reglas iniciales;
- validación del formato OpenMetrics.

### Dependencias

- aplicación estable;
- endpoint de métricas o componente instrumentable.

### Resultado de salida

Métricas de plataforma y aplicación recopiladas y consultables.

## Unidad 12 — Visualización y alertas con Grafana

### Objetivos

- construir dashboards operativos;
- definir alertas accionables;
- vincular señales con objetivos de servicio iniciales.

### Capacidades previstas

- Grafana;
- datasources;
- dashboards versionados;
- provisioning;
- alert rules;
- contacto o receptor de laboratorio;
- indicadores RED y USE;
- primeros SLI y SLO de carácter didáctico.

### Dependencias

- Prometheus operativo.

### Resultado de salida

Paneles y alertas reproducibles para la solución evolutiva.

## Unidad 13 — Logs con Loki

### Objetivos

- centralizar logs;
- estructurar consultas;
- correlacionar logs con workloads y releases.

### Capacidades previstas

- Loki;
- agente de recolección compatible;
- labels;
- LogQL;
- retención de laboratorio;
- dashboards de logs;
- buenas prácticas de cardinalidad;
- asociación con metadatos Kubernetes.

### Dependencias

- Grafana disponible;
- estrategia de logging de la aplicación definida.

### Resultado de salida

Logs centralizados y consultables desde Grafana.

## Unidad 14 — Trazas con Tempo y OpenTelemetry

### Objetivos

- incorporar trazabilidad distribuida;
- instrumentar la aplicación;
- correlacionar métricas, logs y trazas.

### Capacidades previstas

- OpenTelemetry SDK o auto-instrumentation;
- OpenTelemetry Collector;
- OTLP;
- Tempo;
- propagación de contexto;
- exemplars cuando sean viables;
- exploración de trazas en Grafana;
- diagnóstico de latencia.

### Dependencias

- aplicación apta para instrumentación;
- Grafana operativo;
- métricas y logs disponibles.

### Resultado de salida

Trazas distribuidas integradas con el stack de observabilidad.

## Unidad 15 — Observabilidad operativa integrada

### Objetivos

- consolidar las señales;
- crear procedimientos de diagnóstico;
- introducir prácticas de respuesta operativa.

### Capacidades previstas

- correlación de señales;
- runbooks;
- alertas con contexto;
- dashboards de servicio;
- diagnóstico de incidentes simulados;
- revisión de SLI y SLO;
- control de coste y cardinalidad en laboratorio.

### Dependencias

- Prometheus;
- Grafana;
- Loki;
- Tempo;
- OpenTelemetry.

### Resultado de salida

Sistema de observabilidad integrado con procedimientos de operación.

---

# Fase 6 — Seguridad y escalado

## Unidad 16 — Seguridad de workloads y acceso

### Objetivos

- reducir privilegios;
- controlar acceso al clúster;
- aplicar políticas básicas.

### Capacidades previstas

- RBAC;
- ServiceAccounts;
- security contexts;
- Pod Security Standards;
- NetworkPolicies;
- manejo de imágenes;
- secretos;
- escaneo o validación de configuración;
- auditoría de permisos.

### Dependencias

- solución desplegada mediante automatización;
- observabilidad operativa.

### Resultado de salida

Workloads y accesos endurecidos con controles verificables.

## Unidad 17 — Políticas y seguridad de la cadena de suministro

### Objetivos

- aplicar controles preventivos;
- mejorar trazabilidad de artefactos;
- proteger el flujo CI/CD.

### Capacidades previstas

- policy as code;
- validación de admisión;
- firma o verificación de imágenes cuando sea viable;
- SBOM;
- controles en Tekton;
- controles en GitOps;
- gestión de excepciones;
- evidencias de cumplimiento.

### Dependencias

- Tekton;
- Argo CD;
- seguridad base.

### Resultado de salida

Cadena de entrega con políticas y verificaciones integradas.

## Unidad 18 — Escalado con HPA y KEDA

### Objetivos

- introducir escalado basado en recursos y eventos;
- comparar mecanismos;
- validar comportamiento y límites.

### Capacidades previstas

- Metrics Server;
- HorizontalPodAutoscaler;
- métricas custom o external;
- KEDA;
- ScaledObjects;
- triggers;
- pruebas de carga;
- estabilización;
- límites y efectos sobre disponibilidad.

### Dependencias

- métricas operativas;
- requests y limits definidos;
- aplicación susceptible de escalado.

### Resultado de salida

Solución capaz de escalar mediante señales de recursos y eventos.

---

# Fase 7 — Plataformas Kubernetes gestionadas

## Unidad 19 — Fundamentos de migración a cloud

### Objetivos

- identificar dependencias locales;
- preparar artefactos portables;
- definir estrategia común para AKS y EKS.

### Capacidades previstas

- inventario de acoplamientos a MicroK8s;
- externalización de almacenamiento;
- ingress y load balancers;
- identidad;
- DNS;
- registros de imágenes;
- secretos;
- módulos Terraform reutilizables;
- estrategia de costes y teardown.

### Dependencias

- solución local completa;
- automatización con Terraform;
- GitOps y observabilidad definidos.

### Resultado de salida

Plan y baseline técnico de migración a plataformas gestionadas.

## Unidad 20 — Despliegue en AKS

### Objetivos

- provisionar AKS;
- desplegar la solución;
- adaptar identidad, red, almacenamiento y observabilidad.

### Capacidades previstas

- Terraform para Azure;
- resource groups;
- networking;
- AKS;
- Azure Container Registry cuando proceda;
- identidad administrada;
- integración con Helm y Argo CD;
- almacenamiento gestionado;
- ingress;
- validación y teardown.

### Dependencias

- Unidad 19;
- suscripción y credenciales fuera del repositorio.

### Resultado de salida

Solución operativa en AKS mediante infraestructura como código y GitOps.

## Unidad 21 — Despliegue en EKS

### Objetivos

- provisionar EKS;
- desplegar la misma solución;
- comparar decisiones con AKS.

### Capacidades previstas

- Terraform para AWS;
- VPC;
- EKS;
- IAM;
- Elastic Container Registry cuando proceda;
- almacenamiento gestionado;
- ingress;
- integración con Helm y Argo CD;
- validación y teardown.

### Dependencias

- Unidad 19;
- cuenta y credenciales fuera del repositorio.

### Resultado de salida

Solución operativa en EKS mediante infraestructura como código y GitOps.

## Unidad 22 — Comparativa operativa MicroK8s, AKS y EKS

### Objetivos

- comparar operación y arquitectura;
- identificar elementos comunes y específicos;
- consolidar una estrategia multiplataforma.

### Capacidades previstas

- diferencias de red;
- identidad;
- almacenamiento;
- upgrades;
- observabilidad;
- seguridad;
- escalado;
- costes;
- responsabilidades compartidas;
- portabilidad de artefactos.

### Dependencias

- despliegues completados en las tres plataformas.

### Resultado de salida

Modelo comparativo y conjunto de decisiones para operación multiplataforma.

---

# Fase 8 — Operación avanzada

## Unidad 23 — Fiabilidad, continuidad y recuperación

### Objetivos

- diseñar procedimientos de continuidad;
- probar recuperación;
- vincular arquitectura y objetivos de servicio.

### Capacidades previstas

- backup;
- restore;
- recuperación de configuración;
- recuperación de datos;
- pruebas de fallo;
- RPO y RTO didácticos;
- runbooks;
- validación de dependencias externas.

### Dependencias

- observabilidad y plataformas gestionadas disponibles.

### Resultado de salida

Procedimientos probados de continuidad y recuperación.

## Unidad 24 — Gobierno y operación de plataforma

### Objetivos

- consolidar prácticas de plataforma;
- definir estándares reutilizables;
- preparar evolución organizativa.

### Capacidades previstas

- golden paths;
- plantillas;
- ownership;
- políticas;
- catálogo de capacidades;
- gestión de versiones;
- mantenimiento;
- métricas de plataforma;
- adopción progresiva;
- límites del modelo.

### Dependencias

- itinerario técnico completado.

### Resultado de salida

Modelo operativo para evolucionar la solución hacia una plataforma interna mantenible.

## Unidad 25 — Proyecto final integrado

### Objetivos

- demostrar dominio del itinerario;
- desplegar y operar una evolución completa de la solución;
- justificar decisiones.

### Capacidades previstas

- infraestructura como código;
- Helm;
- CI con Tekton;
- GitOps con Argo CD;
- observabilidad completa;
- seguridad;
- escalado;
- despliegue local y en al menos una plataforma gestionada;
- validaciones;
- documentación de arquitectura;
- operación ante incidentes simulados.

### Dependencias

- todas las capacidades requeridas completadas.

### Resultado de salida

Implementación integral revisable como proyecto profesional de ingeniería de plataforma.

---

# Matriz de incorporación tecnológica

| Tecnología | Primera incorporación prevista | Consolidación |
|---|---|---|
| MicroK8s | Unidad 00 | Unidades 01–19 |
| Kubernetes | Unidad 01 | Todo el itinerario |
| Helm | Unidad 06 | Unidades 07–25 |
| Terraform | Unidad 07 | Unidades 19–25 |
| Tekton | Unidad 08 | Unidades 10, 17 y 25 |
| Argo CD | Unidad 09 | Unidades 10–25 |
| Prometheus | Unidad 11 | Unidades 12–25 |
| OpenMetrics | Unidad 11 | Unidades 12–18 |
| Grafana | Unidad 12 | Unidades 13–25 |
| Loki | Unidad 13 | Unidades 15–25 |
| OpenTelemetry | Unidad 14 | Unidades 15–25 |
| Tempo | Unidad 14 | Unidades 15–25 |
| Seguridad | Unidad 16 | Unidades 17–25 |
| KEDA | Unidad 18 | Unidades 19–25 |
| AKS | Unidad 20 | Unidades 22–25 |
| EKS | Unidad 21 | Unidades 22–25 |

---

# Dependencias principales

```text
00 Environment
      ↓
01–05 Kubernetes foundations
      ↓
06 Helm
      ↓
07 Terraform
      ↓
08 Tekton ──────┐
      ↓          │
09 Argo CD       │
      ↓          │
10 Promotion     │
      ↓          │
11–15 Observability
      ↓
16–17 Security
      ↓
18 Scaling
      ↓
19 Cloud migration baseline
      ├── 20 AKS
      └── 21 EKS
             ↓
22 Platform comparison
      ↓
23–24 Advanced operations
      ↓
25 Final project
```

Algunas unidades podrán desarrollarse parcialmente en paralelo durante la implementación, pero la generación del contenido deberá respetar las dependencias declaradas.

---

# Criterios comunes de entrada

Una unidad podrá comenzar cuando:

- la unidad anterior esté cerrada;
- exista su `summary.md`;
- `project/project-state.md` esté actualizado;
- sus dependencias técnicas estén disponibles;
- exista un playbook específico aprobado;
- no haya inconsistencias abiertas que impidan avanzar.

# Criterios comunes de salida

Una unidad se considerará completada cuando:

- exista documentación del alumno;
- exista laboratorio ejecutable o artefactos equivalentes;
- existan notas del instructor;
- exista `summary.md`;
- se hayan ejecutado o documentado las validaciones;
- se haya actualizado `project/project-state.md`;
- los artefactos reutilicen la solución previa;
- no se hayan introducido secretos reales;
- las decisiones relevantes estén registradas.

---

# Decisiones pendientes antes de generar unidades

## Aplicación evolutiva

Antes de la Unidad 01 deberá definirse la aplicación o sistema funcional que evolucionará durante el curso.

Deberá permitir incorporar progresivamente:

- configuración;
- persistencia;
- networking;
- métricas;
- logs;
- trazas;
- escalado;
- despliegues;
- seguridad;
- operación en cloud.

## Granularidad definitiva

La numeración y separación de unidades constituye una propuesta inicial.

Los playbooks podrán recomendar:

- dividir una unidad;
- fusionar unidades;
- introducir unidades de refuerzo;
- mover una capacidad.

Cualquier cambio deberá actualizar este documento antes de generar contenido afectado.

## Estrategia de repositorios e imágenes

Antes de Tekton deberá definirse:

- ubicación del código de la aplicación;
- estrategia de construcción;
- registro de imágenes local o remoto;
- versionado;
- credenciales;
- relación entre repositorio formativo y repositorio de aplicación, si fueran distintos.

## Estrategia de cloud

Antes de las unidades de AKS y EKS deberá definirse:

- modelo de cuentas;
- regiones permitidas;
- límites de coste;
- estrategia de destrucción;
- gestión de identidad;
- backend de Terraform;
- tratamiento de recursos compartidos.

---

# Fuera de alcance inicial

Salvo revisión posterior del roadmap, quedan fuera del alcance inicial:

- desarrollo profundo de operadores Kubernetes;
- service mesh como eje principal;
- multi-cluster avanzado;
- Kubernetes bare metal de producción;
- gestión completa de costes FinOps;
- certificación formal de cumplimiento;
- arquitecturas serverless no basadas en Kubernetes;
- administración exhaustiva de Windows containers;
- entrenamiento específico para exámenes de certificación.

Estas materias podrán introducirse como ampliaciones si el itinerario principal está consolidado.

---

# Mantenimiento del roadmap

Este documento deberá revisarse:

- al completar cada fase;
- cuando cambien las prioridades técnicas;
- cuando se incorpore o retire una herramienta;
- cuando una unidad revele dependencias no previstas;
- antes de añadir una unidad nueva;
- antes de alterar la secuencia;
- cuando cambie el proyecto final.

Una modificación del roadmap no implica que una capacidad esté implementada. El cambio deberá reflejarse separadamente en `project/project-state.md`.
