# Summary - Unidad 00

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 00 - Preparacion del entorno |
| Identificador | `00-environment` |
| Estado | En progreso |
| Ultima actualizacion | 2026-07-18 |

## Resumen ejecutivo

La Unidad 00 se ha iniciado y ya dispone de un bloque documentado para validar Windows, WSL2 y Ubuntu 24.04 LTS. Ubuntu 24.04.4 LTS sobre WSL2 fue validada como base Linux inicial, con `snap`, Git, herramientas basicas y espacio libre correctos.

Todavia no existe plataforma Kubernetes local validada. MicroK8s, `kubectl`, Helm y Terraform siguen pendientes y deben abordarse en bloques posteriores de la misma unidad.

## Cambios introducidos

| Artefacto | Ruta | Estado |
|---|---|---|
| Guia WSL/Ubuntu del tutorial | `tutorial/00-environment/README.md` | Actualizada |
| Referencia tecnica de plataforma | `platform/environment/README.md` | Actualizada |
| Validacion Windows inicial | `platform/environment/windows/check-prerequisites.ps1` | Creado |
| Preparacion Ubuntu WSL | `platform/environment/windows/prepare-ubuntu-wsl.ps1` | Creado |
| Validacion Linux inicial | `platform/environment/linux/check-prerequisites.sh` | Creado |
| Validacion integrada Linux | `platform/environment/validation/validate-environment.sh` | Creado |
| Estructura reservada MicroK8s | `platform/environment/microk8s/` | Preparada sin scripts vacios |
| Estructura reservada herramientas | `platform/environment/tools/` | Preparada sin scripts vacios |
| Playbook de la unidad | `playbooks/units/00-environment.md` | Actualizado con decision `kubectl` |
| Estado del proyecto | `project/project-state.md` | Actualizado con el bloque WSL/Ubuntu y el siguiente incremento permitido |

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

Resultados ejecutados en la sesion actual desde Ubuntu WSL:

| Validacion | Resultado observado |
|---|---|
| `bash -n platform/environment/linux/check-prerequisites.sh` | Correcto |
| `bash -n platform/environment/validation/validate-environment.sh` | Correcto |
| `platform/environment/validation/validate-environment.sh` | 0 fallos, 6 avisos |
| `systemd` | `systemctl` disponible; estado `unknown` en esta ejecucion |
| DNS | `snapcraft.io` no resolvio en esta ejecucion |
| Espacio libre HOME | 952 GB |

La diferencia de DNS debe revisarse antes de instalar MicroK8s con `snap`.

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

- Los scripts Linux creados son solo de diagnostico y no instalan componentes.
- El script Windows `prepare-ubuntu-wsl.ps1` puede ejecutar la instalacion de Ubuntu solo con `-Install`.
- No existe `tutorial/00-environment/instructor-notes.md`.
- Ubuntu 24.04.4 LTS esta instalada y validada como base WSL2 de la Unidad 00.
- `kubectl`, MicroK8s, Helm y Terraform aun no estan instalados o configurados.
- No se han validado versiones reales de Windows, MicroK8s, Kubernetes, `kubectl`, Helm ni Terraform.
- No se ha instalado ni configurado la plataforma Kubernetes local desde este repositorio.
- La validacion actual no resolvio `snapcraft.io`; revisar DNS/proxy/VPN antes de instalar MicroK8s.

## Siguiente incremento recomendado

Preparar el bloque MicroK8s y `kubectl` de la Unidad 00: scripts idempotentes, documentacion de instalacion, habilitacion del addon minimo `dns`, generacion/configuracion de kubeconfig y validaciones con `kubectl`.
