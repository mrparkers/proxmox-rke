expose:
  type: ingress
  tls:
    enabled: true
    certSource: none
  ingress:
    hosts:
      core: harbor.parker.gg
      notary: notary.parker.gg
externalURL: https://harbor.parker.gg

chartmuseum:
  enabled: false

notary:
  enabled: false
