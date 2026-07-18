# Student notes - Unidad 01

## Proposito de estas notas

Estas notas explican los conceptos basicos que aparecen en el primer despliegue de `platform-api`. El laboratorio muestra como aplicar los manifiestos; este documento explica que significa cada recurso y por que existe.

La idea central de la unidad es que Kubernetes no es un comando para arrancar contenedores. Es una API declarativa con controladores que intentan mantener un estado deseado.

## Modelo mental principal

En Kubernetes normalmente no dices:

```text
Arranca este contenedor ahora.
```

Dices:

```text
Quiero que exista este estado.
```

Luego Kubernetes compara continuamente:

```text
Estado deseado
  -> lo que declaras en los manifiestos

Estado observado
  -> lo que existe ahora en el cluster

Reconciliacion
  -> trabajo de los controladores para acercar ambos estados
```

Si declaras dos replicas y solo hay una, Kubernetes intenta crear otra. Si un Pod desaparece, intenta reemplazarlo. Si el Service no selecciona ningun Pod, Kubernetes no "adivina" la intencion: muestra un Service sin endpoints.

## Que es un cluster

Un cluster Kubernetes es un conjunto coordinado de componentes que exponen una API y ejecutan workloads.

En un cluster grande puede haber muchos nodos. En este laboratorio MicroK8s ejecuta todo en una sola maquina, pero el modelo conceptual sigue siendo el mismo:

- hay una API donde declaras objetos;
- hay componentes que guardan y observan estado;
- hay nodos que ejecutan Pods;
- hay controladores que reaccionan a diferencias entre lo deseado y lo real.

No pienses en el cluster como "un servidor". Piensa en el cluster como un sistema que toma decisiones sobre objetos.

## Que es la API de Kubernetes

La API de Kubernetes es la entrada principal del cluster. `kubectl` no modifica archivos locales para desplegar una aplicacion; envia objetos a la API.

Un manifiesto YAML describe un objeto. Cuando lo aplicas, Kubernetes guarda ese objeto y sus controladores empiezan a trabajar.

El YAML tiene normalmente:

- `apiVersion`: version de la API usada por el objeto;
- `kind`: tipo de objeto;
- `metadata`: nombre, namespace, labels y datos de identificacion;
- `spec`: estado deseado;
- `status`: estado observado, mantenido por Kubernetes.

El alumno escribe `spec`. Kubernetes actualiza `status`.

## Que es un Namespace

Un `Namespace` es una frontera logica dentro del cluster. Sirve para agrupar recursos y evitar que todo viva mezclado en `default`.

En esta unidad se crea:

```text
platform-training
```

Ese namespace contiene los recursos funcionales del curso.

Un Namespace no es una maquina virtual. No crea un cluster separado ni aísla todo por seguridad avanzada. Es una forma basica de organizar nombres, recursos y operaciones.

Error frecuente: aplicar un Deployment en un namespace y buscarlo en otro. Por eso muchos comandos usan:

```bash
kubectl -n platform-training ...
```

## Que es un Pod

Un `Pod` es la unidad minima desplegable de Kubernetes.

La frase es importante, pero incompleta si se memoriza sin entenderla. Un Pod no es simplemente "un contenedor". Un Pod es una envoltura de ejecucion que puede contener uno o mas contenedores que comparten ciertas cosas:

- red del Pod;
- direccion IP del Pod;
- puertos;
- volumenes declarados para el Pod;
- ciclo de vida comun.

En esta unidad cada Pod de `platform-api` contiene un contenedor nginx. Eso hace que parezca que Pod y contenedor son lo mismo, pero no lo son.

Kubernetes gestiona Pods, no contenedores sueltos. El contenedor vive dentro del Pod.

## Por que los Pods son efimeros

Un Pod puede desaparecer y ser reemplazado:

- porque un nodo falla;
- porque cambia el Deployment;
- porque el contenedor no arranca;
- porque el operador elimina el Pod;
- porque Kubernetes necesita acercarse a otro estado deseado.

Cuando un Pod se reemplaza, puede cambiar su nombre y su IP. Por eso no conviene depender de un Pod concreto para dar servicio estable.

La pregunta correcta no es "como conservo este Pod?", sino "que objeto declara que debe existir otro Pod equivalente si este desaparece?".

## Que es un Deployment

Un `Deployment` declara como debe ejecutarse una aplicacion replicada.

En esta unidad el Deployment de `platform-api` dice, de forma simplificada:

```text
Quiero 2 replicas de Pods con esta imagen y estas labels.
```

El Deployment no es el contenedor. No es el Pod. Es el controlador de alto nivel que expresa el estado deseado de la aplicacion.

Responsabilidades principales:

- declarar numero de replicas;
- definir el template de Pod;
- gestionar cambios mediante rollouts;
- crear y coordinar ReplicaSets.

## Que es un ReplicaSet

Un `ReplicaSet` mantiene un numero determinado de Pods equivalentes.

En esta unidad no escribes un ReplicaSet a mano. Lo crea el Deployment. Lo observas para entender que Kubernetes descompone una declaracion de alto nivel en objetos derivados.

Relacion:

```text
Deployment
  -> crea ReplicaSet
    -> crea Pods
```

Error frecuente: intentar arreglar el sistema editando directamente el ReplicaSet o el Pod. En un flujo normal, corriges el Deployment y dejas que Kubernetes reconcilie.

## Que es un Service

Un `Service` da un punto de acceso estable hacia un conjunto de Pods.

El problema que resuelve es que los Pods cambian. Si una aplicacion tiene dos replicas, no quieres que otros componentes dependan de la IP de una replica concreta. Quieres un nombre y un puerto estables.

En esta unidad:

```text
service/platform-api
```

selecciona Pods usando labels y publica el puerto `80` dentro del cluster.

El Service no crea Pods. No arregla Pods que fallan. No sabe que quieres si el selector no coincide. Su responsabilidad es seleccionar backends y dar una entrada estable.

## Que son labels y selectors

Las labels son pares clave-valor asociados a objetos. Los selectors son consultas sobre esas labels.

En esta unidad unen tres piezas:

```text
Deployment selector
  -> reconoce Pods que pertenecen al Deployment

Pod template labels
  -> labels que reciben los Pods creados

Service selector
  -> selecciona Pods que recibiran trafico
```

Si el Service busca:

```text
app.kubernetes.io/name=platform-api
```

pero los Pods no tienen esa label, el Service existira sin endpoints. Eso no significa que la red este rota. Significa que el contrato de seleccion esta roto.

## Que significa observar Kubernetes

Observar no es mirar una sola salida. Es cruzar varias señales:

| Señal | Que responde |
|---|---|
| `kubectl get` | Existe el objeto y cual es su estado resumido? |
| `kubectl describe` | Que eventos y detalles explican su situacion? |
| `kubectl logs` | Que dice el proceso dentro del contenedor? |
| endpoints o EndpointSlice | Que Pods listos esta seleccionando el Service? |
| `rollout status` | El Deployment alcanzo el estado esperado? |

Un buen diagnostico empieza preguntando que capa esta fallando.

## platform-api como aplicacion evolutiva

`platform-api` es una aplicacion HTTP minima. No es importante por su logica de negocio, sino porque sera el hilo conductor del curso.

En Unidad 01 sirve para aprender:

- declarar un Deployment;
- crear Pods replicados;
- exponerlos internamente con un Service;
- validar logs y respuesta HTTP.

En unidades posteriores se le añadiran configuracion, salud, ingreso, persistencia, empaquetado, automatizacion, observabilidad, seguridad y cloud.

## Errores de razonamiento frecuentes

| Error | Correccion |
|---|---|
| "Un Pod es un contenedor" | Un Pod contiene contenedores y define su contexto compartido. |
| "El Deployment ejecuta la aplicacion" | El Deployment declara; los Pods ejecutan. |
| "El Service apunta al Deployment" | El Service selecciona Pods por labels. |
| "Si el Pod esta Running, la aplicacion funciona" | Running solo habla del contenedor; puede fallar trafico, readiness o configuracion. |
| "Borrar el Pod arregla el Deployment" | El controlador creara otro igual si la declaracion no cambia. |

## Preguntas de comprobacion

- Que diferencia hay entre Deployment, ReplicaSet y Pod?
- Por que Kubernetes no recomienda depender de la IP de un Pod?
- Que campo del Service decide que Pods reciben trafico?
- Que mirarias si hay Pods Running pero el Service no tiene endpoints?
- Que parte del manifiesto representa el estado deseado?

## Continuidad

La Unidad 02 parte de este modelo. Antes de hablar de ConfigMaps, Secrets, probes y recursos, necesitas tener clara esta cadena:

```text
Deployment -> ReplicaSet -> Pods -> Service -> endpoints
```

Si esa cadena no esta clara, los siguientes conceptos pareceran solo campos YAML adicionales.
