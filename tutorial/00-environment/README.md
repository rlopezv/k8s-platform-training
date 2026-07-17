# Unidad 00 - Preparacion del entorno

## Estado de este documento

Este documento cubre el bloque inicial de la Unidad 00: validacion de Windows, WSL2 y Ubuntu 24.04 LTS, continuidad del trabajo desde VS Code conectado a WSL, y preparacion de MicroK8s con `kubectl`.

Helm y Terraform quedan preparados como bloques posteriores de la misma unidad. No se instalan ni se validan todavia desde este tutorial.

## Objetivo

Al finalizar este bloque, el alumno debe poder justificar con evidencias que:

- el host Windows puede ejecutar WSL2;
- existe una distribucion Ubuntu LTS objetivo para el laboratorio;
- Ubuntu se ejecuta sobre WSL2;
- `systemd`, `snap`, Git y herramientas basicas estan disponibles dentro de Ubuntu;
- MicroK8s y `kubectl` pueden instalarse y validarse mediante scripts del repositorio;
- los avisos sobre Helm y Terraform son esperados en esta fase;
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

En este bloque solo se valida hasta Ubuntu WSL. La plataforma Kubernetes se incorporara despues.

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
platform/environment/validation/validate-environment.sh
```

Los scripts de `platform/environment/windows/` se ejecutan desde PowerShell en Windows.

Los scripts de `platform/environment/linux/`, `platform/environment/microk8s/` y `platform/environment/validation/` se ejecutan dentro de Ubuntu sobre WSL2, en la raiz del repositorio.

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

## 4. Interpretar avisos esperados

En este bloque son esperados los avisos siguientes:

| Aviso | Interpretacion |
|---|---|
| `kubectl command not found` | Esperado antes de ejecutar `platform/environment/microk8s/install.sh` |
| `microk8s command not found` | Esperado antes de ejecutar `platform/environment/microk8s/install.sh` |
| `helm command not found` | Esperado; Helm se instalara despues sin crear charts |
| `terraform command not found` | Esperado; Terraform se instalara despues sin crear modulos |

Estos avisos no bloquean la validacion inicial de Ubuntu. Si aparecen fallos (`FAIL`) en WSL, Ubuntu, `snap`, DNS o espacio disponible, no continuar con MicroK8s hasta resolverlos.

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

## 11. Estado validado hasta ahora

Resultados aportados para este repositorio:

| Elemento | Estado observado |
|---|---|
| Distribucion WSL | `Ubuntu-24.04` instalada |
| Usuario Linux inicial | `ramon` |
| Ubuntu | 24.04.4 LTS (`noble`) |
| `systemd` | Disponible; validacion previa en ejecucion, validacion actual con estado `unknown` |
| `snap` | Disponible (`2.73+ubuntu24.04`) |
| Herramientas base | Git, `curl`, `tar` y `gzip` disponibles |
| DNS | Validacion previa correcta; validacion actual no resolvio `snapcraft.io` |
| Espacio libre en `$HOME` | 952-954 GB observados |
| Validacion Linux inicial | 0 fallos; avisos esperados por herramientas pendientes |
| Validacion integrada Linux | El bloque Ubuntu no tiene fallos; el bloque MicroK8s falla hasta instalar `microk8s` y `kubectl` |

No se ha validado todavia:

```text
microk8s status --wait-ready
microk8s version
kubectl version --client
kubectl get nodes
helm version
terraform version
```

## 12. Siguiente bloque

El siguiente incremento de la Unidad 00, despues de validar MicroK8s y `kubectl` con resultados reales, debe instalar y validar Helm y Terraform sin crear charts ni modulos.

No iniciar la Unidad 01 hasta cerrar completamente la Unidad 00.
