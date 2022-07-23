#!/bin/sh

helm repo add stable https://charts.helm.sh/stable
helm repo add democratic-csi https://democratic-csi.github.io/charts/
helm repo update
helm upgrade --install --create-namespace --values ./helm/nfs/freenas-nfs.yaml --namespace democratic-csi zfs-nfs democratic-csi/democratic-csi
kubectl patch storageclass freenas-nfs-csi -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
