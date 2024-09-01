#!/bin/sh

# Commands to re-create everything

#export GITLAB_TOKEN=$(pass gitlab-all-access-pat)
#flux bootstrap gitlab \
#	--owner=insanitywholesale \
#	--repository=infra \
#	--private=false \
#	--personal \
#	--branch=master \
#	--token-auth=false \
#	--read-write-key=true \
#	--path=fluxcd/cluster01

mkdir -p fluxcd/cluster01/core/metallb/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p fluxcd/cluster01/core/metallb/config  # For things other than values of the upstream chart

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/core/metallb/base/kustomization.yaml

flux create source helm metallb \
	--interval=10m \
	--url=https://metallb.github.io/metallb \
	--export > fluxcd/cluster01/core/metallb/base/helmrepository.yaml

flux create helmrelease metallb \
	--interval=10m \
	--release-name metallb \
	--target-namespace metallb-system \
	--create-target-namespace \
	--source=HelmRepository/metallb \
	--chart=metallb \
	--chart-version="0.14.8" \
	--values=fluxcd/cluster01/core/metallb/base/metallb-values.yml \
	--export > fluxcd/cluster01/core/metallb/base/helmrelease.yaml

flux create kustomization metallb-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/core/metallb/kustomization-fluxCRD.yaml

flux create kustomization metallb-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/config \
	--depends-on metallb-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export >> fluxcd/cluster01/core/metallb/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/core/cert-manager/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p fluxcd/cluster01/core/cert-manager/config  # For things other than values of the upstream chart

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/core/cert-manager/base/kustomization.yaml

flux create source helm cert-manager \
	--interval=10m \
	--url=https://charts.jetstack.io \
	--export > fluxcd/cluster01/core/cert-manager/base/helmrepository.yaml

flux create helmrelease cert-manager \
	--interval=10m \
	--release-name cert-manager \
	--target-namespace cert-manager \
	--create-target-namespace \
	--source=HelmRepository/cert-manager \
	--chart=cert-manager \
	--chart-version="v1.15.3" \
	--values=fluxcd/cluster01/core/cert-manager/base/cert-manager-values.yml \
	--export > fluxcd/cluster01/core/cert-manager/base/helmrelease.yaml

flux create kustomization cert-manager-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/cert-manager/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/core/cert-manager/kustomization-fluxCRD.yaml

flux create kustomization cert-manager-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/cert-manager/config \
	--depends-on cert-manager-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export >> fluxcd/cluster01/core/cert-manager/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/core/ingress-nginx/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/core/ingress-nginx/base/kustomization.yaml

flux create source helm ingress-nginx \
	--interval=10m \
	--url=https://kubernetes.github.io/ingress-nginx \
	--export > fluxcd/cluster01/core/ingress-nginx/base/helmrepository.yaml

flux create helmrelease ingress-nginx \
	--interval=10m \
	--release-name ingress-nginx \
	--target-namespace ingress-nginx \
	--create-target-namespace \
	--source=HelmRepository/ingress-nginx \
	--chart=ingress-nginx \
	--chart-version="4.11.1" \
	--values=fluxcd/cluster01/core/ingress-nginx/base/ingress-nginx-values.yml \
	--export > fluxcd/cluster01/core/ingress-nginx/base/helmrelease.yaml

flux create kustomization ingress-nginx-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/ingress-nginx/base \
	--depends-on metallb-config \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/core/ingress-nginx/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/core/external-dns/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/core/external-dns/base/kustomization.yaml

flux create source helm external-dns \
	--interval=10m \
	--url=https://kubernetes-sigs.github.io/external-dns \
	--export > fluxcd/cluster01/core/external-dns/base/helmrepository.yaml

flux create helmrelease external-dns \
	--interval=10m \
	--release-name external-dns \
	--target-namespace external-dns\
	--create-target-namespace \
	--source=HelmRepository/external-dns \
	--chart=external-dns \
	--chart-version="1.14.5" \
	--values=fluxcd/cluster01/core/external-dns/base/external-dns-values.yml \
	--export > fluxcd/cluster01/core/external-dns/base/helmrelease.yaml

flux create kustomization external-dns-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/external-dns/base \
	--depends-on "metallb-base,ingress-nginx-base" \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/core/external-dns/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/apps/lister/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/apps/lister/base/kustomization.yaml

flux create source helm lister \
	--interval=10m \
	--url=https://gitlab.com/api/v4/projects/27255221/packages/helm/stable \
	--export > fluxcd/cluster01/apps/lister/base/helmrepository.yaml

flux create helmrelease lister \
	--interval=10m \
	--release-name lister \
	--target-namespace lister \
	--create-target-namespace \
	--source=HelmRepository/lister \
	--chart=lister \
	--chart-version="0.2.2" \
	--values=fluxcd/cluster01/apps/lister/base/lister-values.yml \
	--export > fluxcd/cluster01/apps/lister/base/helmrelease.yaml

flux create kustomization lister-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/apps/lister/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/apps/lister/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/apps/dashboard/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/apps/dashboard/base/kustomization.yaml

flux create source helm dashboard \
	--interval=10m \
	--url=https://kubernetes.github.io/dashboard \
	--export > fluxcd/cluster01/apps/dashboard/base/helmrepository.yaml

flux create helmrelease dashboard \
	--interval=10m \
	--release-name dashboard \
	--target-namespace dashboard\
	--create-target-namespace \
	--source=HelmRepository/dashboard \
	--chart=kubernetes-dashboard \
	--chart-version="7.5.0" \
	--values=fluxcd/cluster01/apps/dashboard/base/dashboard-values.yml \
	--export > fluxcd/cluster01/apps/dashboard/base/helmrelease.yaml

flux create kustomization dashboard-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/apps/dashboard/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/apps/dashboard/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/apps/podinfo/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/apps/podinfo/base/kustomization.yaml

 flux create source helm podinfo \
	--interval=10m \
	--url=https://stefanprodan.github.io/podinfo \
	--export > fluxcd/cluster01/apps/podinfo/base/helmrepository.yaml

flux create helmrelease podinfo \
	--interval=10m \
	--release-name podinfo \
	--target-namespace podinfo\
	--create-target-namespace \
	--source=HelmRepository/podinfo \
	--chart=podinfo \
	--chart-version="6.7.0" \
	--values=fluxcd/cluster01/apps/podinfo/base/podinfo-values.yml \
	--export > fluxcd/cluster01/apps/podinfo/base/helmrelease.yaml

flux create kustomization podinfo-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/apps/podinfo/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/apps/podinfo/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/core/longhorn/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/core/longhorn/base/kustomization.yaml

flux create source helm longhorn \
	--interval=10m \
	--url=https://charts.longhorn.io \
	--export > fluxcd/cluster01/core/longhorn/base/helmrepository.yaml

flux create helmrelease longhorn \
	--interval=10m \
	--release-name longhorn \
	--target-namespace longhorn-system \
	--create-target-namespace \
	--source=HelmRepository/longhorn \
	--chart=longhorn \
	--chart-version="1.6.2" \
	--values=fluxcd/cluster01/core/longhorn/base/longhorn-values.yml \
	--export > fluxcd/cluster01/core/longhorn/base/helmrelease.yaml

flux create kustomization longhorn-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/longhorn/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/core/longhorn/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/core/local-path-provisioner/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/core/local-path-provisioner/base/kustomization.yaml

# NOTE: this is a 3rd part repo
flux create source helm local-path-provisioner \
	--interval=10m \
	--url=https://charts.containeroo.ch \
	--export > fluxcd/cluster01/core/local-path-provisioner/base/helmrepository.yaml

flux create helmrelease local-path-provisioner \
	--interval=10m \
	--release-name local-path-storage \
	--target-namespace local-path-storage \
	--create-target-namespace \
	--source=HelmRepository/local-path-provisioner \
	--chart=local-path-provisioner \
	--chart-version="0.0.28" \
	--export > fluxcd/cluster01/core/local-path-provisioner/base/helmrelease.yaml

flux create kustomization local-path-provisioner-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/local-path-provisioner/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/core/local-path-provisioner/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/apps/cnpg/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/cluster01/templates/hrhr-kustomization.yaml fluxcd/cluster01/apps/cnpg/base/kustomization.yaml

flux create source helm cnpg \
	--interval=10m \
	--url=https://cloudnative-pg.github.io/charts \
	--export > fluxcd/cluster01/apps/cnpg/base/helmrepository.yaml

flux create helmrelease cnpg \
	--interval=10m \
	--release-name cnpg \
	--target-namespace cnpg-system \
	--create-target-namespace \
	--source=HelmRepository/cnpg \
	--chart=cloudnative-pg \
	--chart-version="0.22.0" \
	--values=fluxcd/cluster01/apps/cnpg/base/cnpg-values.yml \
	--export > fluxcd/cluster01/apps/cnpg/base/helmrelease.yaml

flux create kustomization cnpg-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/apps/cnpg/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/cluster01/apps/cnpg/kustomization-fluxCRD.yaml
