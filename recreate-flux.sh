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

flux create source helm metallb \
	--interval=1m \
	--url=https://metallb.github.io/metallb \
	--export > fluxcd/cluster01/core/metallb/base/helmrepository.yaml

flux create helmrelease metallb \
	--interval=1m \
	--release-name metallb \
	--target-namespace metallb-system \
	--create-target-namespace \
	--source=HelmRepository/metallb \
	--chart=metallb \
	--chart-version="0.14.8" \
	--values=fluxcd/cluster01/core/metallb/base/metallb-values.yml \
	--export > fluxcd/cluster01/core/metallb/base/helmrelease.yaml

flux create kustomization metallb-base \
	--interval=1m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/base \
	--prune \
	--wait \
	--export > fluxcd/cluster01/core/metallb/kustomization-fluxCRD.yaml

flux create kustomization metallb-config \
	--interval=1m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/config \
	--depends-on metallb-base \
	--prune \
	--wait \
	--export >> fluxcd/cluster01/core/metallb/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/core/ingress-nginx/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

flux create source helm ingress-nginx \
	--interval=1m \
	--url=https://kubernetes.github.io/ingress-nginx \
	--export > fluxcd/cluster01/core/ingress-nginx/base/helmrepository.yaml

flux create helmrelease ingress-nginx \
	--interval=1m \
	--release-name ingress-nginx \
	--target-namespace ingress-nginx \
	--create-target-namespace \
	--source=HelmRepository/ingress-nginx \
	--chart=ingress-nginx \
	--chart-version="4.11.1" \
	--values=fluxcd/cluster01/core/ingress-nginx/base/ingress-nginx-values.yml \
	--export > fluxcd/cluster01/core/ingress-nginx/base/helmrelease.yaml

flux create kustomization ingress-nginx-base \
	--interval=1m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/ingress-nginx/base \
	--depends-on metallb-config \
	--prune \
	--wait \
	--export > fluxcd/cluster01/core/ingress-nginx/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/apps/lister/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

flux create source helm lister \
	--interval=1m \
	--url=https://gitlab.com/api/v4/projects/27255221/packages/helm/stable \
	--export > fluxcd/cluster01/apps/lister/base/helmrepository.yaml

flux create helmrelease lister \
	--interval=1m \
	--release-name lister \
	--target-namespace lister \
	--create-target-namespace \
	--source=HelmRepository/lister \
	--chart=lister \
	--chart-version="0.2.2" \
	--export > fluxcd/cluster01/apps/lister/base/helmrelease.yaml

flux create kustomization lister-base \
	--interval=1m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/apps/lister/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--export > fluxcd/cluster01/apps/lister/kustomization-fluxCRD.yaml

mkdir -p fluxcd/cluster01/apps/dashboard/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values

flux create source helm dashboard \
	--interval=1m \
	--url=https://kubernetes.github.io/dashboard \
	--export > fluxcd/cluster01/apps/dashboard/base/helmrepository.yaml

flux create helmrelease dashboard \
	--interval=1m \
	--release-name dashboard \
	--target-namespace dashboard\
	--create-target-namespace \
	--source=HelmRepository/dashboard \
	--chart=kubernetes-dashboard \
	--chart-version="7.5.0" \
	--values=fluxcd/cluster01/apps/dashboard/base/dashboard-values.yml \
	--export > fluxcd/cluster01/apps/dashboard/base/helmrelease.yaml

flux create kustomization dashboard-base \
	--interval=1m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/apps/dashboard/base \
	--depends-on ingress-nginx-base \
	--prune \
	--wait \
	--export > fluxcd/cluster01/apps/dashboard/kustomization-fluxCRD.yaml
