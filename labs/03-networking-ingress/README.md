# Laboratorio - Unidad 03

## Proposito

Este laboratorio evoluciona `platform-api` desde el estado final de la Unidad 02 hacia una aplicacion accesible por HTTP mediante un recurso `Ingress` local.

La unidad incorpora:

- comprobacion de Service `ClusterIP` y EndpointSlice;
- validacion de DNS interno de Kubernetes;
- uso del addon Ingress de MicroK8s como controlador local;
- recurso `Ingress` para el host de laboratorio `platform-api.local`;
- diagnostico por capas: Pod, Service, EndpointSlice, DNS, controlador, regla de Ingress y cliente.

Helm y Terraform siguen disponibles como herramientas base, pero no gestionan ningun recurso de este laboratorio.

## Estructura

```text
labs/03-networking-ingress/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Artefactos

| Ruta | Uso |
|---|---|
| `starter/` | Punto de partida para revisar la cadena completa de red antes de comparar con la solucion. |
| `solution/` | Estado final de la unidad. Esta ruta es la base que debe reutilizar la Unidad 04. |
| `validation/validate.sh` | Validacion del estado esperado tras aplicar `solution/`. Crea un Pod temporal para probar DNS interno. |

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/02-configuration-lifecycle/validation/validate.sh
kubectl config current-context
kubectl get nodes
microk8s status --wait-ready
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
El Deployment platform-api de Unidad 02 esta disponible.
El contexto de kubectl apunta al MicroK8s local.
El addon dns aparece habilitado.
```

Si la Unidad 02 no esta aplicada, recuperar el estado base:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
bash labs/02-configuration-lifecycle/validation/validate.sh
```

## Controlador de Ingress en MicroK8s

Kubernetes acepta recursos `Ingress`, pero necesita un controlador que los observe y configure el proxy real. En MicroK8s, habilitar el addon es un paso especifico de la plataforma local:

```bash
microk8s enable ingress
microk8s status --wait-ready
kubectl get ingressclass
kubectl get pods -n ingress
```

En MicroK8s `v1.35`, el addon usa Traefik por defecto y proporciona la clase `public`, que es la usada por `labs/03-networking-ingress/solution/ingress.yaml`.

## Despliegue

Aplicar la solucion en orden explicito:

```bash
kubectl apply -f labs/03-networking-ingress/solution/namespace.yaml
kubectl apply -f labs/03-networking-ingress/solution/configmap.yaml
kubectl apply -f labs/03-networking-ingress/solution/secret.yaml
kubectl apply -f labs/03-networking-ingress/solution/deployment.yaml
kubectl apply -f labs/03-networking-ingress/solution/service.yaml
kubectl apply -f labs/03-networking-ingress/solution/ingress.yaml
```

Comprobar el rollout y la cadena interna:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress
```

## Prueba de DNS interno

Probar el nombre DNS completo del Service desde dentro del cluster:

```bash
kubectl -n platform-training run dns-check --rm -i --restart=Never --image=busybox:1.36 -- nslookup platform-api.platform-training.svc.cluster.local
```

Resultado esperado:

```text
El nombre platform-api.platform-training.svc.cluster.local resuelve dentro del cluster.
```

## Prueba HTTP por Ingress

La prueba recomendada no requiere modificar `/etc/hosts`; fuerza la cabecera `Host` en la peticion:

```bash
curl -i -H 'Host: platform-api.local' http://127.0.0.1/
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

El cuerpo HTML debe mencionar:

```text
Unidad 03: acceso HTTP mediante Service interno e Ingress local.
```

Si el entorno WSL no enruta `127.0.0.1` hacia el controlador, obtener la direccion del nodo y probar contra ella manteniendo la cabecera `Host`:

```bash
kubectl get nodes -o wide
curl -i -H 'Host: platform-api.local' http://<INTERNAL-IP-del-nodo>/
```

## Validacion automatizada

Ejecutar:

```bash
bash labs/03-networking-ingress/validation/validate.sh
```

La validacion comprueba:

- disponibilidad de `kubectl`;
- acceso al cluster;
- namespace, Deployment y Pods Ready;
- Service `platform-api` de tipo `ClusterIP`;
- EndpointSlice con endpoints;
- DNS interno mediante un Pod temporal;
- `IngressClass` `public`;
- Pods del controlador en namespace `ingress`;
- recurso `Ingress` con host y backend esperados;
- HTTP local con cabecera `Host: platform-api.local`.

Puede parametrizarse:

```bash
INGRESS_URL=http://<direccion-del-nodo>/ bash labs/03-networking-ingress/validation/validate.sh
```

Tambien se puede cambiar el host esperado si se modifica el manifiesto:

```bash
INGRESS_HOST=otro-host.local bash labs/03-networking-ingress/validation/validate.sh
```

## Diagnostico rapido

Pods y rollout:

```bash
kubectl -n platform-training get deploy,rs,pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Service y EndpointSlice:

```bash
kubectl -n platform-training get service platform-api
kubectl -n platform-training describe service platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

DNS interno:

```bash
kubectl -n platform-training run dns-check --rm -i --restart=Never --image=busybox:1.36 -- nslookup platform-api.platform-training.svc.cluster.local
kubectl -n kube-system get pods -l k8s-app=kube-dns
```

Ingress:

```bash
kubectl get ingressclass
kubectl get pods -n ingress
kubectl -n platform-training describe ingress platform-api
kubectl -n platform-training get ingress platform-api -o yaml
```

Logs:

```bash
kubectl -n platform-training logs deployment/platform-api --tail=50
kubectl -n ingress logs --tail=50 --all-containers -l app.kubernetes.io/name=traefik
```

## Recuperacion

Reaplicar el estado declarado:

```bash
microk8s enable ingress
kubectl apply -f labs/03-networking-ingress/solution/namespace.yaml
kubectl apply -f labs/03-networking-ingress/solution/configmap.yaml
kubectl apply -f labs/03-networking-ingress/solution/secret.yaml
kubectl apply -f labs/03-networking-ingress/solution/deployment.yaml
kubectl apply -f labs/03-networking-ingress/solution/service.yaml
kubectl apply -f labs/03-networking-ingress/solution/ingress.yaml
kubectl -n platform-training rollout status deployment/platform-api
bash labs/03-networking-ingress/validation/validate.sh
```

Si el `Ingress` existe pero no enruta:

```bash
kubectl -n platform-training describe ingress platform-api
kubectl get ingressclass
kubectl get pods -n ingress
curl -i -H 'Host: platform-api.local' http://127.0.0.1/
```

## Limpieza opcional

Eliminar solo la regla de entrada:

```bash
kubectl -n platform-training delete ingress platform-api
```

Recuperacion:

```bash
kubectl apply -f labs/03-networking-ingress/solution/ingress.yaml
```

Eliminar el namespace borra la aplicacion acumulada que la Unidad 04 espera reutilizar. Ejecutarlo solo con confirmacion explicita:

```bash
kubectl delete namespace platform-training
```

No usar scripts de reset de MicroK8s como limpieza de esta unidad.
