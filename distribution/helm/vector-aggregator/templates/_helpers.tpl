{{/* vim: set filetype=mustache: */}}

{{/*
Resolve effective service ports to use.
*/}}
{{- define "vector-aggregator.servicePorts" -}}
{{- if .Values.vectorSource.enabled }}
- name: vector
  port: {{ .Values.vectorSource.listenPort }}
  protocol: TCP
  targetPort: {{ .Values.vectorSource.listenPort }}
{{- if (and (eq .Values.service.type "NodePort") (not (empty .Values.vectorSource.nodePort))) }}
  nodePort: {{ .Values.vectorSource.nodePort }}
{{- end }}
{{- end }}
{{- range $key, $value := .Values.service.ports }}
- name: {{ $value.name }}
  port: {{ $value.port }}
  protocol: {{ $value.protocol }}
  targetPort: {{ $value.targetPort}}
{{- if (and (eq $.Values.service.type "NodePort") (not (empty $value.nodePort))) }}
  nodePort: {{ $value.nodePort }}
{{- end }}
{{- end }}
{{- end }}

{{- define "vector-aggregator.hedalessServicePorts" -}}
{{- if .Values.vectorSource.enabled }}
- name: vector
  port: {{ .Values.vectorSource.listenPort }}
  protocol: TCP
  targetPort: {{ .Values.vectorSource.listenPort }}
{{- end }}
{{- range $key, $value := .Values.service.ports }}
- name: {{ $value.name }}
  port: {{ $value.port }}
  protocol: {{ $value.protocol }}
  targetPort: {{ $value.targetPort}}
{{- end }}
{{- end }}

{{/*
Determines whether there are any ports present.
*/}}
{{- define "vector-aggregator.servicePortsPresent" -}}
{{- or .Values.vectorSource.enabled (not (empty .Values.service.ports)) }}
{{- end }}
