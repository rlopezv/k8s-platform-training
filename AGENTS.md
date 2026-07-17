# AGENTS.md

## Proposito

Este repositorio es un framework para construir un itinerario incremental de formacion profesional sobre Kubernetes y platform engineering.

El repositorio es la fuente unica de verdad. No dependas del historial de conversacion para inferir estado, decisiones, validaciones o trabajo completado.

## Estado Actual

Segun `project/project-state.md`, el proyecto ha completado Bootstrap y ha cerrado Framework V1. El siguiente incremento permitido es:

```text
Generar la Unidad 00 - 00-environment
```

Estado verificable actual:

- no se ha generado ninguna unidad formativa;
- no hay plataforma local desplegada por artefactos del repositorio;
- no existen workloads Kubernetes del curso;
- no se ha definido la aplicacion evolutiva;
- `tutorial/`, `labs/`, `platform/` y `assets/` son rutas previstas por la arquitectura, pero Git puede no conservarlas si estan vacias;
- la Unidad 00 debe crear contenido en `tutorial/00-environment/` y artefactos ejecutables en `platform/environment/`.

## Lectura Obligatoria

Antes de cambiar archivos, lee los documentos que correspondan al trabajo.

Para cualquier trabajo sustancial, empieza por:

```text
README.md
project/architecture.md
project/project-state.md
project/roadmap.md
project/how-to.md
project/project-planning.md
playbooks/master.md
```

Para trabajo sobre la Unidad 00, lee tambien:

```text
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
playbooks/units/00-environment.md
```

No existe `summary.md` de una unidad anterior para la Unidad 00. Es una excepcion explicita declarada en `playbooks/units/00-environment.md`.

Para unidades futuras, lee tambien:

```text
tutorial/<unidad-anterior>/summary.md
playbooks/units/<unidad>.md
```

e inspecciona cualquier artefacto que la unidad deba reutilizar o modificar.

## Precedencia Documental

Si hay contradicciones, aplica este orden:

1. `project/architecture.md`
2. `playbooks/master.md`
3. `project/project-state.md`
4. `project/roadmap.md`
5. playbook especifico de la unidad
6. `summary.md` de la unidad anterior
7. tutoriales, laboratorios y artefactos existentes
8. contexto de conversacion

No resuelvas contradicciones relevantes en silencio. Identifica la contradiccion, aplica la fuente con mayor precedencia y actualiza el documento adecuado cuando el alcance lo requiera.

## Restricciones Activas

Durante la generacion de la Unidad 00, no debes:

- generar contenido de la Unidad 01;
- definir o desplegar la aplicacion evolutiva;
- crear workloads funcionales del curso;
- crear charts Helm;
- crear modulos Terraform;
- instalar o configurar Tekton, Argo CD, Prometheus, Grafana, Loki, Tempo, OpenTelemetry, KEDA, AKS o EKS;
- asumir versiones de herramientas sin validarlas;
- afirmar que Windows, WSL2, Ubuntu, MicroK8s, Helm o Terraform han sido validados si no se han ejecutado pruebas reales o el usuario no ha aportado resultados;
- guardar credenciales reales, tokens, kubeconfigs, claves privadas, credenciales de proxy, certificados o secretos corporativos;
- introducir Minikube, kind o Docker Desktop Kubernetes como plataforma paralela.

La Unidad 00 si puede:

- crear scripts idempotentes;
- crear procedimientos de validacion estatica y funcional;
- documentar validaciones manuales;
- preparar comprobaciones de Windows, WSL2, Ubuntu, MicroK8s, Helm, Terraform y Git;
- documentar diagnostico y recuperacion;
- actualizar `project/project-state.md` con estado real y verificable.

## Salidas Esperadas de la Unidad 00

La Unidad 00 debe producir:

```text
tutorial/00-environment/README.md
tutorial/00-environment/instructor-notes.md
tutorial/00-environment/summary.md
platform/environment/README.md
platform/environment/windows/
platform/environment/linux/
platform/environment/microk8s/
platform/environment/tools/
platform/environment/validation/
project/project-state.md
```

La estructura ejecutable exacta la gobierna `playbooks/units/00-environment.md`.

No crees scripts vacios ni placeholders sin comportamiento util.

## Reglas de Trabajo

- Haz el incremento coherente mas pequeno que cumpla el objetivo.
- Manten alineados documentacion, scripts, summaries y estado del proyecto.
- Usa rutas exactas del repositorio.
- Distingue contenido generado de contenido validado.
- Prefiere scripts reutilizables e idempotentes.
- Documenta precondiciones, efectos, comportamiento al repetir y recuperacion cuando una operacion no sea idempotente.
- Separa el comportamiento especifico de MicroK8s de los conceptos estandar de Kubernetes.
- Registra decisiones y limitaciones en la fuente de verdad adecuada.
- Evita duplicar contenido de gobierno salvo que el archivo destino requiera un resumen operativo breve.

## Validacion

Antes de cerrar un incremento, comprueba todo lo que pueda comprobarse en el entorno actual.

Para scripts shell generados, usa comprobaciones estaticas como:

```bash
bash -n <script>
shellcheck <script>
```

cuando esten disponibles.

Para scripts PowerShell, usa los mecanismos disponibles de sintaxis o parser cuando sea posible.

Las validaciones funcionales que dependen del host real o de WSL deben quedar como pendientes salvo que se ejecuten realmente. Ejemplos:

```text
wsl --status
wsl --list --verbose
cat /etc/os-release
microk8s status --wait-ready
kubectl version --client
kubectl get nodes
helm version
terraform version
```

Nunca declares una validacion como superada si solo se reviso el contenido del archivo.

## Cierre de Sesion

Un incremento terminado debe dejar suficiente contexto para que otra sesion continue sin historial de chat.

Antes de finalizar:

1. Actualiza `tutorial/<unidad>/summary.md` cuando haya una unidad activa.
2. Actualiza `project/project-state.md` cuando cambie el estado real, el siguiente trabajo permitido, riesgos, decisiones o entregables.
3. Revisa `git status` y `git diff`.
4. Indica archivos creados o modificados.
5. Indica validaciones ejecutadas y pendientes.
6. Registra limitaciones o riesgos.
7. Sugiere un mensaje de commit.

## Handoff

El procedimiento de handoff esta definido en:

```text
playbooks/generate-session-handoff.md
```

`SESSION_HANDOFF.md` es un artefacto derivado y temporal. No debe mantenerse manualmente como fuente de verdad.

## Idioma

La documentacion formativa debe escribirse en espanol. Los nombres tecnicos, comandos, APIs de Kubernetes, rutas y terminos habituales de herramientas deben conservar su forma estandar en ingles.
