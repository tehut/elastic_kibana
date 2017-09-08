local loadbalancer = import "../components/es-k8s-logging-loadbalancer.jsonnet";
local namespace = "NAMESPACE VALUE";
local appname = "NAME VALUE";
local cpuValue = "CPU VALUE";
local memoryValue = "MEMORY VALUE";
local portValue = "PORT VALUE";
local targetPortValue = "TARGET PORT VALUE";
local functionValue = "FUNCTION VALUE";


local conf = {
metadata:: {
name:: appname,
namespace:: namespace,
labels:: {
    app: "LABEL",
    foo: "LABEL",
},
},
selector::{
    app: appname,
    "function": functionValue
},
port:: portValue,
targetPort: targetPortValue
};

// generate the yaml
local loadbalancerGen() = 

loadbalancer + {
metadata+: {
    name: conf.metadata.name,
    namespace: conf.metadata.namespace
    },
    spec+: {
        ports:[
            {port: conf.port,
            protocol: "TCP",
            targetPort: conf.targetPort
            }
        ],
        selector:{
            app: conf.selector.app,
            "function": conf.selector["function"],
        },
    },
};


loadbalancerGen()

