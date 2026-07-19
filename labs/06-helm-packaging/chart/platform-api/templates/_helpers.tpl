{{- define "platform-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-api.fullname" -}}
{{- default (include "platform-api.name" .) .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-api.namespace" -}}
{{- .Values.namespace.name | default .Release.Namespace -}}
{{- end -}}

{{- define "platform-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "platform-api.labels" -}}
helm.sh/chart: {{ include "platform-api.chart" . }}
{{ include "platform-api.selectorLabels" . }}
app.kubernetes.io/part-of: k8s-platform-training
app.kubernetes.io/managed-by: {{ .Release.Service }}
training.k8s-platform.io/unit: {{ .Values.training.unit | quote }}
{{- end -}}

{{- define "platform-api.componentLabels" -}}
{{- include "platform-api.labels" .root }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{- define "platform-api.configMapName" -}}
{{- printf "%s-config" (include "platform-api.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-api.secretName" -}}
{{- printf "%s-secret" (include "platform-api.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "platform-api.pvcName" -}}
{{- .Values.persistence.claimName | default (printf "%s-data" (include "platform-api.fullname" .)) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
