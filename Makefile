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


# --- Управление мониторингом ---

prometheus-repo:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

prometheus-deploy: prometheus-repo
	helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  		--namespace monitoring --create-namespace \
  		-f manifests/prometheus/values.yaml

prometheus-port-forward:
	kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80


# --- Логи и Alloy ---

grafana-repo:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

loki-deploy: grafana-repo
	helm upgrade --install loki grafana/loki \
		--namespace monitoring \
		-f manifests/loki/values.yaml

alloy-deploy: grafana-repo
	helm upgrade --install alloy grafana/alloy \
		--namespace monitoring \
		-f manifests/alloy/values.yaml


# --- Tempo ---

tempo-deploy: grafana-repo
	helm upgrade --install tempo grafana/tempo \
		--namespace monitoring \
		-f manifests/tempo/values.yaml
		