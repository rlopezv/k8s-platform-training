# Student notes - Unidad 03

## Proposito de estas notas

Estas notas explican como llega una peticion HTTP hasta `platform-api`. El laboratorio crea y valida un `Ingress`; este documento explica la cadena de red que hace que eso tenga sentido.

La idea mas importante: la entrada HTTP no es un objeto aislado. Es una secuencia de responsabilidades.

## Modelo mental

Una peticion hacia `platform-api` atraviesa varias capas:

```text
Cliente local
  -> punto de entrada del controlador
    -> Ingress Controller
      -> regla Ingress
        -> Service
          -> EndpointSlice
            -> Pod Ready
              -> contenedor
```

Si falla HTTP, no sabemos aun donde esta el problema. Puede estar en el cliente, el host, el controlador, la regla, el Service, las labels, readiness o el contenedor.

## Red de Pods

Cada Pod recibe una direccion IP dentro del cluster. Esa IP permite comunicacion entre Pods, pero no es un contrato estable para usuarios ni para otros componentes.

Por que no debe usarse como contrato:

- cambia cuando el Pod se recrea;
- identifica una instancia, no una aplicacion;
- no expresa readiness;
- no sobrevive a rollouts.

La IP de Pod sirve para diagnostico, no como interfaz publica de la aplicacion.

## Service

El Service resuelve el problema de estabilidad interna. Publica un nombre y un puerto estables para un conjunto de Pods seleccionados por labels.

En esta unidad el Service sigue siendo:

```text
service/platform-api
type: ClusterIP
```

`ClusterIP` significa que el Service es interno al cluster. No esta pensado para usuarios externos.

El Service no sustituye a Ingress. Ingress usa el Service como backend.

## EndpointSlice

EndpointSlice representa los destinos reales que hay detras de un Service.

Si el Service selecciona dos Pods listos, EndpointSlice contiene sus direcciones. Si los Pods no estan Ready, no deberian aparecer como destinos listos para trafico.

EndpointSlice ayuda a responder:

```text
El Service tiene backends reales ahora mismo?
```

Es una evidencia mejor que mirar solo si el Service existe. Un Service puede existir y no tener ningun destino util.

## DNS interno de Kubernetes

Kubernetes publica nombres DNS para Services dentro del cluster.

Para esta unidad:

```text
platform-api.platform-training.svc.cluster.local
```

Ese nombre significa:

- `platform-api`: nombre del Service;
- `platform-training`: namespace;
- `svc`: familia de Services;
- `cluster.local`: dominio interno del cluster.

No es DNS publico. No tiene por que resolver desde Windows ni desde Ubuntu WSL. Se prueba desde un Pod porque pertenece a la red interna del cluster.

## Ingress Controller

Un Ingress Controller es el componente que acepta trafico y configura un proxy real segun reglas de Ingress.

Kubernetes por si solo define la API `Ingress`, pero no trae necesariamente un controlador funcionando. Por eso un cluster puede aceptar un objeto `Ingress` y aun asi no enrutar trafico.

En MicroK8s `v1.35`, el addon `ingress` despliega Traefik. En otros clusters podria usarse otro controlador.

Lo importante no es Traefik como producto, sino esta idea:

```text
Ingress es la declaracion.
Ingress Controller es quien la ejecuta.
```

## Ingress

Un recurso `Ingress` declara reglas HTTP o HTTPS.

En esta unidad la regla dice:

```text
Si la peticion usa host platform-api.local
y path /
entonces enviar al Service platform-api puerto 80.
```

El Ingress no apunta a Pods directamente. Apunta al Service. El Service y EndpointSlice resuelven que Pods estan disponibles.

## Host HTTP

HTTP permite que una peticion incluya una cabecera `Host`. Los controladores de Ingress usan esa cabecera para decidir que regla aplica.

Por eso la prueba usa:

```bash
curl -H 'Host: platform-api.local' http://127.0.0.1/
```

`127.0.0.1` es el destino de red local de la prueba. `platform-api.local` es el host HTTP que debe coincidir con la regla.

Si haces curl sin la cabecera correcta, puedes recibir 404 o backend por defecto aunque la aplicacion este sana.

## Gateway API

Gateway API es una evolucion del modelo de entrada de Kubernetes. Separa responsabilidades de forma mas rica que Ingress y usa recursos como `GatewayClass`, `Gateway` y `HTTPRoute`.

En esta unidad no se usa como laboratorio principal porque añadiria otra API y otro conjunto de decisiones antes de consolidar Ingress.

El addon de MicroK8s puede instalar CRDs de Gateway API como parte de su implementacion, pero el curso no crea recursos Gateway API todavia.

## Diagnostico por capas

Cuando HTTP falla, recorre la cadena:

| Capa | Pregunta |
|---|---|
| Pod | Hay Pods `Ready`? |
| Deployment | El rollout termino? |
| Service | El selector coincide con labels de Pods? |
| EndpointSlice | Hay direcciones de backend? |
| DNS interno | El nombre del Service resuelve desde un Pod? |
| Controlador | Hay Ingress Controller activo? |
| Ingress | Host, path y backend son correctos? |
| Cliente | La cabecera `Host` coincide? |

Este orden evita culpar al Ingress de problemas que empezaron antes.

## Seguridad basica

Exponer una aplicacion por Ingress cambia el perimetro de acceso. Aunque sea local, ya no estas usando solo `port-forward` para diagnostico.

Esta unidad no enseña todavia:

- TLS productivo;
- certificados publicos;
- autenticacion;
- autorizacion;
- WAF;
- NetworkPolicies;
- service mesh;
- DNS publico;
- LoadBalancer cloud.

Por tanto, el laboratorio demuestra entrada HTTP, no seguridad productiva.

## Errores de razonamiento frecuentes

| Error | Correccion |
|---|---|
| "Ingress abre trafico por si solo" | Necesita un controlador instalado y listo. |
| "Service e Ingress son lo mismo" | Service da estabilidad interna; Ingress declara entrada HTTP. |
| "DNS interno es `/etc/hosts`" | DNS del cluster resuelve desde Pods; `/etc/hosts` afecta al cliente local. |
| "Un 404 significa Pod caido" | Puede ser host o path que no coinciden. |
| "La IP del Pod sirve como endpoint estable" | Es efimera y no expresa la aplicacion completa. |

## Preguntas de comprobacion

- Por que el Ingress apunta a un Service y no a un Pod?
- Que demuestra EndpointSlice que no demuestra solo `kubectl get service`?
- Que diferencia hay entre resolver `platform-api.local` desde el host y resolver el Service desde un Pod?
- Que componente ejecuta realmente la regla de Ingress?
- Por que Gateway API se menciona pero no se usa como laboratorio principal?

## Continuidad

La Unidad 04 podra estudiar persistencia con una aplicacion ya accesible y diagnosticable por red:

```text
Deployment sano
  -> Service con endpoints
    -> Ingress HTTP local
      -> futura incorporacion de estado persistente
```
