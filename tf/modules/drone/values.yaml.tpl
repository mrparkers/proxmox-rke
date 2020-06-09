ingress:
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: true
  hosts:
    - ${host}

sourceControl:
  provider: github
  github:
    clientID: ${github_client_id}
    clientSecretValue: ${github_client_secret}

server:
  adminUser: ${admin}
  host: ${host}
  protocol: https
  database:
    driver: postgres
    dataSource: postgres://${postgres_user}:${postgres_password}@${postgres_service}:${postgres_port}/${postgres_database}?sslmode=disable
  kubernetes:
    enabled: false
  logs:
    debug: true
    trace: true
    pretty: true
    color: true
  env:
    DRONE_USER_FILTER: ${users}
    DRONE_JSONNET_ENABLED: "true"
    DRONE_LOGS_TEXT: "true"
    DRONE_LOGS_PRETTY: "true"
    DRONE_LOGS_COLOR: "true"

runner:
  enabled: true

secrets:
  enabled: true

persistence:
  enabled: false
