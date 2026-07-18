# Instructor notes - Unidad 02

## Intencion pedagogica

La unidad debe hacer que el alumno vea un Deployment como una declaracion operativa completa, no solo como una forma de arrancar contenedores.

El foco no esta en memorizar todos los campos posibles, sino en conectar cuatro preguntas practicas:

- que configuracion necesita la aplicacion;
- que valores no deben tratarse como configuracion visible;
- como decide Kubernetes si un Pod puede recibir trafico;
- que recursos se reservan y que consumo se limita.

La sesion debe reforzar continuidad: `platform-api` sigue siendo la misma aplicacion de Unidad 01, pero su template de Pod ha evolucionado.

## Puntos de enfasis

- ConfigMap separa configuracion no sensible de la imagen.
- Secret no equivale a un gestor de secretos corporativo; en esta unidad solo hay valores ficticios.
- Cambiar `.spec.template` de un Deployment provoca rollout.
- Readiness controla participacion en endpoints del Service; liveness controla reinicio de contenedores.
- Startup probe evita que liveness penalice arranques lentos.
- Requests se usan para scheduling; limits para contencion.
- `kubectl describe` y eventos suelen explicar mejor un fallo de ConfigMap, Secret o probe que una lista de Pods.
- EndpointSlice debe preferirse para observar endpoints en Kubernetes reciente, aunque `Endpoints` todavia aparezca en comandos heredados.

## Demostraciones recomendadas

### Rollout por cambio de ConfigMap montado

Aplicar la solucion:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

Editar temporalmente `index.html` en el ConfigMap y aplicar solo el ConfigMap. Explicar que los datos proyectados por volumen pueden actualizarse, pero que en produccion se suele provocar un rollout controlado para tener trazabilidad y evitar diferencias temporales entre Pods:

```bash
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

Recuperar con la solucion versionada.

### Readiness y endpoints

Cambiar temporalmente `readinessProbe.httpGet.path` a `/missing`, aplicar y observar:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Recuperar:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

### Secret ausente

Eliminar el Secret de laboratorio y reiniciar el rollout:

```bash
kubectl -n platform-training delete secret platform-api-secret
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

Recuperar:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

No imprimir ni decodificar valores de Secret durante la demostracion.

### Requests y limits

Mostrar la especificacion declarada:

```bash
kubectl -n platform-training get deployment platform-api -o jsonpath='{.spec.template.spec.containers[0].resources}'
```

Comparar con allocatable del nodo:

```bash
kubectl describe node
```

Evitar convertir esta parte en observabilidad avanzada o HPA.

## Errores frecuentes

| Error | Sintoma | Intervencion |
|---|---|---|
| Aplicar Deployment antes de ConfigMap o Secret | Pods nuevos no arrancan | Revisar eventos y aplicar `configmap.yaml` y `secret.yaml`. |
| Confundir Secret con cifrado fuerte por defecto | Alumno propone versionar credenciales reales | Reforzar que solo se usan valores ficticios y que seguridad avanzada queda diferida. |
| Cambiar ConfigMap y esperar rollout automatico | No aparece nuevo ReplicaSet | Explicar diferencia entre datos proyectados y cambios del template de Pod. |
| Readiness mal configurada | Pods Running pero no Ready; Service sin endpoints listos | Revisar `describe pod` y EndpointSlice. |
| Liveness demasiado agresiva | Reinicios repetidos | Aumentar tiempos o restaurar `solution/deployment.yaml`. |
| Requests altos | Pods Pending | Usar eventos de scheduling y reducir requests. |
| Contexto de kubectl equivocado | Recursos ausentes o cluster inesperado | Revisar `kubectl config current-context` y `kubectl get nodes`. |

## Preguntas de comprobacion

- Que tipo de dato debe ir en un ConfigMap y cual no?
- Por que el Secret de esta unidad no debe usarse como ejemplo de gestion real de credenciales?
- Que cambio en un Deployment provoca un rollout?
- Que pasa con un Service cuando falla readiness?
- Que diferencia hay entre startup, readiness y liveness?
- Para que usa Kubernetes un request de CPU o memoria?
- Que efecto tiene un limit demasiado bajo?
- Que ruta debe reutilizar la Unidad 03?

## Criterios de evaluacion

El laboratorio se considera correcto si el alumno puede:

- aplicar `labs/02-configuration-lifecycle/solution/` sin errores;
- explicar por que se conserva `platform-api` y se crea una ruta nueva de laboratorio;
- identificar ConfigMap y Secret sin exponer valores sensibles;
- demostrar que el Deployment referencia ConfigMap, Secret, volumen, probes y resources;
- observar un rollout completo;
- comprobar que los Pods estan Ready;
- comprobar endpoints mediante EndpointSlice;
- probar HTTP por port-forward;
- diagnosticar al menos un fallo de ConfigMap, Secret o readiness;
- ejecutar `bash labs/02-configuration-lifecycle/validation/validate.sh` sin fallos.

## Riesgos tecnicos

| Riesgo | Mitigacion |
|---|---|
| La imagen `nginxinc/nginx-unprivileged:1.27.4-alpine` cambia o deja de estar disponible | Validar pull durante despliegue real; sustituir solo con decision documentada en summary y estado. |
| El volumen sobre `index.html` no refleja cambios inmediatamente | Explicar actualizacion de volumenes ConfigMap y usar rollout restart para una practica reproducible. |
| `kubectl get endpoints` muestra advertencia de deprecacion | Usar EndpointSlice en Unidad 02 y mencionar la diferencia con Unidad 01. |
| Alumnos imprimen datos del Secret | Insistir en `get` y `describe` sin decodificar valores; recordar que son ficticios. |
| Host local con pocos recursos | Mantener requests y limits modestos; revisar eventos si aparecen Pods Pending. |

## Limites de alcance

No introducir en esta unidad:

- Ingress, Gateway API, DNS ni TLS;
- PV, PVC ni StorageClass;
- Helm;
- Terraform;
- Tekton;
- Argo CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u OpenMetrics;
- HPA, KEDA ni escalado automatico;
- NetworkPolicies, RBAC avanzado, Pod Security o admission policies;
- gestores externos de secretos;
- AKS o EKS.

Cuando aparezcan preguntas sobre estas capacidades, conectarlas con el roadmap y volver al objetivo de la unidad: configuracion, secretos de laboratorio, salud y recursos del workload.
