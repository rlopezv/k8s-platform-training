# Entorno de plataforma - Unidad 00

## Proposito

Este directorio contendra los artefactos ejecutables para preparar y validar el entorno local de la Unidad 00.

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
├── windows/
│   └── check-prerequisites.ps1
├── linux/
│   └── check-prerequisites.sh
└── validation/
    └── validate-environment.sh
```

Los scripts de instalacion, configuracion, herramientas y recuperacion se anadiran en incrementos posteriores.

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

### Validacion integrada Linux

Ejecutar desde Ubuntu, en la raiz del repositorio:

```bash
bash platform/environment/validation/validate-environment.sh
```

Por ahora ejecuta las validaciones Linux disponibles. No instala MicroK8s, Helm, Terraform ni `kubectl`.
