CLUSTER_NAME=obs
NAMESPACE=microservices-demo

# Развертывание демо-приложения через Helm
app-deploy:
	helm upgrade --install onlineboutique oci://us-docker.pkg.dev/online-boutique-ci/charts/onlineboutique \
		--namespace $(NAMESPACE) --create-namespace

# Проброс порта для проверки работы магазина
app-port-forward:
	kubectl port-forward svc/frontend -n $(NAMESPACE) 8080:80

# Полная очистка приложения (пригодится для тестов)
app-clean:
	helm uninstall onlineboutique -n $(NAMESPACE)
	kubectl delete namespace $(NAMESPACE)