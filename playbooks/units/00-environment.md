# Playbook de la Unidad 00 - Preparación del entorno

## Identificación

### Unidad

```text
00 - Preparación del entorno
```

### Identificador

```text
00-environment
```

### Fase del roadmap

```text
Fase 1 - Plataforma local
```

### Estado del playbook

```text
Aprobado; regenerado contra el contrato documental en fase 4
```

### Propietario lógico

```text
Plataforma local
```

---

# Propósito de la unidad

La Unidad 00 prepara la estación de trabajo local que sostiene todo el itinerario: Windows 11 como host, WSL2, Ubuntu LTS, MicroK8s, `kubectl`, Helm y Terraform. Su problema no es desplegar una aplicación, sino eliminar ambigüedad operativa antes de que aparezcan los conceptos de Kubernetes.

La unidad aparece al inicio porque una práctica posterior solo es formativa si el alumno puede distinguir un fallo del laboratorio de un fallo de host, virtualización, Linux, DNS, permisos, clúster o cliente. También cierra documentalmente `GAP-001`: la Unidad 01 consume una imagen de contenedor ya existente, y la Unidad 00 debe dar el mapa profesional de contenedores, imágenes y registros sin crear una práctica de build ni registry local.

## Supuesto pedagógico

La unidad se escribe para alumnos con perfil técnico que saben usar una terminal, pero que todavía no dominan Kubernetes ni el encaje entre host, WSL2, Linux, distribución local de Kubernetes, cliente, runtime, imagen y registry.

Se explican desde cero:

- qué responsabilidad tiene cada capa de la pila Windows -> WSL2 -> Ubuntu -> MicroK8s -> API Kubernetes -> `kubectl`;
- qué diferencia hay entre instalar, configurar, validar y registrar evidencia;
- qué partes del flujo son Kubernetes estándar y cuáles son específicas de MicroK8s;
- por qué `kubectl` será el cliente operativo principal y `microk8s kubectl` solo fallback de diagnóstico;
- qué significan contenedor, imagen, runtime, tag, digest, registry e `imagePullPolicy`;
- por qué Helm y Terraform se instalan como CLI, pero no gestionan recursos todavía.

Se retoman de fases anteriores:

- el repositorio como fuente única de verdad;
- la separación entre documentos de gobierno, tutoriales y artefactos ejecutables;
- el requisito de registrar solo estado real y verificable.

Se mencionan solo para continuidad:

- aplicación evolutiva `platform-api`;
- `Namespace`, `Deployment`, `Service`, `Pod` y errores de pull de imagen;
- ConfigMaps, Secrets, probes, requests, limits, Ingress, persistencia, Helm, Terraform, Tekton, GitOps, observabilidad, seguridad, escalado, AKS y EKS.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que MicroK8s es "todo Kubernetes";
- creer que una herramienta instalada ya gestiona recursos del curso;
- pensar que Kubernetes construye imágenes;
- usar `latest` como si fuera una versión validada;
- confundir tag con digest;
- asumir que un registry público equivale a una estrategia profesional de supply chain;
- tratar `ImagePullBackOff` como un fallo genérico de Deployment.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- validar que Windows, WSL2 y Ubuntu cumplen las precondiciones del laboratorio;
- instalar, configurar y validar MicroK8s de forma reproducible;
- configurar `kubectl` como cliente principal contra la API Kubernetes local;
- instalar y validar Helm y Terraform como CLI sin crear artefactos funcionales;
- distinguir Kubernetes estándar de decisiones locales de MicroK8s;
- interpretar avisos y fallos por capa antes de aplicar recuperaciones destructivas;
- explicar por qué la Unidad 01 puede consumir una imagen ya publicada sin construirla todavía;
- diferenciar proceso, contenedor, imagen, runtime, registry, tag, digest e `imagePullPolicy`;
- justificar el estado final mediante evidencias registradas, sin inventar validaciones no ejecutadas.

---

# Alcance

## Incluido

- comprobación documental y operativa de requisitos del host Windows;
- validación de WSL2 y Ubuntu LTS;
- preparación básica de Ubuntu para ejecutar servicios y herramientas;
- instalación, configuración y validación de MicroK8s;
- configuración de permisos de usuario y kubeconfig;
- uso de `kubectl` como cliente principal;
- habilitación mínima del addon `dns`;
- instalación y validación de Helm como CLI;
- instalación y validación de Terraform como CLI;
- scripts idempotentes o con comportamiento al repetir documentado;
- diagnóstico y recuperación básica del entorno;
- reset controlado de MicroK8s con confirmación explícita;
- referencia profesional sobre contenedores, imágenes y registros para cerrar `GAP-001`;
- laboratorio de acompañamiento de solo lectura en `platform/environment/container-images/README.md`;
- actualización de `summary.md`, `project/project-state.md` y, si procede, `project/content-gap-register.md`.

## Excluido

- despliegue de `platform-api`;
- creación de namespaces funcionales del curso;
- creación o modificación de workloads Kubernetes;
- creación de manifiestos Kubernetes de aplicación;
- construcción de imágenes;
- instalación de Docker o Podman como requisito del curso;
- habilitación del registry de MicroK8s;
- publicación de imágenes;
- credenciales de pull reales;
- charts Helm, releases Helm de aplicación o repositorios Helm;
- módulos Terraform, backends, providers configurados para gestionar recursos o cloud;
- Tekton, Argo CD, GitOps, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS y EKS;
- tuning avanzado del API Server local, feature gates o rangos de puertos;
- configuración avanzada de `.wslconfig` como práctica obligatoria;
- `kubectx` y `kubens` como dependencias obligatorias.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Primera aplicación evolutiva `platform-api` | Unidad 01 | Requiere entorno validado y cliente `kubectl` operativo |
| Uso práctico de `image`, `imagePullPolicy` e `ImagePullBackOff` | Unidad 01 | El Deployment consume la imagen que esta unidad explica conceptualmente |
| ConfigMaps, Secrets de laboratorio, probes, requests y limits | Unidad 02 | Requieren un Deployment base |
| Ingress HTTP local, DNS operativo de aplicación y TLS como referencia | Unidad 03 | Requiere Service y aplicación |
| Persistencia y StorageClass | Unidad 04 | Requiere workload existente |
| Empaquetado de `platform-api` con Helm | Unidad 06 | Requiere manifiestos acumulados |
| Gestión del release con Terraform | Unidad 07 | Requiere chart Helm funcional |
| Construcción de imágenes en pipeline | Unidad 08 | Encaja en CI/CD con Tekton |
| Gestión real de secretos y credenciales de registry | Unidad 09 y seguridad posterior | Requiere GitOps, identidad y políticas |
| Supply chain, SBOM, firma y verificación de imágenes | Unidad 17 | Requiere pipelines e imagen propia |
| Desacoplamiento formal de MicroK8s | Unidad 19 | Será el puente hacia cloud |
| AKS/EKS y registries cloud ACR/ECR | Unidades 20-21 | Requieren cuentas, redes, identidad y coste cloud |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar la preparación del entorno: capas de host, WSL2, Ubuntu, MicroK8s, `kubectl`, Helm y Terraform; qué se comprueba; cómo se interpreta un resultado; qué fallos operativos pueden aparecer dentro del laboratorio; y cómo ubicarlos por capa.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: contenedores, imágenes, runtimes, OCI, Docker, Podman, containerd, tags, digests, registries, pull de imágenes, credenciales, `imagePullPolicy`, supply chain y límites profesionales de usar una imagen pública ya construida.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta.

## Laguna asignada

| ID | Tratamiento en esta unidad | Cierre esperado |
|---|---|---|
| `GAP-001` | La referencia de la Unidad 00 cubre contenedores, imágenes y registros; el laboratorio de acompañamiento permite leer campos de imagen sin construir ni desplegar nada | Cierre documental en `tutorial/00-environment/student-reference.md`, rastro en `tutorial/00-environment/summary.md` y registro confirmado en `project/content-gap-register.md` |

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicación en la Unidad 00 |
|---|---|
| Panorama | Situar contenedores, imágenes, runtimes y registros antes de que Kubernetes despliegue `platform-api` |
| Profundidad | Explicar tags, digests, capas, Dockerfile, multi-stage, `imagePullPolicy`, runtime y flujo de pull hasta poder leer el Deployment de Unidad 01 |
| Criterio | Decidir cuándo basta una imagen pública versionada, cuándo se necesita registry gobernado y por qué evitar `latest` |
| Práctica | Nombrar distancias con producción: no hay build propio, no hay registry local, no hay credenciales reales, no hay firma, no hay SBOM y no hay escaneo |

## Simplificaciones que obligan a práctica profesional

| Simplificación del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| MicroK8s local de un nodo | No representa disponibilidad, operación ni seguridad de un clúster corporativo | Clústeres gestionados o multi-nodo, runbooks y separación de responsabilidades |
| Addon inicial `dns` como único addon explícito | Otros servicios de plataforma no están preparados | Habilitar capacidades solo cuando una unidad las necesite y registrarlo |
| Helm y Terraform instalados pero sin uso | La presencia de una CLI puede confundirse con estado gestionado | Artefactos versionados, comandos documentados y estado registrado al empezar su unidad |
| Imagen pública de `platform-api` en Unidad 01 | Dependencia externa, sin control de build ni supply chain | Registry gobernado, tags inmutables, digests, escaneo, firma y promoción |
| Sin build ni registry local | No cubre ciclo código -> imagen -> publicación -> despliegue | Tekton, registry y seguridad de supply chain en unidades posteriores |
| Sin credenciales de registry | No demuestra autenticación ni rotación | `imagePullSecrets`, ServiceAccounts e identidad gestionada cuando corresponda |

## Uso de `project/coverage-map.md`

La sección de Unidad 00 de `project/coverage-map.md` se usa únicamente como checklist de cobertura. Sus puntos se clasifican así:

| Punto de `project/coverage-map.md` | Clasificación | Tratamiento |
|---|---|---|
| WSL2 con Ubuntu 22.04+ y comandos de administración | Práctica existente del laboratorio | Cubierto por README, notas y scripts Windows/Ubuntu; baseline real Ubuntu 24.04 LTS |
| `.wslconfig`, límites de CPU/RAM, swap y compactación VHD | Criterio conceptual / exclusión parcial | Se menciona como ajuste de host fuera de práctica obligatoria; no se convierte en procedimiento |
| MicroK8s por `snap`, grupos de usuario y addons base `dns`, `rbac` | Práctica existente y exclusión | `dns` cubierto; `rbac` no se habilita en Unidad 00 porque el alcance aprobado conserva addons mínimos |
| Argumentos avanzados de API Server en `/var/snap/microk8s/current/args/` | Exclusión anclada | Se excluye de Unidad 00; se retoma en operación avanzada, seguridad o migración cuando exista necesidad |
| `kubectl`, Helm y Terraform independientes | Práctica existente | Instalados y validados como CLI según estado registrado |
| Kubeconfig, contextos y TLS con API Server | Práctica existente y criterio | Kubeconfig básico y comunicación por API cubiertos; `kubectx`/`kubens` quedan como herramientas opcionales no obligatorias |

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
14. este playbook;
15. sección de Unidad 00 en `project/coverage-map.md`, solo como checklist de cobertura;
16. `tutorial/00-environment/README.md`;
17. `tutorial/00-environment/student-notes.md`;
18. `tutorial/00-environment/student-reference.md`;
19. `tutorial/00-environment/summary.md`;
20. `platform/environment/README.md`;
21. `platform/environment/container-images/README.md`.

## Excepciones

No existe `summary.md` de una unidad anterior porque la Unidad 00 es la primera unidad formativa del itinerario.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- historial del saneamiento consolidado en `project/project-state.md`;
- registro de lagunas con `GAP-001`;
- artefactos actuales de la Unidad 00;
- documentación operativa de `platform/environment/`.

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Windows 11 | Requisito previsto; validación por equipo | `platform/environment/windows/check-prerequisites.ps1` |
| WSL2 | Disponible para la distribución objetivo | `wsl --status`, `wsl --list --verbose` |
| Ubuntu LTS | Disponible y validable | `cat /etc/os-release` |
| `systemd` y `snap` | Disponibles en Ubuntu | `bash platform/environment/linux/check-prerequisites.sh` |
| MicroK8s | Instalado y operativo tras ejecutar scripts | `bash platform/environment/microk8s/validate.sh` |
| `kubectl` | Cliente operativo principal | `kubectl version --client`, `kubectl get nodes` |
| Helm | CLI instalada y validada | `bash platform/environment/tools/validate-tools.sh` |
| Terraform | CLI instalada y validada | `bash platform/environment/tools/validate-tools.sh` |

## Dependencias pedagógicas

El alumno debe saber:

- abrir PowerShell y una shell Bash;
- ejecutar comandos desde la raíz del repositorio;
- distinguir rutas Windows y rutas Linux;
- interpretar salidas básicas de comandos;
- entender a nivel general qué es un proceso, un archivo, una red local y un permiso.

No se asume experiencia previa administrando Kubernetes ni construyendo imágenes.

## Dependencias del laboratorio

No existen artefactos técnicos de unidades anteriores. La Unidad 00 reutiliza el framework del repositorio y deja sus artefactos ejecutables en:

```text
platform/environment/
```

---

# Estado inicial esperado

La unidad parte de un repositorio sin plataforma desplegada por sus propios artefactos y sin aplicación evolutiva. El entorno del alumno puede estar limpio o parcialmente preparado.

Estado esperado antes de ejecutar la unidad:

- Windows 11 disponible como host o pendiente de validación por equipo;
- WSL2 ausente, parcialmente configurado o disponible;
- Ubuntu LTS ausente o disponible;
- MicroK8s no gestionado todavía por el proyecto;
- Helm y Terraform no gestionados todavía por el proyecto;
- ningún namespace funcional del curso;
- ningún workload;
- ningún chart Helm de aplicación;
- ningún proyecto Terraform del curso;
- ningún recurso cloud.

## Validación del estado inicial

Comprobaciones documentadas:

```powershell
.\platform\environment\windows\check-prerequisites.ps1
wsl --status
wsl --list --verbose
```

```bash
bash platform/environment/linux/check-prerequisites.sh
cat /etc/os-release
git --version
```

La salida exacta depende del equipo. No se registra como validada si no se ejecuta o si el usuario no aporta resultados.

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Arquitectura | `project/architecture.md` | Mantener Unidad 00 fuera de `labs/` |
| Estado | `project/project-state.md` | Registrar solo hechos verificables |
| Roadmap | `project/roadmap.md` | Limitar alcance a plataforma local |
| Registro de lagunas | `project/content-gap-register.md` | Confirmar cierre de `GAP-001` |
| Plantilla de referencia | `playbooks/student-reference-template.md` | Regenerar `student-reference.md` |
| Artefactos de entorno | `platform/environment/` | Scripts y documentación operativa |
| Laboratorio de imágenes | `platform/environment/container-images/README.md` | Acompañar `GAP-001` sin build ni despliegue |

## Reglas de reutilización

- no crear un laboratorio paralelo en `labs/00-environment/`;
- no crear workloads;
- no crear manifiestos Kubernetes;
- no modificar scripts de `platform/environment/` durante el saneamiento salvo defecto documental bloqueante explícito;
- conservar `platform/environment/container-images/README.md` como laboratorio de solo lectura;
- mantener `kubectl` como cliente principal y MicroK8s como distribución local.

---

# Cambios previstos sobre la solución

## Componentes nuevos

```text
Ninguno durante el saneamiento documental.
```

La generación original de Unidad 00 creó documentación y scripts; la fase 4 solo regenera y ajusta documentación permitida.

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `playbooks/units/00-environment.md` | Regeneración contra contrato documental | No cambia comportamiento técnico |
| `tutorial/00-environment/README.md` | Ajuste de entrada, enlaces y cobertura | Mantiene pasos existentes |
| `tutorial/00-environment/student-notes.md` | Alineación con frontera notas/referencia y ortografía | Conserva diagnóstico del laboratorio |
| `tutorial/00-environment/student-reference.md` | Regeneración canónica y cierre de `GAP-001` | No crea práctica ejecutable nueva |
| `tutorial/00-environment/summary.md` | Registro del saneamiento documental | No declara validaciones funcionales nuevas |
| `project/project-state.md` | Estado de fase 4 y cierre de `TD-019` si procede | No cambia estado técnico del clúster |
| `project/content-gap-register.md` | Solo si se ajusta el tratamiento de `GAP-001` | Mantiene fuente única de lagunas |

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseño de la unidad

## D-00-01 - MicroK8s como distribución local

### Decisión

Usar MicroK8s sobre Ubuntu LTS en WSL2 como plataforma local inicial.

### Motivo

Respeta la arquitectura aprobada, permite disponer de un Kubernetes local reproducible y evita introducir distribuciones paralelas.

### Consecuencias

- las particularidades de MicroK8s deben aislarse;
- los procedimientos Kubernetes transferibles usarán `kubectl`;
- la evolución hacia AKS y EKS requiere diferenciar distribución local y API estándar.

### Alternativas descartadas

- Minikube, kind y Docker Desktop Kubernetes: no se introducen como plataformas paralelas.

## D-00-02 - Scripts separados por contexto

### Decisión

Separar scripts Windows, Linux, MicroK8s, herramientas y validación integrada.

### Motivo

Evita ambigüedad sobre shell, permisos y sistema donde se ejecuta cada acción.

### Consecuencias

- cada documento debe indicar contexto de ejecución;
- los scripts Linux no instalan WSL ni crean Ubuntu;
- los scripts Windows no gestionan MicroK8s.

## D-00-03 - Validación antes de instalación

### Decisión

Validar el estado existente antes de instalar o normalizar.

### Motivo

La unidad debe funcionar en equipos limpios y en equipos parcialmente preparados.

### Consecuencias

- los scripts evitan reinstalaciones innecesarias;
- los avisos se interpretan según fase;
- las versiones observadas se registran solo cuando se han comprobado.

## D-00-04 - Addons mínimos

### Decisión

Habilitar como baseline explícita solo el addon `dns`.

### Motivo

Evita anticipar networking, almacenamiento, observabilidad, registry o seguridad avanzada.

### Consecuencias

- `rbac`, registry, Ingress, storage y otros addons quedan fuera de la práctica de Unidad 00;
- cualquier addon observado por MicroK8s como core se registra como observado, no como objetivo didáctico de esta unidad.

## D-00-05 - Helm y Terraform solo como CLI

### Decisión

Instalar y validar Helm y Terraform sin crear charts, releases, módulos, backends ni recursos.

### Motivo

La unidad prepara herramientas; sus responsabilidades reales aparecen cuando existan artefactos de aplicación.

### Consecuencias

- Helm se usa como empaquetador en Unidad 06;
- Terraform gestiona el release Helm en Unidad 07;
- la presencia de la CLI no implica ownership de recursos.

## D-00-06 - `kubectl` como cliente principal

### Decisión

Configurar `kubectl` independiente como cliente operativo principal del curso.

### Motivo

`kubectl` es portable entre MicroK8s, AKS, EKS y otros clusters Kubernetes.

### Consecuencias

- `microk8s kubectl` queda como fallback de diagnóstico;
- el kubeconfig debe quedar disponible para el usuario;
- las unidades posteriores deben favorecer comandos estándar de Kubernetes.

## D-00-07 - `GAP-001` sin práctica de build

### Decisión

Cerrar `GAP-001` con referencia profesional y laboratorio de lectura, no con construcción de imagen ni registry local.

### Motivo

La Unidad 01 necesita entender la imagen que consume, pero construir y publicar imágenes pertenece al flujo de CI/CD y supply chain.

### Consecuencias

- `student-reference.md` cubre el mapa mental de contenedores, imágenes y registros;
- `platform/environment/container-images/README.md` es de solo lectura;
- no se instala Docker, Podman ni registry local como requisito.

## D-00-08 - Política inicial de versiones

### Decisión

Mantener la baseline registrada: Ubuntu 24.04 LTS, MicroK8s `1.35/stable`, Kubernetes/kubectl 1.35.x, Helm 3.21.x y Terraform 1.15.x.

### Motivo

Reduce variabilidad en el entorno inicial y permite comparar resultados.

### Consecuencias

- las versiones exactas se registran desde evidencia real;
- no se asume que un equipo nuevo tenga las mismas versiones sin validarlas;
- cualquier actualización mayor se decide en su unidad natural.

---

# Estructura de entregables

## Tutorial

```text
tutorial/00-environment/README.md
```

Debe actuar como puerta de entrada. Debe explicar el problema real, la arquitectura de capas, el mapa de aprendizaje, cómo usar `student-notes.md`, cómo usar `student-reference.md`, cómo llegar al README operativo de `platform/environment/` y qué queda preparado para Unidad 01.

## Notas del alumno

```text
tutorial/00-environment/student-notes.md
```

Debe explicar lo que ocurre dentro de la preparación del entorno: capas, contratos, comprobaciones, señales, fallos típicos del laboratorio, recuperación y evidencias. No debe convertirse en catálogo profesional de contenedores ni duplicar la referencia.

## Referencia del alumno

```text
tutorial/00-environment/student-reference.md
```

Debe seguir `playbooks/student-reference-template.md` y cerrar `GAP-001`. Su tema profesional es contenedores, imágenes y registros, con relación directa con la imagen `nginxinc/nginx-unprivileged:1.27.4-alpine` que usa Unidad 01.

## Notas del instructor

```text
tutorial/00-environment/instructor-notes.md
```

No se modifican en esta fase salvo necesidad explícita.

## Resumen

```text
tutorial/00-environment/summary.md
```

Debe registrar el saneamiento documental, el cierre de `GAP-001`, validaciones funcionales no ejecutadas en esta fase y continuidad hacia Unidad 01.

## Artefactos ejecutables

```text
platform/environment/
```

Durante esta fase no se modifican scripts ni comportamiento funcional.

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

---

# Estructura prevista de artefactos

La Unidad 00 conserva esta estructura:

```text
tutorial/00-environment/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

platform/environment/
├── README.md
├── container-images/
│   └── README.md
├── linux/
│   └── check-prerequisites.sh
├── microk8s/
│   ├── configure.sh
│   ├── install.sh
│   ├── reset.sh
│   └── validate.sh
├── tools/
│   ├── install-helm.sh
│   ├── install-terraform.sh
│   └── validate-tools.sh
├── validation/
│   └── validate-environment.sh
└── windows/
    ├── check-prerequisites.ps1
    └── prepare-ubuntu-wsl.ps1
```

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `tutorial/00-environment/README.md` | Entrada formativa de la unidad |
| `tutorial/00-environment/student-notes.md` | Guía de aprendizaje y diagnóstico del laboratorio |
| `tutorial/00-environment/student-reference.md` | Referencia profesional de contenedores, imágenes y registros |
| `tutorial/00-environment/summary.md` | Continuidad y estado documental |
| `platform/environment/README.md` | Operación de scripts de entorno |
| `platform/environment/container-images/README.md` | Laboratorio de lectura sobre imagen e `imagePullPolicy` |
| `platform/environment/windows/` | Comprobaciones y preparación desde PowerShell |
| `platform/environment/linux/` | Comprobaciones de Ubuntu WSL |
| `platform/environment/microk8s/` | Instalación, configuración, validación y reset de MicroK8s |
| `platform/environment/tools/` | Instalación y validación de Helm/Terraform |
| `platform/environment/validation/` | Validación integrada |

---

# Flujo pedagógico obligatorio

La unidad debe seguir este orden conceptual:

1. problema real: separar aprendizaje de Kubernetes de fallos del entorno;
2. pila de capas Windows -> WSL2 -> Ubuntu -> MicroK8s -> API -> `kubectl`;
3. validación del host antes de instalar;
4. validación de Ubuntu y dependencias;
5. instalación y configuración de MicroK8s;
6. configuración de `kubectl`;
7. validación del clúster;
8. instalación y validación de Helm y Terraform como CLI;
9. diagnóstico por capa y recuperación controlada;
10. referencia profesional de imágenes como preparación para Unidad 01;
11. consolidación de evidencias y limitaciones.

Este orden evita saltar de un error de entorno a una explicación de Kubernetes que todavía no aplica.

---

# Procedimientos obligatorios

## Preparación

- comprobar Windows, virtualización, WSL y distribución objetivo;
- comprobar Ubuntu, `systemd`, `snap`, Git, herramientas base, DNS y espacio;
- revisar si las herramientas ya existen.

## Implementación

- instalar Ubuntu WSL solo desde el procedimiento Windows documentado;
- instalar MicroK8s y `kubectl` mediante scripts;
- configurar grupo `microk8s`, addon `dns` y kubeconfig;
- instalar Helm y Terraform como CLI.

## Validación

- comprobar WSL2, Ubuntu, MicroK8s, `kubectl`, nodos, namespaces, Helm y Terraform;
- ejecutar validación integrada cuando los bloques previos existan.

## Diagnóstico

- ubicar el fallo por capa;
- distinguir `WARN` esperado de bloqueo;
- comprobar DNS, permisos, contexto, kubeconfig, grupos y servicios.

## Recuperación

- reabrir sesión para aplicar grupos;
- reiniciar WSL o MicroK8s cuando proceda;
- usar reset de MicroK8s solo con confirmación explícita;
- no borrar distribuciones ni estado local sin procedimiento externo.

## Limpieza

No hay limpieza ordinaria de la Unidad 00. El reset de MicroK8s es recuperación, no cierre normal.

---

# Validaciones obligatorias

## Validaciones estáticas

| Validación | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis Bash | `bash -n <script>` | Código de salida 0 |
| ShellCheck | `shellcheck <script>` cuando esté disponible | Sin errores bloqueantes |
| Sintaxis PowerShell | Parser o ejecución controlada cuando esté disponible | Scripts sin errores de sintaxis |
| Rutas documentadas | Revisión del repositorio | Todas las rutas existen |
| Secretos | Revisión documental | No hay credenciales reales |

## Validaciones funcionales

| Validación | Procedimiento | Resultado esperado |
|---|---|---|
| WSL2 | `wsl --status` | WSL disponible |
| Distribución | `wsl --list --verbose` | Ubuntu objetivo en WSL2 |
| Ubuntu | `cat /etc/os-release` | Ubuntu LTS compatible |
| MicroK8s | `microk8s status --wait-ready` | Clúster preparado |
| Nodo | `kubectl get nodes` | Nodo en `Ready` |
| Cliente Kubernetes | `kubectl version --client` | Versión compatible |
| Helm | `helm version` | CLI disponible |
| Terraform | `terraform version` | CLI disponible |
| Validación integrada | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |

## Validaciones de continuidad

Comprobar que:

- no se han creado workloads;
- no se han creado namespaces funcionales;
- no se han creado charts ni módulos Terraform;
- `summary.md` distingue validaciones ejecutadas de pendientes;
- `student-reference.md` declara y cierra `GAP-001`;
- la Unidad 01 puede reutilizar la explicación de imagen sin exigir build ni registry.

## Validaciones no ejecutables en el saneamiento documental

Durante la fase 4 de saneamiento de Unidad 00 no se ejecutan validaciones funcionales nuevas. No declarar como nueva evidencia:

- Windows real;
- virtualización real;
- WSL2 desde PowerShell;
- MicroK8s;
- `kubectl`;
- Helm;
- Terraform;
- pull de imágenes;
- build de imágenes;
- registry local.

---

# Escenarios de error obligatorios

| Escenario | Síntoma | Diagnóstico | Recuperación |
|---|---|---|---|
| Virtualización no disponible | WSL2 no inicia | Revisar host y features | Habilitar virtualización según procedimiento del equipo |
| Distribución en WSL1 | MicroK8s no funciona correctamente | `wsl --list --verbose` | Convertir a WSL2 |
| `systemd` o `snap` ausentes | Servicios o instalación fallan | `systemctl`, `snap version` | Normalizar Ubuntu/WSL antes de MicroK8s |
| DNS bloqueado | Fallan descargas de `snap` o herramientas | `getent hosts snapcraft.io` | Resolver red/proxy/VPN sin versionar credenciales |
| Usuario fuera de grupo | Errores de permisos MicroK8s | `groups`, salida de scripts | Añadir grupo y reabrir sesión |
| Kubeconfig incorrecto | `kubectl` no habla con el clúster | `kubectl config current-context` | Regenerar kubeconfig desde MicroK8s |
| Imagen no descargable en Unidad 01 | `ImagePullBackOff` o `ErrImagePull` | Eventos del Pod, nombre, tag, red, credenciales | Corregir referencia de imagen o acceso al registry en su unidad |
| Reset usado como reflejo | Pérdida de estado local | Revisar alcance de `reset.sh` | Diagnosticar antes y ejecutar solo con confirmación |

---

# Requisitos de seguridad

## Datos sensibles

No versionar:

- contraseñas;
- tokens;
- kubeconfigs personales;
- claves privadas;
- certificados corporativos;
- credenciales de proxy;
- credenciales cloud;
- credenciales de registry.

La unidad usa placeholders y valores ficticios cuando necesita hablar de secretos o credenciales.

## Privilegios

Documentar con claridad:

- cuándo se ejecuta PowerShell;
- cuándo se requieren permisos administrativos;
- cuándo un script Linux usa `sudo`;
- qué operaciones modifican grupos;
- qué operaciones escriben en `~/.kube/config` o `/usr/local/bin`.

## Operaciones destructivas

| Operación | Advertencia | Alcance | Recuperación |
|---|---|---|---|
| `microk8s reset` | Elimina recursos del clúster local | MicroK8s | Reconfigurar y redeplegar unidades necesarias |
| Desinstalar MicroK8s | Elimina distribución Kubernetes local | Ubuntu | Reinstalar con scripts |
| Eliminar distribución WSL | Borra filesystem Linux | Windows/WSL | Restaurar backup o reinstalar |

Las operaciones destructivas requieren confirmación explícita o quedan fuera del repositorio.

---

# Requisitos de portabilidad

## Kubernetes estándar

- API Kubernetes;
- `kubectl`;
- kubeconfig;
- nodos y namespaces;
- Pod spec con `image` e `imagePullPolicy`;
- errores de pull de imagen;
- uso de tags y digests como criterio de reproducibilidad.

## Específico de MicroK8s

- instalación por `snap`;
- comando `microk8s`;
- grupo `microk8s`;
- addons;
- generación de kubeconfig desde MicroK8s;
- reset de la distribución local.

## Específico de AKS

```text
No aplica en esta unidad.
```

Se permite referencia conceptual breve a ACR como registry cloud futuro, sin procedimiento.

## Específico de EKS

```text
No aplica en esta unidad.
```

Se permite referencia conceptual breve a ECR como registry cloud futuro, sin procedimiento.

## Estrategia de desacoplamiento

- aislar comandos MicroK8s en `platform/environment/microk8s/`;
- usar `kubectl` para operaciones Kubernetes transferibles;
- no presentar addons MicroK8s como equivalentes universales;
- registrar acoplamientos locales en `summary.md`;
- diferir cloud hasta unidades previstas.

---

# Restricciones de generación

La IA no debe:

- generar Unidad 08;
- crear workloads nuevos;
- modificar manifiestos Kubernetes;
- tocar labs de Unidades 01-07;
- modificar scripts de `platform/environment/` salvo defecto documental bloqueante explícito;
- ejecutar validaciones funcionales nuevas durante el saneamiento documental;
- crear charts Helm;
- crear módulos Terraform;
- instalar Docker, Podman o registry local como requisito;
- habilitar addons nuevos por conveniencia;
- modificar el API Server local, feature gates o rangos de puertos;
- introducir Minikube, kind o Docker Desktop Kubernetes como plataforma paralela;
- almacenar credenciales reales;
- usar `project/coverage-map.md` como contrato o estructura.

La IA sí puede:

- regenerar el playbook contra contrato;
- regenerar `student-reference.md` contra `playbooks/student-reference-template.md`;
- ajustar README, notas y summary para respetar la frontera documental;
- revisar `GAP-001` en `project/content-gap-register.md`;
- actualizar `project/project-state.md` con el estado documental real;
- hacer validaciones documentales, de rutas, de búsqueda y de diff.

---

# Criterios de aceptación

La unidad se considera conforme tras el saneamiento cuando:

- [ ] `playbooks/units/00-environment.md` declara frontera, laguna, tipos de cobertura, simplificaciones y uso limitado de `project/coverage-map.md`;
- [ ] `tutorial/00-environment/student-reference.md` sigue las nueve secciones canónicas de `playbooks/student-reference-template.md`;
- [ ] `student-reference.md` declara `GAP-001` en su propósito y lo cierra sin práctica nueva;
- [ ] cada exclusión relevante de `student-notes.md` queda cubierta, anclada o declarada fuera del itinerario;
- [ ] `student-notes.md` conserva diagnóstico del laboratorio y no duplica el catálogo profesional de imágenes;
- [ ] `README.md` funciona como entrada y remite a notas, referencia y README operativo;
- [ ] `summary.md` registra el saneamiento, `GAP-001` y la ausencia de validaciones funcionales nuevas;
- [ ] `project/project-state.md` registra el saneamiento de Unidad 00 y cierra `TD-019` si ya no quedan unidades pendientes;
- [ ] `project/content-gap-register.md` mantiene `GAP-001` cerrado o ajustado de forma coherente;
- [ ] no hay cambios funcionales en `platform/environment/`;
- [ ] no hay cambios en labs de Unidades 01-07;
- [ ] no se han creado workloads, manifiestos, charts, módulos ni unidades nuevas;
- [ ] la prosa del material del alumno tiene ortografía completa;
- [ ] el reporte final incluye cobertura punto por punto contra `project/coverage-map.md`.

---

# Estado final esperado

## Plataforma

Sin cambios funcionales durante el saneamiento. Se conserva el estado ya registrado: Ubuntu WSL, MicroK8s, `kubectl`, Helm y Terraform validados según evidencias históricas de Unidad 00.

## Aplicación

```text
No definida ni desplegada por Unidad 00.
```

## Automatización

Se conservan scripts de `platform/environment/` sin cambios funcionales.

## Observabilidad

```text
No incorporada.
```

## Seguridad

- sin credenciales reales;
- sin registry local;
- sin credenciales de pull reales;
- referencia conceptual a supply chain, firma y SBOM anclada a unidades posteriores.

## Artefactos principales

```text
playbooks/units/00-environment.md
tutorial/00-environment/README.md
tutorial/00-environment/student-notes.md
tutorial/00-environment/student-reference.md
tutorial/00-environment/summary.md
platform/environment/README.md
platform/environment/container-images/README.md
project/project-state.md
project/content-gap-register.md
```

---

# Información obligatoria para el summary

El `summary.md` debe destacar:

- Unidad 00 saneada contra contrato documental;
- `GAP-001` cerrado por `student-reference.md`;
- `platform/environment/container-images/README.md` como laboratorio de solo lectura;
- que no hubo cambios funcionales en scripts;
- que no se ejecutaron validaciones funcionales nuevas;
- validaciones técnicas históricas que permanecen como evidencia;
- validaciones Windows/PowerShell pendientes por equipo;
- continuidad hacia Unidad 01.

---

# Impacto esperado en project-state

Al cerrar el saneamiento documental de Unidad 00, actualizar como mínimo:

- resumen ejecutivo;
- último incremento completado;
- siguiente incremento permitido;
- artefactos de gobierno;
- tabla de unidades;
- bloque de Unidad 00;
- decisiones específicas si se añade la frontera documental;
- deuda `TD-019`, que queda cerrada si Unidad 00 queda conforme;
- `TD-020`, que sigue parcialmente cerrada hasta sanear todas las unidades;
- restricciones activas y continuidad de fase 4.

---

# Conexión con la siguiente unidad

## Siguiente unidad prevista

```text
01 - Fundamentos operativos y primera aplicación
```

## Capacidades que deja preparadas

- entorno local validado según evidencias históricas;
- `kubectl` como cliente principal;
- Helm y Terraform disponibles como CLI;
- modelo mental de contenedores, imágenes, runtime y registry;
- criterio básico para leer `image`, tag, digest, `imagePullPolicy` y fallos de pull.

## Elementos que la siguiente unidad debe reutilizar

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Entorno local | `platform/environment/` | No reinstalar ni sustituir plataforma |
| Summary | `tutorial/00-environment/summary.md` | Conocer estado y limitaciones |
| Referencia de imágenes | `tutorial/00-environment/student-reference.md` | Entender la imagen de `platform-api` |
| Laboratorio de lectura | `platform/environment/container-images/README.md` | Leer `image` e `imagePullPolicy` sin modificar el clúster |
| Estado del proyecto | `project/project-state.md` | Confirmar restricciones y herramientas disponibles |

## Elementos que no deben modificarse todavía

- distribución Kubernetes;
- addons de MicroK8s no requeridos;
- scripts de entorno salvo corrección justificada;
- registry local;
- estrategia de build de imágenes;
- Helm como empaquetador de aplicación;
- Terraform como gestor de recursos;
- componentes de CI/CD, GitOps, observabilidad, seguridad avanzada y cloud.

---

# Riesgos específicos

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Confundir saneamiento documental con revalidación técnica | Media | Alto | Registrar explícitamente que no se ejecutan validaciones funcionales nuevas |
| Sobrecargar Unidad 00 con tuning de WSL o API Server | Media | Medio | Tratar esos puntos de `project/coverage-map.md` como criterio o exclusión anclada |
| Duplicar contenedores e imágenes en notas y referencia | Media | Medio | Dejar el diagnóstico local en notas y el modelo profesional en referencia |
| Convertir `GAP-001` en práctica de build | Media | Alto | Mantener laboratorio de solo lectura y anclar build a CI/CD |
| Presentar MicroK8s como equivalente a cloud | Media | Alto | Separar Kubernetes estándar, MicroK8s y cloud en referencia y notas |

---

# Preguntas abiertas

```text
Ninguna bloqueante para el saneamiento documental de Unidad 00.
```

La validación Windows/PowerShell sigue siendo una comprobación por equipo al replicar el laboratorio, no una pregunta de diseño.
