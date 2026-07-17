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
│   ├── check-prerequisites.ps1
│   └── setup-wsl.ps1
├── linux/
│   ├── check-prerequisites.sh
│   └── prepare-ubuntu.sh
├── microk8s/
│   ├── install.sh
│   ├── configure.sh
│   ├── validate.sh
│   └── reset.sh
├── tools/
│   ├── install-helm.sh
│   ├── install-terraform.sh
│   └── validate-tools.sh
└── validation/
    └── validate-environment.sh
```

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
