# Referencia del alumno - Unidad 00: Contenedores, imágenes y registros

## Propósito de la referencia

Esta referencia completa `tutorial/00-environment/student-notes.md` con el mapa profesional de contenedores, imágenes y registros. Las notas explican cómo preparar y diagnosticar el entorno local; este documento explica qué ejecutará Kubernetes cuando la Unidad 01 despliegue `platform-api`.

Aplica cobertura de panorama, profundidad, criterio y práctica. Cierra `GAP-001` porque la Unidad 01 consume una imagen existente y el alumno necesita entender proceso, contenedor, imagen, runtime, registry, tag, digest, `imagePullPolicy` y errores de pull sin convertir la Unidad 00 en una práctica de construcción de imágenes.

Esta referencia no instala Docker ni Podman, no construye imágenes, no habilita el registry de MicroK8s, no crea credenciales de pull, no despliega workloads y no modifica el estado técnico del clúster.

## Relación con la unidad

La Unidad 00 practica:

- preparación y validación de Windows, WSL2, Ubuntu, MicroK8s, `kubectl`, Helm y Terraform;
- separación entre Kubernetes estándar y detalles locales de MicroK8s;
- registro de evidencias reales sin inventar validaciones;
- lectura de una futura referencia de imagen sin crear recursos.

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Notas del alumno | `tutorial/00-environment/student-notes.md` | Capas del entorno y diagnóstico dentro del laboratorio |
| README operativo | `platform/environment/README.md` | Scripts, contexto de ejecución, efectos y validaciones |
| Laboratorio de imágenes | `platform/environment/container-images/README.md` | Lectura de `image`, `imagePullPolicy` y fallos de pull sin modificar el clúster |
| Deployment de Unidad 01 | `labs/01-kubernetes/solution/deployment.yaml` | Imagen pública versionada que usará `platform-api` |

## Mapa conceptual

```text
código fuente
  -> receta de build
    -> imagen
      -> registry
        -> runtime del nodo
          -> contenedor
            -> Pod declarado en Kubernetes
```

Kubernetes no ejecuta código fuente directamente. Un Pod declara contenedores, cada contenedor arranca desde una imagen, el runtime del nodo obtiene esa imagen desde un registry y el kubelet informa el estado resultante a la API Kubernetes.

La Unidad 00 no construye esa cadena completa. Solo prepara el entorno y ofrece el vocabulario necesario para que la imagen de Unidad 01 no parezca una cadena mágica en YAML.

Distinciones clave:

- un proceso es un programa en ejecución;
- un contenedor es un proceso aislado con filesystem, entorno, red y límites;
- una imagen es una plantilla versionada para crear contenedores;
- un runtime descarga imágenes y arranca contenedores;
- un registry almacena y sirve imágenes;
- Kubernetes declara qué imagen debe ejecutar, pero no la construye.

## Conceptos y mecanismos

### Proceso, contenedor e imagen

Un proceso existe mientras se ejecuta. Un contenedor añade aislamiento alrededor de uno o varios procesos: filesystem, usuarios, red, variables de entorno, límites y señales. No es una máquina virtual completa; comparte el kernel del nodo.

Una imagen existe antes de arrancar el contenedor. Contiene filesystem, binarios, librerías, metadatos, usuario por defecto, variables, puertos declarados y comando de arranque. Si la imagen cambia, el contenedor nuevo puede comportarse de forma distinta aunque el manifiesto Kubernetes parezca igual.

| Concepto | Qué es | Qué no es |
|---|---|---|
| Proceso | Programa en ejecución | Unidad de despliegue de Kubernetes |
| Contenedor | Proceso aislado arrancado desde una imagen | Máquina virtual completa |
| Imagen | Plantilla inmutable o versionada para contenedores | Código fuente vivo |
| Runtime | Componente que descarga y ejecuta imágenes | Controlador de Kubernetes |

### OCI, Docker, Podman y containerd

OCI define especificaciones comunes para imágenes y runtimes. Ese contrato permite que una imagen construida con una herramienta compatible pueda ejecutarse con otra.

Docker popularizó la experiencia de build y ejecución local. Podman ofrece un flujo similar con un enfoque que puede funcionar sin daemon central. Kubernetes, en muchos clústeres modernos, usa `containerd` u otro runtime compatible mediante CRI.

La decisión importante no es elegir una marca en Unidad 00, sino separar responsabilidades:

| Pieza | Responsabilidad |
|---|---|
| Dockerfile o Containerfile | Describe cómo construir una imagen |
| Docker o Podman | Construye, etiqueta y prueba imágenes localmente |
| Registry | Almacena y distribuye imágenes |
| containerd u otro runtime | Descarga y arranca contenedores en el nodo |
| Kubernetes | Declara la imagen que debe ejecutar un Pod |

### Qué contiene una imagen

Una imagen suele estar formada por capas. Cada capa representa cambios sobre el filesystem anterior. Las capas permiten reutilizar contenido, distribuir cambios de forma eficiente y razonar sobre qué entra realmente en el runtime.

Una imagen profesional debería ser:

- reproducible;
- explícita en versiones;
- pequeña sin perder operabilidad;
- ejecutable como usuario no privilegiado cuando la aplicación lo permita;
- libre de secretos, cachés de build y herramientas innecesarias;
- observable cuando falla;
- compatible con el runtime y la arquitectura del nodo.

Si reconstruir una imagen depende de pasos manuales no documentados, esa imagen no es una base fiable para CI/CD ni para promoción entre entornos.

### Dockerfile y multi-stage builds

Un Dockerfile describe cómo pasar de código fuente y dependencias a una imagen ejecutable. Este ejemplo es conceptual, no un artefacto de la unidad:

```dockerfile
FROM runtime-base:version
WORKDIR /app
COPY artefactos/ .
USER 10001
EXPOSE 8080
CMD ["./app"]
```

Las decisiones que importa reconocer son:

- imagen base;
- archivos copiados;
- usuario de ejecución;
- puerto documentado;
- comando de arranque.

Un build multi-stage separa la fase de construcción de la fase de runtime:

```text
stage de build: compiladores, gestores de dependencias y herramientas pesadas
stage de runtime: solo lo necesario para ejecutar
```

Este patrón reduce tamaño, superficie de ataque y riesgo de arrastrar secretos o herramientas de compilación a producción.

### Usuario no root, filesystem, puertos y variables

Ejecutar como root dentro del contenedor aumenta el impacto de errores de configuración o vulnerabilidades. Por eso muchas imágenes profesionales se preparan para correr como usuario no privilegiado.

También conviene separar:

- filesystem de la imagen: viene de la imagen y debe tratarse como inmutable;
- filesystem escribible del contenedor: existe durante la vida del contenedor;
- volumen: almacenamiento conectado desde fuera del contenedor;
- variables de entorno: configuración recibida al arrancar;
- puerto de contenedor: puerto donde escucha el proceso dentro del Pod.

Estos temas reaparecen en unidades posteriores: ConfigMaps y Secrets en Unidad 02, volúmenes en Unidad 04, security contexts en Unidad 16 y supply chain en Unidad 17.

### Tags, `latest` y digests

Una imagen suele referenciarse así:

```text
registry.example.com/equipo/app:1.2.3
```

El tag es una etiqueta legible. Puede ser inmutable si el registry lo protege, pero técnicamente muchos registros permiten mover un tag para apuntar a otro contenido.

`latest` no significa "la versión más nueva validada". Solo es un tag convencional. Usarlo como contrato de despliegue reduce reproducibilidad porque el mismo manifiesto podría arrancar una imagen distinta en otro momento.

Un digest identifica contenido concreto:

```text
registry.example.com/equipo/app@sha256:...
```

El digest ofrece mayor reproducibilidad. En entornos profesionales se suelen combinar tags legibles, políticas que impiden sobrescribir versiones y, cuando procede, despliegue por digest.

### Registros de imágenes

Un registry almacena imágenes y permite que los nodos las descarguen.

| Tipo | Ejemplo | Uso habitual |
|---|---|---|
| Público | Docker Hub, GitHub Container Registry | Imágenes públicas o comunitarias |
| Privado corporativo | ACR, ECR, Harbor, Artifactory | Imágenes internas con control de acceso |
| Local de laboratorio | Registry addon de MicroK8s | Pruebas locales acotadas |

La Unidad 00 no habilita el registry de MicroK8s. Hacerlo implicaría nuevas decisiones sobre publicación, pull, limpieza, credenciales y relación con CI/CD. Aquí basta con entender qué problema resolvería un registry.

### Cómo Kubernetes usa una imagen

En el Deployment de Unidad 01 aparece una referencia como esta:

```yaml
containers:
  - name: platform-api
    image: nginxinc/nginx-unprivileged:1.27.4-alpine
    imagePullPolicy: IfNotPresent
```

El flujo normal es:

```text
1. El manifiesto declara una imagen.
2. El scheduler asigna el Pod a un nodo.
3. El kubelet del nodo pide la imagen al runtime.
4. El runtime consulta el registry si la imagen no está disponible localmente o si la política lo exige.
5. El runtime crea y arranca el contenedor.
6. El kubelet reporta estado del Pod a la API.
```

Si la descarga falla, el Pod puede quedar en `ErrImagePull` o `ImagePullBackOff`. Eso no significa por sí mismo que el Deployment sea el controlador equivocado: significa que el nodo no pudo obtener la imagen declarada.

### `imagePullPolicy` y credenciales

`imagePullPolicy` influye en cuándo el nodo intenta descargar una imagen.

| Política | Idea principal |
|---|---|
| `IfNotPresent` | Usa la imagen local si ya existe; si no, la descarga |
| `Always` | Comprueba el registry cada vez que arranca el contenedor |
| `Never` | No descarga; exige que la imagen ya exista en el nodo |

Para imágenes privadas, Kubernetes necesita credenciales de pull. Normalmente se configuran mediante Secrets de tipo `kubernetes.io/dockerconfigjson` y se referencian desde `imagePullSecrets` o desde una ServiceAccount.

La Unidad 00 no introduce credenciales reales. La gestión profesional de secretos y credenciales se retoma cuando aparezcan GitOps, identidad y registros cloud.

### Conexión con `platform-api`

La primera versión de `platform-api` usa:

```text
nginxinc/nginx-unprivileged:1.27.4-alpine
```

La elección es didáctica:

- expone HTTP sin construir todavía una aplicación propia;
- puede ejecutarse sin privilegios de root dentro del contenedor;
- permite observar Pods, logs, Service y errores de imagen con poco ruido;
- usa un tag explícito en lugar de `latest`.

Sus límites también son importantes:

- no enseña a crear una imagen propia;
- depende de disponibilidad externa del registry;
- no introduce firma, SBOM ni escaneo;
- no representa el ciclo completo código -> imagen -> despliegue.

## Criterios de decisión

### Cuándo basta una imagen pública versionada

Basta para una unidad inicial cuando el objetivo es aprender Kubernetes y el coste pedagógico de construir imágenes distraería del modelo de clúster, Pod, Deployment y Service.

No basta cuando la organización necesita controlar procedencia, vulnerabilidades, firma, retención, disponibilidad, promoción o cumplimiento. En ese caso la imagen debe venir de un proceso gobernado.

### Cuándo evitar `latest`

Evita `latest` siempre que quieras reproducir un despliegue, comparar entornos o depurar un cambio. Un tag explícito no garantiza por sí solo inmutabilidad, pero mejora el contrato de lectura y permite aplicar políticas de registry.

Usa digest o políticas de tag inmutable cuando el contenido exacto de la imagen sea parte del control de cambio.

### Cuándo necesitas un registry privado

Necesitas un registry privado cuando la imagen contiene código interno, dependencias privadas, requisitos de acceso, retención, escaneo, firma o promoción por entornos.

Un registry privado no resuelve todo. También exige gestión de credenciales, permisos, limpieza, replicación, disponibilidad, auditoría y política de tags.

### Cómo evaluar una imagen para Kubernetes

Antes de promover una imagen, comprueba:

- si declara y ejecuta un usuario no root cuando sea posible;
- si tiene tag o digest trazable;
- si expone el puerto que el manifiesto espera;
- si arranca con configuración externa;
- si escribe en rutas compatibles con contenedores efímeros;
- si produce logs útiles;
- si su proceso responde bien a señales de terminación;
- si el registry es accesible desde los nodos.

### Cómo interpretar `ImagePullBackOff`

`ImagePullBackOff` apunta al paso de obtención de imagen. Las causas típicas son nombre incorrecto, tag inexistente, registry caído, DNS o red bloqueados, rate limit, credenciales ausentes, credenciales inválidas o arquitectura incompatible.

No lo confundas con `CrashLoopBackOff`: en ese caso la imagen se descargó y el problema aparece al arrancar o mantener el proceso.

## Relación con el laboratorio

El laboratorio practica:

- validar capas del entorno local;
- instalar y validar MicroK8s, `kubectl`, Helm y Terraform;
- leer la imagen que usará Unidad 01 en `labs/01-kubernetes/solution/deployment.yaml`;
- consultar el contrato Kubernetes de `image` e `imagePullPolicy` con comandos de lectura;
- razonar sobre errores de pull sin crear Pods nuevos.

El laboratorio menciona, pero no practica:

- construcción de imágenes propias: Unidad 08;
- publicación en registry: Unidad 08 y Unidades 20-21 para cloud;
- credenciales reales de registry: Unidad 09 y seguridad posterior;
- SBOM, firma y verificación de imágenes: Unidad 17;
- registry de MicroK8s: fuera del flujo principal salvo decisión posterior explícita;
- tuning avanzado de API Server local: fuera de Unidad 00; se retoma solo si una unidad operativa lo necesita.

Restricción de la unidad: no modificar `platform/environment/` para convertir esta referencia en una práctica de build. El cierre de `GAP-001` es documental y conceptual.

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Pensar que Kubernetes construye imágenes | Kubernetes consume imágenes; el build pertenece a CI/CD o a herramientas de contenedores |
| Creer que un contenedor es una máquina virtual | Lleva a esperar aislamiento, kernel y ciclo de vida que no existen |
| Usar `latest` como versión validada | Reduce reproducibilidad y dificulta auditoría |
| Confundir tag con digest | El tag puede moverse; el digest identifica contenido concreto |
| Pensar que una imagen pública es una estrategia de supply chain | Falta gobierno sobre procedencia, escaneo, firma, retención y disponibilidad |
| Tratar `ImagePullBackOff` como fallo de la aplicación | El proceso quizá ni siquiera arrancó porque la imagen no se descargó |
| Creer que instalar Docker es requisito para usar Kubernetes | Los nodos usan runtimes compatibles; el cliente de build no tiene por qué existir en la estación del alumno |
| Guardar credenciales de registry en Git | Expone acceso a imágenes privadas y rompe el modelo de secretos del curso |

## Continuidad

Unidad 01 retoma esta referencia al desplegar `platform-api` con `image: nginxinc/nginx-unprivileged:1.27.4-alpine` e `imagePullPolicy: IfNotPresent`. Allí el alumno observa cómo una imagen declarada se convierte en contenedores dentro de Pods.

Unidad 02 conecta variables de entorno, ConfigMaps y Secrets con la configuración que recibe un contenedor al arrancar.

Unidad 04 separa filesystem efímero del contenedor, volumen y persistencia externa.

Unidad 08 introduce el lugar natural para construir imágenes en pipeline, ejecutar tests y preparar publicación.

Unidad 09 retoma la gestión real de secretos y credenciales en un flujo GitOps, sin guardarlas en Git.

Unidad 17 profundiza en supply chain: SBOM, firma, verificación, políticas de admisión y bloqueo de imágenes no conformes.

Unidades 20 y 21 conectan la publicación y consumo de imágenes con ACR en Azure y ECR en AWS.

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Open Container Initiative](https://opencontainers.org/) | Qué estandarizan las especificaciones de imagen y runtime | Qué contrato permite interoperar entre herramientas de contenedores? |
| [Kubernetes - Images](https://kubernetes.io/docs/concepts/containers/images/) | Nombres de imagen, tags, digests y pull policies | Cómo decide Kubernetes qué imagen descargar? |
| [Kubernetes - Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) | Credenciales de pull mediante Secrets | Cómo obtiene un Pod acceso a una imagen privada? |
| [Dockerfile reference](https://docs.docker.com/reference/dockerfile/) | Instrucciones principales de una receta de imagen | Qué decisiones quedan codificadas en el build? |
| [Podman documentation](https://docs.podman.io/) | Construcción y ejecución local compatible con OCI | Por qué Docker no es la única herramienta posible? |
