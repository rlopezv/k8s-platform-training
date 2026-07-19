# Student notes - Unidad 06

## Proposito

Estas notas explican Helm desde el problema real del curso: `platform-api` ya funciona con manifiestos Kubernetes, pero ahora necesita empaquetarse para instalarse, actualizarse y parametrizarse de forma repetible.

La idea central es:

```text
Helm no inventa nuevos recursos de Kubernetes.
Helm renderiza manifiestos conocidos y gestiona una instalacion llamada release.
```

## Que se va a cubrir

| Bloque | Que aporta | Nivel en esta unidad |
|---|---|---|
| Chart | Paquete de la aplicacion | Practico |
| Template | YAML con expresiones Helm | Practico |
| Values | Parametros de configuracion | Practico |
| Release | Instalacion gestionada por Helm | Practico |
| Renderizado | YAML final antes de aplicar | Practico |
| Helpers | Reutilizacion de nombres y labels | Practico |
| Upgrade | Cambio de valores o templates | Practico |
| Rollback | Vuelta a una revision anterior | Practico |
| Terraform | Gestion futura del release | Solo continuidad conceptual |

No se cubren repositorios remotos de charts, OCI, firma de paquetes, Argo CD, Tekton, modulos Terraform, secretos productivos ni promocion formal entre entornos.

## Que representa cada componente

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| Chart | Directorio versionado con templates y valores | Agrupa recursos relacionados | No es un cluster ni una aplicacion nueva |
| `Chart.yaml` | Metadatos del paquete | Identifica nombre, tipo y version | No configura Kubernetes |
| `values.yaml` | Defaults del chart | Declara configuracion base | No debe guardar secretos reales |
| `values-local.yaml` | Valores del entorno local | Ajusta el chart a MicroK8s | No sustituye gestion formal de entornos |
| Template | Archivo renderizable | Produce YAML Kubernetes | No es YAML final hasta renderizar |
| `_helpers.tpl` | Bloques reutilizables | Evita duplicar nombres y labels | No crea recursos por si solo |
| Release | Instalacion concreta | Permite historial, upgrades y rollback | No versiona el repositorio |

Frase clave:

```text
Chart es el paquete.
Release es una instalacion del paquete.
Values son datos.
Templates son instrucciones para producir YAML.
```

## Que vas a construir

Construiras el primer chart local del curso:

```text
labs/06-helm-packaging/chart/platform-api/
```

El chart renderiza:

- Namespace `platform-training`;
- ConfigMap `platform-api-config`;
- Secret ficticio `platform-api-secret`;
- PVC `platform-api-data`;
- Deployment `platform-api`;
- Service `platform-api`;
- Ingress `platform-api`;
- PDB `platform-api`.

El release local recomendado se llama:

```text
platform-api-local
```

## Como se relacionan las piezas

Helm trabaja en dos planos.

Plano de entrada:

```text
Chart.yaml
templates/*.yaml
values.yaml
values-local.yaml
opciones CLI
```

Plano de salida:

```text
YAML Kubernetes renderizado
  -> recursos aplicados al cluster
  -> release con historial Helm
```

Kubernetes sigue decidiendo scheduling, rollout, readiness, endpoints y PDB. Helm solo organiza como se produce y aplica el YAML.

## Que ocurre cuando aplicas el chart

Flujo mental:

```text
1. Helm carga Chart.yaml.
2. Helm fusiona values.yaml con values-local.yaml.
3. Helm ejecuta templates usando el contexto de release.
4. Helm genera YAML Kubernetes.
5. Helm envia los recursos al API server.
6. Kubernetes reconcilia Deployment, Service, Ingress, PVC y PDB.
7. Helm guarda una revision del release.
```

Por eso el laboratorio renderiza primero:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

Renderizar antes de instalar evita tratar Helm como una caja negra.

## Como comprobar que funciona

Comprobar el chart:

```bash
helm lint labs/06-helm-packaging/chart/platform-api
```

Comprobar el release:

```bash
helm status platform-api-local --namespace platform-training
helm history platform-api-local --namespace platform-training
```

Comprobar Kubernetes:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc,pdb
```

Validacion automatizada:

```bash
bash labs/06-helm-packaging/validation/validate.sh
```

## Como diagnosticar los 4 fallos tipicos

### 1. Helm renderiza YAML invalido

Comprueba:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

Idea clave: si el YAML no se renderiza, Kubernetes aun no participa. Mira sintaxis de templates, sangria, `quote`, `nindent` y contexto.

### 2. El chart renderiza, pero Kubernetes lo rechaza

Comprueba:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml | kubectl apply --dry-run=client -f -
```

Idea clave: Helm puede producir YAML sintacticamente valido que no sea un recurso Kubernetes valido.

### 3. El Service no tiene endpoints

Comprueba:

```bash
kubectl -n platform-training get pods --show-labels
kubectl -n platform-training describe service platform-api
```

Idea clave: selectors y labels deben coincidir. Si cambias `Release.Name`, tambien cambian labels de instancia.

### 4. Un upgrade rompe la aplicacion

Comprueba:

```bash
helm history platform-api-local --namespace platform-training
helm rollback platform-api-local <revision> --namespace platform-training
kubectl -n platform-training rollout status deployment/platform-api
```

Idea clave: rollback Helm vuelve a una revision del release. No arregla automaticamente el chart en Git ni borra datos persistentes.

## Que debes recordar para la Unidad 07

La Unidad 07 introducira Terraform. El limite conceptual sera:

| Herramienta | Responsabilidad |
|---|---|
| Helm | Empaquetar y renderizar Kubernetes |
| Terraform | Orquestar infraestructura y gestionar releases como recursos declarativos |

No confundas el chart con la automatizacion que lo instala. En esta unidad el operador ejecuta Helm. En la siguiente, Terraform podra gestionar el release.

## Fuentes de referencia

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Helm - Charts](https://helm.sh/docs/topics/charts/) | Estructura de charts | Ubicar cada archivo del laboratorio |
| [Helm - Values Files](https://helm.sh/docs/chart_template_guide/values_files/) | Prioridad de valores | Entender defaults y overrides |
| [Helm - Template Guide](https://helm.sh/docs/chart_template_guide/) | Objetos, funciones y flujo | Razonar sobre renderizado |
| [Helm - Debugging Templates](https://helm.sh/docs/chart_template_guide/debugging/) | `lint`, `template`, dry-run | Diagnosticar errores antes de instalar |
| [Helm - Rollback](https://helm.sh/docs/helm/helm_rollback/) | Uso de rollback | Recuperar una revision de release |
