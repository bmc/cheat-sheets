---
title: VirtualBox Cheat Sheet
layout: cheat-sheet
---

# Create VMDK for existing partition

Create a vmdk file (a Virtual Box disk descriptor) for an existing raw
partition:

    VBoxManage internalcommands createrawvmdk -filename ./presto.vmdk -rawdisk /dev/drive2/presto

# Upgrading host Linux OS causes network to stop working in Windows guest

Environment:

* Linux host is Ubuntu
* Bridged networking installed on Linux host
* Windows 7 guest is using bridged networking

Solution:

* Boot Windows and reinstall VirtualBox Guest Additions. 

# VERR_ACCESS_DENIED after a virtual machine crashes

If the VM's disk is a physical partition, check the partition's permissions. In
particular, ensure that the device (e.g., `/dev/dm-4`) is readable and writable
by the user running VirtualBox.

# Resize a virtual hard disk (VDI)

Bring the virtual machine down. Then, find the VDI (usually under
`$HOME/VirtualBox VMs/machinename/`. Use `vboxmanage` to resize the
VDI:

    vboxmanage modifyhd image.vdi --resize size-in-megabytes

For instance, to resize the VDI to 100 Gb, use:

    vboxmanage modifyhd image.vdi --resize 100000

# Tell the guest operating system to resize the drive

## Windows 7

See <http://www.howtogeek.com/howto/windows-vista/resize-a-partition-for-free-in-windows-vista/>
