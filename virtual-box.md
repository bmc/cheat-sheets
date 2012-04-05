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
