CLUSTER_NAME=obs
NAMESPACE=demo-app

app-deploy:
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml -n $(NAMESPACE)

# Проброс порта
app-port-forward:
	kubectl port-forward svc/frontend -n $(NAMESPACE) 8080:80

# Полная очистка
app-clean:
	kubectl delete -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml -n $(NAMESPACE)
	kubectl delete namespace $(NAMESPACE)
