local kube_inst = import "../components/kube_instrumentation_namespace.jsonnet";
local configMap = import "../components/es-k8s-configMap.jsonnet";
local deamonSet = import "../components/es-k8s-daemon-set.jsonnet";
local service = import "../components/es-k8s-logging-service.jsonnet";
local loadBalancer = import "../components/es-k8s-logging-loadbalancer.jsonnet";
local statefulSet = import "../components/es-k8s-stateful-set.jsonnet";
local ksonnet = import "../vendor/schema/dev/k.libsonnet";
local itemArray = [kube_inst,configMap,deamonSet,service,loadBalancer,statefulSet];
local es(namespace) = 
    ksonnet.core.v1.list.new([
        {
  "apiVersion": "v1",
  "kind": "ConfigMap",
  "metadata": {
    "name": "filebeat-config",
    "namespace": namespace
  },
  "data": {
    "filebeat.yaml": "name: pod-logs\nfilebeat.prospectors:\n- input_type: log\n  paths:\n    - /var/lib/docker/containers/*/*.log\n  symlinks: true\n  json.keys_under_root: true\n json.add_error_key: true\n  json.message_key: log\nprocessors:\n- add_cloud_metadata:\n- kubernetes:\n    in_cluster: true\n    namespace:"+ namespace + "\noutput.elasticsearch:\n  hosts: ['es-k8s-logging:9200']\n  username: elastic\n  password: changeme\n"
  }
},
{
  "apiVersion": "apps/v1beta1",
  "kind": "Deployment",
  "metadata": {
    "name": "kibana-k8s-logging",
    "namespace": namespace
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
},
{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "es-k8s-logging",
    "namespace": namespace,
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
},
{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "kibana-k8s-logging",
    "namespace": namespace,
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
},
{
  "apiVersion": "extensions/v1beta1",
  "kind": "DaemonSet",
  "metadata": {
    "name": "filebeat-k8s-logging",
    "namespace": namespace,
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
},
{
  "apiVersion": "apps/v1beta1",
  "kind": "StatefulSet",
  "metadata": {
    "name": "es-k8s-logging",
    "namespace": namespace
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
]);

es("dev-tehut")