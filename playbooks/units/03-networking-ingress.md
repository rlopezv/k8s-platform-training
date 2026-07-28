# Playbook de la Unidad 03 - Networking e ingreso

## Identificación

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
Aprobado; regenerado contra el contrato documental en fase 4
```

### Propietario lógico

```text
Fundamentos Kubernetes
```

---

# Propósito de la unidad

La Unidad 03 evoluciona `platform-api` desde una aplicación accesible solo dentro del clúster mediante `Service` `ClusterIP` y pruebas puntuales con `port-forward` hacia una aplicación expuesta por HTTP en el laboratorio local mediante un recurso `Ingress`.

La unidad aparece aquí porque la Unidad 02 ya dejó un workload configurable, con `ConfigMap`, `Secret` ficticio, probes, `resources` y Service interno. Antes de introducir persistencia, empaquetado o automatización, el alumno necesita entender la cadena de red que conecta una petición externa con un Pod listo: red de Pods, Service, EndpointSlice, DNS interno, controlador de ingreso, regla `Ingress`, host HTTP y cliente.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que ya han visto `Deployment`, `Pod`, labels, selectors, Service y EndpointSlice, pero que todavía no dominan networking de Kubernetes ni exposición HTTP.

Se explican desde cero:

- por qué las IP de Pod son efímeras y no deben ser contrato de cliente;
- qué papel cumple el CNI en la red de Pods sin convertirlo en práctica de administración de red;
- qué diferencia hay entre red de Pod, IP virtual de Service, EndpointSlice y DNS interno;
- por qué un Service `ClusterIP` da estabilidad interna pero no resuelve la entrada externa;
- qué diferencia hay entre un Ingress Controller y un recurso `Ingress`;
- cómo se evalúan host, path, `pathType`, `ingressClassName` y backend;
- cómo diagnosticar una petición fallida por capas;
- por qué TLS, certificados, `cert-manager`, MetalLB, anotaciones de controlador y Gateway API son criterios profesionales, no práctica nueva de esta unidad.

Se retoman de unidades anteriores:

- MicroK8s local, `kubectl` y namespace funcional `platform-training`;
- aplicación evolutiva `platform-api`;
- manifiestos finales de `labs/02-configuration-lifecycle/solution/`;
- Deployment, ConfigMap, Secret ficticio, probes, `resources` y Service `ClusterIP`;
- labels y selectors base;
- EndpointSlice como evidencia preferente de Pods listos detrás de un Service;
- diagnóstico con `kubectl get`, `describe`, eventos, logs y `rollout status`.

Se mencionan solo para continuidad:

- `LoadBalancer` cloud y simulación local con MetalLB;
- TLS productivo, DNS público, certificados públicos, ACME, `cert-manager` y PKI corporativa;
- anotaciones avanzadas específicas de controladores de Ingress;
- Gateway API aplicada con `GatewayClass`, `Gateway` y `HTTPRoute`;
- NetworkPolicies, service mesh, mTLS, seguridad avanzada, observabilidad, Helm, Terraform, CI/CD, GitOps, AKS y EKS.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que crear un `Ingress` abre tráfico aunque no exista controlador;
- confundir `Service` con `Ingress`;
- asumir que `ClusterIP` es una IP estable para usuarios externos;
- confundir DNS interno del clúster con DNS del host local o DNS público;
- interpretar un 404 del controlador como caída automática de la aplicación;
- tratar anotaciones de NGINX, Traefik u otro controlador como API estándar de Kubernetes;
- presentar MicroK8s, su addon Ingress o una posible instalación local de MetalLB como equivalente a una entrada cloud;
- añadir TLS manualmente sin diseñar confianza, renovación y protección de claves.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- explicar el recorrido de una petición HTTP desde el cliente local hasta un Pod de `platform-api`;
- diferenciar Pod IP, Service, EndpointSlice, DNS interno, Ingress Controller, `Ingress`, host HTTP y cliente;
- validar que `service/platform-api` conserva endpoints listos mediante EndpointSlice;
- comprobar la resolución DNS interna de `platform-api.platform-training.svc.cluster.local`;
- habilitar o verificar el controlador Ingress local de MicroK8s cuando el laboratorio lo requiera;
- aplicar un recurso `Ingress` HTTP hacia el Service existente sin cambiarlo a `NodePort` ni `LoadBalancer`;
- probar el acceso HTTP mediante `Host: platform-api.local`;
- diagnosticar fallos por capas sin saltar directamente al último recurso modificado;
- comparar Ingress, `LoadBalancer`, MetalLB y Gateway API a nivel conceptual sin crear artefactos nuevos;
- explicar por qué TLS productivo y certificados quedan fuera de la práctica de la unidad.

---

# Alcance

## Incluido

- saneamiento documental de la Unidad 03 contra el contrato cerrado;
- reutilización de `platform-api`, `platform-training` y `labs/02-configuration-lifecycle/solution/`;
- laboratorio existente en `labs/03-networking-ingress/`, sin cambios durante fase 4;
- conservación del Service `platform-api` como `ClusterIP`;
- recurso `Ingress` HTTP existente para host `platform-api.local`;
- uso de `ingressClassName: public` como detalle del laboratorio MicroK8s ya generado;
- explicación de red de Pods, CNI como interfaz conceptual, Service, EndpointSlice y DNS interno;
- explicación de Ingress Controller frente a recurso `Ingress`;
- criterio profesional sobre `LoadBalancer`, MetalLB, anotaciones de controlador, TLS, certificados, `cert-manager` y Gateway API;
- diagnóstico de conectividad por capas en `student-notes.md`;
- cierre documental de `GAP-003` en `student-reference.md` y `summary.md`;
- actualización de `project/project-state.md` al cierre documental.

## Excluido

- generación de Unidad 08;
- creación de workloads nuevos;
- modificación de laboratorios de Unidades 01-07;
- modificación de manifiestos Kubernetes, scripts de validación o scripts de `platform/environment/`;
- ejecución de validaciones funcionales nuevas durante el saneamiento;
- creación de charts Helm o módulos Terraform;
- instalación o configuración de Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- cambio del Service a `NodePort` o `LoadBalancer`;
- instalación o configuración de MetalLB;
- creación de recursos `GatewayClass`, `Gateway` o `HTTPRoute`;
- introducción de TLS práctico, certificados, `cert-manager`, ACME, PKI corporativa o secretos TLS reales;
- introducción de NetworkPolicies, service mesh o mTLS;
- sustitución de `platform-api` o creación de namespaces funcionales alternativos;
- introducción de Minikube, kind o Docker Desktop Kubernetes como plataforma paralela.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Persistencia con PV, PVC y StorageClass | Unidad 04 | Requiere aplicación ya accesible y diagnosticable |
| Scheduling, PDB, mantenimiento y resiliencia | Unidad 05 | Requiere workload expuesto y observable |
| Empaquetado de Ingress y manifiestos acumulados con Helm | Unidad 06 | Requiere estado declarativo estable |
| Automatización local con Terraform | Unidad 07 | Requiere chart Helm funcional |
| Gestión real de secretos y automatización GitOps | Unidad 09 | Requiere decidir qué puede ir a Git y qué debe venir de un gestor externo |
| Promoción entre entornos y variación de hosts/rutas | Unidad 10 | Requiere layout declarativo y GitOps |
| Observabilidad de tráfico de entrada, SLI/SLO y alertas | Unidades 11-15 | Requiere pila de observabilidad |
| NetworkPolicies, service mesh y mTLS | Unidad 16 y seguridad posterior | Requiere baseline funcional antes de restringir tráfico |
| MetalLB, `LoadBalancer`, desacoplamiento de MicroK8s y portabilidad cloud | Unidad 19 | Encaja en la auditoría de supuestos locales antes de AKS/EKS |
| Entrada cloud, DNS, balanceadores gestionados e identidad | Unidades 20-21 | Requiere plataformas gestionadas |
| Gateway API como estándar de plataforma y delegación multi-equipo | Unidad 24 | Requiere modelo operativo y gobierno de plataforma |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar y diagnosticar el laboratorio: cadena de recursos, comprobaciones de Pod, Service, EndpointSlice, DNS interno, controlador, regla `Ingress`, prueba HTTP, fallos típicos y recuperación.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: CNI como interfaz de red, límites de Pod IP y `ClusterIP`, entrada local frente a entrada productiva, `LoadBalancer` y MetalLB, anotaciones específicas de controladores, TLS, certificados, `cert-manager`, Gateway API, cloud y criterios de migración.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta. El diagnóstico de fallos del laboratorio pertenece a `student-notes.md`; los errores de concepto pertenecen a `student-reference.md`.

## Laguna asignada

```text
GAP-003 - TLS, cert-manager e Ingress/Gateway API
```

La unidad cierra documentalmente `GAP-003` mediante `tutorial/03-networking-ingress/student-reference.md`: TLS, certificados, `cert-manager`, terminación TLS, diferencias entre Ingress y Gateway API y criterio de migración quedan explicados como referencia profesional sin cambiar el laboratorio local.

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 03 |
|---|---|
| Panorama | Situar networking de Kubernetes, CNI, Service, Ingress, `LoadBalancer`, MetalLB, TLS, certificados, cloud y Gateway API |
| Profundidad | Explicar la cadena Pod IP -> Service -> EndpointSlice -> DNS -> Ingress Controller -> `Ingress` -> cliente |
| Criterio | Decidir cuándo basta Ingress, cuándo considerar Gateway API, cuándo usar `LoadBalancer`, qué implica MetalLB y cuándo introducir TLS |
| Práctica | Nombrar distancias con producción: HTTP local, host de laboratorio, addon MicroK8s, sin DNS público, sin certificados, sin MetalLB y sin entrada cloud |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| HTTP local sin TLS | Normalizar tráfico sin identidad ni cifrado | TLS con certificados gestionados, terminación definida, renovación y control de claves |
| Host `platform-api.local` probado con cabecera `Host` | Confundir routing HTTP con DNS real | DNS público o privado gestionado y resolución coherente con el punto de entrada |
| Addon Ingress de MicroK8s con clase `public` | Extrapolar una implementación local a todos los clústeres | Controlador elegido por plataforma, clase documentada, operación y observabilidad |
| Service conservado como `ClusterIP` | Creer que Ingress sustituye al Service | Service interno como backend estable; entrada como capa HTTP separada |
| No se instala MetalLB | No comprender por qué `LoadBalancer` puede quedar `Pending` en local | Explicar MetalLB como simulación L2 local, no como requisito de esta práctica |
| No se usan anotaciones avanzadas | Copiar anotaciones de NGINX/Traefik como si fueran estándar | Tratar CORS, rewrite, rate limit y body size como capacidades específicas del controlador |
| No se crea Gateway API | Presentar Gateway API como reemplazo automático | Explicar separación de roles, madurez del controlador y criterio de adopción |

## Uso de `project/coverage-map.md`

La sección de Unidad 03 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se absorben en el contrato documental de esta unidad sin copiar su estructura:

| Punto de `project/coverage-map.md` | Clasificación | Tratamiento |
|---|---|---|
| Modelo de red K8s y CNI | Criterio conceptual | Cubierto en referencia como red IP-per-Pod, CNI y límite de administración en MicroK8s |
| Exposición y enrutamiento base con Ingress Controller e `Ingress` | Práctica existente del laboratorio | Cubierto por `labs/03-networking-ingress/solution/ingress.yaml` y diagnóstico en notas |
| MetalLB para simular `LoadBalancer` local | Criterio profesional y exclusión práctica | Explicado en referencia; no se instala ni se cambia el Service durante fase 4 |
| Anotaciones avanzadas de NGINX | Criterio profesional | Explicadas como extensiones específicas de controlador; el laboratorio no las practica |
| TLS local, secretos TLS y automatización con autoridades simuladas | Criterio profesional y laguna `GAP-003` | Cubierto en referencia mediante TLS, Secret TLS, terminación y `cert-manager`; sin certificados ni claves en el repo |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `project/project-state.md`;
2. `README.md`;
3. `project/architecture.md`;
4. `project/project-state.md`;
5. `project/roadmap.md`;
6. `project/how-to.md`;
7. `project/project-planning.md`;
8. `project/content-gap-register.md`;
9. `playbooks/master.md`;
10. `playbooks/unit-template.md`;
11. `playbooks/student-reference-template.md`;
12. `playbooks/summary-template.md`;
13. `playbooks/project-state-template.md`;
14. `playbooks/units/03-networking-ingress.md`;
15. sección de Unidad 03 en `project/coverage-map.md`;
16. `tutorial/02-configuration-lifecycle/summary.md`;
17. `tutorial/03-networking-ingress/README.md`;
18. `tutorial/03-networking-ingress/student-notes.md`;
19. `tutorial/03-networking-ingress/student-reference.md`;
20. `tutorial/03-networking-ingress/summary.md`;
21. `labs/03-networking-ingress/README.md`;
22. `labs/03-networking-ingress/solution/`.

## Excepciones

Ninguna. La Unidad 02 está cerrada y existe `tutorial/02-configuration-lifecycle/summary.md`.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- historial del saneamiento consolidado en `project/project-state.md`;
- `tutorial/02-configuration-lifecycle/summary.md`;
- artefactos actuales de la Unidad 03;
- registro de lagunas `project/content-gap-register.md`;
- `project/coverage-map.md` como checklist, no como estructura.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Entorno local | Heredado de Unidad 00 | Evidencia registrada en `tutorial/00-environment/summary.md` y `project/project-state.md` |
| `platform-api` configurada | Generada en Unidad 02 | Evidencia registrada en `tutorial/02-configuration-lifecycle/summary.md` |
| Namespace `platform-training` | Conservado | `labs/03-networking-ingress/solution/namespace.yaml` |
| Service `platform-api` | Declarado como `ClusterIP` | `labs/03-networking-ingress/solution/service.yaml` |
| Ingress `platform-api` | Disponible como manifiesto de solución | `labs/03-networking-ingress/solution/ingress.yaml` |
| Validación de Unidad 03 | Existente, no ejecutada en saneamiento | `labs/03-networking-ingress/validation/validate.sh` |

Durante el saneamiento documental de fase 4 no se ejecutan validaciones funcionales nuevas.

## Dependencias pedagógicas

- el alumno entiende el modelo declarativo básico de Unidades 01 y 02;
- el alumno puede leer YAML de Kubernetes con guía;
- el alumno distingue configuración, salud, Service y EndpointSlice;
- la referencia debe corregir extrapolaciones inseguras del laboratorio local.

---

# Entregables

## Documentación del alumno

| Entregable | Ruta | Responsabilidad |
|---|---|---|
| Tutorial principal | `tutorial/03-networking-ingress/README.md` | Puerta de entrada conceptual de la unidad |
| Student notes | `tutorial/03-networking-ingress/student-notes.md` | Acompañamiento del laboratorio, observación y diagnóstico |
| Student reference | `tutorial/03-networking-ingress/student-reference.md` | Referencia profesional autosuficiente según contrato |
| Summary | `tutorial/03-networking-ingress/summary.md` | Contrato de continuidad con Unidad 04 |

## Artefactos de laboratorio existentes

| Entregable | Ruta | Responsabilidad |
|---|---|---|
| Laboratorio | `labs/03-networking-ingress/README.md` | Instrucciones operativas |
| Starter | `labs/03-networking-ingress/starter/` | Punto de partida guiado |
| Solution | `labs/03-networking-ingress/solution/` | Estado final reutilizable por Unidad 04 |
| Validación | `labs/03-networking-ingress/validation/validate.sh` | Comprobación no destructiva existente |

Durante esta fase no deben modificarse estos artefactos de laboratorio.

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

siguiendo:

```text
playbooks/project-state-template.md
```

`project/content-gap-register.md` solo debe cambiar si se ajusta una laguna existente. Para Unidad 03 no se prevé cambio obligatorio: `GAP-003` ya está cerrada y debe confirmarse sin reabrirla.

---

# Criterios de aceptación del saneamiento

La Unidad 03 queda conforme cuando:

- el playbook declara `student-reference.md` como entregable y respeta la plantilla global;
- el playbook declara la frontera entre `student-notes.md` y `student-reference.md`;
- el playbook declara `GAP-003` como laguna cerrada documentalmente por la referencia;
- la referencia conserva la estructura canónica de `playbooks/student-reference-template.md`;
- la referencia cubre CNI, Pod IP, Service, EndpointSlice, DNS interno, Ingress Controller, `Ingress`, `LoadBalancer`, MetalLB, anotaciones de controlador, TLS, certificados, `cert-manager`, Gateway API y cloud como criterio profesional;
- `student-notes.md` queda centrado en la práctica y diagnóstico del laboratorio;
- el `README.md` remite claramente a notas y referencia sin duplicar toda la referencia;
- `summary.md` registra el saneamiento documental y distingue validaciones históricas de validaciones no ejecutadas en esta fase;
- `project/project-state.md` registra el incremento y el siguiente paso permitido;
- no se modifican `labs/03-networking-ingress/`, laboratorios de otras unidades, scripts ni manifiestos Kubernetes;
- no se crean workloads nuevos;
- no se ejecutan validaciones funcionales nuevas.

---

# Validaciones permitidas durante fase 4

Permitidas:

```bash
git diff --check
git status --short
rg -n "..." <rutas documentales>
```

No permitidas en este incremento salvo instrucción posterior explícita:

```bash
bash labs/03-networking-ingress/validation/validate.sh
kubectl apply -f labs/03-networking-ingress/solution/
kubectl -n platform-training rollout status deployment/platform-api
microk8s status --wait-ready
kubectl get nodes
```

---

# Cierre esperado

Al cerrar el saneamiento de la Unidad 03:

- `playbooks/units/03-networking-ingress.md` queda regenerado contra contrato documental;
- `tutorial/03-networking-ingress/README.md` queda alineado con el playbook;
- `tutorial/03-networking-ingress/student-notes.md` queda alineado con la frontera de notas;
- `tutorial/03-networking-ingress/student-reference.md` queda ajustado contra la plantilla global;
- `tutorial/03-networking-ingress/summary.md` registra el saneamiento y sus límites;
- `project/project-state.md` registra el incremento;
- `project/content-gap-register.md` queda sin cambios salvo que se detecte una laguna que deba ajustarse;
- Unidad 08 sigue congelada;
- la siguiente unidad de saneamiento permitida es la Unidad 05.
