# Student notes - Unidad 03

## Propósito

Estas notas explican cómo una petición HTTP llega hasta `platform-api`. El laboratorio crea un `Ingress`; estas notas explican la arquitectura de red que hace que ese objeto tenga sentido.

Para una capa de referencia más amplia, con criterios profesionales sobre TLS, certificados, `cert-manager`, cloud y Gateway API, consulta `tutorial/03-networking-ingress/student-reference.md`.

La idea central es:

```text
Un Pod tiene red efímera.
Un Service da estabilidad interna.
Un Ingress Controller ejecuta reglas de entrada HTTP.
Un recurso Ingress declara esas reglas.
```

## Qué se va a cubrir

| Bloque | Qué aporta | Nivel en esta unidad |
|---|---|---|
| Red de Pods | Entender por qué las IPs de Pods no son contrato estable | Conceptual |
| Service `ClusterIP` | Acceso interno estable hacia Pods | Práctico heredado |
| EndpointSlice | Evidencia de destinos listos | Práctico |
| DNS interno | Descubrimiento de Services dentro del clúster | Práctico |
| Ingress Controller | Componente real que recibe HTTP | Práctico en MicroK8s |
| Ingress | Regla declarativa de host/path hacia Service | Práctico |
| Host HTTP | Selección de regla por cabecera `Host` | Práctico |
| Gateway API | Comparación conceptual y camino futuro | Conceptual |

No se cubren TLS productivo, DNS público, certificados, LoadBalancer cloud, NetworkPolicies, service mesh ni Gateway API aplicada. Esos errores de concepto y criterios profesionales se desarrollan en `tutorial/03-networking-ingress/student-reference.md`.

## Qué representa cada componente

| Componente | Qué representa | Qué problema resuelve | Qué no es |
|---|---|---|---|
| Red de Pods | Comunicación entre Pods dentro del clúster | Permite que los workloads se comuniquen con IPs asignadas por Kubernetes | No ofrece identidades estables para clientes |
| Service | Identidad estable de red dentro del clúster | Evita depender de IPs efímeras de Pods | No publica por sí solo una aplicación hacia fuera |
| ClusterIP | Tipo de Service interno | Da una IP virtual accesible desde el clúster | No es una IP para usuarios externos |
| EndpointSlice | Lista de destinos reales y listos de un Service | Permite observar qué Pods recibirán tráfico | No se configura manualmente en esta unidad |
| DNS interno | Resolución de nombres de Services dentro del clúster | Permite usar nombres como `platform-api.platform-training.svc.cluster.local` | No es DNS público ni resuelve automáticamente desde tu navegador |
| Ingress Controller | Proxy o componente que recibe tráfico HTTP y aplica reglas | Convierte objetos Ingress en comportamiento real | No aparece solo por crear un Ingress |
| Ingress | Recurso declarativo con reglas HTTP | Expresa host, path y Service backend | No es el proxy que recibe conexiones |
| IngressClass | Selección del controlador que debe atender un Ingress | Evita ambigüedad cuando hay varios controladores | No enruta tráfico por sí misma |
| Host HTTP | Cabecera usada para elegir una regla | Permite enrutar varios nombres por el mismo punto de entrada | No es necesariamente DNS real |
| Gateway API | Modelo más moderno y expresivo para entrada y routing | Separa mejor infraestructura y reglas de aplicación | No sustituye al Ingress en este laboratorio |

Frase clave:

```text
Ingress declara la regla; el Ingress Controller la ejecuta.
```

## Qué vas a construir

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

En MicroK8s, el laboratorio depende del addon de Ingress. Esa es una pieza de plataforma local: los conceptos son Kubernetes, pero la forma concreta de habilitar el controlador depende de la distribución.

## Cómo se relacionan

La cadena de tráfico es:

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

El Ingress no apunta a Pods. Apunta a un Service. El Service, a su vez, encuentra Pods por labels y readiness. Por eso el diagnóstico de Ingress empieza siempre por abajo: Pods, Service, EndpointSlice, controlador, regla y cliente.

## Qué ocurre cuando aplicas los manifiestos

Flujo mental:

```text
1. Deployment, ConfigMap, Secret y Service mantienen la aplicación sana.
2. EndpointSlice refleja los Pods listos detrás del Service.
3. El recurso Ingress se guarda en la API.
4. El Ingress Controller observa ese Ingress.
5. El controlador configura su routing HTTP.
6. Una petición con Host: platform-api.local llega al controlador.
7. El controlador reenvia al Service platform-api.
8. El Service distribuye hacia Pods listos.
```

Crear un Ingress sin controlador activo no abre tráfico. El objeto puede existir perfectamente en la API y no tener ningún efecto observable desde fuera.

## Cómo comprobar que funciona

Comprueba que la aplicación sigue sana:

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

La validación automatizada de la unidad es:

```bash
bash labs/03-networking-ingress/validation/validate.sh
```

## Cómo diagnosticar los 4 fallos típicos

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

Idea clave: el DNS interno de Kubernetes sirve para Pods dentro del clúster. `platform-api.local` en este laboratorio es un host HTTP controlado para pruebas locales, no DNS público productivo.

## Qué debes recordar para la Unidad 04

La Unidad 04 introduce persistencia. Necesita una aplicación ya accesible y diagnosticable.

| Idea | Por qué importa después |
|---|---|
| Los Pods siguen siendo efímeros | La persistencia aparece porque recrear Pods borra datos escritos en su filesystem |
| Service e Ingress no guardan estado | Solo enrutan; no conservan datos |
| EndpointSlice muestra destinos listos | Seguirá siendo una evidencia de salud durante cambios |

Resumen:

```text
Ingress resuelve entrada HTTP.
No resuelve persistencia.
La aplicación sigue necesitando una forma de conservar datos fuera del Pod.
```

## Fuentes de referencia

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Kubernetes - Services](https://kubernetes.io/docs/concepts/services-networking/service/) | Service y tipos de Service | Distinguir Service interno de entrada externa |
| [Kubernetes - EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/) | EndpointSlice | Entender destinos reales de un Service |
| [Kubernetes - DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) | DNS interno | Separar DNS de clúster y DNS externo |
| [Kubernetes - Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) | Recurso Ingress | Entender reglas host/path/backend |
| [Kubernetes - Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) | Controladores de Ingress | Entender por qué el controlador es imprescindible |
| [Gateway API](https://gateway-api.sigs.k8s.io/) | Visión general | Comparar el modelo futuro con Ingress |
