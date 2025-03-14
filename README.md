# infra
repository for my home infra using infrastructure as code

## things in here

There are 3 main directories in here:
- [`ansible`](./ansible) includes ansible playbooks for configuring proxmox virtualization hosts and virtual machines running on them
- [`terraform`](./terraform) includes terraform configuration to create virtual machines on proxmox
- [`fluxcd`](./fluxcd) includes fluxcd configuration to automatically deploy applications to a kubernetes cluster
