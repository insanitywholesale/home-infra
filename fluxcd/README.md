# FluxCD

## Bootstrap

Run the following spaghetti:
```bash
kubectl create ns flux-system; cat ~/age.agekey | kubectl -n flux-system create secret generic sops-age --from-file=age.agekey=/dev/stdin; export GITLAB_TOKEN=$(pass gitlab-all-access-pat); flux bootstrap gitlab --owner=insanitywholesale --repository=infra --visibility=public --personal --branch=master --path=fluxcd/homecluster/ --token-auth=false --read-write-key=true
```
