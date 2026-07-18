# Playbook de la Unidad 03 - Networking e ingreso

## Identificacion

### Unidad

```text
03 - Networking e ingreso
```

### Identificador

```text
03-networking-ingress
```

### Fase del roadmap

```text
Fase 2 - Fundamentos Kubernetes
```

### Estado del playbook

```text
Aprobado para iniciar la generacion de la Unidad 03
```

### Propietario logico

```text
Fundamentos Kubernetes
```

---

# Proposito de la unidad

La Unidad 03 evoluciona `platform-api` desde una aplicacion accesible solo dentro del cluster mediante un Service `ClusterIP` hacia una aplicacion expuesta de forma controlada por HTTP a traves de un punto de entrada estable del entorno local.

La unidad aparece despues de que la Unidad 02 haya dejado un workload configurable, con probes, resources y Service interno. Su responsabilidad es construir el modelo mental de red de Kubernetes: como los Pods reciben direcciones efimeras, como el Service da estabilidad interna, como DNS permite descubrir servicios, que papel cumple un Ingress Controller y que responsabilidad tiene un recurso `Ingress`. Gateway API debe aparecer como comparacion conceptual y camino futuro, sin sustituir todavia el laboratorio principal salvo decision explicita y validacion real del entorno.

## Supuesto pedagogico

La unidad debe escribirse para alumnos con perfil tecnico que todavia no dominan networking en Kubernetes.

Se explicaran desde cero:

- diferencia entre red de Pods, red de Services y entrada desde fuera del cluster;
- relacion entre `Pod`, `Service`, `EndpointSlice`, DNS interno, Ingress Controller e `Ingress`;
- diferencia entre definir una regla de entrada y tener un componente que la ejecute;
- enrutamiento HTTP por host y path;
- diagnostico basico de conectividad por capas.

Se retomaran de unidades anteriores:

- `platform-api` como aplicacion evolutiva;
- namespace `platform-training`;
- Deployment, Pods, labels, selectors, probes y Service `ClusterIP`;
- uso de `kubectl apply`, `get`, `describe`, `logs` y `port-forward`;
- EndpointSlice como evidencia preferente de Pods seleccionados por el Service.

Se mencionaran y diferiran:

- TLS gestionado de forma productiva;
- Gateway API aplicada como reemplazo de Ingress;
- LoadBalancer cloud, DNS publico, certificados publicos y balanceadores gestionados;
- NetworkPolicies y seguridad avanzada de red.

Errores de razonamiento que deben prevenirse:

- creer que un `Ingress` por si solo abre trafico si no existe Ingress Controller;
- confundir `Service` con `Ingress`;
- asumir que `ClusterIP` es una IP estable para usuarios externos;
- diagnosticar siempre desde fuera sin comprobar primero Pods, Service, EndpointSlice y DNS interno;
- tratar una configuracion local de `/etc/hosts` o `curl --resolve` como DNS productivo;
- presentar MicroK8s Ingress como comportamiento universal de todos los clusters.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- explicar el recorrido de una peticion HTTP desde el cliente local hasta un Pod de `platform-api`;
- validar que el Service interno conserva endpoints mediante EndpointSlice;
- comprobar resolucion DNS interna para `platform-api.platform-training.svc.cluster.local`;
- habilitar o verificar un Ingress Controller local en MicroK8s cuando el laboratorio lo requiera;
- crear un recurso `Ingress` que enrute trafico HTTP hacia el Service existente;
- probar acceso HTTP mediante host local controlado, sin introducir DNS publico;
- diagnosticar fallos de conectividad separando capas: Pod, Service, DNS, Ingress Controller, regla `Ingress` y cliente;
- comparar Ingress y Gateway API a nivel conceptual sin adelantar una migracion no validada;
- recuperar el laboratorio a un estado conocido reaplicando manifiestos declarativos;
- registrar en `summary.md` el estado que reutilizara la Unidad 04.

---

# Alcance

## Incluido

- reutilizacion de `platform-api`, `platform-training` y `labs/02-configuration-lifecycle/solution/`;
- laboratorio de Unidad 03 en `labs/03-networking-ingress/`;
- tutorial de alumno, notas del instructor y summary de continuidad;
- conservacion del Service `platform-api` como `ClusterIP`;
- explicacion y validacion de DNS interno de Kubernetes;
- uso de EndpointSlice como comprobacion principal de seleccion de Pods;
- introduccion de Ingress Controller en MicroK8s como dependencia especifica local;
- recurso `Ingress` HTTP para `platform-api`;
- ruta o host local de laboratorio, por ejemplo `platform-api.local`;
- diagnostico de conectividad con `kubectl`, eventos, logs, EndpointSlice, DNS interno y peticiones HTTP;
- comparacion conceptual entre Ingress y Gateway API;
- validacion no destructiva del estado esperado;
- actualizacion de `project/project-state.md` al generar y cerrar la unidad.

## Excluido

- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- Prometheus, Grafana, Loki, Tempo, OpenTelemetry u observabilidad avanzada;
- KEDA, HPA o escalado automatico;
- almacenamiento persistente con PV, PVC o StorageClass;
- NetworkPolicies, service mesh, mTLS o seguridad avanzada de red;
- certificados publicos, ACME, cert-manager o PKI corporativa;
- LoadBalancer cloud, AKS, EKS, DNS publico o registros externos;
- sustitucion de `platform-api` por otra aplicacion;
- cambio de namespace funcional;
- introduccion de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Persistencia con PV, PVC y StorageClass | Unidad 04 | La Unidad 03 debe cerrar primero el acceso estable a la aplicacion |
| Scheduling, resiliencia y mantenimiento avanzado | Unidad 05 | Requiere workload ya accesible y diagnosticable por red |
| Helm | Unidad 06 | Requiere manifiestos acumulados y estables |
| Terraform | Unidad 07 | Requiere chart o limites claros entre herramientas |
| Tekton | Unidad 08 | Requiere artefactos de aplicacion y validacion consolidados |
| Argo CD | Unidad 09 | Requiere layout declarativo estable |
| Observabilidad avanzada | Unidades 11-15 | La Unidad 03 usa observacion nativa para diagnostico de red |
| Seguridad avanzada de red y NetworkPolicies | Unidades 16-17 | Requiere baseline funcional antes de restringir trafico |
| Gateway API aplicada como capacidad principal | Unidad posterior a consolidar segun roadmap | En esta unidad se introduce de forma conceptual y comparativa |
| TLS productivo y certificados publicos | Unidades de seguridad, cloud o GitOps | Requiere decisiones de identidad, DNS y automatizacion |
| AKS y EKS | Unidades 20-21 | Requieren baseline local consolidado |

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
10. `tutorial/02-configuration-lifecycle/summary.md`;
11. este playbook;
12. `labs/02-configuration-lifecycle/README.md`;
13. `labs/02-configuration-lifecycle/solution/namespace.yaml`;
14. `labs/02-configuration-lifecycle/solution/configmap.yaml`;
15. `labs/02-configuration-lifecycle/solution/secret.yaml`;
16. `labs/02-configuration-lifecycle/solution/deployment.yaml`;
17. `labs/02-configuration-lifecycle/solution/service.yaml`;
18. `labs/02-configuration-lifecycle/validation/validate.sh`.

## Excepciones

Ninguna. La Unidad 02 esta cerrada, validada tecnicamente, aprobada por el usuario y existe `tutorial/02-configuration-lifecycle/summary.md`.

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
playbooks/units/03-networking-ingress.md
tutorial/02-configuration-lifecycle/summary.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| Ubuntu WSL objetivo | Validado como Ubuntu 24.04 LTS | `cat /etc/os-release` o validacion heredada |
| MicroK8s | Instalado y operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| Addon DNS | Habilitado | `microk8s status --wait-ready` y prueba DNS interna |
| Addon Ingress de MicroK8s | Habilitable o activo para el laboratorio | `microk8s status --wait-ready` y `kubectl get pods -n ingress` |
| Namespace `platform-training` | Existente o aplicable desde manifiesto | `kubectl get namespace platform-training` |
| Deployment `platform-api` | Definido y desplegable desde Unidad 02 | `kubectl -n platform-training rollout status deployment/platform-api` |
| Service `platform-api` | `ClusterIP` interno con endpoints | `kubectl -n platform-training get service platform-api` y EndpointSlice |
| Helm | Instalado, pero no usado para desplegar la unidad | `helm version --short` |
| Terraform | Instalado, pero no usado para gestionar recursos | `terraform version` |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00 y validacion del entorno local;
- Unidad 01 y despliegue inicial de `platform-api`;
- Unidad 02 y configuracion, probes, resources y Service interno;
- relacion entre Deployment, Pod, labels, selector, Service y EndpointSlice;
- uso basico de `kubectl apply`, `get`, `describe`, `logs`, `rollout status` y `port-forward`;
- lectura basica de YAML.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/02-configuration-lifecycle/summary.md
labs/02-configuration-lifecycle/README.md
labs/02-configuration-lifecycle/solution/namespace.yaml
labs/02-configuration-lifecycle/solution/configmap.yaml
labs/02-configuration-lifecycle/solution/secret.yaml
labs/02-configuration-lifecycle/solution/deployment.yaml
labs/02-configuration-lifecycle/solution/service.yaml
labs/02-configuration-lifecycle/validation/validate.sh
```

---

# Estado inicial esperado

La unidad parte de `platform-api` desplegada sobre MicroK8s en el namespace `platform-training`, con configuracion externa y Service interno.

Estado verificable esperado:

- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` disponibles segun estado heredado;
- `kubectl` `v1.35.6` configurado como cliente principal;
- addon `dns` de MicroK8s habilitado;
- Helm y Terraform instalados como CLI heredadas, sin gestionar recursos del curso;
- namespace `platform-training` definido en `labs/02-configuration-lifecycle/solution/namespace.yaml`;
- Deployment `platform-api` definido con dos replicas, imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`, ConfigMap, Secret de laboratorio, probes y resources;
- Service `platform-api` de tipo `ClusterIP` definido en `labs/02-configuration-lifecycle/solution/service.yaml`;
- EndpointSlice activo cuando los Pods esten Ready;
- sin Ingress, Gateway, HTTPRoute, TLS, charts Helm, modulos Terraform, pipelines, observabilidad avanzada ni recursos cloud.

No debe asumirse que el laboratorio esta desplegado en el cluster si no se ejecuta validacion real o el usuario aporta evidencia.

## Validacion del estado inicial

Ejecutar desde Ubuntu WSL objetivo cuando se vaya a generar o validar funcionalmente la unidad:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/02-configuration-lifecycle/validation/validate.sh
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice
kubectl -n platform-training get ingress
microk8s status --wait-ready
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
deployment/platform-api esta disponible.
service/platform-api existe como ClusterIP y selecciona Pods Ready.
No existen recursos Ingress de la aplicacion creados por unidades anteriores.
El addon dns esta habilitado.
El addon ingress puede estar deshabilitado antes de esta unidad.
```

Si la Unidad 02 no esta aplicada, la unidad puede documentar la recuperacion aplicando `labs/02-configuration-lifecycle/solution/`, sin declarar validacion funcional hasta ejecutarla.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 02 | `tutorial/02-configuration-lifecycle/summary.md` | Continuidad tecnica, decisiones y limitaciones |
| Namespace base | `labs/02-configuration-lifecycle/solution/namespace.yaml` | Mantener `platform-training` como namespace funcional |
| ConfigMap base | `labs/02-configuration-lifecycle/solution/configmap.yaml` | Conservar contenido/configuracion de laboratorio |
| Secret de laboratorio | `labs/02-configuration-lifecycle/solution/secret.yaml` | Conservar valores ficticios sin imprimirlos |
| Deployment evolucionado | `labs/02-configuration-lifecycle/solution/deployment.yaml` | Mantener Pods, probes, resources y labels |
| Service interno | `labs/02-configuration-lifecycle/solution/service.yaml` | Backend del Ingress y evidencia de red interna |
| Validacion Unidad 02 | `labs/02-configuration-lifecycle/validation/validate.sh` | Precondicion funcional |
| Labels base | `app.kubernetes.io/name=platform-api`, `app.kubernetes.io/instance=platform-api-local` | Selectors, EndpointSlice y continuidad operativa |
| Estado del proyecto | `project/project-state.md` | Registro de hechos generados y validados |

## Reglas de reutilizacion

- mantener `platform-api` como aplicacion evolutiva;
- mantener `platform-training` como namespace funcional;
- conservar el Service `platform-api` como `ClusterIP`;
- no cambiar selectors del Service salvo defecto real y documentado;
- no modificar el Deployment salvo que sea imprescindible para exponer correctamente HTTP, y registrar el motivo;
- no exponer ni decodificar valores del Secret de laboratorio;
- crear artefactos de Unidad 03 en una ruta propia y declarar que extienden la solucion de Unidad 02;
- no usar Helm ni Terraform para aplicar los recursos;
- aislar cualquier paso especifico de MicroK8s, especialmente la habilitacion de Ingress Controller.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Responsabilidad | Ubicacion prevista |
|---|---|---|
| Tutorial de la Unidad 03 | Guiar conceptos de red, DNS, Service, Ingress y diagnostico | `tutorial/03-networking-ingress/README.md` |
| Notas del instructor | Facilitar imparticion, demostraciones y evaluacion | `tutorial/03-networking-ingress/instructor-notes.md` |
| Summary | Registrar continuidad tecnica y pedagogica | `tutorial/03-networking-ingress/summary.md` |
| Laboratorio | Contener instrucciones y artefactos declarativos | `labs/03-networking-ingress/README.md` |
| Ingress HTTP | Enrutar trafico HTTP hacia `service/platform-api` | `labs/03-networking-ingress/solution/ingress.yaml` |
| Manifiestos heredados versionados para Unidad 03 | Nueva base acumulativa | `labs/03-networking-ingress/solution/` |
| Validacion del laboratorio | Comprobacion no destructiva del estado esperado | `labs/03-networking-ingress/validation/validate.sh` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar existencia del playbook, generacion y cierre de Unidad 03 segun corresponda | Mantiene estado real como fuente de verdad |
| Service `platform-api` | Debe conservarse como `ClusterIP`; solo se modifica si hay defecto documentado | Ingress enruta al Service existente |
| Addon Ingress de MicroK8s | Puede habilitarse durante el laboratorio si no esta activo | Cambio especifico de plataforma local y documentado como no portable |

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseno de la unidad

## D-03-01 - Service interno conservado como backend estable

### Decision

La unidad conservara `service/platform-api` como `ClusterIP` y lo usara como backend del recurso `Ingress`.

### Motivo

El alumno debe ver que Ingress no sustituye al Service; lo complementa como capa de entrada HTTP.

### Consecuencias

- el Service sigue siendo la abstraccion estable dentro del cluster;
- el Ingress depende de que el Service tenga EndpointSlices con Pods Ready;
- los diagnosticos deben empezar por Pods, Service y EndpointSlice antes de revisar Ingress.

### Alternativas descartadas

- Cambiar el Service a `NodePort`: expone la aplicacion sin explicar la abstraccion de ingreso HTTP prevista.
- Usar `LoadBalancer`: en local depende de componentes no introducidos y en cloud anticipa unidades posteriores.

## D-03-02 - Ingress Controller local como dependencia explicita de MicroK8s

### Decision

El laboratorio usara el addon Ingress de MicroK8s como Ingress Controller local cuando sea necesario.

### Motivo

Kubernetes define recursos `Ingress`, pero necesita un controlador instalado para materializar las reglas. MicroK8s proporciona un camino local reproducible para practicar esta capacidad.

### Consecuencias

- la habilitacion del addon debe documentarse como especifica de MicroK8s;
- el tutorial debe separar API estandar de Kubernetes y componente concreto del entorno local;
- no se debe extrapolar el addon de MicroK8s a AKS, EKS o entornos corporativos.

### Alternativas descartadas

- Instalar NGINX Ingress por Helm: anticipa Helm como herramienta de despliegue.
- Introducir un controlador cloud: anticipa AKS/EKS.
- Omitir controlador y crear solo YAML: impide validacion funcional real.

## D-03-03 - HTTP local antes que TLS productivo

### Decision

La unidad priorizara ingreso HTTP local con host de laboratorio. TLS se explicara conceptualmente y se diferira salvo que se use un ejemplo local autocontenido y sin certificados reales.

### Motivo

El objetivo principal es comprender enrutamiento y diagnostico de entrada. TLS introduce identidad, certificados, confianza y renovacion, que requieren tratamiento propio.

### Consecuencias

- no se versionaran claves privadas ni certificados reales;
- si se menciona TLS, debe quedar claro que no es un cierre productivo;
- cert-manager, ACME y PKI corporativa quedan fuera de alcance.

### Alternativas descartadas

- Configurar TLS publico: requiere DNS publico y certificados fuera de alcance.
- Versionar certificados privados de ejemplo: normaliza una practica insegura.

## D-03-04 - Gateway API como comparacion, no como eje operativo

### Decision

Gateway API se introducira a nivel conceptual y comparativo frente a Ingress, sin convertirla en el mecanismo principal del laboratorio.

### Motivo

El roadmap la menciona como capacidad conceptual de Unidad 03, pero el incremento debe mantener complejidad controlada y depender solo de capacidades locales verificables.

### Consecuencias

- el tutorial debe explicar por que Gateway API existe y que problemas aborda;
- no se deben crear `GatewayClass`, `Gateway` ni `HTTPRoute` como estado final salvo decision explicita y validacion real;
- el summary debe registrar si Gateway API quedo solo como concepto.

### Alternativas descartadas

- Migrar directamente a Gateway API: aumenta alcance y dependencia de controladores.
- Ignorar Gateway API: deja incompleta la comparacion prevista en roadmap.

## D-03-05 - Laboratorio acumulativo con ruta propia

### Decision

La Unidad 03 tendra su propio directorio `labs/03-networking-ingress/` con la solucion evolucionada, reutilizando semanticamente los manifiestos de Unidad 02.

### Motivo

Mantiene trazabilidad por unidad sin modificar retroactivamente el estado final de la Unidad 02.

### Consecuencias

- `labs/02-configuration-lifecycle/solution/` queda como evidencia de salida de Unidad 02;
- `labs/03-networking-ingress/solution/` sera la nueva base para Unidad 04;
- el summary debera indicar claramente que Unidad 04 reutiliza la solucion de Unidad 03.

### Alternativas descartadas

- Editar solo `labs/02-configuration-lifecycle/solution/`: dificulta auditar la evolucion entre unidades.
- Crear manifests sin relacion con la solucion previa: rompe continuidad.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/03-networking-ingress/README.md
```

Debe incluir:

1. problema real que resuelve la unidad: acceso estable a una aplicacion dentro de un cluster;
2. por que aparece despues de configuracion, probes y Service interno;
3. contexto;
4. objetivos;
5. conocimientos previos;
6. relacion con la Unidad 02;
7. estado inicial;
8. modelo mental de red: Pod IP, Service, EndpointSlice, DNS, Ingress Controller, Ingress y cliente;
9. conceptos explicados con profundidad progresiva;
10. decisiones de diseno y trade-offs;
11. procedimiento solo cuando ayude a comprender;
12. validaciones conceptuales y tecnicas;
13. errores de razonamiento frecuentes;
14. resolucion de problemas por capas;
15. recuperacion o limpieza;
16. conclusion;
17. lectura guiada con referencias oficiales, conceptuales y complementarias;
18. conexion con la Unidad 04.

Las referencias deberan priorizar documentacion oficial de Kubernetes sobre Services, DNS for Services and Pods, EndpointSlices, Ingress, Ingress Controllers y Gateway API. Cualquier material secundario debera complementar esas fuentes, no sustituirlas.

El tutorial no debe escribirse como una guia de laboratorio extendida. Los comandos repetitivos, secuencias completas de despliegue, recuperacion operacional y validacion mecanica pertenecen al README del laboratorio, salvo comandos puntuales que ayuden a observar o razonar sobre un concepto.

## Notas del instructor

Ruta:

```text
tutorial/03-networking-ingress/instructor-notes.md
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
- limites de alcance para no anticipar Helm, Terraform, Gateway API operativa, TLS productivo, seguridad avanzada ni cloud.

## Resumen

Ruta:

```text
tutorial/03-networking-ingress/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Laboratorio

Ruta normal:

```text
labs/03-networking-ingress/
```

## Estado del proyecto

Actualizar:

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
labs/03-networking-ingress/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/03-networking-ingress/README.md` | Referencia operativa del laboratorio |
| `labs/03-networking-ingress/starter/` | Punto de partida guiado con Ingress incompleto o parametros por completar |
| `labs/03-networking-ingress/solution/` | Estado final reutilizable por Unidad 04 |
| `labs/03-networking-ingress/solution/ingress.yaml` | Regla HTTP de ingreso hacia `service/platform-api` |
| `labs/03-networking-ingress/validation/validate.sh` | Validacion no destructiva de recursos esperados |

---

# Flujo pedagogico obligatorio

La unidad debera seguir este orden conceptual:

1. recuperar el estado final de Unidad 02;
2. explicar por que el Service interno no resuelve por si solo el acceso de usuarios externos;
3. construir el modelo de red por capas: Pod, Service, EndpointSlice, DNS interno, controlador de ingreso, regla de ingreso y cliente;
4. observar Service y EndpointSlice antes de introducir Ingress;
5. validar DNS interno desde dentro del cluster;
6. explicar la diferencia entre Ingress Controller e `Ingress`;
7. habilitar o verificar el controlador de ingreso de MicroK8s como paso especifico local;
8. crear un `Ingress` HTTP hacia el Service existente;
9. probar acceso HTTP local con host controlado;
10. diagnosticar al menos un fallo realista por capa;
11. comparar Ingress y Gateway API conceptualmente;
12. consolidar el estado que reutilizara la Unidad 04.

Este orden es necesario porque el alumno debe entender que la entrada al cluster depende de una cadena de responsabilidades. Saltar directamente al YAML de `Ingress` oculta que un fallo puede estar en el Pod, en readiness, en el selector del Service, en DNS, en el controlador, en la regla HTTP o en la resolucion del host cliente.

---

# Procedimientos obligatorios

## Preparacion

- validar entorno heredado;
- validar que `platform-api` de Unidad 02 esta disponible o reaplicar `labs/02-configuration-lifecycle/solution/`;
- confirmar contexto actual de `kubectl`;
- revisar recursos existentes en `platform-training`;
- verificar estado del addon `dns`;
- verificar si el addon Ingress de MicroK8s esta activo;
- confirmar que no existen recursos Ingress previos para `platform-api`.

## Implementacion

- copiar o evolucionar los manifiestos de Unidad 02 hacia `labs/03-networking-ingress/solution/`;
- mantener `Service` como `ClusterIP`;
- crear manifiesto `Ingress` con host local de laboratorio y backend `service/platform-api` puerto `80`;
- documentar habilitacion del Ingress Controller de MicroK8s si no esta activo;
- documentar mecanismo local de resolucion del host, preferentemente sin depender de cambios permanentes no explicados;
- aplicar manifiestos en orden explicito;
- documentar comandos exactos y resultados esperados.

## Validacion

- comprobar Deployment disponible;
- comprobar Service `ClusterIP`;
- comprobar EndpointSlice con endpoints listos;
- comprobar DNS interno desde un Pod temporal de diagnostico o mecanismo equivalente;
- comprobar Ingress Controller activo;
- comprobar recurso `Ingress` creado con host y backend esperados;
- comprobar acceso HTTP por la ruta de ingreso local;
- ejecutar script de validacion de Unidad 03.

## Diagnostico

- identificar Pods no Ready y su efecto en EndpointSlice;
- identificar Service sin endpoints por selector incorrecto;
- identificar fallo de DNS interno;
- distinguir Ingress Controller ausente de recurso `Ingress` mal definido;
- revisar eventos y logs del controlador de ingreso cuando esten disponibles;
- identificar fallo por host HTTP incorrecto;
- separar fallo de resolucion local del host de fallo dentro del cluster.

## Recuperacion

- reaplicar manifiestos declarativos de Unidad 03;
- reaplicar manifiestos de Unidad 02 si falta la base;
- corregir selectors y backend del Ingress;
- habilitar de nuevo addon Ingress de MicroK8s si procede;
- esperar disponibilidad del controlador;
- volver a ejecutar la validacion.

## Limpieza

- documentar limpieza del recurso `Ingress` como operacion reversible;
- documentar limpieza del namespace como operacion opcional y destructiva para la aplicacion acumulada;
- advertir que eliminar `platform-training` borra el estado que Unidad 04 espera reutilizar;
- no destruir MicroK8s ni ejecutar resets de Unidad 00;
- no eliminar recursos de sistema salvo que se documente explicitamente el alcance del addon Ingress de MicroK8s.

---

# Validaciones obligatorias

## Validaciones estaticas

| Validacion | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/03-networking-ingress/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | Revision de manifiestos y busqueda de patrones sensibles | Sin tokens, passwords reales, claves privadas ni kubeconfigs |
| Sintaxis Bash de validacion | `bash -n labs/03-networking-ingress/validation/validate.sh` | Codigo de salida 0 |
| Ausencia de Helm charts | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

## Validaciones funcionales

| Validacion | Procedimiento | Resultado esperado |
|---|---|---|
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |
| Estado Unidad 02 | `bash labs/02-configuration-lifecycle/validation/validate.sh` | Sin fallos antes de evolucionar la solucion |
| Addon DNS | `microk8s status --wait-ready` | `dns` habilitado |
| Aplicacion de manifiestos | `kubectl apply -f labs/03-networking-ingress/solution/` | Recursos aplicados sin errores |
| Deployment disponible | `kubectl -n platform-training rollout status deployment/platform-api` | Rollout completado |
| Service interno | `kubectl -n platform-training get service platform-api` | `TYPE` igual a `ClusterIP` |
| EndpointSlice | `kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api` | Endpoints presentes |
| DNS interno | Pod temporal o comando equivalente que resuelva `platform-api.platform-training.svc.cluster.local` | Resolucion satisfactoria |
| Ingress Controller | `kubectl get pods -n ingress` o namespace/controlador documentado por MicroK8s | Controlador en estado Ready o Running |
| Recurso Ingress | `kubectl -n platform-training get ingress platform-api` | Host y backend esperados |
| HTTP por Ingress | `curl` contra el punto de entrada local con host esperado | `HTTP/1.1 200 OK` y contenido de `platform-api` |
| Validacion del laboratorio | `bash labs/03-networking-ingress/validation/validate.sh` | Sin fallos |

## Validaciones de continuidad

Comprobar que:

- `labs/02-configuration-lifecycle/solution/` permanece como evidencia de Unidad 02;
- `labs/03-networking-ingress/solution/` contiene el estado que reutilizara Unidad 04;
- `platform-api` conserva nombre, namespace, selector, ConfigMap, Secret de laboratorio, probes y resources;
- el Service conserva tipo `ClusterIP`;
- el Ingress enruta hacia el Service existente;
- Helm y Terraform siguen sin gestionar recursos del curso;
- no existen credenciales reales versionadas;
- `tutorial/03-networking-ingress/summary.md` registra Ingress, DNS, controlador local, validaciones y limitaciones;
- `project/project-state.md` refleja solo recursos realmente creados y validados.

## Validaciones no ejecutables en el entorno de generacion

Declarar como pendientes cualquier validacion funcional que no se ejecute realmente en MicroK8s.

No afirmar que DNS, Ingress Controller, Ingress, host local o HTTP funcionan si solo se revisaron los archivos.

---

# Escenarios de error obligatorios

| Escenario | Sintoma | Diagnostico | Recuperacion |
|---|---|---|---|
| Pods no Ready | Service sin endpoints o HTTP falla | `kubectl get pods`, `kubectl describe pod`, EndpointSlice | Corregir fallo de Pod/probe y esperar rollout |
| Selector del Service incorrecto | Service existe pero no selecciona Pods | `kubectl describe service` y EndpointSlice vacio | Restaurar labels/selectors compatibles |
| DNS interno falla | Nombre del Service no resuelve desde Pod de diagnostico | Prueba DNS interna y estado de CoreDNS/MicroK8s dns | Verificar addon `dns` y Service |
| Ingress Controller ausente | Recurso `Ingress` existe pero no hay entrada funcional | `kubectl get ingress`, namespaces del controlador, eventos | Habilitar o reparar addon Ingress de MicroK8s |
| Backend del Ingress incorrecto | HTTP devuelve 503, 404 o no enruta a `platform-api` | `kubectl describe ingress`, eventos del controlador | Corregir service name, service port, host o path |
| Host HTTP incorrecto | Acceso por IP funciona distinto o devuelve backend por defecto | Revisar cabecera `Host`, `curl -H` o resolucion local | Usar host documentado o ajustar resolucion local |
| Puerto local ocupado | No se puede probar el punto de entrada local | Mensaje de bind o conexion rechazada | Elegir puerto alternativo documentado si aplica |
| Contexto `kubectl` equivocado | Recursos no aparecen o se aplican a otro cluster | `kubectl config current-context` y `kubectl get nodes` | Cambiar contexto o reconfigurar desde Unidad 00 |
| Confundir `/etc/hosts` con DNS del cluster | Funciona desde el host pero no desde Pods, o al reves | Comparar resolucion en cliente local y dentro del cluster | Separar diagnostico local y diagnostico interno |

---

# Requisitos de seguridad

## Datos sensibles

La Unidad 03 no debe introducir credenciales reales.

Solo se permiten:

- hosts locales de laboratorio;
- placeholders no corporativos;
- valores ficticios ya heredados de Unidad 02;
- configuracion publica de ejemplo.

No versionar:

- tokens;
- passwords reales;
- claves privadas;
- kubeconfigs personales;
- certificados privados;
- credenciales de proxy;
- datos corporativos;
- cadenas de conexion reales.

## Tratamiento didactico de exposicion

Documentar que:

- exponer una aplicacion por Ingress cambia el perimetro de acceso;
- un Ingress HTTP local no equivale a una exposicion productiva segura;
- TLS, autenticacion, autorizacion, WAF, politicas de red y gestion de certificados quedan fuera de esta unidad;
- cualquier configuracion de host local debe ser reversible y limitada al laboratorio.

## Privilegios

Documentar:

- que `kubectl` opera contra el cluster local;
- que habilitar addons de MicroK8s puede requerir permisos locales del usuario configurado en Unidad 00;
- que no se requieren credenciales cloud;
- que no deben usarse privilegios de administrador para introducir credenciales ni modificar recursos externos.

## Operaciones destructivas

| Operacion | Advertencia | Alcance | Recuperacion | Confirmacion requerida |
|---|---|---|---|---|
| `kubectl delete ingress platform-api -n platform-training` | Elimina solo la regla de entrada | Ingress de la aplicacion | Reaplicar `ingress.yaml` | No, si esta dentro de limpieza guiada |
| `kubectl delete namespace platform-training` | Elimina la aplicacion y configuracion acumulada | Recursos funcionales del curso | Reaplicar `labs/03-networking-ingress/solution/` | Confirmacion explicita en tutorial |
| Deshabilitar addon Ingress de MicroK8s | Puede afectar a otros Ingress locales | Componente compartido del cluster local | Rehabilitar addon y reaplicar validacion | Confirmacion explicita |

No usar `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de Unidad 03.

---

# Requisitos de portabilidad

## Kubernetes estandar

- `Service` de tipo `ClusterIP`;
- DNS interno para Services;
- EndpointSlice;
- `Ingress`;
- reglas HTTP por host y path;
- `kubectl apply`, `get`, `describe`, `logs`, `rollout status`;
- diagnostico por eventos y estado de recursos.

## Especifico de MicroK8s

- addon `dns` como implementacion local heredada;
- addon `ingress` como Ingress Controller local;
- posible namespace `ingress` y recursos propios del controlador;
- acceso desde el host WSL o Windows puede depender de red local y resolucion de nombres;
- recursos disponibles dependen del host WSL.

## Especifico de AKS

No aplica en esta unidad. Mencionar solo de forma comparativa que en AKS el controlador, LoadBalancer, identidad, DNS y certificados se gestionan con decisiones propias de plataforma.

## Especifico de EKS

No aplica en esta unidad. Mencionar solo de forma comparativa que en EKS el controlador, LoadBalancer, identidad, DNS y certificados se gestionan con decisiones propias de plataforma.

## Estrategia de desacoplamiento

- usar APIs Kubernetes estandar para Service e Ingress;
- aislar la habilitacion del controlador como paso especifico de MicroK8s;
- mantener nombres y labels preparados para Helm;
- no depender de DNS publico;
- no introducir IPs fijas externas como contrato del curso;
- documentar el host local como comodidad de laboratorio, no como diseno productivo;
- registrar en summary cualquier dependencia concreta del controlador local.

---

# Restricciones de generacion

La IA no debe:

- generar contenido de Unidad 04 o posteriores;
- crear charts Helm;
- crear modulos Terraform;
- instalar o configurar Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- introducir PV, PVC o StorageClass;
- introducir NetworkPolicies, service mesh, mTLS, cert-manager, ACME o PKI corporativa;
- cambiar el Service a `NodePort` o `LoadBalancer` salvo decision documentada y aprobada;
- crear `GatewayClass`, `Gateway` o `HTTPRoute` como estado final salvo decision explicita y validacion real;
- redefinir la plataforma local ni sustituir MicroK8s;
- introducir Minikube, kind o Docker Desktop Kubernetes como plataforma paralela;
- usar Secrets con valores reales;
- crear dependencias obligatorias de servicios cloud, DNS publico o herramientas corporativas;
- asumir que un recurso fue desplegado sin ejecutar validacion real o recibir evidencia del usuario;
- modificar scripts de Unidad 00 salvo correccion justificada;
- resolver la deuda de hardening pedagogico global salvo decision explicita.

La IA si puede:

- crear manifiestos Kubernetes declarativos que extiendan `platform-api`;
- crear un recurso `Ingress` HTTP para el Service existente;
- documentar y ejecutar habilitacion del addon Ingress de MicroK8s cuando proceda;
- crear scripts de validacion del laboratorio;
- documentar comandos de diagnostico y recuperacion;
- registrar decisiones, limitaciones y evidencias en `summary.md` y `project/project-state.md`;
- usar `kubectl` contra MicroK8s validado.

---

# Criterios de aceptacion

La unidad se considerara completada cuando:

- [ ] exista `tutorial/03-networking-ingress/README.md`;
- [ ] exista `tutorial/03-networking-ingress/instructor-notes.md`;
- [ ] exista `tutorial/03-networking-ingress/summary.md`;
- [ ] exista `labs/03-networking-ingress/README.md`;
- [ ] existan manifiestos en `labs/03-networking-ingress/starter/`;
- [ ] existan manifiestos en `labs/03-networking-ingress/solution/`;
- [ ] exista `labs/03-networking-ingress/validation/validate.sh`;
- [ ] `platform-api` se mantenga como aplicacion evolutiva;
- [ ] `platform-training` se mantenga como namespace funcional;
- [ ] el Service conserve tipo `ClusterIP` y selectors compatibles con los Pods;
- [ ] exista un Ingress HTTP hacia `service/platform-api`;
- [ ] el tutorial explique DNS interno, EndpointSlice, Ingress Controller e Ingress;
- [ ] el tutorial compare Ingress y Gateway API sin adelantar capacidad no implementada;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] las validaciones estaticas y funcionales posibles hayan sido ejecutadas;
- [ ] las validaciones no ejecutadas esten declaradas;
- [ ] no existan secretos reales ni certificados privados versionados;
- [ ] el tutorial incluya referencias oficiales o fuentes primarias relevantes;
- [ ] Helm y Terraform no gestionen todavia recursos del curso;
- [ ] `project/project-state.md` este actualizado;
- [ ] el resultado prepare la Unidad 04;
- [ ] no existan contradicciones abiertas.

---

# Estado final esperado

## Plataforma

- MicroK8s local sigue disponible y validado;
- `kubectl` sigue siendo el cliente principal;
- addon `dns` sigue habilitado;
- Ingress Controller local de MicroK8s activo si se ejecuto la unidad funcionalmente;
- no se han introducido cambios estructurales en `platform/environment/`;
- Helm y Terraform siguen instalados pero no gestionan recursos del curso.

## Aplicacion

- `platform-api` sigue desplegada en `platform-training`;
- Deployment conserva ConfigMap, Secret ficticio, probes y resources de Unidad 02;
- Service `platform-api` sigue siendo `ClusterIP`;
- Ingress HTTP permite acceso local controlado a `platform-api`;
- Gateway API queda registrada como comparacion conceptual salvo decision explicita distinta.

## Automatizacion

- manifiestos Kubernetes declarativos disponibles en `labs/03-networking-ingress/solution/`;
- script de validacion no destructiva disponible;
- no existen charts Helm;
- no existen modulos Terraform.

## Observabilidad

- diagnostico mediante estado Kubernetes, eventos, logs, EndpointSlice, DNS interno, estado del Ingress y pruebas HTTP;
- no existe stack de observabilidad avanzada.

## Seguridad

- no se incorporan credenciales reales;
- no se versionan certificados privados;
- exposicion HTTP local documentada como laboratorio, no como patron productivo cerrado.

## Artefactos principales

```text
tutorial/03-networking-ingress/README.md
tutorial/03-networking-ingress/instructor-notes.md
tutorial/03-networking-ingress/summary.md
labs/03-networking-ingress/README.md
labs/03-networking-ingress/starter/
labs/03-networking-ingress/solution/
labs/03-networking-ingress/validation/validate.sh
```

---

# Informacion obligatoria para el summary

El `summary.md` debera destacar:

- capacidad incorporada;
- artefactos creados;
- artefactos modificados;
- controlador de ingreso usado y si es especifico de MicroK8s;
- comandos de validacion principales;
- decisiones especificas;
- referencias principales utilizadas;
- dependencias nuevas;
- limitaciones;
- deuda tecnica;
- estado de Gateway API como conceptual o implementado;
- elementos que debe reutilizar la Unidad 04;
- estado final verificable.

---

# Impacto esperado en project-state

Al cerrar la unidad, actualizar como minimo:

- fase actual;
- ultima unidad completada;
- unidad siguiente;
- artefactos existentes;
- componentes desplegados;
- estado del Ingress Controller local si fue habilitado y validado;
- Ingress de `platform-api` si fue creado y validado;
- herramientas disponibles;
- versiones activas si se validaron de nuevo;
- decisiones;
- riesgos;
- deuda tecnica;
- siguiente incremento permitido.

No registrar componentes previstos como si estuvieran implementados.

---

# Conexion con la siguiente unidad

## Siguiente unidad prevista

```text
04 - Persistencia y estado
```

## Capacidades que deja preparadas

- aplicacion accesible mediante Service interno e Ingress HTTP local;
- diagnostico de red por capas;
- manifiestos acumulados con Namespace, ConfigMap, Secret de laboratorio, Deployment, Service e Ingress;
- separacion documentada entre Kubernetes estandar y dependencia local de MicroK8s.

## Elementos que la siguiente unidad debera reutilizar

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Continuidad tecnica y limitaciones |
| Solucion Unidad 03 | `labs/03-networking-ingress/solution/` | Base declarativa acumulada |
| Validacion Unidad 03 | `labs/03-networking-ingress/validation/validate.sh` | Precondicion funcional |
| `platform-api` | `deployment/platform-api` | Aplicacion evolutiva |
| `service/platform-api` | `labs/03-networking-ingress/solution/service.yaml` | Acceso interno estable |
| `ingress/platform-api` | `labs/03-networking-ingress/solution/ingress.yaml` | Entrada HTTP local |

## Elementos que no deben modificarse todavia

- no convertir manifiestos a Helm;
- no crear modulos Terraform;
- no introducir almacenamiento persistente antes de la Unidad 04;
- no introducir NetworkPolicies como parte de Unidad 03;
- no sustituir Ingress por Gateway API sin decision posterior.

---

# Riesgos especificos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|---|---|---|---|
| El addon Ingress de MicroK8s no esta activo o tarda en estar listo | Media | Medio | Verificar estado, documentar espera y diagnostico del namespace/controlador |
| Diferencias de red entre WSL2, host Windows y MicroK8s | Media | Medio | Separar validacion desde WSL y host; documentar limitaciones locales |
| El alumno confunde Ingress con Service | Alta | Alto pedagogico | Reforzar modelo por capas y diagnostico descendente |
| Host local no resuelve | Media | Bajo | Usar `curl -H` o mecanismo documentado sin exigir DNS publico |
| Gateway API distrae del objetivo principal | Media | Medio | Mantenerla como comparacion conceptual |
| Introducir TLS aumenta alcance y riesgo de secretos | Media | Alto | Diferir TLS productivo y prohibir certificados privados reales |
| Ingress Controller devuelve backend por defecto | Media | Medio | Validar host/path, eventos y backend del recurso `Ingress` |
| Cambios no portables se presentan como Kubernetes estandar | Media | Alto | Etiquetar pasos MicroK8s y registrar dependencias en summary |
