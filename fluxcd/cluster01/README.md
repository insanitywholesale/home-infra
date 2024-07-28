# Commands to kinda re-create everything

mkdir -p core/metallb/base    # For flux helmrepository, upstream chart helm values and flux helmrelease with custom values
mkdir -p core/metallb/config  # For things other than values of the upstream chart

curl \
	-o core/metallb/base/metallb-values.yml \
	https://github.com/metallb/metallb/blob/110fbf0e47379d8af847b8dc31ec1751cdf6139d/charts/metallb/values.yaml

flux create source helm metallb \
	--interval=10m \
	--url=https://metallb.github.io/metallb \
	--export > core/metallb/base/helmrepository.yaml

flux create helmrelease metallb \
	--interval=10m \
	--target-namespace metallb-system \
	--create-target-namespace \
	--source=HelmRepository/metallb \
	--chart=metallb \
	--chart-version="0.14.8" \
	--values=./core/metallb/base/metallb-values.yml \
	--export > core/metallb/base/helmrelease.yaml

flux create kustomization metallb-base \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/base \
	--prune \
	--wait \
	--export > core/metallb/kustomization.yaml

flux create kustomization metallb-config \
	--interval=10m \
	--source GitRepository/flux-system \
	--path=fluxcd/cluster01/core/metallb/config \
	--depends-on metallb-base \
	--prune \
	--wait \
	--export >> core/metallb/kustomization.yaml
