{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "whois-rest.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "whois-rest.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "whois-rest.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "whois-rest.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "whois-rest.fullname" .) }}
{{- end -}}

{{- define "whois-rest.rootCAIssuer" -}}
{{ printf "%s-ca" (include "whois-rest.fullname" .) }}
{{- end -}}

{{- define "whois-rest.rootCACertificate" -}}
{{ printf "%s-ca" (include "whois-rest.fullname" .) }}
{{- end -}}

{{- define "whois-rest.servingCertificate" -}}
{{ printf "%s-webhook-tls" (include "whois-rest.fullname" .) }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "whois-rest.labels" -}}
helm.sh/chart: {{ include "whois-rest.chart" . }}
{{ include "whois-rest.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "whois-rest.selectorLabels" -}}
app.kubernetes.io/name: {{ include "whois-rest.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}