local configMap = import "../components/es-k8s-configMap.jsonnet";
local namespace = "hootlet";
local appname = "NAMENAME";

  local conf = {
  metadata:: {
    name:: appname,
    namespace:: namespace
  },
  data:: {
    "filebeat.yaml": "name: pod-logs\nfilebeat.prospectors:\n- input_type: log\n  paths:\n    - /var/lib/docker/containers/*/*.log\n  symlinks: true\n  json.keys_under_root: true\n  json.add_error_key: true\n  json.message_key: log\nprocessors:\n- add_cloud_metadata:\n- kubernetes:\n    in_cluster: true\n    namespace:"+  namespace +"\noutput.elasticsearch:\n  hosts: ['es-k8s-logging:9200']\n  username: elastic\n  password: changeme\n"
  }
};
// generate the yaml
local configMapGen() = 

configMap + {
  data: conf.data,
  metadata+: {
    name: conf.metadata.name,
    namespace: conf.metadata.namespace
  },
  };


configMapGen()

