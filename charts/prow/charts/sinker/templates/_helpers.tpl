{{/*
Expand the name of the chart.
*/}}
{{- define "sinker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sinker.fullname" -}}
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
{{- define "sinker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sinker.labels" -}}
helm.sh/chart: {{ include "sinker.chart" . }}
{{ include "sinker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sinker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sinker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Chart.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sinker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sinker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the role
*/}}
{{- define "sinker.roleName" -}}
{{- if .Values.serviceAccount.roleBinding.create }}
{{- default (include "sinker.fullname" .) .Values.serviceAccount.roleBinding.role }}
{{- end }}
{{- end }}

{{/*
Create the name of the role binding
*/}}
{{- define "sinker.roleBindingName" -}}
{{- if .Values.serviceAccount.roleBinding.create }}
{{- default (include "sinker.fullname" .) .Values.serviceAccount.roleBinding.name }}
{{- end }}
{{- end }}