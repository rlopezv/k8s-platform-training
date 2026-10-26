# Índice del tutorial

Este directorio contiene el itinerario formativo del curso. Las unidades son acumulativas: cada una parte de la aplicación `platform-api` y de los artefactos construidos anteriormente.

## Recorrido formativo

| Unidad | Tema | Tutorial | Laboratorio |
|---|---|---|---|
| 00 | Preparación del entorno | [README](00-environment/README.md) | [README](../platform/environment/README.md) |
| 01 | Fundamentos operativos y primera aplicación | [README](01-kubernetes/README.md) | [README](../labs/01-kubernetes/README.md) |
| 02 | Configuración, secretos y ciclo de vida | [README](02-configuration-lifecycle/README.md) | [README](../labs/02-configuration-lifecycle/README.md) |
| 03 | Networking e ingreso | [README](03-networking-ingress/README.md) | [README](../labs/03-networking-ingress/README.md) |
| 04 | Persistencia y estado | [README](04-persistence-state/README.md) | [README](../labs/04-persistence-state/README.md) |
| 05 | Scheduling, resiliencia y mantenimiento | [README](05-scheduling-resilience-maintenance/README.md) | [README](../labs/05-scheduling-resilience-maintenance/README.md) |
| 06 | Empaquetado con Helm | [README](06-helm-packaging/README.md) | [README](../labs/06-helm-packaging/README.md) |
| 07 | Automatización local con Terraform | [README](07-local-terraform-automation/README.md) | [README](../labs/07-local-terraform-automation/README.md) |
| 08 | Integración continua con Tekton | [README](08-tekton-continuous-integration/README.md) | [README](../labs/08-tekton-continuous-integration/README.md) |

## Estructura de cada unidad

La documentación principal de cada unidad se complementa, cuando existe, con:

- `student-notes.md`: guía de aprendizaje y construcción del modelo mental;
- `student-reference.md`: referencia profesional y criterios de diseño;
- `instructor-notes.md`: guía para impartir y evaluar la unidad;
- `summary.md`: estado, decisiones y continuidad hacia la siguiente unidad.

Los artefactos ejecutables se encuentran en `labs/`. La preparación del entorno de la Unidad 00 es la excepción y utiliza `platform/environment/`.

## Gobierno del itinerario

- [Estado actual del proyecto](../project/project-state.md)
- [Roadmap](../project/roadmap.md)
- [Arquitectura](../project/architecture.md)
- [README del repositorio](../README.md)
