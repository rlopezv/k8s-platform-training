# Unidad 06 - Empaquetado con Helm

## Guia pedagogica de la unidad

Esta unidad introduce Helm cuando `platform-api` ya tiene una forma suficientemente rica: configuracion externa, Secret ficticio, probes, resources, Service, Ingress, PVC, estrategia de rollout, scheduling seguro y PDB.

La pregunta ya no es "como escribo un Deployment?", sino:

```text
Como convierto un conjunto de manifiestos conocidos en un paquete instalable, parametrizable y repetible sin ocultar las decisiones de Kubernetes que ya entiendo?
```

Helm aparece aqui porque empaqueta decisiones existentes. No reemplaza Kubernetes, no convierte YAML en infraestructura como codigo por si solo y no debe transformar cada campo en una variable sin criterio.

Para estudiar el modelo mental completo usa `tutorial/06-helm-packaging/student-notes.md`. Para consultar sintaxis de templates, contexto, helpers, jerarquia de valores y frontera con Terraform usa `tutorial/06-helm-packaging/student-reference.md`. Para ejecutar el laboratorio usa `labs/06-helm-packaging/README.md`.

## Problema real

Hasta ahora el laboratorio aplicaba varios manifiestos independientes. Eso es claro para aprender Kubernetes, pero empieza a tener costes:

- hay que recordar el orden y el conjunto completo de ficheros;
- repetir el despliegue en otro entorno exige copiar y editar YAML;
- los nombres, labels y selectors aparecen en varios sitios;
- pequeños cambios de entorno pueden acabar mezclados con decisiones estructurales;
- validar el resultado completo requiere renderizar mentalmente muchos archivos.

Helm resuelve parte de ese problema empaquetando los manifiestos en un chart. El chart mantiene templates versionados y valores configurables. Helm renderiza esos templates, instala un release y guarda historial para upgrades y rollbacks.

## Objetivos

Al finalizar la unidad podras:

- explicar que son chart, template, values file y release;
- renderizar un chart local antes de instalarlo;
- instalar y actualizar `platform-api` con `helm upgrade --install`;
- inspeccionar valores, manifiestos, estado e historial de un release;
- ejecutar un rollback Helm y recuperar el estado esperado;
- distinguir valores por defecto, valores locales y overrides de CLI;
- reconocer errores de sangria, contexto y selectors en templates;
- justificar que debe parametrizarse y que debe quedar fijo;
- explicar por que Terraform queda diferido como ejecucion a la Unidad 07.

## Conocimientos previos

Debes venir de las Unidades 00 a 05. En particular:

- has aplicado manifiestos Kubernetes con `kubectl apply`;
- reconoces Deployment, ReplicaSet, Pod, Service, EndpointSlice, ConfigMap, Secret, Ingress, PVC y PDB;
- sabes validar rollout, readiness y respuesta HTTP por Ingress;
- entiendes que labels y selectors forman contratos entre recursos;
- has visto requests, limits, probes, strategy, affinity y PDB;
- tienes Helm instalado y validado como CLI local.

## Relacion con la Unidad 05

La Unidad 05 dejo una solucion estable en:

```text
labs/05-scheduling-resilience-maintenance/solution/
```

La Unidad 06 convierte esa solucion en:

```text
labs/06-helm-packaging/chart/platform-api/
```

El comportamiento esperado se conserva: namespace `platform-training`, aplicacion `platform-api`, dos replicas, Service `ClusterIP`, Ingress `platform-api.local`, PVC `platform-api-data`, Secret ficticio, PDB y constraints seguros de scheduling.

La diferencia es el mecanismo de gestion. Antes el estado se aplicaba como varios manifiestos nativos. Ahora se renderiza e instala como release Helm local llamado `platform-api-local`.

## Estado inicial

La unidad parte de:

- MicroK8s local validado;
- Helm `v3.21.0+ge0878d4` disponible;
- `platform-api` como aplicacion evolutiva;
- namespace funcional `platform-training`;
- salida validada de Unidad 05;
- ausencia de charts Helm y modulos Terraform previos del curso;
- Secret de laboratorio con valores ficticios.

## Mapa de aprendizaje

| Concepto | Responsabilidad | Pregunta de diagnostico |
|---|---|---|
| Chart | Paquete local de templates y valores | Que conjunto de recursos instala? |
| Template | Archivo que produce YAML Kubernetes | Que parte es Helm y que parte es Kubernetes? |
| Values | Datos que parametrizan templates | Que cambia entre entornos? |
| Release | Instalacion concreta de un chart | Que version esta activa en el cluster? |
| Renderizado | Transformacion de templates a YAML | Que YAML aplicaria Helm realmente? |
| Helpers | Bloques reutilizables en `_helpers.tpl` | Donde se centralizan nombres y labels? |
| Upgrade | Cambio de release | Que revision nueva se genero? |
| Rollback | Vuelta a una revision anterior | Que vuelve y que no vuelve? |

## Diseno del laboratorio

El chart local incluye:

- `Chart.yaml`;
- `values.yaml`;
- `values-local.yaml`;
- templates para Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB;
- helpers para nombres, labels, selectors y nombres derivados;
- validacion automatizada en `labs/06-helm-packaging/validation/validate.sh`.

La unidad parametriza imagen, replicas, Ingress, contenido visible, resources, scheduling, PVC y PDB. No parametriza todo por defecto: algunos campos permanecen fijos porque forman parte del contrato pedagogico y funcional del laboratorio.

## Validaciones

Las validaciones principales son:

```bash
bash -n labs/06-helm-packaging/validation/validate.sh
helm lint labs/06-helm-packaging/chart/platform-api
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml | kubectl apply --dry-run=client -f -
```

La validacion funcional requiere instalar o actualizar el release:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training --create-namespace -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
bash labs/06-helm-packaging/validation/validate.sh
```

## Errores de razonamiento frecuentes

- Creer que Helm sustituye a Kubernetes.
- Renderizar solo mentalmente y no ejecutar `helm template`.
- Convertir cada campo en valor configurable sin criterio.
- Usar `--set` para estructuras complejas como metodo principal.
- Perder el contexto dentro de `range` o `with`.
- Romper YAML por espacios en blanco o sangria incorrecta.
- Confundir rollback Helm con rollback Git.
- Introducir secretos reales en `values.yaml`.

## Resultado final

Al cierre de la unidad, `platform-api` queda empaquetada como chart local. El laboratorio conserva el comportamiento de Unidad 05 y anade instalacion, upgrade, inspeccion, renderizado y rollback con Helm.

La Unidad 07 podra reutilizar este chart para introducir Terraform como capa de automatizacion, sin mezclar todavia modulos Terraform dentro de la Unidad 06.

## Lectura guiada

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Helm - Chart Template Guide](https://helm.sh/docs/chart_template_guide/) | Introduccion, objetos, funciones y control de flujo | Entender el motor de renderizado |
| [Helm - Values Files](https://helm.sh/docs/chart_template_guide/values_files/) | Prioridad y combinacion de valores | Separar defaults de valores de entorno |
| [Helm - Named Templates](https://helm.sh/docs/chart_template_guide/named_templates/) | `define`, `template`, `include` | Centralizar nombres y labels |
| [Helm - Helm Commands](https://helm.sh/docs/helm/) | `install`, `upgrade`, `template`, `history`, `rollback` | Operar releases locales |
| [Terraform - `templatefile`](https://developer.hashicorp.com/terraform/language/functions/templatefile) | Funcion de renderizado de Terraform | Preparar la frontera conceptual de Unidad 07 |
| [Terraform Helm provider - `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Recurso `helm_release` | Entender lo que se diferira a la siguiente unidad |
