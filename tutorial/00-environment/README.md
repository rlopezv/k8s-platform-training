# Unidad 00 - Preparacion del entorno

## Estado de este documento

Este archivo inicia el diseno de la Unidad 00. No es todavia el tutorial completo del alumno.

La unidad queda orientada por una decision operativa clave:

```text
kubectl sera el cliente principal para operar Kubernetes.
```

MicroK8s se utilizara como distribucion local inicial dentro de Ubuntu sobre WSL2, pero sus comandos propios se reservaran para instalacion, configuracion, gestion de addons, diagnostico y recuperacion.

## Arquitectura objetivo

El entorno se construira en esta secuencia:

```text
Windows 11
  -> WSL2
    -> Ubuntu LTS
      -> MicroK8s
        -> kubeconfig para kubectl
```

MicroK8s no instala ni prepara WSL2 por si mismo. Para instalar MicroK8s ya debe existir una distribucion Ubuntu sobre WSL2.

## Decisiones iniciales

| Decision | Estado | Consecuencia |
|---|---|---|
| `kubectl` como cliente operativo principal | Aprobada | Los comandos Kubernetes del curso usaran `kubectl` |
| `microk8s kubectl` como fallback de diagnostico | Aprobada | Solo se usara antes de completar la configuracion de `kubectl` o para aislar problemas |
| MicroK8s dentro de Ubuntu/WSL2 | Aprobada | Los scripts MicroK8s se ejecutaran desde Ubuntu, no desde PowerShell |
| Addon inicial `dns` | Aprobada para el primer diseno | Otros addons quedan diferidos hasta que una unidad los necesite |
| Sin workloads funcionales | Aprobada | La aplicacion evolutiva no se crea en la Unidad 00 |

## Politica inicial de versiones

| Producto | Baseline inicial | Criterio |
|---|---|---|
| Windows | Windows 11 soportado | Validar version y build; no fijar build exacta |
| WSL | WSL2 actualizado | Validar con `wsl --status` |
| Ubuntu | 24.04 LTS | Baseline principal; aceptar 22.04 LTS si ya existe y pasa validaciones |
| MicroK8s | `1.35/stable` | Canal snap fijo |
| Kubernetes | 1.35.x | Derivado de MicroK8s |
| kubectl | 1.35.x compatible | Alineado con el API server |
| Helm | 3.21.x | Baseline inicial; reevaluar Helm 4 antes de la Unidad 06 |
| Terraform | 1.15.x | Rama estable; evitar prereleases |

Las versiones exactas observadas se registraran despues de ejecutar validaciones reales en el entorno.

## Flujo previsto

1. Validar Windows 11 y virtualizacion desde PowerShell.
2. Validar o preparar WSL2.
3. Validar o instalar Ubuntu LTS sobre WSL2.
4. Preparar dependencias base dentro de Ubuntu.
5. Instalar MicroK8s dentro de Ubuntu.
6. Habilitar el addon minimo `dns`.
7. Configurar kubeconfig para usar `kubectl`.
8. Validar el cluster con `kubectl`.
9. Instalar y validar Helm y Terraform sin crear charts ni modulos.
10. Documentar diagnostico, recuperacion y validaciones pendientes.

## Validaciones principales previstas

PowerShell:

```powershell
wsl --status
wsl --list --verbose
```

Ubuntu sobre WSL2:

```bash
cat /etc/os-release
kubectl version --client
kubectl get nodes
microk8s status --wait-ready
microk8s version
kubectl version
helm version
terraform version
```

Las validaciones funcionales del host, WSL2, Ubuntu, MicroK8s, Helm y Terraform se consideraran pendientes hasta que se ejecuten en el entorno real.

## Fuera de alcance

Esta unidad no generara:

- contenido de la Unidad 01;
- aplicacion evolutiva;
- namespaces funcionales del curso;
- workloads;
- charts Helm;
- modulos Terraform;
- componentes de CI/CD, GitOps, observabilidad, seguridad avanzada o cloud.

## Siguiente incremento

El siguiente incremento recomendado es ejecutar los scripts de validacion inicial en el entorno real y registrar los resultados observados.

Scripts disponibles:

```text
platform/environment/windows/check-prerequisites.ps1
platform/environment/linux/check-prerequisites.sh
platform/environment/validation/validate-environment.sh
```
