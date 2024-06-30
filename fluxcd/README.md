# FluxCD

## Bootstrap

Run the following commands:
```bash
$ export GITLAB_TOKEN=$(pass gitlab-all-access-pat)
$ flux bootstrap gitlab --owner=insanitywholesale --repository=infra --private=false --personal --branch=master --path=fluxcd/cluster01/ --deploy-token-auth
```
