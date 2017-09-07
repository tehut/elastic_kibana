{
  "apiVersion": "extensions/v1beta1",
  "kind": "DaemonSet",
  "metadata": {
    "name": "filebeat-k8s-logging",
    "namespace": "kube-instrumentation",
    "labels": {
      "app": "filebeat",
      "function": "logging"
    }
  },
  "spec": {
    "template": {
      "metadata": {
        "labels": {
          "app": "filebeat",
          "function": "logging"
        },
        "name": "filebeat"
      },
      "spec": {
        "containers": [
          {
            "name": "filebeat",
            "image": "docker.elastic.co/beats/filebeat:6.0.0-alpha2",
            "command": [
              "filebeat"
            ],
            "args": [
              "-e",
              "-c",
              "/etc/filebeat/filebeat.yaml"
            ],
            "resources": {
              "limits": {
                "cpu": "50m",
                "memory": "50Mi"
              }
            },
            "securityContext": {
              "privileged": true,
              "runAsUser": 0
            },
            "volumeMounts": [
              {
                "name": "varlog",
                "mountPath": "/var/log/containers",
                "readOnly": true
              },
              {
                "name": "varlogpods",
                "mountPath": "/var/log/pods",
                "readOnly": true
              },
              {
                "name": "varlibdockercontainers",
                "mountPath": "/var/lib/docker/containers",
                "readOnly": true
              },
              {
                "name": "config-volume",
                "mountPath": "/etc/filebeat"
              }
            ]
          }
        ],
        "terminationGracePeriodSeconds": 30,
        "volumes": [
          {
            "name": "varlog",
            "hostPath": {
              "path": "/var/log/containers"
            }
          },
          {
            "name": "varlogpods",
            "hostPath": {
              "path": "/var/log/pods"
            }
          },
          {
            "name": "varlibdockercontainers",
            "hostPath": {
              "path": "/var/lib/docker/containers/"
            }
          },
          {
            "name": "config-volume",
            "configMap": {
              "name": "filebeat-config"
            }
          }
        ]
      }
    }
  }
}