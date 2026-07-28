# Mapa de cobertura

## Propósito

Este documento recoge la cobertura candidata de profundidad para las unidades del itinerario.

Su función es aportar granularidad al diseño de unidades y servir como checklist de cobertura al generar playbooks, referencias y cierres. No sustituye a `project/roadmap.md`, `project/project-state.md`, `project/content-gap-register.md`, `project/advanced-labs-register.md` ni a los playbooks específicos de unidad.

Este documento no realiza ese reparto: expresa la cobertura candidata, y la clasificación de cada punto se decide al generar cada unidad, contra su alcance real. Un punto puede figurar aquí con una intención y resolverse en otra categoría si el alcance de la unidad no lo admite.

Cuando exista tensión entre este mapa y el roadmap o el estado consolidado, se aplica la precedencia documental del proyecto. Cada punto de este mapa debe repartirse contra el alcance real de la unidad como:

- práctica;
- criterio;
- diferido;
- candidato a laboratorio avanzado;
- fuera del itinerario.

El resultado de ese reparto debe quedar registrado en el playbook de la unidad afectada.

---

# Contenido


## 📂 BLOQUE 1: PREPARACIÓN Y FUNDAMENTOS 

## 00 | Preparación del entorno

* Aislamiento y virtualización base: Instalación de WSL2 (Ubuntu 22.04+) en Windows y comandos esenciales de administración de la distribución.
* Optimización avanzada del Host: Configuración fina del archivo %USERPROFILE%\.wslconfig (límites estrictos de CPU, asignación de memoria RAM, swap y vhd compacting) para mitigar el agotamiento de memoria del sistema anfitrión.
* Despliegue e inicialización de MicroK8s: Instalación mediante snap, gestión de grupos de usuarios del sistema y activación de add-ons base (dns, rbac).
* Gestión avanzada de la API Server local: Configuración de argumentos del plano de control en /var/snap/microk8s/current/args/ (ej. ajustar rangos de puertos de servicios o activar feature gates).
* Tooling e interoperabilidad: Instalación de binarios independientes (kubectl, helm, terraform). Configuración avanzada del archivo kubeconfig para la conmutación segura de contextos (kubectx/kubens) y validación de comunicación TLS con el API Server.

## 01 | Fundamentos operativos y primera aplicación

* Arquitectura del plano de control: Flujo detallado de una petición (de kubectl a Dqlite/etcd). Comparativa interna entre el almacenamiento local embebido y los clústeres distribuidos en producción.
* Aislamiento y jerarquía lógica: Creación de Namespaces. Aplicación avanzada de etiquetas (labels) y anotaciones corporativas para el control de ciclo de vida de los recursos.
* Despliegue atómico e inyección básica: Anatomía de un Pod, el rol del kubelet y del Container Runtime (containerd). Despliegue de la aplicación descriptiva platform-api.
* Abstracción de resiliencia y controladores: Configuración de ReplicaSets para el control de réplicas. Evolución hacia la especificación de un Deployment.
* Estrategias de despliegue avanzadas: Diferencias conceptuales e implementación de estrategias Recreate frente a RollingUpdate (ajuste fino de maxSurge y maxUnavailable).
* Descubrimiento e interconexión interna: Creación de un Service de tipo ClusterIP. Funcionamiento interno de CoreDNS y flujos de resolución de nombres de dominio internos (FQDN).

## 02 | Configuración, secretos y ciclo de vida

* Inyección de entorno base: Creación y montaje de ConfigMaps como variables de entorno unificadas y como archivos volumétricos estructurados.
* Datos sensibles locales vs producción: Creación de Secrets nativos en Base64. Análisis de sus fallas de seguridad intrínsecas (falta de cifrado en reposo) y mitigación en local.
* Ciclo de vida y resiliencia de procesos: Configuración secuencial de Probes: Startup (para arranques pesados), Readiness (control de tráfico del servicio) y Liveness (auto-recuperación ante bloqueos).
* Planificación del consumo y gobernanza de recursos: Configuración estricta de requests y limits de CPU y memoria. Análisis del comportamiento del kernel ante saturación (CPU Throttling frente a desalojo por falta de memoria OOMKilled).
* Clases de Calidad de Servicio (QoS): Impacto de las configuraciones de recursos en la clasificación del Pod (Guaranteed, Burstable, BestEffort) y su prioridad de supervivencia en el clúster.
* Terminación controlada (Graceful Shutdown): Gestión del ciclo de vida del borrado del Pod (SIGTERM, ejecución de scripts de limpieza vía preStop hooks y control del terminationGracePeriodSeconds).

------------------------------
## 🌐 BLOQUE 2: REDES, PERSISTENCIA Y RESILIENCIA 

## 03 | Networking e ingreso

* Modelo de red K8s y CNI: Principios del direccionamiento IP por Pod (IP-per-Pod) y comunicación inter-pod mediante el Container Network Interface (Calico/Flannel en MicroK8s).
* Exposición y enrutamiento base: Activación del Ingress Controller NGINX nativo en MicroK8s. Creación de recursos Ingress con enrutamiento basado en rutas HTTP (/api) y resolución local mediante el archivo hosts del host.
* El "Efecto LoadBalancer" en local: Configuración e instalación de MetalLB en modo Capa 2 para simular la asignación de IPs públicas en un entorno local y evitar el estado eterno <pending>.
* Gestión de tráfico avanzada en Ingress: Configuración de anotaciones avanzadas de NGINX (CORS, reescritura de paths con rewrite-target, límites de tasa de transferencia rate-limiting y tamaños máximos de cuerpo de petición).
* Seguridad y cifrado perimetral: Generación y gestión de certificados TLS locales integrados en el objeto Ingress mediante secretos TLS y automatización inicial con autoridades certificadoras simuladas.

## 04 | Persistencia y estado

* Estrategias de almacenamiento corporativo: Diferencias entre almacenamiento efímero (emptyDir) y persistente. Análisis de los modos de acceso (ReadWriteOnce, ReadOnlyMany, ReadWriteMany).
* Abstracción y aprovisionamiento base: Uso del objeto PersistentVolumeClaim (PVC) y el funcionamiento del aprovisionamiento dinámico mediante la StorageClass por defecto microk8s-hostpath.
* Arquitectura de desacoplamiento para Cloud: Diseño de manifiestos agnósticos mediante la parametrización del nombre de la StorageClass. Cómo preparar la carga de trabajo para cambiar de un disco local a plugins CSI en la nube (Azure Disk o AWS EBS) sin alterar la lógica de negocio.
* Políticas de reciclaje y estado huérfano: Configuración avanzada de políticas de retención (Retain frente a Delete) de los PersistentVolumes (PV) generados dinámicamente.
* Pruebas de resistencia y consistencia de datos: Simulación de fallos físicos catastróficos: borrado destructivo de pods con estado y verificación de la reasociación automática del volumen y consistencia de la información tras la recreación.

## 05 | Scheduling, resiliencia y mantenimiento

* Mecánica interna del planificador: Funcionamiento del componente kube-scheduler (fases de filtrado y puntuación) y asignación básica mediante nodeSelector.
* Algoritmos de distribución avanzados: Implementación de reglas complejas de afinidad y antiafinidad (nodeAffinity, podAffinity, podAntiAffinity) utilizando expresiones duras (requiredDuringSchedulingIgnoredDuringExecution) y blandas (preferredDuringSchedulingIgnoredDuringExecution).
* Aislamiento y restricciones de infraestructura: Aplicación de Taints (restricciones en nodos) y Tolerations (permisos especiales en pods) para asegurar la segregación de cargas de trabajo (ej. evitar que aplicaciones web corran en nodos destinados a bases de datos).
* Garantías de disponibilidad operativa (PDB): Creación de un PodDisruptionBudget para mitigar caídas imprevistas del servicio durante procesos de mantenimiento automatizados o actualizaciones de infraestructura.
* Operaciones de infraestructura sin fricción: Simulación de evacuación, aislamiento y mantenimiento controlado de un nodo de clúster utilizando los comandos drain, cordon y uncordon.

## 🤖 BLOQUE 3: AUTOMATIZACIÓN, PAQUETIZACIÓN Y CI/CD 

## 06 | Empaquetado con Helm

* Fundamentos de empaquetado: Estructura de directorios estándar (templates/, values.yaml, Chart.yaml). Creación, ciclo de vida y comandos esenciales (helm lint, helm template, helm install/upgrade).
* Parametrización dinámica base: Conversión de manifiestos planos de platform-api mediante funciones de plantilla Go esenciales (.Values, .Release.Name). Control de flujo con condicionales (if/else) y bucles (range).
* Procesamiento de datos avanzado: Uso de toYaml, indent, nindent y el motor tpl para renderizar configuraciones complejas (como inyectar bloques dinámicos de ConfigMaps en variables de entorno). Manipulación de colecciones con merge y control estricto de nulos.
* Composición mediante Subcharts: Gestión de dependencias en Chart.yaml. Diseño de herencia (parent/child) pasando valores hacia abajo con la propiedad global y sobreescribiendo valores del subchart desde el raíz.
* Patrón Umbrella Chart: Configuración de un chart único para orquestar la topología completa (platform-api + base de datos auxiliar como subchart) con activación/desactivación dinámica vía tags (condition: redis.enabled).
* Hooks, validación y rollback: Implementación de helm.sh/hook (pre-install para migraciones de BD) y políticas de borrado. Pruebas funcionales pos-despliegue con helm test. Manejo de estados de releases (Secrets binarios) y ejecución de helm rollback.

## 07 | Automatización local con Terraform

* Diseño de código base y autenticación: Configuración del bloque terraform y definición de proveedores (kubernetes, helm). Conexión al clúster MicroK8s abstrayendo las rutas del kubeconfig mediante autenticación dinámica (extrayendo credenciales del output del recurso del clúster).
* Despliegue e idempotencia base: Declaración del recurso helm_release para orquestar la instalación del Chart local. Gestión de variables y análisis del archivo de estado local terraform.tfstate.
* Estructuras de datos complejas: Modelado de variables (object, map) y bloques validation {} (ej. restringir nombres de entorno a local, aks, eks). Uso de expresiones for_each y dynamic blocks para inyectar valores dinámicamente sin destruir el release.
* Gestión del estado y secretos: Configuración de backends (locales vs remotos simulados). Uso de variables marcadas como sensitive = true y estrategias para evitar la filtración de contraseñas y tokens en texto plano dentro del .tfstate. Recuperación de estados corruptos o bloqueados (terraform force-unlock).
* Outputs y ciclo de vida: Extracción automatizada de URLs, IPs y datos de depuración tras el apply. Uso avanzado de directivas de ciclo de vida (create_before_destroy, prevent_destroy, ignore_changes) en recursos críticos.

## 08 | Integración continua con Tekton

* Modelo nativo y bloques base: Arquitectura basada en CRDs de Kubernetes. Definición y ejecución secuencial de componentes esenciales: Task, Pipeline, TaskRun y PipelineRun.
* Persistencia e intercambio de estado: Configuración de Workspaces usando PVCs locales para compartir el código clonado entre tareas. Uso de VolumeClaimTemplates avanzados para aprovisionar PVCs dinámicos por cada ejecución (PipelineRun), controlando el ciclo de vida de los datos temporales del build.
* Composición y reutilización: Creación de tareas modulares (clonar Git, linter, tests, build de imagen). Paso de parámetros estructurados (array, object) y captura de salidas mediante results para alimentar pasos condicionales.
* Lógica condicional y seguridad: Implementación de expresiones When (ej. compilar la imagen de Docker solo si el commit pertenece a la rama main o tiene un Tag de versión). Configuración de ServiceAccounts corporativas con roles de mínimo privilegio para interactuar de forma segura con el API Server.

## 09 | GitOps con Argo CD

* Filosofía e instalación base: Principios del estado deseado (Git) frente al estado actual (Clúster). Despliegue e inicialización declarativa de Argo CD en el clúster local.
* Patrón App-of-Apps: Configuración de una aplicación raíz que orquesta de forma declarativa el catálogo completo de microservicios y dependencias de la plataforma.
* Sincronización avanzada y Sync Waves: Configuración de políticas de sincronización (Automated, Prune, SelfHeal). Control estricto del orden de despliegue usando anotaciones de ondas (argocd.argoproj.io/sync-wave) para asegurar que Namespaces, CRDs y Secretos se creen antes que las aplicaciones o los Ingress.
* Gestión de desvíos (Drift) y Plugins (CMP): Detección de modificaciones manuales en el clúster y auto-remediación. Uso de ignoreDifferences para ignorar mutaciones esperadas hechas por el HPA o inyecciones de sidecars de terceros. Configuración de Plugins de Configuración Personalizados para combinar herramientas como Kustomize + Helm.

## 10 | Promoción entre entornos

* Estructura y gestión base: Estrategias de organización del código de infraestructura por directorios o ramas para entornos de testing, staging y producción.
* Uso avanzado de Kustomize (Patches): Creación de una base común y personalización por entorno mediante capas (overlays). Uso de parches estructurados JSON6902 y parches estratégicos de fusión (strategicMergePatches) para alterar secciones específicas (ej. modificar réplicas, dominios de Ingress, inyectar sidecars o alterar políticas de afinidad según el entorno).
* Flujos de promoción automatizados: Diseño del ciclo de vida del código de infraestructura. Automatización de actualizaciones de tags de imágenes en el repositorio de GitOps tras un build exitoso (usando herramientas de actualización declarativa como Renovate o Argo CD Image Updater).
* Trazabilidad y auditoría: Control y auditoría de despliegues basándose en hashes de commits de Git visibles en el panel de Argo CD, asegurando la correlación total entre el código fuente y el clúster.

------------------------------
## 📊 BLOQUE 4: OBSERVABILIDAD INTEGRADA

## 11 | Métricas con Prometheus y OpenMetrics

* Arquitectura y despliegue base: Modelo de recolección basado en Pull (Scraping) y series temporales. Despliegue de la pila kube-prometheus-stack mediante Helm. Análisis de métricas base de la plataforma (CPU de nodos, memoria de Pods, saturación).
* Descubrimiento dinámico mediante operadores: Configuración fina de los CRDs ServiceMonitor y PodMonitor para automatizar el descubrimiento de servicios. Uso avanzado de relabelings y metricRelabelings vía expresiones regulares para filtrar o descartar métricas ruidosas de alto volumen en origen.
* Fundamentos y consultas PromQL avanzadas: Introducción práctica a filtros y agregaciones esenciales. Evolución hacia álgebra de vectores y consultas complejas (cálculo de tasas de error relativas en ventanas de tiempo deslizantes, emparejamiento de etiquetas vectoriales mediante on(), ignoring(), group_left() para correlacionar métricas de plataforma con métricas de negocio).
* Definición de Alertas y Alta Disponibilidad: Creación de reglas de alerta estables (PrometheusRule) minimizando el ruido mediante el ajuste de la cláusula for, severidades y enrutamiento en el Alertmanager. Introducción conceptual a arquitecturas multi-clúster y almacenamiento a largo plazo (Thanos/Cortex).

## 12 | Visualización y alertas con Grafana

* Gestión y diseño de tableros base: Configuración manual e intuitiva de Prometheus como Datasource. Creación paso a paso de un Dashboard para monitorizar el estado de la infraestructura y los recursos de platform-api.
* Provisionamiento Declarativo (Dashboards as Code): Automatización total del despliegue de Grafana cargando archivos JSON de tableros y datasources a través de ConfigMaps locales y el patrón Sidecar de Grafana, eliminando la interacción manual con la UI.
* Estrategia de Alertas y Notificaciones: Configuración de reglas basadas en umbrales de saturación y rutas de notificación hacia canales de mensajería (Slack, Discord, Webhooks).
* Matemática de Presupuestos de Error (SLI/SLO): Definición conceptual y modelado matemático de Indicadores de Nivel de Servicio (SLIs) y Objetivos de Nivel de Servicio (SLOs) (ej. 99.5% de éxito). Cálculo en tiempo real de la velocidad de quema del presupuesto de error (Error Budget Burn Rate) para disparar alertas proactivas antes de impactar al usuario.

## 13 | Logs con Loki

* Arquitectura distribuida y recolección base: Componentes de la pila Loki. Configuración de Promtail o FluentBit como agentes de recolección locales para capturar el stdout/stderr de los contenedores en MicroK8s.
* Ingeniería de indexación y diseño de Labels: Mitigación del antipatrón de alta cardinalidad en Loki. Diseño eficiente de etiquetas estáticas y dinámicas (ej. diferenciar labels de infraestructura como node de labels de aplicación como app_name).
* Fundamentos y sintaxis avanzada de LogQL: Consultas base de coincidencia de texto. Evolución hacia expresiones avanzadas de filtrado, formateo de flujos estructurados JSON en caliente y uso de selectores de etiquetas de flujo.
* Generación de métricas a partir de Logs: Transformación de líneas de log no estructuradas en series temporales en tiempo real (uso de funciones como count_over_time y rate) para monitorizar excepciones de código o códigos de estado específicos de la aplicación.
* Análisis forense y optimización cloud: Uso de filtros temporales y expresiones regulares para aislar e identificar errores en cascada. Preparación del almacenamiento persistente de Loki (pasando de discos locales a Object Storage como Azure Blob o AWS S3 para AKS/EKS).

## 14 | Trazas con Tempo y OpenTelemetry

* Conceptos de trazado y propagación base: Ciclo de vida de un Span, Trace ID, Parent ID y mecanismos estándar de propagación de contexto en cabeceras de peticiones HTTP (W3C Trace Context).
* Arquitectura del OpenTelemetry (OTel) Collector: Configuración del colector unificado como un Deployment (o un DaemonSet) en MicroK8s. Diseño de pipelines internos en el archivo de configuración del colector (receivers, processors, exporters).
* Ingesta avanzada en Grafana Tempo: Configuración de Tempo para recibir trazas en formato nativo OTLP (OpenTelemetry Protocol). Estrategias de muestreo (Sampling en cabecera y en cola) para controlar el volumen de trazas transferidas en entornos de alta concurrencia.
* Instrumentación de código (Agnóstica): Configuración práctica de platform-api (mediante SDKs automáticos de OTel o librerías de lenguaje) para emitir trazas directas al colector sin acoplar la aplicación a un proveedor específico de trazas.
* Visualización extremo a extremo: Rastreo visual de una petición distribuida en la interfaz de Grafana. Identificación de cuellos de botella de rendimiento, bloqueos en llamadas a APIs externas o consultas lentas a bases de datos.

## 15 | Observabilidad operativa integrada

* Correlación unificada de telemetría (Data Links): Configuración declarativa en Grafana de enlaces cruzados basados en metadatos comunes. Cómo saltar con un solo clic de una alerta de métricas en Prometheus, al stream de logs exacto en Loki, y de ahí al ID de traza específico en Tempo.
* Creación de Runbooks e incidentes: Diseño de documentación operativa en vivo y guías de respuesta vinculadas directamente a los metadatos de las alertas de producción generadas en bloques previos.
* Simulación de incidentes y validación visual: Inyección controlada de errores en el entorno local (p. ej., inyectar latencia artificial mediante políticas de red o causar excepciones simuladas de conexión a la base de datos).
* Diagnóstico de causa raíz en tiempo real: Uso práctico del dashboard unificado de la plataforma por parte del alumno para rastrear y documentar paso a paso el origen exacto de un incidente simulado en el clúster.
* Gobernanza de dashboards corporativos: Organización y restricción de acceso a los tableros operativos de Grafana por entornos, aplicando carpetas compartidas y control de acceso basado en roles (RBAC integrado).

------------------------------
## 🛡️ BLOQUE 5: SEGURIDAD, POLÍTICAS Y ESCALADO 

## 16 | Seguridad de workloads y acceso

* Control de accesos base (RBAC): Creación y asignación de permisos mediante los recursos estándar Roles, ClusterRoles, RoleBindings y ClusterRoleBindings.
* Identidades de procesos e isolation: Uso de ServiceAccounts personalizadas (anulando el token por defecto montado en los Pods). Restricciones a nivel de contenedor mediante el securityContext base (correr como usuario no-root, solo lectura en el sistema de archivos).
* Estándares y restricciones del Kernel (PSS): Aplicación de Pod Security Standards en niveles Baseline y Restricted. Configuración avanzada del kernel (restricción de capacidades de Linux con capabilities: drop: ["ALL"], deshabilitación de la escalada de privilegios y uso de perfiles de AppArmor/Seccomp integrados en MicroK8s).
* Aislamiento de Red Zero-Trust: Principios de direccionamiento e implementación de NetworkPolicies base. Evolución hacia un modelo Zero-Trust: bloqueo general de tráfico por defecto (Default Deny All) en el Namespace y apertura granular de flujos Ingress/Egress basados exclusivamente en selectores de pods (podSelector) y puertos de bases de datos.

## 17 | Políticas y seguridad de la cadena de suministro

* Validación as-code y Admisión base: Introducción a motores de políticas webhook ([Kyverno](https://kyverno.io/) o [OPA/Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/)). Bloqueo básico de imágenes con el tag :latest.
* Arquitectura de Admisión Webhook Avanzada: Comprensión de las fases internas de Mutación y Validación de Kubernetes. Escritura de reglas complejas para interceptar y rechazar en caliente recursos que intenten montar directorios del host (hostPath) sin autorización (evitando ataques de escape de contenedor).
* Transparencia y Firma Criptográfica (Supply Chain): Generación del Software Bill of Materials (SBOM) en el pipeline de CI. Firma de imágenes con herramientas criptográficas de código abierto (Cosign).
* Verificación en tiempo de ejecución: Configuración del webhook de admisión para descifrar y validar las firmas de las imágenes en tiempo real contra llaves públicas corporativas, impidiendo la ejecución de cualquier contenedor alterado o no firmado.

## 18 | Escalado con HPA y KEDA

* Métricas nativas y escalado clásico: Despliegue del componente metrics-server en MicroK8s. Configuración de un HorizontalPodAutoscaler (HPA) clásico basado en consumo medio de CPU/Memoria, definiendo límites mínimos y máximos de réplicas.
* Matemática Interna del HPA: Estudio detallado del algoritmo de escalado del controlador:
$$\text{Replicas Deseadas} = \lceil \text{Replicas Actuales} \times \frac{\text{Valor Métrica Actual}}{\text{Valor Métrica Objetivo}} \rceil$$ 
* Configuración de políticas de estabilización (scaleUp / scaleDown stabilization windows) para evitar el comportamiento de "Trashing" (creación y destrucción infinita de pods por picos de carga altamente variables).
* Escalado por Eventos (KEDA): Arquitectura, instalación y conceptos de KEDA. Configuración de escaladores avanzados (Triggers) basados en colas de mensajes externos o consultas PromQL complejas (ej. escalar la API según el ratio de retardo en el procesamiento de colas o conexiones HTTP activas simultáneas).
* Pruebas de estrés: Generación de carga artificial para documentar y observar en vivo el comportamiento de ambos motores de escalado.

------------------------------
## ☁️ BLOQUE 6: MIGRACIÓN Y ENTORNOS CLOUD 

## 19 | Fundamentos de migración a cloud

* Auditoría de acoplamiento local: Identificación y aislamiento de configuraciones acopladas a MicroK8s (rutas hostPath, configuraciones de red internas y dependencias de plugins locales).
* Agnosticismo absoluto de configuración: Refactorización de manifiestos para eliminar nombres de DNS acoplados al dominio local por defecto de Kubernetes (.cluster.local).
* Estrategia de portabilidad de APIs: Evaluación de la matriz de compatibilidad de versiones de las APIs de Kubernetes (v1, apps/v1, networking.k8s.io/v1) entre MicroK8s y las versiones administradas en la nube de destino.
* Migración de estado y datos persistentes: Diseño estratégico para la extracción, empaquetado y transferencia segura de volúmenes persistentes locales hacia sistemas de almacenamiento gestionados en la nube.

## 20 | Despliegue en AKS (Azure)

* Aprovisionamiento de infraestructura cloud: Estructura modular de código de Terraform para la creación del clúster AKS, configuración de node pools híbridos y un registro privado Azure Container Registry (ACR).
* Arquitectura de red e identidad avanzada: Configuración avanzada de Azure CNI (asignación dinámica de IPs de la red corporativa) e integración nativa de Azure Workload Identity mediante OpenID Connect (OIDC).
* Abstracción de almacenamiento e Ingress cloud: Sustitución de la StorageClass local por la nativa managed-csi (Azure Disks/Files). Configuración de Ingress integrada con Azure Application Gateway (AGIC) o balanceadores de carga públicos de Azure.
* Despliegue unificado GitOps: Conexión de la instancia remota de AKS al flujo de trabajo de Argo CD preconfigurado en local, demostrando la portabilidad inmediata de la aplicación mediante la inyección de los perfiles específicos de desarrollo/producción.

## 21 | Despliegue en EKS (AWS)

* Aprovisionamiento modular en AWS: Uso de módulos de Terraform para la creación de una VPC multi-AZ, subredes públicas/privadas y el clúster Amazon EKS junto con Managed Node Groups.
* Desacoplamiento de accesos e identidad (IRSA): Configuración avanzada de IAM Roles for Service Accounts (IRSA). Vinculación de roles de AWS IAM a las ServiceAccounts nativas de Kubernetes mediante anotaciones de metadatos, eliminando el uso de llaves de acceso estáticas.
* Inyección de controladores CSI y balanceo de AWS: Instalación automatizada vía Helm del AWS EBS CSI Driver y del AWS Load Balancer Controller. Adaptación del objeto Ingress local para aprovisionar dinámicamente un Application Load Balancer (ALB) corporativo.
* Sincronización y cierre del bucle: Integración con Amazon ECR mediante autenticación nativa de nodos y despliegue final controlado de la aplicación mediante el motor de GitOps unificado.

## 22 | Comparativa operativa MicroK8s, AKS y EKS

* Arquitectura profunda del plano de control: Diferencias operativas y de resiliencia entre el modelo monolítico integrado de MicroK8s y los planos de control distribuidos y altamente disponibles gestionados por los proveedores de nube.
* Análisis económico de plataforma: Modelado financiero y de costes ocultos en entornos reales (costes por plano de control, computación bajo demanda vs instancias spot, transferencias de datos inter-zona, balanceadores de carga e IPs asignadas).
* Ciclo de vida y parches de infraestructura: Estrategias de actualización de versiones mayores del clúster (Upgrades) en local frente a las herramientas de automatización y estrategias de actualización Blue/Green o Canary de nodos en entornos cloud.
* Matriz de Responsabilidad Compartida: Delimitación de fronteras de seguridad (quién asegura el hardware, el hipervisor, el sistema operativo de los nodos trabajadores y las configuraciones de la plataforma de aplicaciones).

------------------------------
## 💼 BLOQUE 7: OPERACIONES, GOBIERNO Y CIERRE 

## 23 | Fiabilidad, continuidad y recuperación

* Estrategia de respaldo nativa (Velero): Instalación, arquitectura y configuración del motor de copias de seguridad Velero integrado con sistemas de almacenamiento locales u objetos S3 remotos.
* Respaldos consistentes de estado: Configuración de backups integrales de metadatos (definiciones de recursos en etcd) y backups consistentes a nivel de bloque para volúmenes de datos persistentes mediante instantáneas (VolumeSnapshots).
* Métricas de continuidad operativa: Aplicación práctica de los conceptos de RPO (Recovery Point Objective) y RTO (Recovery Time Objective) en fallos simulados del clúster.
* Simulación de desastre total y restauración: Destrucción provocada del clúster local o Namespace de trabajo, y ejecución paso a paso del protocolo automatizado de recuperación total utilizando Velero, validando la integridad del sistema pos-recuperación.

## 24 | Gobierno y operación de plataforma

* Rutas doradas (Golden Paths): Diseño e implementación de plantillas de andamiaje estandarizadas (ej. usando herramientas tipo Backstage o repositorios plantilla) para el autoservicio seguro de desarrolladores.
* Gobernanza y asignación estricta de cuotas: Implementación avanzada de objetos ResourceQuotas y LimitRanges por Namespace para mitigar el antipatrón del "vecino ruidoso" y controlar el gasto en entornos compartidos.
* Auditoría y cumplimiento normativo global: Configuración de reportes automatizados de cumplimiento utilizando las políticas de Kyverno/OPA Gatekeeper instaladas en bloques previos, generando paneles interactivos de gobernanza de la plataforma.
* Modelo operativo de plataforma (Platform as a Product): Definición del ciclo de vida y soporte de los componentes internos de infraestructura, orientando las herramientas del clúster como un producto interno para los equipos de desarrollo.

## 25 | Proyecto final integrado (Capstone)

* Planteamiento del reto de producción: Requisitos de negocio para un ecosistema de microservicios distribuidos que requiere persistencia de datos, alta concurrencia, seguridad estricta y observabilidad total.
* Fase 1: Infraestructura y Automatización: Inicialización del entorno con Terraform, despliegue del catálogo de aplicaciones base vía Helm y configuración de las ondas de sincronización en el clúster de GitOps.
* Fase 2: Blindaje de seguridad Zero-Trust: Implementación del modelo perimetral y de red de mínimo privilegio, configuración de contextos de seguridad no-root y validación criptográfica de firmas de imágenes en la admisión.
* Fase 3: Ingeniería de Caos y Observabilidad: Inyección de carga pesada y fallos controlados en la API para validar la monitorización declarativa, el cálculo dinámico de presupuestos de error (SLO) y las alertas integradas en la pila LGTM.
* Fase 4: Promoción y defensa de arquitectura cloud: Ejecución del pipeline de promoción hacia AKS o EKS mediante Kustomize patches y generación del informe operativo final de la arquitectura, comparativa de costes y plan de contingencia.
