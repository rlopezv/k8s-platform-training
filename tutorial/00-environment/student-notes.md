# Student notes - Unidad 00

## Proposito de estas notas

Estas notas explican los conceptos que hay detras de la preparacion del entorno. El laboratorio te dice que comandos ejecutar; este documento explica por que importan y que significa cada capa.

La Unidad 00 no busca que aprendas Kubernetes en profundidad. Busca que sepas reconocer si tu estacion de trabajo esta preparada para aprender Kubernetes sin mezclar problemas del sistema operativo con problemas del cluster.

## Modelo mental

El entorno es una pila de capas. Cada capa ofrece un contrato a la siguiente:

```text
Windows
  -> WSL2
    -> Ubuntu
      -> systemd, snap y herramientas base
        -> MicroK8s
          -> API Kubernetes
            -> kubectl
```

Si una capa falla, las capas superiores pueden dar errores engañosos. Por ejemplo, un fallo de DNS en Ubuntu puede parecer un problema de MicroK8s porque impide descargar paquetes. Un problema de permisos de grupo puede parecer que el cluster no responde, aunque MicroK8s este funcionando.

## Windows como host

Windows es el sistema operativo anfitrion. En este curso no ejecuta directamente Kubernetes, pero proporciona virtualizacion, almacenamiento, red y acceso a WSL2.

Lo importante no es la marca "Windows 11" por si sola, sino estas capacidades:

- puede ejecutar WSL2;
- tiene virtualizacion disponible;
- puede iniciar una distribucion Linux;
- permite acceder al repositorio desde un filesystem estable;
- no bloquea red o DNS necesarios para descargar herramientas.

Error frecuente: pensar que si PowerShell puede ejecutar `wsl`, entonces todo esta listo. `wsl` solo demuestra que existe la interfaz. Aun falta saber que distribucion hay, si usa WSL2 y si Linux tiene los servicios necesarios.

## WSL2

WSL2 permite ejecutar Linux sobre Windows con un kernel Linux real en una maquina virtual ligera. Para este curso es importante porque MicroK8s espera un entorno Linux con capacidades de servicios, red, procesos y permisos.

WSL2 no es exactamente un servidor Linux tradicional. Comparte integracion con Windows, tiene particularidades de red y puede comportarse distinto segun version, VPN, proxy o politicas corporativas. Por eso la unidad valida WSL antes de instalar Kubernetes.

Debes poder responder:

- que distribucion Linux se esta usando;
- si esa distribucion corre en WSL version 2;
- desde que filesystem estas trabajando;
- si la terminal pertenece realmente a Ubuntu y no a PowerShell.

## Ubuntu

Ubuntu es el entorno Linux objetivo. Es donde se ejecutan los scripts Linux, donde se instala MicroK8s y donde `kubectl` se usa como cliente principal.

En esta unidad Ubuntu debe aportar:

- shell Bash;
- comandos basicos como Git, `curl`, `tar` y `gzip`;
- `systemd` para gestionar servicios;
- `snap` para instalar MicroK8s;
- DNS funcional;
- espacio suficiente en disco.

Ubuntu no es la aplicacion ni el cluster. Es la base donde se instala la plataforma local.

## systemd

`systemd` es el sistema de inicializacion y gestion de servicios usado por muchas distribuciones Linux. MicroK8s lo necesita porque despliega componentes que deben arrancar, detenerse y mantenerse como servicios.

Si `systemd` no esta disponible, MicroK8s puede instalarse mal o no arrancar correctamente. Un error aqui no se corrige escribiendo manifiestos Kubernetes; se corrige en la capa Linux/WSL.

## snap

`snap` es el sistema de paquetes usado por MicroK8s en este laboratorio. Permite instalar MicroK8s desde un canal versionado como `1.35/stable`.

Que `snap` exista no basta. Tambien debe poder resolver DNS y descargar paquetes. Si la red corporativa bloquea `snapcraft.io`, el problema esta antes de Kubernetes.

## MicroK8s

MicroK8s es una distribucion local de Kubernetes. Empaqueta componentes de Kubernetes y decisiones propias para que puedas tener un cluster funcional en una maquina de laboratorio.

MicroK8s no es "Kubernetes entero" como concepto. Es una forma concreta de ejecutar Kubernetes.

Transferible a otros entornos:

- trabajar contra una API Kubernetes;
- usar `kubectl`;
- validar nodos, namespaces y recursos;
- razonar sobre estado deseado y observado.

Especifico de MicroK8s:

- instalacion por `snap`;
- comando `microk8s`;
- addons como `dns` o `ingress`;
- detalles de permisos del grupo `microk8s`;
- empaquetado local de componentes.

## kubectl

`kubectl` es el cliente principal del curso. Su trabajo es hablar con la API Kubernetes usando un contexto y una configuracion.

Cuando ejecutas:

```bash
kubectl get nodes
```

estas comprobando varias cosas a la vez:

- `kubectl` existe;
- hay una configuracion de acceso;
- el contexto actual apunta a un cluster;
- la API responde;
- el cluster puede informar sobre sus nodos.

No es lo mismo que `microk8s status`. `microk8s status` habla de la distribucion local y sus addons. `kubectl get nodes` habla con la API Kubernetes que usaran los laboratorios.

## Helm y Terraform

Helm y Terraform se instalan en Unidad 00 como herramientas futuras.

Helm servira mas adelante para empaquetar y parametrizar recursos Kubernetes. Terraform servira mas adelante para declarar infraestructura. En Unidad 00 solo se instalan y validan como CLI.

Una CLI instalada no significa que el curso ya este usando esa herramienta. El curso solo empieza a usar una herramienta cuando existen artefactos versionados, comandos documentados y estado registrado.

## Evidencia

En este repositorio no basta con decir "esta instalado". El estado debe apoyarse en evidencia:

- comando ejecutado;
- resultado observado;
- version detectada;
- archivo generado;
- limitacion declarada.

Esta disciplina evita que una sesion futura dependa de memoria o conversacion.

## Errores de razonamiento frecuentes

| Error | Correccion |
|---|---|
| Confundir instalacion con validacion | Instalar copia archivos; validar demuestra que funcionan en este entorno. |
| Confundir MicroK8s con Kubernetes | MicroK8s es una distribucion local; Kubernetes es la API y el modelo. |
| Creer que `kubectl` siempre apunta al cluster correcto | Siempre revisa el contexto cuando algo no aparece. |
| Resolver todo con reset | Un reset puede borrar evidencia y ocultar la causa real. |
| Ignorar avisos por fase | Algunos avisos son esperados antes de instalar; otros bloquean el siguiente paso. |

## Preguntas de comprobacion

- Que diferencia hay entre host, WSL2, Ubuntu y MicroK8s?
- Que demuestra `kubectl get nodes` que no demuestra `microk8s status`?
- Por que Helm instalado no significa que existan charts del curso?
- Que capa revisarias si `snapcraft.io` no resuelve?
- Por que conviene trabajar desde una ruta Linux en lugar de `/mnt/c/...`?

## Continuidad

La Unidad 01 puede empezar cuando el alumno puede demostrar que:

- Ubuntu WSL esta operativo;
- MicroK8s esta listo;
- `kubectl` habla con el cluster;
- Helm y Terraform responden como CLI;
- las limitaciones no verificadas estan documentadas.
