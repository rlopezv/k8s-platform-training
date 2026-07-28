# Catálogo de componentes de clúster

Este directorio cataloga las herramientas que se despliegan dentro del clúster durante el curso, como controladores, CRDs u operadores, frente a los CLIs locales, que viven en `platform/environment/tools/` y se instalan en la Unidad 00.

## Convención

Cada componente de clúster:

- se instala por su método oficial upstream, con versión fija verificada contra la documentación oficial al generar su unidad, nunca `latest`;
- se instala en la unidad cuyo tema es ese componente, nunca antes;
- se declara como precondición de entorno en el README del laboratorio de esa unidad, con método, versión, namespace, persistencia y limpieza completa;
- documenta su retirada incluyendo los recursos que genera después de instalarse.

El catálogo provee la referencia de instalación. La decisión de instalar, cuándo y con qué ciclo de vida vive en el playbook y el README de cada unidad. Este documento no instala nada por sí mismo.

## Componentes

| Componente | Unidad | Método oficial | Versión | Namespace | Persiste | Estado |
|---|---|---|---|---|---|---|
| Tekton Pipelines | 08 | `kubectl apply -f https://infra.tekton.dev/tekton-releases/pipeline/previous/v1.12.2/release.yaml` | `v1.12.2` LTS, verificada el 2026-07-28 contra fuentes oficiales de Tekton; soportada hasta mayo de 2027 | `tekton-pipelines` | Sí, hacia Unidades 09-10 | Instalado; controladores `Available`; CRDs presentes; `PipelineRun` de Unidad 08 completado |
| Argo CD | 09 | Por definir al generar la Unidad 09 | Por definir | Por definir | Por definir | Esperado |
| Prometheus | 11 | Por definir al generar la Unidad 11 | Por definir | Por definir | Por definir | Esperado |
| Grafana | 12 | Por definir al generar la Unidad 12 | Por definir | Por definir | Por definir | Esperado |
| KEDA | 18 | Por definir al generar la Unidad 18 | Por definir | Por definir | Por definir | Esperado |
| Velero | 23 | Por definir al generar la Unidad 23 | Por definir | Por definir | Por definir | Esperado |

Las filas marcadas `Por definir` se completan al generar su unidad, con datos verificados en ese momento. No se rellenan por adelantado: las versiones caducan y las decisiones de método dependen del diseño de cada unidad.

## Qué no va aquí

Los CLIs locales, como Helm, Terraform y `kubectl`, no son componentes de clúster. Viven en `platform/environment/tools/` y se instalan en la Unidad 00.

El operador de Tekton, Argo CD u otros no es la vía de instalación de este curso salvo decisión explícita posterior. La gestión mediante operador es criterio de referencia y candidata a laboratorio avanzado, no la vía del tronco.

## Limpieza de Tekton Pipelines

La Unidad 08 documenta la limpieza precisa de recursos de laboratorio en:

```text
labs/08-tekton-continuous-integration/README.md
```

La retirada completa del componente, cuando el instructor decida no conservarlo hacia Unidades 09-10, utiliza el mismo manifiesto oficial versionado:

```bash
kubectl delete -f https://infra.tekton.dev/tekton-releases/pipeline/previous/v1.12.2/release.yaml
```
