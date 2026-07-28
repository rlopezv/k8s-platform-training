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
├── student-notes.md
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
├── student-notes.md
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

### 7.6. Sesión de desarrollo pedagógico de guías del alumno

Se utiliza cuando una o varias unidades ya tienen contenido técnico, laboratorio y validaciones suficientes, pero el material dirigido al alumno todavía no ofrece soporte formativo adecuado para personas que no dominan el tema.

Esta sesión no debe crear nuevas capacidades técnicas ni avanzar el roadmap funcional. Su objetivo es desarrollar el material pedagógico de la unidad, separando responsabilidades:

* `README.md` como puerta de entrada, mapa de aprendizaje y orientación;
* `student-notes.md` como guía de aprendizaje con estructura académica y aplicada;
* `labs/<unidad>/README.md` como guía operativa del laboratorio.

La guía del alumno debe:

* presentar qué se va a cubrir;
* explicar qué representa cada componente antes de ligarlo al laboratorio;
* describir qué se va a construir;
* mostrar cómo se relacionan las piezas;
* explicar qué ocurre al aplicar los artefactos;
* indicar cómo comprobar que funciona;
* incluir diagnóstico de fallos típicos;
* conectar con la unidad siguiente;
* cerrar con fuentes de referencia oficiales o primarias.

Debe evitar estructuras excesivamente densas para el alumno, como catálogos extensos de invariantes, glosarios razonados obligatorios, anexos largos o matrices que sustituyan a una progresión didáctica clara.

Puede planificarse como fase posterior cuando convenga avanzar primero en varias unidades técnicas y revisar después la progresión completa del itinerario.

### 7.7. Sesión de reapertura de framework didáctico

Se utiliza cuando el contenido generado revela que las reglas del framework necesitan evolucionar para mejorar la calidad formativa del itinerario antes de seguir incorporando herramientas nuevas.

Esta sesión no es una unidad formativa numerada. No debe crear capacidades técnicas nuevas, instalar herramientas, modificar el estado funcional del clúster ni avanzar el roadmap operativo. Su objetivo es ajustar el contrato de generación para que futuras unidades y revisiones transversales mantengan una didáctica consistente.

Debe producir, como mínimo:

* reglas ligeras para usar `student-reference.md` cuando `student-notes.md` necesite apoyo de referencia, visión general o profundidad técnica sin crecer indefinidamente;
* registro de lagunas de contenido aplicable a unidades ya generadas y futuras;
* criterios simples para decidir si una laguna se corrige en una unidad existente, en `student-reference.md`, en una unidad nueva o en el roadmap;
* actualización de `project/project-state.md` con la pausa del roadmap funcional y el siguiente incremento permitido.

La sesión debe preservar la separación entre:

* framework pedagógico;
* revisión documental de unidades existentes;
* generación de nuevas unidades técnicas.

### 7.8. Sesión de revisión didáctica transversal

Se utiliza después de ajustar el framework didáctico, para revisar unidades ya generadas contra los nuevos criterios.

La revisión debe comprobar, como mínimo:

* si la unidad explica el problema antes de introducir la herramienta;
* si explicita el modelo mental que soporta la unidad y su lugar dentro de Kubernetes o del ecosistema de herramientas;
* si identifica los conceptos nuevos y los retoma desde cero cuando proceda;
* si conecta con unidades anteriores y posteriores;
* si distingue teoría, práctica, diagnóstico y límites;
* si el laboratorio está apoyado por una explicación conceptual suficiente y si las lagunas de visión general quedan cubiertas por `student-reference.md` o registradas para el roadmap;
* si las fuentes de referencia están guiadas por preguntas concretas;
* si existen saltos de dificultad para alumnos que todavía no dominan el tema.

La revisión de contenido generado debe tratarse como incremento documental y pedagógico. Solo debe modificar artefactos técnicos cuando detecte una contradicción real entre explicación, laboratorio y estado validado.

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

Tras completar el saneamiento documental de Unidades 00-07, cerrar funcionalmente `TD-023` en Unidad 04 y preparar el framework mínimo para componentes de clúster, el siguiente incremento recomendado es generar el playbook de la **Unidad 08 — Integración continua con Tekton**.

La sesión de Unidad 08 debe:

1. partir del estado consolidado en `project/project-state.md`;
2. aplicar el reparto de cobertura definido en `playbooks/master.md`: práctica, criterio y diferido;
3. declarar Tekton Pipelines como componente de clúster de la unidad, usando la convención de `platform/tools/`;
4. verificar la versión vigente contra documentación oficial al generar el playbook;
5. no instalar Tekton ni crear recursos ejecutables hasta que el playbook específico esté aprobado.
