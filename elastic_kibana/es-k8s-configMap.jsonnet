  local kube = import "kube_instrumentation_namespace.jsonnet";
{
  "apiVersion": "v1",
  "kind": "ConfigMap",
  "metadata": {
    "name": "filebeat-config",
    "namespace": kube.metadata.name
  },
  "data": {
    "filebeat.yaml": "name: pod-logs\nfilebeat.prospectors:\n- input_type: log\n  paths:\n    - /var/lib/docker/containers/*/*.log\n  symlinks: true\n  json.keys_under_root: true\n  json.add_error_key: true\n  json.message_key: log\nprocessors:\n- add_cloud_metadata:\n- kubernetes:\n    in_cluster: true\n    namespace: kube-instrumentation\noutput.elasticsearch:\n  hosts: ['es-k8s-logging:9200']\n  username: elastic\n  password: changeme\n"
  }
}