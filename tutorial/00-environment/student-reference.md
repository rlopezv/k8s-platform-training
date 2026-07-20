# Student reference - Unidad 00

## Proposito de esta referencia

Esta referencia completa la Unidad 00 con una vision profesional de contenedores, imagenes y registros.

No es una guia de construccion de imagenes y no pide crear una imagen en esta unidad. Su objetivo es que, cuando la Unidad 01 despliegue `platform-api`, el alumno no vea la imagen como una cadena magica dentro de un YAML.

Tiene un laboratorio de acompañamiento en `platform/environment/container-images/README.md`. Ese laboratorio es de solo lectura: ayuda a localizar campos como `image` e `imagePullPolicy`, consultar el contrato Kubernetes y razonar sobre fallos de pull sin modificar el cluster.

La Unidad 00 prepara el entorno. Esta referencia prepara el mapa mental de una parte esencial de ese entorno: Kubernetes no ejecuta codigo fuente directamente; ejecuta contenedores creados a partir de imagenes, y esas imagenes viven normalmente en registros.

## Por que aparece en la Unidad 00

Antes de Kubernetes hay una pregunta mas basica:

```text
Que es exactamente lo que va a ejecutar el cluster?
```

La respuesta no es "una aplicacion" en abstracto. Kubernetes ejecuta contenedores. Un contenedor arranca desde una imagen. Una imagen se construye, se etiqueta, se publica en un registro y se descarga en el nodo donde vaya a ejecutarse el Pod.

La Unidad 01 usa una imagen publica ya existente para no mezclar demasiados trabajos a la vez. Eso es correcto para empezar con Kubernetes, pero deja una laguna conceptual importante. Esta referencia y su laboratorio de acompañamiento cubren esa laguna sin construir imagenes ni habilitar un registry local.

## Proceso, contenedor, imagen y runtime

Un proceso es un programa en ejecucion dentro de un sistema operativo.

Un contenedor es una forma de ejecutar uno o varios procesos con aislamiento de filesystem, red, usuarios, limites y entorno. No es una maquina virtual completa. Comparte el kernel del host, pero ve un entorno controlado.

Una imagen es una plantilla inmutable desde la que se crean contenedores. Contiene el filesystem base, binarios, librerias, metadatos, usuario por defecto, variables, puertos declarados y comando de arranque.

Un runtime de contenedores es la pieza que descarga imagenes, prepara el entorno de ejecucion y arranca contenedores. En Kubernetes, el kubelet habla con el runtime mediante la Container Runtime Interface, o CRI.

Resumen:

| Concepto | Que es | Cuando existe |
|---|---|---|
| Proceso | Programa ejecutandose | Durante la ejecucion |
| Contenedor | Proceso aislado con filesystem y configuracion propios | Durante la ejecucion |
| Imagen | Plantilla versionada para crear contenedores | Antes de ejecutar |
| Runtime | Motor que descarga imagenes y arranca contenedores | En el nodo |

## OCI, containerd, Docker y Podman

OCI, Open Container Initiative, define especificaciones comunes para imagenes y runtimes. Gracias a ese contrato, una imagen puede construirse con una herramienta y ejecutarse con otra compatible.

Docker popularizo la experiencia de construir y ejecutar contenedores. Incluye herramientas de usuario, formato de Dockerfile, cliente, daemon y flujo de trabajo local.

Podman ofrece una experiencia parecida para construir y ejecutar contenedores, con un enfoque que puede funcionar sin daemon central y con mejor integracion rootless en algunos entornos.

containerd es un runtime ampliamente usado por Kubernetes. En muchos clusters modernos, Kubernetes no habla con Docker como runtime principal; habla con containerd u otro runtime compatible mediante CRI.

Para el itinerario, lo importante no es memorizar marcas, sino separar responsabilidades:

| Pieza | Responsabilidad |
|---|---|
| Dockerfile o Containerfile | Describe como construir una imagen |
| Docker o Podman | Herramientas habituales para construir, etiquetar y probar imagenes |
| Registry | Almacena y sirve imagenes |
| containerd u otro runtime | Descarga y ejecuta imagenes en el nodo |
| Kubernetes | Declara que imagen debe ejecutar un Pod |

## Que contiene una imagen

Una imagen suele construirse por capas. Cada instruccion relevante de la receta de construccion puede crear una capa nueva. Las capas permiten reutilizar contenido y distribuir cambios de forma eficiente.

Una imagen profesional debe ser:

- reproducible;
- pequena sin sacrificar operabilidad;
- explicita en versiones;
- segura por defecto;
- observable durante el diagnostico;
- compatible con el runtime donde se ejecutara.

Una imagen no deberia depender de pasos manuales no documentados. Si para reconstruirla hace falta recordar una conversacion, copiar archivos a mano o usar una version implicita de una herramienta, esa imagen no es una base fiable para CI/CD.

## Dockerfile como receta

Un Dockerfile describe como pasar de codigo fuente y dependencias a una imagen ejecutable.

Ejemplo conceptual:

```dockerfile
FROM runtime-base:version
WORKDIR /app
COPY artefactos/ .
USER 10001
EXPOSE 8080
CMD ["./app"]
```

Este ejemplo no forma parte del laboratorio de Unidad 00. Sirve para reconocer decisiones que apareceran mas adelante:

- que imagen base se usa;
- que archivos entran en la imagen;
- que usuario ejecuta el proceso;
- que puerto documenta la imagen;
- que comando arranca la aplicacion.

## Multi-stage builds

Un build multi-stage separa la fase de construccion de la fase de ejecucion.

La idea es sencilla:

```text
stage de build
  contiene compiladores, gestores de dependencias y herramientas pesadas

stage de runtime
  contiene solo lo necesario para ejecutar
```

Esto reduce tamano, superficie de ataque y ruido operativo. Tambien ayuda a que la imagen final no incluya secretos, caches o herramientas que solo eran necesarias durante la compilacion.

Este patron sera importante cuando el curso llegue a CI/CD y supply chain security.

## Usuario no root, filesystem, puertos y variables

Ejecutar como root dentro del contenedor aumenta el impacto de errores de configuracion o vulnerabilidades. Una imagen preparada para Kubernetes deberia poder ejecutarse con un usuario no privilegiado siempre que la aplicacion lo permita.

Tambien conviene distinguir:

- filesystem de la imagen: viene de la imagen y deberia tratarse como inmutable;
- filesystem escribible del contenedor: existe durante la vida del contenedor;
- volumen: almacenamiento conectado desde fuera del contenedor;
- variables de entorno: configuracion recibida al arrancar;
- puerto del contenedor: puerto donde escucha el proceso dentro del Pod.

Estas diferencias conectan con unidades posteriores:

| Tema | Unidad |
|---|---|
| Variables, ConfigMaps y Secrets | Unidad 02 |
| Volumenes y persistencia | Unidad 04 |
| Security contexts y privilegios | Unidad 16 |
| SBOM, firma y verificacion | Unidad 17 |

## Tags, `latest` y digests

Una imagen se referencia normalmente con:

```text
registry.example.com/equipo/app:1.2.3
```

El tag es una etiqueta legible. Puede ser inmutable si la organizacion lo protege, pero tecnicamente muchos registros permiten mover un tag para apuntar a otra imagen.

`latest` no significa "la mejor version" ni "la version mas nueva validada". Solo es un tag convencional. Usarlo en plataformas compartidas reduce reproducibilidad.

Un digest identifica el contenido de una imagen:

```text
registry.example.com/equipo/app@sha256:...
```

El digest es mas reproducible porque apunta a contenido concreto. En entornos profesionales es habitual combinar tags legibles para humanos con digests o politicas que impidan sobrescribir versiones publicadas.

## Registros de imagenes

Un registry almacena imagenes y permite que los nodos las descarguen.

Tipos habituales:

| Tipo | Ejemplo | Uso |
|---|---|---|
| Publico | Docker Hub, GitHub Container Registry | Imagenes publicas o de comunidad |
| Privado corporativo | ACR, ECR, Harbor, Artifactory | Imagenes internas con control de acceso |
| Local de laboratorio | Registry addon de MicroK8s | Pruebas sin publicar fuera del entorno local |

La Unidad 00 no habilita el registry de MicroK8s. Queda como concepto para entender que, antes de CI/CD, el curso debe decidir donde se publica una imagen y como Kubernetes la descarga.

## Como Kubernetes usa una imagen

En un Pod o Deployment aparece una referencia como esta:

```yaml
containers:
  - name: platform-api
    image: nginxinc/nginx-unprivileged:1.27.4-alpine
    imagePullPolicy: IfNotPresent
```

Kubernetes no construye esa imagen. El flujo normal es:

```text
1. El manifiesto declara una imagen.
2. El scheduler asigna el Pod a un nodo.
3. El kubelet del nodo pide la imagen al runtime.
4. El runtime consulta el registry si la imagen no esta disponible localmente o si la politica lo exige.
5. El runtime crea y arranca el contenedor.
6. El kubelet reporta estado del Pod a la API.
```

Si la descarga falla, el Pod puede quedar en `ImagePullBackOff` o `ErrImagePull`. Ese fallo no significa que el Deployment este mal como controlador; significa que el nodo no ha podido obtener la imagen declarada.

## `imagePullPolicy` y credenciales

`imagePullPolicy` influye en cuando el nodo intenta descargar una imagen.

| Politica | Idea principal |
|---|---|
| `IfNotPresent` | Usa la imagen local si ya existe; si no, la descarga |
| `Always` | Comprueba el registry cada vez que arranca el contenedor |
| `Never` | No descarga; exige que la imagen exista ya en el nodo |

Para imagenes privadas, Kubernetes necesita credenciales de pull. Normalmente se configuran mediante Secrets de tipo `kubernetes.io/dockerconfigjson` y se referencian desde `imagePullSecrets` o desde una ServiceAccount.

Este curso no introduce credenciales reales en Unidad 00. La gestion seria parte de un bloque posterior sobre CI/CD, GitOps, secretos y cloud registries.

## Conexion con `platform-api`

La primera version de `platform-api` usa:

```text
nginxinc/nginx-unprivileged:1.27.4-alpine
```

Esa eleccion tiene tres ventajas didacticas:

- expone HTTP sin construir todavia una aplicacion propia;
- puede ejecutarse sin privilegios de root dentro del contenedor;
- permite observar Pods, logs, Service y errores de imagen con poco ruido.

Tambien tiene limites:

- no ensena a crear una imagen propia;
- depende de disponibilidad externa del registry;
- no introduce firma, SBOM ni escaneo;
- no representa todavia un ciclo completo codigo -> imagen -> despliegue.

La Unidad 01 acepta esos limites para centrarse en Kubernetes. Las unidades posteriores deberan cerrar el ciclo de imagenes cuando aparezcan CI/CD y seguridad de supply chain.

## Relacion con Tekton, supply chain y cloud

Tekton no solo ejecuta comandos. En una plataforma real suele formar parte de un flujo como este:

```text
codigo
  -> build
  -> test
  -> imagen
  -> SBOM
  -> firma/verificacion
  -> publicacion en registry
  -> despliegue declarativo
```

Supply chain security necesita saber que se esta protegiendo:

- receta de construccion;
- dependencias;
- imagen resultante;
- identidad del proceso que construye;
- registro donde se publica;
- evidencia de firma o verificacion;
- politica que permite o bloquea el despliegue.

En cloud, los registros suelen ser servicios gestionados:

| Plataforma | Registry habitual |
|---|---|
| Azure | Azure Container Registry |
| AWS | Elastic Container Registry |
| Entorno neutral | Harbor, GitHub Container Registry u otro registry OCI |

Por eso esta referencia aparece temprano: no obliga a ejecutar todos esos pasos, pero da vocabulario y mapa mental para reconocerlos cuando aparezcan.

## Que recordar para la Unidad 01

Antes de desplegar `platform-api`, recuerda:

- Kubernetes ejecuta contenedores dentro de Pods;
- los contenedores arrancan desde imagenes;
- la imagen debe existir en un registry o estar disponible en el nodo;
- `image` identifica que se quiere ejecutar;
- `imagePullPolicy` influye en la descarga;
- `ImagePullBackOff` suele apuntar a nombre, tag, red, permisos o disponibilidad del registry;
- usar una imagen publica versionada es una decision didactica, no una estrategia completa de produccion.

## Fuentes de referencia

| Fuente | Que leer | Pregunta que deberias poder responder |
|---|---|---|
| Open Container Initiative | Concepto de runtime e image specification | Que estandar comparten las herramientas de contenedores? |
| Kubernetes Documentation - Images | Nombres de imagen, tags, digests y pull policies | Como decide Kubernetes que imagen descargar? |
| Kubernetes Documentation - Pull an Image from a Private Registry | Uso de credenciales para registros privados | Como obtiene Kubernetes acceso a una imagen privada? |
| Docker Documentation - Dockerfile reference | Instrucciones principales de Dockerfile | Que decisiones quedan codificadas en una receta de imagen? |
| Podman Documentation | Construccion y ejecucion local compatible con contenedores OCI | Por que Docker no es la unica herramienta posible? |
