# Session Handoff

## 1. Proyecto

Repositorio para generar un itinerario incremental de formacion en Kubernetes Platform Engineering.

El repositorio es la fuente unica de verdad: las sesiones deben guiarse por los documentos versionados, actualizar el estado consolidado y evitar depender del historial de conversacion.

La Unidad 00 prepara el entorno local base sobre Windows 11, WSL2, Ubuntu LTS y, mas adelante, MicroK8s.

## 2. Objetivos

Objetivo inmediato de la siguiente conversacion:

```text
Continuar la Unidad 00 desde VS Code conectado directamente a Ubuntu WSL.
Completar la verificacion WSL/Ubuntu, documentar la guia de instalacion y troubleshooting inicial, y dejar preparado el siguiente bloque para MicroK8s y kubectl.
```

No iniciar todavia la Unidad 01.

## 3. Arquitectura

Arquitectura objetivo de la Unidad 00:

```text
Windows 11 -> WSL2 -> Ubuntu 24.04 LTS -> MicroK8s -> kubectl
```

Decisiones activas relevantes:

- `kubectl` sera el cliente operativo principal del curso.
- `microk8s kubectl` queda solo como fallback de diagnostico.
- MicroK8s se instalara dentro de Ubuntu sobre WSL2.
- El addon inicial de MicroK8s sera `dns`.
- Versiones objetivo: Ubuntu 24.04 LTS, MicroK8s `1.35/stable`, Kubernetes 1.35.x, kubectl 1.35.x, Helm 3.21.x y Terraform 1.15.x.

## 4. Estado Actual

Fase actual:

```text
Unidad 00 - Preparacion del entorno
```

Estado consolidado:

- Bootstrap y Framework V1 completados.
- Unidad 00 en progreso.
- Ubuntu WSL ya instalada y validada como base Linux.
- No hay MicroK8s instalado.
- No hay `kubectl`, Helm ni Terraform instalados o configurados.
- No existe todavia `tutorial/00-environment/instructor-notes.md`.
- No se ha generado contenido de Unidad 01.

## 5. Estado Del Laboratorio

Resultados ya proporcionados por el usuario:

- `Ubuntu-24.04` instalada correctamente mediante `platform/environment/windows/prepare-ubuntu-wsl.ps1 -Install`.
- Primer arranque correcto.
- Usuario Linux inicial: `ramon`.
- `/etc/os-release` indica Ubuntu 24.04.4 LTS (`noble`).
- `platform/environment/linux/check-prerequisites.sh` finaliza con 0 fallos y 4 avisos esperados.
- `platform/environment/validation/validate-environment.sh` finaliza sin fallos bloqueantes.
- `systemd` esta disponible y en ejecucion.
- `snap` esta disponible: `2.73+ubuntu24.04`.
- Git, curl, tar y gzip estan disponibles.
- DNS resuelve `snapcraft.io`.
- `$HOME` tiene 954 GB libres.

Avisos esperados pendientes:

- `kubectl` no instalado.
- MicroK8s no instalado.
- Helm no instalado.
- Terraform no instalado.

## 6. Flujo De Generacion

Antes de modificar la Unidad 00, leer:

```text
playbooks/master.md
project/architecture.md
project/project-state.md
project/roadmap.md
playbooks/units/00-environment.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
tutorial/00-environment/summary.md
```

Cada incremento debe:

- mantener `tutorial/00-environment/summary.md` actualizado;
- mantener `project/project-state.md` actualizado;
- diferenciar trabajo documentado de trabajo ejecutado;
- no afirmar validaciones que no haya ejecutado el usuario;
- cerrar con commit cuando el usuario lo indique.

El usuario quiere ejecutar los comandos del entorno personalmente. El asistente debe preparar scripts, documentacion, criterios e interpretar salidas proporcionadas por el usuario.

## 7. Restricciones

- No iniciar Unidad 01.
- No crear aplicacion evolutiva.
- No desplegar workloads funcionales.
- No crear charts Helm.
- No crear modulos Terraform.
- No instalar Tekton, Argo CD, observabilidad, seguridad avanzada ni cloud.
- No ejecutar instalaciones o comandos modificadores del entorno por cuenta del asistente.
- No tratar `SESSION_HANDOFF.md` como fuente de verdad permanente; es un artefacto derivado.

## 8. Objetivo De La Nueva Conversacion

Abrir el repositorio desde VS Code conectado a `Ubuntu-24.04` mediante WSL y validar que el flujo de trabajo desde Linux es viable.

Completar despues la guia de instalacion y troubleshooting inicial en:

```text
tutorial/00-environment/README.md
```

La guia debe cubrir al menos:

1. Validacion Windows/WSL2.
2. Instalacion de Ubuntu 24.04 LTS.
3. Validacion Ubuntu desde WSL.
4. Interpretacion de avisos esperados.
5. Troubleshooting inicial.
6. Continuacion del trabajo desde VS Code en WSL.

## 9. Primeras Acciones

1. Abrir VS Code conectado a la distro `Ubuntu-24.04`.
2. Confirmar que el workspace apunta al repositorio desde WSL.
3. Revisar `git status`.
4. Leer `tutorial/00-environment/summary.md` y `project/project-state.md`.
5. Completar `tutorial/00-environment/README.md` como guia real de WSL/Ubuntu.
6. Ajustar `platform/environment/README.md` si hace falta separar guia de alumno y referencia tecnica de scripts.
7. Actualizar `summary.md` y `project-state.md`.
8. Commit del incremento.
