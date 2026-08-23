# 🔭 Cloud-Native Observability Stack

Полноценный контур наблюдаемости (Logs, Metrics, Traces) для микросервисной архитектуры [Google Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo), развернутый как код (IaC) в Kubernetes.

## 🏗 Архитектура

В основе проекта лежит концепция **Unified Collector**. Приложение не знает о конечных базах данных — оно отправляет всю телеметрию в единый шлюз на базе Grafana Alloy. 

*   **Логи:** Собираются Alloy с подов Kubernetes и отправляются в **Loki**.
*   **Трейсы:** Приложение генерирует распределенные трейсы через OpenTelemetry SDK, которые Alloy маршрутизирует в базу данных **Tempo**.
*   **Метрики (Магия):** Из-за отсутствия нативных метрик в приложении, используется коннектор `spanmetrics` внутри Alloy. Он анализирует пролетающие трейсы на лету и генерирует RED-метрики (RPS, Errors, Latency), которые затем пишутся в **Prometheus**.
*   **Визуализация:** **Grafana** выступает единым окном для анализа логов, метрик и Waterfall-диаграмм запросов.

## ✨ Ключевые особенности (Highlights)
*   **Trace-to-Metrics Pipeline:** Динамическая генерация метрик из трейсов.
*   **Infrastructure as Code:** Вся инфраструктура управляется через Helm и автоматизирована с помощью `Makefile`.
*   **Zero-code Instrumentation:** Переопределение хардкод-переменных приложения (`COLLECTOR_SERVICE_ADDR`) на уровне манифестов Kubernetes без вмешательства в исходный код микросервисов.

## 🚀 Быстрый старт

**Требования:**
*   Kubernetes (Minikube/Kind/OKD)
*   Helm 3+
*   Make

**Установка:**
```bash
# 1. Клонируем репозиторий
git clone <URL_твоего_репозитория>
cd observability

# 2. Разворачиваем базы данных и коллектор
make loki-deploy
make tempo-deploy
make prometheus-deploy
make alloy-deploy

# 3. Применяем конфигурацию к приложению
kubectl set env deployment --all -n demo-app COLLECTOR_SERVICE_ADDR="alloy-otlp.monitoring.svc.cluster.local:4317"
```

📸 Галерея

[RED Metrics Dashboard: /docs/images/dashboard.jpg](./docs/images/dashboard.jpg)

[Trace Waterfall: /docs/images/waterfall.jpg](./docs/images/waterfall.jpg)
