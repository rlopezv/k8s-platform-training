# Unidad 07 - Automatizacion local con Terraform

## Guia pedagogica de la unidad

Esta unidad introduce Terraform cuando `platform-api` ya tiene un paquete Helm funcional. La pregunta ya no es "como instalo el chart?", sino:

```text
Como declaro la instalacion del release Helm para que pueda planificarse, aplicarse, inspeccionarse y repetirse con estado explicito?
```

Terraform aparece despues de Helm porque no reemplaza el chart. Kubernetes sigue ejecutando recursos, Helm sigue empaquetando y renderizando la aplicacion, y Terraform declara que el release `platform-api-local` debe existir con unos valores determinados.

Para estudiar el modelo mental usa `tutorial/07-local-terraform-automation/student-notes.md`. Para consultar arquitectura avanzada de Terraform usa `tutorial/07-local-terraform-automation/student-reference.md`. Para ejecutar comandos usa `labs/07-local-terraform-automation/README.md`.

## Problema real

En la Unidad 06 el operador ejecutaba comandos Helm directamente. Ese flujo funciona en local, pero tiene limites:

- el resultado depende de recordar los flags usados;
- no queda un plan previo separado de la aplicacion;
- no existe una interfaz clara de variables y outputs;
- no hay un estado Terraform que relacione configuracion declarada y release real;
- es dificil preparar una futura pipeline que ejecute validacion, plan y apply controlado.

Terraform resuelve este problema declarando el release Helm como recurso. Antes de cambiar el cluster, Terraform evalua la configuracion, construye un grafo de dependencias y muestra un plan.

## Objetivos

Al finalizar la unidad podras:

- inicializar un proyecto Terraform local;
- explicar `init`, `plan`, `apply`, `destroy` y `state`;
- configurar providers Helm y Kubernetes contra MicroK8s;
- declarar `helm_release.platform_api` sobre el chart de Unidad 06;
- parametrizar el despliegue con variables y `terraform.tfvars.example`;
- exponer outputs no sensibles;
- validar que Terraform, Helm y Kubernetes observan el mismo estado;
- diagnosticar drift basico sin borrar PVCs ni secretos reales.

## Conocimientos previos

Debes venir de las Unidades 00 a 06. En particular:

- usas `kubectl` contra MicroK8s;
- reconoces Deployment, Service, Ingress, PVC, PDB, ConfigMap y Secret;
- has instalado `platform-api` como release Helm local;
- entiendes la diferencia entre chart, values, template y release;
- sabes validar rollout, EndpointSlice, Ingress y estado Helm.

## Relacion con la Unidad 06

La Unidad 06 dejo el chart:

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

| Concepto | Responsabilidad | Pregunta de diagnostico |
|---|---|---|
| Terraform Core | Evalua HCL, grafo, plan y state | Que cambiaria antes de aplicar? |
| Provider | Traduce Terraform a una API externa | Contra que sistema habla este bloque? |
| Resource | Objeto gestionado por Terraform | Que identidad queda en el state? |
| Variable | Entrada parametrizable | Que cambia entre ejecuciones? |
| Output | Salida consultable | Que informacion puede consumir otra automatizacion? |
| State | Mapa entre configuracion y realidad | Que cree Terraform que gestiona? |
| `helm_release` | Release Helm declarado como recurso | Que chart y valores instala? |
| Drift | Desalineacion entre estado deseado, state y realidad | Que propone el siguiente plan? |

## Diseno del laboratorio

El laboratorio crea:

- `versions.tf` con versiones de providers;
- `providers.tf` para Helm y Kubernetes usando kubeconfig local;
- `variables.tf` con tipos, defaults y validaciones;
- `main.tf` con `helm_release.platform_api`;
- `outputs.tf` con salidas no sensibles;
- `terraform.tfvars.example` como valores de laboratorio;
- `values/platform-api-values.yaml.tftpl` para renderizar values Helm desde Terraform;
- `validation/validate.sh` para comprobar Terraform, Helm y Kubernetes.

No se crea backend remoto, modulo cloud, cluster, pipeline, GitOps ni observabilidad avanzada.

## Validaciones

Las validaciones principales son:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive
terraform -chdir=labs/07-local-terraform-automation/terraform init
terraform -chdir=labs/07-local-terraform-automation/terraform validate
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

La aplicacion funcional requiere revisar el plan y aplicar:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
bash labs/07-local-terraform-automation/validation/validate.sh
bash labs/06-helm-packaging/validation/validate.sh
```

## Errores de razonamiento frecuentes

- Creer que Terraform sustituye a Helm.
- Ejecutar `apply` sin leer el plan.
- Versionar `terraform.tfstate` o `terraform.tfvars` locales.
- Guardar secretos reales en variables o state.
- Confundir drift con fallo inmediato.
- Usar `destroy` como limpieza rutinaria.
- Convertir Terraform en una capa de templates Kubernetes paralela al chart.

## Resultado final

Al cierre de la unidad, `platform-api` sigue empaquetada por Helm, pero el release local puede quedar gestionado por Terraform mediante `helm_release.platform_api`. El state local es un artefacto de ejecución no versionado.

La Unidad 08 podra reutilizar este flujo para introducir CI/CD con Tekton: una pipeline podra validar el chart, inicializar Terraform, generar plan y aplicar cambios de forma controlada.

## Lectura guiada

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Terraform Language](https://developer.hashicorp.com/terraform/language) | Sintaxis, bloques, expresiones y valores | Leer HCL con criterio |
| [Terraform CLI](https://developer.hashicorp.com/terraform/cli) | `init`, `plan`, `apply`, `destroy`, `state` | Operar el flujo del laboratorio |
| [Terraform State](https://developer.hashicorp.com/terraform/language/state) | Proposito y riesgos del state | Entender por que no se versiona |
| [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) | Tipos, validaciones y prioridad | Diseñar entradas seguras |
| [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs) | Salidas y sensibilidad | Exponer informacion util |
| [Helm provider - `helm_release`](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | Argumentos y ciclo de vida | Relacionar Terraform y Helm |
| [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) | Configuracion del provider | Entender autenticacion local y futura cloud |
