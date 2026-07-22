# Student notes - Unidad 03

## Proposito

Estas notas explican como una peticion HTTP llega hasta `platform-api`. El laboratorio crea un `Ingress`; estas notas explican la arquitectura de red que hace que ese objeto tenga sentido.

Para una capa de referencia más amplia, con criterios profesionales sobre TLS, certificados, `cert-manager`, cloud y Gateway API, consulta `tutorial/03-networking-ingress/student-reference.md`.

La idea central es:

```text
Un Pod tiene red efimera.
Un Service da estabilidad interna.
Un Ingress Controller ejecuta reglas de entrada HTTP.
Un recurso Ingress declara esas reglas.
```

## Que se va a cubrir

| Bloque | Que aporta | Nivel en esta unidad |
|---|---|---|
| Red de Pods | Entender por que las IPs de Pods no son contrato estable | Conceptual |
| Service `ClusterIP` | Acceso interno estable hacia Pods | Practico heredado |
| EndpointSlice | Evidencia de destinos listos | Practico |
| DNS interno | Descubrimiento de Services dentro del cluster | Practico |
| Ingress Controller | Componente real que recibe HTTP | Practico en MicroK8s |
| Ingress | Regla declarativa de host/path hacia Service | Practico |
| Host HTTP | Seleccion de regla por cabecera `Host` | Practico |
| Gateway API | Comparacion conceptual y camino futuro | Conceptual |

No se cubren TLS productivo, DNS publico, certificados, LoadBalancer cloud, NetworkPolicies, service mesh ni Gateway API aplicada.

## Que representa cada componente

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| Red de Pods | Comunicacion entre Pods dentro del cluster | Permite que los workloads se comuniquen con IPs asignadas por Kubernetes | No ofrece identidades estables para clientes |
| Service | Identidad estable de red dentro del cluster | Evita depender de IPs efimeras de Pods | No publica por si solo una aplicacion hacia fuera |
| ClusterIP | Tipo de Service interno | Da una IP virtual accesible desde el cluster | No es una IP para usuarios externos |
| EndpointSlice | Lista de destinos reales y listos de un Service | Permite observar que Pods recibiran trafico | No se configura manualmente en esta unidad |
| DNS interno | Resolucion de nombres de Services dentro del cluster | Permite usar nombres como `platform-api.platform-training.svc.cluster.local` | No es DNS publico ni resuelve automaticamente desde tu navegador |
| Ingress Controller | Proxy o componente que recibe trafico HTTP y aplica reglas | Convierte objetos Ingress en comportamiento real | No aparece solo por crear un Ingress |
| Ingress | Recurso declarativo con reglas HTTP | Expresa host, path y Service backend | No es el proxy que recibe conexiones |
| IngressClass | Seleccion del controlador que debe atender un Ingress | Evita ambiguedad cuando hay varios controladores | No enruta trafico por si misma |
| Host HTTP | Cabecera usada para elegir una regla | Permite enrutar varios nombres por el mismo punto de entrada | No es necesariamente DNS real |
| Gateway API | Modelo mas moderno y expresivo para entrada y routing | Separa mejor infraestructura y reglas de aplicacion | No sustituye al Ingress en este laboratorio |

Frase clave:

```text
Ingress declara la regla; el Ingress Controller la ejecuta.
```

## Que vas a construir

La unidad conserva `platform-api`, su ConfigMap, Secret, probes, resources y Service interno. Añade un recurso `Ingress`.

| Elemento | Valor |
|---|---|
| Service backend | `service/platform-api` |
| Tipo de Service | `ClusterIP` |
| Ingress | `ingress/platform-api` |
| IngressClass | `public` |
| Host de laboratorio | `platform-api.local` |
| Path | `/` con `pathType: Prefix` |
| Backend | Service `platform-api`, puerto `80` |

En MicroK8s, el laboratorio depende del addon de Ingress. Esa es una pieza de plataforma local: los conceptos son Kubernetes, pero la forma concreta de habilitar el controlador depende de la distribucion.

## Como se relacionan

La cadena de trafico es:

```text
Cliente local
  -> Ingress Controller
      lee Ingress
      -> Service platform-api
          -> EndpointSlice
              -> Pod Ready
                  -> contenedor
```

Y la cadena declarativa es:

```text
Ingress
  host: platform-api.local
  path: /
  backend: service/platform-api:80
```

El Ingress no apunta a Pods. Apunta a un Service. El Service, a su vez, encuentra Pods por labels y readiness. Por eso el diagnostico de Ingress empieza siempre por abajo: Pods, Service, EndpointSlice, controlador, regla y cliente.

## Que ocurre cuando aplicas los manifiestos

Flujo mental:

```text
1. Deployment, ConfigMap, Secret y Service mantienen la aplicacion sana.
2. EndpointSlice refleja los Pods listos detras del Service.
3. El recurso Ingress se guarda en la API.
4. El Ingress Controller observa ese Ingress.
5. El controlador configura su routing HTTP.
6. Una peticion con Host: platform-api.local llega al controlador.
7. El controlador reenvia al Service platform-api.
8. El Service distribuye hacia Pods listos.
```

Crear un Ingress sin controlador activo no abre trafico. El objeto puede existir perfectamente en la API y no tener ningun efecto observable desde fuera.

## Como comprobar que funciona

Comprueba que la aplicacion sigue sana:

```bash
kubectl -n platform-training get deploy,pods,svc,endpoints
```

Comprueba EndpointSlice:

```bash
kubectl -n platform-training get endpointslice
```

Comprueba el Ingress:

```bash
kubectl -n platform-training get ingress platform-api
kubectl -n platform-training describe ingress platform-api
```

Comprueba el controlador de Ingress de MicroK8s:

```bash
kubectl get pods -n ingress
```

Prueba HTTP con host de laboratorio:

```bash
curl -i -H 'Host: platform-api.local' http://127.0.0.1/
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

La validacion automatizada de la unidad es:

```bash
bash labs/03-networking-ingress/validation/validate.sh
```

## Como diagnosticar los 4 fallos tipicos

### 1. El Ingress existe pero no responde

Comprueba:

```bash
kubectl -n platform-training get ingress platform-api
kubectl get pods -n ingress
```

Idea clave: el Ingress es una regla. Necesitas un Ingress Controller activo que la lea.

### 2. Recibes 404

Comprueba:

```bash
kubectl -n platform-training describe ingress platform-api
curl -i http://127.0.0.1/
curl -i -H 'Host: platform-api.local' http://127.0.0.1/
```

Idea clave: la regla se elige por `Host` y path. Si la cabecera no coincide, puedes llegar al controlador pero no a la regla correcta.

### 3. Recibes 502 o 503

Comprueba:

```bash
kubectl -n platform-training get svc platform-api
kubectl -n platform-training get endpoints platform-api
kubectl -n platform-training get pods
```

Idea clave: el controlador puede estar funcionando, pero el Service no tener destinos listos.

### 4. El DNS funciona en un sitio y no en otro

Comprueba:

```bash
kubectl -n platform-training get svc platform-api
```

Idea clave: el DNS interno de Kubernetes sirve para Pods dentro del cluster. `platform-api.local` en este laboratorio es un host HTTP controlado para pruebas locales, no DNS publico productivo.

## Que debes recordar para la Unidad 04

La Unidad 04 introduce persistencia. Necesita una aplicacion ya accesible y diagnosticable.

| Idea | Por que importa despues |
|---|---|
| Los Pods siguen siendo efimeros | La persistencia aparece porque recrear Pods borra datos escritos en su filesystem |
| Service e Ingress no guardan estado | Solo enrutan; no conservan datos |
| EndpointSlice muestra destinos listos | Seguira siendo una evidencia de salud durante cambios |

Resumen:

```text
Ingress resuelve entrada HTTP.
No resuelve persistencia.
La aplicacion sigue necesitando una forma de conservar datos fuera del Pod.
```

## Fuentes de referencia

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Kubernetes - Services](https://kubernetes.io/docs/concepts/services-networking/service/) | Service y tipos de Service | Distinguir Service interno de entrada externa |
| [Kubernetes - EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/) | EndpointSlice | Entender destinos reales de un Service |
| [Kubernetes - DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) | DNS interno | Separar DNS de cluster y DNS externo |
| [Kubernetes - Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) | Recurso Ingress | Entender reglas host/path/backend |
| [Kubernetes - Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) | Controladores de Ingress | Entender por que el controlador es imprescindible |
| [Gateway API](https://gateway-api.sigs.k8s.io/) | Vision general | Comparar el modelo futuro con Ingress |
