# Unidad 00 - Preparación del entorno

## Guía pedagógica de la unidad

Esta unidad no enseña Kubernetes todavía. Enseña algo anterior: cómo construir un entorno de aprendizaje confiable.

En muchos equipos, los primeros problemas con Kubernetes no vienen de Kubernetes. Vienen de una instalación incompleta, de WSL mal configurado, de una terminal sin permisos actualizados, de DNS bloqueado por una VPN, de un `kubectl` apuntando a otro clúster o de una herramienta instalada pero no validada. Si esos problemas se mezclan con los conceptos del curso, el alumno aprende a probar comandos al azar en vez de razonar.

Por eso esta unidad cubre la base operativa del itinerario:

- qué significa trabajar sobre Windows, WSL2 y Ubuntu;
- por qué MicroK8s es una distribución local de Kubernetes, no "todo Kubernetes";
- qué papel cumple `kubectl` como cliente principal;
- por qué Helm y Terraform se instalan ahora pero no se usan todavía para gestionar recursos;
- qué diferencia hay entre instalar, configurar, validar y registrar evidencia;
- cómo decidir si un fallo pertenece al host, a Linux, a MicroK8s, a la red o a una herramienta.

El laboratorio ejecutable está en `platform/environment/`. Este README es la puerta de entrada formativa; el README operativo de scripts está en `platform/environment/README.md`.

Para estudiar las capas del entorno con más detalle, lee `tutorial/00-environment/student-notes.md`.

Para preparar la base conceptual sobre contenedores, imágenes y registros antes de desplegar `platform-api` en la Unidad 01, lee `tutorial/00-environment/student-reference.md`. Esa referencia cierra `GAP-001`. El laboratorio de acompañamiento está en `platform/environment/container-images/README.md` y es de solo lectura.

## Mapa de aprendizaje

| Bloque | Qué cubre | Qué debe poder explicar el alumno |
|---|---|---|
| Host Windows | Requisitos mínimos para ejecutar WSL2 | Por qué Kubernetes local depende de virtualización y soporte del host |
| WSL2 | Capa Linux integrada en Windows | Por qué el laboratorio se ejecuta dentro de Ubuntu y no directamente en PowerShell |
| Ubuntu | Sistema donde correrán scripts, snaps y herramientas | Qué señales muestran que Linux está preparado para operar servicios |
| MicroK8s | Distribución Kubernetes local | Qué partes son específicas de MicroK8s y cuáles son API Kubernetes estándar |
| `kubectl` | Cliente operativo del curso | Por qué `kubectl get nodes` prueba acceso a la API del clúster |
| Helm y Terraform | Herramientas futuras | Por qué una CLI instalada no implica que ya gestione recursos |
| Imágenes de contenedor | Base conceptual para Unidad 01 | Por qué Kubernetes ejecuta contenedores creados desde imágenes |

## Qué no intenta enseñar esta unidad

Esta unidad no intenta que el alumno despliegue aplicaciones, diseñe manifests, entienda Deployments, exponga Services ni use Helm o Terraform de forma práctica. Tampoco enseña a construir imágenes, publicar en un registry o configurar credenciales de pull.

El objetivo es que, cuando en la Unidad 01 aparezca el primer workload, el alumno pueda decir: "el clúster está disponible, el cliente habla con la API, el nodo está `Ready`, las herramientas base responden y entiendo qué imagen va a ejecutar Kubernetes".

## Problema real que resuelve

Antes de aprender Kubernetes hace falta eliminar una fuente habitual de ruido: no saber si un fallo viene del concepto que se está practicando, del sistema operativo, de la virtualización, de la red, de permisos locales o del propio clúster.

La Unidad 00 crea una estación de trabajo local con evidencias. El objetivo no es "tener MicroK8s instalado" como fin en sí mismo, sino construir una base donde las unidades posteriores puedan fallar por razones formativas y diagnosticables.

## Por qué aparece al inicio

Kubernetes es una plataforma distribuida incluso cuando se ejecuta en un único portátil. Si se empieza desplegando una aplicación sin entender las capas inferiores, cada error se vuelve ambiguo: puede parecer un problema de YAML cuando en realidad falta `systemd`, falla DNS, el usuario no pertenece al grupo correcto o `kubectl` apunta a otro contexto.

Por eso esta unidad separa dos trabajos distintos:

- preparar una plataforma local de aprendizaje;
- desplegar aplicaciones sobre esa plataforma.

La primera responsabilidad pertenece a la Unidad 00. La segunda empieza en la Unidad 01.

## Objetivos

Al finalizar este bloque, el alumno debe poder justificar con evidencias que:

- el host Windows puede ejecutar WSL2;
- existe una distribución Ubuntu LTS objetivo para el laboratorio;
- Ubuntu se ejecuta sobre WSL2;
- `systemd`, `snap`, Git y herramientas básicas están disponibles dentro de Ubuntu;
- MicroK8s y `kubectl` pueden instalarse, configurarse y validarse mediante scripts del repositorio;
- Helm y Terraform pueden instalarse y validarse como CLI sin crear artefactos funcionales;
- el repositorio puede continuarse desde VS Code conectado a Ubuntu WSL;
- la Unidad 01 podrá consumir una imagen de contenedor ya publicada sin que la Unidad 00 construya imágenes.

## Arquitectura objetivo

La Unidad 00 construye el entorno en esta secuencia:

```text
Windows 11
  -> WSL2
    -> Ubuntu 24.04 LTS
      -> MicroK8s
        -> API Kubernetes
          -> kubectl
```

Helm y Terraform quedan instalados en Ubuntu como herramientas de línea de comandos. No gestionan recursos del curso hasta sus unidades previstas.

## Modelo mental de la unidad

Piensa el entorno como una pila de contratos. Cada capa ofrece una capacidad a la siguiente:

| Capa | Contrato que debe cumplir | Evidencia |
|---|---|---|
| Windows | Puede ejecutar virtualización y WSL2 | `wsl --status`, features Windows |
| WSL2 | Ejecuta una distribución Linux para el laboratorio | `wsl --list --verbose` |
| Ubuntu | Tiene servicios, paquetes, red y herramientas base | `systemd`, `snap`, Git, DNS |
| MicroK8s | Proporciona una distribución Kubernetes local | `microk8s status --wait-ready` |
| `kubectl` | Habla con la API Kubernetes como cliente estándar | `kubectl get nodes` |
| Helm/Terraform | Responden como CLI | `helm version`, `terraform version` |

Cuando una validación falla, no conviene saltar directamente a reinstalar. Primero hay que ubicar en qué capa se rompe el contrato y qué capa depende de ella.

## Plataforma local frente a Kubernetes estándar

MicroK8s es la distribución local elegida para el laboratorio inicial. Kubernetes, en cambio, es la API y el modelo operativo que se mantendrán cuando el itinerario avance hacia plataformas gestionadas.

En esta unidad son específicos del entorno local:

- Windows 11 como host;
- WSL2 como capa de virtualización Linux;
- Ubuntu 24.04 LTS como distribución objetivo;
- instalación de MicroK8s mediante `snap`;
- addons propios de MicroK8s;
- scripts de preparación en `platform/environment/`.

Son conceptos y prácticas transferibles:

- validar precondiciones antes de desplegar;
- usar `kubectl` como cliente principal;
- comprobar contexto y conectividad con la API;
- registrar versiones reales;
- distinguir instalación, configuración y validación;
- documentar limitaciones no verificadas;
- leer una referencia de imagen en un manifiesto Kubernetes.

## Reglas de la unidad

- `kubectl` será el cliente operativo principal del curso.
- `microk8s kubectl` se usará solo como fallback de diagnóstico.
- MicroK8s se instala dentro de Ubuntu sobre WSL2.
- La Unidad 00 no crea workloads, namespaces funcionales, charts Helm, módulos Terraform ni aplicación evolutiva.
- La Unidad 00 no construye imágenes ni habilita registry local.
- Las validaciones reales se registran solo cuando se han ejecutado en el entorno o el alumno aporta sus resultados.

## Rutas relevantes

```text
tutorial/00-environment/README.md
tutorial/00-environment/student-notes.md
tutorial/00-environment/student-reference.md
tutorial/00-environment/summary.md
platform/environment/README.md
platform/environment/container-images/README.md
platform/environment/windows/check-prerequisites.ps1
platform/environment/windows/prepare-ubuntu-wsl.ps1
platform/environment/linux/check-prerequisites.sh
platform/environment/microk8s/install.sh
platform/environment/microk8s/configure.sh
platform/environment/microk8s/validate.sh
platform/environment/microk8s/reset.sh
platform/environment/tools/install-helm.sh
platform/environment/tools/install-terraform.sh
platform/environment/tools/validate-tools.sh
platform/environment/validation/validate-environment.sh
```

Los scripts de `platform/environment/windows/` se ejecutan desde PowerShell en Windows.

Los scripts de `platform/environment/linux/`, `platform/environment/microk8s/`, `platform/environment/tools/` y `platform/environment/validation/` se ejecutan dentro de Ubuntu sobre WSL2, en la raíz del repositorio.

## Flujo de trabajo recomendado

### 1. Validar Windows y WSL2

Desde PowerShell en Windows:

```powershell
.\platform\environment\windows\check-prerequisites.ps1
wsl --status
wsl --list --verbose
```

El objetivo es comprobar que el host puede ejecutar la distribución Ubuntu objetivo sobre WSL2. Si estas comprobaciones no se han ejecutado en un equipo concreto, deben quedar como pendientes para ese equipo.

### 2. Preparar Ubuntu 24.04 LTS

Desde PowerShell, revisar primero:

```powershell
.\platform\environment\windows\prepare-ubuntu-wsl.ps1
```

Si `Ubuntu-24.04` no existe, el script muestra el comando recomendado. Con `-Install`, delega la instalación en `wsl.exe`.

Tras el primer arranque de Ubuntu, comprobar:

```powershell
wsl.exe -d Ubuntu-24.04 -- cat /etc/os-release
wsl.exe --list --verbose
```

### 3. Validar Ubuntu desde WSL

Abrir Ubuntu y situarse en la raíz del repositorio dentro del filesystem Linux:

```bash
bash platform/environment/linux/check-prerequisites.sh
```

El script no instala nada. Comprueba WSL, Ubuntu, arquitectura, `systemd`, `snap`, Git, herramientas básicas, DNS y espacio disponible.

### 4. Instalar y configurar MicroK8s

Ejecutar desde Ubuntu:

```bash
bash platform/environment/microk8s/install.sh
bash platform/environment/microk8s/configure.sh
```

El primer script instala MicroK8s y `kubectl` desde canales versionados si no existen. El segundo configura permisos, habilita `dns` y genera kubeconfig para `kubectl`.

Si el usuario se añade al grupo `microk8s`, cerrar y abrir de nuevo la sesión Ubuntu antes de asumir que los permisos están activos.

### 5. Validar MicroK8s y `kubectl`

```bash
bash platform/environment/microk8s/validate.sh
kubectl get nodes
kubectl get namespaces
```

No continuar hacia las unidades de aplicación si el clúster no está `Ready` o si `kubectl` no habla con la API esperada.

### 6. Instalar Helm y Terraform como CLI

```bash
bash platform/environment/tools/install-helm.sh
bash platform/environment/tools/install-terraform.sh
bash platform/environment/tools/validate-tools.sh
```

En esta unidad Helm y Terraform solo se instalan y validan. No se crean charts, releases, módulos, backends ni recursos.

### 7. Ejecutar validación integrada

```bash
bash platform/environment/validation/validate-environment.sh
```

La validación integrada reúne los bloques disponibles. Su resultado debe interpretarse según la fase de preparación: antes de instalar MicroK8s, Helm o Terraform, algunos avisos son esperados; al cierre, deben quedar resueltos o documentados.

### 8. Revisar contenedores e imágenes como lectura

Después de leer `tutorial/00-environment/student-reference.md`, usar:

```text
platform/environment/container-images/README.md
```

Ese laboratorio solo lee artefactos y consulta el contrato Kubernetes. No construye imágenes, no descarga imágenes y no modifica el clúster.

## Diagnóstico inicial

| Síntoma | Interpretación inicial |
|---|---|
| `wsl.exe` no existe | Revisar instalación de WSL y features de Windows |
| Ubuntu aparece como WSL1 | Convertir la distribución a WSL2 |
| `systemd` no está disponible | Resolver configuración Ubuntu/WSL antes de MicroK8s |
| `snapcraft.io` no resuelve | Revisar DNS, VPN, proxy o red corporativa |
| `microk8s status` falla | Revisar instalación y servicios de MicroK8s |
| `kubectl get nodes` falla | Revisar kubeconfig, contexto, API y permisos |
| Helm o Terraform no responden | Revisar instalación, PATH y versiones |

Los errores de modelo mental sobre contenedores, imágenes y registros están desarrollados en `tutorial/00-environment/student-reference.md`.

## Estado validado registrado

El estado histórico registrado para este repositorio indica:

| Elemento | Estado observado |
|---|---|
| Distribución WSL | `Ubuntu-24.04` instalada |
| Usuario Linux inicial | `ramon` |
| Ubuntu | 24.04.4 LTS (`noble`) |
| `systemd` | Disponible y en ejecución |
| `snap` | Disponible |
| DNS | `snapcraft.io` resuelve correctamente en validaciones finales |
| MicroK8s | Instalado desde `1.35/stable`; versión observada `v1.35.6` |
| `kubectl` | Instalado desde `1.35/stable`; versión observada `v1.35.6` |
| Nodo Kubernetes | `gmktecg2` en estado `Ready`, versión `v1.35.6` |
| Helm | `v3.21.0+ge0878d4` instalado y validado |
| Terraform | `1.15.7` instalado y validado |

Quedan como comprobaciones por equipo al replicar el laboratorio:

```text
wsl --status
wsl --list --verbose
platform/environment/windows/check-prerequisites.ps1
```

No se han ejecutado validaciones funcionales nuevas durante el saneamiento documental de la Unidad 00.

## Conexión con la Unidad 01

La Unidad 01 puede usar esta base para desplegar `platform-api` con manifiestos Kubernetes. No debe reinstalar la plataforma ni sustituir MicroK8s.

También puede apoyarse en `tutorial/00-environment/student-reference.md` para explicar:

- qué es la imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`;
- qué representa `image`;
- qué hace `imagePullPolicy`;
- por qué `ImagePullBackOff` apunta al paso de descarga de imagen;
- por qué construir imágenes propias queda diferido a CI/CD y supply chain.

## Lectura guiada

| Tema | Fuente | Qué leer | Pregunta de comprobación |
|---|---|---|---|
| WSL | [Microsoft Learn - Windows Subsystem for Linux](https://learn.microsoft.com/windows/wsl/) | Instalación, versiones de WSL y comandos básicos | Cómo demuestras que Ubuntu se ejecuta sobre WSL2 y no WSL1? |
| Ubuntu en WSL | [Ubuntu on WSL documentation](https://documentation.ubuntu.com/wsl/) | Particularidades de Ubuntu dentro de WSL | Qué diferencias pueden afectar a servicios, red o filesystem? |
| MicroK8s | [MicroK8s documentation](https://microk8s.io/docs) | Instalación, estado, addons y estaciones locales | Qué partes del procedimiento son propias de MicroK8s? |
| Kubernetes | [Kubernetes Concepts](https://kubernetes.io/docs/concepts/) | Vista general del modelo Kubernetes | Qué conceptos pertenecen a Kubernetes aunque cambie la distribución? |
| `kubectl` | [kubectl reference](https://kubernetes.io/docs/reference/kubectl/) | Contextos, acceso al clúster y comandos de inspección | Por qué `kubectl get nodes` valida algo distinto a `microk8s status`? |
| Imágenes | [Kubernetes - Images](https://kubernetes.io/docs/concepts/containers/images/) | Nombres de imagen, tags, digests y pull policies | Qué necesita el nodo para arrancar un contenedor desde una imagen? |
