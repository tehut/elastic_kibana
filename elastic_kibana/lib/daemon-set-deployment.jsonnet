local daemon = import "../components/es-k8s-daemon-set.jsonnet";
local namespace = "NAMESPACE VALUE";
local appname = "NAME VALUE";
local cpuValue = "CPU VALUE";
local memoryValue = "MEMORY VALUE";



  local conf = {
  metadata:: {
    name:: appname,
    namespace:: namespace,
    labels:: {
        app: "LABEL",
        foo: "LABEL",
    },
  },
    resources::{
    limits::{
        cpu: cpuValue,
        memory: memoryValue
       },
    }
  };
 
// generate the yaml
local daemonGen() = 

daemon + {
  metadata+: {
    name: conf.metadata.name,
    namespace: conf.metadata.namespace,
    labels: conf.metadata.labels
  },
  spec+: {
    containers+: {
            resources:{
                limits: conf.resources.limits
            },
} ,
  }
};

daemonGen()

