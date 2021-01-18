# info

## commands to install democratic-csi
need helm installed (k3s has it by default)
```
helm upgrade --install --values freenas-nfs.yaml --namespace democratic-csi zfs-nfs democratic-csi/democratic-csi
helm upgrade --install --values freenas-iscsi.yaml --namespace democratic-csi zfs-iscsi democratic-csi/democratic-csi
```

## commands to fix storageclasses
both are needed
```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass freenas-nfs-csi -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
