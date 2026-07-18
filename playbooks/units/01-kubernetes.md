# Playbook de la Unidad 01 - Fundamentos operativos y primera aplicacion

## Identificacion

### Unidad

```text
01 - Fundamentos operativos y primera aplicacion
```

### Identificador

```text
01-kubernetes
```

### Fase del roadmap

```text
Fase 2 - Fundamentos Kubernetes
```

### Estado del playbook

```text
Aprobado para iniciar la generacion de la Unidad 01
```

### Propietario logico

```text
Fundamentos Kubernetes
```

---

# Proposito de la unidad

La Unidad 01 introduce la operacion basica de Kubernetes desplegando la primera version funcional de la solucion evolutiva del curso sobre el entorno MicroK8s validado en la Unidad 00.

Su responsabilidad es transformar el laboratorio local vacio en una base de aplicacion declarativa, inspeccionable y reutilizable. La unidad debe establecer las primeras convenciones de namespaces, labels, selectors, manifiestos y validaciones operativas que las unidades posteriores ampliaran con configuracion, networking, persistencia, Helm, Terraform, CI/CD, observabilidad, seguridad, escalado y cloud.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- validar que el entorno MicroK8s heredado de la Unidad 00 esta listo para recibir workloads;
- explicar la arquitectura basica del clúster, incluyendo control plane, nodos worker y componentes principales;
- situar `kube-apiserver`, `etcd`, `kube-scheduler`, `kube-controller-manager`, `kubelet`, `kube-proxy` y container runtime dentro del flujo operativo;
- diferenciar el papel de CRI, CNI y CSI sin implementarlos todavia en el laboratorio;
- justificar la relacion entre Pods, ReplicaSets, Deployments y Services;
- identificar como se gestiona la configuracion en Kubernetes mediante ConfigMaps, Secrets, variables de entorno y volumenes de configuracion, y que parte se implementara en Unidad 02;
- identificar para que sirven probes, requests, limits, Ingress, Gateway API y almacenamiento persistente, y en que unidad se implementaran;
- distinguir observabilidad basica disponible desde Kubernetes (`status`, eventos y logs) de la observabilidad avanzada que se incorporara con Prometheus, Grafana, Loki, Tempo, OpenTelemetry y OpenMetrics;
- crear un namespace funcional del curso mediante manifiestos declarativos;
- desplegar la primera version de la aplicacion evolutiva usando recursos Kubernetes estandar;
- inspeccionar estado, eventos, logs, labels y selectors con `kubectl`;
- diagnosticar fallos basicos de despliegue, scheduling, imagen y seleccion de Pods;
- recuperar el laboratorio a un estado conocido sin destruir la plataforma base;
- dejar artefactos reutilizables para la Unidad 02.

---

# Alcance

## Incluido

- seleccion o definicion minima de la aplicacion evolutiva;
- estructura inicial de laboratorio en `labs/01-kubernetes/`;
- introduccion conceptual de arquitectura Kubernetes: control plane, nodos worker y flujo de reconciliacion;
- explicacion conceptual de `kube-apiserver`, `etcd`, `kube-scheduler`, `kube-controller-manager`, `kubelet`, `kube-proxy` y container runtime;
- mapa conceptual de CRI, CNI y CSI como interfaces de runtime, red y almacenamiento;
- vision general de gestion de configuracion en Kubernetes: ConfigMaps, Secrets, variables de entorno y volumenes de configuracion;
- mapa conceptual de recursos que se implementaran despues: probes, requests, limits, Ingress, Gateway API y almacenamiento persistente;
- vision general de observabilidad: estado, eventos y logs en Unidad 01; metricas, dashboards, logs centralizados, trazas y correlacion en Unidades 11-15;
- primer namespace funcional del curso;
- manifiestos declarativos para `Namespace`, `Deployment` y `Service`;
- uso de Pods y ReplicaSets como recursos observados y explicados, no como artefactos primarios gestionados manualmente;
- convenciones iniciales de nombres, labels y selectors;
- comandos de inspeccion con `kubectl`;
- logs de contenedor;
- eventos de Kubernetes;
- validaciones estaticas y funcionales del despliegue;
- procedimientos de diagnostico, recuperacion y limpieza del laboratorio de la unidad;
- notas del instructor y summary de continuidad;
- actualizacion de `project/project-state.md` al cerrar la unidad.

## Excluido

- implementacion practica de ConfigMaps y Secrets de aplicacion;
- implementacion practica de probes;
- definicion practica de requests y limits;
- implementacion practica de Ingress;
- implementacion practica de Gateway API;
- implementacion practica de almacenamiento persistente;
- instalacion, sustitucion o configuracion avanzada de CNI, CSI o container runtime;
- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- observabilidad con Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- politicas avanzadas de seguridad;
- escalado con KEDA;
- recursos AKS o EKS;
- registro de credenciales reales o configuraciones corporativas sensibles.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Implementacion de ConfigMaps, Secrets, probes y recursos | Unidad 02 | Requiere una aplicacion ya desplegada; Unidad 01 debe explicar conceptualmente como Kubernetes separa configuracion, secretos e imagen |
| Implementacion de Networking avanzado, Ingress y Gateway API | Unidad 03 | Requiere Service y workload base; Unidad 01 debe explicar la diferencia entre Service, Ingress y Gateway API |
| Implementacion de persistencia | Unidad 04 | Requiere modelo inicial de aplicacion; Unidad 01 debe introducir volumen, PV, PVC y CSI a nivel conceptual |
| Helm | Unidad 06 | Requiere manifiestos declarativos estables |
| Terraform | Unidad 07 | Requiere artefactos de despliegue ya definidos |
| Tekton | Unidad 08 | Requiere aplicacion y estrategia de build |
| Argo CD | Unidad 09 | Requiere layout declarativo estable |
| Observabilidad avanzada | Unidades 11-15 | Requiere aplicacion operativa; Unidad 01 debe explicar el mapa de señales y usar estado, logs y eventos como observabilidad basica |
| Seguridad avanzada | Unidades 16-17 | Requiere workloads definidos |
| KEDA | Unidad 18 | Requiere metricas y aplicacion escalable |
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
10. `tutorial/00-environment/summary.md`;
11. este playbook;
12. `platform/environment/README.md`;
13. los scripts existentes en `platform/environment/validation/`, `platform/environment/microk8s/` y `platform/environment/tools/`.

## Excepciones

Ninguna. La Unidad 00 esta cerrada y existe `tutorial/00-environment/summary.md`.

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
playbooks/units/01-kubernetes.md
tutorial/00-environment/summary.md
```

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| Ubuntu WSL objetivo | Validado como Ubuntu 24.04 LTS | `cat /etc/os-release` |
| MicroK8s | Instalado y en estado operativo | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` | `kubectl get nodes` |
| `kubectl` | Cliente principal operativo | `kubectl version --client` |
| DNS de Kubernetes | Addon `dns` habilitado | `microk8s status` y validacion mediante Service/DNS cuando aplique |
| Helm | Instalado, pero no usado para desplegar la unidad | `helm version --short` |
| Terraform | Instalado, pero no usado para gestionar recursos | `terraform version` |
| Conectividad para imagenes | Disponible cuando se use una imagen externa | Pull real durante despliegue o uso de imagen ya disponible |

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- preparacion y validacion del entorno de la Unidad 00;
- uso basico de shell Linux;
- ejecucion de comandos con `kubectl`;
- lectura de salidas tabulares y YAML;
- conceptos iniciales de procesos, puertos y conectividad HTTP.

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
tutorial/00-environment/summary.md
platform/environment/README.md
platform/environment/validation/validate-environment.sh
platform/environment/microk8s/validate.sh
platform/environment/tools/validate-tools.sh
```

---

# Estado inicial esperado

La unidad parte de un entorno local validado, sin workloads funcionales del curso y sin aplicacion evolutiva definida.

Estado verificable esperado:

- Ubuntu 24.04 LTS sobre WSL2 disponible;
- MicroK8s `v1.35.6` validado por el usuario en la Unidad 00;
- Kubernetes `v1.35.6` operativo en MicroK8s;
- `kubectl` `v1.35.6` configurado como cliente principal;
- Helm `v3.21.0+ge0878d4` instalado y validado, sin charts del curso;
- Terraform `1.15.7` instalado y validado, sin modulos ni estado;
- namespaces existentes solo de sistema y `default`;
- `labs/` sin laboratorios funcionales;
- sin workloads, Services de aplicacion, endpoints ni recursos cloud.

No debe asumirse que las validaciones Windows/WSL pendientes por equipo han sido completadas salvo que el usuario aporte resultados.

## Validacion del estado inicial

Ejecutar desde Ubuntu WSL objetivo:

```bash
bash platform/environment/validation/validate-environment.sh
bash platform/environment/microk8s/validate.sh
kubectl get nodes
kubectl get namespaces
find labs -type f -not -name .gitkeep -print
```

Resultado esperado:

```text
La validacion del entorno no muestra fallos bloqueantes.
El nodo local aparece en Ready.
Solo existen namespaces de sistema y default antes de crear la unidad.
labs/ no contiene artefactos funcionales previos.
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 00 | `tutorial/00-environment/summary.md` | Continuidad de estado, versiones y limitaciones |
| Referencia de entorno | `platform/environment/README.md` | Recordar comandos base y contexto de ejecucion |
| Validacion integrada | `platform/environment/validation/validate-environment.sh` | Confirmar precondiciones del entorno |
| Validacion MicroK8s | `platform/environment/microk8s/validate.sh` | Confirmar clúster antes del despliegue |
| Validacion herramientas | `platform/environment/tools/validate-tools.sh` | Confirmar baseline CLI sin usar Helm/Terraform aun |
| Estado del proyecto | `project/project-state.md` | Registrar solo hechos implementados y validados |

## Reglas de reutilizacion

- no duplicar scripts de preparacion del entorno en `labs/01-kubernetes/`;
- no modificar `platform/environment/` salvo que se detecte un defecto real en validaciones heredadas;
- no crear un segundo clúster local;
- usar `kubectl` como cliente principal;
- usar `microk8s kubectl` solo como fallback de diagnostico;
- conservar Helm y Terraform instalados como baseline, sin usarlos todavia para gestionar el despliegue.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Responsabilidad | Ubicacion prevista |
|---|---|---|
| Tutorial de la Unidad 01 | Guiar conceptos y laboratorio del alumno | `tutorial/01-kubernetes/README.md` |
| Notas del instructor | Facilitar imparticion, diagnostico y evaluacion | `tutorial/01-kubernetes/instructor-notes.md` |
| Summary | Registrar continuidad tecnica y pedagogica | `tutorial/01-kubernetes/summary.md` |
| Laboratorio | Contener instrucciones y artefactos declarativos | `labs/01-kubernetes/README.md` |
| Manifiestos starter | Proporcionar punto de partida incompleto o guiado | `labs/01-kubernetes/starter/` |
| Manifiestos solution | Proporcionar solucion declarativa validada | `labs/01-kubernetes/solution/` |
| Namespace del curso | Aislar recursos funcionales iniciales | `labs/01-kubernetes/solution/namespace.yaml` |
| Deployment inicial | Ejecutar la primera version de la aplicacion | `labs/01-kubernetes/solution/deployment.yaml` |
| Service inicial | Exponer la aplicacion dentro del clúster | `labs/01-kubernetes/solution/service.yaml` |
| Validacion del laboratorio | Comprobar estado esperado de la unidad | `labs/01-kubernetes/validation/` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar inicio, progreso, validacion y cierre de Unidad 01 segun corresponda | Mantiene estado real como fuente de verdad |

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseno de la unidad

## D-01-01 - Manifiestos Kubernetes como artefacto primario

### Decision

La Unidad 01 gestionara la aplicacion mediante manifiestos Kubernetes YAML versionados, aplicados con `kubectl`.

### Motivo

La unidad introduce fundamentos operativos antes de incorporar herramientas de empaquetado o automatizacion.

### Consecuencias

- Helm y Terraform no gestionan todavia recursos del curso;
- los manifiestos deben ser claros, pequeños y reutilizables;
- la Unidad 02 podra extender estos recursos sin migracion de herramienta.

### Alternativas descartadas

- Helm desde la Unidad 01: anticipa contenido posterior.
- Terraform desde la Unidad 01: oculta los recursos Kubernetes basicos que el alumno debe operar.

## D-01-02 - Aplicacion evolutiva simple, observable y portable

### Decision

La aplicacion inicial debera ser suficientemente simple para desplegarse con un `Deployment` y un `Service`, pero debera permitir evolucionar hacia configuracion, salud, metricas, logs, trazas, escalado y despliegue cloud.

La seleccion concreta de nombre, imagen y estructura se realizara durante la primera sesion de generacion de Unidad 01 y debera registrarse en el tutorial, el summary y `project/project-state.md`.

### Motivo

El estado actual exige definir la aplicacion antes de generar la Unidad 01, pero el repositorio aun no contiene artefactos de aplicacion. El playbook debe fijar criterios sin crear workloads prematuramente.

### Consecuencias

- no se puede cerrar la Unidad 01 sin una aplicacion desplegada y validada;
- no se deben usar credenciales, servicios externos obligatorios ni dependencias corporativas;
- la imagen debe fijarse con una version explicita o digest validado durante la generacion;
- la aplicacion no debe requerir Ingress, persistencia, colas ni bases de datos en esta unidad.

### Alternativas descartadas

- Aplicacion distinta por unidad: contradice el laboratorio evolutivo.
- Aplicacion dependiente de cloud: anticipa unidades gestionadas.
- Workload efimero tipo `busybox` como aplicacion principal: no soporta evolucion pedagogica suficiente.

## D-01-03 - Namespace funcional unico inicial

### Decision

La unidad creara un namespace funcional unico para la solucion del curso.

### Motivo

Permite aislar recursos del laboratorio y prepara una convencion reutilizable para las unidades posteriores.

### Consecuencias

- el namespace debe definirse declarativamente;
- todos los recursos funcionales de la aplicacion inicial deben ubicarse en ese namespace;
- la convencion de nombre debe quedar documentada y registrada al cerrar la unidad.

### Alternativas descartadas

- Usar `default`: reduce claridad operativa.
- Crear multiples namespaces: anticipa topologias y gobierno posteriores.

## D-01-04 - Starter y solution sin duplicar laboratorios completos

### Decision

`starter/` contendra solo los artefactos necesarios para guiar el ejercicio y `solution/` contendra la solucion final validada.

### Motivo

Permite aprendizaje incremental sin crear laboratorios independientes.

### Consecuencias

- el tutorial debe explicar cuando usar cada ruta;
- la solucion final sera la fuente que la Unidad 02 debera reutilizar;
- cualquier diferencia entre starter y solution debe ser intencional y documentada.

### Alternativas descartadas

- Solo comandos imperativos: dificulta continuidad.
- Copias completas por cada paso: aumenta divergencia y mantenimiento.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/01-kubernetes/README.md
```

Debe incluir:

1. contexto;
2. objetivos;
3. conocimientos previos;
4. relacion con la Unidad 00;
5. estado inicial;
6. arquitectura del clúster: control plane, nodos worker y flujo de reconciliacion;
7. componentes del control plane: `kube-apiserver`, `etcd`, `kube-scheduler` y `kube-controller-manager`;
8. componentes de nodo: `kubelet`, `kube-proxy` y container runtime;
9. interfaces de plataforma: CRI, CNI y CSI;
10. mapa de objetos Kubernetes: namespaces, Pods, ReplicaSets, Deployments y Services;
11. gestion de configuracion en Kubernetes: ConfigMaps, Secrets, variables de entorno y volumenes de configuracion;
12. red e ingreso: Service, Ingress y Gateway API;
13. salud, recursos y persistencia: probes, requests, limits, volumenes, PV, PVC y StorageClass;
14. observabilidad en Kubernetes: estado, eventos, logs, metricas, trazas y señales operativas;
15. labels y selectors;
16. procedimiento declarativo;
17. validaciones;
18. diagnostico con logs y eventos;
19. recuperacion o limpieza;
20. conclusion;
21. conexion con la Unidad 02.

## Notas del instructor

Ruta:

```text
tutorial/01-kubernetes/instructor-notes.md
```

Debe incluir:

- intencion pedagogica;
- puntos de enfasis;
- demostraciones recomendadas;
- errores frecuentes;
- preguntas de comprobacion;
- criterios de evaluacion;
- riesgos tecnicos;
- limites de alcance para no anticipar Unidad 02.

## Resumen

Ruta:

```text
tutorial/01-kubernetes/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Laboratorio

Ruta normal:

```text
labs/01-kubernetes/
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
labs/01-kubernetes/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── solution/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── validation/
    └── validate.sh
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `labs/01-kubernetes/README.md` | Referencia operativa del laboratorio |
| `labs/01-kubernetes/starter/` | Punto de partida para el alumno |
| `labs/01-kubernetes/solution/` | Estado final reutilizable por unidades posteriores |
| `labs/01-kubernetes/validation/validate.sh` | Validacion no destructiva de recursos esperados |

---

# Flujo pedagogico obligatorio

La unidad debera seguir este orden conceptual:

1. confirmar el entorno heredado de Unidad 00;
2. explicar como se organiza un clúster: control plane, nodos worker y componentes principales;
3. explicar como `kube-apiserver`, `etcd`, scheduler y controllers convierten declaracion en estado observado;
4. situar kubelet, kube-proxy, container runtime, CRI, CNI y CSI en la operacion de un Pod;
5. presentar el mapa de recursos del itinerario: workload, configuracion, salud, recursos, red, ingreso, Gateway API y almacenamiento;
6. presentar el mapa de observabilidad del itinerario: estado, eventos y logs ahora; metricas, dashboards, logs centralizados, trazas y correlacion despues;
7. presentar la necesidad de aislar recursos;
8. crear el namespace declarativo;
9. introducir Pods como resultado de un Deployment;
10. desplegar la aplicacion con Deployment;
11. relacionar ReplicaSets y Pods generados;
12. exponer la aplicacion con Service;
13. validar estado, logs, eventos y seleccion por labels;
14. provocar o analizar al menos un fallo realista;
15. consolidar el estado que reutilizara la Unidad 02.

Este orden evita que el alumno trate Kubernetes como una lista de comandos aislados y muestra la relacion entre declaracion, reconciliacion, estado observado y diagnostico.

---

# Procedimientos obligatorios

## Preparacion

- validar entorno con los scripts heredados;
- confirmar contexto actual de `kubectl`;
- confirmar ausencia de workloads funcionales previos;
- revisar estructura del laboratorio.

## Implementacion

- explicar el recorrido de una declaracion desde `kubectl apply` hasta la reconciliacion;
- aplicar el namespace;
- aplicar el Deployment;
- observar ReplicaSet y Pods generados;
- aplicar el Service;
- documentar comandos exactos y resultados esperados.

## Validacion

- comprobar estado de Deployment, ReplicaSet, Pods y Service;
- comprobar labels y selectors;
- revisar logs;
- revisar eventos del namespace;
- validar conectividad del Service mediante `kubectl port-forward` o un Pod temporal de diagnostico, segun se defina en la unidad.

## Diagnostico

- identificar si un fallo pertenece al plano de control, al nodo, al runtime, a red o al manifiesto aplicado;
- interpretar `ImagePullBackOff` o `ErrImagePull`;
- diagnosticar selector que no apunta a Pods;
- diagnosticar Pod no listo o CrashLoopBackOff cuando aplique;
- revisar eventos y logs antes de modificar manifiestos.

## Recuperacion

- reaplicar manifiestos declarativos;
- corregir imagen, labels o selector;
- reiniciar rollout solo si el tutorial justifica el caso;
- volver a ejecutar la validacion.

## Limpieza

- documentar limpieza del namespace de la unidad como operacion opcional;
- no destruir MicroK8s ni artefactos de Unidad 00;
- advertir que la limpieza elimina la aplicacion que la Unidad 02 espera reutilizar.

---

# Validaciones obligatorias

## Validaciones estaticas

| Validacion | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis YAML | `kubectl apply --dry-run=client -f labs/01-kubernetes/solution/` | Manifiestos aceptados por el cliente |
| Ausencia de secretos reales | Revision de manifiestos | Sin tokens, passwords, claves privadas ni kubeconfigs |
| Sintaxis Bash de validacion | `bash -n labs/01-kubernetes/validation/validate.sh` | Codigo de salida 0 |

## Validaciones funcionales

| Validacion | Procedimiento | Resultado esperado |
|---|---|---|
| Entorno heredado | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |
| Clúster disponible | `kubectl get nodes` | Nodo local `Ready` |
| Namespace creado | `kubectl get namespace <namespace>` | Namespace activo |
| Deployment disponible | `kubectl -n <namespace> rollout status deployment/<deployment>` | Rollout completado |
| Pods saludables | `kubectl -n <namespace> get pods -l <selector>` | Pods en `Running` o estado esperado documentado |
| Service selecciona Pods | `kubectl -n <namespace> get endpoints <service>` | Endpoints presentes |
| Logs disponibles | `kubectl -n <namespace> logs deploy/<deployment>` | Salida interpretable |
| Validacion del laboratorio | `bash labs/01-kubernetes/validation/validate.sh` | Sin fallos |

## Validaciones de continuidad

Comprobar que:

- los scripts de Unidad 00 siguen disponibles;
- MicroK8s no fue reinstalado ni reseteado;
- Helm y Terraform siguen instalados pero sin charts, releases ni modulos del curso;
- `labs/01-kubernetes/solution/` contiene los artefactos que reutilizara la Unidad 02;
- `tutorial/01-kubernetes/summary.md` registra namespace, recursos, imagen y comandos principales;
- `project/project-state.md` refleja solo recursos realmente creados y validados.

## Validaciones no ejecutables en el entorno de generacion

Declarar como pendientes cualquier validacion funcional que no se ejecute realmente en MicroK8s.

No afirmar que un Deployment, Pod, Service o endpoint funciona si solo se revisaron los archivos.

---

# Escenarios de error obligatorios

| Escenario | Sintoma | Diagnostico | Recuperacion |
|---|---|---|---|
| Imagen no descargable | Pod en `ImagePullBackOff` o `ErrImagePull` | `kubectl describe pod` y eventos | Corregir imagen o tag, reaplicar manifiesto |
| Selector incorrecto | Service sin endpoints | `kubectl get endpoints`, comparar labels/selectors | Corregir selector o labels y reaplicar |
| Namespace ausente | `kubectl apply` o consultas fallan por namespace inexistente | `kubectl get namespace` | Aplicar `namespace.yaml` antes del resto |
| Contenedor falla al iniciar | Pod en `CrashLoopBackOff` | `kubectl logs` y `kubectl describe pod` | Corregir argumentos, imagen o configuracion inicial |
| Contexto `kubectl` equivocado | Recursos no aparecen o se aplican a otro clúster | `kubectl config current-context` y `kubectl get nodes` | Cambiar contexto o reconfigurar `kubectl` desde Unidad 00 |

---

# Requisitos de seguridad

## Datos sensibles

La Unidad 01 no debe requerir secretos reales.

Solo se permiten:

- valores publicos de laboratorio;
- imagenes publicas o construidas sin credenciales;
- placeholders documentados cuando se prepare contenido futuro.

No versionar:

- tokens;
- passwords;
- claves privadas;
- kubeconfigs personales;
- certificados privados;
- credenciales de proxy;
- datos corporativos.

## Privilegios

Documentar:

- que `kubectl` opera contra el clúster local;
- que no deben requerirse privilegios cloud;
- que no se deben ejecutar comandos con `sudo` para crear recursos Kubernetes;
- que los permisos locales de MicroK8s pertenecen a la preparacion de Unidad 00.

## Operaciones destructivas

| Operacion | Advertencia | Alcance | Recuperacion | Confirmacion requerida |
|---|---|---|---|---|
| `kubectl delete namespace <namespace>` | Elimina la aplicacion de la unidad | Recursos funcionales de Unidad 01 | Reaplicar `labs/01-kubernetes/solution/` | Confirmacion explicita en tutorial |

No usar `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de Unidad 01.

---

# Requisitos de portabilidad

## Kubernetes estandar

- `Namespace`;
- `Deployment`;
- `ReplicaSet`;
- `Pod`;
- `Service`;
- labels y selectors;
- `kubectl apply`, `get`, `describe`, `logs`, `rollout status`.

## Especifico de MicroK8s

- validacion de disponibilidad del clúster local;
- contexto local heredado de Unidad 00;
- posible fallback con `microk8s kubectl` para diagnostico.

## Especifico de AKS

No aplica en esta unidad.

## Especifico de EKS

No aplica en esta unidad.

## Estrategia de desacoplamiento

- evitar APIs no estandar de MicroK8s;
- mantener manifiestos compatibles con Kubernetes upstream;
- documentar cualquier dependencia de imagen, puerto o contexto;
- usar nombres y labels que puedan trasladarse posteriormente a Helm y Terraform;
- no depender de addons MicroK8s salvo `dns` como baseline heredado.

---

# Restricciones de generacion

La IA no debe:

- generar contenido de Unidad 02 o posteriores;
- crear charts Helm;
- crear modulos Terraform;
- instalar o configurar Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- redefinir la plataforma local ni sustituir MicroK8s;
- introducir Minikube, kind o Docker Desktop Kubernetes como plataforma paralela;
- usar Secrets con valores reales;
- crear dependencias obligatorias de servicios cloud o corporativos;
- asumir que un recurso fue desplegado sin ejecutar validacion real o recibir evidencia del usuario;
- modificar scripts de Unidad 00 salvo correccion justificada.

La IA si puede:

- definir la aplicacion evolutiva inicial dentro del alcance de Unidad 01;
- crear manifiestos Kubernetes declarativos;
- crear scripts de validacion del laboratorio;
- documentar comandos de diagnostico y recuperacion;
- registrar decisiones, limitaciones y evidencias en `summary.md` y `project/project-state.md`;
- usar `kubectl` contra MicroK8s validado.

---

# Criterios de aceptacion

La unidad se considerara completada cuando:

- [ ] exista `tutorial/01-kubernetes/README.md`;
- [ ] exista `tutorial/01-kubernetes/instructor-notes.md`;
- [ ] exista `tutorial/01-kubernetes/summary.md`;
- [ ] exista `labs/01-kubernetes/README.md`;
- [ ] existan los manifiestos previstos en `labs/01-kubernetes/starter/`;
- [ ] existan los manifiestos previstos en `labs/01-kubernetes/solution/`;
- [ ] exista una validacion ejecutable en `labs/01-kubernetes/validation/`;
- [ ] la aplicacion evolutiva haya sido definida y registrada;
- [ ] el namespace funcional de la unidad exista en manifiestos;
- [ ] el Deployment y el Service se desplieguen correctamente en MicroK8s;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] las validaciones estaticas y funcionales posibles hayan sido ejecutadas;
- [ ] las validaciones no ejecutadas esten declaradas;
- [ ] no existan secretos reales;
- [ ] Helm y Terraform no gestionen todavia recursos del curso;
- [ ] `project/project-state.md` este actualizado;
- [ ] el resultado prepare la Unidad 02;
- [ ] no existan contradicciones abiertas.

---

# Estado final esperado

## Plataforma

- MicroK8s local sigue disponible y validado;
- `kubectl` sigue siendo el cliente principal;
- no se han introducido cambios estructurales en `platform/environment/`.

## Aplicacion

- primera version funcional desplegada en un namespace del curso;
- Deployment operativo;
- ReplicaSet y Pods generados por el Deployment;
- Service interno con endpoints;
- logs y eventos inspeccionables.

## Automatizacion

- manifiestos Kubernetes declarativos disponibles en `labs/01-kubernetes/solution/`;
- validacion ejecutable disponible para comprobar el estado del laboratorio;
- sin charts Helm, releases Helm, modulos Terraform ni estado Terraform.

## Seguridad

- sin credenciales reales;
- sin Secrets de aplicacion;
- recursos aislados en namespace funcional.

## Artefactos principales

```text
tutorial/01-kubernetes/README.md
tutorial/01-kubernetes/instructor-notes.md
tutorial/01-kubernetes/summary.md
labs/01-kubernetes/README.md
labs/01-kubernetes/starter/
labs/01-kubernetes/solution/
labs/01-kubernetes/validation/validate.sh
project/project-state.md
```

---

# Informacion obligatoria para el summary

El `summary.md` debera destacar:

- aplicacion evolutiva definida;
- namespace creado;
- manifiestos creados;
- imagen y version utilizadas;
- recursos desplegados;
- comandos de validacion principales;
- decisiones especificas;
- dependencias nuevas;
- validaciones ejecutadas y pendientes;
- limitaciones;
- deuda tecnica;
- elementos que debe reutilizar la Unidad 02;
- estado final verificable.

---

# Impacto esperado en project-state

Al cerrar la unidad, actualizar como minimo:

- fase actual;
- ultimo incremento completado;
- unidad activa;
- ultima unidad completada;
- siguiente incremento permitido;
- estructura actual del repositorio;
- estado de la Unidad 01;
- namespaces funcionales;
- workloads;
- Services y endpoints;
- estado de la aplicacion evolutiva;
- decisiones especificas de Unidad 01;
- riesgos y deuda tecnica;
- validaciones globales disponibles.

No registrar componentes previstos como si estuvieran implementados.

---

# Conexion con la siguiente unidad

## Siguiente unidad prevista

```text
02 - Configuracion, secretos y ciclo de vida
```

## Capacidades que deja preparadas

- aplicacion evolutiva desplegada;
- namespace funcional del curso;
- manifiestos base de Kubernetes;
- convenciones iniciales de labels y selectors;
- validacion basica de estado, logs y eventos.

## Elementos que la siguiente unidad debera reutilizar

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Manifiestos de solucion | `labs/01-kubernetes/solution/` | Base para ConfigMaps, Secrets, probes y recursos |
| Summary Unidad 01 | `tutorial/01-kubernetes/summary.md` | Fuente de continuidad |
| Namespace funcional | Registrado en `project/project-state.md` | Aislamiento de recursos del curso |
| Aplicacion evolutiva | Registrada en `project/project-state.md` | Debe evolucionar sin reemplazarse |

## Elementos que no deben modificarse todavia

- charts Helm;
- modulos Terraform;
- pipelines Tekton;
- aplicaciones Argo CD;
- stacks de observabilidad;
- recursos cloud.

---

# Riesgos especificos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|---|---|---|---|
| La aplicacion elegida no evoluciona bien hacia unidades posteriores | Media | Alto | Aplicar criterios de D-01-02 antes de generar artefactos |
| Imagen externa no disponible por red o rate limit | Media | Medio | Fijar imagen/version y documentar alternativa validada |
| Selectors inconsistentes entre Deployment y Service | Media | Medio | Validacion explicita de endpoints |
| Uso prematuro de Helm o Terraform | Baja | Medio | Restricciones explicitas y revision de artefactos |
| Dependencia accidental de MicroK8s | Media | Medio | Usar APIs Kubernetes estandar y documentar excepciones |
| Limpieza destructiva elimina continuidad para Unidad 02 | Media | Medio | Marcar limpieza como opcional y advertir impacto |

---

# Cuestiones abiertas

| Cuestion | Bloqueante | Momento de resolucion |
|---|---|---|
| Nombre definitivo de la aplicacion evolutiva | No para aprobar este playbook; si para generar/cerrar la Unidad 01 | Primera sesion de Unidad 01 |
| Imagen o codigo inicial de la aplicacion | No para aprobar este playbook; si para validar el laboratorio | Primera sesion de Unidad 01 |
| Nombre definitivo del namespace funcional | No para aprobar este playbook; si para generar manifiestos | Primera sesion de Unidad 01 |
| Estrategia de conectividad inicial para validar el Service | No para aprobar este playbook; si para cerrar la Unidad 01 | Generacion y validacion de Unidad 01 |

---

# Checklist de revision del playbook

Antes de aprobar este documento:

- [x] la unidad existe en `project/roadmap.md`;
- [x] el identificador y las rutas son consistentes;
- [x] el alcance no invade unidades posteriores;
- [x] las dependencias son verificables;
- [x] los artefactos previos estan identificados;
- [x] los entregables estan definidos;
- [x] las validaciones son suficientes;
- [x] los escenarios de error son realistas;
- [x] las restricciones de seguridad estan declaradas;
- [x] la portabilidad esta considerada;
- [x] los criterios de aceptacion son objetivos;
- [x] el estado final esta claramente definido;
- [x] la conexion con la siguiente unidad es explicita;
- [x] no contradice arquitectura, estado, roadmap ni playbook maestro.

---

# Metadatos de mantenimiento

## Fecha de creacion

```text
2026-07-18
```

## Ultima revision

```text
2026-07-18
```
