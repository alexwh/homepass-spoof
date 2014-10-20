I wrote this ages ago and posted it on the [GBATemp Forums](http://gbatemp.net/threads/how-to-have-a-homemade-streetpass-relay.352645/page-51#post-4751612).

To use, replace the example MAC addresses (aa:bb:cc:dd:ee:ff) with your 3DS' MAC in the `macs` file and `spawnhostapd.expect`

Putting it on GitHub now because it didn't fit in my dotfiles bin dir.


From the GBATemp forums:

> [The script will] auto cycle to the next "spoofX" when your DS disconnects from the AP (after it checks for and retrieves streetpasses), so you don't need to guess wait times. If your DS never disconnects, it will time out and move to the next spoof after 4 minutes. It requires expect, you can get it from your distro's package manager.

> To set it up, you need to edit the "macs" file and put your DS' MAC on one line, then edit "spawnhostapd.expect" and replace your-ds-mac (make sure it's lower case and seperated by colons, not dashes, e.g. 'expect "${zone}: AP-STA-DISCONNECTED 00:00:00:00:00:00"'). If you're not using wlan0 as your broadcast device, you need to edit it in hostapd.conf

> chmod all the scripts (chmod +x *.sh;chmod +x *.expect)

> To run it, do "sudo ./cycle.sh start-spoof end-spoof wlan-dev world-dev". For example, "sudo ./cycle.sh 1 21 wlan0 eth0".
