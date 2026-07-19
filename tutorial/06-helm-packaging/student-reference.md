# Arquitectura avanzada de plantillas y gestion de variables en Helm

## Proposito de la referencia

Este documento es una referencia tecnica para consultar durante la Unidad 06 y las unidades posteriores. No sustituye a `student-notes.md`: aqui el foco esta en sintaxis, contexto, jerarquia de valores, helpers y la frontera conceptual con Terraform.

Los ejemplos usan `platform-api` y deben leerse como piezas pequeñas, no como recetas productivas completas.

## Modulo 1 - El compilador de Helm y el motor de plantillas de Go

### 1.1 Introduccion al motor `text/template` de Go

Helm toma archivos de texto en `templates/`, evalua expresiones delimitadas por `{{ ... }}` y produce YAML. El YAML resultante es lo que se envia al API server.

El punto `.` representa el contexto actual. Al principio suele contener objetos como:

| Objeto | Uso habitual |
|---|---|
| `.Values` | Valores fusionados del chart |
| `.Chart` | Metadatos de `Chart.yaml` |
| `.Release` | Nombre, namespace y servicio de instalacion |
| `.Capabilities` | Capacidades del cluster detectadas |

Ejemplo:

```yaml
app.kubernetes.io/instance: {{ .Release.Name }}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
```

El signo `$` conserva una referencia al contexto raiz. Es importante dentro de `range` o `with`, donde `.` cambia.

```gotemplate
{{- $root := . -}}
{{- range .Values.persistence.accessModes }}
- {{ . }}
# El chart sigue disponible como $root.Chart.Name
{{- end }}
```

### 1.2 Control estricto de espacios en blanco y sintaxis estandar

`{{-` elimina espacios antes de la expresion. `-}}` elimina espacios despues. Es util en bloques multilínea, pero peligroso en expresiones inline.

Seguro:

```yaml
labels:
{{- include "platform-api.labels" . | nindent 2 }}
```

Peligroso:

```yaml
name: {{- include "platform-api.fullname" . }}
```

El segundo caso puede renderizar `name:platform-api`, que no es lo que se busca.

Los pipelines encadenan transformaciones:

```yaml
training.k8s-platform.io/unit: {{ .Values.training.unit | quote }}
```

Funciones comunes:

| Funcion | Uso |
|---|---|
| `quote` | Proteger strings ambiguos |
| `lower` / `upper` | Normalizar texto |
| `default` | Elegir valor alternativo |
| `toYaml` | Convertir mapas o listas a YAML |
| `indent` / `nindent` | Ajustar sangria |
| `include` | Insertar helper como string |

## Modulo 2 - Jerarquia, fusion y sustitucion de variables

### 2.1 Ciclo de vida y flujo de prioridades

Helm fusiona valores con una prioridad general:

| Prioridad | Fuente |
|---|---|
| Menor | `values.yaml` del chart |
| Media | valores del chart padre, si existe |
| Media-alta | archivos `-f` en el orden indicado |
| Mayor | `--set`, `--set-string`, `--set-file` |

En la Unidad 06:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api \
  --namespace platform-training \
  --create-namespace \
  -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

`values.yaml` define defaults. `values-local.yaml` ajusta el laboratorio local. `--set` queda reservado para cambios pequeños y observables, por ejemplo una replica temporal:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api \
  --namespace platform-training \
  -f labs/06-helm-packaging/chart/platform-api/values-local.yaml \
  --set replicaCount=2
```

Riesgo: sobrescribir mapas complejos parcialmente puede destruir estructura esperada. Para configuraciones largas, usa archivos de valores.

### 2.2 Flujo de datos horizontal y descendente

Helm permite varios niveles de valores:

| Nivel | Descripcion | Estado en esta unidad |
|---|---|---|
| 1 | `charts/subchart/values.yaml` | No usado |
| 2 | sobrescritura desde chart padre | No usado |
| 3 | `.Values.global` | Solo referencia conceptual |
| 4 | archivos de entorno con `-f` | Usado con `values-local.yaml` |
| 5 | override quirurgico con `--set` | Usado solo para demostraciones pequeñas |

La Unidad 06 evita subcharts para no introducir otra capa antes de entender un chart simple.

## Modulo 3 - Estructuras de control de flujo y mutacion de contexto

### 3.1 Logica condicional avanzada

`if` evalua existencia, booleanos y resultados de funciones.

```gotemplate
{{- if .Values.ingress.enabled }}
kind: Ingress
{{- end }}
```

Operadores frecuentes usan notacion prefija:

```gotemplate
{{- if and .Values.persistence.enabled (eq .Values.service.type "ClusterIP") }}
```

### 3.2 Iteraciones eficientes en YAML

`range` itera listas o mapas:

```gotemplate
accessModes:
{{- range .Values.persistence.accessModes }}
  - {{ . }}
{{- end }}
```

Para mapas complejos, muchas veces `toYaml` es mas claro:

```gotemplate
nodeSelector:
{{- toYaml .Values.scheduling.nodeSelector | nindent 2 }}
```

### 3.3 Mutacion del ambito con `with`

`with` cambia `.` al valor indicado:

```gotemplate
{{- with .Values.resources }}
resources:
{{- toYaml . | nindent 2 }}
{{- end }}
```

Dentro de ese bloque, `.Values` ya no apunta al objeto raiz. Si necesitas volver al contexto original, usa `$`.

## Modulo 4 - Ingenieria de codigo reutilizable con `_helpers.tpl`

### 4.1 Declaracion e invocacion de bloques nombrados

`define` crea un bloque nombrado:

```gotemplate
{{- define "platform-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
```

`template` inserta salida directamente. `include` devuelve un string y permite pipelines, por eso suele combinarse con `nindent`.

```yaml
selector:
{{- include "platform-api.selectorLabels" . | nindent 2 }}
```

El contexto debe pasarse de forma explicita. Si llamas a un helper sin `.`, ese helper no tendra acceso a `.Values`, `.Chart` ni `.Release`.

### 4.2 Tecnicas de indentacion dinamica

`indent` anade espacios. `nindent` anade nueva linea y espacios. En YAML, `nindent` suele encajar mejor bajo claves como `labels:`.

```yaml
metadata:
  labels:
{{- include "platform-api.labels" . | nindent 4 }}
```

Regla practica:

```text
Si el helper produce varias lineas bajo una clave YAML, piensa primero en nindent.
Si estas en medio de una linea, evita {{- al inicio.
```

## Modulo 5 - Orquestacion con Terraform como siguiente nivel

### 5.1 El recurso `helm_release` de Terraform

Terraform puede gestionar un release Helm como recurso mediante el provider Helm. Conceptualmente, Terraform declararia:

- chart a instalar;
- namespace;
- valores;
- dependencias;
- sensibilidad de ciertos overrides;
- ciclo de vida del release.

Ejemplo conceptual no ejecutable en Unidad 06:

```hcl
resource "helm_release" "platform_api" {
  name      = "platform-api-local"
  chart     = "../labs/06-helm-packaging/chart/platform-api"
  namespace = "platform-training"

  values = [
    templatefile("values-local.yaml.tftpl", {
      ingress_host = "platform-api.local"
    })
  ]
}
```

`templatefile()` renderiza texto desde Terraform. `set_sensitive` protege valores sensibles en algunas salidas, pero no elimina todos los riesgos del estado. Por eso los secretos productivos quedan fuera de esta unidad.

Limite de alcance:

```text
Unidad 06: crear y operar el chart con Helm.
Unidad 07: gestionar la instalacion del chart desde Terraform.
```

## Diagnostico de errores frecuentes de renderizado

| Sintoma | Causa probable | Comprobacion | Recuperacion |
|---|---|---|---|
| `mapping values are not allowed` | Sangria YAML rota | `helm template` | Revisar `nindent`, `toYaml` y bloques |
| `nil pointer evaluating` | Ruta inexistente en `.Values` | `helm lint` y revisar values | Anadir default o corregir clave |
| `name:platform-api` | Uso incorrecto de `{{-` inline | Renderizado visible | Quitar guion inicial en expresion inline |
| Service sin endpoints | Labels/selectors no coinciden | `kubectl get pods --show-labels` | Centralizar selectors en helper |
| Override borra configuracion | `--set` o `-f` mal estructurado | `helm get values` | Usar archivo de valores completo |
| Secret real en values | Mala separacion de responsabilidades | Revision de repo | Sustituir por placeholder y rotar credencial |

## Referencias oficiales

| Fuente | Uso recomendado |
|---|---|
| [Helm Chart Template Guide](https://helm.sh/docs/chart_template_guide/) | Profundizar en motor de templates |
| [Helm Values Files](https://helm.sh/docs/chart_template_guide/values_files/) | Revisar prioridad de valores |
| [Helm Functions and Pipelines](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/) | Consultar funciones y pipelines |
| [Helm Named Templates](https://helm.sh/docs/chart_template_guide/named_templates/) | Diseñar helpers reutilizables |
| [Helm Subcharts and Global Values](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/) | Preparar unidades posteriores |
| [Terraform `templatefile`](https://developer.hashicorp.com/terraform/language/functions/templatefile) | Entender renderizado desde Terraform |
| [Terraform Helm provider `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Preparar Unidad 07 |
