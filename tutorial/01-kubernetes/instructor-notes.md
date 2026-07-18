# Instructor notes - Unidad 01

## Intencion pedagogica

La unidad debe hacer que el alumno deje de ver Kubernetes como una lista de comandos y empiece a razonar en terminos de estado deseado, reconciliacion y diagnostico.

El resultado practico es deliberadamente pequeño: un namespace, un Deployment y un Service. Esa sencillez permite dedicar tiempo a observar que recursos aparecen, por que aparecen y como se conectan entre si.

## Puntos de enfasis

- `kubectl apply` envia declaracion al `kube-apiserver`; no "ejecuta contenedores" directamente.
- El Deployment no crea Pods de forma directa para el usuario: gestiona ReplicaSets, y estos mantienen Pods.
- El Service no enruta por nombre de Deployment. Enruta hacia Pods que coinciden con su selector.
- `status`, eventos y logs son observabilidad basica. No sustituye a Prometheus, Loki, Tempo ni OpenTelemetry.
- Helm y Terraform estan instalados, pero usarlos ahora ocultaria los objetos que el alumno necesita entender.
- MicroK8s es la distribucion local; los manifiestos de la unidad usan APIs Kubernetes estandar.

## Demostraciones recomendadas

### Reconciliacion

Aplicar la solucion:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
kubectl -n platform-training get deploy,rs,pods
```

Escalar temporalmente desde la linea de comandos:

```bash
kubectl -n platform-training scale deployment/platform-api --replicas=1
kubectl -n platform-training get pods
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl -n platform-training get pods
```

Explicar que el manifiesto vuelve a declarar `replicas: 2`.

### Selector del Service

Mostrar labels y selector:

```bash
kubectl -n platform-training get pods --show-labels
kubectl -n platform-training get service platform-api -o yaml
kubectl -n platform-training get endpoints platform-api
```

Si se quiere demostrar un fallo, cambiar temporalmente una clave del selector del Service, aplicar, observar endpoints vacios y revertir con `solution/service.yaml`.

### Imagen no descargable

Cambiar temporalmente la imagen a un tag inexistente, observar `ImagePullBackOff` con `describe pod` y eventos, y recuperar reaplicando `solution/deployment.yaml`.

## Errores frecuentes

| Error | Sintoma | Intervencion |
|---|---|---|
| Ejecutar comandos fuera de la raiz del repo | Rutas no encontradas | Pedir `pwd` y volver a `/home/ramon/git/k8s-platform-training`. |
| Aplicar Deployment antes del Namespace | `namespace not found` | Aplicar `namespace.yaml` primero y despues `deployment.yaml` y `service.yaml`. |
| Confundir Deployment con Pod | Buscan logs en `deployment` o `pod` sin entender selector | Mostrar `kubectl get deploy,rs,pods`. |
| Selector incorrecto | Service sin endpoints | Comparar `kubectl get pods --show-labels` con `kubectl get svc -o yaml`. |
| Contexto de `kubectl` equivocado | Recursos ausentes o nodo inesperado | Revisar `kubectl config current-context` y `kubectl get nodes`. |
| Pull de imagen lento | Rollout tarda o queda pendiente | Usar eventos y esperar antes de diagnosticar como error. |

## Preguntas de comprobacion

- Que componente recibe la declaracion enviada por `kubectl apply`?
- Donde se guarda el estado deseado del cluster?
- Que objeto mantiene el numero de replicas deseado?
- Por que no gestionamos Pods manualmente en esta unidad?
- Que ocurre si el selector de un Service no coincide con las labels de los Pods?
- Que diferencia hay entre logs, eventos y estado?
- Que capacidades quedan diferidas a la Unidad 02?

## Criterios de evaluacion

El laboratorio se considera correcto si el alumno puede:

- aplicar `labs/01-kubernetes/solution/` sin errores;
- explicar por que aparece un ReplicaSet aunque no exista un manifiesto de ReplicaSet;
- obtener Pods mediante labels;
- demostrar que el Service tiene endpoints;
- leer logs de `platform-api`;
- diagnosticar al menos un fallo de imagen o selector usando `describe`, eventos y logs;
- ejecutar `bash labs/01-kubernetes/validation/validate.sh` sin fallos.

## Riesgos tecnicos

| Riesgo | Mitigacion |
|---|---|
| Rate limit o fallo temporal al descargar `nginxinc/nginx-unprivileged:1.27.4-alpine` | Validar pull durante el despliegue real; si falla de forma persistente, sustituir por una imagen HTTP publica versionada y registrar el cambio en summary y project-state. |
| Permisos de MicroK8s no aplicados a la sesion actual | Cerrar y abrir Ubuntu WSL o usar diagnostico de Unidad 00. |
| Service validado solo por existencia, no por trafico HTTP | Ejecutar port-forward y `curl` como demostracion funcional. |
| Limpieza accidental antes de Unidad 02 | Reaplicar `labs/01-kubernetes/solution/` y ejecutar la validacion. |

## Limites de alcance

No introducir en esta unidad:

- ConfigMaps ni Secrets practicos;
- probes;
- requests o limits;
- Ingress o Gateway API practicos;
- persistencia;
- Helm;
- Terraform;
- Tekton;
- Argo CD;
- Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- KEDA;
- AKS o EKS.

Cuando aparezcan preguntas sobre esas capacidades, conectarlas con el mapa conceptual y recordar la unidad donde se implementaran.
