local ksonnet = import "../vendor/schema/dev/k.libsonnet";
local config = import "configMap-deployment.jsonnet";
local daemon = import "daemon-set-deployment.jsonnet";



ksonnet.core.v1.list.new([config, daemon])

