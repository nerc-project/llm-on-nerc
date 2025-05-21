#!/bin/sh
exec /usr/bin/oauth-proxy \
  --https-address=:8443 \
  --provider=openshift \
  --openshift-service-account=mlflow-setup \
  --upstream=http://localhost:5000 \
  --tls-cert=/etc/tls/private/tls.crt \
  --tls-key=/etc/tls/private/tls.key \
  --cookie-secret=SECRET \
  --openshift-sar="{\"namespace\":\"$OPENSHIFT_NAMESPACE\",\"resource\":\"services\",\"resourceName\":\"mlflow-service\",\"verb\":\"get\"}"
