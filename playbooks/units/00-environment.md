# Playbook de la Unidad 00 — Preparación del entorno

## Identificación

### Unidad

```text
00 — Preparación del entorno
```

### Identificador

```text
00-environment
```

### Fase del roadmap

```text
Fase 1 — Plataforma local
```

### Estado del playbook

```text
Aprobado para iniciar la generación de la Unidad 00 una vez cerrado el bootstrap
```

### Propietario lógico

```text
Plataforma local
```

---

# Propósito de la unidad

La Unidad 00 prepara y valida el entorno local sobre el que se desarrollará todo el itinerario.

Su responsabilidad es establecer una plataforma Kubernetes reproducible basada en:

- Windows 11 como host;
- WSL2;
- Ubuntu LTS;
- MicroK8s;
- Helm;
- Terraform.

La unidad debe dejar un entorno verificable, diagnosticable y recuperable, preparado para desplegar la aplicación evolutiva en la Unidad 01.

Esta unidad no debe introducir todavía:

- workloads funcionales del curso;
- la aplicación evolutiva;
- charts Helm de aplicación;
- infraestructura cloud;
- Argo CD;
- Tekton;
- stack de observabilidad;
- controles avanzados de seguridad;
- KEDA.

---

# Resultados de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- verificar que Windows 11, WSL2 y Ubuntu cumplen las precondiciones del laboratorio;
- instalar y configurar MicroK8s de forma reproducible;
- validar el estado del clúster local;
- configurar acceso operativo a Kubernetes;
- instalar y comprobar Helm y Terraform;
- identificar diferencias entre Kubernetes estándar y particularidades de MicroK8s;
- ejecutar procedimientos básicos de diagnóstico;
- repetir o recuperar la preparación del entorno sin depender de pasos implícitos;
- justificar el estado final mediante evidencias verificables.

---

# Alcance

## Incluido

- comprobación de requisitos del host;
- validación de WSL2;
- validación o instalación de Ubuntu LTS;
- preparación básica del entorno Linux;
- instalación de MicroK8s;
- configuración de permisos;
- validación del clúster;
- configuración de acceso mediante `kubectl` como cliente operativo principal;
- habilitación de addons mínimos;
- instalación y validación de Helm;
- instalación y validación de Terraform;
- scripts de comprobación;
- diagnóstico básico;
- procedimiento de reset o recuperación;
- documentación de versiones activas;
- actualización del estado del proyecto.

## Excluido

- despliegue de la aplicación evolutiva;
- creación de namespaces funcionales del curso;
- despliegue de workloads de negocio;
- empaquetado de aplicaciones con Helm;
- uso de Terraform para crear infraestructura cloud;
- GitOps;
- pipelines CI;
- monitorización, logging y tracing;
- políticas avanzadas de seguridad;
- escalado automático;
- AKS;
- EKS.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Primera aplicación evolutiva | Unidad 01 | Requiere entorno local validado |
| Configuración y Secrets de aplicación | Unidad 02 | Depende del primer workload |
| Ingress funcional | Unidad 03 | Depende de Services y aplicación |
| Persistencia | Unidad 04 | Depende de workloads definidos |
| Helm para la aplicación | Unidad 06 | Deben existir manifiestos acumulados |
| Terraform aplicado al laboratorio | Unidad 07 | Primero deben fijarse responsabilidades y artefactos |
| Tekton | Unidad 08 | Requiere aplicación y estrategia de build |
| Argo CD | Unidad 09 | Requiere artefactos declarativos estables |
| Observabilidad | Unidades 11–15 | Requiere una aplicación operativa |
| Seguridad avanzada | Unidades 16–17 | Requiere workloads y automatización |
| KEDA | Unidad 18 | Requiere métricas y aplicación escalable |
| AKS y EKS | Unidades 20–21 | Requieren baseline local consolidado |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. este playbook;
6. `playbooks/unit-template.md`;
7. `playbooks/summary-template.md`;
8. `playbooks/project-state-template.md`;
9. los artefactos existentes en `platform/environment/`, si los hubiera.

## Excepción

No existe `summary.md` de una unidad anterior porque la Unidad 00 es la primera unidad formativa del itinerario.

Esta es la única excepción al requisito de leer el resumen anterior.

---

# Dependencias

## Dependencias documentales

Deben existir y estar revisados:

```text
README.md
project/architecture.md
project/project-state.md
project/roadmap.md
playbooks/master.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
playbooks/units/00-environment.md
```

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| Windows 11 | Disponible | Comprobación documentada en PowerShell |
| Virtualización | Habilitada | Validación mediante herramientas del sistema |
| WSL2 | Disponible o instalable | `wsl --status` |
| Ubuntu LTS | Disponible o instalable | `wsl --list --verbose` |
| Acceso administrativo al host | Disponible cuando sea necesario | Validación manual explícita |
| Acceso a Internet | Disponible para descargas | Prueba documentada |
| Espacio en disco | Suficiente según requisitos definidos | Comprobación documentada |
| Git | Disponible o instalable | `git --version` |

## Dependencias pedagógicas

El alumno debe ser capaz de:

- utilizar una terminal de PowerShell;
- utilizar una shell Linux;
- ejecutar comandos con privilegios cuando se indique;
- interpretar salida básica de comandos;
- trabajar con rutas y archivos;
- comprender conceptos básicos de red y procesos.

No se asume experiencia previa administrando Kubernetes.

## Dependencias del laboratorio

No existen artefactos técnicos previos obligatorios.

El repositorio debe contener el framework de bootstrap completo.

---

# Estado inicial esperado

La unidad parte de un repositorio sin plataforma desplegada por sus propios artefactos.

El estado inicial esperado es:

- Windows 11 disponible como host;
- WSL2 ausente, parcialmente configurado o disponible;
- Ubuntu LTS ausente o disponible;
- MicroK8s no gestionado todavía por el proyecto;
- Helm no gestionado todavía por el proyecto;
- Terraform no gestionado todavía por el proyecto;
- ningún namespace funcional del curso;
- ningún workload;
- ningún laboratorio previo;
- ninguna aplicación evolutiva;
- ningún recurso cloud.

MicroK8s se instalará dentro de Ubuntu sobre WSL2. Los scripts de MicroK8s no deberán intentar crear WSL, instalar una distribución Ubuntu ni ejecutar pasos propios de PowerShell.

La unidad deberá admitir dos situaciones:

1. entorno limpio que requiere instalación;
2. entorno parcialmente preparado que requiere validación y normalización.

No debe asumir que una herramienta está disponible únicamente porque exista en la máquina del alumno.

---

# Validación del estado inicial

La documentación deberá incluir comprobaciones equivalentes a:

## En PowerShell

```powershell
winver
wsl --status
wsl --list --verbose
```

## En Ubuntu sobre WSL2

```bash
uname -a
cat /etc/os-release
git --version
```

La salida exacta dependerá del entorno.

La unidad deberá enseñar a interpretar:

- versión de Windows;
- versión de WSL;
- distribución Linux;
- modo WSL 1 o WSL 2;
- arquitectura;
- disponibilidad de Git;
- errores que bloqueen la instalación.

---

# Artefactos que deben reutilizarse

No existen artefactos técnicos de unidades anteriores.

Deben reutilizarse obligatoriamente:

| Artefacto | Ruta | Uso |
|---|---|---|
| Arquitectura | `project/architecture.md` | Mantener separación entre plataforma y laboratorios |
| Estado | `project/project-state.md` | Registrar únicamente hechos validados |
| Roadmap | `project/roadmap.md` | Limitar el alcance de la unidad |
| Playbook maestro | `playbooks/master.md` | Aplicar reglas globales |
| Plantilla de resumen | `playbooks/summary-template.md` | Generar continuidad |
| Plantilla de estado | `playbooks/project-state-template.md` | Actualizar estado consolidado |

## Reglas de reutilización

- no crear un laboratorio alternativo en `labs/`;
- no crear una aplicación de ejemplo;
- no introducir estructura paralela para scripts;
- no duplicar instrucciones de gobierno;
- mantener todos los artefactos ejecutables de la unidad en `platform/environment/`.

---

# Cambios previstos sobre la solución

## Componentes nuevos

| Componente | Responsabilidad | Ubicación prevista |
|---|---|---|
| Tutorial de la Unidad 00 | Guiar la preparación del entorno | `tutorial/00-environment/README.md` |
| Notas del instructor | Facilitar impartición y diagnóstico | `tutorial/00-environment/instructor-notes.md` |
| Summary | Registrar estado final y continuidad | `tutorial/00-environment/summary.md` |
| Scripts de PowerShell | Validar o preparar el host | `platform/environment/windows/` |
| Scripts de shell | Preparar Ubuntu y herramientas | `platform/environment/linux/` |
| Scripts de MicroK8s | Instalar, configurar y validar el clúster | `platform/environment/microk8s/` |
| Scripts de herramientas | Instalar o validar Helm y Terraform | `platform/environment/tools/` |
| Validación global | Comprobar el entorno completo | `platform/environment/validation/` |
| Documentación operativa | Explicar ejecución de artefactos | `platform/environment/README.md` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar entorno y versiones validadas | Compatible con el framework |
| `.gitignore` | Excluir posibles artefactos locales sensibles o temporales | Sin impacto funcional |

La modificación de `.gitignore` solo se realizará si los artefactos generados lo requieren.

## Componentes retirados

```text
Ninguno
```

---

# Decisiones de diseño de la unidad

## D-00-01 — MicroK8s como distribución local

### Decisión

Utilizar MicroK8s sobre Ubuntu LTS en WSL2.

### Motivo

- coincide con la arquitectura aprobada;
- proporciona una experiencia cercana a un clúster Kubernetes real;
- permite habilitar capacidades progresivamente;
- evita introducir otra distribución local paralela.

### Consecuencias

- deberán documentarse particularidades de MicroK8s;
- los comandos deberán usar `kubectl` como cliente operativo principal;
- `microk8s kubectl` quedará reservado como fallback de diagnóstico cuando `kubectl` no esté aún configurado;
- las capacidades estándar y específicas deberán separarse;
- la portabilidad futura a AKS y EKS deberá mantenerse.

### Alternativas descartadas

- Minikube: no se utilizará como plataforma principal.
- kind: no se utilizará como plataforma principal.
- Docker Desktop Kubernetes: no se utilizará como plataforma principal.
- MicroShift u otras distribuciones: fuera del alcance inicial.

## D-00-02 — Scripts separados por contexto de ejecución

### Decisión

Separar los artefactos según se ejecuten en:

- Windows PowerShell;
- Ubuntu sobre WSL2;
- MicroK8s;
- validación global.

### Motivo

Evitar ambigüedad sobre el shell, los permisos y el sistema donde debe ejecutarse cada comando.

### Consecuencias

- el tutorial deberá señalar cada cambio de contexto;
- los scripts deberán utilizar nombres descriptivos;
- las validaciones deberán indicar el entorno de ejecución.

## D-00-03 — Validación antes de instalación

### Decisión

Todos los procedimientos deberán comprobar primero el estado existente.

### Motivo

La unidad debe funcionar tanto en entornos limpios como parcialmente preparados.

### Consecuencias

- los scripts deberán evitar reinstalaciones innecesarias;
- las versiones observadas deberán registrarse;
- los conflictos deberán diagnosticarse antes de modificar el sistema.

## D-00-04 — Addons mínimos

### Decisión

Habilitar únicamente el addon `dns` como baseline inicial de MicroK8s.

### Motivo

Evitar anticipar networking, observabilidad, almacenamiento u otras capacidades que pertenecen a unidades posteriores.

### Consecuencias

- `dns` permite resolución interna básica de Kubernetes y prepara validaciones mínimas del clúster.
- `hostpath-storage`, `ingress`, `registry`, `metrics-server` y otros addons quedan diferidos hasta que una unidad los requiera explícitamente.
- La lista final de addons habilitados deberá validarse y registrarse en `project/project-state.md`.

No se habilitarán addons únicamente por conveniencia futura.

## D-00-05 — Terraform se instala, pero no gestiona recursos todavía

### Decisión

Instalar y validar Terraform como herramienta corporativa, sin utilizarlo aún para provisionar infraestructura.

### Motivo

La Unidad 00 prepara herramientas. La definición de responsabilidades entre Terraform, Helm y Kubernetes corresponde a unidades posteriores.

### Consecuencias

- no se crearán módulos Terraform;
- no se inicializarán backends;
- no se gestionará MicroK8s mediante Terraform;
- solo se validará la instalación y versión.

## D-00-06 — Helm se instala, pero no se crea un chart

### Decisión

Instalar y validar Helm sin empaquetar todavía la solución.

### Motivo

No existen manifiestos acumulados ni aplicación evolutiva.

### Consecuencias

- no se creará ningún chart;
- no se instalarán releases funcionales;
- la primera utilización formativa de Helm se realizará en la Unidad 06.

## D-00-07 — `kubectl` como cliente operativo principal

### Decisión

Utilizar `kubectl` como cliente operativo principal del curso desde Ubuntu sobre WSL2.

MicroK8s seguirá siendo la distribución Kubernetes local inicial, pero sus comandos específicos se limitarán a instalación, configuración, gestión de addons, diagnóstico y recuperación.

### Motivo

- `kubectl` es el cliente estándar de Kubernetes y prepara mejor la evolución hacia AKS y EKS;
- el alumno trabajará principalmente desde Ubuntu sobre WSL2 como estación Linux de plataforma;
- evita que los procedimientos operativos queden acoplados al wrapper `microk8s kubectl`;
- permite separar claramente Kubernetes estándar de operación específica de MicroK8s.

### Consecuencias

- la Unidad 00 deberá instalar o validar `kubectl`;
- la Unidad 00 deberá configurar un kubeconfig usable por `kubectl`;
- las validaciones operativas principales usarán `kubectl`;
- `microk8s kubectl` podrá usarse como fallback de diagnóstico antes de completar la configuración del cliente estándar;
- los scripts deberán diferenciar entre comandos genéricos de Kubernetes y comandos específicos de MicroK8s.

### Alternativas descartadas

- Usar `microk8s kubectl` como flujo principal: descartado por menor portabilidad pedagógica.
- Crear solo un alias `kubectl='microk8s kubectl'`: permitido como medida temporal de diagnóstico, pero no como contrato principal del curso.

---

# Estructura de entregables

## Tutorial

```text
tutorial/00-environment/README.md
```

Debe incluir:

1. contexto;
2. objetivos;
3. arquitectura del entorno;
4. requisitos;
5. validación de Windows;
6. instalación o validación de WSL2;
7. instalación o validación de Ubuntu LTS;
8. preparación de Ubuntu;
9. instalación y configuración de MicroK8s;
10. configuración de acceso;
11. addons mínimos;
12. instalación de Helm;
13. instalación de Terraform;
14. validación global;
15. diagnóstico;
16. recuperación o reset;
17. estado final;
18. conexión con la Unidad 01.

## Notas del instructor

```text
tutorial/00-environment/instructor-notes.md
```

Debe incluir:

- diferencias frecuentes entre versiones de Windows y WSL;
- problemas de virtualización;
- conflictos de red;
- permisos de MicroK8s;
- reinicio de sesión o shell;
- errores de `snap`;
- comportamiento de systemd en WSL2;
- diferencias entre instalaciones limpias y existentes;
- estrategia para no bloquear al grupo;
- criterios para aceptar el entorno.

## Resumen

```text
tutorial/00-environment/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Artefactos ejecutables

```text
platform/environment/
```

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

siguiendo:

```text
playbooks/project-state-template.md
```

---

# Estructura prevista de artefactos

La estructura final deberá ser equivalente a:

```text
platform/environment/
├── README.md
├── windows/
│   ├── check-prerequisites.ps1
│   └── setup-wsl.ps1
├── linux/
│   ├── check-prerequisites.sh
│   └── prepare-ubuntu.sh
├── microk8s/
│   ├── install.sh
│   ├── configure.sh
│   ├── validate.sh
│   └── reset.sh
├── tools/
│   ├── install-helm.sh
│   ├── install-terraform.sh
│   └── validate-tools.sh
└── validation/
    └── validate-environment.sh
```

Esta estructura es una baseline.

Durante la generación podrá ajustarse cuando:

- mejore claramente la idempotencia;
- evite duplicación;
- permita reutilización;
- mantenga separación por contexto;
- el cambio quede documentado en el summary.

No deben crearse scripts vacíos o placeholders sin comportamiento definido.

---

# Responsabilidad de los artefactos

| Ruta | Responsabilidad |
|---|---|
| `platform/environment/README.md` | Punto de entrada operativo de los scripts |
| `platform/environment/windows/check-prerequisites.ps1` | Validar requisitos de Windows |
| `platform/environment/windows/setup-wsl.ps1` | Instalar o normalizar WSL2 |
| `platform/environment/linux/check-prerequisites.sh` | Validar Ubuntu y dependencias |
| `platform/environment/linux/prepare-ubuntu.sh` | Preparar el entorno Linux |
| `platform/environment/microk8s/install.sh` | Instalar MicroK8s |
| `platform/environment/microk8s/configure.sh` | Configurar permisos y addons aprobados |
| `platform/environment/microk8s/validate.sh` | Validar clúster y API |
| `platform/environment/microk8s/reset.sh` | Recuperar o limpiar el estado de MicroK8s |
| `platform/environment/tools/install-helm.sh` | Instalar Helm |
| `platform/environment/tools/install-terraform.sh` | Instalar Terraform |
| `platform/environment/tools/validate-tools.sh` | Comprobar herramientas y versiones |
| `platform/environment/validation/validate-environment.sh` | Ejecutar validación integrada |

---

# Flujo pedagógico obligatorio

La unidad deberá seguir este orden:

1. explicar la arquitectura Windows → WSL2 → Ubuntu → MicroK8s;
2. validar el host antes de modificarlo;
3. instalar o normalizar WSL2;
4. validar Ubuntu;
5. preparar dependencias Linux;
6. instalar MicroK8s;
7. configurar permisos y acceso;
8. habilitar únicamente addons mínimos;
9. validar el clúster;
10. instalar Helm y Terraform;
11. ejecutar validación global;
12. provocar o analizar al menos un fallo realista;
13. documentar recuperación;
14. registrar versiones y estado final.

Este orden evita diagnosticar errores de Kubernetes causados realmente por una base WSL2 incorrecta.

---

# Procedimientos obligatorios

## Preparación

- comprobar requisitos de Windows;
- confirmar virtualización;
- comprobar versión de WSL;
- comprobar distribución y versión de Ubuntu;
- verificar conectividad;
- verificar espacio disponible;
- identificar instalaciones existentes.

## Implementación

- instalar o actualizar WSL2 cuando proceda;
- instalar o seleccionar Ubuntu LTS;
- preparar paquetes base;
- instalar MicroK8s;
- configurar pertenencia al grupo correspondiente;
- configurar acceso al clúster;
- habilitar addons mínimos;
- instalar Helm;
- instalar Terraform.

## Validación

- comprobar versión de WSL;
- comprobar versión de Ubuntu;
- comprobar estado de MicroK8s;
- consultar nodos;
- consultar namespaces del sistema;
- comprobar DNS o addon equivalente si se habilita;
- comprobar versión de Helm;
- comprobar versión de Terraform;
- ejecutar validación global.

## Diagnóstico

- revisar estado de MicroK8s;
- revisar servicios relevantes;
- revisar eventos;
- comprobar permisos;
- comprobar resolución de nombres;
- comprobar conectividad;
- comprobar conflictos de puertos;
- comprobar comportamiento de systemd;
- generar informe de inspección cuando sea aplicable.

## Recuperación

- reabrir sesión para aplicar grupos;
- reiniciar WSL;
- reiniciar MicroK8s;
- deshabilitar o rehabilitar addons;
- ejecutar reset controlado;
- reinstalar únicamente cuando el diagnóstico lo justifique.

## Limpieza

La unidad deberá distinguir:

- reset de MicroK8s;
- desinstalación de MicroK8s;
- eliminación de Ubuntu;
- desactivación de WSL;
- limpieza de archivos temporales.

Las operaciones destructivas no deberán agruparse en un único comando automático sin confirmación explícita.

---

# Validaciones obligatorias

## Validaciones estáticas

| Validación | Herramienta o comando | Resultado esperado |
|---|---|---|
| Sintaxis PowerShell | Mecanismo disponible en PowerShell | Scripts sin errores de sintaxis |
| Sintaxis Bash | `bash -n <script>` | Código de salida 0 |
| ShellCheck | `shellcheck <script>` cuando esté disponible | Sin errores bloqueantes |
| Rutas documentadas | Revisión del repositorio | Todas las rutas existen |
| Secretos | Revisión y búsqueda | No existen credenciales reales |

## Validaciones funcionales

| Validación | Procedimiento | Resultado esperado |
|---|---|---|
| WSL2 | `wsl --status` | WSL disponible |
| Distribución | `wsl --list --verbose` | Ubuntu ejecutándose como WSL2 |
| Ubuntu | `cat /etc/os-release` | Ubuntu LTS compatible |
| MicroK8s | `microk8s status --wait-ready` | Clúster preparado |
| Nodo | `kubectl get nodes` | Nodo en estado Ready |
| Cliente Kubernetes | `kubectl version --client` | Versión de cliente disponible |
| API Kubernetes | Consulta de recursos | Respuesta satisfactoria |
| Helm | `helm version` | Versión disponible |
| Terraform | `terraform version` | Versión disponible |
| Validación integrada | Script global | Código de salida 0 |

## Validaciones de continuidad

Comprobar que:

- no se ha creado una aplicación;
- no existen workloads funcionales del curso;
- el clúster queda listo para la Unidad 01;
- las versiones están registradas;
- los scripts pueden volver a ejecutarse sin dañar el entorno;
- `project/project-state.md` refleja el estado observado;
- `tutorial/00-environment/summary.md` contiene la evidencia necesaria.

## Validaciones no ejecutables en el entorno de generación

La IA puede generar y revisar estáticamente scripts, pero no debe afirmar que ha validado:

- Windows 11 real;
- virtualización real;
- WSL2 real;
- Ubuntu real;
- MicroK8s real;
- conectividad real;
- permisos reales;
- versiones observadas en el equipo del alumno.

Estas validaciones deberán ejecutarse por el usuario y registrarse con resultados reales.

---

# Escenarios de error obligatorios

| Escenario | Síntoma | Diagnóstico | Recuperación |
|---|---|---|---|
| Virtualización deshabilitada | WSL2 no inicia | Revisar estado de virtualización y requisitos | Habilitar virtualización y reiniciar |
| Distribución en WSL1 | MicroK8s no funciona correctamente | `wsl --list --verbose` | Convertir la distribución a WSL2 |
| Usuario fuera del grupo de MicroK8s | Errores de permisos | Comprobar grupos del usuario | Añadir grupo y reiniciar sesión |
| MicroK8s no alcanza estado ready | `status --wait-ready` falla | Inspección y servicios | Reiniciar, inspeccionar o reset controlado |
| DNS no operativo | Resolución interna falla | Revisar addon y pods del sistema | Reconfigurar addon |
| Snap o systemd no disponibles | Instalación o servicios fallan | Revisar Ubuntu y configuración WSL | Normalizar configuración de Ubuntu |
| Conflicto de puertos | Componentes no levantan | Inspección de puertos y procesos | Liberar o reconfigurar |
| Falta de conectividad | Descargas o pulls fallan | DNS, proxy, firewall y red WSL | Corregir conectividad |
| Terraform o Helm ya instalados | Versiones diferentes | Consultar binario y origen | Conservar, actualizar o normalizar según política |
| Reset destructivo accidental | Pérdida del estado del clúster | Confirmar alcance | Reejecutar instalación y configuración |

---

# Requisitos de seguridad

## Datos sensibles

La unidad no debe requerir credenciales cloud.

No se versionarán:

- contraseñas;
- tokens;
- claves privadas;
- kubeconfigs personales;
- proxies corporativos con credenciales;
- certificados internos;
- configuraciones específicas de una organización.

Los scripts deberán aceptar configuración sensible mediante:

- variables de entorno;
- parámetros;
- archivos locales ignorados;
- placeholders documentados.

## Privilegios

La documentación deberá señalar claramente:

- comandos ejecutados en PowerShell con privilegios administrativos;
- comandos Linux ejecutados con `sudo`;
- operaciones que modifican grupos;
- operaciones que instalan paquetes;
- operaciones que modifican WSL;
- operaciones que reinician servicios o distribuciones.

## Operaciones destructivas

| Operación | Advertencia | Alcance | Recuperación |
|---|---|---|---|
| `microk8s reset` o equivalente | Elimina recursos del clúster | MicroK8s local | Reconfiguración posterior |
| Desinstalación de MicroK8s | Elimina la distribución Kubernetes | Ubuntu local | Reinstalación |
| Eliminación de distribución WSL | Puede eliminar todo el filesystem Linux | Distribución completa | Restauración desde backup o reinstalación |
| Desactivación de WSL | Afecta al entorno Linux | Host Windows | Reactivación y reinicio |

Las operaciones destructivas deberán requerir confirmación explícita o ejecutarse manualmente.

---

# Requisitos de portabilidad

## Kubernetes estándar

La unidad deberá diferenciar como estándar:

- API de Kubernetes;
- recursos consultados;
- estado de nodos;
- namespaces;
- uso operativo de `kubectl`;
- validación del control plane desde el cliente.

## Específico de MicroK8s

- instalación mediante mecanismo propio de Ubuntu;
- comando `microk8s`;
- gestión de addons;
- grupo de usuarios;
- comandos de inspección y reset;
- kubeconfig generado por MicroK8s.

## Específico de AKS

```text
No aplica en esta unidad.
```

Solo podrán añadirse notas comparativas breves sin procedimientos de AKS.

## Específico de EKS

```text
No aplica en esta unidad.
```

Solo podrán añadirse notas comparativas breves sin procedimientos de EKS.

## Estrategia de desacoplamiento

- utilizar manifiestos Kubernetes estándar en unidades posteriores;
- aislar comandos MicroK8s en scripts específicos;
- utilizar `kubectl` como interfaz estable para operaciones Kubernetes;
- evitar propagar rutas internas de MicroK8s;
- documentar la obtención de kubeconfig;
- no utilizar addons de MicroK8s como sustitutos conceptuales de componentes estándar;
- registrar cualquier acoplamiento en el summary.

---

# Restricciones de generación

La IA no debe:

- generar la aplicación evolutiva;
- crear manifiestos de workloads funcionales;
- crear charts Helm;
- crear módulos Terraform;
- desplegar recursos cloud;
- instalar Argo CD;
- instalar Tekton;
- instalar Prometheus, Grafana, Loki o Tempo;
- instrumentar OpenTelemetry;
- instalar KEDA;
- crear contenido de la Unidad 01;
- asumir versiones sin verificarlas;
- afirmar que el entorno fue ejecutado;
- habilitar addons no justificados;
- almacenar configuraciones corporativas sensibles;
- utilizar Docker Desktop como dependencia obligatoria;
- introducir kind o Minikube como plataforma paralela.

La IA sí puede:

- crear scripts idempotentes;
- crear validaciones;
- documentar variantes controladas;
- detectar instalaciones existentes;
- parametrizar versiones;
- crear procedimientos de diagnóstico;
- crear procedimientos de recuperación;
- proponer validaciones manuales;
- actualizar el estado con resultados proporcionados por el usuario.

---

# Criterios de aceptación

La unidad se considerará completada cuando:

- [ ] exista `tutorial/00-environment/README.md`;
- [ ] exista `tutorial/00-environment/instructor-notes.md`;
- [ ] exista `tutorial/00-environment/summary.md`;
- [ ] exista `platform/environment/README.md`;
- [ ] existan scripts de comprobación de Windows;
- [ ] existan scripts de preparación de Ubuntu;
- [ ] existan scripts de instalación, configuración, validación y reset de MicroK8s;
- [ ] existan scripts de instalación o validación de Helm y Terraform;
- [ ] exista una validación integrada;
- [ ] los scripts Bash superen validación de sintaxis;
- [ ] los scripts PowerShell hayan sido revisados o validados;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] no existan secretos reales;
- [ ] las operaciones destructivas estén protegidas;
- [ ] las particularidades de MicroK8s estén separadas de Kubernetes estándar;
- [ ] se hayan documentado validaciones reales a ejecutar;
- [ ] el usuario haya proporcionado o registrado resultados de ejecución;
- [ ] `project/project-state.md` contenga versiones y estado observados;
- [ ] el summary permita iniciar la Unidad 01;
- [ ] no se haya generado contenido fuera de alcance.

## Criterios específicos

- [ ] `wsl --list --verbose` confirma Ubuntu sobre WSL2;
- [ ] `microk8s status --wait-ready` finaliza correctamente;
- [ ] `kubectl get nodes` muestra el nodo Ready;
- [ ] `kubectl version --client` muestra una versión válida;
- [ ] Helm responde con una versión válida;
- [ ] Terraform responde con una versión válida;
- [ ] el script de validación integrada finaliza con éxito;
- [ ] el procedimiento de recuperación ha sido revisado;
- [ ] el estado final no contiene workloads funcionales del curso.

---

# Estado final esperado

## Plataforma

- Windows 11 validado;
- WSL2 operativo;
- Ubuntu LTS operativo;
- MicroK8s instalado y ready;
- acceso Kubernetes configurado mediante `kubectl`;
- addons mínimos habilitados y documentados.

## Herramientas

- Git disponible;
- Helm disponible;
- Terraform disponible;
- versiones registradas.

## Aplicación

```text
No definida y no desplegada.
```

## Automatización

- scripts de preparación disponibles;
- scripts idempotentes o con comportamiento de repetición documentado;
- validación integrada disponible.

## Observabilidad

```text
No incorporada.
```

## Seguridad

- sin credenciales reales;
- privilegios documentados;
- operaciones destructivas protegidas.

## Artefactos principales

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

---

# Información obligatoria para el summary

El `summary.md` deberá destacar:

- versión validada de Windows;
- versión y estado de WSL;
- distribución y versión de Ubuntu;
- versión de MicroK8s;
- versión de Kubernetes;
- addons habilitados;
- método de acceso al clúster;
- versión de `kubectl`;
- versión de Helm;
- versión de Terraform;
- scripts creados;
- comandos de validación ejecutados;
- resultados observados;
- validaciones pendientes;
- problemas encontrados;
- decisiones específicas;
- acoplamientos a MicroK8s;
- limitaciones;
- deuda técnica;
- estado exacto que podrá asumir la Unidad 01.

---

# Impacto esperado en project-state

Al cerrar la unidad, actualizar como mínimo:

- fase actual;
- estado general;
- última unidad completada;
- unidad siguiente;
- estado de artefactos;
- estado del host;
- estado de WSL2;
- estado de Ubuntu;
- estado de MicroK8s;
- versión de Kubernetes;
- addons habilitados;
- herramientas y versiones;
- validaciones globales;
- decisiones específicas que afecten a unidades posteriores;
- riesgos;
- cuestiones abiertas;
- deuda técnica;
- historial de incrementos;
- siguiente incremento permitido.

El siguiente incremento permitido deberá ser la revisión o creación del playbook de la Unidad 01, no la generación directa de su contenido si dicho playbook aún no existe.

---

# Conexión con la siguiente unidad

## Siguiente unidad prevista

```text
01 — Fundamentos operativos y primera aplicación
```

## Capacidades que deja preparadas

- clúster Kubernetes local;
- acceso operativo mediante cliente Kubernetes;
- herramientas base instaladas;
- validaciones del entorno;
- scripts de diagnóstico;
- procedimiento de recuperación;
- versiones consolidadas.

## Elementos que la siguiente unidad deberá reutilizar

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| Entorno local | `platform/environment/` | No reinstalar ni sustituir la plataforma |
| Summary | `tutorial/00-environment/summary.md` | Conocer versiones y estado |
| Project state | `project/project-state.md` | Confirmar entorno disponible |
| MicroK8s | Clúster validado | Desplegar el primer workload |
| kubectl | Cliente Kubernetes configurado | Operar el clúster con comandos estándar |
| Helm | Instalación validada | Disponible, pero no usar hasta que el roadmap lo indique |
| Terraform | Instalación validada | Disponible, pero no usar para recursos todavía |

## Elementos que no deben modificarse todavía

- distribución Kubernetes;
- estructura de `platform/environment/`;
- addons no requeridos por la Unidad 01;
- estrategia de Helm;
- estrategia de Terraform;
- componentes de observabilidad;
- componentes de CI/CD.

---

# Riesgos específicos

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Diferencias entre versiones de WSL | Media | Alto | Detectar versión y documentar variantes |
| Virtualización no disponible | Baja | Alto | Validación temprana y bloqueo explícito |
| Entorno corporativo con proxy | Media | Alto | Parametrizar sin versionar credenciales |
| Cambios en instalación de herramientas | Media | Medio | Fijar métodos y validar versiones |
| Addons de MicroK8s no portables | Media | Medio | Aislar y documentar |
| Scripts destructivos | Baja | Alto | Confirmación y separación explícita |
| Entorno parcialmente configurado | Alta | Medio | Validación antes de instalación |
| Reinicios requeridos | Media | Medio | Señalar puntos de reinicio y reanudación |
| Limitaciones de recursos del host | Media | Medio | Comprobación previa y requisitos mínimos |

---

# Cuestiones abiertas

| Cuestión | Bloqueante | Momento de resolución |
|---|---|---|
| Versiones exactas de Ubuntu, MicroK8s, Helm y Terraform | Sí para cerrar la unidad, no para generar el primer borrador | Durante la generación y validación de la Unidad 00 |
| Addons mínimos exactos | Resuelta para el primer incremento: `dns` | Reabrir solo si una validación técnica lo exige |
| Política de alias o instalación de `kubectl` independiente | Resuelta: `kubectl` como cliente principal | Reabrir solo si la instalación real lo exige |
| Uso de systemd en la versión objetivo de WSL2 | No | Durante validación del entorno |
| Requisitos mínimos de CPU, memoria y disco | Sí para publicar el tutorial | Durante la generación de la Unidad 00 |
| Necesidad de soporte para proxy corporativo | No | Cuando el entorno objetivo lo requiera |
| Uso de `.gitkeep` para directorios vacíos | No | Al cerrar el bootstrap o crear la estructura |

---

# Checklist de revisión del playbook

- [x] la unidad existe en `project/roadmap.md`;
- [x] el identificador y las rutas son consistentes;
- [x] el alcance no invade unidades posteriores;
- [x] las dependencias son verificables;
- [x] los artefactos previos están identificados;
- [x] los entregables están definidos;
- [x] las validaciones son suficientes;
- [x] los escenarios de error son realistas;
- [x] las restricciones de seguridad están declaradas;
- [x] la portabilidad está considerada;
- [x] los criterios de aceptación son objetivos;
- [x] el estado final está definido;
- [x] la conexión con la siguiente unidad es explícita;
- [x] no contradice arquitectura, estado, roadmap ni playbook maestro.

---

# Metadatos de mantenimiento

## Fecha de creación

```text
2026-07-17
```

## Última revisión

```text
2026-07-17
```

## Motivo de la última revisión

Definición de `kubectl` como cliente operativo principal, concreción del addon inicial `dns` y aclaración de que MicroK8s se instala dentro de Ubuntu sobre WSL2.

## Documentos afectados por cambios futuros

- `project/architecture.md`, si cambia la plataforma local;
- `project/roadmap.md`, si cambia el alcance o secuencia;
- `project/project-state.md`, al iniciar o cerrar la unidad;
- `playbooks/master.md`, si cambia el proceso global;
- `tutorial/00-environment/summary.md`, al completar la unidad.
