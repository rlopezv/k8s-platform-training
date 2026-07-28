# Instructor notes - Unidad 08

## Intención pedagógica

La unidad debe cambiar la pregunta del alumno de "qué comando ejecuto" a "qué contrato de CI estoy declarando". Tekton se presenta como una extensión de Kubernetes que crea trabajo efímero, observable y componible, no como una excusa para meter todos los comandos locales dentro de un YAML.

El punto crítico es la frontera: Unidad 08 valida y planifica; no despliega continuamente. Si el alumno intenta convertir el pipeline en `terraform apply`, conviene detener la práctica y volver a ownership, state compartido, aprobaciones y preparación para Argo CD.

## Énfasis recomendados

- Mostrar primero los CRDs de Tekton con `kubectl api-resources --api-group=tekton.dev`.
- Separar definición (`Task`, `Pipeline`) de ejecución (`TaskRun`, `PipelineRun`).
- Insistir en que cada Step es un contenedor con filesystem efímero.
- Usar el Workspace para explicar por qué una Task no ve automáticamente lo que hizo otra.
- Leer los Results como contrato pequeño, no como logs ni almacén de artefactos.
- Comparar `Job`/`CronJob` con Tekton desde responsabilidad, no desde preferencia.
- Repetir que el `ConfigMap` de fuente es una adaptación local sin credenciales Git.

## Demostración recomendada

1. Instalar Tekton Pipelines `v1.12.2`.
2. Enseñar los controladores en `tekton-pipelines`.
3. Crear el `ConfigMap` de fuente.
4. Aplicar ServiceAccount, RBAC, Tasks y Pipeline.
5. Ejecutar `PipelineRun`.
6. Observar TaskRuns y logs.
7. Leer Results.
8. Mostrar el PVC temporal.
9. Cambiar una copia del `PipelineRun` a `execution_mode=apply` para enseñar `when` y el bloqueo intencional.

## Errores frecuentes durante la sesión

| Error | Intervención |
|---|---|
| El alumno espera que el clúster lea su carpeta local | Preguntar qué filesystem ve un Pod y mostrar el `ConfigMap` de fuente |
| Se confunde Pipeline con PipelineRun | Volver a la analogía definición frente a ejecución |
| Se miran solo logs globales | Guiar hacia TaskRun y Step |
| Se propone añadir `terraform apply` | Revisar la decisión D-08-01 del playbook |
| Se pide usar Triggers | Anclar a Unidad 10 o laboratorio avanzado |
| Se quiere usar credenciales reales | Recordar que el repo no versiona secretos reales |

## Criterios de evaluación

El alumno debería poder:

- explicar qué instaló Tekton en el clúster;
- seguir la relación PipelineRun -> TaskRun -> Pod -> Step;
- justificar por qué existe el Workspace;
- leer un Result sin confundirlo con un log;
- diagnosticar un TaskRun fallido;
- explicar por qué el plan Terraform no aplica cambios;
- decidir cuándo usaría `Job`, `CronJob` o Tekton.

## Riesgos técnicos

- La validación funcional requiere descargar imágenes de contenedor e instalar Tekton; si no hay red, se limita a validación estática.
- `terraform plan -refresh=false` no representa un plan productivo completo; es una práctica no mutante de CI sobre fuente versionada.
- Si el clúster ya tiene Tekton con otra versión, registrar el hecho antes de sobrescribir.
- La limpieza de Tekton con el `release.yaml` elimina CRDs y puede borrar recursos Tekton; solo debe hacerse cuando no se necesite persistencia hacia Unidades 09-10.
