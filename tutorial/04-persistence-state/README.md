# Unidad 04 - Persistencia y estado

## Guia pedagogica de la unidad

Esta unidad trata sobre que ocurre con los datos cuando Kubernetes recrea Pods.

Hasta la Unidad 03 `platform-api` podia desplegarse, configurarse, validar salud, exponerse mediante Service interno y recibir trafico HTTP local por Ingress. Pero seguia teniendo una propiedad importante: cualquier dato escrito dentro del filesystem del contenedor pertenecia al ciclo de vida del Pod. Si el Pod desaparecia, ese dato podia desaparecer con el.

La Unidad 04 cubre:

- por que el filesystem de un contenedor no es un lugar fiable para conservar datos;
- que diferencia hay entre configuracion, secretos ficticios y datos persistentes;
- que problema resuelven `Volume`, `PersistentVolume`, `PersistentVolumeClaim` y `StorageClass`;
- por que un PVC es una solicitud de almacenamiento, no el almacenamiento en si;
- como se monta un volumen persistente en `platform-api`;
- como probar que un dato sobrevive a la recreacion de un Pod;
- por que tener un volumen no equivale a tener backup;
- que limites tiene el almacenamiento local de MicroK8s frente a almacenamiento cloud.

Para estudiar con más detalle el modelo mental de almacenamiento, usa `tutorial/04-persistence-state/student-notes.md`.

Para profundizar en criterios profesionales sobre PV, PVC, StorageClass, CSI, access modes, StatefulSet, headless Service, snapshots, backup y límites de `hostpath-storage`, usa `tutorial/04-persistence-state/student-reference.md`.

## Pregunta central

La pregunta de la unidad es:

```text
Que debe existir para que un dato escrito por un Pod sobreviva cuando ese Pod se recrea?
```

Si el alumno puede responderla, no confundira ConfigMaps con datos de aplicacion, PVC con disco, ni persistencia con recuperacion.

## Problema real

Un Pod es reemplazable. Esa idea ya aparecio en las unidades anteriores: Deployment crea ReplicaSets, los ReplicaSets crean Pods, y los Pods pueden cambiar durante rollouts o recuperaciones.

Para computo stateless, esa propiedad es una ventaja. Kubernetes puede destruir y crear Pods sin que el usuario se preocupe por la identidad concreta de cada instancia.

El problema aparece cuando una aplicacion escribe datos que deben sobrevivir a esa sustitucion. Si el dato vive solo dentro del contenedor, esta atado a una instancia efimera. La plataforma necesita una forma declarativa de separar:

- el proceso que ejecuta la aplicacion;
- la configuracion que recibe;
- los secretos que consume;
- los datos que deben sobrevivir.

## Objetivos

Al finalizar la unidad podras:

- explicar que datos se pierden y que datos sobreviven cuando se recrea un Pod;
- diferenciar filesystem de contenedor, `emptyDir`, ConfigMap/Secret como volumen y volumen persistente;
- inspeccionar las `StorageClass` disponibles en MicroK8s;
- aplicar un `PersistentVolumeClaim` para `platform-api`;
- montar un PVC en un Deployment sin cambiar el Service ni el Ingress;
- validar que un dato de laboratorio persiste tras eliminar un Pod;
- ejecutar una copia y restauracion basica de un dato no sensible;
- diagnosticar PVC `Pending`, volumen no montado y permisos de escritura;
- explicar por que `hostpath-storage` de MicroK8s no es una estrategia productiva general.

## Conocimientos previos

Debes venir de las Unidades 00, 01, 02 y 03. En particular:

- sabes aplicar manifiestos con `kubectl apply`;
- has visto Deployment, Pod, ReplicaSet, Service, ConfigMap, Secret e Ingress;
- entiendes que el Deployment reemplaza Pods;
- has usado labels y selectors;
- has validado EndpointSlice como evidencia de Pods listos detras del Service;
- has probado HTTP por Ingress local;
- has usado `kubectl get`, `describe`, `logs`, `exec` y `rollout status`.

## Estado inicial

La unidad parte de:

- namespace `platform-training`;
- Deployment `platform-api` con dos replicas;
- imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`;
- ConfigMap `platform-api-config`;
- Secret ficticio `platform-api-secret`;
- probes y requests/limits;
- Service `platform-api` de tipo `ClusterIP`;
- Ingress `platform-api` para host `platform-api.local`;
- MicroK8s local con `dns` e `ingress`;
- sin PVC de la aplicacion creado por unidades anteriores.

La base reutilizada es `labs/03-networking-ingress/solution/`.

## Mapa de aprendizaje

| Concepto | Responsabilidad | Pregunta de diagnostico |
|---|---|---|
| Filesystem del contenedor | Espacio efimero de una instancia | El dato esta dentro del Pod o fuera de el? |
| Volume | Conecta una ruta del contenedor con una fuente de datos | Que se monta y en que ruta? |
| PersistentVolumeClaim | Solicita almacenamiento para un workload | El claim esta `Bound`? |
| PersistentVolume | Representa el volumen aprovisionado | Que PV quedo asociado al claim? |
| StorageClass | Define como se aprovisiona almacenamiento | Que proveedor local o cloud lo respalda? |
| Mount | Hace visible el volumen dentro del contenedor | La ruta existe y es escribible? |
| Copia/restauracion | Permite recuperar un dato fuera del volumen activo | Se probo restaurar, o solo existe persistencia? |

## Modelo mental

Un Pod no es una maquina virtual con disco propio permanente. Es una instancia reemplazable de ejecucion.

Un volumen permite que el contenedor vea una ruta cuyo origen no es necesariamente el filesystem efimero del contenedor. Algunos volumenes siguen siendo efimeros, como `emptyDir`. Otros proyectan informacion ya gestionada por Kubernetes, como ConfigMaps o Secrets. Y otros conectan el Pod con almacenamiento persistente.

En el camino persistente intervienen varias responsabilidades:

```text
Pod
  -> volumeMount
    -> volume
      -> PersistentVolumeClaim
        -> PersistentVolume
          -> StorageClass
            -> proveedor de almacenamiento
```

El alumno no administra un disco directamente en esta unidad. Declara un PVC llamado `platform-api-data`. Kubernetes, mediante la StorageClass local de MicroK8s, crea o vincula un PV. El Deployment monta ese claim en `/usr/share/nginx/html/persistent`.

## Diseno del laboratorio

La solucion final queda en:

```text
labs/04-persistence-state/solution/
```

El cambio principal es:

- `pvc.yaml` solicita `1Gi` con `storageClassName: microk8s-hostpath`;
- `deployment.yaml` monta el PVC en `/usr/share/nginx/html/persistent`;
- `configmap.yaml` actualiza el texto visible de la unidad;
- `service.yaml` sigue siendo `ClusterIP`;
- `ingress.yaml` conserva `platform-api.local`.

La ruta persistente esta dentro del directorio servido por Nginx. Eso permite validar el dato de dos formas:

- desde el Pod con `kubectl exec`;
- desde fuera del cluster con `curl -H 'Host: platform-api.local'`.

## MicroK8s y portabilidad

El laboratorio local usa `hostpath-storage`, que crea una StorageClass llamada `microk8s-hostpath`.

Esto es especifico de MicroK8s. Sirve para aprender el flujo PVC/PV sin cloud, pero no debe extrapolarse a produccion:

- los datos quedan ligados al nodo local;
- no hay durabilidad cloud;
- no hay replicacion;
- no hay snapshots productivos;
- no hay politicas corporativas de backup;
- no hay garantias equivalentes a discos gestionados de AKS o EKS.

La API que aprende el alumno, en cambio, si es Kubernetes estandar: PVC, PV, StorageClass, volumes y volumeMounts.

## Procedimiento orientativo

La secuencia completa esta en `labs/04-persistence-state/README.md`. Conceptualmente, el orden correcto es:

1. validar la Unidad 03;
2. inspeccionar StorageClasses;
3. habilitar `hostpath-storage` si no existe `microk8s-hostpath`;
4. aplicar la solucion de Unidad 04;
5. comprobar PVC `Bound` y PV asociado;
6. escribir un dato no sensible en `/usr/share/nginx/html/persistent`;
7. leerlo por `kubectl exec` y por HTTP;
8. eliminar un Pod y comprobar que el dato sigue;
9. crear una copia temporal, borrar y restaurar el dato;
10. ejecutar `bash labs/04-persistence-state/validation/validate.sh`.

## Errores de razonamiento frecuentes

- Creer que un PVC es el dato. El PVC es la solicitud; el dato vive en el volumen aprovisionado.
- Confundir ConfigMap con persistencia. ConfigMap configura la aplicacion; no guarda datos escritos por ella.
- Pensar que Secret y almacenamiento son equivalentes. Secret entrega valores sensibles o ficticios; no es un filesystem persistente.
- Escribir el dato fuera del mount y concluir que Kubernetes perdio la persistencia.
- Presentar `hostpath-storage` como patron productivo general.
- Declarar que existe backup porque existe un volumen.
- Ignorar que access modes y replicas pueden condicionar scheduling y disponibilidad.

## Recuperacion

Si el laboratorio queda inconsistente:

```bash
microk8s enable hostpath-storage
kubectl apply -f labs/04-persistence-state/solution/
kubectl -n platform-training rollout status deployment/platform-api
bash labs/04-persistence-state/validation/validate.sh
```

Eliminar un Pod de `platform-api` es recuperable porque el Deployment lo recrea.

Eliminar el PVC `platform-api-data` puede borrar o desconectar datos persistentes segun la politica de reclamacion del PV. No debe hacerse como limpieza rutinaria sin aceptar esa perdida.

## Resultado final

Al cierre de la unidad, `platform-api` conserva ConfigMap, Secret ficticio, probes, resources, Service interno e Ingress local. Ademas, monta un PVC llamado `platform-api-data` en una ruta de datos de laboratorio.

La Unidad 05 podra reutilizar `labs/04-persistence-state/solution/` para tratar scheduling, resiliencia y mantenimiento sabiendo que ya existe una dependencia real de almacenamiento.

## Lectura guiada

- Kubernetes: Volumes: https://kubernetes.io/docs/concepts/storage/volumes/
- Kubernetes: Persistent Volumes: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
- Kubernetes: Storage Classes: https://kubernetes.io/docs/concepts/storage/storage-classes/
- Kubernetes: Configure a Pod to Use a PersistentVolume for Storage: https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/
- Kubernetes: Storage: https://kubernetes.io/docs/concepts/storage/
- Canonical MicroK8s hostpath storage addon: https://microk8s.io/docs/addon-hostpath-storage
