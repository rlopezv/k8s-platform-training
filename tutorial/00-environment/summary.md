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
| Diseno operativo de plataforma | `platform/environment/README.md` | Creado |
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

No se han ejecutado validaciones funcionales del entorno.

Validaciones pendientes:

```text
wsl --status
wsl --list --verbose
cat /etc/os-release
microk8s status --wait-ready
microk8s version
kubectl version --client
kubectl get nodes
helm version
terraform version
```

## Limitaciones conocidas

- No existen scripts ejecutables todavia.
- No existe `tutorial/00-environment/instructor-notes.md`.
- No se han validado versiones reales de Windows, WSL2, Ubuntu, MicroK8s, Kubernetes, `kubectl`, Helm ni Terraform.
- No se ha instalado ni configurado la plataforma local desde este repositorio.

## Siguiente incremento recomendado

Generar los scripts iniciales de validacion y completar la documentacion operativa de Unidad 00 sin crear contenido de la Unidad 01.
