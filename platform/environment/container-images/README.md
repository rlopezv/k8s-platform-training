# Laboratorio de referencia - contenedores, imagenes y registros

## Proposito

Este laboratorio acompaña a `tutorial/00-environment/student-reference.md`.

No construye imagenes, no instala Docker ni Podman, no habilita el registry de MicroK8s y no despliega workloads. Su objetivo es que el alumno sepa leer una referencia de imagen, ubicar el papel del runtime y anticipar que comprobara Kubernetes cuando la Unidad 01 despliegue `platform-api`.

## Precondiciones

Ejecutar desde Ubuntu WSL, en la raiz del repositorio:

```bash
pwd
kubectl version --client
```

Resultado esperado:

```text
/home/ramon/git/k8s-platform-training
kubectl responde como cliente instalado
```

No es necesario que exista ningun workload del curso desplegado.

## 1. Localizar la imagen que usara la Unidad 01

La Unidad 01 ya contiene manifiestos versionados. En este laboratorio solo se leen.

```bash
rg -n "image:|imagePullPolicy:" labs/01-kubernetes/solution/deployment.yaml
```

Resultado esperado:

```text
image: nginxinc/nginx-unprivileged:1.27.4-alpine
imagePullPolicy: IfNotPresent
```

Preguntas:

- que parte identifica el repositorio o nombre de imagen?
- que parte identifica el tag?
- por que `1.27.4-alpine` es mas reproducible que `latest`?
- que implica `IfNotPresent` si la imagen ya existe en el nodo?

## 2. Separar imagen, contenedor y Pod

Leer el bloque de contenedores del Deployment:

```bash
sed -n '/containers:/,/containerPort/p' labs/01-kubernetes/solution/deployment.yaml
```

Resultado esperado:

```text
containers:
  - name: platform-api
    image: nginxinc/nginx-unprivileged:1.27.4-alpine
    imagePullPolicy: IfNotPresent
    ports:
      - name: http
        containerPort: 8080
```

Interpretacion:

- `image` no construye la imagen; solo declara cual debe usar Kubernetes;
- `name` nombra el contenedor dentro del Pod;
- `containerPort` documenta donde escucha el proceso dentro del contenedor;
- el Pod sera creado por Kubernetes en la Unidad 01, no por este laboratorio.

## 3. Consultar el contrato Kubernetes

`kubectl explain` permite consultar el esquema de recursos Kubernetes sin modificar el cluster.

```bash
kubectl explain pod.spec.containers.image
kubectl explain pod.spec.containers.imagePullPolicy
```

Resultado esperado:

```text
KIND: Pod
FIELD: image <string>

KIND: Pod
FIELD: imagePullPolicy <string>
```

La salida exacta puede variar por version de Kubernetes, pero debe permitir confirmar que `image` e `imagePullPolicy` pertenecen a la especificacion del contenedor dentro del Pod.

## 4. Razonar sobre fallos antes de desplegar

Sin tocar el cluster, clasifica estos sintomas:

| Sintoma futuro | Causa probable | Donde mirarias |
|---|---|---|
| `ImagePullBackOff` | Imagen, tag, red, permisos o registry | Eventos del Pod y referencia `image` |
| `ErrImagePull` | Primer fallo al descargar imagen | Eventos del Pod |
| `CrashLoopBackOff` | La imagen descarga, pero el proceso falla al arrancar | Logs y comando de arranque |
| Pod `Running` sin trafico | La imagen puede estar bien; revisar puerto, Service o selector | Service, EndpointSlice y logs |

La idea clave: no todos los fallos de un Pod son fallos de imagen.

## 5. Relacion con unidades posteriores

Este laboratorio deja preguntas abiertas que se responderan mas adelante:

| Pregunta | Se retoma en |
|---|---|
| Como se construye una imagen propia? | CI/CD con Tekton |
| Donde se publica una imagen del curso? | Tekton, GitOps y cloud |
| Como se evitan tags mutables? | Promocion entre entornos y supply chain security |
| Como se firma o verifica una imagen? | Supply chain security |
| Como se autentica Kubernetes contra un registry privado? | Secretos, GitOps y cloud |

## Efectos al repetir

Este laboratorio es de solo lectura:

- no crea recursos Kubernetes;
- no descarga imagenes;
- no cambia manifiestos;
- no habilita addons;
- no instala herramientas.

Puede repetirse tantas veces como sea necesario.

## Recuperacion

No hay pasos de limpieza porque el laboratorio no modifica el entorno.
