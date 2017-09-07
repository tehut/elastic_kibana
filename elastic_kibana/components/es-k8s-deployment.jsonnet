{
  "apiVersion": "apps/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "kibana-k8s-logging",
    "namespace": "kube-instrumentation"
  },
  "spec": {
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "kibana",
          "function": "logging"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "kibana",
            "image": "docker.elastic.co/kibana/kibana:5.5.1",
            "env": [
              {
                "name": "ELASTICSEARCH_URL",
                "value": "http://es-k8s-logging:9200"
              }
            ],
            "ports": [
              {
                "containerPort": 5601
              }
            ]
          }
        ]
      }
    }
  }
}