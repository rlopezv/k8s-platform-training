# Unidad 06 - Empaquetado con Helm

## Guía pedagógica de la unidad

Esta unidad introduce Helm cuando `platform-api` ya tiene una forma suficientemente rica: configuración externa, Secret ficticio, probes, resources, Service, Ingress, PVC, estrategia de rollout, scheduling seguro y PDB.

La pregunta ya no es "¿cómo escribo un Deployment?", sino:

```text
¿Cómo convierto un conjunto de manifiestos conocidos en un paquete instalable, parametrizable y repetible sin ocultar las decisiones de Kubernetes que ya entiendo?
```

Helm aparece aquí porque empaqueta decisiones existentes. No reemplaza Kubernetes, no convierte YAML en infraestructura como código por sí solo y no debe transformar cada campo en una variable sin criterio.

Para estudiar el modelo mental del laboratorio usa `tutorial/06-helm-packaging/student-notes.md`. Para consultar criterios profesionales, errores de razonamiento, templates, values, helpers, subcharts, hooks, repositorios y frontera con Terraform usa `tutorial/06-helm-packaging/student-reference.md`. Para ejecutar los pasos operativos usa `labs/06-helm-packaging/README.md`.

---

## Problema real

Hasta ahora el laboratorio aplicaba varios manifiestos independientes. Eso es claro para aprender Kubernetes, pero empieza a tener costes:

- hay que recordar el conjunto completo de ficheros;
- repetir el despliegue en otro entorno exige copiar y editar YAML;
- los nombres, labels y selectors aparecen en varios sitios;
- pequeños cambios de entorno pueden mezclarse con decisiones estructurales;
- validar el resultado completo requiere mirar muchos archivos a la vez.

Helm resuelve parte de ese problema empaquetando los manifiestos en un chart. El chart mantiene templates versionados y valores configurables. Helm renderiza esos templates, instala un release y guarda historial para upgrades y rollbacks.

---

## Objetivos

Al finalizar la unidad podrás:

- explicar qué son chart, template, values file y release;
- renderizar un chart local antes de instalarlo;
- instalar y actualizar `platform-api` con `helm upgrade --install`;
- inspeccionar valores, manifiestos, estado e historial de un release;
- ejecutar un rollback Helm y recuperar el estado esperado;
- distinguir valores por defecto, valores locales y overrides de CLI;
- reconocer fallos de sangría, contexto y selectors en templates;
- justificar qué debe parametrizarse y qué debe quedar fijo;
- explicar por qué Terraform queda diferido como ejecución a la Unidad 07.

---

## Conocimientos previos

Debes venir de las Unidades 00 a 05. En particular:

- has aplicado manifiestos Kubernetes con `kubectl apply`;
- reconoces Deployment, ReplicaSet, Pod, Service, EndpointSlice, ConfigMap, Secret, Ingress, PVC y PDB;
- sabes validar rollout, readiness y respuesta HTTP por Ingress;
- entiendes que labels y selectors forman contratos entre recursos;
- has visto requests, limits, probes, strategy, affinity y PDB;
- tienes Helm instalado y validado como CLI local.

---

## Relación con la Unidad 05

La Unidad 05 dejó una solución estable en:

```text
labs/05-scheduling-resilience-maintenance/solution/
```

La Unidad 06 convierte esa solución en:

```text
labs/06-helm-packaging/chart/platform-api/
```

El comportamiento esperado se conserva: namespace `platform-training`, aplicación `platform-api`, dos réplicas, Service `ClusterIP`, Ingress `platform-api.local`, PVC `platform-api-data`, Secret ficticio, PDB y constraints seguros de scheduling.

La diferencia es el mecanismo de gestión. Antes el estado se aplicaba como varios manifiestos nativos. Ahora se renderiza e instala como release Helm local llamado `platform-api-local`.

---

## Estado inicial

La unidad parte de:

- MicroK8s local validado;
- Helm `v3.21.0+ge0878d4` disponible según el estado registrado;
- `platform-api` como aplicación evolutiva;
- namespace funcional `platform-training`;
- salida validada de Unidad 05;
- ausencia histórica de charts Helm y módulos Terraform previos del curso antes de generar esta unidad;
- Secret de laboratorio con valores ficticios.

---

## Mapa de aprendizaje

| Concepto | Responsabilidad | Pregunta de diagnóstico |
|---|---|---|
| Chart | Paquete local de templates y valores | ¿Qué conjunto de recursos instala? |
| Template | Archivo que produce YAML Kubernetes | ¿Qué parte es Helm y qué parte es Kubernetes? |
| Values | Datos que parametrizan templates | ¿Qué cambia entre entornos? |
| Release | Instalación concreta de un chart | ¿Qué revisión está activa en el clúster? |
| Renderizado | Transformación de templates a YAML | ¿Qué YAML aplicaría Helm realmente? |
| Helpers | Bloques reutilizables en `_helpers.tpl` | ¿Dónde se centralizan nombres y labels? |
| Upgrade | Cambio de release | ¿Qué revisión nueva se generó? |
| Rollback | Vuelta a una revisión anterior | ¿Qué vuelve y qué no vuelve? |

---

## Diseño del laboratorio

El chart local incluye:

- `Chart.yaml`;
- `values.yaml`;
- `values-local.yaml`;
- templates para Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB;
- helpers para nombres, labels, selectors y nombres derivados;
- validación automatizada en `labs/06-helm-packaging/validation/validate.sh`.

La unidad parametriza imagen, réplicas, Ingress, contenido visible, resources, scheduling, PVC y PDB. No parametriza todo por defecto: algunos campos permanecen fijos porque forman parte del contrato pedagógico y funcional del laboratorio.

---

## Validaciones

Las validaciones principales aparecen en el README del laboratorio:

```text
labs/06-helm-packaging/README.md
```

El flujo operativo incluye renderizado, lint, dry-run cliente, instalación o upgrade, inspección del release, rollback y validación automatizada. Este README de unidad no sustituye esas instrucciones.

Durante el saneamiento documental de fase 4 no se ejecutan validaciones funcionales nuevas ni se modifican laboratorios.

---

## Errores de razonamiento

Helm suele generar confusiones distintas de los fallos operativos del laboratorio. Por ejemplo: creer que Helm sustituye a Kubernetes, pensar que `helm lint` garantiza disponibilidad, parametrizar todo sin criterio o guardar secretos reales en values.

Esos errores conceptuales se explican en:

```text
tutorial/06-helm-packaging/student-reference.md
```

Los fallos operativos para completar el laboratorio se diagnostican en `tutorial/06-helm-packaging/student-notes.md` y `labs/06-helm-packaging/README.md`.

---

## Resultado final

Al cierre técnico de la unidad, `platform-api` queda empaquetada como chart local. El laboratorio conserva el comportamiento de Unidad 05 y añade instalación, upgrade, inspección, renderizado y rollback con Helm.

La Unidad 07 reutiliza este chart para introducir Terraform como capa de automatización, sin mezclar módulos Terraform dentro de la Unidad 06.

---

## Lectura guiada

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Helm - Charts](https://helm.sh/docs/topics/charts/) | Estructura de charts | Ubicar cada archivo del laboratorio |
| [Helm - Chart Template Guide](https://helm.sh/docs/chart_template_guide/) | Introducción, objetos, funciones y control de flujo | Entender el motor de renderizado |
| [Helm - Values Files](https://helm.sh/docs/chart_template_guide/values_files/) | Prioridad y combinación de valores | Separar defaults de valores de entorno |
| [Helm - Named Templates](https://helm.sh/docs/chart_template_guide/named_templates/) | `define`, `template`, `include` | Centralizar nombres y labels |
| [Helm - Helm Commands](https://helm.sh/docs/helm/) | `install`, `upgrade`, `template`, `history`, `rollback` | Operar releases locales |
| [Terraform Helm provider - `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Recurso `helm_release` | Entender lo que se difiere a la Unidad 07 |
