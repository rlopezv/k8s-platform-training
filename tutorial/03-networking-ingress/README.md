# Unidad 03 - Networking e ingreso

## Problema real

En la Unidad 02 `platform-api` ya era un workload mas serio: tenia configuracion externa, Secret de laboratorio, probes, requests, limits y un Service interno. Pero seguia habiendo una frontera importante: la aplicacion solo era comoda de consumir desde dentro del cluster o mediante `kubectl port-forward`.

Eso es util para diagnostico, no para operar una plataforma. Una plataforma necesita una forma declarativa y estable de recibir trafico HTTP, decidir a que Service enviarlo y conservar una separacion clara entre la aplicacion, el Service interno y el componente que acepta conexiones desde fuera.

Esta unidad introduce esa cadena de responsabilidades sin convertir todavia el laboratorio en una plataforma productiva. No hay DNS publico, TLS productivo, cloud load balancer ni certificados reales. El objetivo es entender bien el camino de una peticion.

## Objetivos

Al finalizar la unidad podras:

- explicar el recorrido de una peticion HTTP desde el cliente local hasta un Pod;
- diferenciar Pod IP, Service, EndpointSlice, DNS interno, Ingress Controller e `Ingress`;
- validar que `service/platform-api` conserva endpoints listos;
- comprobar resolucion DNS interna para `platform-api.platform-training.svc.cluster.local`;
- habilitar o verificar el controlador de Ingress local de MicroK8s;
- aplicar un `Ingress` HTTP hacia el Service existente;
- diagnosticar fallos por capas sin saltar directamente al recurso equivocado;
- comparar Ingress y Gateway API sin adelantar una migracion.

## Conocimientos previos

Debes venir de las Unidades 00, 01 y 02. En particular:

- sabes aplicar manifiestos con `kubectl apply`;
- has visto Deployment, Pod, ReplicaSet, Service, ConfigMap y Secret;
- entiendes que el Deployment crea Pods efimeros;
- has usado labels y selectors;
- has validado EndpointSlice como evidencia de Pods seleccionados por el Service;
- has usado `kubectl get`, `describe`, `logs`, `rollout status` y `port-forward`.

## Estado inicial

La unidad parte de:

- namespace `platform-training`;
- Deployment `platform-api` con dos replicas;
- imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`;
- ConfigMap `platform-api-config`;
- Secret ficticio `platform-api-secret`;
- probes y requests/limits;
- Service `platform-api` de tipo `ClusterIP`;
- MicroK8s local con addon `dns` heredado;
- sin Ingress aplicado para la aplicacion.

La base reutilizada es `labs/02-configuration-lifecycle/solution/`.

## Modelo mental

Piensa en la red de Kubernetes como una cadena, no como un objeto unico.

Un Pod tiene una IP propia dentro de la red del cluster, pero esa IP no es un contrato estable. Si el Pod se recrea, puede cambiar. Por eso un cliente no deberia depender de la IP de un Pod.

Un Service crea un punto estable dentro del cluster. Selecciona Pods mediante labels, publica un puerto y mantiene la relacion con los backends reales mediante EndpointSlices. Si no hay EndpointSlice con direcciones listas, el Service existe pero no tiene destinos utiles.

DNS interno permite que otros Pods usen nombres como `platform-api.platform-training.svc.cluster.local` en lugar de memorizar IPs de Service. Ese DNS existe dentro del cluster; no es el DNS del sistema operativo del alumno ni un registro publico.

Un Ingress Controller es un componente ejecutandose en el cluster. Observa recursos `Ingress` y configura un proxy real para aceptar trafico HTTP o HTTPS. Sin controlador, el YAML de `Ingress` puede existir en la API, pero nadie materializa la ruta.

Un recurso `Ingress` es la regla: host, path y backend. En esta unidad declara que las peticiones con host `platform-api.local` y path `/` deben ir al Service `platform-api` por el puerto `80`.

El cliente local solo participa al final. Debe enviar una peticion HTTP al punto de entrada del controlador y con la cabecera `Host` correcta. Si falla, no sabemos aun si el problema esta en el cliente, en el controlador, en la regla, en el Service o en los Pods.

## Service no es Ingress

El Service responde a la pregunta: "dentro del cluster, como encuentro un conjunto estable de Pods que implementan esta aplicacion?".

Ingress responde a otra pregunta: "cuando llega trafico HTTP a la entrada del cluster, que Service debe recibirlo segun host y path?".

Cambiar el Service a `NodePort` o `LoadBalancer` podria exponer la aplicacion, pero saltaria el objetivo pedagogico de esta unidad. Conservamos `ClusterIP` para ver que Ingress complementa al Service, no lo reemplaza.

## DNS interno

Kubernetes publica nombres DNS para Services. Para `platform-api`, el nombre completo esperado es:

```text
platform-api.platform-training.svc.cluster.local
```

Ese nombre debe resolverse desde Pods del cluster. No tiene por que resolverse desde Ubuntu WSL ni desde Windows. Si se modifica `/etc/hosts`, se esta resolviendo el host local del cliente, no el DNS interno de Kubernetes.

La prueba de laboratorio usa un Pod temporal:

```bash
kubectl -n platform-training run dns-check --rm -i --restart=Never --image=busybox:1.36 -- nslookup platform-api.platform-training.svc.cluster.local
```

## Ingress Controller e Ingress

Kubernetes define la API `Ingress`, pero el comportamiento depende de un controlador instalado. En MicroK8s `v1.35`, el addon `ingress` usa Traefik por defecto y expone clases de Ingress, entre ellas `public`.

La regla de la unidad usa:

```yaml
spec:
  ingressClassName: public
```

Esto es deliberadamente especifico del laboratorio local. En AKS, EKS o una plataforma corporativa, el controlador, la clase, el balanceador, DNS y certificados se decidirian de otra manera.

## Host y path

El `Ingress` de la unidad usa:

```text
Host: platform-api.local
Path: /
Backend: service/platform-api:80
```

El host no es un dominio publico. Es un nombre de laboratorio que permite practicar enrutamiento HTTP por host. La prueba recomendada evita cambios permanentes en `/etc/hosts`:

```bash
curl -i -H 'Host: platform-api.local' http://127.0.0.1/
```

Si se accede sin esa cabecera, el controlador puede devolver otro backend, un 404 o una respuesta por defecto. Eso no prueba que la aplicacion este caida; puede indicar simplemente que la regla HTTP no ha coincidido.

## Procedimiento orientativo

La secuencia completa esta en `labs/03-networking-ingress/README.md`. Conceptualmente, el orden correcto es:

1. validar la Unidad 02;
2. comprobar Pods, Service y EndpointSlice;
3. probar DNS interno;
4. habilitar o verificar el addon Ingress de MicroK8s;
5. aplicar `labs/03-networking-ingress/solution/`;
6. probar HTTP con host local controlado;
7. ejecutar `bash labs/03-networking-ingress/validation/validate.sh`.

## Diagnostico por capas

Cuando falla una peticion HTTP, evita empezar por el ultimo recurso que has escrito. Sigue la cadena:

| Capa | Pregunta | Comando util |
|---|---|---|
| Pod | Hay contenedores Ready? | `kubectl -n platform-training get pods` |
| Deployment | El rollout termino? | `kubectl -n platform-training rollout status deployment/platform-api` |
| Service | El selector coincide con los Pods? | `kubectl -n platform-training describe service platform-api` |
| EndpointSlice | Hay direcciones de backend? | `kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api` |
| DNS interno | El Service resuelve dentro del cluster? | `kubectl -n platform-training run dns-check --rm -i --restart=Never --image=busybox:1.36 -- nslookup platform-api.platform-training.svc.cluster.local` |
| Controlador | Hay Pods del controlador? | `kubectl get pods -n ingress` |
| Regla | Host, path y backend son correctos? | `kubectl -n platform-training describe ingress platform-api` |
| Cliente | La cabecera Host coincide? | `curl -i -H 'Host: platform-api.local' http://127.0.0.1/` |

## Errores de razonamiento frecuentes

- Creer que crear un `Ingress` abre trafico por si solo. Sin controlador, solo hay un objeto en la API.
- Confundir la IP del Pod con un contrato estable. Los Pods son reemplazables.
- Pensar que `ClusterIP` esta pensado para usuarios externos. Es red interna del cluster.
- Interpretar un 404 del controlador como fallo del Deployment. Puede ser host o path incorrecto.
- Confundir `/etc/hosts` con DNS interno. Uno afecta al cliente local; el otro a Pods dentro del cluster.
- Presentar el addon de MicroK8s como una verdad universal. Es una implementacion local para aprender.

## Ingress y Gateway API

Ingress es una API estable y ampliamente disponible para HTTP y HTTPS. Es suficiente para esta etapa: host, path y backend hacia un Service.

Gateway API aparece para expresar redes de entrada de forma mas rica y separada por roles. Introduce recursos como `GatewayClass`, `Gateway` y `HTTPRoute`, y permite modelos mas expresivos que Ingress. Aun asi, requiere CRDs y un controlador compatible. Por eso aqui queda como comparacion conceptual, no como estado operativo del laboratorio.

## Seguridad y limites

Exponer una aplicacion por Ingress cambia el perimetro del laboratorio. Aunque el ejemplo sea local y HTTP, el alumno debe interiorizar que entrada no es lo mismo que seguridad.

Esta unidad no incorpora:

- TLS productivo;
- certificados publicos;
- `cert-manager`;
- autenticacion o autorizacion;
- WAF;
- NetworkPolicies;
- service mesh;
- LoadBalancer cloud;
- DNS publico.

El Secret heredado sigue siendo ficticio y no debe imprimirse ni sustituirse por credenciales reales.

## Recuperacion

Si el laboratorio queda inconsistente, reaplica la solucion:

```bash
microk8s enable ingress
kubectl apply -f labs/03-networking-ingress/solution/
kubectl -n platform-training rollout status deployment/platform-api
bash labs/03-networking-ingress/validation/validate.sh
```

Eliminar solo el `Ingress` es reversible:

```bash
kubectl -n platform-training delete ingress platform-api
kubectl apply -f labs/03-networking-ingress/solution/ingress.yaml
```

Eliminar el namespace `platform-training` borra la aplicacion acumulada y debe hacerse solo con confirmacion explicita.

## Resultado final

Al cierre de la unidad, `platform-api` conserva su Service interno y queda expuesta en el laboratorio local por un `Ingress` HTTP para `platform-api.local`.

La Unidad 04 podra reutilizar `labs/03-networking-ingress/solution/` como nueva base acumulativa antes de introducir persistencia.

## Lectura guiada

- Kubernetes: Services, Load Balancing, and Networking: https://kubernetes.io/docs/concepts/services-networking/
- Kubernetes: Service: https://kubernetes.io/docs/concepts/services-networking/service/
- Kubernetes: DNS for Services and Pods: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
- Kubernetes: Ingress: https://kubernetes.io/docs/concepts/services-networking/ingress/
- Kubernetes: Gateway API: https://kubernetes.io/docs/concepts/services-networking/gateway/
- Gateway API SIG Network: https://gateway-api.sigs.k8s.io/docs/introduction/
- Canonical MicroK8s Ingress addon: https://canonical.com/microk8s/docs/ingress
