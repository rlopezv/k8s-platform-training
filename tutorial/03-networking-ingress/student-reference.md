# Referencia del alumno - Unidad 03: Networking e ingreso

## Propósito de la referencia

Esta referencia amplía `tutorial/03-networking-ingress/student-notes.md` con una visión profesional sobre networking de Kubernetes, entrada HTTP, TLS, certificados, `cert-manager` y Gateway API.

El laboratorio de la Unidad 03 practica una entrada HTTP local con `Ingress`. Esta referencia cierra documentalmente `GAP-003` y aplica cobertura de panorama, profundidad, criterio y práctica: explica qué hay alrededor de ese ejercicio cuando el mismo patrón se lleva a una plataforma real, incluyendo DNS, CNI, controladores, balanceadores, MetalLB, anotaciones de controlador, certificados, terminación TLS, separación de responsabilidades y evolución hacia Gateway API.

No es una segunda guía de laboratorio. No instala `cert-manager`, no crea certificados, no cambia el recurso `Ingress`, no crea `GatewayClass`, `Gateway` ni `HTTPRoute`, y no modifica el estado técnico del clúster.

## Relación con la unidad

La Unidad 03 enseña la cadena que permite que una petición HTTP llegue a `platform-api`:

```text
Cliente
  -> punto de entrada local
  -> Ingress Controller
  -> Ingress
  -> Service
  -> EndpointSlice
  -> Pod Ready
```

La referencia profundiza en las decisiones que el laboratorio deja intencionadamente fuera:

- por qué Service, Ingress Controller e `Ingress` son responsabilidades distintas;
- qué cambia cuando la entrada deja de ser local y pasa a ser pública;
- cómo encajan DNS, balanceadores y certificados;
- qué significa terminar TLS en la entrada;
- cuándo `cert-manager` ayuda y qué no resuelve;
- por qué Gateway API existe y cuándo puede tener más sentido que Ingress.

Los artefactos principales para leer esta referencia son:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Ingress | `labs/03-networking-ingress/solution/ingress.yaml` | `ingressClassName`, `host`, `path`, `pathType` y backend |
| Service | `labs/03-networking-ingress/solution/service.yaml` | Service interno `ClusterIP` usado como backend |
| Deployment | `labs/03-networking-ingress/solution/deployment.yaml` | Pods seleccionados por labels y readiness |
| Validación | `labs/03-networking-ingress/validation/validate.sh` | Diagnóstico por capas sin cambiar recursos |

## Mapa conceptual

Kubernetes separa varias piezas que a veces se confunden:

```text
Service
  identidad estable interna para Pods

EndpointSlice
  destinos reales disponibles para un Service

DNS interno
  nombres de Service dentro del clúster

CNI
  implementación de conectividad entre Pods y nodos

Ingress
  reglas HTTP/HTTPS hacia Services

Ingress Controller
  implementación que recibe tráfico y aplica esas reglas

TLS y certificados
  identidad, cifrado y confianza en la entrada

Gateway API
  modelo más expresivo y separado por roles para entrada y routing
```

El laboratorio usa HTTP local porque primero interesa entender el recorrido de la petición. En producción, entrada significa también identidad de dominio, TLS, renovación de certificados, control de acceso, observabilidad, límites de exposición, operación del controlador y coste de la infraestructura de red.

## Conceptos y mecanismos

### Red de Pods y Service

Los Pods tienen IPs propias dentro del clúster, pero son efímeros. Kubernetes puede reemplazarlos durante rollouts, reinicios, mantenimiento o recuperación. Por eso una IP de Pod no debe ser el contrato de un cliente.

El modelo IP-per-Pod depende de una implementación CNI. Kubernetes define la expectativa de conectividad, pero la forma concreta de crear rutas, interfaces, encapsulación o políticas depende del plugin y de la distribución. En MicroK8s esa implementación queda gestionada por la plataforma local; la Unidad 03 no administra Calico, Flannel ni otro CNI como práctica. Lo importante para esta unidad es no confundir el principio estándar, "cada Pod obtiene una identidad de red", con la operación concreta del plugin que lo materializa.

Un `Service` da una identidad estable para un conjunto de Pods seleccionados por labels. En la Unidad 03, `service/platform-api` conserva tipo `ClusterIP` y puerto `80`, y el `Ingress` lo usa como backend.

El Service no garantiza que haya destinos sanos. Esa información aparece en `EndpointSlice`, que refleja los Pods disponibles para recibir tráfico.

### DNS interno de Kubernetes

Kubernetes publica nombres DNS para Services dentro del clúster. El nombre completo de `platform-api` es:

```text
platform-api.platform-training.svc.cluster.local
```

Ese nombre pertenece al DNS interno del clúster. No tiene por qué resolver desde el navegador, desde Windows ni desde Ubuntu WSL.

El host del laboratorio, `platform-api.local`, cumple otra función: permite practicar routing HTTP por cabecera `Host`. No es un dominio público ni demuestra por sí solo que exista DNS externo.

### Ingress Controller e Ingress

`Ingress` es una API de Kubernetes. Declara reglas de entrada HTTP o HTTPS, pero no recibe tráfico por sí mismo.

El Ingress Controller es la implementación que observa objetos `Ingress`, configura un proxy o balanceador y acepta conexiones. Puede ser Traefik, NGINX Ingress Controller, HAProxy, Contour, AWS Load Balancer Controller, Azure Application Gateway Ingress Controller u otra pieza de plataforma.

En MicroK8s, el laboratorio usa el addon `ingress`, que proporciona un controlador local y la clase `public`. Esa elección es una decisión del laboratorio, no una recomendación universal.

### Host, path y backend

Un `Ingress` decide según reglas HTTP. En esta unidad:

| Campo | Valor |
|---|---|
| `spec.ingressClassName` | `public` |
| `rules.host` | `platform-api.local` |
| `paths.path` | `/` |
| `paths.pathType` | `Prefix` |
| Backend | `service/platform-api:80` |

Un error de `Host` puede producir un 404 aunque la aplicación esté sana. Un error en el Service o en readiness puede producir 502 o 503 aunque el controlador esté funcionando.

### LoadBalancer, NodePort e Ingress

Kubernetes ofrece varias formas de exponer tráfico:

| Mecanismo | Qué expone | Uso típico |
|---|---|---|
| `ClusterIP` | Service interno | Comunicación dentro del clúster |
| `NodePort` | Puerto en los nodos | Casos simples, laboratorios o integración con balanceadores externos |
| `LoadBalancer` | Balanceador gestionado por la plataforma | Entrada L4 en cloud o plataformas con integración de balanceo |
| `Ingress` | Routing HTTP/HTTPS hacia Services | Entrada HTTP por host y path |
| Gateway API | Entrada y routing con separación de roles | Plataformas con necesidades más expresivas |

Ingress no sustituye al Service. Normalmente apunta a un Service, y el Service conserva la relación con Pods y EndpointSlices.

En clústeres cloud, un Service `LoadBalancer` suele pedir a la plataforma un balanceador real. En un laboratorio local esa integración puede no existir y el Service puede quedarse en estado `pending`. MetalLB es una implementación habitual para simular Services `LoadBalancer` en redes locales, normalmente anunciando direcciones en capa 2 o BGP. Es útil para aprender la frontera entre Kubernetes y red externa, pero no forma parte de la Unidad 03: instalarlo cambiaría el alcance del laboratorio y desplazaría el foco desde routing HTTP hacia operación de balanceo.

### Anotaciones de controlador

Muchos controladores de Ingress aceptan anotaciones para capacidades que no están en la API estándar de `Ingress`: reescritura de paths, CORS, límites de tamaño de petición, rate limiting, timeouts, redirecciones o afinidad de sesión.

El detalle importante es que esas anotaciones pertenecen al controlador, no a Kubernetes como contrato universal. Una anotación de NGINX puede no tener efecto en Traefik, Contour, HAProxy o un controlador cloud. Por eso el laboratorio no enseña `nginx.ingress.kubernetes.io/rewrite-target`, CORS ni rate limiting como YAML portable. La práctica profesional es documentar qué controlador usa la plataforma, qué anotaciones están permitidas y qué políticas deben vivir en otro sitio, como un API gateway, un WAF, Gateway API o políticas de plataforma.

### TLS y terminación

TLS resuelve tres problemas:

- cifra la comunicación entre cliente y punto de entrada;
- permite comprobar identidad del servidor mediante certificados;
- establece una cadena de confianza basada en autoridades certificadoras.

En Kubernetes, un `Ingress` puede declarar TLS con un bloque `spec.tls` que referencia un `Secret` de tipo `kubernetes.io/tls`. Ese Secret contiene certificado y clave privada.

La terminación TLS suele ocurrir en el punto de entrada: Ingress Controller, balanceador cloud, API gateway o service mesh. Desde ahí hasta el Pod puede haber HTTP interno, TLS reemitido o mTLS, según la plataforma.

La Unidad 03 no practica TLS porque introducir certificados implica dominios, confianza, renovación, claves privadas y decisiones de seguridad que no deben tratarse como un añadido superficial. Generar un certificado local y guardarlo como Secret puede enseñar la forma del objeto, pero también normalizaría copiar claves privadas en el repositorio si no se acompaña de un diseño completo. Por eso aquí se explica el mecanismo y se difiere la práctica.

### cert-manager

`cert-manager` automatiza la emisión y renovación de certificados en Kubernetes. Añade APIs como `Issuer`, `ClusterIssuer` y `Certificate`, y puede integrarse con ACME, autoridades internas o proveedores externos.

Ayuda a resolver:

- emisión declarativa de certificados;
- renovación antes de caducidad;
- escritura del certificado en Secrets;
- integración con Ingress o Gateway API cuando el controlador lo soporta.

No resuelve por sí solo:

- propiedad del dominio;
- exposición pública necesaria para algunos challenges;
- política corporativa de PKI;
- protección completa de claves privadas;
- autenticación de usuarios;
- autorización de aplicación;
- diseño de entrada multi-equipo.

Por eso queda como referencia futura. Encaja mejor cuando existan GitOps, DNS, cloud o gobierno de plataforma.

### Gateway API

Gateway API nace para expresar entrada y routing con más detalle que Ingress y con mejor separación de responsabilidades.

Sus piezas principales son:

| Recurso | Rol conceptual |
|---|---|
| `GatewayClass` | Tipo de gateway ofrecido por la plataforma |
| `Gateway` | Punto de entrada gestionado por infraestructura o plataforma |
| `HTTPRoute` | Reglas de routing de una aplicación o equipo |

La diferencia pedagógica más importante es la separación de roles. Ingress suele mezclar en un único recurso decisiones de aplicación y de entrada. Gateway API permite que plataforma y equipos de aplicación colaboren con objetos distintos.

Gateway API puede ser preferible cuando hay múltiples equipos, varios listeners, rutas compartidas, políticas transversales, necesidad de delegación o modelos de plataforma más maduros. Ingress sigue siendo suficiente para muchos casos HTTP sencillos y está ampliamente soportado.

## Criterios de decisión

### Cuándo basta con Ingress

Ingress suele ser suficiente cuando:

- necesitas routing HTTP/HTTPS por host y path;
- el controlador de la plataforma ya está estandarizado;
- hay pocas reglas y equipos;
- no necesitas delegación compleja;
- el laboratorio o entorno inicial prioriza simplicidad.

La Unidad 03 usa Ingress por esa razón: enseña la cadena de entrada sin obligar al alumno a aprender varias APIs a la vez.

### Cuándo considerar Gateway API

Gateway API empieza a tener más sentido cuando:

- varios equipos comparten puntos de entrada;
- plataforma y aplicaciones necesitan responsabilidades separadas;
- hay políticas comunes sobre listeners, certificados, rutas o dominios;
- se necesitan capacidades más expresivas que las de Ingress;
- el controlador de la organización soporta Gateway API de forma madura.

No conviene migrar solo porque sea más moderno. La decisión debe considerar soporte del controlador, madurez operativa, observabilidad, documentación interna y coste de cambio.

### Cuándo considerar LoadBalancer o MetalLB

Un Service `LoadBalancer` tiene sentido cuando la plataforma puede entregar una dirección estable de entrada de capa 4 y operar el balanceador asociado. En cloud, esa pieza suele ser un recurso gestionado del proveedor. En bare metal o laboratorio local, Kubernetes no puede inventar por sí solo una IP externa; necesita una implementación como MetalLB o una integración equivalente.

MetalLB no convierte el laboratorio local en cloud. Resuelve una necesidad concreta: anunciar direcciones para Services `LoadBalancer` en redes que Kubernetes no controla. Si el objetivo es routing HTTP por host y path, Ingress sigue siendo la abstracción más adecuada en esta unidad. Si el objetivo es practicar integración de red local o preparar una auditoría de acoplamientos antes de cloud, MetalLB encaja mejor como criterio de Unidad 19.

### Cuándo introducir TLS

TLS debe introducirse cuando la entrada representa un servicio que otros clientes consumirán con una identidad real. Incluso en entornos internos, la pregunta correcta no es "si hace falta TLS", sino dónde termina, quién emite certificados, cómo se renuevan y quién puede leer claves privadas.

En laboratorio local puede ser razonable empezar con HTTP si el objetivo es comprender routing. En producción, HTTP sin TLS debe ser una excepción justificada y acotada.

### Qué cambia en cloud

En cloud aparecen piezas que MicroK8s oculta o simplifica:

- balanceadores gestionados;
- DNS público o privado;
- integración con certificados gestionados;
- firewalls, security groups o network security groups;
- identidad del controlador;
- coste de load balancers, tráfico y direcciones IP;
- límites del proveedor y del controlador elegido.

La Unidad 19 retomará estas diferencias al desacoplar MicroK8s y preparar baseline AKS/EKS.

## Relación con el laboratorio

El laboratorio practica:

- Service `ClusterIP` como backend estable;
- EndpointSlice como evidencia de Pods listos;
- DNS interno desde un Pod temporal;
- addon Ingress de MicroK8s como controlador local;
- recurso `Ingress` con `ingressClassName: public`;
- routing por `Host: platform-api.local`;
- diagnóstico por capas.

El laboratorio menciona, pero no practica:

- TLS productivo;
- certificados;
- `cert-manager`;
- Gateway API aplicada;
- DNS público;
- MetalLB;
- cloud load balancers;
- anotaciones avanzadas de controlador;
- políticas de entrada multi-equipo.

No debe modificarse `labs/03-networking-ingress/solution/ingress.yaml` para añadir TLS en esta unidad. Esa decisión se deja para una unidad donde existan DNS, GitOps, cloud o estándares de plataforma suficientes.

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Creer que `Ingress` es el proxy | El proxy real es el Ingress Controller |
| Crear un `Ingress` sin controlador | El objeto existe, pero nadie aplica la regla |
| Exponer un Service cambiándolo a `NodePort` sin criterio | Se evita aprender la separación entre Service interno e ingreso HTTP |
| Confundir `platform-api.local` con DNS interno | Es una cabecera de laboratorio, no el nombre DNS del Service |
| Interpretar cualquier 404 como caída de la aplicación | Puede ser una regla de host/path que no coincide |
| Copiar anotaciones de un controlador a otro | Las anotaciones de Ingress no son API portable de Kubernetes |
| Instalar MetalLB para resolver cualquier entrada local | MetalLB resuelve Services `LoadBalancer`, no sustituye el criterio sobre Ingress, DNS y TLS |
| Añadir TLS copiando certificados manualmente | Las claves privadas, renovación y confianza necesitan un diseño explícito |
| Presentar Gateway API como reemplazo automático de Ingress | Depende del controlador, del modelo operativo y de la necesidad real |
| Tratar MicroK8s como si fuera cloud | En cloud cambian balanceador, DNS, identidad, coste y operación |

## Continuidad

La Unidad 04 conserva Service e Ingress mientras introduce persistencia. El alumno debe recordar que red y entrada no guardan estado.

La Unidad 09 retomará secretos desde GitOps; esa base será necesaria antes de automatizar certificados o credenciales reales asociadas a entrada.

La Unidad 10 podrá relacionar routing de entrada con promoción entre entornos, aunque progressive delivery queda como referencia hasta disponer de señales operativas suficientes.

La Unidad 12 y la Unidad 15 aportarán SLI/SLO, alertas y observabilidad integrada para decidir si una ruta de entrada está funcionando de verdad.

La Unidad 19 comparará supuestos locales de MicroK8s con AKS/EKS: CNI, Ingress Controller, `LoadBalancer`, MetalLB como patrón local, DNS, identidad, certificados y coste.

La Unidad 20 y la Unidad 21 deberán decidir cómo se implementan entrada, certificados e identidad en AKS y EKS.

La Unidad 24 retomará Gateway API, estándares de entrada, ownership por equipo y gobierno de plataforma cuando haya un modelo operativo más amplio.

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Kubernetes - Services](https://kubernetes.io/docs/concepts/services-networking/service/) | Secciones sobre tipos de Service y `LoadBalancer` | ¿Qué cambia entre `ClusterIP`, `NodePort`, `LoadBalancer` e Ingress? |
| [Kubernetes - Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/) | Modelo de red y responsabilidades de CNI | ¿Qué parte del modelo IP-per-Pod es estándar y qué parte depende del plugin? |
| [Kubernetes - Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) | Secciones sobre reglas, `pathType`, backend y TLS | ¿Qué declara un Ingress y qué no ejecuta por sí mismo? |
| [Kubernetes - Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/) | Relación entre API y controlador | ¿Por qué un Ingress sin controlador no abre tráfico? |
| [MetalLB Documentation](https://metallb.io/) | Propósito de MetalLB en bare metal | ¿Por qué un Service `LoadBalancer` local puede necesitar una implementación externa? |
| [Gateway API](https://gateway-api.sigs.k8s.io/) | Modelo, recursos y separación de roles | ¿Qué problema organizativo resuelve Gateway API frente a Ingress? |
| [cert-manager Documentation](https://cert-manager.io/docs/) | `Issuer`, `ClusterIssuer`, `Certificate` y automatización de certificados | ¿Qué automatiza `cert-manager` y qué decisiones quedan fuera? |
| [Canonical MicroK8s Ingress addon](https://canonical.com/microk8s/docs/ingress) | Funcionamiento del addon local de MicroK8s | ¿Qué parte del laboratorio es Kubernetes estándar y qué parte es específica de MicroK8s? |
