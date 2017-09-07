{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "es-k8s-logging",
    "namespace": "kube-instrumentation",
    "labels": {
      "app": "elasticsearch",
      "function": "logging"
    }
  },
  "spec": {
    "selector": {
      "app": "elasticsearch",
      "function": "logging"
    },
    "type": "NodePort",
    "ports": [
      {
        "protocol": "TCP",
        "port": 9200,
        "nodePort": 30920
      }
    ]
  }
}