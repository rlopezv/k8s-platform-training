# Referencia del alumno — Unidad 07: Automatización local con Terraform

## Propósito de la referencia

Esta referencia amplía `tutorial/07-local-terraform-automation/student-notes.md`. Las notas explican cómo completar el laboratorio; este documento organiza la visión profesional que necesitas para razonar sobre Terraform más allá de la ejecución local.

Aplica cobertura de panorama, profundidad, criterio y práctica. Cubre Terraform Core, providers, state, variables, expresiones, módulos, backends, secretos y `helm_release` hasta poder leer los artefactos de `labs/07-local-terraform-automation/terraform/`. También cierra `GAP-010`: la frontera de propiedad entre un release Helm gestionado por Terraform y una futura reconciliación GitOps con Argo CD.

No instala Tekton ni Argo CD, no crea recursos cloud, no configura backends remotos, no modifica el chart de Unidad 06, no cambia `platform-api`, no altera el namespace `platform-training`, no ejecuta `terraform apply` y no modifica el estado técnico del clúster.

---

## Relación con la unidad

La Unidad 07 practica:

- inicializar un proyecto Terraform local;
- declarar providers Helm y Kubernetes;
- gestionar `platform-api-local` mediante `helm_release.platform_api`;
- parametrizar valores del chart con variables y `templatefile()`;
- exponer outputs no sensibles;
- comparar lo que ven Terraform, Helm y Kubernetes.

Ten delante estos artefactos mientras lees:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Proyecto Terraform | `labs/07-local-terraform-automation/terraform/` | Separación entre providers, variables, recurso principal y outputs |
| Versiones | `labs/07-local-terraform-automation/terraform/versions.tf` | Restricciones de Terraform y providers |
| Providers | `labs/07-local-terraform-automation/terraform/providers.tf` | Conexión local con kubeconfig y contexto Kubernetes |
| Variables | `labs/07-local-terraform-automation/terraform/variables.tf` | Tipos, defaults, validaciones y sensibilidad |
| Recurso principal | `labs/07-local-terraform-automation/terraform/main.tf` | Uso de `helm_release`, `templatefile()` y `set_sensitive` |
| Outputs | `labs/07-local-terraform-automation/terraform/outputs.tf` | Información no sensible para inspección o automatización posterior |
| Valores renderizados | `labs/07-local-terraform-automation/terraform/values/platform-api-values.yaml.tftpl` | Puente entre variables Terraform y values Helm |
| Chart heredado | `labs/06-helm-packaging/chart/platform-api/` | Paquete real que Terraform instala o actualiza |
| Laboratorio operativo | `labs/07-local-terraform-automation/README.md` | Secuencia ejecutable, validación y recuperación |

---

## Mapa conceptual

```text
HCL versionado
  -> Terraform Core evalúa variables, expresiones y grafo
  -> providers traducen intención a APIs externas
  -> provider Helm gestiona helm_release.platform_api
  -> Helm instala o actualiza el chart de platform-api
  -> Kubernetes reconcilia Deployment, Service, Ingress, PVC y PDB
  -> terraform.tfstate registra qué cree Terraform que gestiona
  -> outputs exponen datos no sensibles para observación o automatización
```

La distinción más importante es la de responsabilidad. Kubernetes no sabe qué es Terraform. Helm no sabe que una pipeline futura puede ejecutar Terraform. Terraform no renderiza cada template del chart como si fuera dueño directo de todos los objetos Kubernetes: gestiona un release Helm.

También hay una distinción de tiempo. Terraform trabaja por ejecuciones discretas: evalúa, planifica y aplica. GitOps, que llegará en la Unidad 09, reconciliará de forma continua desde Git. Si ambos intentan gobernar el mismo release o los mismos manifiestos, el problema no es de sintaxis; es de propiedad.

---

## Conceptos y mecanismos

### Terraform Core y HCL

Terraform Core lee ficheros `.tf`, resuelve variables, evalúa expresiones, construye un grafo de dependencias y compara configuración, state y realidad externa. HCL es el lenguaje declarativo con el que describes esa intención.

Core no sabe instalar releases Helm por sí mismo. Esta configuración solo tiene efecto sobre Helm porque declara el provider correspondiente:

```hcl
required_providers {
  helm = {
    source  = "hashicorp/helm"
    version = "~> 2.17"
  }
}
```

Qué resuelve: separa la intención versionada del acto de aplicar cambios. Qué no resuelve: no decide por ti si un cambio es correcto, seguro o deseable.

### Providers

Un provider traduce el modelo de Terraform a una API externa. En la unidad, el provider Helm habla con Kubernetes usando la configuración local:

```hcl
provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kube_context
  }
}
```

El provider Kubernetes aparece como apoyo de observación mediante un data source. No crea el clúster ni sustituye a Helm. Esta diferencia será importante en cloud: un provider puede crear infraestructura, otro puede configurar Kubernetes y otro puede instalar releases, pero mezclar esas responsabilidades sin criterio complica destrucción, credenciales y dependencia entre capas.

En MicroK8s, la autenticación del laboratorio parte de un kubeconfig local porque el clúster ya existe. En AKS o EKS, el patrón profesional suele ser distinto: Terraform puede crear o leer el recurso del clúster con un provider cloud y alimentar después los providers `kubernetes` y `helm` con datos obtenidos de ese recurso, como endpoint, certificado de autoridad, nombre del clúster o token dinámico. Esa autenticación dinámica no se practica aquí porque exigiría una plataforma cloud, identidad, permisos y costes, pero debes reconocer el criterio: en local se reutiliza una credencial preexistente; en cloud se evita copiar kubeconfigs estáticos cuando la propia infraestructura declarada puede exponer los datos necesarios de conexión.

### `helm_release`

`helm_release.platform_api` declara que debe existir un release Helm con un nombre, namespace, chart y valores:

```hcl
resource "helm_release" "platform_api" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true
  chart            = local.chart_full_path
  wait             = true
  timeout          = 300
}
```

Qué resuelve: permite planificar, aplicar e inventariar el release desde Terraform. Qué no resuelve: no convierte Terraform en autor de los templates Kubernetes; esos templates siguen viviendo en `labs/06-helm-packaging/chart/platform-api/`.

La decisión `wait = true` acerca Terraform a una operación de despliegue verificable: el apply no se limita a enviar una petición y terminar inmediatamente. Aun así, la validación funcional completa sigue perteneciendo al laboratorio y a los scripts existentes.

La idempotencia esperada no significa que Terraform "no haga nada nunca", sino que una misma configuración aplicada dos veces debe converger al mismo resultado. Si state, variables y release real coinciden, el siguiente plan no debería proponer cambios. Si Helm o Kubernetes se modifican fuera de Terraform, el plan vuelve a ser el instrumento para detectar y reconciliar esa diferencia.

### State

`terraform.tfstate` une direcciones Terraform con objetos reales. En esta unidad, la relación importante es:

```text
helm_release.platform_api -> platform-training/platform-api-local
```

El state no es un caché. Si desaparece, Terraform puede no saber que el release ya existe. Si se filtra, puede revelar metadatos y valores que algunos providers guardan aunque el plan los marque como sensibles. Por eso `terraform.tfstate`, backups, planes binarios y `tfvars` locales no se versionan.

En equipos y producción, el state necesita una ubicación compartida, control de acceso, cifrado, versionado y bloqueo. Esta unidad usa backend local porque no crea cuentas cloud ni servicios gestionados.

### Variables y jerarquía de valores

Las variables convierten diferencias de entorno en entradas explícitas. `variables.tf` usa tipos, defaults y validaciones:

```hcl
variable "environment" {
  type    = string
  default = "local"

  validation {
    condition     = contains(["local", "aks", "eks"], var.environment)
    error_message = "environment debe ser local, aks o eks."
  }
}
```

Ese ejemplo no se ejecuta en la unidad, pero conecta con la Unidad 10: antes de hablar de promoción entre entornos, Terraform necesita que las diferencias se expresen como datos válidos, no como ediciones manuales dispersas.

Los tipos estructurales permiten modelar entradas con más intención. Un `map(string)` sirve cuando todas las claves comparten el mismo tipo y representan una colección abierta, por ejemplo etiquetas comunes. Un `object` sirve cuando quieres una interfaz cerrada con campos conocidos:

```hcl
variable "release_settings" {
  type = object({
    namespace    = string
    release_name = string
    replicas     = number
  })
}

variable "common_labels" {
  type = map(string)
}
```

No se trata de usar tipos complejos por prestigio. Un `object` mejora la lectura cuando agrupa una decisión coherente; un `map` ayuda cuando las claves son datos. Si el alumno no puede anticipar cómo cambiará el plan al modificar la estructura, la abstracción llegó demasiado pronto.

La prioridad típica va de menor a mayor: `default`, `terraform.tfvars`, `*.auto.tfvars`, `-var-file`, `TF_VAR_nombre`, `-var` y entrada interactiva. El laboratorio usa `terraform.tfvars.example` porque contiene valores inocuos y reproducibles; un `terraform.tfvars` real se ignora.

Qué resuelve: evita editar HCL para cada ejecución. Qué no resuelve: no es por sí mismo un sistema seguro de secretos ni una estrategia completa de promoción entre entornos.

### `templatefile()` y values Helm

`templatefile()` renderiza un values YAML consumido por Helm:

```hcl
rendered_values = templatefile("${path.module}/values/platform-api-values.yaml.tftpl", {
  namespace        = var.namespace
  ingress_host     = var.ingress_host
  replica_count    = var.replica_count
  feature_greeting = var.feature_greeting
})
```

La idea es mantener Helm como dueño del formato de values y usar Terraform como orquestador que calcula entradas. No conviene duplicar todo el chart en HCL ni convertir cada campo de Kubernetes en una variable.

### `set_sensitive`

`set_sensitive` reduce exposición de un valor en la salida del plan o apply:

```hcl
set_sensitive {
  name  = "secret.labApiToken"
  value = var.lab_api_token
}
```

Qué resuelve: evita mostrar accidentalmente el valor en algunas salidas. Qué no resuelve: no convierte el state en un almacén seguro. En producción, el criterio correcto combina backend protegido, secreto externo, mínimos permisos, rotación y revisión de qué guarda realmente cada provider.

### Expresiones, `for_each`, `dynamic` y lifecycle

La unidad no necesita `for_each` ni `dynamic` para el release local, pero esos mecanismos sí importan para leer Terraform real sin convertir la referencia en una segunda guía de laboratorio.

`for_each` es preferible a `count` cuando cada elemento tiene identidad estable:

```hcl
for_each = var.environments
```

Con `count`, Terraform identifica instancias por posición: `resource.example[0]`, `resource.example[1]`. Si una lista cambia de orden, el plan puede parecer una sustitución aunque conceptualmente sigan existiendo los mismos elementos. Con `for_each`, la identidad vive en la clave: `resource.example["aks"]`, `resource.example["eks"]`. Por eso preserva mejor la intención cuando modelas entornos, equipos, namespaces o releases nombrados.

Un bloque `dynamic` genera sub-bloques repetidos, por ejemplo varios `set` calculados para un `helm_release`. Su criterio de uso no es "hacer Terraform más avanzado", sino evitar duplicación cuando la lista de sub-bloques es dato de entrada y las claves tienen identidad clara. Si el `dynamic` obliga a reconstruir mentalmente qué YAML o qué plan se generará, empeora la operación. En esta unidad se explica como criterio porque aplicarlo al release local sería práctica nueva y no aportaría más claridad que escribir los pocos campos explícitos.

Las reglas `lifecycle`, como `prevent_destroy`, `ignore_changes` o `create_before_destroy`, no son parches mágicos. Pueden proteger recursos críticos o silenciar drift esperado, pero también pueden ocultar cambios que deberían revisarse.

### Operaciones de state e import

`terraform import` adopta un objeto existente en el state. En la Unidad 07 se usa para conectar un release Helm ya existente:

```text
platform-training/platform-api-local
```

`terraform state rm` desvincula Terraform sin borrar el recurso real. `terraform state mv` cambia direcciones dentro del state. `terraform force-unlock` libera un bloqueo, pero en backend local rara vez es el centro del problema.

Estas operaciones son recuperación o migración controlada. Si aparecen como rutina diaria, normalmente hay una decisión de ownership, estructura o automatización pendiente.

### Backends remotos y locking

Un backend remoto guarda state fuera de la máquina local. En producción suele aportar versionado, cifrado, acceso compartido y bloqueo:

| Backend | Qué aporta | Qué exige |
|---|---|---|
| AWS S3 | State compartido y versionado | Bucket, permisos, cifrado y locking |
| Azure Blob | State compartido con leases | Storage Account, RBAC y cifrado |
| HCP Terraform | State y ejecución gestionados | Organización, permisos y modelo operativo |
| Consul | State y coordinación | Operación del propio Consul |

La Unidad 07 no configura ninguno. Los menciona para que no confundas backend local con práctica profesional.

Tampoco configura un "backend remoto simulado". En esta referencia, simular solo puede significar describir la arquitectura y razonar sobre sus responsabilidades sin crear artefactos. Crear una estructura local que finja ser S3, Azure Blob o HCP Terraform introduciría práctica nueva y podría enseñar un modelo falso de locking, permisos y cifrado. Para esta unidad, backend local es práctica; backends remotos son criterio.

### Propiedad entre Terraform y GitOps (`GAP-010`)

La Unidad 07 deja `helm_release.platform_api` como propiedad de Terraform. La Unidad 09 introducirá Argo CD, que reconciliará estado deseado desde Git. Si Argo CD y Terraform intentan gestionar el mismo release, los mismos values o los mismos recursos renderizados, aparecerá una lucha de reconciliación.

El criterio profesional es que un recurso tenga un dueño operativo principal. Terraform puede crear la plataforma base y, en algunos equipos, instalar componentes fundacionales. GitOps suele gobernar aplicaciones y configuración continua. Lo incorrecto es que ambos corrijan el mismo drift sin un contrato explícito.

Con esto queda cerrada la laguna `GAP-010` en esta unidad: el alumno ya sabe que existe el conflicto y que debe buscar un reparto de ownership. La Unidad 09 concretará el patrón cuando Argo CD exista en el laboratorio.

---

## Criterios de decisión

### Cuándo gestionar un release Helm con Terraform

Tiene sentido cuando el release forma parte de una provisión de infraestructura discreta, el equipo necesita plan/apply, las entradas se derivan de otros recursos Terraform y no hay todavía un reconciliador GitOps continuo gobernando ese mismo objeto.

En esta unidad se elige porque el objetivo es aprender Terraform sobre un artefacto conocido, sin crear cloud ni pipelines.

### Cuándo no hacerlo

No es una buena elección si el release pertenece al ciclo normal de entrega de aplicaciones y Argo CD u otro motor GitOps ya lo reconcilia. En ese caso, Terraform debería retirarse de esa propiedad o limitarse a preparar dependencias de plataforma.

Tampoco conviene usar Terraform para recrear en HCL cada manifiesto que Helm ya modela correctamente.

### Cómo evaluar backend local frente a backend remoto

Backend local sirve para aprendizaje individual. Backend remoto es necesario cuando varias personas, una pipeline o varios entornos comparten la gestión. El criterio no es tamaño del repositorio, sino riesgo de colisión, pérdida, auditoría y secretos.

Un backend remoto "simulado" solo es aceptable como conversación arquitectónica: qué componentes existirían, quién tendría permisos, cómo se bloquearía el state y cómo se auditarían cambios. Si requiere ficheros nuevos, servicios locales o configuración adicional, ya no es referencia documental de esta unidad.

### Cómo tratar secretos

Un valor sensible no debería vivir como texto real en `.tf`, `.tfvars`, plan, output ni state local sin protección. En el laboratorio se usan placeholders. En producción, el secreto debe venir de un mecanismo especializado y el state debe protegerse como dato sensible.

### Cómo decidir entre `count`, `for_each` y `dynamic`

Usa `count` para presencia condicional simple. Usa `for_each` cuando la identidad de cada elemento importa. Usa `dynamic` solo cuando genera sub-bloques repetidos que ya entiendes manualmente. La abstracción que impide leer el plan no está ayudando.

### Cómo interpretar lifecycle

`prevent_destroy` puede proteger recursos críticos, pero también puede bloquear cambios legítimos. `ignore_changes` puede evitar drift esperado, pero también ocultar divergencias peligrosas. Antes de añadir lifecycle, identifica si el problema es técnico o de propiedad.

En esta unidad, "lifecycle avanzado" significa criterio, no aplicación sobre `helm_release.platform_api`. `prevent_destroy` sería razonable para recursos cuya pérdida es inaceptable, como un volumen, una base de datos o un clúster. `ignore_changes` puede ser útil cuando otro controlador modifica un campo de forma esperada, pero es mala señal si se usa para tapar que dos herramientas se pelean por el mismo recurso. `create_before_destroy` ayuda en recursos reemplazables que admiten coexistencia temporal; no todos los nombres, PVCs o releases Helm la admiten sin rediseño. Por eso la referencia lo explica como decisión profesional y no lo baja al laboratorio local.

---

## Relación con el laboratorio

El laboratorio practica:

- backend local;
- providers Helm y Kubernetes contra MicroK8s;
- `helm_release.platform_api`;
- variables tipadas y validaciones;
- `terraform.tfvars.example`;
- `templatefile()`;
- `set_sensitive` con valor ficticio;
- outputs no sensibles;
- import o apply controlado;
- observación de state, Helm y Kubernetes.

El laboratorio menciona, pero no practica:

- backends remotos y locking real;
- módulos Terraform reutilizables;
- `for_each`, `dynamic` y lifecycle avanzado;
- autenticación dinámica cloud;
- aprovisionamiento de AKS o EKS;
- ejecución desde CI/CD;
- propiedad entre Terraform y Argo CD;
- gestión real de secretos.

Restricción de la unidad: no modifiques `labs/06-helm-packaging/chart/platform-api/` para resolver dudas de Terraform. Si el plan no expresa lo esperado, revisa variables, state, provider y release; el chart heredado es la base estable de la unidad.

Los elementos no practicados quedan anclados así: CI/CD en Unidad 08; propiedad Terraform/GitOps y secretos GitOps en Unidad 09; promoción entre entornos en Unidad 10; distribución y escalado en Unidad 18; desacoplamiento de MicroK8s en Unidad 19; AKS/EKS y backends cloud en Unidades 19-25; seguridad productiva en Unidad 16 y bloque de seguridad.

---

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Creer que Terraform sustituye a Helm | Oculta que el chart sigue siendo la fuente del manifiesto Kubernetes |
| Creer que Terraform sustituye a Kubernetes | Terraform pide cambios; Kubernetes reconcilia recursos |
| Tratar el state como caché | Puede provocar recreaciones, imports innecesarios o pérdida de ownership |
| Versionar `terraform.tfvars` reales | Expone configuración local y puede filtrar secretos |
| Pensar que `set_sensitive` cifra el state | Reduce salida visible, pero no elimina el riesgo del state |
| Usar `apply` como si fuera `kubectl apply` rutinario | Terraform tiene plan y state; saltarse la revisión cambia el modelo operativo |
| Usar `destroy` como limpieza normal | Puede desinstalar el release y afectar recursos persistentes |
| Arreglar todo con `state rm` | Desvincular recursos sin contrato puede crear drift más difícil de explicar |
| Usar `count` para colecciones con identidad estable | Cambios de orden pueden parecer destrucciones y recreaciones |
| Dejar que Terraform y Argo CD gestionen lo mismo | Dos reconciliadores pueden sobrescribirse y ocultar la fuente real de verdad |

---

## Continuidad

Unidad 08 introducirá Tekton. Reutilizará la idea de ejecutar validación, plan y apply como pasos controlados, sin convertir la pipeline en una colección de comandos improvisados.

Unidad 09 introducirá Argo CD y GitOps. Retomará `GAP-010` desde el lado operativo: decidirá qué queda en Terraform, qué pasa a GitOps y cómo evitar que dos herramientas reclamen el mismo release.

Unidad 10 tratará promoción entre entornos. La jerarquía de variables, valores por entorno y separación de responsabilidades de esta unidad serán base para discutir qué cambia entre local, testing, staging y producción.

Unidad 16 y el bloque de seguridad retomarán secretos, permisos, identidades y políticas. La advertencia sobre state sensible se conectará con mecanismos productivos de secret management y mínimos privilegios.

Unidad 18 retomará distribución, escalado y capacidad. Lo que aquí aparece como número de réplicas local se convertirá en criterios de escalado, topología y coste.

Unidad 19 abrirá el puente hacia cloud. Separará lo que en esta unidad es Kubernetes estándar, lo que es MicroK8s local y lo que cambia al operar AKS o EKS.

Unidades 19-25 cubrirán backends cloud, autenticación dinámica, clústeres gestionados y dependencias entre infraestructura, plataforma y aplicaciones.

---

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Terraform Language - Configuration Syntax](https://developer.hashicorp.com/terraform/language/syntax/configuration) | Bloques, argumentos y expresiones | ¿Qué parte del HCL declara estructura y qué parte calcula valores? |
| [Terraform State](https://developer.hashicorp.com/terraform/language/state) | Propósito del state y relación con objetos reales | ¿Por qué perder state no equivale a perder solo un archivo temporal? |
| [Terraform Backends](https://developer.hashicorp.com/terraform/language/backend) | Qué resuelve un backend | ¿Qué carencias tiene el backend local cuando trabaja un equipo? |
| [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) | Tipos, validaciones y sensibilidad | ¿Qué valida Terraform antes de tocar Helm o Kubernetes? |
| [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs) | Outputs y valores sensibles | ¿Qué salida puede consumir una pipeline sin filtrar secretos? |
| [Terraform `templatefile`](https://developer.hashicorp.com/terraform/language/functions/templatefile) | Renderizado de plantillas | ¿Por qué usamos `templatefile()` sin duplicar el chart Helm? |
| [Terraform Resource Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle) | `prevent_destroy`, `ignore_changes` y `create_before_destroy` | ¿Cuándo una regla lifecycle protege y cuándo oculta un problema? |
| [Helm provider - `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Argumentos principales del recurso | ¿Qué identidad real queda detrás de `helm_release.platform_api`? |
| [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) | Configuración del provider | ¿Qué necesita Terraform para hablar con el API server? |
| [Argo CD Architecture](https://argo-cd.readthedocs.io/en/stable/operator-manual/architecture/) | Componentes y reconciliación | ¿Por qué GitOps cambia la discusión de ownership abierta en `GAP-010`? |
