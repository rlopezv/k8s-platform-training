# Student notes - Unidad 06

## Propósito

Estas notas explican Helm desde el problema real del curso: `platform-api` ya funciona con manifiestos Kubernetes, pero ahora necesita empaquetarse para instalarse, actualizarse y parametrizarse de forma repetible.

La idea central es:

```text
Helm no inventa nuevos recursos de Kubernetes.
Helm renderiza manifiestos conocidos y gestiona una instalación llamada release.
```

Para errores de modelo mental, criterios profesionales, subcharts, hooks, repositorios remotos y frontera con Terraform, usa `tutorial/06-helm-packaging/student-reference.md`.

---

## Qué se va a cubrir

| Bloque | Qué aporta | Nivel en esta unidad |
|---|---|---|
| Chart | Paquete de la aplicación | Práctico |
| Template | YAML con expresiones Helm | Práctico |
| Values | Parámetros de configuración | Práctico |
| Release | Instalación gestionada por Helm | Práctico |
| Renderizado | YAML final antes de aplicar | Práctico |
| Helpers | Reutilización de nombres y labels | Práctico |
| Upgrade | Cambio de valores o templates | Práctico |
| Rollback | Vuelta a una revisión anterior | Práctico |
| Terraform | Gestión futura del release | Solo continuidad conceptual |

No se cubren repositorios remotos de charts, OCI, firma de paquetes, Argo CD, Tekton, módulos Terraform, secretos productivos, subcharts ejecutables, umbrella charts, hooks ejecutables, `helm test`, Service mesh, topology spread constraints ni promoción formal entre entornos.

Esos elementos quedan explicados o anclados en `tutorial/06-helm-packaging/student-reference.md`.

---

## Qué representa cada componente

| Componente | Qué representa | Qué problema resuelve | Qué no es |
|---|---|---|---|
| Chart | Directorio versionado con templates y valores | Agrupa recursos relacionados | No es un clúster ni una aplicación nueva |
| `Chart.yaml` | Metadatos del paquete | Identifica nombre, tipo y versión | No configura Kubernetes |
| `values.yaml` | Defaults del chart | Declara configuración base | No debe guardar secretos reales |
| `values-local.yaml` | Valores del entorno local | Ajusta el chart a MicroK8s | No sustituye gestión formal de entornos |
| Template | Archivo renderizable | Produce YAML Kubernetes | No es YAML final hasta renderizar |
| `_helpers.tpl` | Bloques reutilizables | Evita duplicar nombres y labels | No crea recursos por sí solo |
| Release | Instalación concreta | Permite historial, upgrades y rollback | No versiona el repositorio |

Frase clave:

```text
Chart es el paquete.
Release es una instalación del paquete.
Values son datos.
Templates son instrucciones para producir YAML.
```

---

## Qué vas a construir

Construirás el primer chart local del curso:

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

---

## Cómo se relacionan las piezas

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
  -> recursos aplicados al clúster
  -> release con historial Helm
```

Kubernetes sigue decidiendo scheduling, rollout, readiness, endpoints y PDB. Helm solo organiza cómo se produce y aplica el YAML.

---

## Qué ocurre cuando aplicas el chart

Flujo mental:

```text
1. Helm carga Chart.yaml.
2. Helm fusiona values.yaml con values-local.yaml.
3. Helm ejecuta templates usando el contexto de release.
4. Helm genera YAML Kubernetes.
5. Helm envía los recursos al API server.
6. Kubernetes reconcilia Deployment, Service, Ingress, PVC y PDB.
7. Helm guarda una revisión del release.
```

Por eso el laboratorio renderiza primero:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

Renderizar antes de instalar evita tratar Helm como una caja negra.

---

## Cómo comprobar que funciona

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

Validación automatizada:

```bash
bash labs/06-helm-packaging/validation/validate.sh
```

---

## Cómo diagnosticar los 4 fallos típicos

### 1. Helm renderiza YAML inválido

Comprueba:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

Idea clave: si el YAML no se renderiza, Kubernetes aún no participa. Mira sintaxis de templates, sangría, `quote`, `nindent` y contexto.

### 2. El chart renderiza, pero Kubernetes lo rechaza

Comprueba:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml | kubectl apply --dry-run=client -f -
```

Idea clave: Helm puede producir YAML sintácticamente válido que no sea un recurso Kubernetes válido.

### 3. El Service no tiene endpoints

Comprueba:

```bash
kubectl -n platform-training get pods --show-labels
kubectl -n platform-training describe service platform-api
```

Idea clave: selectors y labels deben coincidir. Si cambias `Release.Name`, también cambian labels de instancia.

### 4. Un upgrade rompe la aplicación

Comprueba:

```bash
helm history platform-api-local --namespace platform-training
helm rollback platform-api-local <revision> --namespace platform-training
kubectl -n platform-training rollout status deployment/platform-api
```

Idea clave: rollback Helm vuelve a una revisión del release. No arregla automáticamente el chart en Git ni borra datos persistentes.

---

## Qué debes recordar para la Unidad 07

La Unidad 07 introducirá Terraform. El límite conceptual será:

| Herramienta | Responsabilidad |
|---|---|
| Helm | Empaquetar y renderizar Kubernetes |
| Terraform | Orquestar infraestructura y gestionar releases como recursos declarativos |

No confundas el chart con la automatización que lo instala. En esta unidad el operador ejecuta Helm. En la siguiente, Terraform podrá gestionar el release.

---

## Fuentes de referencia

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Helm - Debugging Templates](https://helm.sh/docs/chart_template_guide/debugging/) | `lint`, `template`, dry-run | Diagnosticar errores antes de instalar |
| [Helm - Rollback](https://helm.sh/docs/helm/helm_rollback/) | Uso de rollback | Recuperar una revisión de release |
| [Helm - Status](https://helm.sh/docs/helm/helm_status/) | Estado de un release | Confirmar qué release está desplegado |
| [Helm - History](https://helm.sh/docs/helm/helm_history/) | Historial de revisiones | Relacionar upgrades y rollbacks del laboratorio |
