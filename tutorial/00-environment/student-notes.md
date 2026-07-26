# Notas del alumno - Unidad 00

## Propósito de estas notas

Estas notas explican los conceptos que hay detrás de la preparación del entorno. El README operativo de `platform/environment/` indica qué comandos ejecutar; este documento explica por qué importan, qué significa cada capa y cómo diagnosticar fallos dentro del laboratorio.

La Unidad 00 no busca que aprendas Kubernetes en profundidad. Busca que sepas reconocer si tu estación de trabajo está preparada para aprender Kubernetes sin mezclar problemas del sistema operativo, de WSL, de Linux, de red o de permisos con problemas del clúster.

Para el mapa profesional de contenedores, imágenes y registros, lee `tutorial/00-environment/student-reference.md`. Esa referencia cierra `GAP-001` y prepara la lectura de la imagen que usará `platform-api` en la Unidad 01. El laboratorio de acompañamiento `platform/environment/container-images/README.md` es de solo lectura: no construye imágenes ni modifica el clúster.

## Qué se va a cubrir

La unidad cubre la preparación de una pila local:

```text
Windows
  -> WSL2
    -> Ubuntu
      -> systemd, snap y herramientas base
        -> MicroK8s
          -> API Kubernetes
            -> kubectl
```

También instala Helm y Terraform como herramientas de línea de comandos para unidades posteriores. En esta unidad no se crean charts, releases, módulos, backends, workloads ni namespaces funcionales.

## Qué representa cada componente

### Windows

Windows es el sistema operativo anfitrión. No ejecuta directamente los workloads del curso, pero proporciona virtualización, almacenamiento, red y acceso a WSL2.

Lo importante no es la etiqueta "Windows 11" por sí sola, sino comprobar que puede ejecutar WSL2, iniciar una distribución Linux, acceder al repositorio desde un filesystem estable y no bloquear la red necesaria para descargar herramientas.

### WSL2

WSL2 permite ejecutar Linux sobre Windows con un kernel Linux real en una máquina virtual ligera. Para este curso es importante porque MicroK8s espera un entorno Linux con servicios, red, procesos y permisos.

WSL2 no es exactamente un servidor Linux tradicional. Puede verse afectado por integración con Windows, VPN, proxy, DNS o políticas corporativas. Por eso se valida antes de instalar Kubernetes.

### Ubuntu

Ubuntu es el entorno Linux objetivo. Es donde se ejecutan los scripts Linux, donde se instala MicroK8s y donde `kubectl` se usa como cliente principal.

En esta unidad Ubuntu debe aportar Bash, Git, `curl`, `tar`, `gzip`, `systemd`, `snap`, DNS funcional y espacio suficiente.

### `systemd`

`systemd` gestiona servicios Linux. MicroK8s lo necesita porque varios componentes deben arrancar, detenerse y mantenerse como servicios.

Si `systemd` no está disponible, el problema pertenece a la capa Linux/WSL. No se corrige escribiendo manifiestos Kubernetes.

### `snap`

`snap` es el sistema de paquetes usado por MicroK8s en este laboratorio. Que `snap` exista no basta: también debe poder resolver DNS y descargar paquetes desde `snapcraft.io`.

### MicroK8s

MicroK8s es una distribución local de Kubernetes. Empaqueta componentes de Kubernetes con decisiones propias para crear un clúster funcional en una estación de trabajo.

Transferible a otros entornos:

- trabajar contra una API Kubernetes;
- usar `kubectl`;
- validar nodos y namespaces;
- razonar sobre estado deseado y observado.

Específico de MicroK8s:

- instalación por `snap`;
- comando `microk8s`;
- addons como `dns`;
- grupo de usuarios `microk8s`;
- generación local de kubeconfig.

### `kubectl`

`kubectl` es el cliente principal del curso. Su trabajo es hablar con la API Kubernetes usando un contexto y una configuración.

Cuando ejecutas:

```bash
kubectl get nodes
```

compruebas varias cosas a la vez: el binario existe, hay kubeconfig, el contexto apunta a un clúster, la API responde y el clúster puede informar sobre sus nodos.

No es lo mismo que `microk8s status`: ese comando habla del estado de la distribución local y sus addons.

### Helm y Terraform

Helm y Terraform se instalan en la Unidad 00 como herramientas futuras.

Helm servirá más adelante para empaquetar y parametrizar recursos Kubernetes. Terraform servirá para declarar y automatizar infraestructura o releases. En Unidad 00 solo se instalan y validan como CLI.

Una CLI instalada no significa que el curso ya esté usando esa herramienta. El curso empieza a usarla cuando existen artefactos versionados, comandos documentados y estado registrado.

## Qué se va a construir

La unidad deja:

- scripts Windows para comprobar precondiciones y preparar Ubuntu WSL;
- scripts Linux para validar Ubuntu;
- scripts de MicroK8s para instalar, configurar, validar y resetear con confirmación;
- scripts de herramientas para instalar y validar Helm y Terraform;
- una validación integrada;
- documentación operativa en `platform/environment/README.md`;
- una referencia conceptual de imágenes en `tutorial/00-environment/student-reference.md`.

No deja aplicación desplegada, workloads, manifiestos Kubernetes de aplicación, charts, módulos Terraform ni recursos cloud.

## Cómo se relacionan las piezas

Cada capa depende de la anterior. Si Ubuntu no resuelve DNS, MicroK8s puede fallar al instalarse. Si el usuario no pertenece al grupo `microk8s`, el clúster puede estar sano pero los comandos pueden fallar por permisos. Si el kubeconfig apunta a otro contexto, `kubectl` puede consultar un clúster distinto del esperado.

Por eso la unidad insiste en validar por capas antes de aplicar recuperaciones.

```text
fallo observado
  -> identificar capa
    -> comprobar contrato de esa capa
      -> corregir la causa
        -> repetir validación
```

## Qué ocurre al aplicar los scripts

Los scripts Windows revisan WSL y preparan la distribución objetivo. El script de preparación de Ubuntu solo instala cuando se usa explícitamente `-Install`.

Los scripts Linux iniciales son de diagnóstico: revisan Ubuntu, dependencias, herramientas y red. No instalan MicroK8s por sí solos.

Los scripts de MicroK8s instalan la distribución local, configuran permisos, habilitan `dns`, generan kubeconfig y validan el clúster. El reset está protegido y no se ejecuta sin confirmación explícita.

Los scripts de herramientas instalan Helm y Terraform como binarios locales y validan sus versiones. No crean recursos del curso.

## Cómo comprobar que funciona

Las comprobaciones principales son:

```powershell
wsl --status
wsl --list --verbose
```

```bash
cat /etc/os-release
bash platform/environment/linux/check-prerequisites.sh
bash platform/environment/microk8s/validate.sh
kubectl get nodes
bash platform/environment/tools/validate-tools.sh
bash platform/environment/validation/validate-environment.sh
```

El resultado final esperado es que Ubuntu esté validado, MicroK8s esté listo, `kubectl` hable con la API, Helm responda como CLI y Terraform responda como CLI.

No registres como validada una comprobación que no has ejecutado o cuyos resultados no ha aportado el usuario.

## Cómo diagnosticar fallos típicos

| Síntoma | Capa probable | Qué revisar |
|---|---|---|
| `wsl` no existe | Windows | Features de WSL y Virtual Machine Platform |
| Ubuntu aparece como versión 1 | WSL | `wsl --list --verbose` y conversión a WSL2 |
| `systemctl` no funciona | Ubuntu/WSL | Soporte de `systemd` en la distribución |
| `snapcraft.io` no resuelve | Red/DNS | DNS, proxy, VPN o política corporativa |
| `microk8s status` falla | MicroK8s | Servicios, instalación y logs de MicroK8s |
| `kubectl get nodes` no responde | Cliente/API | kubeconfig, contexto, permisos y API |
| Helm o Terraform no aparecen | Herramientas | Instalación, PATH y script de validación |

Evita empezar por un reset. Primero identifica si el fallo está en host, WSL, Ubuntu, MicroK8s, cliente, red o herramienta.

## Qué debe recordarse para la unidad siguiente

La Unidad 01 puede empezar cuando puedes demostrar que:

- Ubuntu WSL está operativo;
- MicroK8s está listo;
- `kubectl` habla con el clúster;
- Helm y Terraform responden como CLI;
- no existen workloads funcionales del curso creados por Unidad 00;
- las limitaciones pendientes están documentadas;
- sabes que Kubernetes ejecutará contenedores a partir de imágenes, aunque todavía no construyas una imagen propia.

## Fuentes de referencia

| Fuente | Qué leer | Para qué sirve en esta unidad |
|---|---|---|
| [Microsoft Learn - WSL](https://learn.microsoft.com/windows/wsl/) | Instalación, versiones de WSL y comandos básicos | Validar que Ubuntu corre sobre WSL2 |
| [Ubuntu on WSL](https://documentation.ubuntu.com/wsl/) | Particularidades de Ubuntu dentro de WSL | Resolver diferencias entre Linux de servidor y WSL |
| [MicroK8s documentation](https://microk8s.io/docs) | Instalación, estado y addons | Separar distribución local de API Kubernetes |
| [Kubernetes - kubectl](https://kubernetes.io/docs/reference/kubectl/) | Cliente, contextos y comandos de inspección | Entender qué valida `kubectl get nodes` |
| `tutorial/00-environment/student-reference.md` | Contenedores, imágenes, registros y pull policies | Preparar la lectura de Unidad 01 sin duplicar la referencia profesional |
