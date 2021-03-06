{local function1(arg) = {appName : arg},
cow:function1(arg="duck"),

	"apiVersion": "extensions/v1beta1",
	"kind": "Deployment",
    local appName = "hootlet",
	"metadata": {
		"labels": {
			"run": appName,
            foo: [1, 2, 4],
            "others":[x  for x in $.status.conditions],
		},
		"name": $.metadata.labels.run
	},
	"spec": {
		replicas: 1,
        "best label":"ever",
		"selector": 5 + self.replicas,
		"template": {
			"metadata": {
				"labels": {
                    [$.spec["best label"]]: "I can count "
                     + $.spec.selector * 2 + " reasons to poo",
					"run": appName
				}
			},
			"spec": {
				"containers": [
					{
						"image": "tehut/hootlet:latest",
						"imagePullPolicy": self.image,
						"name": appName,
						"resources": {},
						"terminationMessagePath": "/dev/termination-log",
						"terminationMessagePolicy": "File",
                        [$.spec.template.metadata.labels.run]: "file"
					}
				],
				"dnsPolicy": "ClusterFirst",
                fmt1: "dnsPolicy %s" % [self.dnsPolicy],
				"restartPolicy": "Always",
				"schedulerName": "default-scheduler",
				"securityContext": {},
				"terminationGracePeriodSeconds": 30
			}
		}
	},
	"status": {
		"availableReplicas": 1,
		"conditions": [
			{
				"lastTransitionTime": "2017-08-15T21:21:49.000Z",
				"lastUpdateTime": "2017-08-15T21:21:49.000Z",
				"message": "Deployment has minimum availability.",
				"reason": "MinimumReplicasAvailable",
				"status": "True",
				"type": "Available"
			}
		],
		"observedGeneration": 1,
		"readyReplicas": 1,
		"replicas": 1,
		"updatedReplicas": 1
	}
}