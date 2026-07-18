# Playbook de la Unidad 04 - Persistencia y estado

## Identificacion

### Unidad

```text
04 - Persistencia y estado
```

### Identificador

```text
04-persistence-state
```

### Fase del roadmap

```text
Fase 2 - Fundamentos Kubernetes
```

### Estado del playbook

```text
Aprobado
```

### Propietario logico

```text
Fundamentos Kubernetes
```

---

# Proposito de la unidad

La Unidad 04 introduce la persistencia en Kubernetes a partir de la solucion acumulada de `platform-api`, que ya dispone de configuracion externa, probes, resources, Service interno e Ingress HTTP local. Hasta la Unidad 03 la aplicacion puede recrear Pods sin conservar datos escritos en el filesystem del contenedor. Esta unidad debe explicar que ese comportamiento no es un fallo: es una consecuencia natural del modelo efimero de Pods.

La unidad aparece en este punto porque el alumno ya puede desplegar, configurar, exponer y diagnosticar una aplicacion. Ahora debe aprender a diferenciar entre estado efimero, configuracion, secretos de laboratorio y datos persistentes; a utilizar las abstracciones `Volume`, `PersistentVolume`, `PersistentVolumeClaim` y `StorageClass`; y a ejecutar procedimientos basicos de copia, recuperacion y diagnostico sin introducir todavia Helm, Terraform, CI/CD, observabilidad avanzada ni cloud.

## Supuesto pedagogico

La unidad debe escribirse para alumnos con perfil tecnico que todavia no dominan almacenamiento en Kubernetes.

Se explicaran desde cero:

- diferencia entre filesystem de contenedor, volumen efimero y volumen persistente;
- problema de perder datos cuando un Pod se recrea;
- responsabilidad de `Volume`, `PersistentVolume`, `PersistentVolumeClaim` y `StorageClass`;
- diferencia entre aprovisionamiento dinamico y volumen preexistente;
- modos de acceso, capacidad solicitada y ciclo de vida de un volumen;
- relacion entre persistencia, replicas, scheduling y disponibilidad;
- impacto de usar almacenamiento local de MicroK8s frente a almacenamiento gestionado cloud;
- copia, restauracion y verificacion basica de datos de laboratorio.

Se retomaran de unidades anteriores:

- `platform-api` como aplicacion evolutiva;
- namespace `platform-training`;
- Deployment, Pods, labels, selectors, ConfigMap, Secret ficticio, probes y resources;
- Service `ClusterIP`, EndpointSlice e Ingress HTTP local;
- diagnostico con `kubectl get`, `describe`, `logs`, `exec`, eventos y rollout;
- separacion entre tutorial formativo, `student-notes.md` y README operativo de laboratorio.

Se mencionaran y diferiran:

- StatefulSets como herramienta para identidad estable cuando la solucion lo requiera;
- snapshots de volumen y backups productivos;
- storage gestionado de AKS y EKS;
- bases de datos reales, operadores de base de datos y replicacion;
- cifrado, rotacion de claves, politicas avanzadas y restauracion ante desastre;
- scheduling avanzado, anti-affinity, PodDisruptionBudgets y mantenimiento de nodos.

Errores de razonamiento que deben prevenirse:

- creer que un PVC es el dato, cuando realmente es una solicitud de almacenamiento;
- confundir ConfigMap o Secret con persistencia de datos de aplicacion;
- asumir que reiniciar un Pod conserva cambios escritos dentro del contenedor;
- asumir que una StorageClass local se comporta igual que un disco gestionado cloud;
- ignorar que almacenamiento y replicas introducen restricciones de acceso y scheduling;
- presentar `hostPath` o almacenamiento local como patron productivo general;
- declarar que hay backup porque existe un volumen, sin probar copia y recuperacion.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- explicar que datos se pierden y que datos sobreviven cuando se recrea un Pod;
- comparar `emptyDir`, volumen de ConfigMap/Secret y volumen persistente;
- inspeccionar las `StorageClass` disponibles en el cluster local;
- crear y aplicar un `PersistentVolumeClaim` para la aplicacion evolutiva;
- montar un volumen persistente en `platform-api` sin cambiar el namespace funcional ni el Service;
- validar que el dato de laboratorio sobrevive a la recreacion de Pods;
- diagnosticar un PVC pendiente, un volumen no montado o permisos de escritura incorrectos;
- ejecutar una copia y restauracion basica de datos de laboratorio;
- explicar las limitaciones de `hostpath-storage` de MicroK8s frente a almacenamiento cloud;
- registrar en `summary.md` el estado que reutilizara la Unidad 05.

---

# Alcance

## Incluido

- reutilizacion de `platform-api`, `platform-training` y `labs/03-networking-ingress/solution/`;
- laboratorio de Unidad 04 en `labs/04-persistence-state/`;
- tutorial, `student-notes.md`, notas del instructor y summary de continuidad;
- explicacion de filesystem efimero de contenedor y ciclo de vida de Pods;
- uso de volumen efimero solo como contraste conceptual u observacion acotada;
- introduccion de `PersistentVolume`, `PersistentVolumeClaim` y `StorageClass`;
- uso de una `StorageClass` local de MicroK8s cuando este disponible o pueda habilitarse;
- evolucion controlada de los manifiestos acumulados para montar persistencia en `platform-api`;
- procedimiento basico para escribir, verificar, copiar, borrar y restaurar datos de laboratorio;
- diagnostico de PVC, PV, eventos, mounts y permisos;
- comparacion explicita entre Kubernetes estandar, MicroK8s local y almacenamiento cloud futuro;
- validacion no destructiva del estado esperado;
- actualizacion de `project/project-state.md` al generar y cerrar la unidad, no durante la creacion de este playbook.

## Excluido

- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automatico;
- NetworkPolicies, service mesh, mTLS o seguridad avanzada de red;
- bases de datos reales, operadores, clusters de base de datos o replicacion;
- snapshots CSI productivos, Velero, restic u otras soluciones de backup avanzadas;
- cifrado productivo de volumenes, KMS, rotacion de claves o politicas corporativas;
- AKS, EKS, discos cloud, identidades cloud o clases de almacenamiento gestionadas;
- sustitucion de `platform-api` por otra aplicacion;
- cambio de namespace funcional;
- introduccion de Minikube, kind o Docker Desktop Kubernetes;
- uso de credenciales reales o datos sensibles en el volumen de laboratorio.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Scheduling, resiliencia y mantenimiento avanzado | Unidad 05 | La persistencia debe quedar comprendida antes de tratar colocacion, interrupciones y mantenimiento |
| Helm | Unidad 06 | Requiere manifiestos acumulados y estables |
| Terraform | Unidad 07 | Requiere decidir limites entre recursos Kubernetes y provision de infraestructura |
| Tekton | Unidad 08 | Requiere artefactos versionados y validaciones consolidadas |
| Argo CD | Unidad 09 | Requiere layout declarativo estable |
| Backups productivos y snapshots CSI | Unidad posterior de operacion o cloud | Dependen del proveedor de almacenamiento y de objetivos RPO/RTO |
| Storage cloud gestionado | Unidades 20-21 | Depende de AKS/EKS, identidad y clases de almacenamiento gestionadas |
| Seguridad avanzada de datos | Unidades 16-17 y cloud | Requiere baseline funcional antes de cifrado, politicas y gobierno |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `project/project-planning.md`;
6. `project/how-to.md`;
7. `playbooks/unit-template.md`;
8. `playbooks/summary-template.md`;
9. `playbooks/project-state-template.md`;
10. `tutorial/03-networking-ingress/README.md`;
11. `tutorial/03-networking-ingress/student-notes.md`;
12. `tutorial/03-networking-ingress/summary.md`;
13. este playbook;
14. `labs/03-networking-ingress/README.md`;
15. `labs/03-networking-ingress/solution/namespace.yaml`;
16. `labs/03-networking-ingress/solution/configmap.yaml`;
17. `labs/03-networking-ingress/solution/secret.yaml`;
18. `labs/03-networking-ingress/solution/deployment.yaml`;
19. `labs/03-networking-ingress/solution/service.yaml`;
20. `labs/03-networking-ingress/solution/ingress.yaml`;
21. `labs/03-networking-ingress/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 03 esta cerrada, validada tecnicamente, aprobada por el usuario y existe `tutorial/03-networking-ingress/summary.md`.

---

# Dependencias

## Dependencias documentales

Deben existir y estar revisados:

```text
README.md
project/architecture.md
project/project-state.md
project/roadmap.md
project/project-planning.md
project/how-to.md
playbooks/master.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
playbooks/units/04-persistence-state.md
tutorial/03-networking-ingress/summary.md
tutorial/03-networking-ingress/student-notes.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| Ubuntu WSL objetivo | Validado como Ubuntu 24.04 LTS | `cat /etc/os-release` o validacion heredada |
| MicroK8s | Instalado y operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| Addon DNS | Habilitado | `microk8s status --wait-ready` y prueba DNS interna heredada |
| Addon Ingress de MicroK8s | Activo si se quiere validar acceso HTTP heredado | `kubectl get pods -n ingress` o validacion de Unidad 03 |
| StorageClass local | Disponible o habilitable para el laboratorio | `kubectl get storageclass` y `microk8s status --wait-ready` |
| Namespace `platform-training` | Existente o aplicable desde manifiesto | `kubectl get namespace platform-training` |
| Deployment `platform-api` | Definido y desplegable desde Unidad 03 | `kubectl -n platform-training rollout status deployment/platform-api` |
| Service `platform-api` | `ClusterIP` interno con endpoints | `kubectl -n platform-training get service platform-api` y EndpointSlice |
| Ingress `platform-api` | Recurso HTTP local heredado | `kubectl -n platform-training get ingress platform-api` |
| Helm | Instalado, pero no usado para desplegar la unidad | `helm version --short` |
| Terraform | Instalado, pero no usado para gestionar recursos | `terraform version` |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00 y validacion del entorno local;
- Unidad 01 y despliegue inicial de `platform-api`;
- Unidad 02 y separacion entre configuracion, secretos ficticios, probes y resources;
- Unidad 03 y relacion entre Deployment, Service, EndpointSlice e Ingress;
- lectura basica de YAML;
- uso basico de `kubectl apply`, `get`, `describe`, `logs`, `exec`, `rollout status` y `delete` con alcance controlado.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/03-networking-ingress/summary.md
tutorial/03-networking-ingress/student-notes.md
labs/03-networking-ingress/README.md
labs/03-networking-ingress/solution/namespace.yaml
labs/03-networking-ingress/solution/configmap.yaml
labs/03-networking-ingress/solution/secret.yaml
labs/03-networking-ingress/solution/deployment.yaml
labs/03-networking-ingress/solution/service.yaml
labs/03-networking-ingress/solution/ingress.yaml
labs/03-networking-ingress/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` desplegada sobre MicroK8s en el namespace `platform-training`, con configuracion externa, Secret ficticio, probes, resources, Service interno e Ingress HTTP local.

Estado verificable esperado:

- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` disponibles segun estado heredado;
- `kubectl` `v1.35.6` configurado como cliente principal;
- addon `dns` de MicroK8s habilitado;
- Ingress Controller local de MicroK8s activo si se ejecuta la validacion completa de Unidad 03;
- Helm y Terraform instalados como CLI heredadas, sin gestionar recursos del curso;
- namespace `platform-training` definido en `labs/03-networking-ingress/solution/namespace.yaml`;
- Deployment `platform-api` definido con dos replicas, imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`, ConfigMap, Secret de laboratorio, probes y resources;
- Service `platform-api` de tipo `ClusterIP`;
- Ingress `platform-api` para host `platform-api.local`;
- no existen PV, PVC, StorageClass gestionada por el curso, StatefulSet, snapshots, backups productivos, charts Helm, modulos Terraform, pipelines ni recursos cloud.

No debe asumirse que el laboratorio esta desplegado en el cluster si no se ejecuta validacion real o el usuario aporta evidencia.

## Validacion del estado inicial

Ejecutar desde Ubuntu WSL objetivo cuando se vaya a generar o validar funcionalmente la unidad:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/03-networking-ingress/validation/validate.sh
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress
kubectl get storageclass
microk8s status --wait-ready
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
deployment/platform-api esta disponible.
service/platform-api existe como ClusterIP y selecciona Pods Ready.
ingress/platform-api existe y conserva host platform-api.local.
No existen PVC de la aplicacion creados por unidades anteriores.
Existe una StorageClass local disponible o se documenta que debe habilitarse en MicroK8s.
```

Si la Unidad 03 no esta aplicada, la unidad puede documentar la recuperacion aplicando `labs/03-networking-ingress/solution/`, sin declarar validacion funcional hasta ejecutarla.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Continuidad tecnica, decisiones y limitaciones |
| Student notes Unidad 03 | `tutorial/03-networking-ingress/student-notes.md` | Continuidad pedagogica sobre ruta HTTP y diagnostico |
| Namespace base | `labs/03-networking-ingress/solution/namespace.yaml` | Mantener `platform-training` como namespace funcional |
| ConfigMap base | `labs/03-networking-ingress/solution/configmap.yaml` | Conservar configuracion no sensible y contenido HTML base |
| Secret de laboratorio | `labs/03-networking-ingress/solution/secret.yaml` | Conservar valores ficticios sin imprimirlos |
| Deployment evolucionado | `labs/03-networking-ingress/solution/deployment.yaml` | Base de `platform-api` para incorporar volumen persistente |
| Service interno | `labs/03-networking-ingress/solution/service.yaml` | Mantener contrato interno y backend del Ingress |
| Ingress local | `labs/03-networking-ingress/solution/ingress.yaml` | Mantener acceso HTTP local a la aplicacion |
| Validacion Unidad 03 | `labs/03-networking-ingress/validation/validate.sh` | Precondicion funcional |
| Labels base | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` | Selectors, continuidad operativa y diagnostico |
| Estado del proyecto | `project/project-state.md` | Registro de hechos generados y validados cuando se genere la unidad |

## Reglas de reutilizacion

- mantener `platform-api` como aplicacion evolutiva;
- mantener `platform-training` como namespace funcional;
- conservar `service/platform-api` como `ClusterIP`;
- conservar `ingress/platform-api` como punto de entrada HTTP local salvo defecto real y documentado;
- no cambiar selectors del Service salvo defecto real y documentado;
- no sustituir la imagen de `platform-api` salvo decision explicita y justificada;
- no exponer ni decodificar valores del Secret de laboratorio;
- crear artefactos de Unidad 04 en una ruta propia y declarar que extienden la solucion de Unidad 03;
- no usar Helm ni Terraform para aplicar los recursos;
- aislar cualquier paso especifico de MicroK8s, especialmente la habilitacion de almacenamiento local.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Responsabilidad | Ubicacion prevista |
|---|---|---|
| Tutorial de la Unidad 04 | Guiar conceptos de persistencia, estado y recuperacion basica | `tutorial/04-persistence-state/README.md` |
| Student notes | Material pedagogico profundo sobre almacenamiento en Kubernetes | `tutorial/04-persistence-state/student-notes.md` |
| Notas del instructor | Facilitar imparticion, demostraciones y evaluacion | `tutorial/04-persistence-state/instructor-notes.md` |
| Summary | Registrar continuidad tecnica y pedagogica | `tutorial/04-persistence-state/summary.md` |
| Laboratorio | Contener instrucciones y artefactos declarativos | `labs/04-persistence-state/README.md` |
| PVC de laboratorio | Solicitar almacenamiento persistente para `platform-api` | `labs/04-persistence-state/solution/pvc.yaml` |
| Manifiestos heredados versionados para Unidad 04 | Nueva base acumulativa con persistencia | `labs/04-persistence-state/solution/` |
| Validacion del laboratorio | Comprobacion no destructiva del estado esperado | `labs/04-persistence-state/validation/validate.sh` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar existencia, generacion y cierre de Unidad 04 segun corresponda | Mantiene estado real como fuente de verdad |
| Deployment `platform-api` | Montar un PVC en una ruta de datos de laboratorio | Debe conservar nombre, labels, probes, resources y variables heredadas |
| ConfigMap `platform-api-config` | Puede ajustar texto visible para reflejar Unidad 04 | Debe seguir siendo configuracion no sensible |
| Service `platform-api` | Debe conservarse como `ClusterIP` | Mantiene backend del Ingress |
| Ingress `platform-api` | Debe conservar host y backend salvo defecto documentado | Mantiene acceso HTTP local |
| StorageClass local de MicroK8s | Puede habilitarse o seleccionarse durante el laboratorio si no existe | Cambio especifico de plataforma local y documentado como no portable |

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseno de la unidad

## D-04-01 - Persistencia como evolucion de `platform-api`

### Decision

La unidad incorporara persistencia extendiendo `platform-api`, sin sustituir la aplicacion evolutiva ni crear una aplicacion independiente.

### Motivo

El itinerario debe mostrar como una misma solucion acumula capacidades. Crear otra aplicacion ocultaria el impacto real de introducir estado en un workload que ya tiene configuracion, red, probes, resources e ingreso.

### Consecuencias

- el alumno comparara el estado efimero anterior con el estado persistente nuevo;
- `Service` e `Ingress` deben seguir funcionando despues del cambio;
- cualquier ajuste de replicas o mounts debe registrarse como trade-off de persistencia.

### Alternativas descartadas

- Crear una aplicacion de base de datos independiente: anticipa decisiones de datos fuera de alcance.
- Sustituir `platform-api`: rompe continuidad del laboratorio.

## D-04-02 - PVC como interfaz principal del alumno

### Decision

El laboratorio usara un `PersistentVolumeClaim` como interfaz principal para solicitar almacenamiento persistente. `PersistentVolume` y `StorageClass` se explicaran como parte del modelo, pero el alumno no debera gestionar manualmente un PV estatico salvo que sea necesario por una limitacion real del entorno.

### Motivo

En Kubernetes moderno, el consumidor de almacenamiento normalmente declara una solicitud y delega el aprovisionamiento en una clase de almacenamiento. Esto permite explicar la separacion entre necesidad de aplicacion e implementacion de plataforma.

### Consecuencias

- el tutorial debe explicar que el PVC no es el disco, sino la solicitud;
- la validacion debe comprobar `Bound`, volumen asociado y montaje real;
- la StorageClass debe tratarse como contrato de plataforma, no como detalle invisible.

### Alternativas descartadas

- Usar solo `emptyDir`: no demuestra persistencia tras recrear Pods.
- Usar `hostPath` directo en el Pod: acopla el workload al nodo y normaliza un patron poco portable.
- Crear PV estatico como camino principal: adelanta administracion de plataforma y reduce el foco en consumo de almacenamiento.

## D-04-03 - Almacenamiento local de MicroK8s aislado como detalle de plataforma

### Decision

Cuando el entorno local lo requiera, la unidad usara la StorageClass proporcionada por el addon de almacenamiento local de MicroK8s. Cualquier nombre concreto de addon o clase debe validarse en el entorno antes de documentarse como evidencia.

### Motivo

La unidad necesita un proveedor local para practicar PV/PVC sin cloud. MicroK8s ofrece almacenamiento local suficiente para laboratorio, pero no debe presentarse como equivalente productivo a almacenamiento gestionado.

### Consecuencias

- el tutorial debe separar API Kubernetes estandar de implementacion MicroK8s;
- el summary debe registrar la StorageClass realmente usada y sus limitaciones;
- el alumno debe entender que migrar a AKS/EKS requerira clases y politicas distintas.

### Alternativas descartadas

- Usar discos cloud: anticipa AKS/EKS.
- Instalar un sistema de almacenamiento externo: aumenta complejidad y operacion fuera de la unidad.
- Omitir proveedor de almacenamiento y generar solo YAML: impide validacion funcional real.

## D-04-04 - Recuperacion basica, no backup productivo

### Decision

La unidad incluira copia y restauracion basica de datos de laboratorio mediante procedimientos transparentes y verificables, sin introducir herramientas de backup productivo.

### Motivo

El alumno debe comprobar que persistencia no equivale automaticamente a recuperacion. A la vez, soluciones como snapshots CSI, Velero o politicas RPO/RTO requieren una unidad posterior.

### Consecuencias

- el laboratorio debe distinguir entre volumen existente, copia externa y restauracion comprobada;
- no se deben versionar datos sensibles ni backups reales;
- cualquier archivo de backup generado debe ubicarse fuera de artefactos versionados o documentarse como temporal.

### Alternativas descartadas

- Introducir snapshots CSI: depende del proveedor de almacenamiento.
- Introducir Velero/restic: anticipa operacion avanzada.
- Declarar backup solo por tener PVC: confunde persistencia con recuperacion.

## D-04-05 - StatefulSet solo si el laboratorio lo justifica

### Decision

La unidad mencionara StatefulSet como abstraccion para identidad estable y almacenamiento por replica, pero no debe convertirlo en eje operativo salvo que el diseno final demuestre que `platform-api` lo requiere.

### Motivo

El roadmap permite StatefulSets cuando la solucion lo requiera. Para una aplicacion HTTP simple, introducir StatefulSet demasiado pronto puede mezclar persistencia de volumen con identidad estable, ordinales y gobierno de replicas.

### Consecuencias

- el material pedagogico debe explicar por que no todo workload con PVC necesita StatefulSet;
- si se mantiene Deployment, deben documentarse sus limites con replicas y almacenamiento;
- si se adopta StatefulSet, debe registrarse la decision, migracion, impacto y compatibilidad con Service e Ingress.

### Alternativas descartadas

- Migrar siempre a StatefulSet: sobredimensiona el problema inicial.
- No mencionar StatefulSet: deja sin marco conceptual una abstraccion prevista por el roadmap.

## D-04-06 - Laboratorio acumulativo con ruta propia

### Decision

La Unidad 04 tendra su propio directorio `labs/04-persistence-state/` con la solucion evolucionada, reutilizando semanticamente los manifiestos de Unidad 03.

### Motivo

Mantiene trazabilidad por unidad sin modificar retroactivamente el estado final de la Unidad 03.

### Consecuencias

- `labs/03-networking-ingress/solution/` queda como evidencia de salida de Unidad 03;
- `labs/04-persistence-state/solution/` sera la nueva base para Unidad 05;
- el summary debera indicar claramente que Unidad 05 reutiliza la solucion de Unidad 04.

### Alternativas descartadas

- Editar solo `labs/03-networking-ingress/solution/`: dificulta auditar la evolucion entre unidades.
- Crear manifests sin relacion con la solucion previa: rompe continuidad.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/04-persistence-state/README.md
```

Debe actuar como puerta de entrada de la unidad. Debe incluir:

1. problema real que resuelve la unidad: datos que deben sobrevivir a recreacion de Pods;
2. por que aparece despues de networking e ingreso;
3. contexto;
4. objetivos;
5. conocimientos previos;
6. relacion con la Unidad 03;
7. estado inicial;
8. mapa de aprendizaje;
9. modelo mental de estado: contenedor efimero, volumen, PVC, PV, StorageClass y proveedor;
10. conceptos explicados con profundidad progresiva;
11. como usar `student-notes.md`;
12. como usar el README del laboratorio;
13. decisiones de diseno y trade-offs;
14. validaciones conceptuales y tecnicas;
15. errores de razonamiento frecuentes;
16. resolucion de problemas de almacenamiento;
17. recuperacion y limpieza;
18. conclusion;
19. lectura guiada con referencias oficiales, conceptuales y complementarias;
20. conexion con la Unidad 05.

Las referencias deberan priorizar documentacion oficial de Kubernetes sobre Volumes, Persistent Volumes, PersistentVolumeClaims, StorageClasses, access modes y storage concepts. Cualquier material secundario debera complementar esas fuentes, no sustituirlas.

El tutorial no debe escribirse como una guia de laboratorio extendida. Los comandos repetitivos, secuencias completas de despliegue, recuperacion operacional y validacion mecanica pertenecen al README del laboratorio, salvo comandos puntuales que ayuden a observar o razonar sobre un concepto.

## Notas del alumno

Ruta:

```text
tutorial/04-persistence-state/student-notes.md
```

Debe ser el material pedagogico profundo de la unidad. Debe construir comprension antes de pedir ejecucion. Debe incluir:

- modelo mental de datos efimeros y persistentes;
- glosario razonado de `Volume`, `emptyDir`, `PersistentVolume`, `PersistentVolumeClaim`, `StorageClass`, access modes, reclaim policy y mount;
- diferencia entre configuracion, secreto y dato persistente;
- relacion entre PVC y Pod;
- relacion entre StorageClass y proveedor de almacenamiento;
- particularidades de replicas y volumenes;
- lectura guiada de los manifiestos de Unidad 04;
- errores de razonamiento frecuentes;
- preguntas de comprobacion;
- limites de alcance y continuidad.

No debe duplicar el README del laboratorio. Puede incluir comandos puntuales de observacion, pero no secuencias operativas completas.

## Notas del instructor

Ruta:

```text
tutorial/04-persistence-state/instructor-notes.md
```

Debe incluir:

- intencion pedagogica;
- puntos de enfasis;
- demostraciones recomendadas;
- errores frecuentes;
- errores de razonamiento;
- preguntas de comprobacion;
- criterios de evaluacion;
- riesgos tecnicos;
- limites de alcance para no anticipar Helm, Terraform, StatefulSets complejos, backups productivos, seguridad avanzada ni cloud.

## Resumen

Ruta:

```text
tutorial/04-persistence-state/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Laboratorio

Ruta normal:

```text
labs/04-persistence-state/
```

## Estado del proyecto

Actualizar durante la generacion y cierre de la unidad:

```text
project/project-state.md
```

siguiendo:

```text
playbooks/project-state-template.md
```

---

# Estructura prevista del laboratorio

```text
labs/04-persistence-state/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/04-persistence-state/README.md` | Referencia operativa del laboratorio |
| `labs/04-persistence-state/starter/` | Punto de partida guiado con persistencia incompleta o parametros por completar |
| `labs/04-persistence-state/solution/` | Estado final reutilizable por Unidad 05 |
| `labs/04-persistence-state/solution/pvc.yaml` | Solicitud declarativa de almacenamiento persistente |
| `labs/04-persistence-state/solution/deployment.yaml` | Workload `platform-api` evolucionado con montaje persistente |
| `labs/04-persistence-state/solution/service.yaml` | Service interno conservado |
| `labs/04-persistence-state/solution/ingress.yaml` | Ingress local conservado |
| `labs/04-persistence-state/validation/validate.sh` | Validacion no destructiva de recursos esperados |

---

# Flujo pedagogico obligatorio

La unidad debera seguir este orden conceptual:

1. recuperar el estado final de Unidad 03;
2. demostrar o explicar que el filesystem del contenedor es efimero;
3. diferenciar configuracion, secretos ficticios y datos persistentes;
4. construir el modelo de almacenamiento: Pod, volume, PVC, PV, StorageClass y proveedor;
5. observar las StorageClasses disponibles en el cluster local;
6. explicar la diferencia entre API estandar y almacenamiento local de MicroK8s;
7. crear un PVC para `platform-api`;
8. montar el PVC en una ruta de datos de laboratorio;
9. escribir un dato de prueba y verificarlo desde la aplicacion o desde el Pod;
10. recrear Pods y validar que el dato persiste;
11. ejecutar copia y restauracion basica de datos de laboratorio;
12. diagnosticar al menos un fallo realista de almacenamiento;
13. consolidar limites, portabilidad y estado que reutilizara la Unidad 05.

Este orden es necesario porque el alumno debe entender primero que problema resuelve la persistencia. Saltar directamente a `pvc.yaml` convierte el laboratorio en una receta y oculta la relacion entre solicitud de almacenamiento, provisionador, Pod, montaje, datos y recuperacion.

---

# Procedimientos obligatorios

## Preparacion

- validar entorno heredado;
- validar que `platform-api` de Unidad 03 esta disponible o reaplicar `labs/03-networking-ingress/solution/`;
- confirmar contexto actual de `kubectl`;
- revisar recursos existentes en `platform-training`;
- verificar estado de DNS e Ingress heredados;
- inspeccionar `StorageClass` disponibles;
- documentar como habilitar almacenamiento local de MicroK8s si no existe StorageClass util;
- confirmar que no existen PVC previos de `platform-api` creados por unidades anteriores.

## Implementacion

- copiar o evolucionar los manifiestos de Unidad 03 hacia `labs/04-persistence-state/solution/`;
- mantener `platform-api`, `platform-training`, labels principales, Service `ClusterIP` e Ingress local;
- crear manifiesto `pvc.yaml` con nombre, capacidad, access mode y StorageClass documentados;
- montar el PVC en `platform-api` en una ruta de datos de laboratorio;
- documentar cualquier ajuste de replicas si el modo de acceso o el proveedor local lo requieren;
- aplicar manifiestos en orden explicito;
- crear un dato de laboratorio no sensible;
- documentar comandos exactos y resultados esperados.

## Validacion

- comprobar Deployment disponible;
- comprobar Service `ClusterIP`;
- comprobar Ingress heredado;
- comprobar StorageClass;
- comprobar PVC en estado `Bound`;
- comprobar PV asociado cuando exista;
- comprobar montaje dentro del Pod;
- comprobar escritura y lectura de un dato de laboratorio;
- recrear Pods o forzar rollout controlado y comprobar que el dato persiste;
- comprobar acceso HTTP si la ruta persistente se expone como contenido de laboratorio;
- ejecutar script de validacion de Unidad 04.

## Diagnostico

- identificar PVC en estado `Pending`;
- revisar eventos de PVC, Pod y scheduler;
- distinguir falta de StorageClass de falta de capacidad o provisionador;
- identificar Pod bloqueado por volumen no montado;
- diagnosticar permisos de escritura en el punto de montaje;
- distinguir dato perdido por escribir fuera del volumen de fallo real de persistencia;
- revisar impacto de replicas con volumen local o access mode restrictivo.

## Recuperacion

- reaplicar manifiestos declarativos de Unidad 04;
- reaplicar manifiestos de Unidad 03 si falta la base;
- corregir StorageClass o PVC segun eventos;
- recrear Pods de forma controlada;
- restaurar datos de laboratorio desde copia temporal documentada;
- volver a ejecutar la validacion.

## Limpieza

- documentar limpieza de datos de prueba como operacion reversible si existe copia;
- documentar eliminacion del PVC como operacion destructiva para datos persistentes;
- advertir que eliminar `platform-training` borra aplicacion, PVC y datos asociados;
- no destruir MicroK8s ni ejecutar resets de Unidad 00;
- no deshabilitar almacenamiento local de MicroK8s salvo procedimiento explicito, consciente de que puede afectar a otros recursos locales.

---

# Validaciones obligatorias

## Validaciones estaticas

| Validacion | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/04-persistence-state/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | Revision de manifiestos y busqueda de patrones sensibles | Sin tokens, passwords reales, claves privadas, kubeconfigs ni datos sensibles |
| Sintaxis Bash de validacion | `bash -n labs/04-persistence-state/validation/validate.sh` | Codigo de salida 0 |
| Ausencia de Helm charts | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

## Validaciones funcionales

| Validacion | Procedimiento | Resultado esperado |
|---|---|---|
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |
| Estado Unidad 03 | `bash labs/03-networking-ingress/validation/validate.sh` | Sin fallos antes de evolucionar la solucion |
| StorageClass disponible | `kubectl get storageclass` | Al menos una clase util para el laboratorio |
| Aplicacion de manifiestos | `kubectl apply -f labs/04-persistence-state/solution/` | Recursos aplicados sin errores |
| Deployment disponible | `kubectl -n platform-training rollout status deployment/platform-api` | Rollout completado |
| PVC enlazado | `kubectl -n platform-training get pvc` | PVC de `platform-api` en estado `Bound` |
| PV asociado | `kubectl get pv` | PV enlazado al claim de laboratorio cuando aplique |
| Montaje del volumen | `kubectl -n platform-training exec` o mecanismo equivalente | Ruta persistente visible dentro del contenedor |
| Escritura de dato | Procedimiento documentado de escritura no sensible | Dato creado en la ruta persistente |
| Persistencia tras recreacion | Eliminar Pod o reiniciar rollout de forma controlada | Dato sigue disponible tras nuevo Pod Ready |
| Service interno | `kubectl -n platform-training get service platform-api` | `TYPE` igual a `ClusterIP` |
| Ingress heredado | `kubectl -n platform-training get ingress platform-api` | Host y backend esperados |
| HTTP por Ingress | `curl` contra el punto de entrada local con host esperado | Respuesta de `platform-api` coherente con Unidad 04 |
| Copia y restauracion | Procedimiento documentado con dato de laboratorio | Dato restaurado y verificado |
| Validacion del laboratorio | `bash labs/04-persistence-state/validation/validate.sh` | Sin fallos |

## Validaciones de continuidad

Comprobar que:

- `labs/03-networking-ingress/solution/` permanece como evidencia de Unidad 03;
- `labs/04-persistence-state/solution/` contiene el estado que reutilizara Unidad 05;
- `platform-api` conserva nombre, namespace, selector, ConfigMap, Secret de laboratorio, probes y resources salvo ajuste documentado;
- el Service conserva tipo `ClusterIP`;
- el Ingress conserva backend hacia el Service existente;
- el PVC y montaje estan registrados en los manifiestos de Unidad 04;
- Helm y Terraform siguen sin gestionar recursos del curso;
- no existen credenciales reales ni datos sensibles versionados;
- `tutorial/04-persistence-state/summary.md` registra StorageClass, PVC, validaciones, recuperacion y limitaciones;
- `project/project-state.md` refleja solo recursos realmente creados y validados.

## Validaciones no ejecutables en el entorno de generacion

Declarar como pendientes cualquier validacion funcional que no se ejecute realmente en MicroK8s.

No afirmar que StorageClass, PVC, PV, montaje, persistencia, backup, restauracion o HTTP funcionan si solo se revisaron los archivos.

---

# Escenarios de error obligatorios

| Escenario | Sintoma | Diagnostico | Recuperacion |
|---|---|---|---|
| No existe StorageClass util | PVC queda `Pending` | `kubectl get storageclass`, `kubectl describe pvc`, eventos | Habilitar o seleccionar StorageClass local documentada |
| StorageClass incorrecta | PVC queda `Pending` o no se aprovisiona PV | `kubectl describe pvc` | Corregir `storageClassName` y recrear el claim si procede |
| PVC no enlazado | Pod no arranca o volumen no monta | `kubectl get pvc,pv`, eventos | Resolver causa del claim antes de diagnosticar aplicacion |
| Pod bloqueado por volumen | Pod queda `Pending` o `ContainerCreating` | `kubectl describe pod` | Revisar eventos de attach/mount y proveedor |
| Permisos de escritura | Comando de escritura falla con permiso denegado | `kubectl exec`, logs y seguridad del contenedor | Ajustar ruta de montaje o permisos sin elevar privilegios innecesarios |
| Dato escrito fuera del volumen | Dato desaparece tras recrear Pod | Comparar ruta escrita con `volumeMounts` | Repetir prueba usando la ruta persistente documentada |
| Replica adicional no puede usar el volumen | Pods quedan pendientes o comportamiento inconsistente | Eventos, access modes y nodos | Ajustar replicas o diseno, registrar trade-off |
| Eliminacion accidental del PVC | Dato persistente desaparece o queda inaccesible | `kubectl get pvc,pv`, eventos | Restaurar desde copia de laboratorio si existe |
| Ingress deja de responder tras cambio | HTTP falla aunque PVC este correcto | Validar Deployment, Service, EndpointSlice e Ingress | Reaplicar manifests, corregir selector o esperar rollout |
| Contexto `kubectl` equivocado | Recursos no aparecen o se aplican a otro cluster | `kubectl config current-context` y `kubectl get nodes` | Cambiar contexto o reconfigurar desde Unidad 00 |

---

# Requisitos de seguridad

## Datos sensibles

La Unidad 04 no debe introducir credenciales reales ni datos reales de negocio.

Solo se permiten:

- datos de laboratorio no sensibles;
- placeholders no corporativos;
- valores ficticios ya heredados de Unidad 03;
- copias temporales con contenido inocuo;
- configuracion publica de ejemplo.

No versionar:

- tokens;
- passwords reales;
- claves privadas;
- kubeconfigs personales;
- certificados privados;
- credenciales de proxy;
- datos corporativos;
- dumps de bases de datos reales;
- backups reales;
- informacion personal.

## Privilegios

Documentar:

- que `kubectl` opera contra el cluster local;
- que habilitar addons de MicroK8s puede requerir permisos locales del usuario configurado en Unidad 00;
- que no se requieren credenciales cloud;
- que no deben usarse privilegios de administrador para introducir credenciales ni modificar recursos externos;
- que los permisos dentro del contenedor deben mantenerse minimos y coherentes con la imagen heredada.

## Operaciones destructivas

| Operacion | Advertencia | Alcance | Recuperacion | Confirmacion requerida |
|---|---|---|---|---|
| Borrar dato de prueba dentro del volumen | Elimina contenido de laboratorio | Ruta persistente de `platform-api` | Restaurar desde copia temporal si existe | No, si esta dentro de limpieza guiada |
| `kubectl delete pod` de `platform-api` | Recrea Pods gestionados por Deployment | Pods de la aplicacion | Deployment crea nuevos Pods | No, si esta dentro de validacion guiada |
| `kubectl delete pvc` de Unidad 04 | Puede eliminar o desconectar datos persistentes segun reclaim policy | PVC y datos asociados | Reaplicar PVC y restaurar copia si existe | Confirmacion explicita |
| `kubectl delete namespace platform-training` | Elimina aplicacion, configuracion, PVC y datos | Recursos funcionales del curso | Reaplicar `labs/04-persistence-state/solution/` y restaurar copia si existe | Confirmacion explicita |
| Deshabilitar almacenamiento local de MicroK8s | Puede afectar a otros volumenes locales | Componente compartido del cluster local | Rehabilitar addon y revisar PVC/PV | Confirmacion explicita |

No usar `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de Unidad 04.

---

# Requisitos de portabilidad

## Kubernetes estandar

- `Volume`;
- `PersistentVolume`;
- `PersistentVolumeClaim`;
- `StorageClass`;
- access modes;
- capacity requests;
- `volumeMounts`;
- eventos de PVC y Pod;
- `kubectl apply`, `get`, `describe`, `logs`, `exec`, `rollout status`;
- diagnostico por eventos y estado de recursos.

## Especifico de MicroK8s

- addon de almacenamiento local disponible en MicroK8s;
- posible StorageClass local basada en host path;
- datos persistentes ligados al nodo local y al filesystem del entorno;
- comportamiento condicionado por recursos disponibles en WSL2;
- no equivalencia con disponibilidad, rendimiento o durabilidad cloud.

## Especifico de AKS

No aplica en esta unidad. Mencionar solo de forma comparativa que en AKS las StorageClasses, discos, identidades, snapshots y politicas de almacenamiento se gestionan con decisiones propias de plataforma.

## Especifico de EKS

No aplica en esta unidad. Mencionar solo de forma comparativa que en EKS las StorageClasses, CSI drivers, discos, identidades, snapshots y politicas de almacenamiento se gestionan con decisiones propias de plataforma.

## Estrategia de desacoplamiento

- usar APIs Kubernetes estandar para PVC, volumes y mounts;
- aislar la habilitacion del proveedor local como paso especifico de MicroK8s;
- no usar rutas de host como contrato de aplicacion;
- no depender de un nombre de StorageClass sin validarlo;
- mantener nombres y labels preparados para Helm futuro;
- no introducir IPs, discos cloud ni rutas absolutas del host como contrato del curso;
- registrar en summary cualquier dependencia concreta del almacenamiento local.

---

# Restricciones de generacion

La IA no debe:

- generar contenido de Unidad 05 o posteriores;
- crear charts Helm;
- crear modulos Terraform;
- instalar o configurar Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- introducir NetworkPolicies, service mesh, mTLS, cert-manager, ACME o PKI corporativa;
- introducir bases de datos reales, operadores o replicacion;
- introducir snapshots CSI, Velero, restic u otras herramientas de backup productivo;
- cambiar el Service a `NodePort` o `LoadBalancer` salvo decision documentada y aprobada;
- sustituir `Ingress` por Gateway API;
- crear `GatewayClass`, `Gateway` o `HTTPRoute`;
- redefinir la plataforma local ni sustituir MicroK8s;
- introducir Minikube, kind o Docker Desktop Kubernetes como plataforma paralela;
- usar Secrets con valores reales;
- crear o versionar datos sensibles o backups reales;
- crear dependencias obligatorias de servicios cloud, DNS publico o herramientas corporativas;
- asumir que un recurso fue desplegado sin ejecutar validacion real o recibir evidencia del usuario;
- modificar scripts de Unidad 00 salvo correccion justificada;
- resolver otras deudas pedagogicas fuera de Unidad 04 salvo decision explicita.

La IA si puede, cuando el playbook sea aprobado y se genere la unidad:

- crear manifiestos Kubernetes declarativos que extiendan `platform-api`;
- crear un PVC y montarlo en `platform-api`;
- documentar y ejecutar habilitacion o seleccion de StorageClass local de MicroK8s cuando proceda;
- crear scripts de validacion del laboratorio;
- documentar comandos de diagnostico, copia, restauracion y recuperacion;
- registrar decisiones, limitaciones y evidencias en `summary.md` y `project/project-state.md`;
- usar `kubectl` contra MicroK8s validado.

---

# Criterios de aceptacion

El playbook se considerara listo para revision cuando:

- [ ] exista `playbooks/units/04-persistence-state.md`;
- [ ] defina proposito, alcance, exclusiones, dependencias y restricciones;
- [ ] conserve `platform-api`, `platform-training` y `labs/03-networking-ingress/solution/` como base;
- [ ] no genere tutorial, laboratorio, manifiestos ni capacidades tecnicas de Unidad 04;
- [ ] no contradiga `project/architecture.md`, `playbooks/master.md`, `project/project-state.md` ni `project/roadmap.md`;
- [ ] distinga Kubernetes estandar de MicroK8s;
- [ ] incluya `student-notes.md` como entregable obligatorio de la unidad;
- [ ] defina validaciones y escenarios de error verificables;
- [ ] declare que la generacion de la Unidad 04 requiere aprobacion posterior del playbook.

La unidad se considerara completada en una sesion posterior, no en esta, cuando:

- [ ] exista `tutorial/04-persistence-state/README.md`;
- [ ] exista `tutorial/04-persistence-state/student-notes.md`;
- [ ] exista `tutorial/04-persistence-state/instructor-notes.md`;
- [ ] exista `tutorial/04-persistence-state/summary.md`;
- [ ] exista `labs/04-persistence-state/README.md`;
- [ ] existan manifiestos en `labs/04-persistence-state/starter/`;
- [ ] existan manifiestos en `labs/04-persistence-state/solution/`;
- [ ] exista `labs/04-persistence-state/validation/validate.sh`;
- [ ] `platform-api` se mantenga como aplicacion evolutiva;
- [ ] `platform-training` se mantenga como namespace funcional;
- [ ] el Service conserve tipo `ClusterIP` y selectors compatibles con los Pods;
- [ ] el Ingress conserve acceso HTTP local hacia `service/platform-api`;
- [ ] exista un PVC montado en `platform-api`;
- [ ] se haya validado persistencia tras recreacion de Pods;
- [ ] se haya validado copia y restauracion basica de datos de laboratorio;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] las validaciones estaticas y funcionales posibles hayan sido ejecutadas;
- [ ] las validaciones no ejecutadas esten declaradas;
- [ ] no existan secretos reales, datos sensibles ni backups reales versionados;
- [ ] el tutorial incluya referencias oficiales o fuentes primarias relevantes;
- [ ] Helm y Terraform no gestionen todavia recursos del curso;
- [ ] `project/project-state.md` este actualizado;
- [ ] el resultado prepare la Unidad 05;
- [ ] no existan contradicciones abiertas.

---

# Estado final esperado de la Unidad 04

## Plataforma

- MicroK8s local sigue disponible y validado;
- `kubectl` sigue siendo el cliente principal;
- addon `dns` sigue habilitado;
- Ingress Controller local de MicroK8s sigue activo si venia de Unidad 03 o se valido acceso HTTP;
- StorageClass local disponible y registrada si se ejecuto la unidad funcionalmente;
- no se han introducido cambios estructurales en `platform/environment/`;
- Helm y Terraform siguen instalados pero no gestionan recursos del curso.

## Aplicacion

- `platform-api` sigue desplegada en `platform-training`;
- Deployment conserva ConfigMap, Secret ficticio, probes y resources heredados salvo ajuste documentado;
- `platform-api` monta un volumen persistente para datos de laboratorio;
- Service `platform-api` sigue siendo `ClusterIP`;
- Ingress HTTP local sigue permitiendo acceso controlado a `platform-api`;
- no se introduce una base de datos real ni una aplicacion alternativa.

## Automatizacion

- manifiestos Kubernetes declarativos disponibles en `labs/04-persistence-state/solution/`;
- script de validacion no destructiva disponible;
- no existen charts Helm;
- no existen modulos Terraform;
- no existen pipelines ni recursos GitOps.

## Observabilidad

- diagnostico mediante estado Kubernetes, eventos, logs, PVC, PV, StorageClass, mounts, EndpointSlice, estado del Ingress y pruebas HTTP;
- no existe stack de observabilidad avanzada.

## Seguridad

- Secret de laboratorio heredado conserva valores ficticios;
- datos persistentes de laboratorio no contienen informacion sensible;
- no se versionan backups reales, credenciales, claves privadas, kubeconfigs ni certificados;
- no se introducen politicas avanzadas de seguridad.

---

# Cierre de la unidad

Al cerrar la Unidad 04 en una sesion posterior:

1. actualizar `tutorial/04-persistence-state/summary.md`;
2. actualizar `project/project-state.md`;
3. registrar StorageClass utilizada, PVC, PV, montaje, validaciones y limitaciones;
4. registrar cualquier ajuste de replicas, permisos o rutas de montaje;
5. registrar validaciones ejecutadas y pendientes;
6. distinguir validacion tecnica de aprobacion pedagogica del usuario;
7. indicar que la Unidad 05 debe reutilizar `labs/04-persistence-state/solution/`;
8. revisar `git status` y `git diff`;
9. sugerir mensaje de commit.

---

# Siguiente incremento permitido tras aprobar este playbook

El usuario solicito generar la Unidad 04 el 2026-07-19. Con esa instruccion, el siguiente incremento permitido es:

```text
Generar la Unidad 04 - Persistencia y estado
```

Ese incremento debera crear tutorial, `student-notes.md`, notas del instructor, summary, laboratorio, manifiestos, validacion y actualizacion de estado, manteniendo `platform-api`, `platform-training` y la solucion de Unidad 03 como base.
