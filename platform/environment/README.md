# Entorno de plataforma - Unidad 00

## Proposito

Este directorio contiene los artefactos ejecutables para preparar y validar el entorno local de la Unidad 00.

La guia pedagogica del alumno vive en:

```text
tutorial/00-environment/README.md
```

Este archivo funciona como referencia tecnica de los scripts: contexto de ejecucion, efectos, repeticion, validaciones y limites.

La plataforma objetivo es:

```text
Windows 11 -> WSL2 -> Ubuntu LTS -> MicroK8s -> kubectl
```

## Principio operativo

`kubectl` sera el cliente principal para operar Kubernetes durante todo el curso.

Los comandos `microk8s` se limitaran a:

- instalar MicroK8s;
- consultar estado propio de MicroK8s;
- habilitar o revisar addons;
- generar kubeconfig;
- diagnosticar o recuperar la distribucion local.

## Estructura prevista

```text
platform/environment/
├── README.md
├── microk8s/
│   ├── configure.sh
│   ├── install.sh
│   ├── reset.sh
│   └── validate.sh
├── tools/
│   ├── install-helm.sh
│   ├── install-terraform.sh
│   └── validate-tools.sh
├── windows/
│   ├── check-prerequisites.ps1
│   └── prepare-ubuntu-wsl.ps1
├── linux/
│   └── check-prerequisites.sh
└── validation/
    └── validate-environment.sh
```

Los scripts de herramientas ya forman parte de la Unidad 00. Instalan y validan Helm y Terraform como CLI sin crear charts, releases, modulos, backends ni recursos.

## Separacion por contexto

Los scripts de `windows/` se ejecutaran desde PowerShell en el host Windows.

Los scripts de `linux/`, `microk8s/`, `tools/` y `validation/` se ejecutaran dentro de Ubuntu sobre WSL2.

Los scripts de MicroK8s asumiran que Ubuntu sobre WSL2 ya existe. No deben instalar WSL2 ni crear la distribucion Ubuntu.

## Addons iniciales

El primer diseno habilitara solo:

```text
dns
```

Otros addons se incorporaran en unidades posteriores o en correcciones justificadas de esta unidad.

## Versiones objetivo

| Producto | Baseline inicial |
|---|---|
| Ubuntu | 24.04 LTS |
| MicroK8s | `1.35/stable` |
| Kubernetes | 1.35.x |
| kubectl | 1.35.x compatible |
| Helm | 3.21.x |
| Terraform | 1.15.x |

Los scripts deben validar versiones reales y no registrar como instalado ningun componente que no haya sido comprobado.

## Validacion esperada

La validacion final debera comprobar, como minimo:

```bash
microk8s status --wait-ready
microk8s version
kubectl version --client
kubectl get nodes
kubectl get namespaces
helm version
terraform version
```

No se considerara que estas validaciones han sido ejecutadas hasta disponer de resultados reales del entorno.

## Scripts disponibles

### Windows

Ejecutar desde PowerShell en el host Windows:

```powershell
.\platform\environment\windows\check-prerequisites.ps1
```

El script comprueba de forma no destructiva:

- version de Windows;
- presencia de hipervisor;
- features de WSL y Virtual Machine Platform;
- disponibilidad de `wsl.exe`;
- salida de `wsl --status`;
- salida de `wsl --list --verbose`;
- espacio libre basico en el disco del sistema.

Comportamiento al repetir:

- seguro de ejecutar varias veces;
- no modifica features de Windows;
- no instala WSL ni distribuciones;
- devuelve codigo distinto de cero solo si detecta fallos bloqueantes.

Preparar la distribucion Ubuntu objetivo desde PowerShell:

```powershell
.\platform\environment\windows\prepare-ubuntu-wsl.ps1
```

Por defecto el script no instala nada. Valida WSL, comprueba si existe la distribucion objetivo y muestra el comando recomendado:

```powershell
wsl.exe --install Ubuntu-24.04
```

Para ejecutar la instalacion de forma explicita:

```powershell
.\platform\environment\windows\prepare-ubuntu-wsl.ps1 -Install
```

Tras la primera ejecucion de Ubuntu y la creacion del usuario Linux, validar:

```powershell
wsl.exe -d Ubuntu-24.04 -- cat /etc/os-release
wsl.exe --list --verbose
```

Comportamiento al repetir:

- sin `-Install`, es una revision no destructiva;
- si la distribucion objetivo ya existe como WSL2, termina correctamente sin reinstalar;
- si existe pero no se confirma WSL2, informa del comando de conversion;
- con `-Install`, delega la instalacion en `wsl.exe --install Ubuntu-24.04`.

Recuperacion:

- si `wsl.exe --install` falla, resolver primero el error de Windows/WSL;
- no borrar distribuciones desde este script;
- no versionar kubeconfigs, credenciales ni datos del usuario Linux.

### Ubuntu sobre WSL2

Ejecutar desde Ubuntu, en la raiz del repositorio:

```bash
bash platform/environment/linux/check-prerequisites.sh
```

El script comprueba de forma no destructiva:

- si el kernel parece ejecutarse bajo WSL;
- distribucion y version de Ubuntu;
- arquitectura;
- disponibilidad de `systemctl`, `snap`, `git`, `curl`, `tar` y `gzip`;
- presencia de `kubectl`, MicroK8s, Helm y Terraform cuando ya existan;
- espacio libre en el filesystem de `$HOME`;
- resolucion DNS basica.

Comportamiento al repetir:

- seguro de ejecutar varias veces;
- no instala paquetes;
- no cambia permisos;
- no inicia ni detiene servicios;
- los avisos de `kubectl`, MicroK8s, Helm y Terraform son esperados antes de su instalacion.

### MicroK8s y kubectl

Ejecutar desde Ubuntu, en la raiz del repositorio.

Instalar MicroK8s y `kubectl`:

```bash
bash platform/environment/microk8s/install.sh
```

Efectos:

- instala MicroK8s mediante `snap` con canal `1.35/stable` si no existe;
- instala `kubectl` mediante `snap` con canal `1.35/stable` si no existe;
- no instala Helm ni Terraform;
- bloquea la instalacion si `snapcraft.io` no resuelve.

Variables admitidas:

```bash
MICROK8S_CHANNEL=1.35/stable
KUBECTL_CHANNEL=1.35/stable
```

Configurar permisos, addon `dns` y kubeconfig:

```bash
bash platform/environment/microk8s/configure.sh
```

Efectos:

- anade el usuario actual al grupo `microk8s` si procede;
- habilita unicamente el addon `dns`;
- escribe `~/.kube/config` desde la configuracion de MicroK8s;
- puede requerir cerrar y reabrir la sesion Ubuntu para aplicar grupos.

Validar MicroK8s y `kubectl`:

```bash
bash platform/environment/microk8s/validate.sh
```

El script es de solo lectura y comprueba:

- `microk8s status --wait-ready`;
- `microk8s version`;
- addon `dns`;
- `kubectl version --client`;
- `kubectl get nodes`;
- `kubectl get namespaces`.

Reset controlado:

```bash
bash platform/environment/microk8s/reset.sh
bash platform/environment/microk8s/reset.sh --confirm-reset
```

Sin `--confirm-reset`, el script solo muestra el impacto. Con confirmacion, ejecuta `microk8s reset`. No elimina Ubuntu, WSL ni Windows.

### Helm y Terraform

Ejecutar desde Ubuntu, en la raiz del repositorio.

Instalar Helm:

```bash
bash platform/environment/tools/install-helm.sh
```

Efectos:

- instala Helm `v3.21.0` como CLI local en `/usr/local/bin/helm`;
- descarga desde `https://get.helm.sh`;
- verifica checksum SHA256;
- no crea charts ni releases.

Variable admitida:

```bash
HELM_VERSION=v3.21.0
```

Instalar Terraform:

```bash
bash platform/environment/tools/install-terraform.sh
```

Efectos:

- instala Terraform `1.15.7` como CLI local en `/usr/local/bin/terraform`;
- descarga desde `https://releases.hashicorp.com`;
- verifica checksum SHA256;
- instala `unzip` mediante `apt-get` si falta;
- no crea modulos, backends ni recursos.

Variable admitida:

```bash
TERRAFORM_VERSION=1.15.7
```

Validar herramientas:

```bash
bash platform/environment/tools/validate-tools.sh
```

El script es de solo lectura y comprueba:

- `helm version`;
- `terraform version`;
- versiones alineadas con Helm `3.21.x` y Terraform `1.15.x`.

### Validacion integrada Linux

Ejecutar desde Ubuntu, en la raiz del repositorio:

```bash
bash platform/environment/validation/validate-environment.sh
```

Ejecuta las validaciones Linux disponibles, la validacion MicroK8s/kubectl y la validacion de herramientas cuando los scripts existen. No instala MicroK8s, Helm, Terraform ni `kubectl`.

Comportamiento al repetir:

- seguro de ejecutar varias veces;
- falla si alguna validacion integrada devuelve fallos bloqueantes;
- falla si MicroK8s o `kubectl` no estan instalados despues de crear el bloque MicroK8s;
- falla si Helm o Terraform no estan instalados despues de crear el bloque de herramientas;
- debe usarse como validacion global despues de ejecutar los scripts de instalacion/configuracion correspondientes.

## Validaciones ejecutadas en el entorno actual

Resultados aportados por el usuario para la Unidad 00:

| Validacion | Resultado |
|---|---|
| `platform/environment/windows/prepare-ubuntu-wsl.ps1 -Install` | `Ubuntu-24.04` instalada correctamente |
| Primer arranque Ubuntu | Correcto; usuario inicial `ramon` |
| `cat /etc/os-release` | Ubuntu 24.04.4 LTS (`noble`) |
| `platform/environment/linux/check-prerequisites.sh` | 0 fallos y 4 avisos esperados |
| `platform/environment/validation/validate-environment.sh` | Ejecutada sin fallos bloqueantes despues de validar MicroK8s, `kubectl`, Helm y Terraform |
| `systemd` | Disponible y en ejecucion |
| `snap` | Disponible (`2.76`) |
| DNS | `snapcraft.io` resuelve correctamente |
| Espacio libre en `$HOME` | 951-954 GB observados |
| Scripts MicroK8s | Creados y validados funcionalmente por el usuario |
| Scripts Helm/Terraform | Creados y validados funcionalmente por el usuario |
| Helm | `v3.21.0+ge0878d4` |
| Terraform | `1.15.7` |

## Pendientes conocidos

Quedan pendientes de evidencia directa completa desde Windows/PowerShell:

```text
wsl --status
wsl --list --verbose
platform/environment/windows/check-prerequisites.ps1
```

Estas comprobaciones no cambian el resultado validado de Ubuntu, MicroK8s, `kubectl`, Helm y Terraform, pero deben mantenerse visibles para diagnosticar diferencias entre equipos Windows.
