# Referencia del alumno — Unidad 06: Empaquetado con Helm

## Propósito de la referencia

Esta referencia amplía `tutorial/06-helm-packaging/student-notes.md`. Las notas explican cómo completar el laboratorio; este documento organiza la visión profesional que necesitas para razonar sobre Helm más allá del primer chart local.

Aplica cobertura de panorama, profundidad, criterio y práctica. Cubre arquitectura de charts, templates, contexto, values, helpers, releases, rollback, subcharts, umbrella charts, hooks, `helm test`, repositorios y frontera con Terraform hasta poder leer el chart de `labs/06-helm-packaging/chart/platform-api/` sin tratar Helm como una caja negra. La Unidad 06 no tiene una laguna propia asignada en `project/content-gap-register.md` y usa la excepción de tamaño declarada para profundizar en subcharts, umbrella y hooks como criterio, sin práctica ejecutable.

No instala Tekton ni Argo CD, no crea módulos Terraform, no ejecuta `helm_release`, no publica charts, no añade subcharts ejecutables, no crea hooks, no configura `helm test`, no cambia `platform-api`, no altera el namespace `platform-training` y no modifica el estado técnico del clúster.

---

## Relación con la unidad

La Unidad 06 practica:

- empaquetar `platform-api` como chart Helm local;
- renderizar templates antes de instalar;
- separar defaults del chart y valores locales;
- instalar, actualizar, inspeccionar y revertir un release;
- conservar el comportamiento Kubernetes acumulado desde la Unidad 05;
- validar el chart, el release y los recursos renderizados.

Ten delante estos artefactos mientras lees:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Chart local | `labs/06-helm-packaging/chart/platform-api/` | Organización general del paquete Helm |
| Metadatos | `labs/06-helm-packaging/chart/platform-api/Chart.yaml` | Nombre, versión y tipo de chart |
| Defaults | `labs/06-helm-packaging/chart/platform-api/values.yaml` | Qué decide el chart por defecto |
| Values locales | `labs/06-helm-packaging/chart/platform-api/values-local.yaml` | Qué cambia para MicroK8s local |
| Helpers | `labs/06-helm-packaging/chart/platform-api/templates/_helpers.tpl` | Centralización de nombres, labels y selectors |
| Templates | `labs/06-helm-packaging/chart/platform-api/templates/` | Conversión de recursos Kubernetes conocidos en plantillas |
| Laboratorio operativo | `labs/06-helm-packaging/README.md` | Secuencia ejecutable, validación y recuperación |
| Notas del alumno | `tutorial/06-helm-packaging/student-notes.md` | Diagnóstico operativo y flujo de aprendizaje |

---

## Mapa conceptual

```text
Chart versionado
  -> Chart.yaml describe el paquete
  -> values.yaml define defaults
  -> values-local.yaml ajusta el entorno local
  -> templates/ contiene YAML con expresiones Helm
  -> _helpers.tpl centraliza nombres, labels y selectors
  -> helm template renderiza YAML Kubernetes
  -> helm upgrade --install crea o actualiza un release
  -> Kubernetes reconcilia Deployment, Service, Ingress, PVC y PDB
  -> Helm guarda historial del release para inspección, upgrade y rollback
```

La distinción principal es que Helm no crea una API nueva para ejecutar aplicaciones. Kubernetes sigue ejecutando Pods, Services, Ingress, PVCs y PDBs. Helm empaqueta los manifiestos, calcula el YAML final y registra una instalación concreta llamada release.

También debes separar paquete e instalación. Un chart puede existir en Git sin estar instalado. Un release es una instalación concreta de ese chart con un nombre, un namespace, unos values efectivos y un historial. Dos releases podrían venir del mismo chart y tener values distintos.

---

## Conceptos y mecanismos

### Chart

Un chart es un paquete de Kubernetes. Agrupa metadatos, valores y templates para producir un conjunto coherente de manifiestos.

En esta unidad, el chart no inventa `platform-api`; empaqueta recursos que ya existían como manifiestos planos:

```text
Deployment + ConfigMap + Secret ficticio + Service + Ingress + PVC + PDB
```

Qué resuelve: distribución, repetición y parametrización de un conjunto de recursos. Qué no resuelve: disponibilidad, networking, persistencia o seguridad por sí mismo. Esas capacidades siguen dependiendo de Kubernetes y de las decisiones del chart.

### `Chart.yaml`

`Chart.yaml` identifica el paquete. Contiene nombre, descripción, tipo, versión del chart y versión de la aplicación cuando procede.

La versión del chart y la versión de la imagen no significan lo mismo. La primera describe el paquete; la segunda describe el artefacto de aplicación que el Deployment ejecutará. Confundirlas produce releases difíciles de auditar.

### Values y jerarquía de configuración

Helm fusiona valores con prioridad creciente:

```text
values.yaml del chart
  -> values del chart padre, si existe
  -> archivos -f en el orden indicado
  -> --set, --set-string y --set-file
```

En el laboratorio:

```text
values.yaml
  -> values-local.yaml
```

`values.yaml` expresa defaults razonables del chart. `values-local.yaml` adapta el despliegue a MicroK8s. `--set` se reserva para demostraciones pequeñas, como cambiar un texto visible durante un upgrade.

Qué resuelve: separar configuración variable de estructura estable. Qué no resuelve: una estrategia completa de entornos, secretos o promoción.

### Templates y contexto

Un template es texto con expresiones Helm. Helm evalúa esas expresiones y produce YAML Kubernetes.

El contexto inicial suele ofrecer objetos como:

| Objeto | Uso habitual |
|---|---|
| `.Values` | Valores fusionados del chart |
| `.Chart` | Metadatos de `Chart.yaml` |
| `.Release` | Nombre, namespace y estado del release |
| `.Capabilities` | Capacidades detectadas del clúster |

Ejemplo:

```yaml
app.kubernetes.io/instance: {{ .Release.Name }}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

El punto `.` significa "contexto actual". Dentro de `range` o `with`, ese contexto cambia. El símbolo `$` conserva el contexto raíz:

```gotemplate
{{- $root := . -}}
{{- range .Values.persistence.accessModes }}
- {{ . }}
# $root sigue apuntando al contexto completo del chart.
{{- end }}
```

Qué resuelve: permite generar YAML desde datos. Qué no resuelve: no valida automáticamente que tu intención operativa sea buena.

### Control de flujo

`if`, `range` y `with` son herramientas de composición, no un objetivo en sí mismas.

`if` permite activar un recurso o bloque:

```gotemplate
{{- if .Values.ingress.enabled }}
kind: Ingress
{{- end }}
```

`range` recorre listas o mapas:

```gotemplate
accessModes:
{{- range .Values.persistence.accessModes }}
  - {{ . }}
{{- end }}
```

`with` reduce rutas largas, pero cambia el significado de `.`:

```gotemplate
{{- with .Values.resources }}
resources:
{{- toYaml . | nindent 2 }}
{{- end }}
```

La regla práctica: si al leer el template no puedes reconstruir el YAML final, el control de flujo está ocultando demasiado.

### Funciones, pipelines y YAML

Los pipelines encadenan transformaciones:

```yaml
training.k8s-platform.io/unit: {{ .Values.training.unit | quote }}
```

Funciones frecuentes:

| Función | Qué aporta |
|---|---|
| `quote` | Evita interpretaciones ambiguas de strings |
| `default` | Define valor alternativo cuando falta uno |
| `toYaml` | Convierte mapas o listas a YAML |
| `indent` | Añade espacios a un bloque |
| `nindent` | Añade nueva línea y espacios a un bloque |
| `include` | Inserta helper como string y permite pipelines |
| `tpl` | Evalúa una cadena como template |
| `merge` | Combina mapas en escenarios avanzados |

`tpl` y `merge` son potentes, pero deben usarse con prudencia. `tpl` permite que un valor contenga expresiones template; eso puede ser útil en charts extensibles, pero también dificulta saber de dónde sale el YAML final. `merge` ayuda a combinar mapas, pero puede esconder precedencia y nulos si no se documenta bien. En esta unidad bastan para criterio: reconocerlos y saber cuándo la complejidad supera al beneficio.

### Espacios, sangría y nulos

Helm renderiza texto. Kubernetes recibe YAML. Entre ambos, un espacio mal situado puede cambiarlo todo.

`{{-` elimina espacios antes de la expresión. `-}}` elimina espacios después. Funciona bien al iniciar bloques:

```yaml
labels:
{{- include "platform-api.labels" . | nindent 2 }}
```

Es peligroso en mitad de una línea:

```yaml
name: {{- include "platform-api.fullname" . }}
```

Ese patrón puede acabar pegando `name:` al valor. Por eso conviene renderizar siempre antes de instalar.

Los nulos también importan. Un value ausente, un mapa vacío o una clave con `null` pueden renderizar YAML distinto. En charts profesionales, las plantillas suelen proteger estos casos con defaults, `with`, `if` y validación de values.

### Helpers

`_helpers.tpl` contiene bloques nombrados para reutilizar nombres, labels y selectors.

```gotemplate
{{- define "platform-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
```

`include` devuelve texto y puede combinarse con `nindent`:

```yaml
selector:
{{- include "platform-api.selectorLabels" . | nindent 2 }}
```

Qué resuelve: evita duplicación y reduce errores entre Deployment, Service y PDB. Qué no resuelve: no sustituye el diseño del contrato de labels. Si los helpers centralizan un contrato malo, lo repiten con eficacia.

### Release e historial

Un release es una instalación de un chart. Helm guarda revisiones con los values y manifiestos relevantes para poder inspeccionar, actualizar y revertir.

El release de la unidad se llama:

```text
platform-api-local
```

El nombre del release aparece en labels como `app.kubernetes.io/instance`. Cambiarlo no es un detalle estético: puede afectar selectors, adopción de recursos y lectura del historial.

Rollback Helm vuelve a una revisión del release. No arregla automáticamente el repositorio, no recupera datos borrados y no equivale a una estrategia GitOps de promoción.

### Subcharts, values globales y umbrella charts

Un subchart es una dependencia empaquetada dentro de un chart padre. Se declara como dependencia del chart y tiene su propio `Chart.yaml`, sus propios templates y sus propios defaults. El chart padre no copia los templates del subchart: lo incluye como dependencia y le pasa configuración.

Conceptualmente, la relación se parece a:

```yaml
dependencies:
  - name: redis
    version: 20.x.x
    repository: oci://registry.example/charts
    condition: redis.enabled
```

El chart padre puede sobrescribir valores del subchart usando una clave con el nombre de la dependencia:

```yaml
redis:
  enabled: true
  architecture: standalone
```

El flujo de values queda separado por alcance:

```text
values del subchart
  -> values que el chart padre pasa bajo la clave del subchart
  -> .Values.global, si se usa para valores compartidos
  -> archivos -f y overrides de instalación
```

`.Values.global` sirve para datos transversales que varias dependencias necesitan, por ejemplo un dominio base, una convención de labels o una configuración común de imagen. No debe usarse como cajón compartido para evitar diseñar interfaces claras entre charts. Si todo termina en `global`, el chart padre queda acoplado a detalles internos de cada subchart.

Un umbrella chart coordina varios charts como una topología. Por ejemplo, podría agrupar `platform-api` y una base de datos auxiliar, activando o desactivando dependencias con `condition` o `tags`:

```yaml
tags:
  datastore: true

redis:
  enabled: true
```

Qué resuelve: instalar una composición de componentes con un único release o una única unidad de empaquetado. Qué no resuelve: ownership entre equipos, compatibilidad de versiones, backup de datos, actualización segura de dependencias ni recuperación si una dependencia cambia su contrato.

El criterio profesional es tratar cada subchart como un producto con ciclo de vida. Antes de añadirlo, pregunta:

- quién mantiene esa dependencia;
- cómo se versiona y actualiza;
- qué valores del subchart se exponen al chart padre;
- qué datos persistentes crea;
- qué ocurre si falla el upgrade de una dependencia;
- si conviene que esa dependencia sea parte del mismo release o tenga release propio.

La Unidad 06 no practica subcharts ni umbrella charts porque `platform-api` aún no necesita dependencias empaquetadas. Lo importante ahora es aprender a leer un chart simple con precisión.

### Hooks y `helm test`

Los hooks ejecutan recursos Kubernetes en momentos concretos del ciclo de vida de un release. Se declaran con annotations sobre un recurso, habitualmente un `Job`:

```yaml
metadata:
  annotations:
    "helm.sh/hook": pre-install
    "helm.sh/hook-weight": "0"
    "helm.sh/hook-delete-policy": before-hook-creation,hook-succeeded
```

Hooks habituales:

| Hook | Momento conceptual | Uso típico |
|---|---|---|
| `pre-install` | Antes de crear recursos del release | Comprobaciones previas o preparación |
| `post-install` | Después de instalar | Verificación o inicialización |
| `pre-upgrade` | Antes de actualizar | Migraciones o comprobaciones |
| `post-upgrade` | Después de actualizar | Validación posdespliegue |
| `pre-delete` | Antes de borrar | Limpieza controlada |
| `post-delete` | Después de borrar | Limpieza auxiliar |
| `test` | Cuando se ejecuta `helm test` | Pruebas empaquetadas |

El hook no es magia fuera de Kubernetes: normalmente renderiza un recurso como cualquier otro template. Lo especial es que Helm decide cuándo ejecutarlo y cómo lo relaciona con el ciclo del release.

`helm.sh/hook-weight` ordena hooks cuando hay varios en el mismo momento. `helm.sh/hook-delete-policy` define cuándo borrar recursos generados por hooks. Si no hay política clara, los Jobs y Pods de hooks pueden acumularse o dificultar el diagnóstico.

`helm test` ejecuta recursos anotados como test. Sirve para comprobaciones posdespliegue que pertenecen al paquete, por ejemplo verificar que un Service responde desde dentro del clúster. No sustituye observabilidad, pruebas de integración completas ni validación de negocio.

Un patrón conceptual de test sería:

```yaml
metadata:
  annotations:
    "helm.sh/hook": test
```

Los hooks son útiles, pero tienen coste operativo: idempotencia, permisos, limpieza, timeout, orden y diagnóstico. Un hook de migración de base de datos, por ejemplo, no debería añadirse sin estrategia de rollback de datos, backups, observabilidad y decisión clara sobre qué ocurre si la migración termina bien pero el upgrade falla después.

Qué resuelven: conectar acciones puntuales al ciclo de vida del release. Qué no resuelven: transacciones distribuidas, recuperación de datos, garantías de entrega continua ni diseño de migraciones seguras.

La Unidad 06 los menciona como práctica profesional, no los implementa.

### Repositorios remotos y OCI

Un chart local sirve para aprender. En equipos, el paquete suele publicarse en un repositorio Helm o en un OCI registry, con versionado, autenticación y política de promoción.

Publicar el chart cambia el problema: ya no solo importa que renderice, sino quién puede publicarlo, quién lo consume, cómo se firman versiones, cómo se revocan paquetes defectuosos y cómo se alinea la versión del chart con la versión de la aplicación.

### Frontera con Terraform

Helm empaqueta y renderiza. Terraform, en la Unidad 07, gestionará la existencia del release como recurso declarativo.

Conceptualmente, Terraform puede declarar:

```hcl
resource "helm_release" "platform_api" {
  name      = "platform-api-local"
  chart     = "../../06-helm-packaging/chart/platform-api"
  namespace = "platform-training"
}
```

Eso no convierte Terraform en dueño de cada template. El chart sigue siendo responsabilidad de Helm. Terraform orquesta la instalación del release y registra state sobre esa propiedad.

---

## Criterios de decisión

### Cuándo usar Helm

Helm encaja cuando un conjunto de recursos Kubernetes se instala repetidamente, necesita values por entorno, requiere historial de releases o debe consumirse como paquete por otras herramientas.

En esta unidad se elige porque `platform-api` ya tiene suficientes recursos como para que los manifiestos planos empiecen a ser costosos de mantener.

### Cuándo no usar Helm todavía

No conviene introducir Helm para ocultar conceptos de Kubernetes que el equipo no entiende. Si nadie puede leer el YAML renderizado, Helm solo desplaza el problema.

Tampoco conviene empaquetar una aplicación trivial con una abstracción excesiva si el coste de templates, helpers y values supera el beneficio.

### Qué parametrizar

Parametriza lo que cambia legítimamente entre entornos o ejecuciones: imagen, tag, réplicas, host de Ingress, resources, storage, flags de configuración o valores visibles de laboratorio.

Mantén fijo lo que forma parte del contrato del recurso o del curso: nombres funcionales necesarios para continuidad, labels base, selectors y estructura de recursos. Si un selector cambia por values sin control, el Service puede quedarse sin endpoints.

### Cuándo usar `values.yaml`, `values-local.yaml` y `--set`

`values.yaml` define defaults del chart. Un archivo como `values-local.yaml` expresa un entorno completo y revisable. `--set` sirve para cambios pequeños, temporales o de demostración.

Usar `--set` para estructuras profundas suele empeorar auditoría y reproducibilidad. Si el cambio debe repetirse o revisarse, merece un archivo de valores.

### Cuándo usar helpers

Usa helpers para contratos repetidos: nombre completo, labels comunes, labels de selector y nombres derivados. No los uses para esconder lógica de negocio o producir templates imposibles de leer.

Un helper bueno reduce duplicación. Un helper excesivo convierte el chart en un laberinto.

### Cuándo considerar subcharts o umbrella charts

Considera subcharts cuando tienes dependencias empaquetables con ciclo de vida propio. Considera umbrella charts cuando necesitas coordinar varios charts como una topología.

Evítalos cuando solo quieres agrupar por comodidad recursos que el equipo no sabe operar por separado. En producción, las dependencias también implican ownership, upgrades, seguridad y recuperación.

### Cómo pensar rollback

Rollback Helm es útil para volver a una revisión previa del release, pero no debe confundirse con recuperación completa. Si un cambio migró datos, borró un PVC o ejecutó un hook irreversible, volver al manifiesto anterior puede no recuperar el estado anterior de la aplicación.

---

## Relación con el laboratorio

El laboratorio practica:

- chart local de `platform-api`;
- `Chart.yaml`, `values.yaml`, `values-local.yaml` y `templates/`;
- helpers para nombres, labels y selectors;
- renderizado con `helm template`;
- lint con `helm lint`;
- dry-run cliente del YAML renderizado;
- adopción de recursos heredados mediante metadata Helm;
- instalación y upgrade con Helm CLI;
- inspección de values, manifest, status e history;
- rollback de release local;
- validación del release y de recursos Kubernetes.

El laboratorio menciona, pero no practica:

- repositorios Helm remotos u OCI;
- firma, provenance y políticas de supply chain;
- subcharts y umbrella charts;
- hooks y `helm test`;
- `tpl`, `merge` y control avanzado de nulos en escenarios complejos;
- gestión real de secretos;
- TLS productivo;
- promoción formal entre entornos;
- Terraform `helm_release`;
- CI/CD, Tekton, Argo CD y GitOps;
- Service mesh;
- topology spread constraints;
- AKS y EKS.

Restricción de la unidad: no modifiques el laboratorio para introducir herramientas posteriores. Si necesitas explicar una práctica profesional que no se ejecuta, déjala como criterio en esta referencia y ancla su continuidad.

Los elementos no practicados quedan anclados así: Terraform `helm_release` en Unidad 07; CI/CD y Tekton en Unidad 08; Argo CD, GitOps y gestión real de secretos en Unidad 09; promoción entre entornos en Unidad 10; Service mesh y seguridad de plataforma en Unidad 16; topology spread constraints y escalado en Unidad 18; desacoplamiento de MicroK8s en Unidad 19; AKS, EKS, registries cloud y prácticas cloud en Unidades 19-25. La firma de charts, provenance y publicación OCI quedan como criterio de supply chain para unidades posteriores de CI/CD, seguridad o cloud; no tienen práctica asignada en Unidad 06.

---

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Creer que Helm sustituye a Kubernetes | Kubernetes sigue reconciliando los recursos; Helm solo empaqueta, renderiza y gestiona releases |
| Creer que `helm lint` garantiza disponibilidad | Lint puede pasar aunque el Deployment no quede Ready o el Service no tenga endpoints |
| Convertir cada campo en value | Produce charts difíciles de operar y rompe contratos como labels y selectors |
| Usar `--set` para configuración compleja | Reduce reproducibilidad y dificulta auditoría de cambios |
| Confundir `values.yaml` con values de entorno | Mezcla defaults del paquete con decisiones locales o productivas |
| Olvidar que `.` cambia dentro de `range` y `with` | Puede renderizar rutas incorrectas o provocar errores por valores inexistentes |
| Usar `{{-` en mitad de una línea sin mirar el renderizado | Puede romper YAML de forma sutil |
| Duplicar labels en cada template | Aumenta el riesgo de que Service, PDB y Deployment dejen de seleccionar lo mismo |
| Guardar secretos reales en values | Values, releases, historial y permisos de lectura pueden exponer datos sensibles |
| Confundir rollback Helm con recuperación completa | Rollback no recupera datos borrados ni corrige automáticamente Git |

---

## Continuidad

Unidad 07 usará el chart de esta unidad como entrada para Terraform. Retomará la frontera: Helm empaqueta y renderiza; Terraform orquesta el release y registra state.

Unidad 08 introducirá Tekton y CI/CD. Reutilizará la idea de validar antes de aplicar, pero trasladada a pasos controlados de pipeline.

Unidad 09 introducirá Argo CD y GitOps. Retomará el chart como artefacto declarativo y tratará la gestión real de secretos sin guardarlos en Git.

Unidad 10 tratará promoción entre entornos. La separación entre defaults, values locales y overrides será base para hablar de entornos, revisión y promoción.

Unidad 16 retomará seguridad de plataforma, secret management, políticas, mTLS y Service mesh como criterio profesional.

Unidad 18 retomará distribución y escalado. Allí encajan `topologySpreadConstraints`, capacidad y relación entre réplicas, scheduling y coste.

Unidad 19 separará formalmente Kubernetes estándar, MicroK8s y plataformas gestionadas. Los values de esta unidad servirán para inventariar qué supuestos eran locales.

Unidades 19-25 cubrirán AKS, EKS, storage cloud, Ingress cloud, registries, identidad y diferencias de operación entre plataformas gestionadas.

---

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Helm - Charts](https://helm.sh/docs/topics/charts/) | Estructura de charts y metadatos | ¿Qué parte del directorio es paquete y qué parte es configuración? |
| [Helm - Chart Template Guide](https://helm.sh/docs/chart_template_guide/) | Objetos, contexto y motor de templates | ¿Qué YAML recibirá Kubernetes después del renderizado? |
| [Helm - Values Files](https://helm.sh/docs/chart_template_guide/values_files/) | Prioridad y fusión de values | ¿Qué valor gana cuando se combinan defaults, `-f` y `--set`? |
| [Helm - Functions and Pipelines](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/) | Pipelines y funciones comunes | ¿Cuándo necesitas `quote`, `toYaml`, `indent` o `nindent`? |
| [Helm - Named Templates](https://helm.sh/docs/chart_template_guide/named_templates/) | `define`, `include` y helpers | ¿Por qué centralizar labels y selectors reduce fallos? |
| [Helm - Subcharts and Global Values](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/) | Dependencias y `.Values.global` | ¿Cuándo una dependencia merece subchart y cuándo no? |
| [Helm - Hooks](https://helm.sh/docs/topics/charts_hooks/) | Ciclo de vida de hooks | ¿Qué riesgo introduce un hook si no es idempotente? |
| [Helm - Chart Tests](https://helm.sh/docs/topics/chart_tests/) | Tests empaquetados en un chart | ¿Qué validaría `helm test` que no valida `helm lint`? |
| [Helm - Registries](https://helm.sh/docs/topics/registries/) | Uso de charts con OCI | ¿Qué cambia cuando el chart deja de ser solo local? |
| [Terraform Helm provider - `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Recurso que gestionará la Unidad 07 | ¿Qué responsabilidad pasará a Terraform sin quitarle a Helm el chart? |
