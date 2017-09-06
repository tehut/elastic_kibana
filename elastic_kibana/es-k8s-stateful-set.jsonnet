{
  "apiVersion": "apps/v1beta1",
  "kind": "StatefulSet",
  "metadata": {
    "name": "es-k8s-logging",
    "namespace": "kube-instrumentation"
  },
  "spec": {
    "serviceName": "elasticsearch",
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "elasticsearch",
          "function": "logging"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "elasticsearch",
            "image": "docker.elastic.co/elasticsearch/elasticsearch:5.5.1",
            "volumeMounts": [
              {
                "mountPath": "/data",
                "name": "elasticsearch-storage"
              }
            ]
          }
        ],
        "volumes": [
          {
            "name": "elasticsearch-storage",
            "persistentVolumeClaim": {
              "claimName": "elasticsearch-storage"
            },
            "command": [
              "bin/elasticsearch"
            ],
            "args": [
              "-Ehttp.host=0.0.0.0",
              "-Etransport.host=127.0.0.1",
              "-Ecluster.name=kubernetes",
              "-Ebootstrap.memory_lock=true"
            ],
            "env": [
              {
                "name": "ES_JAVA_OPTS",
                "value": "-Xms512m -Xmx512m"
              }
            ],
            "ports": [
              {
                "containerPort": 9200
              }
            ]
          }
        ],
        "initContainers": [
          {
            "name": "volume-mount-hack",
            "image": "busybox",
            "command": [
              "sh",
              "-c",
              "chown -R 1000:100 /usr/share/elasticsearch/data"
            ],
            "volumeMounts": [
              {
                "name": "data",
                "mountPath": "/usr/share/elasticsearch/data"
              }
            ]
          }
        ]
      },
      "volumeClaimTemplates": [
        {
          "metadata": {
            "name": "elasticsearch"
          },
          "spec": {
            "accessModes": [
              "ReadWriteOnce"
            ],
            "resources": {
              "requests": {
                "storage": "5Gi"
              }
            }
          }
        }
      ]
    }
  }
}