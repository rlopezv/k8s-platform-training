# Instructor notes - Unidad 05

## Intencion pedagogica

La unidad debe cambiar la conversacion desde "tengo dos replicas" hacia "que condiciones hacen que esas replicas aporten disponibilidad real".

El objetivo no es que el alumno memorice todos los campos de affinity, sino que pueda razonar por capas: scheduler, nodo, requests, volumen, probes, EndpointSlice, Service, Ingress, rollout y PDB.

## Puntos de enfasis

- Un Pod se ejecuta en un nodo concreto, no en una abstraccion sin restricciones.
- `nodeSelector` y affinity pueden bloquear un despliegue si el contrato de labels es falso.
- Anti-affinity obligatoria es peligrosa en un cluster de un nodo.
- Taints rechazan Pods; tolerations permiten aceptar ese rechazo, pero no atraen Pods por si solas.
- PDB protege interrupciones voluntarias, no fallos involuntarios.
- Readiness decide si un Pod entra en EndpointSlice.
- El PVC local de MicroK8s condiciona cualquier afirmacion sobre resiliencia multi-nodo.
- Rollout y rollback nativos deben comprenderse antes de Helm.

## Demostraciones recomendadas

1. Mostrar `kubectl get nodes --show-labels` y pedir al grupo que identifique labels estandar frente a labels de plataforma.
2. Aplicar la solucion de Unidad 05 y observar `kubectl -n platform-training get pods -o wide`.
3. Enseñar `strategy`, `nodeSelector`, affinity y PDB desde el manifiesto y desde la API.
4. Eliminar un Pod de `platform-api` y observar Deployment, ReplicaSet, Pods y EndpointSlice.
5. Anotar el Deployment para generar una revision inocua y revisar `rollout history`.
6. Hacer rollback y reaplicar la solucion versionada.
7. Mostrar, solo como fallo esperado, un selector imposible y leer eventos del scheduler. Revertir inmediatamente.

No ejecutar `kubectl drain` salvo entorno preparado, consentimiento explicito y tiempo para recuperar. No es necesario para cumplir la unidad.

## Errores frecuentes del alumno

- Buscar logs de Nginx cuando el Pod esta `Pending` y nunca arranco.
- Creer que `kubectl delete pod` es equivalente a una eviction gobernada por PDB.
- Interpretar `disruptionsAllowed` como garantia absoluta.
- Olvidar comprobar EndpointSlice durante rollout.
- Dejar un patch temporal aplicado y despues culpar al manifiesto versionado.
- Borrar el PVC para "limpiar" y perder el dato de laboratorio.

## Preguntas de comprobacion

- Que campo muestra el nodo asignado a un Pod?
- Por que un PDB no protege ante apagado del nodo?
- Que pasaria si la anti-affinity de `platform-api` fuera obligatoria en MicroK8s de un nodo?
- Que diferencia hay entre falta de recursos y mismatch de labels?
- Como sabes si el Service tiene backends listos?
- Que limita `maxUnavailable` durante el rollout?
- Por que la persistencia local no demuestra resiliencia cloud?

## Criterios de evaluacion

El alumno deberia poder:

- aplicar `labs/05-scheduling-resilience-maintenance/solution/`;
- explicar los cambios de `deployment.yaml` y `pdb.yaml`;
- diagnosticar un Pod `Pending` leyendo eventos;
- ejecutar una recreacion controlada de Pod y validar recuperacion;
- observar EndpointSlice durante disponibilidad;
- ejecutar rollout history y rollback;
- explicar por que no se automatiza `drain`;
- diferenciar limitaciones del laboratorio local frente a un cluster multi-nodo.

## Riesgos tecnicos de la sesion

- MicroK8s local puede tener un solo nodo: no prometer reparto real de replicas.
- `hostpath-storage` ata datos al nodo local.
- Si se patcha un selector imposible, hay que reaplicar la solucion antes de cerrar.
- Un rollback puede dejar anotaciones o revisiones que no coinciden con el manifiesto versionado; reaplicar solution al final.
- El script de validacion elimina un Pod de `platform-api`, pero no toca nodos ni PVC.
- `shellcheck` puede no estar instalado en el entorno.

## Limites de alcance

No introducir como parte de esta unidad:

- Helm o charts;
- Terraform;
- Tekton, Argo CD o GitOps;
- HPA, KEDA o autoscaling;
- Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- canary, blue/green o progressive delivery;
- NetworkPolicies, admission control o seguridad avanzada;
- AKS, EKS, node pools reales o mantenimiento cloud.

La continuidad natural es Unidad 06: empaquetar con Helm una solucion que ya tiene manifiestos de workload, red, persistencia, rollout y PDB.
