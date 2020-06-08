grafana:
  ingress:
    enabled: true
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    tls:
    - hosts:
      - ${grafana_hostname}
    hosts:
    - ${grafana_hostname}
  grafana.ini:
    auth.anonymous:
      enabled: false
  image:
    repository: grafana/grafana
    tag: 7.0.3
  resources:
    limits:
      cpu: 300m
      memory: 256Mi
    requests:
      cpu: 100m
      memory: 128Mi

kube-state-metrics:
  resources:
    limits:
      cpu: 200m
      memory: 200Mi
    requests:
      cpu: 10m
      memory: 50Mi
  service:
    annotations:
      prometheus.io/scrape: "false"

kubeEtcd:
  enabled: false

kubeScheduler:
  enabled: false

kubeProxy:
  enabled: false

prometheus-node-exporter:
  service:
    annotations:
      prometheus.io/scrape: "false"
  resources:
    requests:
      cpu: 10m
      memory: 15Mi
    limits:
      cpu: 500m
      memory: 100Mi

prometheusOperator:
  resources:
    limits:
      cpu: 200m
      memory: 200Mi
    requests:
      cpu: 100m
      memory: 100Mi
  admissionWebhooks:
    enabled: false
  tlsProxy:
    enabled: false

prometheus:
  prometheusSpec:
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: ${storage_class}
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 50Gi
    resources:
      requests:
        cpu: 500m
        memory: 2Gi
      limits:
        cpu: "1"
        memory: 4Gi

alertmanager:
  enabled: false
