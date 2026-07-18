# Student notes - Unidad 04

## Proposito de estas notas

Estas notas explican como pensar sobre persistencia en Kubernetes antes de escribir YAML.

La idea mas importante: un Pod es reemplazable, pero algunos datos no deberian serlo.

## Tres tipos de informacion

En `platform-api` ya conviven varios tipos de informacion:

| Tipo | Ejemplo | Cambia como | Debe persistir como dato de aplicacion |
|---|---|---|---|
| Configuracion | `APP_ENV`, `LOG_LEVEL`, `index.html` | Manifiesto ConfigMap | No |
| Secreto de laboratorio | `LAB_API_TOKEN` ficticio | Manifiesto Secret | No como fichero de datos |
| Dato persistente | `persistent/message.txt` | Escritura de la aplicacion o del laboratorio | Si |

Confundir estas categorias lleva a malos disenos. Un ConfigMap no es una base de datos. Un Secret no es un volumen de trabajo. Un PVC no sustituye a la configuracion.

## Filesystem efimero del contenedor

Cuando un contenedor arranca, ve un filesystem. Puede escribir en algunas rutas. Eso no significa que esas escrituras sobrevivan al ciclo de vida del Pod.

Si Kubernetes elimina un Pod y crea otro, el nuevo Pod no es el mismo proceso ni el mismo filesystem efimero. Puede tener la misma imagen, las mismas labels y el mismo Service delante, pero no conserva automaticamente los cambios escritos dentro del contenedor anterior.

Esto no es un defecto. Es parte del modelo:

```text
Deployment desea estado
ReplicaSet mantiene replicas
Pod ejecuta contenedores
Pod puede ser reemplazado
```

La persistencia aparece cuando una parte del estado debe vivir fuera del Pod.

## Volume

Un `Volume` conecta una ruta del contenedor con una fuente de datos.

La palabra "volumen" no significa siempre "disco persistente". Kubernetes tiene muchos tipos de volumen:

- `emptyDir`: existe mientras existe el Pod;
- ConfigMap como volumen: proyecta claves de configuracion como ficheros;
- Secret como volumen: proyecta claves sensibles o ficticias como ficheros;
- PVC: conecta el Pod con almacenamiento persistente solicitado.

La pregunta correcta no es solo "hay un volumen?", sino:

```text
De donde viene ese volumen y cuanto vive?
```

## PersistentVolumeClaim

Un `PersistentVolumeClaim` es una solicitud de almacenamiento.

El workload dice:

```text
Necesito almacenamiento de este tamano, con este modo de acceso y esta clase.
```

El PVC no es el dato. Tampoco es necesariamente el disco. Es el contrato que permite a la aplicacion pedir almacenamiento sin conocer todos los detalles del proveedor.

En la unidad:

```text
pvc/platform-api-data
storageClassName: microk8s-hostpath
accessModes: ReadWriteOnce
storage: 1Gi
```

## PersistentVolume

Un `PersistentVolume` representa el volumen que Kubernetes ha enlazado al claim.

Puede haber sido creado manualmente o aprovisionado dinamicamente por una StorageClass. En este laboratorio se espera aprovisionamiento dinamico desde MicroK8s.

La relacion esperada es:

```text
PersistentVolumeClaim platform-api-data
  -> Bound
    -> PersistentVolume asociado
```

Si el PVC queda `Pending`, no tiene sentido empezar mirando Nginx. Primero hay que diagnosticar almacenamiento.

## StorageClass

Una `StorageClass` describe como se crea almacenamiento.

Es un contrato de plataforma. En MicroK8s, `microk8s-hostpath` usa almacenamiento local del nodo. En AKS o EKS, una StorageClass podria crear discos gestionados mediante un CSI driver cloud.

Mismo YAML conceptual, distintas consecuencias operativas:

| Entorno | StorageClass | Consecuencia |
|---|---|---|
| MicroK8s local | `microk8s-hostpath` | Datos ligados al nodo local |
| AKS | Clase de discos Azure | Depende de Azure Disk, identidad y politicas |
| EKS | Clase de EBS/EFS | Depende de CSI driver, IAM y politicas |

Por eso la unidad separa API estandar de implementacion local.

## Access modes

`ReadWriteOnce` significa que el volumen puede montarse como lectura/escritura por workloads en un nodo. No significa "solo un Pod para siempre" ni "seguro para escrituras concurrentes de cualquier aplicacion".

En un laboratorio MicroK8s de un nodo, dos replicas pueden terminar compartiendo el mismo volumen local. Eso permite practicar, pero no debe convertirse automaticamente en un patron productivo. Aplicaciones con estado compartido requieren diseno de concurrencia, bloqueo, consistencia y recuperacion.

## Mount

El Pod no usa directamente el PVC si no lo monta.

En la solucion:

```text
claim platform-api-data
  -> volume platform-api-data
    -> volumeMount /usr/share/nginx/html/persistent
```

La ruta importa. Si escribes en `/tmp/message.txt`, estas probando el filesystem efimero. Si escribes en `/usr/share/nginx/html/persistent/message.txt`, estas probando el PVC.

## Permisos

La imagen `nginxinc/nginx-unprivileged` ejecuta Nginx sin privilegios de root. Eso es deseable, pero puede hacer que un volumen recien montado no sea escribible por el proceso.

La solucion usa:

```yaml
securityContext:
  fsGroup: 101
  fsGroupChangePolicy: OnRootMismatch
```

La intencion es permitir escritura en el volumen sin convertir el contenedor en root. Este punto conecta almacenamiento con seguridad: resolver permisos elevando privilegios sin pensar suele crear problemas mayores.

## Persistencia no es backup

Persistencia significa que el dato no desaparece solo porque se recrea un Pod.

Backup significa que existe una copia recuperable fuera del volumen activo, con un procedimiento probado.

En la unidad se hace una copia temporal con `kubectl cp` y se restaura un fichero de laboratorio. Eso no es una estrategia productiva, pero enseña una verdad importante:

```text
No hay recuperacion si nunca has probado restaurar.
```

Snapshots CSI, Velero, restic, RPO, RTO y politicas corporativas quedan fuera de esta unidad.

## Diagnostico por capas

Cuando algo falla, sigue este orden:

| Capa | Pregunta |
|---|---|
| StorageClass | Existe la clase solicitada? |
| PVC | Esta `Bound`? |
| PV | Hay volumen asociado? |
| Pod | Se puede programar y arrancar? |
| Mount | La ruta existe dentro del contenedor? |
| Permisos | La ruta es escribible por el proceso? |
| Dato | Se escribio en la ruta persistente correcta? |
| Service/Ingress | La aplicacion sigue accesible por red? |

Este orden evita diagnosticar HTTP cuando el problema real es que el volumen nunca monto.

## Errores frecuentes

| Error | Correccion |
|---|---|
| "El PVC es mi disco" | El PVC es una solicitud enlazada a un PV. |
| "Si hay volumen, hay backup" | Persistencia y backup son capacidades distintas. |
| "ConfigMap guarda estado" | ConfigMap entrega configuracion declarativa. |
| "hostPath sirve igual en produccion" | Acopla datos al nodo local y no aporta durabilidad cloud. |
| "El dato se perdio" | Comprobar primero si se escribio dentro del mount. |
| "El Pod no arranca, Nginx falla" | Revisar eventos de PVC, PV y mount antes de culpar al contenedor. |

## Preguntas de comprobacion

- Que diferencia hay entre escribir en `/tmp` y escribir en `/usr/share/nginx/html/persistent`?
- Por que un PVC puede quedarse `Pending`?
- Que aporta una StorageClass al modelo?
- Por que `microk8s-hostpath` no debe presentarse como almacenamiento productivo?
- Por que tener persistencia no demuestra que exista recuperacion?
- Que problema resolveria StatefulSet que no estamos resolviendo todavia?

## Continuidad

La Unidad 05 podra estudiar scheduling, resiliencia y mantenimiento con una aplicacion que ya no es puramente stateless:

```text
Deployment
  -> Pods reemplazables
    -> PVC compartido de laboratorio
      -> nuevas restricciones de scheduling y mantenimiento
```
