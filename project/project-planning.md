# Project Planning

## 1. Objetivo

Este documento define el plan de trabajo del proyecto, la secuencia recomendada de ejecución y la organización de las sesiones de trabajo.

Su finalidad es establecer:

* qué debe construirse;
* en qué orden;
* qué sesiones se recomiendan;
* qué artefactos debe producir cada sesión;
* qué criterios permiten considerar completada una fase o una unidad.

Este documento no describe el mecanismo operativo de interacción con asistentes de IA. Dicho procedimiento se define en `project/how-to.md`.

---

## 2. Principios de planificación

El proyecto se desarrollará de forma incremental.

Cada incremento deberá:

* partir del estado real del repositorio;
* reutilizar los artefactos existentes;
* producir un resultado coherente y validable;
* actualizar la documentación de estado;
* dejar un punto limpio de continuación.

Las unidades formativas no deben generar ejemplos independientes.

Cada unidad debe ampliar la plataforma, la aplicación, los laboratorios y los artefactos creados por las unidades anteriores.

El repositorio es la fuente única de verdad del proyecto.

---

## 3. Unidad de trabajo

La unidad de trabajo recomendada es una sesión con un objetivo concreto y verificable.

Una sesión puede corresponder a:

* una fase completa;
* una unidad formativa;
* una parte de una unidad;
* una revisión;
* una corrección;
* una validación;
* una actualización de arquitectura o roadmap.

No es obligatorio que una unidad formativa se complete en una única sesión.

Cuando una unidad requiera generación, ejecución, validación y corrección, podrá dividirse en varias sesiones.

---

## 4. Fases del proyecto

### 4.1. Fase 1 — Bootstrap del repositorio

**Estado:** completada.

#### Objetivo

Crear la estructura inicial del repositorio y establecer los documentos de gobierno, arquitectura, estado y generación.

#### Artefactos principales

```text
README.md

project/
├── architecture.md
├── roadmap.md
├── project-state.md
├── project-planning.md
└── how-to.md

playbooks/
├── master.md
├── unit-template.md
├── summary-template.md
├── project-state-template.md
├── generate-session-handoff.md
└── units/
```

#### Criterio de cierre

La fase se considera completada cuando:

* la estructura del repositorio está creada;
* la arquitectura inicial está documentada;
* el roadmap está definido;
* el estado inicial está registrado;
* los playbooks base están disponibles;
* el mecanismo de trabajo está documentado;
* los documentos han sido revisados y versionados en Git.

---

### 4.2. Fase 2 — Framework de generación

**Estado:** completada y cerrada como Framework V1.

#### Objetivo

Validar que el repositorio contiene todas las reglas, plantillas y contratos necesarios para generar unidades formativas sin depender del historial de conversaciones.

#### Trabajo completado

* Revisar `playbooks/master.md`.
* Revisar `playbooks/unit-template.md`.
* Revisar `playbooks/summary-template.md`.
* Revisar `playbooks/project-state-template.md`.
* Revisar `playbooks/generate-session-handoff.md`.
* Definir el playbook específico necesario para iniciar la Unidad 00.
* Verificar que el modelo de resumen y estado permite transferir contexto entre sesiones.
* Confirmar que el framework funciona tanto con asistentes con acceso al workspace como con asistentes conversacionales.

#### Artefactos resultantes

```text
playbooks/units/
└── 00-environment.md
```

Las estructuras iniciales de salida se materializan mediante `.gitkeep` hasta que existan artefactos reales:

```text
tutorial/
└── .gitkeep

labs/
└── .gitkeep

platform/
├── .gitkeep
└── environment/
    └── .gitkeep
```

#### Sesiones de referencia

##### Sesión 2.1 — Revisión del framework

Objetivo:

* revisar los playbooks base;
* eliminar contradicciones;
* asegurar que las entradas y salidas están claramente definidas.

Resultado:

* playbooks base aprobados;
* reglas de generación cerradas;
* dependencias entre documentos verificadas.

##### Sesión 2.2 — Playbooks de unidades iniciales

Objetivo:

* generar el playbook de la Unidad 00;
* definir sus objetivos, entradas, salidas y criterios de aceptación.

Resultado:

* playbook específico de la Unidad 00 disponible;
* secuencia inicial preparada para comenzar el itinerario.

##### Sesión 2.3 — Validación del mecanismo de continuidad

Objetivo:

* simular el cierre y arranque de una sesión;
* validar el uso de `project-state.md`, `summary.md` y `SESSION_HANDOFF.md`.

Resultado:

* mecanismo de continuidad probado;
* inconsistencias corregidas.

#### Criterio de cierre

La fase se considera completada cuando:

* un nuevo asistente puede identificar el siguiente trabajo leyendo el repositorio;
* las entradas y salidas de la Unidad 00 están definidas;
* la Unidad 0 puede comenzar sin depender de decisiones no documentadas;
* el mecanismo de cierre y apertura de sesiones ha sido validado.

---

### 4.3. Fase 3 — Unidad 0: entorno de laboratorio

#### Objetivo

Construir, documentar y validar el entorno base sobre el que se ejecutarán todas las unidades posteriores.

#### Plataforma objetivo

* Windows 11.
* WSL2.
* Ubuntu LTS.
* MicroK8s.
* `kubectl`.
* Helm.
* Terraform.
* Git.
* Azure CLI.
* AWS CLI.
* Visual Studio Code con soporte para WSL, cuando se utilice.

#### Artefactos esperados

```text
tutorial/00-environment/
├── README.md
├── instructor-notes.md
└── summary.md

platform/environment/
├── README.md
├── scripts/
└── validation/
```

#### Sesiones recomendadas

##### Sesión 3.1 — Diseño de la Unidad 0

Objetivo:

* revisar el playbook de la unidad;
* definir el flujo de instalación;
* definir los requisitos previos;
* definir las validaciones.

Resultado:

* estructura detallada de la unidad;
* lista de artefactos a generar;
* criterios de aceptación confirmados.

##### Sesión 3.2 — Generación de documentación y scripts

Objetivo:

* crear el tutorial;
* crear las notas del instructor;
* crear scripts de instalación o configuración;
* crear scripts o comandos de validación.

Resultado:

* primera versión completa de la unidad.

##### Sesión 3.3 — Ejecución y validación

Objetivo:

* ejecutar los procedimientos en el entorno real;
* registrar resultados;
* identificar errores, incompatibilidades o pasos incompletos.

Resultado:

* evidencias de validación;
* lista de correcciones.

##### Sesión 3.4 — Corrección y cierre

Objetivo:

* corregir los artefactos;
* aprobar el resumen;
* actualizar el estado del proyecto.

Resultado:

* Unidad 0 completada;
* entorno validado;
* `summary.md` aprobado;
* `project-state.md` actualizado.

#### Criterio de cierre

La unidad se considera completada cuando:

* el entorno puede instalarse o verificarse siguiendo la documentación;
* MicroK8s funciona correctamente;
* las herramientas requeridas están disponibles;
* las validaciones son reproducibles;
* los problemas conocidos están documentados;
* el resumen refleja el estado real del laboratorio.

---

### 4.4. Fase 4 — Unidad 1: Fundamentos Kubernetes

#### Objetivo

Introducir los fundamentos operativos de Kubernetes mediante el despliegue de una aplicación base en el entorno creado en la Unidad 0.

Esta aplicación será reutilizada y evolucionada durante el resto del itinerario.

#### Contenido previsto

* arquitectura básica de Kubernetes;
* control plane y nodos worker;
* `kube-apiserver`;
* `etcd`;
* `kube-scheduler`;
* `kube-controller-manager`;
* `kubelet`;
* `kube-proxy`;
* container runtime;
* CRI, CNI y CSI como interfaces de plataforma;
* recursos fundamentales;
* namespaces;
* Pods;
* Deployments;
* Services;
* mapa conceptual de ConfigMaps, Secrets, probes, requests, limits, Ingress, Gateway API y almacenamiento persistente;
* mapa conceptual de observabilidad: estado, eventos, logs, metricas, trazas y correlacion;
* despliegue y actualización;
* labels y selectors;
* logs;
* eventos;
* diagnóstico básico.

#### Artefactos esperados

```text
tutorial/01-kubernetes/
├── README.md
├── instructor-notes.md
└── summary.md

labs/01-kubernetes/
├── README.md
├── starter/
└── solution/
```

#### Sesiones recomendadas

##### Sesión 4.1 — Diseño de la aplicación base

Objetivo:

* seleccionar o definir la aplicación;
* establecer su estructura;
* definir los recursos Kubernetes necesarios;
* definir el resultado final del laboratorio.

##### Sesión 4.2 — Generación de la unidad

Objetivo:

* crear tutorial, notas, laboratorio y solución;
* generar los manifiestos Kubernetes.

##### Sesión 4.3 — Validación

Objetivo:

* desplegar la aplicación en MicroK8s;
* validar conectividad básica, estado, logs, eventos y recuperación.

##### Sesión 4.4 — Corrección y cierre

Objetivo:

* corregir documentación y artefactos;
* aprobar el resumen;
* actualizar el estado del proyecto.

#### Criterio de cierre

* La aplicación se despliega correctamente.
* Los manifiestos son coherentes y reutilizables.
* El laboratorio puede ejecutarse de principio a fin.
* La aplicación queda preparada para incorporar configuración, secretos y ciclo de vida en la Unidad 2.

---

### 4.5. Fase 5 — Unidad 2: Configuración, secretos y ciclo de vida

#### Objetivo

Ampliar la aplicación de la Unidad 1 para separar configuración, tratar secretos de laboratorio y definir comportamiento operativo básico de ciclo de vida.

#### Principio obligatorio

No se creará una nueva aplicación ni un ejemplo independiente.

#### Contenido previsto

* ConfigMaps;
* Secrets con valores no reales;
* variables de entorno;
* volúmenes de configuración;
* liveness probes;
* readiness probes;
* startup probes;
* requests y limits iniciales;
* graceful shutdown.

#### Sesiones recomendadas

* Diseño de configuración y ciclo de vida.
* Generación de manifiestos y documentación.
* Validación de configuración, secretos de laboratorio y probes.
* Corrección y cierre.

#### Criterio de cierre

* La aplicación se configura sin modificar la imagen.
* Los secretos de laboratorio no contienen credenciales reales.
* Las probes y recursos iniciales reflejan un comportamiento operativo verificable.
* La aplicación queda preparada para networking e ingreso.

---

### 4.6. Fase 6 — Unidad 3: Networking e ingreso

#### Objetivo

Exponer la aplicación de manera controlada, comprender el networking interno de Kubernetes e introducir entrada HTTP al clúster.

#### Contenido previsto

* ClusterIP;
* DNS interno;
* Service discovery;
* port-forward;
* Ingress;
* Gateway API a nivel conceptual y comparativo;
* `Gateway` y `HTTPRoute` cuando el entorno local lo permita o como artefacto diferido documentado;
* addon `ingress` de MicroK8s cuando el playbook específico lo autorice;
* diagnóstico de conectividad.

#### Sesiones recomendadas

* Diseño de exposición de la aplicación.
* Generación de manifiestos y documentación.
* Validación de conectividad interna y entrada HTTP.
* Corrección y cierre.

#### Criterio de cierre

* La aplicación se expone de forma controlada.
* La resolución DNS interna se valida.
* El acceso HTTP al clúster queda documentado y verificado.
* Las particularidades de MicroK8s quedan separadas de Kubernetes estándar.

---

## 5. Roadmap formativo posterior

La secuencia inicial prevista es:

```text
00 Entorno de laboratorio
01 Kubernetes
02 Configuración, secretos y ciclo de vida
03 Networking e ingreso
04 Persistencia y estado
05 Imágenes, registros y entrega local
06 Helm
07 Terraform
08 Tekton
09 Argo CD
10 Operación declarativa y promoción
11 Prometheus
12 Grafana
13 Loki
14 Tempo y OpenTelemetry
15 OpenMetrics
16 Seguridad de workloads
17 Seguridad de plataforma
18 KEDA y escalado
19 Preparación cloud
20 AKS
21 EKS
22 Multi-cloud y portabilidad
23 Fiabilidad operativa
24 Gobierno y costes
25 Cierre del itinerario
```

El orden podrá modificarse cuando exista una justificación técnica o pedagógica.

Cualquier cambio debe reflejarse en:

* `project/roadmap.md`;
* `project/project-state.md`;
* los playbooks afectados;
* los resúmenes de unidad, cuando corresponda.

---

## 6. Contenido recomendado de cada sesión

Cada sesión debe comenzar con:

1. objetivo concreto;
2. contexto de entrada;
3. artefactos que pueden modificarse;
4. resultado esperado;
5. criterio de cierre.

Cada sesión debe producir:

* archivos nuevos o modificados;
* rutas de destino;
* decisiones relevantes;
* validaciones realizadas o pendientes;
* problemas detectados;
* actualización propuesta del estado del proyecto.

---

## 7. Tipos de sesión

### 7.1. Sesión de diseño

Se utiliza para:

* definir alcance;
* resolver decisiones;
* preparar la estructura;
* identificar dependencias;
* fijar criterios de aceptación.

No debería generar grandes volúmenes de contenido definitivo.

### 7.2. Sesión de generación

Se utiliza para:

* crear tutoriales;
* crear laboratorios;
* generar scripts;
* generar configuraciones;
* crear documentación de instructor.

### 7.3. Sesión de validación

Se utiliza para:

* ejecutar comandos;
* probar scripts;
* verificar configuraciones;
* registrar resultados;
* identificar problemas.

### 7.4. Sesión de corrección

Se utiliza para:

* resolver errores;
* ajustar artefactos;
* actualizar documentación;
* cerrar pendientes.

### 7.5. Sesión de cierre

Se utiliza para:

* aprobar el incremento;
* generar o revisar `summary.md`;
* actualizar `project-state.md`;
* revisar `roadmap.md` y `architecture.md`;
* realizar el commit;
* preparar el siguiente handoff.

---

## 8. Criterios generales de cierre

Una fase, unidad o incremento no debe considerarse completado únicamente porque los archivos hayan sido generados.

Debe comprobarse que:

* los artefactos existen en las rutas previstas;
* la documentación es consistente;
* las dependencias están disponibles;
* los procedimientos han sido validados cuando sea posible;
* los resultados reales coinciden con lo documentado;
* los problemas conocidos están registrados;
* el resumen está actualizado;
* el estado del proyecto refleja la situación real;
* el repositorio se encuentra en un punto limpio de continuación.

---

## 9. Próximo trabajo recomendado

El siguiente incremento recomendado vigente se registra en `project/project-state.md`, que debe prevalecer sobre esta sección cuando el itinerario avance.

Tras completar la Unidad 01, el siguiente incremento recomendado es generar el playbook de la **Unidad 02 — Configuración, secretos y ciclo de vida**.

Esa sesión debería centrarse en:

1. leer `tutorial/01-kubernetes/summary.md`;
2. reutilizar `labs/01-kubernetes/solution/`;
3. definir el alcance exacto de ConfigMaps, Secrets de laboratorio, probes y recursos;
4. mantener `platform-api` y `platform-training` como base evolutiva;
5. evitar Helm, Terraform, CI/CD, GitOps, observabilidad avanzada y cloud hasta sus unidades previstas.
