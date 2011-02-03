# VirtualBox Cheat Sheet

## Create VMDK for existing partition

Create a vmdk file (a Virtual Box disk descriptor) for an existing raw
partition:

    VBoxManage internalcommands createrawvmdk -filename ./presto.vmdk -rawdisk /dev/drive2/presto
