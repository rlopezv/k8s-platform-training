# Playbook de la Unidad 07 - Automatizacion local con Terraform

## Identificacion

### Unidad

```text
07 - Automatizacion local con Terraform
```

### Identificador

```text
07-local-terraform-automation
```

### Fase del roadmap

```text
Fase 3 - Empaquetado e infraestructura como codigo
```

### Estado del playbook

```text
Aprobado
```

### Propietario logico

```text
Empaquetado e infraestructura como codigo
```

---

# Proposito de la unidad

La Unidad 07 introduce Terraform como capa de automatizacion declarativa para instalar, actualizar, validar e inspeccionar el release Helm de `platform-api` sobre el entorno local ya construido. La unidad parte del chart funcional de la Unidad 06 y convierte una operacion manual con `helm upgrade --install` en una declaracion Terraform con providers, variables, outputs, estado local y dependencias explicitas.

Esta unidad aparece despues de Helm porque Terraform no debe ocultar que el paquete aplicable sigue siendo un chart. El alumno debe distinguir tres responsabilidades: Kubernetes ejecuta recursos, Helm empaqueta y renderiza esos recursos, y Terraform declara la instalacion y conserva estado sobre lo gestionado.

## Supuesto pedagogico

La unidad debe escribirse para alumnos con perfil tecnico que han usado `kubectl` y Helm, pero todavia no dominan Terraform, HCL, providers, state, variables, outputs, DAG, lifecycle ni la relacion entre Terraform y Kubernetes.

Se explicaran desde cero:

- que es Terraform y que problema resuelve frente a scripts imperativos;
- que representa un provider, un resource, un data source, una variable, un output y el state;
- que ocurre en `terraform init`, `terraform plan`, `terraform apply` y `terraform destroy`;
- como Terraform construye un grafo de dependencias;
- por que el state no es un cache inocuo, sino el contrato entre configuracion y recursos reales;
- como funciona la jerarquia de variables y overrides;
- como se usa el provider Helm para gestionar un `helm_release`;
- como se usa el provider Kubernetes solo para leer o validar estado cuando sea necesario;
- como proteger valores sensibles en laboratorio sin versionar secretos reales;
- como interpretar un plan y diagnosticar drift basico.

Se retomaran de unidades anteriores:

- `platform-api` como aplicacion evolutiva;
- namespace funcional `platform-training`;
- chart Helm local `labs/06-helm-packaging/chart/platform-api/`;
- release local `platform-api-local`;
- separacion entre configuracion, secretos ficticios, probes, resources, Service, Ingress, PVC, PDB, scheduling y rollout;
- validacion con `helm lint`, `helm template`, `kubectl`, `rollout status`, `helm history` y el script de Unidad 06;
- uso de `student-notes.md` como guia de aprendizaje y `student-reference.md` como referencia tecnica.

Se mencionaran y diferiran:

- backends remotos reales en AWS S3, Azure Blob o HCP Terraform;
- bloqueo real de estado con DynamoDB, Consul o mecanismos gestionados;
- creacion de clusters AKS o EKS;
- redes cloud, IAM, identidades, registries y storage cloud;
- CI/CD, Tekton, Argo CD y GitOps;
- politicas de seguridad, escaneo, firma, admision y secretos productivos;
- observabilidad avanzada;
- modulos Terraform cloud reutilizables de produccion.

Errores de razonamiento que deben prevenirse:

- creer que Terraform reemplaza Helm o Kubernetes;
- ejecutar `terraform apply` sin leer el plan;
- tratar `terraform.tfstate` como un archivo prescindible o versionable sin consecuencias;
- guardar secretos reales en `.tf`, `.tfvars`, estado o salida de comandos;
- usar `-var` como mecanismo habitual para configuraciones complejas;
- creer que los workspaces sustituyen siempre una estructura clara de directorios;
- usar `count` para listas cuya posicion puede cambiar cuando `for_each` expresa mejor la identidad;
- introducir providers cloud o recursos gestionados cloud antes de la fase prevista;
- destruir PVCs o recursos persistentes como limpieza normal del laboratorio.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- inicializar un proyecto Terraform local para gestionar el release Helm de `platform-api`;
- explicar el papel de `init`, `plan`, `apply`, `destroy` y del state;
- interpretar un plan antes de aplicar cambios;
- configurar providers Helm y Kubernetes contra el contexto local existente;
- declarar un `helm_release` que reutilice el chart de Unidad 06;
- parametrizar el despliegue con variables tipadas, `tfvars` y valores por defecto;
- exponer outputs utiles sin filtrar valores sensibles;
- validar que Terraform, Helm y Kubernetes observan el mismo estado funcional;
- diagnosticar drift basico entre Terraform state, Helm release y recursos Kubernetes;
- justificar que responsabilidades corresponden a Terraform y cuales deben permanecer en Helm o Kubernetes.

---

# Alcance

## Incluido

- reutilizacion de `labs/06-helm-packaging/chart/platform-api/` como entrada tecnica principal;
- creacion de un proyecto Terraform local para gestionar `helm_release.platform_api`;
- uso de provider Helm y, si aporta valor, provider Kubernetes para comprobaciones o data sources no destructivos;
- backend local de Terraform para laboratorio;
- variables tipadas, `terraform.tfvars.example`, archivos `.tfvars` locales ignorados y overrides por CLI documentados;
- outputs utiles para release, namespace, host de Ingress y comandos de observacion;
- uso de `templatefile()` cuando sea pedagogicamente necesario para renderizar un `values.yaml` dinamico consumido por `helm_release`;
- uso de `set {}` y `set_sensitive {}` para explicar inyeccion puntual y valores sensibles sin introducir credenciales reales;
- estructura inicial con un modulo local reutilizable solo si reduce complejidad y no oculta el flujo principal;
- validacion con `terraform fmt`, `terraform validate`, `terraform plan`, `terraform apply`, `terraform output`, `helm status`, `kubectl` y validacion heredada de Unidad 06;
- documentacion formativa de Terraform desde cero;
- `tutorial/07-local-terraform-automation/student-reference.md` como referencia avanzada obligatoria con el indice definido en este playbook;
- actualizacion de `tutorial/07-local-terraform-automation/summary.md` al cerrar la unidad;
- actualizacion de `project/project-state.md` al generar y cerrar la unidad.

## Excluido

- creacion de recursos cloud reales;
- backends remotos reales en AWS S3, Azure Blob, HCP Terraform o Consul;
- bloqueo real de estado con DynamoDB o Consul;
- provisionamiento de AKS, EKS, VPC, VNet, IAM, node groups o registries;
- CI/CD, Tekton, Argo CD o GitOps;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automatico;
- gestores productivos de secretos como Vault, External Secrets, SOPS o Sealed Secrets;
- publicacion de charts en repositorios remotos u OCI;
- sustitucion de `platform-api`;
- cambio del namespace funcional `platform-training`;
- introduccion de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Tekton | Unidad 08 | Requiere Terraform y Helm estables antes de automatizar entrega |
| Argo CD y GitOps | Unidad 09 | Requiere separar estado deseado, paquetes y despliegue automatizado |
| Promocion formal entre entornos | Unidad 10 | Requiere convenciones IaC y CI/CD previas |
| Backends remotos productivos | Unidades cloud | Requiere cuenta cloud, permisos, costes y gobierno |
| AKS y EKS | Unidades 19-25 | Pertenece a plataformas gestionadas |
| Secret management productivo | Unidades de seguridad | Requiere herramientas y politicas especificas |

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
10. `playbooks/units/06-helm-packaging.md`;
11. `tutorial/06-helm-packaging/README.md`;
12. `tutorial/06-helm-packaging/student-notes.md`;
13. `tutorial/06-helm-packaging/student-reference.md`;
14. `tutorial/06-helm-packaging/summary.md`;
15. este playbook;
16. `labs/06-helm-packaging/README.md`;
17. `labs/06-helm-packaging/chart/platform-api/Chart.yaml`;
18. `labs/06-helm-packaging/chart/platform-api/values.yaml`;
19. `labs/06-helm-packaging/chart/platform-api/values-local.yaml`;
20. `labs/06-helm-packaging/chart/platform-api/templates/`;
21. `labs/06-helm-packaging/validation/adopt-existing-resources.sh`;
22. `labs/06-helm-packaging/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 06 existe, esta aprobada y deja `tutorial/06-helm-packaging/summary.md` y `labs/06-helm-packaging/chart/platform-api/` como base prevista para Unidad 07.

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
playbooks/units/07-local-terraform-automation.md
tutorial/06-helm-packaging/summary.md
tutorial/06-helm-packaging/student-notes.md
tutorial/06-helm-packaging/student-reference.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| MicroK8s | Instalado y operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| Helm | CLI disponible y chart de Unidad 06 validable | `helm version --short` y `helm lint labs/06-helm-packaging/chart/platform-api` |
| Terraform | CLI disponible | `terraform version` |
| Namespace `platform-training` | Existente o creable por chart | `kubectl get namespace platform-training` |
| Chart `platform-api` | Disponible | `test -f labs/06-helm-packaging/chart/platform-api/Chart.yaml` |
| Release `platform-api-local` | Instalado o instalable | `helm status platform-api-local --namespace platform-training` |
| PVC `platform-api-data` | Conservado si ya existe | `kubectl -n platform-training get pvc platform-api-data` |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00 y validacion del entorno local;
- Unidad 01 y relacion entre Deployment, ReplicaSet, Pod, Service, labels y selectors;
- Unidad 02 y uso de ConfigMap, Secret ficticio, probes, requests y limits;
- Unidad 03 y relacion entre Service, EndpointSlice e Ingress;
- Unidad 04 y relacion entre PVC, PV, StorageClass y volumen montado;
- Unidad 05 y relacion entre scheduling, rollout, PDB, replicas y disponibilidad;
- Unidad 06 y relacion entre chart, templates, values, release y rollback Helm;
- lectura basica de YAML;
- lectura basica de ficheros declarativos;
- uso operativo de `kubectl` y Helm.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/06-helm-packaging/summary.md
tutorial/06-helm-packaging/student-notes.md
tutorial/06-helm-packaging/student-reference.md
labs/06-helm-packaging/README.md
labs/06-helm-packaging/chart/platform-api/Chart.yaml
labs/06-helm-packaging/chart/platform-api/values.yaml
labs/06-helm-packaging/chart/platform-api/values-local.yaml
labs/06-helm-packaging/chart/platform-api/templates/
labs/06-helm-packaging/validation/adopt-existing-resources.sh
labs/06-helm-packaging/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` empaquetada como chart Helm local y desplegable en MicroK8s mediante el release `platform-api-local` en el namespace `platform-training`. Terraform esta instalado y validado como CLI, pero no existen todavia configuraciones `.tf`, modulos, backends ni estados Terraform del curso.

Estado verificable esperado:

- MicroK8s y Kubernetes disponibles segun `project/project-state.md`;
- Helm disponible y chart de Unidad 06 validado;
- Terraform disponible como CLI;
- `labs/06-helm-packaging/chart/platform-api/` es la base tecnica de entrada;
- no existen modulos Terraform del curso antes de generar la unidad;
- los secretos existentes son ficticios y no contienen credenciales reales;
- el PVC `platform-api-data` no debe eliminarse como parte normal de la unidad.

## Validacion del estado inicial

```bash
bash platform/environment/validation/validate-environment.sh
helm version --short
terraform version
helm lint labs/06-helm-packaging/chart/platform-api
bash labs/06-helm-packaging/validation/validate.sh
find . -path ./.git -prune -o -type f '(' -name '*.tf' -o -name '*.tfvars' ')' -print
```

Resultado esperado:

```text
Las validaciones heredadas no muestran fallos bloqueantes.
Helm y Terraform informan su version.
El chart de Unidad 06 pasa lint y validacion funcional cuando el entorno esta disponible.
No existen archivos Terraform del curso antes de generar la Unidad 07.
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 06 | `tutorial/06-helm-packaging/summary.md` | Continuidad tecnica y pedagogica |
| Student notes Unidad 06 | `tutorial/06-helm-packaging/student-notes.md` | Contexto previo sobre Helm |
| Student reference Unidad 06 | `tutorial/06-helm-packaging/student-reference.md` | Frontera conceptual Helm/Terraform y patrones de values |
| Chart Helm | `labs/06-helm-packaging/chart/platform-api/` | Paquete que Terraform instalara mediante `helm_release` |
| Laboratorio Unidad 06 | `labs/06-helm-packaging/README.md` | Flujo manual equivalente que sera automatizado |
| Validacion Unidad 06 | `labs/06-helm-packaging/validation/validate.sh` | Comprobacion funcional heredada |
| Adopcion Helm | `labs/06-helm-packaging/validation/adopt-existing-resources.sh` | Recuperacion si existen recursos heredados sin ownership Helm |

## Reglas de reutilizacion

- conservar `platform-api` como aplicacion evolutiva;
- conservar `platform-training` como namespace funcional por defecto;
- conservar `platform-api-local` como release local salvo que el playbook aprobado indique otra convencion;
- no duplicar el chart Helm ni convertir templates Helm de nuevo a manifiestos planos;
- declarar Terraform como orquestador de instalacion, no como motor de plantillas Kubernetes;
- mantener Secret ficticio de laboratorio sin introducir credenciales reales;
- preservar Service, Ingress, PVC, PDB, probes, resources, rollout y scheduling definidos por el chart;
- no borrar el PVC como parte normal de `terraform destroy` sin advertencia explicita y procedimiento de recuperacion.

---

# Entregables esperados

## Documentacion del alumno

```text
tutorial/07-local-terraform-automation/README.md
tutorial/07-local-terraform-automation/student-notes.md
tutorial/07-local-terraform-automation/student-reference.md
tutorial/07-local-terraform-automation/instructor-notes.md
tutorial/07-local-terraform-automation/summary.md
```

Responsabilidades:

- `README.md`: puerta de entrada, problema real, objetivos, mapa conceptual, flujo de uso y validaciones;
- `student-notes.md`: guia de aprendizaje academica y aplicada de Terraform en la unidad;
- `student-reference.md`: referencia tecnica avanzada sobre motor Terraform, state, variables, expresiones, modulos e integracion Kubernetes/Helm;
- `instructor-notes.md`: guia de imparticion, riesgos, evaluacion y recuperacion;
- `summary.md`: contrato de continuidad hacia Unidad 08.

## Laboratorio

```text
labs/07-local-terraform-automation/
├── README.md
├── terraform/
│   ├── versions.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars.example
│   ├── values/
│   │   └── platform-api-values.yaml.tftpl
│   └── .gitignore
└── validation/
    └── validate.sh
```

Si se decide incluir un modulo local inicial, la estructura maxima permitida sera:

```text
labs/07-local-terraform-automation/
└── terraform/
    └── modules/
        └── helm-release/
            ├── main.tf
            ├── variables.tf
            └── outputs.tf
```

El modulo solo debe existir si mejora la claridad pedagogica. La primera version puede mantenerse sin modulo si el flujo principal resulta mas comprensible.

---

# Student reference requerido

La Unidad 07 debe incorporar:

```text
tutorial/07-local-terraform-automation/student-reference.md
```

Titulo recomendado:

```text
Arquitectura avanzada de automatizacion con Terraform
```

Este documento no sustituye a `student-notes.md`. Su funcion es servir como referencia tecnica consultable durante ejercicios, revisiones y futuras unidades. Debe ser mas denso, preciso y estructurado que la guia de aprendizaje, pero conservar explicaciones progresivas y ejemplos pequenos conectados con `platform-api`, el chart Helm local y el laboratorio MicroK8s.

## Indice minimo obligatorio

### Modulo 1 - El motor de Terraform, ciclo de vida y gestion del estado

#### 1.1 Anatomia del compilador y lenguaje HCL (HashiCorp Configuration Language)

- fases de ejecucion: `init` como carga de plugins, `plan` como evaluacion del grafico de dependencias y `apply` como mutacion;
- el motor de grafo dirigido aciclico (DAG): como Terraform calcula el orden de creacion;
- el archivo de estado `terraform.tfstate`: anatomia del JSON, mapeo de IDs reales y metadatos.

#### 1.2 Arquitectura del estado en entornos de produccion

- configuracion de backends remotos: AWS S3, Azure Blob y HashiCorp Cloud;
- mecanismos de bloqueo de estado mediante DynamoDB o Consul para evitar colisiones;
- aislamiento de entornos: workspaces de Terraform frente a estructura de directorios nativos;
- operaciones de emergencia en consola: `terraform state rm`, `terraform state mv` e import de recursos existentes.

### Modulo 2 - El sistema de variables, tipos de datos y jerarquia de sustitucion

#### 2.1 Tipificacion estricta en HCL

- tipos primitivos: `string`, `number` y `bool`;
- tipos estructurales complejos: `list()`, `map()`, `object()`, `set()` y `tuple()`;
- bloques de validacion de variables con `validation` y `error_message` para asegurar estandares.

#### 2.2 La cascada de prioridades en la sustitucion de datos

- piramide de pesos de Terraform: del valor por defecto a la consola;
- nivel 1: valores por defecto en la declaracion `default`;
- nivel 2: archivo automatico de variables del proyecto `terraform.tfvars`;
- nivel 3: archivos de entorno especificos por cliente o region con `-var-file="prod.tfvars"`;
- nivel 4: variables de entorno del sistema operativo con prefijo `TF_VAR_nombre`;
- nivel 5: inyeccion directa y quirurgica por linea de comandos con `-var="clave=valor"`.

### Modulo 3 - Logica dinamica, expresiones y manipulacion de infraestructura

#### 3.1 Estructuras de control estaticas y condicionales

- operador condicional ternario: `condicion ? si_verdadero : si_falso`;
- duplicacion de recursos condicional utilizando `count = var.enabled ? 1 : 0`.

#### 3.2 Expresiones avanzadas de bucles

- iteraciones de recursos con `for_each` sobre mapas y conjuntos;
- diferencias tecnicas de ciclo de vida: por que `for_each` es superior a `count` al modificar listas;
- comprension de listas y mapas usando expresiones `for`, por ejemplo `[for k, v in var.map : v if k != "test"]`.

#### 3.3 Bloques dinamicos

- sintaxis de `dynamic` para generar sub-bloques repetitivos dentro de un recurso, por ejemplo reglas de Security Groups o tags;
- configuracion de los argumentos `iterator` y `content`.

### Modulo 4 - Modularizacion y flujo de datos transversal

#### 4.1 Diseno de modulos reutilizables de caja negra

- estructura estandar: `main.tf`, `variables.tf`, `outputs.tf` y `providers.tf`;
- inyeccion de datos: conversion de outputs de un modulo en inputs de otro;
- uso de `count`, `for_each` y `depends_on` a nivel de modulo completo desde Terraform 0.13.

#### 4.2 Comparticion de datos entre proyectos independientes

- bloque de datos remoto `data "terraform_remote_state"`;
- lectura segura del estado de redes o clusters core sin dar permisos de escritura.

### Modulo 5 - Integracion avanzada con Kubernetes y Helm

#### 5.1 Autenticacion dinamica entre proveedores

- puente de datos para configurar providers `helm` y `kubernetes` utilizando outputs directos del recurso del cluster, por ejemplo `aws_eks_cluster.core.endpoint` y su token dinamico;
- limite de alcance: en esta unidad se ejecuta contra MicroK8s local; la autenticacion cloud queda como referencia conceptual.

#### 5.2 El recurso `helm_release` y la inyeccion de datos

- uso de la funcion `templatefile()` para renderizar un `values.yaml` dinamico con variables calculadas por Terraform;
- inyeccion quirurgica con bloques `set {}`;
- proteccion de contrasenas con `set_sensitive {}` y advertencia sobre state.

#### 5.3 Control de dependencias criticas en el despliegue

- problema del orden de destruccion: evitar que Terraform borre la VPC o el cluster antes de que Helm desinstale las aplicaciones;
- uso estricto de `depends_on` apuntando al Node Group o controladores de red como CNI/CSI para asegurar la salida limpia de recursos Kubernetes;
- limite de alcance: la unidad local no crea VPC, cluster ni node groups.

## Criterios de calidad del `student-reference.md`

- debe usar ejemplos breves basados en `platform-api`, `helm_release` y el chart local;
- debe distinguir claramente lenguaje HCL, Terraform Core, providers, estado y recursos remotos;
- debe explicar las secciones cloud como arquitectura de produccion, no como laboratorio ejecutable;
- debe incluir advertencias sobre secretos en state y `.tfvars`;
- debe incluir referencias a documentacion oficial de Terraform, provider Helm, provider Kubernetes y Helm;
- debe cerrar con una tabla de diagnostico de errores frecuentes de init, plan, apply, state y provider authentication.

---

# Diseno pedagogico

## `README.md`

Debe responder:

- por que Terraform aparece despues de Helm;
- que problema resuelve declarar el release Helm con Terraform;
- que partes del comportamiento siguen perteneciendo a Kubernetes o Helm;
- que comandos debe ejecutar el alumno;
- como validar que Terraform conserva el comportamiento de Unidad 06.

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
- que debes recordar para la Unidad 08;
- fuentes de referencia.

## `student-reference.md`

Debe actuar como manual de consulta sobre Terraform avanzado. Puede ser mas extenso que `student-notes.md`, pero no debe convertirse en una copia de la documentacion oficial ni en una promesa de ejecucion cloud.

## `labs/07-local-terraform-automation/README.md`

Debe incluir:

- precondiciones;
- estructura del proyecto Terraform;
- inicializacion con `terraform init`;
- revision con `terraform fmt`, `terraform validate` y `terraform plan`;
- aplicacion controlada con `terraform apply`;
- inspeccion de state, outputs y release Helm;
- cambio controlado de una variable;
- deteccion y correccion de drift basico;
- validacion automatizada;
- recuperacion de errores comunes;
- limpieza controlada si procede, con advertencia explicita sobre PVC y state.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Responsabilidad | Ubicacion prevista |
|---|---|---|
| Tutorial Unidad 07 | Puerta de entrada de la unidad | `tutorial/07-local-terraform-automation/README.md` |
| Student notes | Guia de aprendizaje de Terraform aplicado | `tutorial/07-local-terraform-automation/student-notes.md` |
| Student reference | Referencia avanzada de Terraform | `tutorial/07-local-terraform-automation/student-reference.md` |
| Instructor notes | Guia de imparticion | `tutorial/07-local-terraform-automation/instructor-notes.md` |
| Summary Unidad 07 | Continuidad hacia Unidad 08 | `tutorial/07-local-terraform-automation/summary.md` |
| Laboratorio Terraform | Guia operativa | `labs/07-local-terraform-automation/README.md` |
| Proyecto Terraform local | Gestion del release Helm | `labs/07-local-terraform-automation/terraform/` |
| Validacion Unidad 07 | Comprobacion de Terraform, Helm y Kubernetes | `labs/07-local-terraform-automation/validation/validate.sh` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| Release Helm `platform-api-local` | Pasara a estar gestionado por Terraform si se aplica la unidad | Debe conservar nombres, namespace, Ingress, PVC, PDB y comportamiento de Unidad 06 |
| `project/project-state.md` | Registro de unidad generada y validada | Debe distinguir generacion, validacion tecnica y aprobacion pedagogica |

## Componentes retirados

Ninguno.

---

# Procedimientos obligatorios

## Preparacion

- validar entorno local y chart heredado;
- confirmar version de Terraform;
- explicar si el release Helm existente sera importado, recreado o actualizado por Terraform;
- asegurar que `.terraform/`, `terraform.tfstate`, `terraform.tfstate.backup`, `*.tfvars` locales y planes binarios no se versionan.

## Implementacion

- crear estructura Terraform local;
- declarar providers con versiones acotadas;
- declarar variables tipadas y validaciones;
- declarar `helm_release` contra el chart local;
- usar `templatefile()` o `values` de forma legible;
- exponer outputs no sensibles;
- documentar el flujo `init -> plan -> apply`.

## Validacion

- ejecutar validaciones estaticas;
- ejecutar plan antes de apply;
- aplicar contra MicroK8s solo si el entorno esta disponible;
- validar release Helm y recursos Kubernetes;
- ejecutar validacion heredada de Unidad 06.

## Diagnostico

- diagnosticar errores de provider, contexto Kubernetes, release existente, state bloqueado o desalineado, chart invalido y variables no validas.

## Recuperacion

- explicar `terraform plan -refresh-only`;
- explicar `terraform import` solo si se necesita adoptar un release existente;
- explicar `terraform state rm` como emergencia controlada, no como flujo normal;
- explicar como volver a aplicar el estado versionado sin borrar PVCs.

## Limpieza

- documentar `terraform destroy` como operacion destructiva;
- advertir que puede desinstalar el release y afectar recursos gestionados por Helm;
- no borrar PVCs manualmente salvo instruccion explicita y entendida por el alumno.

---

# Validaciones requeridas

## Validaciones estaticas

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive
terraform -chdir=labs/07-local-terraform-automation/terraform init
terraform -chdir=labs/07-local-terraform-automation/terraform validate
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
bash -n labs/07-local-terraform-automation/validation/validate.sh
```

Si `shellcheck` esta disponible:

```bash
shellcheck labs/07-local-terraform-automation/validation/validate.sh
```

## Validaciones funcionales

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
terraform -chdir=labs/07-local-terraform-automation/terraform output
helm status platform-api-local --namespace platform-training
kubectl -n platform-training rollout status deployment/platform-api
bash labs/06-helm-packaging/validation/validate.sh
bash labs/07-local-terraform-automation/validation/validate.sh
```

La validacion funcional debe comprobar, como minimo:

- Terraform inicializado;
- plan legible y sin destrucciones inesperadas;
- apply completado cuando el entorno este disponible;
- `helm_release.platform_api` presente en state;
- release `platform-api-local` instalado o actualizado;
- Deployment disponible;
- Service `ClusterIP` con endpoints;
- Ingress conservado para `platform-api.local`;
- PVC `platform-api-data` conservado;
- PDB `platform-api` presente;
- outputs no sensibles;
- ausencia de secretos reales en archivos versionados.

## Validaciones pendientes si no se ejecutan

Si el entorno no esta disponible, registrar como pendientes:

- `terraform init`;
- `terraform validate`;
- `terraform plan`;
- `terraform apply`;
- inspeccion real de state;
- validacion real del release Helm;
- validacion funcional de Kubernetes;
- pruebas de recuperacion o drift.

---

# Escenarios de error obligatorios

| Escenario | Sintoma | Diagnostico | Recuperacion |
|---|---|---|---|
| Provider no inicializado | `terraform plan` indica provider desconocido o lock ausente | Revisar `terraform init` y `.terraform.lock.hcl` | Ejecutar `terraform init` desde la ruta correcta |
| Contexto Kubernetes incorrecto | Provider Helm/Kubernetes no conecta al cluster | `kubectl config current-context`, `kubectl get nodes` | Seleccionar contexto correcto o validar MicroK8s |
| Release existente fuera de Terraform | `helm_release` falla por recurso ya existente o ownership | `helm status`, `terraform state list`, metadatos Helm | Importar release si procede o usar adopcion documentada |
| Variable invalida | `terraform validate` o `plan` falla por `validation` | Leer `error_message` y valor efectivo | Corregir `tfvars` o default |
| State desalineado | Plan propone crear/destruir algo que ya existe | `terraform state list`, `terraform plan -refresh-only`, `helm status` | Importar, refrescar o retirar state con procedimiento controlado |
| Secreto filtrado | Valor sensible aparece en plan, output o archivo | Revisar `sensitive`, `set_sensitive`, `tfvars` y state | Sustituir por placeholder, rotar si fuera real, no versionar |

---

# Requisitos de seguridad

## Datos sensibles

- usar solo secretos ficticios de laboratorio;
- incluir `terraform.tfvars.example` con placeholders inocuos;
- ignorar `terraform.tfvars`, `*.auto.tfvars`, `*.tfvars.json`, `.terraform/`, `terraform.tfstate`, `terraform.tfstate.backup` y planes binarios;
- no versionar kubeconfigs, tokens, claves privadas, credenciales cloud ni secretos corporativos;
- documentar que `set_sensitive` reduce exposicion en CLI, pero el state puede seguir conteniendo datos sensibles segun provider y version.

## Privilegios

- no requerir privilegios cloud;
- requerir acceso local al cluster Kubernetes configurado;
- requerir permisos para crear, actualizar y borrar recursos en `platform-training` cuando se ejecute apply o destroy;
- documentar que `terraform destroy` puede desinstalar el release Helm.

## Operaciones destructivas

| Operacion | Advertencia | Alcance | Recuperacion | Confirmacion requerida |
|---|---|---|---|---|
| `terraform destroy` | Puede desinstalar el release y afectar recursos gestionados por Helm | Recursos declarados en Terraform | Reaplicar con `terraform apply`; comprobar PVC antes de cualquier borrado manual | Confirmacion interactiva de Terraform |
| `terraform state rm` | Desvincula Terraform sin borrar recurso real | Entrada concreta del state | Importar de nuevo o aplicar estrategia documentada | Confirmacion explicita del instructor |
| Borrado manual de PVC | Puede perder datos de laboratorio | `pvc/platform-api-data` | Restaurar solo si existe copia previa | No debe formar parte del flujo normal |

---

# Requisitos de portabilidad

## Kubernetes estandar

- recursos renderizados por el chart;
- namespace, Deployment, Service, Ingress, PVC y PDB;
- acceso mediante kubeconfig.

## Especifico de MicroK8s

- contexto local de Kubernetes;
- StorageClass `microk8s-hostpath`;
- Ingress local mediante addon de MicroK8s;
- validacion HTTP local con `platform-api.local`.

## Especifico de AKS

- no aplica como ejecucion;
- puede mencionarse en `student-reference.md` para explicar providers, backends y autenticacion dinamica futura.

## Especifico de EKS

- no aplica como ejecucion;
- puede mencionarse en `student-reference.md` para explicar providers, backends, tokens dinamicos y dependencias con node groups.

## Estrategia de desacoplamiento

- parametrizar namespace, release name, chart path, values y host de Ingress;
- evitar rutas absolutas;
- separar defaults versionados de `tfvars` locales;
- documentar backend local como decision de laboratorio y backends remotos como arquitectura futura;
- mantener Helm como paquete portable y Terraform como orquestacion de instalacion.

---

# Restricciones especificas

- No crear recursos cloud reales.
- No configurar backends remotos reales.
- No versionar `terraform.tfstate`, `.terraform/`, planes binarios ni `*.tfvars` con valores locales.
- No introducir credenciales reales, tokens, kubeconfigs, claves privadas ni secretos corporativos.
- No sustituir el chart de Unidad 06 ni duplicarlo en otra ruta.
- No cambiar el namespace funcional por defecto.
- No sustituir `platform-api`.
- No instalar CI/CD, GitOps, observabilidad avanzada, KEDA ni recursos cloud.
- No borrar PVCs como parte normal de limpieza.
- No presentar workspaces como solucion universal de entornos.

La IA si puede:

- crear archivos Terraform locales dentro de `labs/07-local-terraform-automation/terraform/` cuando se genere la unidad;
- crear `.gitignore` especifico de Terraform;
- usar `helm_release` contra el chart local;
- documentar backends remotos y locking en `student-reference.md` como arquitectura de produccion no ejecutada;
- crear un modulo local inicial si aporta claridad y se mantiene dentro del laboratorio.

---

# Decisiones previstas

## D-07-01 - Terraform orquesta el release Helm existente

El primer uso ejecutable de Terraform en el curso debe gestionar el release Helm local de `platform-api`. Terraform no reemplaza el chart ni reescribe los manifiestos Kubernetes.

## D-07-02 - Backend local para el laboratorio

La unidad usa state local para evitar cuentas cloud, costes, credenciales y permisos externos. Los backends remotos se explican en `student-reference.md` como arquitectura de produccion.

## D-07-03 - Variables tipadas antes de multi-entorno complejo

La unidad introduce variables, validaciones, `tfvars` y jerarquia de sustitucion sin crear todavia una estrategia completa de promocion entre entornos.

## D-07-04 - Secrets solo ficticios y con advertencia sobre state

La unidad puede demostrar `set_sensitive`, pero debe explicar que el state requiere proteccion y no debe contener secretos reales en este laboratorio.

## D-07-05 - Plan antes de apply

El alumno debe leer el plan antes de mutar el entorno. El flujo pedagogico debe impedir tratar Terraform como un wrapper de comandos.

## D-07-06 - Modulo local opcional

El laboratorio puede incorporar un modulo local inicial si ayuda a explicar interfaces de modulo. Si aumenta la carga cognitiva, se diferira la modularizacion ejecutable y se mantendra como referencia.

---

# Fuentes externas recomendadas

- Terraform Language Documentation: https://developer.hashicorp.com/terraform/language
- Terraform CLI Documentation: https://developer.hashicorp.com/terraform/cli
- Terraform State: https://developer.hashicorp.com/terraform/language/state
- Terraform Backends: https://developer.hashicorp.com/terraform/language/backend
- Terraform Input Variables: https://developer.hashicorp.com/terraform/language/values/variables
- Terraform Outputs: https://developer.hashicorp.com/terraform/language/values/outputs
- Terraform Expressions: https://developer.hashicorp.com/terraform/language/expressions
- Terraform Modules: https://developer.hashicorp.com/terraform/language/modules
- Terraform `templatefile`: https://developer.hashicorp.com/terraform/language/functions/templatefile
- Terraform Helm provider `helm_release`: https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release
- Terraform Kubernetes provider: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
- Helm Chart Template Guide: https://helm.sh/docs/chart_template_guide/

---

# Criterios de aceptacion

El playbook de Unidad 07 quedara listo para aprobar cuando:

- respete el roadmap y el estado actual;
- mantenga `platform-api` como aplicacion evolutiva;
- reutilice el chart Helm local de Unidad 06;
- defina Terraform como orquestacion de instalacion y no como sustituto de Helm;
- incorpore `student-reference.md` como entregable obligatorio con el indice de arquitectura avanzada indicado;
- distinga conceptos avanzados de produccion frente a laboratorio ejecutable local;
- distinga validacion tecnica de revision pedagogica del usuario;
- declare validaciones verificables;
- no contradiga las restricciones de unidades anteriores.

La Unidad 07 quedara completada cuando, en una sesion posterior al playbook aprobado:

- existan todos los documentos de `tutorial/07-local-terraform-automation/`;
- exista el proyecto Terraform local previsto;
- exista el laboratorio operativo;
- exista la validacion automatizada;
- las validaciones estaticas se hayan ejecutado;
- las validaciones funcionales se hayan ejecutado o queden registradas como pendientes con causa;
- `tutorial/07-local-terraform-automation/summary.md` registre continuidad hacia Unidad 08;
- `project/project-state.md` refleje el estado real;
- no existan secretos reales ni estados Terraform versionados.

---

# Estado final esperado

## Plataforma

- MicroK8s local sigue siendo la plataforma de ejecucion.
- No se crean recursos cloud.

## Aplicacion

- `platform-api` sigue desplegada en `platform-training`.
- El chart Helm de Unidad 06 sigue siendo el paquete de aplicacion.

## Automatizacion

- Terraform gestiona el release Helm local.
- Existe state local de laboratorio no versionado.
- Existen variables, outputs y validaciones.

## Seguridad

- No se versionan secretos reales.
- Los valores sensibles se tratan con placeholders y advertencias explicitas.

## Artefactos principales

```text
tutorial/07-local-terraform-automation/
labs/07-local-terraform-automation/
labs/07-local-terraform-automation/terraform/
labs/07-local-terraform-automation/validation/validate.sh
```

---

# Informacion obligatoria para el summary

El `summary.md` debera destacar:

- capacidad incorporada;
- artefactos creados;
- artefactos modificados;
- comandos de validacion principales;
- decisiones especificas;
- referencias principales utilizadas;
- dependencias nuevas;
- limitaciones;
- deuda tecnica;
- elementos que debe reutilizar la siguiente unidad;
- estado final verificable;
- si el release quedo gestionado por Terraform;
- si existe state local y donde queda no versionado;
- si hubo import o adopcion de release existente;
- si `terraform destroy` fue ejecutado o solo documentado.

---

# Impacto esperado en project-state

Al cerrar la unidad, actualizar como minimo:

- fase actual;
- ultima unidad completada;
- unidad siguiente;
- artefactos existentes;
- componentes desplegados;
- herramientas disponibles;
- versiones activas;
- decisiones;
- riesgos;
- deuda tecnica;
- siguiente incremento permitido.

No registrar componentes previstos como si estuvieran implementados.

---

# Conexion con la siguiente unidad

## Siguiente unidad prevista

```text
08 - CI/CD con Tekton
```

## Capacidades que deja preparadas

- chart Helm gestionable desde automatizacion declarativa;
- proyecto Terraform local;
- variables y outputs como interfaz de automatizacion;
- frontera clara entre Terraform, Helm y Kubernetes;
- base para que una pipeline ejecute validacion, plan y aplicacion controlada en una unidad posterior.
