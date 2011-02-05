# iPod Cheat Sheet

## Using Apple iPod with Linux.

First, see:

<http://www.freedos.org/jhall/ipod/>
<http://pag.csail.mit.edu/~adonovan/hacks/ipod.html>

### Getting iPod to mount properly, and with the right permissions

Install the following in `/usr/share/hal/fd/95userpolicy`:

    <?xml version="1.0" encoding="ISO-8859-1"?> <!-- -*- SGML -*- -->
    <deviceinfo version="0.2">
      <device>
        <match key="storage.vendor" string="Apple">
          <match key="storage.model" string="iPod">
            <merge key="storage.requires_eject" type="bool">true</merge>
            <merge key="storage.removable" type="bool">false</merge>
            <merge key="storage.media_check_enabled" type="bool">false</merge>
          </match>
        </match>
        <match key="@block.storage_device:storage.vendor" string="Apple">
          <match key="@block.storage_device:storage.model" string="iPod">
            <match key="block.is_volume" bool="true">
              <match key="volume.fsusage" string="filesystem">
                <match key="volume.partition.number" int="1">
                  <merge key="volume.policy.should_mount" type="bool">false</merge>
                </match>
                <match key="volume.partition.number" int="2">
                  <merge key="volume.policy.desired_mount_point" type="string">iPod</merge>
                  <merge key="volume.policy.mount_option.sync" type="bool">true</merge>
                  <merge key="volume.policy.mount_option.uid=bmc" type="bool">true</merge>
                </match>
              </match>
    	</match>
          </match>
        </match>
      </device>
    </deviceinfo>

See <http://www.kgarner.com/blog/archives/2005/01/11/fc3-hal-ipod/>

### Accessing iPod

Use *gtkpod*.

### Disconnecting recalcitrant iPod

If iPod doesn't want to disconnect properly, use this quick hack solution:

Disable automount option in gtkpod, and create two scripts:

`mount-ipod`:

    mount /media/iPod

`umount-ipod`:

    sudo umount /media/iPod
    exec sudo eject -s /dev/sda2

Then modify *gtkpod* front end so it looks like this:

    mount-ipod
    env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib /usr/local/bin/gtkpod
    umount-ipod

