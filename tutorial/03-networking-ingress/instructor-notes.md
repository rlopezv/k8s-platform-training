# Instructor notes - Unidad 03

## Intencion pedagogica

La unidad debe cambiar la pregunta del alumno de "como hago curl a mi aplicacion" a "que cadena de responsabilidades permite que una peticion llegue a un Pod correcto".

El punto clave es separar tres ideas:

- Service como contrato estable interno;
- DNS interno como descubrimiento dentro del cluster;
- Ingress Controller e `Ingress` como entrada HTTP desde fuera.

## Puntos de enfasis

- Ingress no sustituye al Service; depende de el.
- EndpointSlice es la evidencia principal de que el Service tiene backends listos.
- DNS interno de Kubernetes no es `/etc/hosts` ni DNS publico.
- El `Ingress` es una regla; el controlador es quien la ejecuta.
- En MicroK8s `v1.35`, el addon Ingress usa Traefik por defecto y la clase `public` es una opcion valida del entorno local.
- Gateway API debe presentarse como evolucion conceptual, no como practica de esta unidad.

## Demostraciones recomendadas

1. Mostrar Pods, Service y EndpointSlice antes de aplicar el Ingress.
2. Ejecutar la prueba de DNS interno desde un Pod temporal.
3. Mostrar que el Service sigue siendo `ClusterIP`.
4. Aplicar `ingress.yaml` y describir host, path y backend.
5. Probar `curl -H 'Host: platform-api.local'`.
6. Repetir la prueba sin cabecera `Host` para observar que no es la misma ruta HTTP.

## Errores frecuentes

| Error | Sintoma | Intervencion |
|---|---|---|
| No habilitar el controlador | `Ingress` existe pero HTTP no funciona | Revisar `kubectl get ingressclass` y `kubectl get pods -n ingress` |
| Selector roto del Service | Service sin EndpointSlice util | Comparar labels de Pods y selector del Service |
| Pods no Ready | EndpointSlice sin backends listos o HTTP 503 | Revisar probes, eventos y rollout |
| Host incorrecto | 404 o backend por defecto | Revisar cabecera `Host` y regla del `Ingress` |
| Confundir DNS interno y local | Resuelve en un sitio pero no en otro | Separar prueba desde Pod y prueba desde cliente local |

## Preguntas de comprobacion

- Que cambia si un Pod de `platform-api` se recrea?
- Por que el Service puede existir aunque no tenga endpoints utiles?
- Que recurso deberias mirar antes de culpar al Ingress?
- Que ocurre si el `Ingress` referencia un Service correcto pero un puerto incorrecto?
- Por que `platform-api.local` no es DNS productivo?
- Que problema intenta resolver Gateway API que Ingress resuelve solo parcialmente?

## Criterios de evaluacion

El alumno debe ser capaz de:

- dibujar la cadena cliente -> controlador -> Ingress -> Service -> EndpointSlice -> Pod;
- validar el Service sin usar port-forward;
- ejecutar una prueba DNS desde dentro del cluster;
- explicar por que `Ingress` necesita controlador;
- diagnosticar un fallo de host HTTP incorrecto;
- recuperar el laboratorio reaplicando manifiestos.

## Riesgos tecnicos

- El addon Ingress de MicroK8s puede no estar habilitado.
- La imagen `busybox:1.36` del Pod temporal puede requerir pull si no existe en cache.
- En algunos entornos WSL, `127.0.0.1` puede no ser el punto correcto para alcanzar el controlador; usar `INGRESS_URL=http://<IP-del-nodo>/`.
- Los logs del controlador pueden variar si MicroK8s cambia detalles internos del addon.
- `shellcheck` puede no estar instalado; registrar como validacion pendiente si no esta disponible.

## Limites de alcance

No introducir en la sesion:

- Helm;
- Terraform;
- Gateway API operativa;
- TLS productivo;
- cert-manager;
- DNS publico;
- LoadBalancer cloud;
- NetworkPolicies;
- service mesh;
- observabilidad avanzada;
- AKS o EKS.

## Cierre recomendado

Antes de cerrar, confirmar:

- `labs/03-networking-ingress/solution/` existe completo;
- `service/platform-api` sigue siendo `ClusterIP`;
- `ingress/platform-api` enruta a `service/platform-api:80`;
- el summary registra validaciones ejecutadas y no ejecutadas;
- `project/project-state.md` no afirma aprobacion pedagogica si el usuario aun no la ha dado.
