#!/bin/sh

# Commands to re-create everything

mkdir -p fluxcd/homecluster/core/metallb/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p fluxcd/homecluster/core/metallb/config  # For things other than values of the upstream chart

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/core/metallb/base/kustomization.yaml

flux create source helm metallb \
	--interval=10m \
	--url=https://metallb.github.io/metallb \
	--export > fluxcd/homecluster/core/metallb/base/helmrepository.yaml

flux create helmrelease metallb \
	--interval=10m \
	--release-name metallb \
	--target-namespace metallb-system \
	--create-target-namespace \
	--source=HelmRepository/metallb \
	--chart=metallb \
	--chart-version="0.14.9" \
	--values=fluxcd/homecluster/core/metallb/base/metallb-values.yml \
	--export > fluxcd/homecluster/core/metallb/base/helmrelease.yaml

flux create kustomization metallb-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/metallb/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/core/metallb/kustomization-fluxCRD.yaml

flux create kustomization metallb-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/metallb/config \
	--depends-on metallb-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export >> fluxcd/homecluster/core/metallb/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/core/cert-manager/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p fluxcd/homecluster/core/cert-manager/config  # For things other than values of the upstream chart

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/core/cert-manager/base/kustomization.yaml

flux create source helm cert-manager \
	--interval=10m \
	--url=https://charts.jetstack.io \
	--export > fluxcd/homecluster/core/cert-manager/base/helmrepository.yaml

flux create helmrelease cert-manager \
	--interval=10m \
	--release-name cert-manager \
	--target-namespace cert-manager \
	--create-target-namespace \
	--source=HelmRepository/cert-manager \
	--chart=cert-manager \
	--chart-version="v1.17.1" \
	--values=fluxcd/homecluster/core/cert-manager/base/cert-manager-values.yml \
	--export > fluxcd/homecluster/core/cert-manager/base/helmrelease.yaml

flux create kustomization cert-manager-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/cert-manager/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/core/cert-manager/kustomization-fluxCRD.yaml

flux create kustomization cert-manager-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/cert-manager/config \
	--depends-on cert-manager-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export >> fluxcd/homecluster/core/cert-manager/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/core/ingress-nginx/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/core/ingress-nginx/base/kustomization.yaml

flux create source helm ingress-nginx \
	--interval=10m \
	--url=https://kubernetes.github.io/ingress-nginx \
	--export > fluxcd/homecluster/core/ingress-nginx/base/helmrepository.yaml

flux create helmrelease ingress-nginx \
	--interval=10m \
	--release-name ingress-nginx \
	--target-namespace ingress-nginx \
	--create-target-namespace \
	--source=HelmRepository/ingress-nginx \
	--chart=ingress-nginx \
	--chart-version="4.12.0" \
	--values=fluxcd/homecluster/core/ingress-nginx/base/ingress-nginx-values.yml \
	--export > fluxcd/homecluster/core/ingress-nginx/base/helmrelease.yaml

flux create kustomization ingress-nginx-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/ingress-nginx/base \
	--depends-on metallb-config \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/core/ingress-nginx/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/core/external-dns/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/core/external-dns/base/kustomization.yaml

flux create source helm external-dns \
	--interval=10m \
	--url=https://kubernetes-sigs.github.io/external-dns \
	--export > fluxcd/homecluster/core/external-dns/base/helmrepository.yaml

flux create helmrelease external-dns \
	--interval=10m \
	--release-name external-dns \
	--target-namespace external-dns\
	--create-target-namespace \
	--source=HelmRepository/external-dns \
	--chart=external-dns \
	--chart-version="1.14.5" \
	--values=fluxcd/homecluster/core/external-dns/base/external-dns-values.yml \
	--export > fluxcd/homecluster/core/external-dns/base/helmrelease.yaml

flux create kustomization external-dns-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/external-dns/base \
	--depends-on "metallb-base,ingress-nginx-base" \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/core/external-dns/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/apps/lister/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/apps/lister/base/kustomization.yaml

flux create source helm lister \
	--interval=10m \
	--url=https://gitlab.com/api/v4/projects/27255221/packages/helm/stable \
	--export > fluxcd/homecluster/apps/lister/base/helmrepository.yaml

flux create helmrelease lister \
	--interval=10m \
	--release-name lister \
	--target-namespace lister \
	--create-target-namespace \
	--source=HelmRepository/lister \
	--chart=lister \
	--chart-version="0.3.1" \
	--values=fluxcd/homecluster/apps/lister/base/lister-values.yml \
	--export > fluxcd/homecluster/apps/lister/base/helmrelease.yaml

flux create kustomization lister-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/apps/lister/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/apps/lister/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/apps/dashboard/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/apps/dashboard/base/kustomization.yaml

flux create source helm dashboard \
	--interval=10m \
	--url=https://kubernetes.github.io/dashboard \
	--export > fluxcd/homecluster/apps/dashboard/base/helmrepository.yaml

flux create helmrelease dashboard \
	--interval=10m \
	--release-name dashboard \
	--target-namespace dashboard\
	--create-target-namespace \
	--source=HelmRepository/dashboard \
	--chart=kubernetes-dashboard \
	--chart-version="7.5.0" \
	--values=fluxcd/homecluster/apps/dashboard/base/dashboard-values.yml \
	--export > fluxcd/homecluster/apps/dashboard/base/helmrelease.yaml

flux create kustomization dashboard-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/apps/dashboard/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/apps/dashboard/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/apps/podinfo/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/apps/podinfo/base/kustomization.yaml

 flux create source helm podinfo \
	--interval=10m \
	--url=https://stefanprodan.github.io/podinfo \
	--export > fluxcd/homecluster/apps/podinfo/base/helmrepository.yaml

flux create helmrelease podinfo \
	--interval=10m \
	--release-name podinfo \
	--target-namespace podinfo\
	--create-target-namespace \
	--source=HelmRepository/podinfo \
	--chart=podinfo \
	--chart-version="6.7.0" \
	--values=fluxcd/homecluster/apps/podinfo/base/podinfo-values.yml \
	--export > fluxcd/homecluster/apps/podinfo/base/helmrelease.yaml

flux create kustomization podinfo-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/apps/podinfo/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/apps/podinfo/kustomization-fluxCRD.yaml

# https://raw.githubusercontent.com/openebs/openebs/e90fe9b35ea45ca03077317259e8eb530693ad33/charts/values.yaml

mkdir -p fluxcd/homecluster/core/openebs/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p fluxcd/homecluster/core/openebs/config  # For things other than values of the upstream chart

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/core/openebs/base/kustomization.yaml

flux create source helm openebs \
	--interval=10m \
	--url=https://openebs.github.io/openebs \
	--export > fluxcd/homecluster/core/openebs/base/helmrepository.yaml

flux create helmrelease openebs \
	--interval=10m \
	--release-name openebs \
	--target-namespace openebs \
	--create-target-namespace \
	--source=HelmRepository/openebs \
	--chart=openebs \
	--chart-version="4.1.3" \
	--values=fluxcd/homecluster/core/openebs/base/openebs-values.yml \
	--export > fluxcd/homecluster/core/openebs/base/helmrelease.yaml

flux create kustomization openebs-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/openebs/base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/core/openebs/kustomization-fluxCRD.yaml

flux create kustomization openebs-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/core/openebs/config \
	--depends-on openebs-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export >> fluxcd/homecluster/core/openebs/kustomization-fluxCRD.yaml

mkdir -p fluxcd/homecluster/apps/cnpg/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p fluxcd/homecluster/apps/cnpg/config  # For things other than values of the upstream chart

cp fluxcd/homecluster/templates/hrhr-kustomization.yaml fluxcd/homecluster/apps/cnpg/base/kustomization.yaml

flux create source helm cnpg \
	--interval=10m \
	--url=https://cloudnative-pg.github.io/charts \
	--export > fluxcd/homecluster/apps/cnpg/base/helmrepository.yaml

flux create helmrelease cnpg \
	--interval=10m \
	--release-name cnpg \
	--target-namespace cnpg-system \
	--create-target-namespace \
	--source=HelmRepository/cnpg \
	--chart=cloudnative-pg \
	--chart-version="0.23.2" \
	--values=fluxcd/homecluster/apps/cnpg/base/cnpg-values.yml \
	--export > fluxcd/homecluster/apps/cnpg/base/helmrelease.yaml

flux create kustomization cnpg-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/apps/cnpg/base \
	--depends-on openebs-config \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export > fluxcd/homecluster/apps/cnpg/kustomization-fluxCRD.yaml

flux create kustomization cnpg-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/homecluster/apps/cnpg/config \
	--depends-on cnpg-base \
	--prune \
	--wait \
	--decryption-provider=sops \
	--decryption-secret=sops-age \
	--export >> fluxcd/homecluster/apps/cnpg/kustomization-fluxCRD.yaml
