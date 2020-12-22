{{/* vim: set filetype=mustache: */}}

{{/*
Serialize the passed Vector component configuration bits as TOML.
*/}}
{{- define "libvector.vectorComponentConfig" -}}
{{- $componentGroup := index . 0 -}}
{{- $componentId := index . 1 -}}
{{- $value := index . 2 -}}

{{- $rawConfig := $value.rawConfig -}}
{{- $value = unset $value "rawConfig" -}}

{{- $toml := toToml (dict $componentGroup (dict $componentId $value)) -}}
{{- $toml -}}

{{- with $rawConfig -}}
  {{- printf "[%s.%s]" $componentGroup $componentId | nindent 2 -}}
    {{- $rawConfig | nindent 4 -}}
{{- end }}
{{- end }}

{{/*
Serialize the passed Vector source configuration bits as TOML.
*/}}
{{- define "libvector.vectorSourceConfig" -}}
{{- $componentId := index . 0 -}}
{{- $value := index . 1 -}}
{{- tuple "sources" $componentId $value | include "libvector.vectorComponentConfig" -}}
{{- end }}

{{/*
Serialize the passed Vector transform configuration bits as TOML.
*/}}
{{- define "libvector.vectorTransformConfig" -}}
{{- $componentId := index . 0 -}}
{{- $value := index . 1 -}}
{{- tuple "transforms" $componentId $value | include "libvector.vectorComponentConfig" -}}
{{- end }}

{{/*
Serialize the passed Vector sink configuration bits as TOML.
*/}}
{{- define "libvector.vectorSinkConfig" -}}
{{- $componentId := index . 0 -}}
{{- $value := index . 1 -}}
{{- tuple "sinks" $componentId $value | include "libvector.vectorComponentConfig" -}}
{{- end }}

{{/*
Serialize the passed Vector topology configuration bits as TOML.
*/}}
{{- define "libvector.vectorTopology" -}}
{{- range $componentId, $value := .sources }}
{{- tuple $componentId $value | include "libvector.vectorSourceConfig" | nindent 0 -}}
{{- end }}

{{- range $componentId, $value := .transforms }}
{{- tuple $componentId $value | include "libvector.vectorTransformConfig" | nindent 0 -}}
{{- end }}

{{- range $componentId, $value := .sinks }}
{{- tuple $componentId $value | include "libvector.vectorSinkConfig" | nindent 0 -}}
{{- end }}
{{- end }}
