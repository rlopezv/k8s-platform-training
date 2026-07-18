# Instructor Notes - Unidad 00

## Intencion pedagogica

Esta unidad debe convertir un equipo Windows con WSL2 en una estacion de trabajo Kubernetes local verificable.

El foco no es memorizar comandos de MicroK8s, sino aprender a separar:

- precondiciones del host;
- estado de Ubuntu sobre WSL2;
- instalacion de la distribucion Kubernetes;
- acceso estandar mediante `kubectl`;
- diagnostico cuando una capa inferior falla.

Tras el hardening pedagogico inicial, presentar la unidad como una practica de reduccion de ambiguedad: cada validacion responde a la pregunta "que capa puedo dar por fiable antes de seguir?".

## Puntos de enfasis

- `kubectl` es el cliente operativo principal del curso.
- `microk8s kubectl` solo debe usarse como fallback para diagnostico.
- MicroK8s se instala dentro de Ubuntu WSL2, no desde PowerShell.
- El addon inicial permitido es solo `dns`.
- Helm y Terraform se instalan como CLI, sin charts ni modulos en esta fase.
- La aplicacion evolutiva no se define ni se despliega durante la Unidad 00.
- Windows, WSL2, Ubuntu y MicroK8s son capas distintas; no diagnosticar todas con el mismo comando.
- Una validacion documentada no equivale a una validacion ejecutada.
- Los conceptos transferibles son `kubectl`, API Kubernetes, validacion y registro de estado; la instalacion mediante `snap` es especifica del entorno local.

## Demostracion recomendada

1. Ejecutar la validacion Ubuntu/WSL y revisar avisos.
2. Mostrar que DNS hacia `snapcraft.io` es precondicion para instalar desde `snap`.
3. Ejecutar o revisar `platform/environment/microk8s/install.sh`.
4. Ejecutar o revisar `platform/environment/microk8s/configure.sh`.
5. Explicar por que puede requerirse cerrar y reabrir Ubuntu tras modificar el grupo `microk8s`.
6. Validar con `kubectl get nodes`, no con `microk8s kubectl`, salvo diagnostico.
7. Mostrar que `reset.sh` no ejecuta nada destructivo sin `--confirm-reset`.
8. Ejecutar o revisar `platform/environment/tools/install-helm.sh`.
9. Ejecutar o revisar `platform/environment/tools/install-terraform.sh`.
10. Validar que instalar las herramientas no crea charts, releases, modulos, backends ni recursos.

## Errores frecuentes

| Error | Sintoma | Accion recomendada |
|---|---|---|
| WSL1 en lugar de WSL2 | MicroK8s no arranca correctamente | Validar con `wsl --list --verbose` y convertir la distribucion |
| DNS o proxy bloqueado | `snapcraft.io` no resuelve o `snap install` falla | Revisar VPN, DNS corporativo o proxy sin versionar credenciales |
| `systemd` no operativo | Servicios o snap fallan | Validar `systemctl is-system-running` y configuracion WSL |
| Usuario fuera del grupo `microk8s` | Permisos al ejecutar `microk8s` | Reabrir sesion Ubuntu tras `usermod -a -G microk8s` |
| kubeconfig ausente o incorrecto | `kubectl get nodes` falla | Regenerar con `configure.sh` y revisar `~/.kube/config` |
| DNS addon no habilitado | Resolucion interna de Kubernetes falla | Ejecutar `configure.sh` y validar addon `dns` |
| Helm no es 3.21.x | `validate-tools.sh` falla | Reinstalar con `install-helm.sh` o registrar desviacion |
| Terraform no es 1.15.x | `validate-tools.sh` falla | Reinstalar con `install-terraform.sh` o registrar desviacion |
| Falta `unzip` | Instalacion Terraform no puede extraer zip | El script intenta instalar `unzip` mediante `apt-get` |

## Criterios para aceptar el laboratorio

Aceptar el entorno solo cuando el alumno pueda aportar evidencias de:

- Ubuntu LTS ejecutandose sobre WSL2;
- `snap` disponible;
- MicroK8s instalado desde el canal objetivo o una version compatible registrada;
- addon `dns` habilitado;
- `kubectl version --client` correcto;
- `kubectl get nodes` con el nodo en `Ready`;
- `helm version` con version 3.21.x;
- `terraform version` con version 1.15.x;
- validacion integrada sin fallos bloqueantes.

El cierre de la unidad puede aceptarse con limitaciones si Windows 11, virtualizacion o la salida completa de `wsl --status` / `wsl --list --verbose` no se han capturado desde PowerShell, siempre que la limitacion quede registrada y el entorno Ubuntu/MicroK8s/herramientas este validado.

Antes de permitir la Unidad 01, confirmar que no existen workloads, namespaces funcionales, charts Helm, releases, modulos Terraform, backends ni recursos creados por la Unidad 00.

Si el entorno no puede instalar MicroK8s por DNS, proxy o VPN, registrar el bloqueo. No sustituir MicroK8s por Minikube, kind ni Docker Desktop Kubernetes.

## Preguntas de comprobacion

- Que problema pedagogico causa empezar Kubernetes sin validar antes el entorno?
- Que contrato aporta cada capa: Windows, WSL2, Ubuntu, MicroK8s y `kubectl`?
- Que capa esta fallando si `snapcraft.io` no resuelve?
- Por que `kubectl` es preferible a `microk8s kubectl` para el flujo principal?
- Que implica anadir el usuario al grupo `microk8s`?
- Que addon se habilita en esta unidad y cuales quedan diferidos?
- Que diferencia hay entre resetear MicroK8s y eliminar la distribucion WSL?
- Por que instalar Helm no implica crear charts?
- Por que instalar Terraform no implica crear modulos ni backends?
- Que partes de esta unidad son especificas de MicroK8s y cuales seguiran aplicando en AKS o EKS?

## Riesgos tecnicos

- Cambios de red corporativa pueden hacer que una validacion DNS pase en una sesion y falle en otra.
- El estado `degraded` o `unknown` de `systemd` en WSL puede requerir diagnostico adicional antes de instalar.
- `snap install` puede necesitar privilegios y conectividad estable.
- Las descargas de Helm y Terraform dependen de conectividad HTTPS externa y verificacion de checksum.
- Un reset de MicroK8s elimina recursos locales del cluster, aunque esta unidad todavia no debe contener workloads funcionales.
- Versiones ya instaladas manualmente deben registrarse como observadas, no asumirse como validadas por el repositorio.
