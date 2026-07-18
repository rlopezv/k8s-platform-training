# Instructor notes - Unidad 04

## Intencion pedagogica

La unidad debe cambiar la intuicion del alumno: Kubernetes no "pierde" datos por accidente; los Pods estan disenados para ser reemplazables. La persistencia aparece cuando se separa el ciclo de vida del dato del ciclo de vida del Pod.

El objetivo no es ensenar almacenamiento productivo completo, sino construir el modelo PVC/PV/StorageClass con una validacion real y pequena.

## Puntos de enfasis

- Empezar preguntando que ocurriria si un Pod escribe un fichero y luego se recrea.
- Separar configuracion, Secret ficticio y dato persistente.
- Repetir que el PVC es una solicitud, no el dato.
- Mostrar `kubectl get storageclass`, `kubectl get pvc` y `kubectl get pv` antes de hablar de Nginx.
- Aislar `microk8s-hostpath` como detalle local, no como patron productivo.
- Subrayar que persistencia no equivale a backup.

## Demostracion recomendada

1. Validar Unidad 03.
2. Mostrar que no hay PVC previos de `platform-api`.
3. Ejecutar `kubectl get storageclass`.
4. Habilitar `microk8s enable hostpath-storage` si falta la clase.
5. Aplicar `labs/04-persistence-state/starter/` y observar que el PVC existe pero el Deployment aun no monta el volumen.
6. Comparar `starter/deployment.yaml` con `solution/deployment.yaml`.
7. Aplicar `labs/04-persistence-state/solution/`.
8. Escribir `message.txt`.
9. Eliminar un Pod y comprobar que el dato sigue.
10. Borrar/restaurar el fichero desde copia temporal.

## Errores frecuentes del alumno

- Diagnosticar el Ingress cuando el PVC esta `Pending`.
- Escribir el fichero en una ruta que no es el mount persistente.
- Tratar `microk8s-hostpath` como si fuera un disco cloud.
- Creer que dos replicas mas PVC ya significan alta disponibilidad.
- Confundir `ReadWriteOnce` con una garantia de consistencia de aplicacion.
- Borrar el PVC como limpieza sin explicar que puede afectar a los datos.

## Criterios de evaluacion

El alumno deberia poder:

- explicar el recorrido Pod -> volumeMount -> PVC -> PV -> StorageClass;
- identificar si un dato esta en configuracion, Secret o almacenamiento persistente;
- comprobar un PVC `Bound`;
- leer eventos cuando el volumen no se aprovisiona;
- validar persistencia tras recrear un Pod;
- explicar por que la copia temporal del laboratorio no es backup productivo;
- describir que cambiaria al migrar a AKS o EKS sin entrar todavia en implementacion cloud.

## Riesgos tecnicos

- `hostpath-storage` puede estar deshabilitado en MicroK8s.
- El comando `kubectl get storageclass` puede requerir ejecutarse fuera de un sandbox si el cliente instalado por snap no tiene capacidades suficientes.
- El volumen local esta ligado al nodo del laboratorio.
- Permisos de escritura pueden fallar si se elimina `fsGroup`.
- El Ingress puede tardar unos segundos en servir el fichero persistente tras un rollout.

## Limites de alcance

No introducir:

- StatefulSet como eje operativo;
- bases de datos reales;
- snapshots CSI;
- Velero o restic;
- Helm;
- Terraform;
- NetworkPolicies;
- cifrado productivo;
- storage cloud de AKS o EKS.

StatefulSet puede mencionarse como continuidad: identidad estable por replica y volumenes por replica seran relevantes cuando el workload lo requiera.

## Preguntas de comprobacion

- Que evidencia demuestra que el PVC esta listo?
- Que diferencia hay entre PV y PVC?
- Por que `hostpath-storage` no es portable?
- Que pasaria si se borra el PVC?
- Como demostrarias que el dato sobrevivio al Pod y no solo al proceso?
- Que parte de esta unidad seguira siendo valida en cloud y que parte cambiara?
