artifactory:
  nginx:
    enabled: false
  ingress:
    enabled: true
    annotations:
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/proxy-body-size: 10g
    hosts:
      - jcr.parker.gg
  artifactory:
    annotations:
      foo: "bar"
    admin:
      ip: "*"
      username: "admin"
      password: "${admin_password}"
  postgresql:
    postgresqlPassword: "${postgres_password}"
