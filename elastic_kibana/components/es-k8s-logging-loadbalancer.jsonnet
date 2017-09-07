{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "kibana-k8s-logging",
    "namespace": "kube-instrumentation",
    "labels": {
      "app": "kibana",
      "function": "logging"
    }
  },
  "spec": {
    "selector": {
      "app": "kibana",
      "function": "logging"
    },
    "type": "LoadBalancer",
    "ports": [
      {
        "protocol": "TCP",
        "port": 80,
        "targetPort": 5601
      }
    ]
  }
}