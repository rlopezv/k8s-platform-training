# Precondiciones de Tekton

Tekton Pipelines se instala en el namespace `tekton-pipelines` mediante el manifiesto oficial versionado:

```bash
kubectl apply -f https://infra.tekton.dev/tekton-releases/pipeline/previous/v1.12.2/release.yaml
```

La versión `v1.12.2` se fijó el 2026-07-28 tras comprobar fuentes oficiales de Tekton: es una línea LTS soportada hasta mayo de 2027. La release general más reciente publicada en esa comprobación era `v1.14.1`, no LTS.

La unidad no instala Tekton Operator, Tekton Triggers, Tekton Chains, Tekton Results ni dashboard.
