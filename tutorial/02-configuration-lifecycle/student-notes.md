# Student notes - Unidad 02

## Proposito de estas notas

Estas notas explican que significa hacer que un workload sea configurable y operable. El laboratorio muestra los manifiestos; aqui se explica el modelo mental.

La Unidad 02 no trata de escribir mas YAML. Trata de declarar que necesita la aplicacion para arrancar, recibir trafico, recuperarse y compartir recursos con otros workloads.

## Modelo mental

Un Deployment minimo puede crear Pods, pero Kubernetes necesita mas informacion para operarlos bien:

```text
Que datos recibe?
Cuando esta lista?
Cuando debe reiniciarse?
Cuantos recursos necesita?
Que Pods pueden recibir trafico?
```

La Unidad 02 responde esas preguntas con ConfigMap, Secret, probes, requests y limits.

## Configuracion

Configuracion es informacion que modifica el comportamiento de la aplicacion sin cambiar su imagen.

Ejemplos:

- entorno (`APP_ENV`);
- nivel de logs (`LOG_LEVEL`);
- mensaje o contenido de laboratorio;
- URL de una dependencia no sensible;
- flags de una funcionalidad.

La configuracion no deberia obligar a reconstruir la imagen. Si cada entorno necesita una imagen distinta para cambiar valores, la frontera entre build y operacion queda borrosa.

## ConfigMap

Un `ConfigMap` almacena datos no sensibles como claves y valores. Kubernetes puede entregarlos a un Pod como variables de entorno o como archivos montados.

Que resuelve:

- separar configuracion no sensible de la imagen;
- versionar parametros de laboratorio;
- permitir que el Deployment declare de donde obtiene sus valores.

Que no resuelve:

- no protege secretos;
- no reinicia automaticamente Pods de forma trazable por cualquier cambio;
- no valida que el contenido tenga sentido para la aplicacion.

En esta unidad, el ConfigMap tambien contiene un `index.html` para que el alumno vea un efecto observable sin reconstruir la imagen.

## Secret

Un `Secret` almacena datos que Kubernetes trata como sensibles en su API. En esta unidad se usa solo con valores ficticios.

Es importante ser preciso: un Secret no significa automaticamente "seguridad completa". Segun configuracion del cluster, politicas de acceso y cifrado, puede requerir controles adicionales.

Que resuelve en esta unidad:

- practicar como un Pod referencia datos no publicos;
- separar conceptualmente valores sensibles de ConfigMap;
- evitar imprimir valores en validaciones.

Que no resuelve todavia:

- rotacion;
- integracion con vault externo;
- cifrado corporativo;
- politicas RBAC avanzadas;
- auditoria de acceso a secretos.

## Variables de entorno

Una variable de entorno entrega un valor al proceso cuando arranca. Es comoda para parametros simples, pero no es ideal para todo.

Ventajas:

- facil de leer por muchas aplicaciones;
- simple de declarar;
- buena para valores pequeños.

Limites:

- normalmente requiere reiniciar el proceso para cambiar;
- puede aparecer en diagnosticos si no se cuida;
- no sirve bien para archivos estructurados grandes.

## Volumen de configuracion

Un volumen desde ConfigMap permite montar datos como archivos dentro del Pod.

En esta unidad se monta `index.html` para que nginx sirva contenido definido fuera de la imagen.

Esto no es persistencia. Si el Pod escribe datos propios y se destruye, esos datos no quedan preservados por usar un ConfigMap. La persistencia se estudiara en Unidad 04 con volumenes persistentes.

## Probes

Las probes son preguntas que el kubelet hace al contenedor.

No son observabilidad avanzada. Son señales locales de salud que Kubernetes usa para tomar decisiones inmediatas.

### Startup probe

Pregunta:

```text
La aplicacion ya termino de arrancar?
```

Sirve para proteger aplicaciones que tardan en iniciar. Mientras startup falla, liveness no mata el contenedor por impaciencia.

### Readiness probe

Pregunta:

```text
Esta instancia puede recibir trafico?
```

Si readiness falla, el Pod puede seguir `Running`, pero deja de ser candidato para recibir trafico del Service. Esto afecta a EndpointSlice.

Readiness no reinicia el contenedor. Solo cambia su disponibilidad para trafico.

### Liveness probe

Pregunta:

```text
El contenedor sigue sano o debe reiniciarse?
```

Si liveness falla repetidamente, el kubelet reinicia el contenedor.

Error frecuente: usar liveness para comprobar dependencias externas. Si una base de datos externa falla, reiniciar todos los contenedores puede empeorar el incidente.

## Requests y limits

Los recursos son otro contrato entre Pod y plataforma.

`requests` indican lo que el Pod solicita para ser planificado. El scheduler los usa para decidir si un nodo puede alojarlo.

`limits` indican el maximo permitido. El nodo y el runtime aplican esa frontera.

No son lo mismo:

| Campo | Pregunta |
|---|---|
| request CPU | Cuanta CPU deberia reservarse para planificar? |
| limit CPU | Hasta donde se permite consumir CPU? |
| request memory | Cuanta memoria minima se reserva al planificar? |
| limit memory | A partir de que consumo de memoria se puede terminar el contenedor? |

Un request demasiado alto puede dejar Pods en `Pending`. Un limit demasiado bajo puede provocar terminaciones por memoria o throttling.

## Rollout

Un rollout ocurre cuando cambia el template de Pod de un Deployment.

Cambiar una variable de entorno en el Deployment cambia `.spec.template`, por tanto Kubernetes crea una nueva revision y nuevos Pods.

Cambiar solo el contenido de un ConfigMap no siempre produce un rollout del Deployment. La plataforma puede actualizar archivos montados con cierta demora, pero si quieres trazabilidad operativa normalmente fuerzas o declaras un cambio visible.

## Relacion con Service y EndpointSlice

La Unidad 01 explico que el Service selecciona Pods. La Unidad 02 añade un matiz: no todos los Pods seleccionados deben recibir trafico.

El Service debe encontrar Pods que:

- coinciden por labels;
- existen;
- estan listos segun readiness.

EndpointSlice muestra esos destinos. Si readiness falla, puede desaparecer la direccion del Pod de EndpointSlice aunque el Pod siga vivo.

## Errores de razonamiento frecuentes

| Error | Correccion |
|---|---|
| "ConfigMap sirve para cualquier dato externo" | Solo para datos no sensibles. |
| "Secret significa dato seguro en cualquier circunstancia" | Secret requiere controles adicionales y aqui solo usa valores ficticios. |
| "Running significa listo para trafico" | Readiness decide si recibe trafico. |
| "Liveness arregla cualquier fallo" | Liveness reinicia; no diagnostica ni corrige causas externas. |
| "Requests y limits son metricas" | Son declaracion de recursos, no observacion de consumo real. |
| "Un volumen de ConfigMap es persistencia" | Es configuracion montada, no almacenamiento persistente de datos de aplicacion. |

## Preguntas de comprobacion

- Que dato pondrias en ConfigMap y cual nunca deberias poner ahi?
- Por que un Pod puede estar `Running` pero no recibir trafico?
- Que probe afecta a EndpointSlice?
- Que diferencia hay entre reiniciar un contenedor y retirarlo del trafico?
- Por que requests hablan con el scheduler y limits con el nodo/runtime?
- Que cambio crea un nuevo ReplicaSet y cual puede no hacerlo?

## Continuidad

La Unidad 03 parte de un workload que ya declara configuracion, salud y recursos. Eso permite estudiar red e ingreso con una base sana:

```text
Pod configurable y observable
  -> Service con endpoints listos
    -> DNS interno
      -> Ingress
```
