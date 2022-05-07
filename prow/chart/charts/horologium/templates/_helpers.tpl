{{/*
Expand the name of the chart.
*/}}
{{- define "horologium.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "horologium.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "horologium.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "horologium.labels" -}}
helm.sh/chart: {{ include "horologium.chart" . }}
{{ include "horologium.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "horologium.selectorLabels" -}}
app.kubernetes.io/name: {{ include "horologium.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Chart.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "horologium.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "horologium.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the role
*/}}
{{- define "horologium.roleName" -}}
{{- if .Values.serviceAccount.roleBinding.create }}
{{- default (include "horologium.fullname" .) .Values.serviceAccount.roleBinding.role }}
{{- end }}
{{- end }}

{{/*
Create the name of the role binding
*/}}
{{- define "horologium.roleBindingName" -}}
{{- if .Values.serviceAccount.roleBinding.create }}
{{- default (include "horologium.fullname" .) .Values.serviceAccount.roleBinding.name }}
{{- end }}
{{- end }}