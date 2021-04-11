# general info
this holds all the manifests for the k3s cluster deployed by terraform and ansible on proxmox using [this](https://gitlab.com/insanitywholesale/infra/-/tree/master/terraform/proxmox).
- secrets are not handled properly (private cluster so no biggie yet)
- connection and use of ceph is WIP and not actually used
- minecraft is used as a testing for storage stuff, not to be deployed (yet)
- minio from gifinator is there for testing purposes, instance on truenas is to be used in prod
- nfs dir is archived/useless (no workie with >=1.20 and [democratic-csi](https://github.com/democratic-csi/democratic-csi) is used instead)
- helm things are archived/useless too

## commands to install democratic-csi
need helm installed (k3s has it by default)
```
helm upgrade --install --values freenas-nfs.yaml --namespace democratic-csi zfs-nfs democratic-csi/democratic-csi
```

## commands to fix storageclasses on k3s
both are needed
```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass freenas-nfs-csi -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
