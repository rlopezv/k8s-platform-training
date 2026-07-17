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

### 4.4. Fase 4 — Unidad 1: Kubernetes

#### Objetivo

Introducir los fundamentos operativos de Kubernetes mediante el despliegue de una aplicación base en el entorno creado en la Unidad 0.

Esta aplicación será reutilizada y evolucionada durante el resto del itinerario.

#### Contenido previsto

* arquitectura básica de Kubernetes;
* recursos fundamentales;
* namespaces;
* Pods;
* Deployments;
* Services;
* ConfigMaps;
* Secrets;
* probes;
* requests y limits;
* despliegue y actualización;
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
* validar conectividad, configuración, estado y recuperación.

##### Sesión 4.4 — Corrección y cierre

Objetivo:

* corregir documentación y artefactos;
* aprobar el resumen;
* actualizar el estado del proyecto.

#### Criterio de cierre

* La aplicación se despliega correctamente.
* Los manifiestos son coherentes y reutilizables.
* El laboratorio puede ejecutarse de principio a fin.
* La aplicación queda preparada para su conversión a Helm.

---

### 4.5. Fase 5 — Unidad 2: Helm

#### Objetivo

Transformar los manifiestos de Kubernetes de la Unidad 1 en un chart Helm reutilizable y configurable.

#### Principio obligatorio

No se creará una nueva aplicación ni un ejemplo independiente.

#### Contenido previsto

* estructura de un chart;
* plantillas;
* valores;
* helpers;
* validación;
* instalación;
* actualización;
* rollback;
* empaquetado;
* buenas prácticas.

#### Sesiones recomendadas

* Diseño de la migración a Helm.
* Generación del chart y documentación.
* Validación del ciclo de vida.
* Corrección y cierre.

#### Criterio de cierre

* La aplicación se despliega mediante Helm.
* Los manifiestos originales han sido incorporados correctamente al chart.
* Los valores permiten configurar el despliegue.
* El chart está preparado para su consumo desde Terraform y Argo CD.

---

### 4.6. Fase 6 — Unidad 3: Terraform

#### Objetivo

Incorporar Terraform al ciclo de provisión y despliegue de la plataforma.

#### Contenido previsto

* estructura de configuración;
* providers;
* estado;
* variables;
* outputs;
* módulos;
* provider de Kubernetes;
* provider de Helm;
* despliegue del chart;
* preparación para AKS y EKS.

#### Sesiones recomendadas

* Diseño de la estructura Terraform.
* Generación de configuración y laboratorio.
* Validación de `plan`, `apply` y `destroy`.
* Corrección y cierre.

#### Criterio de cierre

* Terraform gestiona los recursos definidos para la unidad.
* El chart existente se reutiliza.
* El estado y las variables están documentados.
* La estructura permite evolucionar hacia plataformas gestionadas.

---

## 5. Roadmap formativo posterior

La secuencia inicial prevista es:

```text
00 Entorno de laboratorio
01 Kubernetes
02 Helm
03 Terraform
04 Argo CD
05 Tekton
06 Observabilidad
07 Seguridad
08 KEDA y escalado
09 AKS
10 EKS
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

Tras completar Bootstrap y cerrar Framework V1, el siguiente incremento recomendado es la **Unidad 00 — Preparación del entorno**.

La primera sesión de la Unidad 00 debería centrarse en:

1. revisar `playbooks/units/00-environment.md`;
2. definir versiones objetivo y requisitos mínimos;
3. decidir los addons mínimos de MicroK8s;
4. diseñar la estructura concreta de scripts en `platform/environment/`;
5. preparar el primer incremento de documentación y validaciones sin generar contenido de la Unidad 01.
