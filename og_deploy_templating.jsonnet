{
	"apiVersion": "extensions/v1beta1",
	"kind": "Deployment",
    local appName = "hootlet",
	"metadata": {
		"labels": {
			"run": appName
		},
		"name": $.metadata.labels.run
	},
	"spec": {
		"replicas": 1,
		"selector": 5 + self.replicas,
		"template": {
			"metadata": {
				"labels": {
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
						"terminationMessagePolicy": "File"
					}
				],
				"dnsPolicy": "ClusterFirst",
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