# Proxmox

## Prerequisites

You must have a full bare metal server with sufficient ressources :
- 8 cores (minimum) / 12 (better) / above 16 (optimal)
- 16G RAM (minimum) / 32 (better) / above 48 (optimal)
- 500G (minimum) / 1To (better) / above 2T (optimal)

Nvme storage is the best choice for experimentation, giving us the flexibility to create and destroy as quickly as the hardware can.

And the more servers you have, the more you can do.

## Quick Documentation

The official documentation is sufficient, so there's no need to create a new one to suit your scenario.

Some advices for the deployment :
- 1 server : Default deployment, you can keep LVM by default, but for flexibility, I recommand directly to move to ZFS filesystem. If you have a hardware RAID you can choose RAID 1/5/6/10 depending of the number of disks.
- 2 servers only : Choose ZFS during the install, forget LVM option. Disk organisation is same as above. We will be able to do some ZFS replication, in the event of a node failure.
- 3 servers: If you have the necessary amount of storage, you should switch to Ceph storage. Forget about hardware RAID for the Ceph file system.

## Cluster - The Qorum 

- Prefer 3 nodes for making the cluster, more important if you have a Ceph Storage. In a production environment, plan for even more nodes.
- If you're like me, limited by money in the case of a homelab, you can do a 2-node cluster with ZFS replication. This is less important when the services are not vital.

## Best Practices

- If you have multiple network interface, you can seperate :
  - The admin interface
  - The cluster interface
  - The data interface
- The ZFS filesystem can be used also for SSD caching, you can do directly software RAID also with this choice.
- The power of Proxmox also lies in the command line, don't limit yourself using only the graphical interface.

## References

- https://www.proxmox.com/en/proxmox-virtual-environment/get-started