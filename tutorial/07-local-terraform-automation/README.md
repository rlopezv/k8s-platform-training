# Unidad 07 - Automatización local con Terraform

## Guía pedagógica de la unidad

Esta unidad introduce Terraform cuando `platform-api` ya tiene un paquete Helm funcional. La pregunta ya no es "como instalo el chart?", sino:

```text
¿Cómo declaro la instalación del release Helm para que pueda planificarse, aplicarse, inspeccionarse y repetirse con estado explícito?
```

Terraform aparece después de Helm porque no reemplaza el chart. Kubernetes sigue ejecutando recursos, Helm sigue empaquetando y renderizando la aplicación, y Terraform declara que el release `platform-api-local` debe existir con unos valores determinados.

Para estudiar el modelo mental usa `tutorial/07-local-terraform-automation/student-notes.md`. Para consultar arquitectura avanzada, criterios profesionales y errores de razonamiento usa `tutorial/07-local-terraform-automation/student-reference.md`. Para ejecutar comandos usa `labs/07-local-terraform-automation/README.md`.

## Problema real

En la Unidad 06 el operador ejecutaba comandos Helm directamente. Ese flujo funciona en local, pero tiene límites:

- el resultado depende de recordar los flags usados;
- no queda un plan previo separado de la aplicación;
- no existe una interfaz clara de variables y outputs;
- no hay un estado Terraform que relacione configuración declarada y release real;
- es difícil preparar una futura pipeline que ejecute validación, plan y apply controlado.

Terraform resuelve este problema declarando el release Helm como recurso. Antes de cambiar el clúster, Terraform evalúa la configuración, construye un grafo de dependencias y muestra un plan.

## Objetivos

Al finalizar la unidad podrás:

- inicializar un proyecto Terraform local;
- explicar `init`, `plan`, `apply`, `destroy` y `state`;
- configurar providers Helm y Kubernetes contra MicroK8s;
- declarar `helm_release.platform_api` sobre el chart de Unidad 06;
- parametrizar el despliegue con variables y `terraform.tfvars.example`;
- exponer outputs no sensibles;
- validar que Terraform, Helm y Kubernetes observan el mismo estado;
- diagnosticar drift básico sin borrar PVCs ni secretos reales.

## Conocimientos previos

Debes venir de las Unidades 00 a 06. En particular:

- usas `kubectl` contra MicroK8s;
- reconoces Deployment, Service, Ingress, PVC, PDB, ConfigMap y Secret;
- has instalado `platform-api` como release Helm local;
- entiendes la diferencia entre chart, values, template y release;
- sabes validar rollout, EndpointSlice, Ingress y estado Helm.

## Relación con la Unidad 06

La Unidad 06 dejó el chart:

```text
labs/06-helm-packaging/chart/platform-api/
```

La Unidad 07 no duplica ese chart. Crea un proyecto Terraform en:

```text
labs/07-local-terraform-automation/terraform/
```

El release conserva el nombre `platform-api-local`, el namespace `platform-training`, el host `platform-api.local`, el PVC `platform-api-data`, el Service, el Ingress, el PDB, las probes, los resources y el scheduling seguro.

## Estado inicial

La unidad parte de:

- MicroK8s local validado;
- Helm disponible;
- Terraform instalado como CLI;
- chart Helm de Unidad 06 disponible;
- release Helm local instalado o instalable;
- ausencia previa de state Terraform del curso;
- secretos ficticios de laboratorio.

## Mapa de aprendizaje

| Concepto | Responsabilidad | Pregunta de diagnóstico |
|---|---|---|
| Terraform Core | Evalúa HCL, grafo, plan y state | ¿Qué cambiaría antes de aplicar? |
| Provider | Traduce Terraform a una API externa | ¿Contra qué sistema habla este bloque? |
| Resource | Objeto gestionado por Terraform | ¿Qué identidad queda en el state? |
| Variable | Entrada parametrizable | ¿Qué cambia entre ejecuciones? |
| Output | Salida consultable | ¿Qué información puede consumir otra automatización? |
| State | Mapa entre configuración y realidad | ¿Qué cree Terraform que gestiona? |
| `helm_release` | Release Helm declarado como recurso | ¿Qué chart y valores instala? |
| Drift | Desalineación entre estado deseado, state y realidad | ¿Qué propone el siguiente plan? |

## Diseño del laboratorio

El laboratorio crea:

- `versions.tf` con versiones de providers;
- `providers.tf` para Helm y Kubernetes usando kubeconfig local;
- `variables.tf` con tipos, defaults y validaciones;
- `main.tf` con `helm_release.platform_api`;
- `outputs.tf` con salidas no sensibles;
- `terraform.tfvars.example` como valores de laboratorio;
- `values/platform-api-values.yaml.tftpl` para renderizar values Helm desde Terraform;
- `validation/validate.sh` para comprobar Terraform, Helm y Kubernetes.

No se crea backend remoto, módulo cloud, clúster, pipeline, GitOps ni observabilidad avanzada.

## Validaciones

Las validaciones principales son:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive
terraform -chdir=labs/07-local-terraform-automation/terraform init
terraform -chdir=labs/07-local-terraform-automation/terraform validate
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

La aplicación funcional requiere revisar el plan y aplicar:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
bash labs/07-local-terraform-automation/validation/validate.sh
bash labs/06-helm-packaging/validation/validate.sh
```

## Errores de razonamiento frecuentes

Esta unidad nombra varios errores conceptuales, pero no los desarrolla aquí para no duplicar la referencia: creer que Terraform sustituye a Helm, tratar el state como caché, usar `destroy` como limpieza rutinaria o dejar que Terraform y GitOps gestionen lo mismo. Están explicados en `tutorial/07-local-terraform-automation/student-reference.md`.

## Resultado final

Al cierre de la unidad, `platform-api` sigue empaquetada por Helm, pero el release local puede quedar gestionado por Terraform mediante `helm_release.platform_api`. El state local es un artefacto de ejecución no versionado.

La Unidad 08 podrá reutilizar este flujo para introducir CI/CD con Tekton: una pipeline podrá validar el chart, inicializar Terraform, generar plan y aplicar cambios de forma controlada.

## Lectura guiada

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Terraform Language](https://developer.hashicorp.com/terraform/language) | Sintaxis, bloques, expresiones y valores | Leer HCL con criterio |
| [Terraform CLI](https://developer.hashicorp.com/terraform/cli) | `init`, `plan`, `apply`, `destroy`, `state` | Operar el flujo del laboratorio |
| [Terraform State](https://developer.hashicorp.com/terraform/language/state) | Propósito y riesgos del state | Entender por qué no se versiona |
| [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) | Tipos, validaciones y prioridad | Diseñar entradas seguras |
| [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs) | Salidas y sensibilidad | Exponer información útil |
| [Helm provider - `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Argumentos y ciclo de vida | Relacionar Terraform y Helm |
| [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) | Configuración del provider | Entender autenticación local y futura cloud |
