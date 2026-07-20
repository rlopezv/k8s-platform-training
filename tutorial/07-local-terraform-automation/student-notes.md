# Student notes - Unidad 07

## Proposito

Estas notas explican Terraform desde el problema real del curso: `platform-api` ya se instala con Helm, pero ahora queremos que esa instalacion sea declarativa, planificable y observable mediante state.

La idea central es:

```text
Terraform no renderiza los recursos Kubernetes de platform-api.
Terraform declara que debe existir un release Helm que instala el chart existente.
```

## Que se va a cubrir

| Bloque | Que aporta | Nivel en esta unidad |
|---|---|---|
| HCL | Lenguaje declarativo de Terraform | Practico |
| Provider | Conexion con Helm y Kubernetes | Practico |
| Resource | Objeto gestionado por Terraform | Practico |
| State | Relacion entre configuracion y realidad | Practico |
| Plan | Vista previa de cambios | Practico |
| Variables | Parametros tipados | Practico |
| Outputs | Salidas consumibles | Practico |
| Drift | Desalineacion basica | Introduccion |
| Backends remotos | State compartido productivo | Referencia |

No se cubren recursos cloud reales, backends remotos ejecutables, modulos productivos, Tekton, Argo CD, AKS, EKS ni gestores productivos de secretos.

## Que representa cada componente

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| `terraform` block | Requisitos de Terraform y providers | Define compatibilidad | No crea recursos |
| Provider Helm | Cliente Terraform para Helm | Gestiona releases | No sustituye al chart |
| Provider Kubernetes | Cliente Terraform para API Kubernetes | Lee o valida estado | No crea el cluster |
| Variable | Entrada controlada | Evita editar HCL por entorno | No es un almacen seguro por si sola |
| `helm_release` | Release Helm como recurso Terraform | Permite plan, apply y state | No es un Deployment |
| Output | Valor consultable tras apply | Expone informacion no sensible | No debe filtrar secretos |
| State | Inventario de lo gestionado | Une HCL con IDs reales | No es cache prescindible |

Frase clave:

```text
Kubernetes ejecuta.
Helm empaqueta.
Terraform orquesta la instalacion y guarda estado.
```

## Que vas a construir

Construiras un proyecto Terraform local:

```text
labs/07-local-terraform-automation/terraform/
```

Ese proyecto declara:

- providers Helm y Kubernetes usando kubeconfig local;
- variables para release, namespace, chart, host y replicas;
- `helm_release.platform_api`;
- values renderizados con `templatefile()`;
- un ejemplo de `set_sensitive` con secreto ficticio;
- outputs para inspeccionar el resultado.

## Como se relacionan las piezas

Flujo de entrada:

```text
*.tf
terraform.tfvars.example
values/platform-api-values.yaml.tftpl
chart Helm de Unidad 06
```

Flujo de ejecucion:

```text
terraform init
  -> descarga providers
terraform plan
  -> evalua HCL y muestra cambios
terraform apply
  -> llama al provider Helm
helm_release
  -> instala o actualiza el chart
Kubernetes
  -> reconcilia Deployment, Service, Ingress, PVC y PDB
terraform.tfstate
  -> registra la identidad gestionada
```

## Que ocurre al aplicar Terraform

Terraform no envia directamente los templates del chart al API server. Primero evalua HCL, calcula valores y construye el plan. Cuando aplicas, el provider Helm ejecuta la operacion equivalente a gestionar el release `platform-api-local` con el chart local.

Despues del apply hay tres planos que deben coincidir:

| Plano | Comprobacion |
|---|---|
| Terraform | `terraform state list` contiene `helm_release.platform_api` |
| Helm | `helm status platform-api-local -n platform-training` indica `deployed` |
| Kubernetes | `kubectl -n platform-training rollout status deployment/platform-api` termina correctamente |

## Como comprobar que funciona

Antes de mutar:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive
terraform -chdir=labs/07-local-terraform-automation/terraform validate
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

Despues de aplicar:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform state list
terraform -chdir=labs/07-local-terraform-automation/terraform output
helm status platform-api-local --namespace platform-training
kubectl -n platform-training get deploy,svc,endpointslice,ingress,pvc,pdb
```

## Como diagnosticar los 4 fallos tipicos

### 1. Provider no inicializado

Sintoma: `terraform validate` o `plan` habla de providers no disponibles.

Comprueba:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform init
```

Idea clave: `init` descarga y prepara plugins. Sin plugins, Terraform no sabe hablar con Helm ni Kubernetes.

### 2. Contexto Kubernetes incorrecto

Sintoma: el plan o apply no conecta al cluster.

Comprueba:

```bash
kubectl config current-context
kubectl get nodes
```

Idea clave: Terraform usa el kubeconfig configurado en variables. Si apunta a otro contexto, el provider trabaja contra otro cluster o falla.

### 3. Release existente fuera de Terraform

Sintoma: Helm conoce `platform-api-local`, pero `terraform state list` no contiene `helm_release.platform_api`.

Comprueba:

```bash
helm status platform-api-local --namespace platform-training
terraform -chdir=labs/07-local-terraform-automation/terraform state list
```

Idea clave: un recurso real puede existir sin estar en state. En ese caso hay que decidir si se importa, se adopta mediante apply controlado o se recrea con cuidado.

### 4. Plan inesperadamente destructivo

Sintoma: el plan propone destruir recursos que no esperabas.

Comprueba:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

Idea clave: no apliques por reflejo. Revisa variables efectivas, state y release Helm antes de aceptar cambios destructivos.

## Que debes recordar para la Unidad 08

La Unidad 08 introducira CI/CD con Tekton. Terraform deja preparada una interfaz clara:

- comandos repetibles;
- variables versionadas mediante ejemplo;
- outputs consultables;
- validacion antes de apply;
- estado local que demuestra la idea de ownership.

Una pipeline no deberia improvisar comandos: deberia ejecutar el mismo flujo controlado que has aprendido aqui.

## Fuentes de referencia

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Terraform CLI](https://developer.hashicorp.com/terraform/cli) | `init`, `plan`, `apply`, `destroy` | Entender el ciclo operativo |
| [Terraform State](https://developer.hashicorp.com/terraform/language/state) | Proposito del state | Evitar tratarlo como cache |
| [Terraform Variables](https://developer.hashicorp.com/terraform/language/values/variables) | Tipos y validacion | Diseñar entradas seguras |
| [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs) | Outputs y `sensitive` | Exponer datos utiles |
| [Terraform Expressions](https://developer.hashicorp.com/terraform/language/expressions) | Referencias y funciones | Leer `templatefile()` y locals |
| [Helm provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) | Provider y `helm_release` | Conectar Terraform con Helm |
