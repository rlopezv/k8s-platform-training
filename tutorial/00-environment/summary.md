# Summary - Unidad 00

## Identificación

| Campo | Valor |
|---|---|
| Unidad | 00 - Preparación del entorno |
| Identificador | `00-environment` |
| Fase del roadmap | Fase 1 - Plataforma local |
| Estado | Completada con limitaciones documentadas; saneamiento documental de fase 4 aplicado |
| Última actualización | 2026-07-27 |
| Revisión pedagógica del saneamiento | Aprobada por el usuario el 2026-07-27 |

## Resumen ejecutivo

La Unidad 00 queda cerrada como preparación del entorno base y saneada contra el contrato documental vigente. Dispone de documentación y scripts para validar Windows, WSL2, Ubuntu 24.04 LTS, MicroK8s, `kubectl`, Helm y Terraform.

El saneamiento documental regeneró `playbooks/units/00-environment.md`, regeneró `tutorial/00-environment/student-reference.md` con la estructura canónica de `playbooks/student-reference-template.md`, y ajustó `README.md` y `student-notes.md` para respetar la frontera entre diagnóstico del laboratorio y referencia profesional.

`GAP-001` queda confirmado como cerrado por `tutorial/00-environment/student-reference.md`, que cubre contenedores, imágenes y registros sin construir imágenes, instalar Docker o Podman, habilitar registry local, crear credenciales de pull ni modificar el clúster. El laboratorio de acompañamiento `platform/environment/container-images/README.md` sigue siendo de solo lectura.

No se han ejecutado validaciones funcionales nuevas durante este saneamiento. No se han modificado scripts de `platform/environment/`, labs de Unidades 01-07, manifiestos Kubernetes, workloads, charts Helm ni módulos Terraform.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Preparar y validar la plataforma local base | Alcanzado históricamente | `platform/environment/`, evidencias registradas en este summary y `project/project-state.md` |
| Separar Kubernetes estándar de MicroK8s local | Alcanzado | `tutorial/00-environment/README.md`, `tutorial/00-environment/student-notes.md` |
| Instalar y validar Helm y Terraform como CLI | Alcanzado históricamente | Versiones registradas: Helm `v3.21.0+ge0878d4`, Terraform `1.15.7` |
| Cerrar `GAP-001` documentalmente | Alcanzado | `tutorial/00-environment/student-reference.md`, `project/content-gap-register.md` |
| Regenerar playbook contra contrato documental | Alcanzado | `playbooks/units/00-environment.md` |
| Evitar cambios funcionales durante fase 4 | Alcanzado | Diff limitado a documentación permitida |

## Estado inicial utilizado

## Plataforma

- Unidad 00 ya existía y estaba completada con limitaciones documentadas.
- Ubuntu 24.04.4 LTS, MicroK8s `v1.35.6`, `kubectl` `v1.35.6`, Helm `v3.21.0+ge0878d4` y Terraform `1.15.7` estaban registrados como validados por evidencias históricas.

## Aplicación

- No existía aplicación evolutiva dentro de Unidad 00.
- `platform-api` empieza en Unidad 01.

## Seguridad

- No existían credenciales reales versionadas.
- La referencia de contenedores e imágenes no introduce credenciales de registry.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Plan de saneamiento | `project/documentation-cleanup-plan.md` | Gobernar fase 4 |
| Contrato de referencia | `playbooks/student-reference-template.md` | Regenerar `student-reference.md` |
| Registro de lagunas | `project/content-gap-register.md` | Confirmar `GAP-001` |
| Checklist de cobertura | `.work/detail.md` | Verificación de Unidad 00; no contrato ni estructura |
| Documentación actual de Unidad 00 | `tutorial/00-environment/` | Base ajustada |
| Artefactos de entorno | `platform/environment/` | Reutilizados sin cambios funcionales |

## Cambios introducidos

## Capacidades incorporadas

- Conformidad documental de Unidad 00 contra contrato de fase 4.
- Referencia canónica del alumno para `GAP-001`.
- Frontera explícita entre `student-notes.md` y `student-reference.md`.
- Cobertura explícita de `.work/detail.md` dentro del playbook.
- Registro de que el saneamiento no ejecutó validaciones funcionales nuevas.

## Componentes creados

```text
Ninguno
```

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Playbook de Unidad 00 | `playbooks/units/00-environment.md` | Regenerado contra contrato documental; declara frontera, `GAP-001`, cobertura, simplificaciones y uso limitado de `.work/detail.md` |
| README de alumno | `tutorial/00-environment/README.md` | Ajustado como puerta de entrada y con ortografía completa |
| Notas del alumno | `tutorial/00-environment/student-notes.md` | Ajustadas para diagnóstico del entorno y sin duplicar la referencia |
| Referencia del alumno | `tutorial/00-environment/student-reference.md` | Regenerada con estructura canónica y cierre de `GAP-001` |
| Summary | `tutorial/00-environment/summary.md` | Actualizado con estado del saneamiento |
| Estado del proyecto | `project/project-state.md` | Actualizado con cierre de saneamiento de Unidad 00 y `TD-019` |
| Registro de lagunas | `project/content-gap-register.md` | Revisión de `GAP-001` confirmada como cerrada |

## Componentes retirados

```text
Ninguno
```

## Estructura final de artefactos

```text
tutorial/00-environment/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

platform/environment/
├── README.md
├── container-images/
│   └── README.md
├── linux/
│   └── check-prerequisites.sh
├── microk8s/
│   ├── configure.sh
│   ├── install.sh
│   ├── reset.sh
│   └── validate.sh
├── tools/
│   ├── install-helm.sh
│   ├── install-terraform.sh
│   └── validate-tools.sh
├── validation/
│   └── validate-environment.sh
└── windows/
    ├── check-prerequisites.ps1
    └── prepare-ubuntu-wsl.ps1
```

## Estado técnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| Ubuntu WSL | Validada históricamente | Ubuntu 24.04.4 LTS (`noble`) |
| MicroK8s | Instalado y validado históricamente | `v1.35.6`, canal `1.35/stable` |
| Kubernetes | Disponible en MicroK8s | Nodo `gmktecg2` en `Ready` registrado |
| `kubectl` | Cliente principal validado históricamente | `v1.35.6` |
| Helm | CLI validada históricamente | `v3.21.0+ge0878d4` |
| Terraform | CLI validada históricamente | `1.15.7` |

## Aplicación

```text
No definida ni desplegada en Unidad 00.
```

## Automatización

| Elemento | Estado final | Evidencia |
|---|---|---|
| Scripts de entorno | Conservados sin cambios funcionales | `platform/environment/` |
| Laboratorio de imágenes | Solo lectura | `platform/environment/container-images/README.md` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Credenciales reales | No versionadas | Revisión documental |
| Registry local | No habilitado por Unidad 00 | `student-reference.md` lo declara fuera de práctica |
| Build de imágenes | No practicado | Anclado a Unidad 08 |

## Inventario relevante

## Herramientas y versiones

| Herramienta | Versión validada | Método de comprobación |
|---|---|---|
| Ubuntu | 24.04.4 LTS (`noble`) | Evidencia histórica de Unidad 00 |
| MicroK8s | `v1.35.6` | Evidencia histórica de Unidad 00 |
| Kubernetes | `v1.35.6` | Evidencia histórica de Unidad 00 |
| `kubectl` | `v1.35.6` | Evidencia histórica de Unidad 00 |
| Helm | `v3.21.0+ge0878d4` | Evidencia histórica de Unidad 00 |
| Terraform | `1.15.7` | Evidencia histórica de Unidad 00 |

## Decisiones tomadas

## D-00-09 - Cierre documental de `GAP-001`

### Decisión

La Unidad 00 cierra `GAP-001` mediante `student-reference.md` y un laboratorio de acompañamiento de solo lectura, no mediante build de imagen, registry local ni credenciales.

### Motivo

La Unidad 01 necesita consumir y diagnosticar una imagen, pero construirla pertenece al flujo de CI/CD y supply chain de unidades posteriores.

### Consecuencias

- `student-reference.md` explica contenedor, imagen, runtime, registry, tags, digests e `imagePullPolicy`;
- `platform/environment/container-images/README.md` permite lectura y razonamiento sin cambios de clúster;
- build, publicación, SBOM, firma y verificación quedan anclados a unidades posteriores.

## Validaciones

## Validaciones ejecutadas históricamente

La Unidad 00 conserva las evidencias históricas ya registradas:

| Validación | Resultado observado |
|---|---|
| Ubuntu WSL | Ubuntu 24.04.4 LTS (`noble`) |
| MicroK8s | `v1.35.6` instalado desde `1.35/stable` |
| `kubectl get nodes` | Nodo `gmktecg2` en `Ready` |
| Helm | `v3.21.0+ge0878d4` |
| Terraform | `1.15.7` |
| Validación integrada | Completada sin fallos bloqueantes tras instalar componentes |

## Validaciones ejecutadas en el saneamiento documental

- Revisión documental contra `playbooks/student-reference-template.md`.
- Revisión de rutas mediante inspección del repositorio.
- Revisión de `GAP-001` en `project/content-gap-register.md`.
- Revisión de cobertura contra la sección de Unidad 00 de `.work/detail.md`.

## Validaciones no ejecutadas en el saneamiento documental

```text
wsl --status
wsl --list --verbose
platform/environment/windows/check-prerequisites.ps1
microk8s status --wait-ready
kubectl get nodes
helm version
terraform version
bash platform/environment/validation/validate-environment.sh
```

Estas comprobaciones no se ejecutaron de nuevo porque el alcance de fase 4 prohibía validaciones funcionales nuevas.

## Limitaciones conocidas

- Windows 11, virtualización, salida completa de `wsl --status` y `wsl --list --verbose` siguen siendo validaciones por equipo al replicar el laboratorio.
- Los scripts de `platform/environment/` no fueron modificados en el saneamiento documental.
- La referencia de contenedores, imágenes y registros no valida construcción de imágenes, Dockerfile real, registry local ni credenciales de pull.
- `rbac`, tuning avanzado del API Server, `.wslconfig`, `kubectx` y `kubens` no forman parte de la práctica obligatoria de Unidad 00.
- La revisión pedagógica específica del saneamiento documental de Unidad 00 fue aprobada por el usuario el 2026-07-27.

## Continuidad

La Unidad 01 debe reutilizar:

- entorno local registrado en `platform/environment/`;
- `kubectl` como cliente principal;
- `tutorial/00-environment/student-reference.md` para explicar la imagen de `platform-api`;
- `platform/environment/container-images/README.md` como práctica de lectura previa o complementaria;
- las limitaciones registradas sin inferir validaciones nuevas.

No debe crear build de imágenes ni registry local para compensar `GAP-001`; la laguna queda cerrada documentalmente y la práctica de build queda diferida.
