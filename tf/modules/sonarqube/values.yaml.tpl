ingress:
  annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
  enabled: true
  hosts:
    - name: sonar.parker.gg
      path: /

account:
  adminPassword: ${admin_password}
