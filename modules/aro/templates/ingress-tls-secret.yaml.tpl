apiVersion: v1
kind: Secret
metadata:
  name: ${name}
  namespace: ${namespace}
type: kubernetes.io/tls
data:
  tls.crt: ${base64encode(crt)}
  tls.key: ${base64encode(key)}