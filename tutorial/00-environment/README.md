# Unidad 00 - Preparacion del entorno

## Guia pedagogica de la unidad

Esta unidad no ensena Kubernetes todavia. Ensena algo anterior y muy importante: como construir un entorno de aprendizaje confiable.

En muchos equipos, los primeros problemas con Kubernetes no vienen de Kubernetes. Vienen de una instalacion incompleta, de WSL mal configurado, de una terminal que no ha cargado permisos, de DNS bloqueado por una VPN, de un `kubectl` apuntando a otro cluster o de una herramienta instalada pero no validada. Si esos problemas se mezclan con los conceptos del curso, el alumno aprende a probar comandos al azar en vez de razonar.

Por eso esta unidad cubre la base operativa del itinerario:

- que significa trabajar sobre Windows, WSL2 y Ubuntu;
- por que MicroK8s es una distribucion local de Kubernetes, no "todo Kubernetes";
- que papel cumple `kubectl` como cliente principal;
- por que Helm y Terraform se instalan ahora pero no se usan todavia;
- que diferencia hay entre instalar, configurar, validar y registrar evidencia;
- como decidir si un fallo pertenece al host, a Linux, a MicroK8s, a la red o a una herramienta.

El laboratorio ejecutable esta en `platform/environment/`. Este README debe leerse como el capitulo que explica por que se hacen esas comprobaciones y que aprende el alumno al interpretarlas.

## Mapa de aprendizaje

| Bloque | Que cubre | Que debe poder explicar el alumno |
|---|---|---|
| Host Windows | Requisitos minimos para ejecutar WSL2 | Por que Kubernetes local depende de virtualizacion y soporte del host |
| WSL2 | Capa Linux integrada en Windows | Por que el laboratorio se ejecuta dentro de Ubuntu y no directamente en PowerShell |
| Ubuntu | Sistema donde correran scripts, snaps y herramientas | Que senales muestran que Linux esta preparado para operar servicios |
| MicroK8s | Distribucion Kubernetes local | Que partes son especificas de MicroK8s y cuales son API Kubernetes estandar |
| `kubectl` | Cliente operativo del curso | Por que validar `kubectl get nodes` prueba acceso a la API del cluster |
| Helm y Terraform | Herramientas futuras | Por que instalar una CLI no significa que ya gestione recursos del curso |

## Que no intenta ensenar esta unidad

Esta unidad no intenta que el alumno despliegue aplicaciones, disene manifests, entienda Deployments, exponga Services ni use Helm o Terraform de forma practica. Eso seria demasiado pronto.

El objetivo es que, cuando en la Unidad 01 aparezca el primer workload, el alumno pueda decir: "el cluster esta disponible, el cliente habla con la API, el nodo esta Ready y las herramientas base responden". Esa frase parece sencilla, pero evita horas de diagnostico confuso.

## Estado de este documento

Este documento cubre la Unidad 00 completa: validacion de Windows, WSL2 y Ubuntu 24.04 LTS, continuidad del trabajo desde VS Code conectado a WSL, preparacion de MicroK8s con `kubectl`, e instalacion de Helm y Terraform como herramientas CLI.

Helm y Terraform se instalan y validan como herramientas base. En esta unidad no se crean charts, releases, modulos, backends ni recursos.

## Problema real que resuelve

Antes de aprender Kubernetes hace falta eliminar una fuente habitual de ruido: no saber si un fallo viene del concepto que se esta practicando, del sistema operativo, de la virtualizacion, de la red, de permisos locales o del propio cluster.

La Unidad 00 crea una estacion de trabajo local con evidencias. El objetivo no es "tener MicroK8s instalado" como fin en si mismo, sino construir una base donde las unidades posteriores puedan fallar por razones formativas y diagnosticables, no por una preparacion opaca del equipo.

## Por que aparece al inicio

Kubernetes es una plataforma distribuida incluso cuando se ejecuta en un unico portatil. Si se empieza desplegando una aplicacion sin entender las capas inferiores, cada error se vuelve ambiguo: puede parecer un problema de YAML cuando en realidad falta `systemd`, falla DNS, el usuario no pertenece al grupo correcto o `kubectl` apunta a otro contexto.

Por eso esta unidad separa dos trabajos distintos:

- preparar una plataforma local de aprendizaje;
- desplegar aplicaciones sobre esa plataforma.

La primera responsabilidad pertenece a la Unidad 00. La segunda empieza en la Unidad 01.

## Objetivo

Al finalizar este bloque, el alumno debe poder justificar con evidencias que:

- el host Windows puede ejecutar WSL2;
- existe una distribucion Ubuntu LTS objetivo para el laboratorio;
- Ubuntu se ejecuta sobre WSL2;
- `systemd`, `snap`, Git y herramientas basicas estan disponibles dentro de Ubuntu;
- MicroK8s y `kubectl` pueden instalarse y validarse mediante scripts del repositorio;
- Helm y Terraform pueden instalarse y validarse como CLI sin crear artefactos funcionales;
- el repositorio puede continuarse desde VS Code conectado directamente a Ubuntu WSL.

## Arquitectura objetivo

La Unidad 00 construye el entorno en esta secuencia:

```text
Windows 11
  -> WSL2
    -> Ubuntu 24.04 LTS
      -> MicroK8s
        -> kubectl
```

La plataforma Kubernetes local se incorpora durante la misma unidad, despues de validar Ubuntu WSL.

## Modelo mental de la unidad

Piensa el entorno como una pila de contratos. Cada capa ofrece una capacidad a la siguiente:

| Capa | Contrato que debe cumplir | Evidencia |
|---|---|---|
| Windows | Puede ejecutar virtualizacion y WSL2 | `wsl --status`, features Windows |
| WSL2 | Ejecuta una distribucion Linux realista para laboratorio | `wsl --list --verbose` |
| Ubuntu | Tiene servicios, paquetes, red y herramientas base | `systemd`, `snap`, Git, DNS |
| MicroK8s | Proporciona una distribucion Kubernetes local | `microk8s status --wait-ready` |
| `kubectl` | Habla con la API Kubernetes como cliente estandar | `kubectl get nodes` |

Cuando una validacion falla, no conviene saltar directamente a reinstalar. Primero hay que ubicar en que capa se rompe el contrato y que capa depende de ella.

## Plataforma local frente a Kubernetes estandar

MicroK8s es la distribucion local elegida para el laboratorio inicial. Kubernetes, en cambio, es la API y el modelo operativo que se mantendran cuando el itinerario avance hacia plataformas gestionadas.

En esta unidad son especificos del entorno local:

- Windows 11 como host;
- WSL2 como capa de virtualizacion Linux;
- Ubuntu 24.04 LTS como distribucion objetivo;
- instalacion de MicroK8s mediante `snap`;
- addons propios de MicroK8s;
- scripts de preparacion en `platform/environment/`.

Son conceptos y practicas transferibles:

- validar precondiciones antes de desplegar;
- usar `kubectl` como cliente principal;
- comprobar contexto y conectividad con la API;
- registrar versiones reales;
- distinguir instalacion, configuracion y validacion;
- documentar limitaciones no verificadas.

Esta separacion evita confundir "como se instala el laboratorio local" con "como funciona Kubernetes".

## Reglas de la unidad

- `kubectl` sera el cliente operativo principal del curso.
- `microk8s kubectl` se usara solo como fallback de diagnostico.
- MicroK8s se instalara dentro de Ubuntu sobre WSL2.
- La Unidad 00 no crea workloads, namespaces funcionales, charts Helm, modulos Terraform ni aplicacion evolutiva.
- Las validaciones reales se registran solo cuando se han ejecutado en el entorno o el alumno aporta sus resultados.

## Rutas relevantes

```text
tutorial/00-environment/README.md
tutorial/00-environment/summary.md
platform/environment/README.md
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

Los scripts de `platform/environment/linux/`, `platform/environment/microk8s/`, `platform/environment/tools/` y `platform/environment/validation/` se ejecutan dentro de Ubuntu sobre WSL2, en la raiz del repositorio.

## 1. Validar Windows y WSL2

Abrir PowerShell en Windows y situarse en la raiz del repositorio.

Ejecutar:

```powershell
.\platform\environment\windows\check-prerequisites.ps1
```

El script es no destructivo. Comprueba senales del host:

- edicion y build de Windows;
- presencia de hipervisor;
- features `Microsoft-Windows-Subsystem-Linux` y `VirtualMachinePlatform`;
- disponibilidad de `wsl.exe`;
- salida de `wsl --status`;
- salida de `wsl --list --verbose`;
- espacio libre basico.

Resultado esperado:

```text
Completed without blocking failures. Review WARN entries before continuing.
```

Un `WARN` no siempre bloquea. Debe revisarse antes de continuar porque puede indicar una feature pendiente, una version no confirmada o un entorno que necesita reinicio.

## 2. Preparar Ubuntu 24.04 LTS

Desde PowerShell, ejecutar primero en modo revision:

```powershell
.\platform\environment\windows\prepare-ubuntu-wsl.ps1
```

Si `Ubuntu-24.04` no existe, el script muestra el comando recomendado:

```powershell
wsl.exe --install Ubuntu-24.04
```

Para lanzar la instalacion desde el script, usar:

```powershell
.\platform\environment\windows\prepare-ubuntu-wsl.ps1 -Install
```

La instalacion puede requerir permisos elevados, reinicio o apertura manual de Ubuntu para crear el primer usuario Linux.

Tras el primer arranque, comprobar desde PowerShell:

```powershell
wsl.exe -d Ubuntu-24.04 -- cat /etc/os-release
wsl.exe --list --verbose
```

Resultado esperado:

```text
Ubuntu 24.04.x LTS
Ubuntu-24.04    Running o Stopped    2
```

Si la distribucion aparece como version `1`, convertirla explicitamente:

```powershell
wsl.exe --set-version Ubuntu-24.04 2
```

## 3. Validar Ubuntu desde WSL

Abrir Ubuntu 24.04 y situarse en la raiz del repositorio desde el filesystem Linux.

Ejecutar:

```bash
bash platform/environment/linux/check-prerequisites.sh
```

El script no instala nada. Comprueba:

- marcador WSL en el kernel;
- distribucion Ubuntu y version;
- arquitectura;
- estado de `systemd`;
- disponibilidad de `snap`;
- Git, `curl`, `tar` y `gzip`;
- presencia o ausencia de `kubectl`, MicroK8s, Helm y Terraform;
- espacio libre en `$HOME`;
- resolucion DNS para `snapcraft.io`.

Despues ejecutar la validacion integrada:

```bash
bash platform/environment/validation/validate-environment.sh
```

Resultado esperado antes de instalar MicroK8s:

```text
Ubuntu/WSL prerequisites completed
MicroK8s and kubectl exited with 1
```

La validacion integrada falla hasta que MicroK8s y `kubectl` existan. En este punto es aceptable que el bloque Ubuntu no tenga fallos y que el bloque MicroK8s indique que los comandos faltan.

## 4. Interpretar avisos por fase

Antes de instalar cada componente son esperados los avisos siguientes:

| Aviso | Interpretacion |
|---|---|
| `kubectl command not found` | Esperado antes de ejecutar `platform/environment/microk8s/install.sh` |
| `microk8s command not found` | Esperado antes de ejecutar `platform/environment/microk8s/install.sh` |
| `helm command not found` | Esperado antes de ejecutar `platform/environment/tools/install-helm.sh` |
| `terraform command not found` | Esperado antes de ejecutar `platform/environment/tools/install-terraform.sh` |

Estos avisos no bloquean la validacion inicial de Ubuntu. Si aparecen fallos (`FAIL`) en WSL, Ubuntu, `snap`, DNS o espacio disponible, no continuar con MicroK8s hasta resolverlos.

## Errores de razonamiento frecuentes

| Error de razonamiento | Por que confunde | Mejor criterio |
|---|---|---|
| "Si el script existe, el entorno esta validado" | Un script versionado solo define una comprobacion; no demuestra que se haya ejecutado bien. | Registrar comando ejecutado, fecha o resultado observado. |
| "MicroK8s es Kubernetes" | MicroK8s empaqueta Kubernetes con decisiones locales propias. | Separar API estandar de distribucion local. |
| "Helm y Terraform instalados significan que ya se usan" | Una CLI disponible no implica que gestione recursos del curso. | Distinguir herramienta instalada de artefacto creado. |
| "Un reset arregla cualquier problema" | Puede borrar estado local util y ocultar la causa real. | Diagnosticar capa por capa antes de limpiar. |
| "Un WARN es irrelevante" | Algunos avisos son esperados por fase, otros anticipan bloqueo posterior. | Leer el aviso contra la fase actual. |

## 5. Troubleshooting inicial

### `wsl.exe` no existe

Revisar que WSL este instalado y habilitado en Windows. Ejecutar las comprobaciones desde PowerShell, no desde Ubuntu.

```powershell
wsl --status
```

Si el comando no existe, instalar WSL siguiendo el procedimiento corporativo o la instalacion oficial de Windows.

### La distribucion no es WSL2

Comprobar:

```powershell
wsl --list --verbose
```

Si `Ubuntu-24.04` aparece con version `1`:

```powershell
wsl --set-version Ubuntu-24.04 2
```

### Ubuntu no es 24.04 LTS

Ubuntu 24.04 LTS es la baseline principal de la unidad. Ubuntu 22.04 LTS puede aceptarse temporalmente si ya existe y pasa validaciones, pero el estado consolidado del proyecto debe registrar la version real.

### `systemd` no esta disponible

MicroK8s requiere un entorno WSL2 con soporte de `systemd`. Revisar dentro de Ubuntu:

```bash
systemctl is-system-running
```

Estados como `running` o `degraded` pueden ser operativos para esta fase. Si `systemctl` no existe, revisar la version de WSL y la configuracion de Ubuntu antes de instalar MicroK8s.

### `snap` no esta disponible

MicroK8s se instalara mediante `snap`. Validar:

```bash
snap version
```

Si falta `snap`, no instalar MicroK8s todavia. Resolver primero la preparacion base de Ubuntu.

### DNS no resuelve `snapcraft.io`

Validar:

```bash
getent hosts snapcraft.io
```

Si falla, revisar conectividad, DNS corporativo, proxy o VPN. No guardar credenciales, certificados privados ni configuraciones sensibles en el repositorio.

### El repositorio esta en una ruta de Windows

Para trabajar desde WSL, preferir una ruta Linux, por ejemplo:

```text
/home/<usuario>/git/k8s-platform-training
```

Evitar ejecutar scripts Linux desde `/mnt/c/...` si aparecen problemas de permisos, rendimiento o finales de linea.

## 6. Continuar desde VS Code en WSL

El flujo recomendado para continuar la Unidad 00 es abrir VS Code conectado a la distribucion `Ubuntu-24.04`.

Desde Ubuntu:

```bash
cd ~/git/k8s-platform-training
pwd
git status --short
```

La ruta debe apuntar al repositorio dentro de Linux.

Si se usa VS Code con soporte WSL, abrir el workspace desde esa shell:

```bash
code .
```

Una vez dentro de VS Code, confirmar que la terminal integrada muestra una ruta Linux y no una ruta de Windows:

```bash
pwd
cat /etc/os-release
```

## 7. Instalar MicroK8s y kubectl

Antes de instalar, repetir la validacion base:

```bash
bash platform/environment/linux/check-prerequisites.sh
```

Si `snapcraft.io` no resuelve, no continuar. MicroK8s y `kubectl` se instalan mediante `snap`, por lo que el script de instalacion bloquea cuando detecta ese fallo.

Ejecutar:

```bash
bash platform/environment/microk8s/install.sh
```

El script:

- valida que se ejecuta en Ubuntu sobre WSL;
- comprueba `sudo`, `snap` y DNS hacia `snapcraft.io`;
- instala MicroK8s desde el canal `1.35/stable` si no existe;
- instala `kubectl` desde el canal `1.35/stable` si no existe;
- no instala Helm ni Terraform.

Comportamiento al repetir:

- si MicroK8s ya existe, no lo reinstala;
- si `kubectl` ya existe como snap, no lo reinstala;
- si falla DNS, bloquea antes de modificar el sistema;
- si `snap` falla durante la instalacion, deja el error visible y termina con fallo.

## 8. Configurar MicroK8s y kubeconfig

Ejecutar:

```bash
bash platform/environment/microk8s/configure.sh
```

El script:

- valida que `microk8s` y `kubectl` existen;
- anade el usuario actual al grupo `microk8s` si todavia no pertenece;
- habilita unicamente el addon `dns`;
- genera `~/.kube/config` desde MicroK8s para que `kubectl` sea el cliente operativo principal.

Si el script indica que ha anadido el usuario al grupo `microk8s`, cerrar y volver a abrir la sesion Ubuntu antes de asumir que los permisos estan aplicados.

`microk8s kubectl` queda reservado para diagnostico, por ejemplo para aislar si el problema esta en `kubectl`, en kubeconfig o en el propio clúster.

## 9. Validar MicroK8s y kubectl

Ejecutar:

```bash
bash platform/environment/microk8s/validate.sh
```

Resultado esperado despues de instalar y configurar:

```text
MicroK8s validation summary: 0 failure(s), 0 warning(s).
```

Validaciones principales:

```bash
microk8s status --wait-ready
microk8s version
kubectl version --client
kubectl get nodes
kubectl get namespaces
```

Despues ejecutar la validacion integrada:

```bash
bash platform/environment/validation/validate-environment.sh
```

No continuar hacia Helm y Terraform hasta que MicroK8s y `kubectl` esten validados o el problema quede registrado.

## 10. Reset controlado de MicroK8s

El reset no se ejecuta por defecto.

Para ver el aviso:

```bash
bash platform/environment/microk8s/reset.sh
```

Para ejecutar un reset de MicroK8s:

```bash
bash platform/environment/microk8s/reset.sh --confirm-reset
```

Este reset afecta solo al clúster MicroK8s local. No elimina Ubuntu, WSL ni configuraciones de Windows.

## 11. Instalar Helm y Terraform

Helm y Terraform se instalan como herramientas de linea de comandos para preparar las unidades posteriores.

En esta unidad no se crean charts, releases de Helm, modulos Terraform, backends ni recursos.

Instalar Helm:

```bash
bash platform/environment/tools/install-helm.sh
```

El script instala Helm `v3.21.0` desde un tarball versionado de `get.helm.sh` y verifica el checksum SHA256 antes de copiar el binario a `/usr/local/bin/helm`.

Instalar Terraform:

```bash
bash platform/environment/tools/install-terraform.sh
```

El script instala Terraform `1.15.7` desde `releases.hashicorp.com`, verifica el checksum SHA256 y copia el binario a `/usr/local/bin/terraform`.

Si falta `unzip`, el script de Terraform intentara instalarlo mediante `apt-get`, porque Terraform se distribuye como archivo zip.

Validar herramientas:

```bash
bash platform/environment/tools/validate-tools.sh
```

Resultado esperado:

```text
Tools validation summary: 0 failure(s), 0 warning(s).
```

Despues ejecutar la validacion integrada:

```bash
bash platform/environment/validation/validate-environment.sh
```

## 12. Estado validado hasta ahora

Resultados aportados para este repositorio:

| Elemento | Estado observado |
|---|---|
| Distribucion WSL | `Ubuntu-24.04` instalada |
| Usuario Linux inicial | `ramon` |
| Ubuntu | 24.04.4 LTS (`noble`) |
| `systemd` | Disponible y en ejecucion |
| `snap` | Disponible (`2.73+ubuntu24.04`) |
| Herramientas base | Git, `curl`, `tar` y `gzip` disponibles |
| DNS | `snapcraft.io` resuelve correctamente en las validaciones finales |
| Espacio libre en `$HOME` | 952-954 GB observados |
| Validacion Linux inicial | 0 fallos; avisos esperados antes de instalar componentes |
| DNS `snapcraft.io` | Resuelve correctamente antes de instalar MicroK8s |
| MicroK8s | Instalado desde `1.35/stable`; version observada `v1.35.6` |
| `kubectl` | Instalado desde `1.35/stable`; version observada `v1.35.6` |
| Nodo Kubernetes | `gmktecg2` en estado `Ready`, version `v1.35.6` |
| Namespaces de sistema | `default`, `kube-node-lease`, `kube-public` y `kube-system` activos |
| Validacion MicroK8s | `platform/environment/microk8s/validate.sh` con 0 fallos y 0 avisos |
| Helm | `v3.21.0+ge0878d4` instalado y validado |
| Terraform | `1.15.7` instalado y validado |
| Validacion herramientas | `platform/environment/tools/validate-tools.sh` con 0 fallos y 0 avisos |
| Validacion integrada | Completada sin fallos bloqueantes tras validar MicroK8s, `kubectl`, Helm y Terraform |
| Revalidacion integrada desde Codex | Bloqueada en `microk8s status/version` por sesion no interactiva sin grupo `microk8s`; `kubectl get nodes`, Helm y Terraform responden correctamente |

Quedan sin evidencia directa completa desde esta sesion Linux:

```text
wsl --status
wsl --list --verbose
platform/environment/windows/check-prerequisites.ps1
```

## 13. Siguiente bloque

La Unidad 00 queda lista para cierre documental con las limitaciones registradas. Antes de iniciar contenido de Unidad 01, confirmar que `tutorial/00-environment/summary.md` y `project/project-state.md` reflejan el estado final.

No crear workloads, charts, modulos Terraform ni aplicacion evolutiva como parte de este cierre.

## Lectura guiada

### Referencias oficiales

| Tema | Referencia | Que leer | Pregunta de comprobacion |
|---|---|---|---|
| WSL | [Microsoft Learn - Windows Subsystem for Linux](https://learn.microsoft.com/windows/wsl/) | Instalacion, versiones de WSL y comandos basicos. | Como demuestras que Ubuntu se ejecuta sobre WSL2 y no WSL1? |
| MicroK8s | [MicroK8s documentation](https://microk8s.io/docs) | Instalacion, estado, addons y uso en estaciones locales. | Que partes del procedimiento son propias de MicroK8s? |
| Kubernetes | [Kubernetes Concepts](https://kubernetes.io/docs/concepts/) | Vista general del modelo Kubernetes que se usara desde Unidad 01. | Que conceptos pertenecen a Kubernetes aunque cambie la distribucion? |
| kubectl | [kubectl reference](https://kubernetes.io/docs/reference/kubectl/) | Contextos, acceso al cluster y comandos de inspeccion. | Por que `kubectl get nodes` valida algo distinto a `microk8s status`? |

### Lecturas complementarias

| Tema | Referencia | Uso recomendado |
|---|---|---|
| Ubuntu en WSL | [Ubuntu on WSL documentation](https://documentation.ubuntu.com/wsl/) | Resolver dudas especificas de Ubuntu dentro de WSL. |
| systemd en WSL | [Microsoft Learn - systemd support](https://learn.microsoft.com/windows/wsl/systemd) | Entender por que algunos servicios Linux necesitan `systemd`. |
