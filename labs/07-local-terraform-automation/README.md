# Laboratorio - Unidad 07

## Proposito

Este laboratorio usa Terraform para gestionar el release Helm local de `platform-api`. Reutiliza el chart de Unidad 06 y conserva el comportamiento acumulado: namespace `platform-training`, release `platform-api-local`, Deployment, Service, Ingress, PVC, PDB, probes, resources y scheduling seguro.

No crea recursos cloud, no configura backend remoto, no instala CI/CD o GitOps, no guarda secretos reales y no borra PVCs como parte normal del flujo.

## Estructura

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

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
helm version --short
terraform version
kubectl config current-context
helm lint labs/06-helm-packaging/chart/platform-api
bash labs/06-helm-packaging/validation/validate.sh
```

Resultado esperado:

```text
El entorno local no muestra fallos bloqueantes.
Helm y Terraform informan version.
El chart de Unidad 06 y el release local estan disponibles o son instalables.
```

Si el release `platform-api-local` existe en Helm pero no en Terraform, decide con el instructor si se importa o si se deja que Terraform lo gestione mediante apply controlado.

## Inicializacion

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform init
```

Efecto esperado:

```text
Terraform descarga providers y crea directorios locales ignorados por Git.
```

No versiones `.terraform/`, `terraform.tfstate`, planes binarios ni `terraform.tfvars` locales. El archivo `.terraform.lock.hcl` si se versiona para fijar las versiones de providers seleccionadas.

## Formato y validacion estatica

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive
terraform -chdir=labs/07-local-terraform-automation/terraform validate
```

Resultado esperado:

```text
La configuracion tiene formato correcto y Terraform puede validarla.
```

## Plan

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

Antes de aplicar, revisa:

- si va a crear, actualizar o destruir;
- que el release sea `platform-api-local`;
- que el namespace sea `platform-training`;
- que el chart usado sea `labs/06-helm-packaging/chart/platform-api`;
- que no aparezcan secretos reales;
- que no haya destrucciones inesperadas.

## Apply

Aplicar solo despues de leer el plan:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
```

Resultado esperado:

```text
helm_release.platform_api queda creado o actualizado.
platform-api sigue disponible en platform-training.
```

## Inspeccion

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform state list
terraform -chdir=labs/07-local-terraform-automation/terraform output
helm status platform-api-local --namespace platform-training
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,svc,endpointslice,ingress,pvc,pdb
```

Resultado esperado:

```text
Terraform lista helm_release.platform_api.
Helm muestra el release deployed.
Kubernetes muestra platform-api disponible.
```

## Cambio controlado

Cambia temporalmente una variable sin editar HCL:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example -var="feature_greeting=terraform-plan-demo"
```

Si el plan es correcto, puedes aplicar:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example -var="feature_greeting=terraform-plan-demo"
```

Vuelve al valor versionado:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
```

No uses `-var` como mecanismo habitual para configuraciones grandes.

## Drift basico

Simula un cambio fuera de Terraform con Helm:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml --set config.featureGreeting=manual-drift-demo
```

Observa el plan:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

Recupera el estado declarado:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
```

## Import de release existente

Si el release ya existe y Terraform no lo gestiona, puede importarse:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform import -var-file=terraform.tfvars.example helm_release.platform_api platform-training/platform-api-local
```

Despues del import:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

El objetivo es llegar a un plan sin cambios inesperados antes de aplicar.

## Validacion automatizada

```bash
bash labs/07-local-terraform-automation/validation/validate.sh
bash labs/06-helm-packaging/validation/validate.sh
```

La validacion de Unidad 07 comprueba:

- CLI de Terraform, Helm y `kubectl`;
- estructura de archivos Terraform;
- formato Terraform;
- validacion Terraform si los providers estan inicializados;
- state cuando existe;
- release Helm;
- Deployment, Service, Ingress, PVC y PDB;
- busqueda basica de patrones de secretos reales.

## Diagnostico rapido

| Sintoma | Comando util | Recuperacion |
|---|---|---|
| Provider no inicializado | `terraform init` | Inicializar desde `terraform/` |
| Contexto incorrecto | `kubectl config current-context` | Ajustar `kube_context` o kubeconfig |
| Release existe fuera de state | `helm status`, `terraform state list` | Importar o aplicar con decision controlada |
| Plan destructivo | `terraform plan` | No aplicar; revisar variables y state |
| State bloqueado o corrupto | `terraform state list` | Resolver bloqueo; no borrar state sin decision |
| Secret real detectado | `grep`, plan, outputs | Retirar, rotar si fuera real y no versionar |

## Limpieza controlada

`terraform destroy` es destructivo porque puede desinstalar el release Helm:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform destroy -var-file=terraform.tfvars.example
```

No lo uses como limpieza normal. Si se ejecuta por demostracion, valida el PVC antes de cualquier borrado manual y recupera con:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example
kubectl -n platform-training get pvc platform-api-data
```

Nunca borres manualmente `pvc/platform-api-data` salvo instruccion explicita y entendida.
