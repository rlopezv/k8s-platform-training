# Instructor notes - Unidad 07

## Intencion pedagogica

El objetivo principal es que el alumno deje de ver Terraform como "un script que ejecuta Helm" y lo entienda como una capa declarativa con plan, state, providers y ownership.

La unidad debe insistir en la frontera:

- Kubernetes ejecuta recursos;
- Helm empaqueta y renderiza `platform-api`;
- Terraform gestiona la existencia del release Helm.

## Puntos de enfasis

- Leer siempre el plan antes de aplicar.
- No versionar `terraform.tfstate`, `.terraform/`, planes binarios ni `terraform.tfvars`.
- `set_sensitive` reduce exposicion en CLI, pero no convierte el state en un almacen seguro.
- El PVC `platform-api-data` no debe borrarse como limpieza normal.
- Un release existente en Helm no implica que Terraform lo gestione.

## Demostraciones recomendadas

1. Ejecutar `terraform init` y mostrar que aparecen plugins locales no versionados.
2. Ejecutar `terraform plan -var-file=terraform.tfvars.example` y pedir al grupo que identifique acciones.
3. Aplicar solo despues de revisar el plan.
4. Comparar `terraform state list`, `helm status` y `kubectl get`.
5. Cambiar temporalmente `feature_greeting`, ejecutar plan y volver al valor versionado.

## Errores frecuentes

| Error | Sintoma | Intervencion |
|---|---|---|
| Saltar `init` | Provider no disponible | Repetir ciclo desde la ruta correcta |
| Contexto incorrecto | Provider no conecta | Revisar `kubectl config current-context` |
| Release fuera de state | Helm existe, Terraform no lo lista | Explicar import/adopcion como decision controlada |
| Secret real en tfvars | Valor sensible versionado o en plan | Detener, retirar, rotar si fuera real |
| Uso rutinario de destroy | Riesgo de desinstalar release | Reforzar limpieza controlada |

## Evaluacion del laboratorio

El alumno debe poder demostrar:

- ejecucion de `fmt`, `init`, `validate` y `plan`;
- explicacion del plan antes de apply;
- `helm_release.platform_api` presente en state tras apply o import;
- release Helm `platform-api-local` desplegado;
- Deployment disponible y Service con endpoints;
- outputs no sensibles;
- ausencia de secretos reales versionados.

## Preguntas de comprobacion

- Que cambia si modificas una variable frente a editar el chart?
- Por que Terraform necesita state?
- Que hace Helm que Terraform no deberia duplicar?
- Que riesgo tiene guardar un secreto real en `terraform.tfvars`?
- Que mirarias si `helm status` funciona pero `terraform state list` esta vacio?

## Riesgos tecnicos

- La primera ejecucion de `terraform init` puede necesitar red para descargar providers.
- Un release Helm instalado previamente puede requerir import si Terraform no puede adoptarlo mediante apply.
- `terraform destroy` puede desinstalar recursos gestionados por el release.
- En MicroK8s de un nodo, cambios de replicas o scheduling pueden tardar mas si el nodo tiene pocos recursos.

## Recuperacion

- Si falla `init`, comprobar red y registry de providers.
- Si falla provider auth, validar kubeconfig y contexto.
- Si el release existe fuera del state, revisar `terraform import helm_release.platform_api platform-training/platform-api-local`.
- Si el plan es destructivo, no aplicar; revisar variables y state.
- Si el release queda desinstalado, reaplicar con `terraform apply -var-file=terraform.tfvars.example` y validar PVC antes de cualquier borrado manual.
