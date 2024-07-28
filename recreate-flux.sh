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
	--interval=10m \
	--url=https://metallb.github.io/metallb \
	--export > fluxcd/cluster01/core/metallb/base/helmrepository.yaml

flux create helmrelease metallb \
	--interval=10m \
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
	--export > fluxcd/cluster01/core/metallb/kustomization-fluxCRD.yaml

flux create kustomization metallb-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/config \
	--depends-on metallb-base \
	--prune \
	--wait \
	--export >> fluxcd/cluster01/core/metallb/kustomization-fluxCRD.yaml
