---
title: Linux Cheat Sheet
layout: cheat-sheet
---

# Single User Boot

To perform single user boot with GRUB perform the steps:

* type p and password if required
* type e to enter edit mode
* select the kernel command line and append single for single user
  boot, or run level number (1 through 5)
* type b to boot the system

# UTF-8

Both *vi* (*vim*) and *emacs* will grok UTF-8 if you set `LANG`
appropriately, e.g.:

    export LANG=en_US.UTF-8
    
# Logical and Physical Volume Groups

## Adding a new disk and putting it in its own logical volume

### Preparation

First, add the hardware.

Then, use the GUI Disk Utility to format the disk (i.e., to create
the partition table). Do NOT create a file system.

### Create the physical volume

Use `fdisk -l` to verify which device is associated with the new disk.
Then, at the command line. create a physical volume. Let's suppose the
disk is `/dev/sdb`:

    # pvcreate /dev/sdb

Doesn't hurt to verify the creation with `pvdisplay`.

### Create the volume group

Next, create the volume group. With a single partition:

    # vgcreate drive2 /dev/sdb

`drive2` is an arbitrary name for the volume group. It can be anything,
as long as it doesn't clash with an existing volume group's name.

To group multiple partitions in the same group:

    # vgcreate drive2 /dev/sdb /dev/sdc ...

Now, run `vgdisplay` to show the new volume group configuration.

### Create the logical volumes

    # lvcreate --name usrlocal --size 80G drive2
    # lvcreate --name home2 --size 160G drive2

To use 100% of all disks:

    # lvcreate --name foo --extents 100%FREE drive3

### Format and mount the new volumes:

    # mkfs.ext4 /dev/drive2/usrlocal
    # mkfs.ext4 /dev/drive2/home2
    # mount /dev/drive2/usrlocal /usr/local
    # mount /dev/drive2/home2 /home2

Reference: <http://www.davelachapelle.ca/guides/ubuntu-lvm-guide/>

## Adding a new disk to an existing volume group.

Create the physical volume, as described above. Then:

### Unmount the existing logical volume

    # umount /dev/volgroup1/logicalvol0

### Add the new physical volume to the parent volume group

    # vgextend volgroup1 /dev/sdb1

### Add space to the logical volume

Decide how much of the new physical volume should go an existing volume
group, if any. If any percentage of the drive is being used to extend an
existing logical volume, extend the logical volume. In this example, the
entire new volume group is being added. (See *lvextend*(8) for more info.)

    # lvextend /dev/volgroup1/logicalvol0 /dev/sdk1 

### Resize the logical volume

    # e2fsck -f /dev/volgroup1/logicalvol0

If that fails to get all the space, then recreate the file system from
scratch:

    # mkfs.ext4 /dev/volgroup1/logicalvol0

# Multimedia

## Video

### Importing Video via Firewire

To import video from a video camera with a Firewire port, use
[dvgrab](http://www.kinodv.org/).

**Example**: Import video to QuickTime format:

    $ dvgrab --rewind -f qt myvideo-
