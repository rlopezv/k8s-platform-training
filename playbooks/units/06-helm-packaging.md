# Playbook de la Unidad 06 - Empaquetado con Helm

## Identificacion

### Unidad

```text
06 - Empaquetado con Helm
```

### Identificador

```text
06-helm-packaging
```

### Fase del roadmap

```text
Fase 3 - Empaquetado e infraestructura como codigo
```

### Estado del playbook

```text
Aprobado por instruccion de generacion
```

### Propietario logico

```text
Empaquetado e infraestructura como codigo
```

---

# Proposito de la unidad

La Unidad 06 introduce Helm como mecanismo de empaquetado, parametrizacion y gestion de releases para la aplicacion evolutiva `platform-api`. La unidad parte de los manifiestos Kubernetes estables de `labs/05-scheduling-resilience-maintenance/solution/`, que ya incluyen configuracion externa, Secret ficticio, probes, requests/limits, Service, Ingress, PVC, estrategia de `RollingUpdate`, constraints seguros de scheduling y `PodDisruptionBudget`.

Esta unidad aparece despues de scheduling y resiliencia porque Helm no debe ocultar decisiones operativas que el alumno todavia no comprende. El objetivo es convertir manifiestos conocidos en un chart mantenible, explicar como el motor de plantillas transforma texto en YAML Kubernetes y preparar la separacion futura entre Helm y Terraform.

## Supuesto pedagogico

La unidad debe escribirse para alumnos con perfil tecnico que han usado YAML Kubernetes declarativo, pero todavia no dominan Helm, templates de Go, jerarquia de valores ni gestion de releases.

Se explicaran desde cero:

- que es un chart, una template, un values file y un release de Helm;
- como Helm renderiza templates hacia manifiestos Kubernetes;
- como funciona el objeto de contexto `.` en templates;
- como usar `$` como referencia al contexto raiz;
- como controlar espacios en blanco para producir YAML valido;
- como usar pipelines y funciones comunes;
- como se fusionan valores por defecto, valores de entorno y overrides por CLI;
- como usar `if`, `range` y `with` sin perder contexto;
- como declarar helpers reutilizables en `_helpers.tpl`;
- como instalar, actualizar, inspeccionar y revertir un release;
- como validar templates con `helm lint`, `helm template`, dry-run y comprobaciones con `kubectl`.

Se retomaran de unidades anteriores:

- `platform-api` como aplicacion evolutiva;
- namespace `platform-training`;
- Deployment, ReplicaSet, Pods, ConfigMap, Secret ficticio, Service, EndpointSlice, Ingress, PVC y PDB;
- probes, requests/limits, labels, selectors y rollout;
- diagnostico con `kubectl get`, `describe`, `logs`, `rollout status`, `rollout history` y `rollout undo`;
- separacion entre tutorial de entrada, `student-notes.md`, referencia del alumno y laboratorio operativo.

Se mencionaran y diferiran:

- gestion de releases Helm mediante Terraform;
- `helm_release`, `templatefile()` y `set_sensitive`;
- modulos Terraform;
- publicacion de charts en repositorios remotos u OCI;
- firma, provenance, politicas de supply chain y admision;
- integracion con Argo CD;
- promocion formal entre entornos;
- secretos productivos y gestores externos de secretos.

Errores de razonamiento que deben prevenirse:

- creer que Helm reemplaza Kubernetes, cuando solo empaqueta y renderiza manifiestos;
- convertir todos los campos en variables sin criterio;
- usar `--set` como mecanismo principal de configuracion compleja;
- confundir defaults del chart con valores de entorno;
- romper YAML por sangria o control incorrecto de espacios;
- perder el contexto dentro de `range` o `with`;
- duplicar labels y nombres en cada template en vez de usar helpers;
- introducir secretos reales en `values.yaml`, `values-*.yaml` o comandos de ejemplo;
- presentar Terraform como parte ejecutable de esta unidad cuando el roadmap lo situa en la Unidad 07.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- convertir los manifiestos acumulados de `platform-api` en un chart Helm funcional;
- parametrizar imagen, replicas, labels, Ingress, resources, scheduling, PVC y PDB sin ocultar su significado;
- explicar el flujo de renderizado desde templates y values hasta YAML Kubernetes;
- usar `.` y `$` correctamente en templates con `if`, `range` y `with`;
- aplicar control de espacios, `quote`, `indent`, `nindent` e `include` para producir YAML valido;
- separar valores por defecto de valores de entorno;
- instalar, actualizar, inspeccionar y revertir un release local;
- validar un chart con `helm lint`, `helm template`, dry-run y comprobaciones de Kubernetes;
- justificar que valores deben exponerse y cuales deben permanecer fijos;
- explicar donde termina Helm y donde empezara Terraform en la Unidad 07.

---

# Alcance

## Incluido

- reutilizacion de `labs/05-scheduling-resilience-maintenance/solution/` como entrada tecnica;
- creacion de un chart local para `platform-api`;
- estructura basica de chart con `Chart.yaml`, `values.yaml`, `templates/` y `_helpers.tpl`;
- templates para Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB;
- valores por defecto seguros para laboratorio;
- valores separados para entorno local cuando proceda;
- instalacion y upgrade local con Helm;
- rollback de release Helm;
- validacion con `helm lint`, `helm template`, `helm install --dry-run`, `helm upgrade --install` y `kubectl`;
- documentacion formativa de Helm desde cero;
- nuevo elemento `student-reference.md` como referencia tecnica avanzada de plantillas y gestion de variables;
- actualizacion de `tutorial/06-helm-packaging/summary.md` al cerrar la unidad;
- actualizacion de `project/project-state.md` al generar y cerrar la unidad.

## Excluido

- modulos Terraform;
- ejecucion de `helm_release` mediante Terraform;
- gestion real de secretos productivos;
- integracion con External Secrets, Sealed Secrets, SOPS o Vault;
- repositorios remotos de charts, OCI registry o publicacion de paquetes;
- CI/CD, Tekton, Argo CD o GitOps;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automatico;
- AKS, EKS o clusters multi-nodo cloud;
- sustitucion de `platform-api`;
- cambio del namespace funcional `platform-training`;
- introduccion de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Terraform `helm_release` ejecutable | Unidad 07 | Requiere chart Helm funcional y limite claro entre empaquetado y IaC |
| Modulos Terraform | Unidad 07 | Pertenece a automatizacion de infraestructura |
| Promocion entre entornos | Unidad 10 | Requiere Helm y automatizacion previos |
| Argo CD | Unidad 09 | Requiere chart y layout declarativo estable |
| Repositorios remotos u OCI | Unidad posterior | No es necesario para el primer chart local |
| Secret management productivo | Unidades de seguridad | Requiere politicas y herramientas especificas |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `project/project-planning.md`;
6. `project/how-to.md`;
7. `playbooks/unit-template.md`;
8. `playbooks/summary-template.md`;
9. `playbooks/project-state-template.md`;
10. `tutorial/05-scheduling-resilience-maintenance/README.md`;
11. `tutorial/05-scheduling-resilience-maintenance/student-notes.md`;
12. `tutorial/05-scheduling-resilience-maintenance/summary.md`;
13. este playbook;
14. `labs/05-scheduling-resilience-maintenance/README.md`;
15. `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml`;
16. `labs/05-scheduling-resilience-maintenance/solution/configmap.yaml`;
17. `labs/05-scheduling-resilience-maintenance/solution/secret.yaml`;
18. `labs/05-scheduling-resilience-maintenance/solution/pvc.yaml`;
19. `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml`;
20. `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml`;
21. `labs/05-scheduling-resilience-maintenance/solution/service.yaml`;
22. `labs/05-scheduling-resilience-maintenance/solution/ingress.yaml`;
23. `labs/05-scheduling-resilience-maintenance/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 05 existe y deja `tutorial/05-scheduling-resilience-maintenance/summary.md` y `labs/05-scheduling-resilience-maintenance/solution/` como base prevista para Unidad 06.

---

# Dependencias

## Dependencias documentales

Deben existir:

```text
README.md
project/architecture.md
project/project-state.md
project/roadmap.md
project/project-planning.md
project/how-to.md
playbooks/master.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
playbooks/units/06-helm-packaging.md
tutorial/05-scheduling-resilience-maintenance/summary.md
tutorial/05-scheduling-resilience-maintenance/student-notes.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| MicroK8s | Instalado y operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| Helm | CLI validada antes de crear charts | `helm version --short` |
| Namespace `platform-training` | Existente o aplicable desde chart | `kubectl get namespace platform-training` |
| Manifiestos Unidad 05 | Disponibles y validables | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/` |
| Deployment `platform-api` | Desplegable desde Unidad 05 | `kubectl -n platform-training rollout status deployment/platform-api` |
| PVC `platform-api-data` | `Bound` cuando la Unidad 05 este aplicada | `kubectl -n platform-training get pvc platform-api-data` |
| Terraform | Instalado, pero no usado para gestionar esta unidad | `terraform version` |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00 y validacion del entorno local;
- Unidad 01 y relacion entre Deployment, ReplicaSet, Pod, Service, labels y selectors;
- Unidad 02 y uso de ConfigMap, Secret ficticio, probes, requests y limits;
- Unidad 03 y relacion entre Service, EndpointSlice e Ingress;
- Unidad 04 y relacion entre PVC, PV, StorageClass y volumen montado;
- Unidad 05 y relacion entre scheduling, rollout, PDB, replicas y disponibilidad;
- lectura basica de YAML;
- uso de `kubectl apply`, `get`, `describe`, `logs`, `rollout status`, `rollout history` y `rollout undo`.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/05-scheduling-resilience-maintenance/summary.md
tutorial/05-scheduling-resilience-maintenance/student-notes.md
labs/05-scheduling-resilience-maintenance/README.md
labs/05-scheduling-resilience-maintenance/solution/namespace.yaml
labs/05-scheduling-resilience-maintenance/solution/configmap.yaml
labs/05-scheduling-resilience-maintenance/solution/secret.yaml
labs/05-scheduling-resilience-maintenance/solution/pvc.yaml
labs/05-scheduling-resilience-maintenance/solution/pdb.yaml
labs/05-scheduling-resilience-maintenance/solution/deployment.yaml
labs/05-scheduling-resilience-maintenance/solution/service.yaml
labs/05-scheduling-resilience-maintenance/solution/ingress.yaml
labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` desplegada sobre MicroK8s en el namespace `platform-training`, con configuracion externa, Secret ficticio, probes, resources, Service interno, Ingress HTTP local, PVC de laboratorio, estrategia de `RollingUpdate`, constraints seguros de scheduling y PDB.

Estado verificable esperado:

- MicroK8s y Kubernetes disponibles segun `project/project-state.md`;
- Helm disponible como CLI validada;
- Terraform disponible como CLI, pero sin gestionar recursos del curso;
- no existen charts Helm del curso antes de esta unidad;
- no existen releases Helm del curso antes de esta unidad;
- `labs/05-scheduling-resilience-maintenance/solution/` es la base tecnica de entrada;
- los secretos existentes son ficticios y no contienen credenciales reales.

## Validacion del estado inicial

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
helm version --short
find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print
find . -path ./.git -prune -o -type f '(' -name '*.tf' -o -name '*.tfvars' ')' -print
```

Resultado esperado:

```text
Las validaciones heredadas no muestran fallos bloqueantes.
Helm informa su version.
No existen Chart.yaml del curso antes de generar la unidad.
No existen archivos Terraform del curso antes de la Unidad 07.
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/summary.md` | Continuidad tecnica y pedagogica |
| Student notes Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` | Contexto previo sobre decisiones operativas que se parametrizan |
| Manifiestos Unidad 05 | `labs/05-scheduling-resilience-maintenance/solution/` | Base para crear templates Helm |
| Validacion Unidad 05 | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Precondicion funcional heredada |

## Reglas de reutilizacion

- conservar `platform-api` como aplicacion evolutiva;
- conservar `platform-training` como namespace funcional por defecto;
- conservar los nombres logicos de recursos salvo que Helm requiera helpers de nombre y la compatibilidad quede explicada;
- convertir los manifiestos existentes en templates sin cambiar comportamiento funcional innecesariamente;
- parametrizar solo valores con variabilidad real o pedagogicamente relevante;
- mantener Secret ficticio de laboratorio sin introducir credenciales reales;
- preservar Service, Ingress, PVC, PDB, probes, resources, rollout y scheduling de Unidad 05.

---

# Entregables esperados

## Documentacion del alumno

```text
tutorial/06-helm-packaging/README.md
tutorial/06-helm-packaging/student-notes.md
tutorial/06-helm-packaging/student-reference.md
tutorial/06-helm-packaging/instructor-notes.md
tutorial/06-helm-packaging/summary.md
```

Responsabilidades:

- `README.md`: puerta de entrada, objetivos, mapa conceptual, flujo de uso y validaciones;
- `student-notes.md`: guia de aprendizaje academica y aplicada de Helm en la unidad;
- `student-reference.md`: referencia tecnica avanzada sobre plantillas, variables, helpers y frontera con Terraform;
- `instructor-notes.md`: guia de imparticion, riesgos, evaluacion y recuperacion;
- `summary.md`: contrato de continuidad hacia Unidad 07.

## Laboratorio

```text
labs/06-helm-packaging/
├── README.md
├── chart/
│   └── platform-api/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-local.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── namespace.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── pvc.yaml
│           ├── pdb.yaml
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
└── validation/
    └── validate.sh
```

La ruta exacta del chart podra ajustarse durante generacion solo si se documenta la razon y se actualizan todas las referencias.

---

# Student reference requerido

La Unidad 06 debe incorporar un nuevo elemento de referencia para el alumno:

```text
tutorial/06-helm-packaging/student-reference.md
```

Titulo recomendado:

```text
Arquitectura avanzada de plantillas y gestion de variables en Helm
```

Este documento no sustituye a `student-notes.md`. Su funcion es servir como referencia tecnica consultable durante ejercicios, revisiones y futuras unidades. Debe ser mas denso, preciso y estructurado que la guia de aprendizaje, pero conservar explicaciones progresivas y ejemplos pequenos conectados con `platform-api`.

## Indice minimo obligatorio

### Modulo 1 - El compilador de Helm y el motor de plantillas de Go

#### 1.1 Introduccion al motor `text/template` de Go

- mecanica del pipeline de renderizado, desde texto plano hasta YAML de Kubernetes;
- anatomia del ambito de contexto: que es el punto `.`;
- objetos globales del compilador;
- el signo dolar `$` como ancla raiz del contexto.

#### 1.2 Control estricto de espacios en blanco y sintaxis estandar

- operador de supresion de espacios `{{-` y `-}}`;
- prevencion de errores de sangria en bloques declarativos YAML;
- uso de pipelines `|`;
- funciones de formateo como `quote`, `upper` y `lower`.

### Modulo 2 - Jerarquia, fusion y sustitucion de variables

#### 2.1 Ciclo de vida y flujo de prioridades

- piramide de pesos de Helm, desde el archivo por defecto hasta la consola;
- relacion entre `values.yaml`, valores de chart padre, archivos `-f` y `--set`;
- mecanica de combinacion y sustitucion de mapas complejos;
- riesgos de destruir configuraciones parciales por overrides mal estructurados.

#### 2.2 Flujo de datos horizontal y descendente

- nivel 1: ambito interno del subchart en `charts/subchart/values.yaml`;
- nivel 2: inyeccion y sobrescritura desde el chart padre;
- nivel 3: inyeccion transversal mediante `.Values.global`;
- nivel 4: sobrescritura externa en produccion mediante archivos de entorno con `-f`;
- nivel 5: inyeccion quirurgica por linea de comandos con `--set` y `--set-string`.

### Modulo 3 - Estructuras de control de flujo y mutacion de contexto

#### 3.1 Logica condicional avanzada

- evaluacion de existencia y booleanos con `if`, `else if` y `else`;
- operadores de comparacion prefijos de Go: `eq`, `ne`, `lt`, `ge`, `and` y `or`.

#### 3.2 Iteraciones eficientes en YAML

- bucles sobre listas planas con `range`;
- desestructuracion clave-valor de mapas complejos.

#### 3.3 Mutacion del ambito con `with`

- simplificacion de rutas largas de variables;
- peligro de perdida de contexto;
- recuperacion del contexto raiz con `$`.

### Modulo 4 - Ingenieria de codigo reutilizable con `_helpers.tpl`

#### 4.1 Declaracion e invocacion de bloques nombrados

- uso de la directiva `define` para empaquetar logica;
- diferencias tecnicas entre `template` e `include`;
- paso obligatorio del contexto de ejecucion.

#### 4.2 Tecnicas de indentacion dinamica

- operador de sangria tradicional `indent`;
- operador con nueva linea `nindent`;
- inyeccion limpia de bloques de labels y variables de entorno.

### Modulo 5 - Orquestacion con Terraform como siguiente nivel

#### 5.1 El recurso `helm_release` de Terraform

- mapeo conceptual de variables HCL a estructuras YAML de Helm;
- inyeccion limpia mediante la funcion `templatefile()` de Terraform;
- proteccion de secretos en el estado con `set_sensitive`;
- limite de alcance: este modulo es una referencia de continuidad hacia Unidad 07, no un laboratorio ejecutable de Unidad 06.

## Criterios de calidad del `student-reference.md`

- debe usar ejemplos breves basados en `platform-api`;
- debe distinguir claramente Go templates, funciones de Helm/Sprig y YAML Kubernetes;
- debe incluir advertencias sobre sangria, contexto y overrides destructivos;
- debe evitar credenciales reales;
- debe incluir referencias a documentacion oficial de Helm y Terraform;
- debe cerrar con una tabla de diagnostico de errores frecuentes de renderizado.

---

# Diseno pedagogico

## `README.md`

Debe responder:

- por que Helm aparece despues de manifiestos nativos;
- que problema resuelve empaquetar `platform-api`;
- que partes del comportamiento ya existian antes de Helm;
- que comandos debe ejecutar el alumno;
- como validar que el release conserva el comportamiento de Unidad 05.

## `student-notes.md`

Debe mantener la estructura aprobada para guias del alumno:

- proposito;
- que se va a cubrir;
- que representa cada componente;
- que vas a construir;
- como se relacionan las piezas;
- que ocurre al aplicar los artefactos;
- como comprobar que funciona;
- diagnostico de cuatro fallos tipicos;
- que debes recordar para la Unidad 07;
- fuentes de referencia.

## `student-reference.md`

Debe actuar como manual de consulta sobre plantillas y variables. Puede ser mas extenso que `student-notes.md`, pero no debe convertirse en una copia de la documentacion oficial.

## `labs/06-helm-packaging/README.md`

Debe incluir:

- precondiciones;
- estructura del chart;
- migracion desde manifiestos de Unidad 05;
- comandos de renderizado;
- instalacion inicial;
- upgrade;
- rollback;
- inspeccion del release;
- validacion automatizada;
- recuperacion de errores comunes;
- limpieza controlada si procede.

---

# Validaciones requeridas

## Validaciones estaticas

```bash
bash -n labs/06-helm-packaging/validation/validate.sh
helm lint labs/06-helm-packaging/chart/platform-api
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml | kubectl apply --dry-run=client -f -
```

Si `shellcheck` esta disponible:

```bash
shellcheck labs/06-helm-packaging/validation/validate.sh
```

## Validaciones funcionales

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training --create-namespace -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
kubectl -n platform-training rollout status deployment/platform-api
bash labs/06-helm-packaging/validation/validate.sh
helm history platform-api-local --namespace platform-training
helm rollback platform-api-local <revision> --namespace platform-training
```

La validacion funcional debe comprobar, como minimo:

- release Helm instalado;
- manifiestos renderizados sin errores;
- Deployment disponible;
- Service `ClusterIP` con endpoints;
- Ingress conservado para `platform-api.local`;
- PVC `platform-api-data` conservado;
- PDB `platform-api` presente;
- labels y selectors coherentes;
- rollback documentado y recuperable;
- ausencia de secretos reales.

## Validaciones pendientes si no se ejecutan

Si el entorno no esta disponible, registrar como pendientes:

- `helm lint`;
- `helm template`;
- dry-run contra `kubectl`;
- instalacion o upgrade real;
- validacion funcional del release;
- rollback real.

---

# Restricciones especificas

- No crear modulos Terraform en esta unidad.
- No ejecutar `helm_release` en esta unidad.
- No introducir secretos reales ni valores sensibles.
- No usar `--set` para estructuras complejas como camino principal.
- No romper compatibilidad con `labs/05-scheduling-resilience-maintenance/solution/`.
- No eliminar PVC como parte normal de instalacion, upgrade, rollback o limpieza.
- No cambiar el namespace funcional por defecto.
- No introducir aplicaciones alternativas.
- No instalar CI/CD, GitOps, observabilidad avanzada, KEDA ni recursos cloud.
- No publicar charts en repositorios remotos.

---

# Decisiones previstas

## D-06-01 - Helm empaqueta `platform-api`

El primer chart del curso debe empaquetar la aplicacion evolutiva existente. No se crea una aplicacion de ejemplo independiente.

## D-06-02 - Parametrizacion con criterio

La unidad debe ensenar que no todo campo debe convertirse en variable. Se parametrizan valores con variabilidad real: imagen, replicas, Ingress, resources, scheduling, PVC, PDB y configuracion visible de laboratorio.

## D-06-03 - `student-reference.md` como referencia tecnica avanzada

La unidad incorpora `tutorial/06-helm-packaging/student-reference.md` para cubrir arquitectura de plantillas, jerarquia de valores, control de flujo, helpers y frontera conceptual con Terraform.

## D-06-04 - Terraform queda diferido como ejecucion

La referencia puede explicar `helm_release`, `templatefile()` y `set_sensitive` para preparar Unidad 07, pero la Unidad 06 no debe crear archivos Terraform ni gestionar releases desde Terraform.

## D-06-05 - Validacion por renderizado antes de instalacion

El alumno debe ver primero el YAML renderizado antes de instalarlo. Esto evita tratar Helm como una caja negra.

---

# Fuentes externas recomendadas

- Helm Chart Template Guide: https://helm.sh/docs/chart_template_guide/
- Helm Values Files: https://helm.sh/docs/chart_template_guide/values_files/
- Helm Template Functions and Pipelines: https://helm.sh/docs/chart_template_guide/functions_and_pipelines/
- Helm Named Templates: https://helm.sh/docs/chart_template_guide/named_templates/
- Helm Subcharts and Global Values: https://helm.sh/docs/chart_template_guide/subcharts_and_globals/
- Helm Function List: https://helm.sh/docs/chart_template_guide/function_list/
- Terraform `templatefile`: https://developer.hashicorp.com/terraform/language/functions/templatefile
- Terraform Helm provider `helm_release`: https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release

---

# Criterios de aceptacion

El playbook de Unidad 06 quedara listo para aprobar cuando:

- respete el roadmap y el estado actual;
- mantenga `platform-api` como aplicacion evolutiva;
- defina el chart local esperado sin crear Terraform;
- incorpore `student-reference.md` como entregable obligatorio;
- trate Terraform solo como continuidad conceptual hacia Unidad 07;
- distinga validacion tecnica de revision pedagogica del usuario;
- declare validaciones verificables;
- no contradiga las restricciones de unidades anteriores.

La Unidad 06 quedara completada cuando, en una sesion posterior al playbook aprobado:

- existan todos los documentos de `tutorial/06-helm-packaging/`;
- exista el chart local de `platform-api`;
- exista el laboratorio operativo;
- exista la validacion automatizada;
- las validaciones estaticas se hayan ejecutado;
- las validaciones funcionales se hayan ejecutado o queden registradas como pendientes con causa;
- `tutorial/06-helm-packaging/summary.md` registre continuidad hacia Unidad 07;
- `project/project-state.md` refleje el estado real.
