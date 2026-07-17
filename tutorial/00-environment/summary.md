# Summary - Unidad 00

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 00 - Preparacion del entorno |
| Identificador | `00-environment` |
| Estado | En progreso |
| Ultima actualizacion | 2026-07-17 |

## Resumen ejecutivo

La Unidad 00 se ha iniciado con un incremento de diseno. Todavia no existe plataforma local validada, no se han creado scripts ejecutables y no se ha instalado MicroK8s desde artefactos del repositorio.

La decision principal registrada es usar `kubectl` como cliente operativo principal del curso. MicroK8s se mantiene como distribucion local dentro de Ubuntu sobre WSL2, y sus comandos propios se limitan a instalacion, configuracion, addons, diagnostico y recuperacion.

## Cambios introducidos

| Artefacto | Ruta | Estado |
|---|---|---|
| Diseno inicial del tutorial | `tutorial/00-environment/README.md` | Creado |
| Diseno operativo de plataforma | `platform/environment/README.md` | Actualizado |
| Validacion Windows inicial | `platform/environment/windows/check-prerequisites.ps1` | Creado |
| Preparacion Ubuntu WSL | `platform/environment/windows/prepare-ubuntu-wsl.ps1` | Creado |
| Validacion Linux inicial | `platform/environment/linux/check-prerequisites.sh` | Creado |
| Validacion integrada Linux | `platform/environment/validation/validate-environment.sh` | Creado |
| Playbook de la unidad | `playbooks/units/00-environment.md` | Actualizado con decision `kubectl` |
| Estado del proyecto | `project/project-state.md` | Actualizado para iniciar Unidad 00 |

## Decisiones registradas

| Decision | Estado | Impacto |
|---|---|---|
| `kubectl` como cliente principal | Aprobada | Las operaciones Kubernetes del curso usaran cliente estandar |
| `microk8s kubectl` como fallback | Aprobada | Solo diagnostico o uso temporal antes de configurar `kubectl` |
| MicroK8s dentro de Ubuntu sobre WSL2 | Aprobada | Los scripts MicroK8s no instalan WSL ni Ubuntu |
| Addon inicial `dns` | Aprobada para el primer diseno | Otros addons quedan diferidos |
| Politica inicial de versiones | Aprobada | Ubuntu 24.04 LTS, MicroK8s 1.35/stable, kubectl 1.35.x, Helm 3.21.x y Terraform 1.15.x |

## Validaciones

La Unidad 00 define validaciones iniciales no destructivas para comprobar que una persona puede preparar el entorno objetivo.

Validacion Windows:

```text
platform/environment/windows/check-prerequisites.ps1
```

Criterios que debe comprobar:

| Comprobacion | Resultado esperado |
|---|---|
| `wsl.exe` | Disponible |
| Version predeterminada de WSL | 2 |
| Distribucion Ubuntu objetivo | Ubuntu 24.04 LTS sobre WSL2 |
| Features WSL/VMP | Habilitadas o pendientes de habilitar antes de instalar Ubuntu |
| Espacio libre | Suficiente para Ubuntu, MicroK8s y las herramientas de la unidad |

Validaciones Linux:

```text
bash -n platform/environment/linux/check-prerequisites.sh
bash -n platform/environment/validation/validate-environment.sh
```

Estas validaciones deben ejecutarse desde la distribucion Ubuntu 24.04 LTS objetivo, no desde otras distribuciones WSL que pueda tener el equipo.

Resultados proporcionados por el usuario:

| Validacion | Resultado observado |
|---|---|
| `platform/environment/windows/prepare-ubuntu-wsl.ps1 -Install` | Instala correctamente `Ubuntu-24.04` |
| Distribucion instalada | `Ubuntu-24.04` |
| Primer arranque | Correcto |
| Usuario Linux inicial | `ramon` |
| `cat /etc/os-release` | Ubuntu 24.04.4 LTS (`noble`) |
| `platform/environment/linux/check-prerequisites.sh` | 0 fallos, 4 avisos esperados |
| `platform/environment/validation/validate-environment.sh` | Validacion integrada completada sin fallos bloqueantes |
| systemd | Disponible y en ejecucion |
| snap | Disponible (`2.73+ubuntu24.04`) |
| Espacio libre HOME | 954 GB |
| DNS | `snapcraft.io` resuelve correctamente |

Validaciones pendientes:

```text
wsl --status
wsl --list --verbose
microk8s status --wait-ready
microk8s version
kubectl version --client
kubectl get nodes
helm version
terraform version
```

## Limitaciones conocidas

- Los scripts creados son solo de diagnostico y no instalan componentes.
- No existe `tutorial/00-environment/instructor-notes.md`.
- Ubuntu 24.04.4 LTS esta instalada y validada como base WSL2 de la Unidad 00.
- `kubectl`, MicroK8s, Helm y Terraform aun no estan instalados o configurados.
- No se han validado versiones reales de Windows, MicroK8s, Kubernetes, `kubectl`, Helm ni Terraform.
- No se ha instalado ni configurado la plataforma local desde este repositorio.

## Siguiente incremento recomendado

Preparar la instalacion de MicroK8s y `kubectl` sobre Ubuntu 24.04 LTS, manteniendo `kubectl` como cliente operativo principal.
