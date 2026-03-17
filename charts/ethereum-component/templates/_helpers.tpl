{{- define "ethereum-component.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ethereum-component.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "ethereum-component.labels" -}}
app.kubernetes.io/name: {{ include "ethereum-component.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{- define "ethereum-component.componentLabels" -}}
{{ include "ethereum-component.labels" . }}
app.kubernetes.io/component: {{ include "ethereum-component.name" .context }}
{{- end -}}

{{- define "ethereum-component.headlessServiceName" -}}
{{ include "ethereum-component.fullname" . }}
{{- end -}}

{{- define "ethereum-component.metricsServiceName" -}}
{{ printf "%s-metrics" (include "ethereum-component.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}
