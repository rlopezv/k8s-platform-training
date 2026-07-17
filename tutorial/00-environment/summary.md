# Summary - Unidad 00

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 00 - Preparacion del entorno |
| Identificador | `00-environment` |
| Estado | Completada con limitaciones documentadas |
| Ultima actualizacion | 2026-07-18 |

## Resumen ejecutivo

La Unidad 00 queda cerrada como preparacion del entorno base. Dispone de bloques documentados y scripts idempotentes para validar Windows, WSL2, Ubuntu 24.04 LTS, MicroK8s, `kubectl`, Helm y Terraform.

Ubuntu 24.04.4 LTS sobre WSL2 fue validada como base Linux inicial, con `snap`, Git, herramientas basicas, DNS hacia `snapcraft.io` y espacio libre correctos.

MicroK8s y `kubectl` ya fueron instalados por el usuario desde el canal `1.35/stable` y responden en el entorno real. La validacion funcional mostro el nodo local en `Ready`, el addon `dns` habilitado y `kubectl` operativo. La validacion integrada termino sin fallos bloqueantes.

Helm y Terraform ya fueron instalados y validados por el usuario como herramientas CLI. No se han creado charts, releases, modulos, backends, workloads, namespaces funcionales ni recursos de Unidad 01.

## Cambios introducidos

| Artefacto | Ruta | Estado |
|---|---|---|
| Guia WSL/Ubuntu del tutorial | `tutorial/00-environment/README.md` | Actualizada |
| Referencia tecnica de plataforma | `platform/environment/README.md` | Actualizada |
| Validacion Windows inicial | `platform/environment/windows/check-prerequisites.ps1` | Creado |
| Preparacion Ubuntu WSL | `platform/environment/windows/prepare-ubuntu-wsl.ps1` | Creado |
| Validacion Linux inicial | `platform/environment/linux/check-prerequisites.sh` | Creado |
| Validacion integrada Linux | `platform/environment/validation/validate-environment.sh` | Creado |
| Instalacion MicroK8s/kubectl | `platform/environment/microk8s/install.sh` | Creado |
| Configuracion MicroK8s/kubectl | `platform/environment/microk8s/configure.sh` | Creado |
| Validacion MicroK8s/kubectl | `platform/environment/microk8s/validate.sh` | Creado |
| Reset MicroK8s protegido | `platform/environment/microk8s/reset.sh` | Creado |
| Instalacion Helm | `platform/environment/tools/install-helm.sh` | Creado |
| Instalacion Terraform | `platform/environment/tools/install-terraform.sh` | Creado |
| Validacion Helm/Terraform | `platform/environment/tools/validate-tools.sh` | Creado |
| Notas del instructor | `tutorial/00-environment/instructor-notes.md` | Creado |
| Playbook de la unidad | `playbooks/units/00-environment.md` | Actualizado con decision `kubectl` |
| Estado del proyecto | `project/project-state.md` | Actualizado con cierre de Unidad 00 y limitaciones documentadas |

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
| `platform/environment/validation/validate-environment.sh` inicial desde Codex | 0 fallos, 6 avisos antes de instalar componentes |
| `systemd` | Disponible; validacion final fuera del sandbox con estado `running` |
| DNS inicial desde sandbox | `snapcraft.io` no resolvio en esa ejecucion; validaciones finales resolvieron correctamente |
| Espacio libre HOME | 952 GB |
| `bash -n platform/environment/microk8s/install.sh` | Correcto |
| `bash -n platform/environment/microk8s/configure.sh` | Correcto |
| `bash -n platform/environment/microk8s/validate.sh` | Correcto |
| `bash -n platform/environment/microk8s/reset.sh` | Correcto |
| `shellcheck` | No disponible en este entorno |
| `bash platform/environment/validation/validate-environment.sh` previo | Fallaba en bloque MicroK8s antes de instalar `microk8s` y `kubectl` |
| `bash platform/environment/microk8s/reset.sh` | Dry run correcto; no ejecuta reset sin `--confirm-reset` |
| `platform/environment/microk8s/install.sh` | Ejecutado por el usuario; MicroK8s `v1.35.6` y `kubectl` `1.35.6` instalados desde `1.35/stable` |
| `platform/environment/microk8s/validate.sh` | Ejecutado por el usuario; 0 fallos, 0 avisos |
| `kubectl get nodes` | Nodo `gmktecg2` en estado `Ready`, Kubernetes `v1.35.6` |
| `kubectl get namespaces` | `default`, `kube-node-lease`, `kube-public` y `kube-system` activos |
| Addons MicroK8s observados | `dns`, `ha-cluster`, `helm` y `helm3` aparecen habilitados por MicroK8s |
| `platform/environment/validation/validate-environment.sh` | Ejecutado por el usuario; completado sin fallos bloqueantes |
| Ubuntu/WSL integrado previo a herramientas | 0 fallos, 2 avisos esperados por Helm y Terraform pendientes |
| `systemd` | Disponible y en ejecucion |
| `snap` | Disponible (`2.76`) |
| DNS | `snapcraft.io` resuelve correctamente |
| `bash -n platform/environment/tools/install-helm.sh` | Correcto |
| `bash -n platform/environment/tools/install-terraform.sh` | Correcto |
| `bash -n platform/environment/tools/validate-tools.sh` | Correcto |
| `bash platform/environment/tools/validate-tools.sh` | Falla con Helm y Terraform ausentes; esperado antes de ejecutar instaladores |
| `shellcheck` | No disponible en este entorno |
| `platform/environment/tools/install-helm.sh` | Ejecutado por el usuario; Helm `v3.21.0+ge0878d4` instalado con checksum correcto |
| `platform/environment/tools/install-terraform.sh` | Ejecutado por el usuario; Terraform `1.15.7` instalado con checksum correcto; falso fallo previo de parser JSON corregido |
| `platform/environment/tools/validate-tools.sh` | Ejecutado por el usuario; 0 fallos, 0 avisos |
| `platform/environment/tools/validate-tools.sh` post-correccion | Ejecutado en esta sesion; 0 fallos, 0 avisos |
| `platform/environment/validation/validate-environment.sh` final | Ejecutado por el usuario; completado sin fallos bloqueantes |
| Helm | `v3.21.0+ge0878d4` |
| Terraform | `1.15.7` |
| Revalidacion integrada desde Codex | Ubuntu, DNS, `kubectl get nodes`, Helm y Terraform correctos; `microk8s status/version` bloqueados por sesion no interactiva sin grupo `microk8s` activo |
| Revision de ausencia de charts Helm | Sin `Chart.yaml` en el repositorio |
| Revision de ausencia de Terraform | Sin archivos `.tf` ni `.tfvars` en el repositorio |
| Revision de laboratorios funcionales | `labs/` solo contiene `.gitkeep` |

DNS hacia `snapcraft.io` resolvio correctamente durante la instalacion y durante la validacion integrada.

Validaciones pendientes:

```text
wsl --status
wsl --list --verbose
platform/environment/windows/check-prerequisites.ps1
```

## Limitaciones conocidas

- Los scripts Linux iniciales son de diagnostico y no instalan componentes.
- El script Windows `prepare-ubuntu-wsl.ps1` puede ejecutar la instalacion de Ubuntu solo con `-Install`.
- `platform/environment/microk8s/install.sh` instala MicroK8s y `kubectl` solo cuando el usuario lo ejecuta.
- `platform/environment/microk8s/reset.sh` no ejecuta reset sin `--confirm-reset`.
- `platform/environment/tools/install-helm.sh` instala Helm `v3.21.0` solo cuando el usuario lo ejecuta.
- `platform/environment/tools/install-terraform.sh` instala Terraform `1.15.7` solo cuando el usuario lo ejecuta.
- Ubuntu 24.04.4 LTS esta instalada y validada como base WSL2 de la Unidad 00.
- MicroK8s y `kubectl` estan instalados y validados.
- Helm y Terraform estan instalados y validados.
- No se han validado versiones reales de Windows desde este entorno Linux.
- La plataforma Kubernetes local responde y queda lista para la siguiente unidad formativa cuando el estado del proyecto lo permita.
- Los addons `helm` y `helm3` aparecen habilitados por MicroK8s como addons core observados; no sustituyen la instalacion y validacion de Helm como herramienta CLI del curso.
- Windows 11, virtualizacion y salida completa de `wsl --status` / `wsl --list --verbose` deben validarse por equipo cuando se replique el laboratorio.

## Siguiente incremento recomendado

Generar el playbook de la Unidad 01 antes de crear contenido formativo nuevo. La Unidad 01 no debe iniciarse desde historial de conversacion: debe gobernarse con un playbook versionado y usando este summary como fuente de continuidad.
