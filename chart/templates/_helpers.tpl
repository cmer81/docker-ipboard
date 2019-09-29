{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ipboard.name" }}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "ipboard.fullname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a name shared accross all apps in namespace.
We truncate at 63 chars because some Kubernetes name fields are limited to this
(by the DNS naming spec).
*/}}
{{- define "ipboard.sharedname" }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Namespace $name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Calculate ipboard certificate
*/}}
{{- define "ipboard.ipboard-certificate" }}
{{- if (not (empty .Values.ingress.ipboard.certificate)) }}
{{- printf .Values.ingress.ipboard.certificate }}
{{- else }}
{{- printf "%s-ipboard-letsencrypt" (include "ipboard.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Calculate ipboard hostname
*/}}
{{- define "ipboard.ipboard-hostname" }}
{{- if (and .Values.config.ipboard.hostname (not (empty .Values.config.ipboard.hostname))) }}
{{- printf .Values.config.ipboard.hostname }}
{{- else }}
{{- if .Values.ingress.ipboard.enabled }}
{{- printf .Values.ingress.ipboard.hostname }}
{{- else }}
{{- printf "%s-ipboard" (include "ipboard.fullname" .) }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Calculate ipboard base url
*/}}
{{- define "ipboard.ipboard-base-url" }}
{{- if (and .Values.config.ipboard.baseUrl (not (empty .Values.config.ipboard.baseUrl))) }}
{{- printf .Values.config.ipboard.baseUrl }}
{{- else }}
{{- if .Values.ingress.ipboard.enabled }}
{{- $hostname := ((empty (include "ipboard.ipboard-hostname" .)) | ternary .Values.ingress.ipboard.hostname (include "ipboard.ipboard-hostname" .)) }}
{{- $path := (eq .Values.ingress.ipboard.path "/" | ternary "" .Values.ingress.ipboard.path) }}
{{- $protocol := (.Values.ingress.ipboard.tls | ternary "https" "http") }}
{{- printf "%s://%s%s" $protocol $hostname $path }}
{{- else }}
{{- printf "http://%s" (include "ipboard.ipboard-hostname" .) }}
{{- end }}
{{- end }}
{{- end }}
