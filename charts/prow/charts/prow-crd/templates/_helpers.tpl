{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "prow-crd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "prow-crd.labels" -}}
helm.sh/chart: {{ include "prow-crd.chart" . }}
{{ include "prow-crd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "prow-crd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "prow-crd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Chart.Name }}
{{- end }}