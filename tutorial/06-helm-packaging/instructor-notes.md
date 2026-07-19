# Instructor notes - Unidad 06

## Intencion pedagogica

La Unidad 06 debe cambiar la pregunta del alumno: de "aplico manifiestos" a "empaqueto una decision operativa que ya entiendo". Helm se presenta como mecanismo de empaquetado y gestion de releases, no como reemplazo conceptual de Kubernetes.

El punto clave de la sesion es renderizar antes de instalar. El alumno debe ver que Helm produce YAML Kubernetes ordinario y que Kubernetes sigue siendo quien reconcilia Deployment, Service, Ingress, PVC y PDB.

## Puntos de enfasis

- Helm aparece despues de manifiestos nativos para no ocultar conceptos.
- `platform-api` sigue siendo la misma aplicacion evolutiva.
- `values.yaml` no es un cajon para secretos.
- No todos los campos merecen ser parametrizados.
- `_helpers.tpl` protege consistencia de nombres, labels y selectors.
- `Release.Name` afecta a labels de instancia y puede romper selectors si se usa sin criterio.
- Rollback Helm revierte una revision del release, no sustituye revision de Git.
- Terraform se menciona solo como continuidad conceptual hacia Unidad 07.

## Demostracion recomendada

1. Mostrar un manifiesto de Unidad 05 y su template equivalente.
2. Ejecutar `helm template` y localizar Deployment, Service e Ingress en la salida.
3. Ejecutar `helm lint`.
4. Si la Unidad 05 ya esta aplicada con `kubectl`, ejecutar `bash labs/06-helm-packaging/validation/adopt-existing-resources.sh`.
5. Instalar con `helm upgrade --install`.
6. Inspeccionar `helm status`, `helm get values` y `helm history`.
7. Hacer un upgrade pequeño del contenido visible o replicas.
8. Ejecutar rollback.
9. Cerrar con `bash labs/06-helm-packaging/validation/validate.sh`.

## Errores frecuentes

| Error | Sintoma | Intervencion |
|---|---|---|
| Tratar Helm como magia | El alumno no puede explicar el YAML final | Volver a `helm template` |
| Parametrizar demasiado | `values.yaml` crece sin criterio | Preguntar que cambia entre entornos |
| Romper selectors | Service sin endpoints | Comparar labels del Pod y selector del Service |
| Usar `{{-` inline | YAML renderizado sin espacio tras `:` | Mostrar renderizado concreto |
| Secret real en values | Credencial versionada | Parar, retirar credencial y explicar rotacion |
| Confundir Helm y Terraform | Propone `helm_release` ya | Remitir a Unidad 07 |

## Criterios de evaluacion

El alumno deberia poder:

- explicar la diferencia entre chart y release;
- renderizar el chart y localizar recursos concretos;
- instalar y actualizar `platform-api` sin cambiar namespace funcional;
- comprobar que Service, Ingress, PVC y PDB se conservan;
- justificar dos valores parametrizados y dos campos no parametrizados;
- diagnosticar un error de template y un error de selector;
- explicar que queda preparado para Terraform.

## Riesgos tecnicos de la sesion

- Un PVC existente puede tener metadatos previos no gestionados por Helm si se instalo con `kubectl`; documentar la adopcion como parte del cambio de mecanismo.
- MicroK8s con snap puede requerir ejecutar `kubectl` fuera de algunos sandboxes.
- No borrar el PVC como limpieza ordinaria.
- No usar reset de MicroK8s para resolver errores del chart.
- `shellcheck` puede no estar instalado; registrar como pendiente si no existe.

## Recuperacion

Si el release queda inconsistente:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training --create-namespace -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

Si un upgrade rompe el contenido:

```bash
helm history platform-api-local --namespace platform-training
helm rollback platform-api-local <revision> --namespace platform-training
kubectl -n platform-training rollout status deployment/platform-api
```

Si solo se quiere volver al estado de manifiestos de Unidad 05 para comparar:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/
```

Esta comparacion no debe quedar como estado final de Unidad 06.
