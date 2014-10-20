#!/bin/bash

# This is dicamarques edition of the script with mac changed to the ones from the list here https://docs.google.com/spreadsheet/lv?key=0AvvH5W4E2lIwdEFCUkxrM085ZGp0UkZlenp6SkJablE and easier wlan config
#
# wifi_zone_new
#  A script that emulates a Nintendo Zone in a way that you can actually connect to
#  other people all over the world.
#
# Initial version written by Somebunny (9. August 2013).
#

#
# documentation (sort of)
#
# You will need the following packages/programs:
#  - rfkill
#  - dnsmasq (will be killed if already running)
#  - hostapd (will be killed if already running)
# You should not need any additional configuration work.
#
# This script MUST be run as root, or using sudo, reconfiguring network
#  interfaces does not seem to work when run by non-root.
#
# Please adapt the following sections to your own computer:
#  - variables "zone" and "world", found below
#  - you can add hotsopts in "InitZone()", just copy what is there
#
# Usage: call the script with one extra parameter that describes the
#  MAC address to use. I have prepared some options that work from
#  the thread in the gbatemp forums.
#
# Shutdown: call the script with the parameter "stop".
#
#
# A first attempt to organise everything in a somewhat smarter way.
#

# First, some obligatory checks.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo."
   echo "I don't like this either, but some calls here are really picky!"
   exit 1
fi

# some global settings; you should only need to adapt them for your system once
#  * this is the network interface used for your custom AP; must be wireless
zone=$2
#  * this is the network interface used to access the internet; can be almost anything
world=$3

# some local variables; using default values so that something is there
mac=4E:53:50:4F:4F:46

cleanup() {
	killall dnsmasq 2> /dev/null
	killall hostapd 2> /dev/null
}

#
# local function that sets up the local variables;
#  crude but better than having to change the script every time
# NOTE: this part should be heavily modified so that it doesn't
#  depend on a static config. Maybe something with an external
#  file or something, so you don't have to share your relay point
#  with the entire world if you don't want to.
#
InitZone() {
  # kill all existing support tools
	cleanup
  # flush routing entries
  iptables --flush
  # deconfigure network interface
  ip link set dev $zone down
  case $1 in
    "stop")
      # emergency exit - restore old network state
      echo "Stopping Nintendo Zone hotspot"
			cleanup
			ip link set dev $zone down
      exit ;;

		"spoof1")
      mac=4E:53:50:4F:4F:46 ;;
    "spoof2")
      mac=4E:53:50:4F:4F:47 ;;
    "spoof3")
      mac=4E:53:50:4F:4F:48 ;;
    "spoof4")
      mac=4E:53:50:4F:4F:49 ;;
    "spoof5")
      mac=4E:53:50:4F:4F:50 ;;
    "spoof6")
      mac=4E:53:50:4F:4F:51 ;;
    "spoof7")
      mac=4E:53:50:4F:4F:40 ;;
    "spoof8")
      mac=4E:53:50:4F:4F:41 ;;
    "spoof9")
      mac=4E:53:50:4F:4F:42 ;;
    "spoof10")
      mac=4E:53:50:4F:4F:43 ;;
    "spoof11")
      mac=4E:53:50:4F:4F:44 ;;
    "spoof12")
      mac=4E:53:50:4F:4F:45 ;;
    "spoof13")
      mac=4E:53:50:4F:4F:4C ;;
    "spoof14")
      mac=4E:53:50:4F:4F:4D ;;
    "spoof15")
      mac=4E:53:50:4F:4F:4E ;;
    "spoof16")
      mac=4E:53:50:4F:4F:4F ;;
    "spoof17")
      mac=00:0D:67:15:2D:82 ;;
    "spoof18")
      mac=00:0D:67:15:D7:21 ;;
    "spoof19")
      mac=00:0D:67:15:D5:44 ;;
    "spoof20")
      mac=00:0D:67:15:D2:59 ;;
    "spoof21")
      mac=00:0D:67:15:D6:FD ;;

"spoof22")
mac=4E:53:50:4F:4F:01 ;;
"spoof23")
mac=4E:53:50:4F:4F:02 ;;
"spoof24")
mac=4E:53:50:4F:4F:03 ;;
"spoof25")
mac=4E:53:50:4F:4F:04 ;;
"spoof26")
mac=4E:53:50:4F:4F:05 ;;
"spoof27")
mac=4E:53:50:4F:4F:06 ;;
"spoof28")
mac=4E:53:50:4F:4F:07 ;;
"spoof29")
mac=4E:53:50:4F:4F:08 ;;
"spoof30")
mac=4E:53:50:4F:4F:09 ;;
"spoof31")
mac=4E:53:50:4F:4F:0A ;;
"spoof32")
mac=4E:53:50:4F:4F:0B ;;
"spoof33")
mac=4E:53:50:4F:4F:0C ;;
"spoof34")
mac=4E:53:50:4F:4F:0D ;;
"spoof35")
mac=4E:53:50:4F:4F:0E ;;
"spoof36")
mac=4E:53:50:4F:4F:0F ;;
"spoof37")
mac=4E:53:50:4F:4F:10 ;;
"spoof38")
mac=4E:53:50:4F:4F:11 ;;
"spoof39")
mac=4E:53:50:4F:4F:12 ;;
"spoof40")
mac=4E:53:50:4F:4F:13 ;;
"spoof41")
mac=4E:53:50:4F:4F:14 ;;
"spoof42")
mac=4E:53:50:4F:4F:15 ;;
"spoof43")
mac=4E:53:50:4F:4F:16 ;;
"spoof44")
mac=4E:53:50:4F:4F:17 ;;
"spoof45")
mac=4E:53:50:4F:4F:18 ;;
"spoof46")
mac=4E:53:50:4F:4F:19 ;;
"spoof47")
mac=4E:53:50:4F:4F:1A ;;
"spoof48")
mac=4E:53:50:4F:4F:1B ;;
"spoof49")
mac=4E:53:50:4F:4F:1C ;;
"spoof50")
mac=4E:53:50:4F:4F:1D ;;
"spoof51")
mac=4E:53:50:4F:4F:1E ;;
"spoof52")
mac=4E:53:50:4F:4F:1F ;;
"spoof53")
mac=4E:53:50:4F:4F:20 ;;
"spoof54")
mac=4E:53:50:4F:4F:21 ;;
"spoof55")
mac=4E:53:50:4F:4F:22 ;;
"spoof56")
mac=4E:53:50:4F:4F:23 ;;
"spoof57")
mac=4E:53:50:4F:4F:24 ;;
"spoof58")
mac=4E:53:50:4F:4F:25 ;;
"spoof59")
mac=4E:53:50:4F:4F:26 ;;
"spoof60")
mac=4E:53:50:4F:4F:27 ;;
"spoof61")
mac=4E:53:50:4F:4F:28 ;;
"spoof62")
mac=4E:53:50:4F:4F:29 ;;
"spoof63")
mac=4E:53:50:4F:4F:2A ;;
"spoof64")
mac=4E:53:50:4F:4F:2B ;;
"spoof65")
mac=4E:53:50:4F:4F:2C ;;
"spoof66")
mac=4E:53:50:4F:4F:2D ;;
"spoof67")
mac=4E:53:50:4F:4F:2E ;;
"spoof68")
mac=4E:53:50:4F:4F:2F ;;
"spoof69")
mac=4E:53:50:4F:4F:30 ;;
"spoof70")
mac=4E:53:50:4F:4F:31 ;;
"spoof71")
mac=4E:53:50:4F:4F:32 ;;
"spoof72")
mac=4E:53:50:4F:4F:33 ;;
"spoof73")
mac=4E:53:50:4F:4F:34 ;;
"spoof74")
mac=4E:53:50:4F:4F:35 ;;
"spoof75")
mac=4E:53:50:4F:4F:36 ;;
"spoof76")
mac=4E:53:50:4F:4F:37 ;;
"spoof77")
mac=4E:53:50:4F:4F:38 ;;
"spoof78")
mac=4E:53:50:4F:4F:39 ;;
"spoof79")
mac=4E:53:50:4F:4F:3A ;;
"spoof80")
mac=4E:53:50:4F:4F:3B ;;
"spoof81")
mac=4E:53:50:4F:4F:3C ;;
"spoof82")
mac=4E:53:50:4F:4F:3D ;;
"spoof83")
mac=4E:53:50:4F:4F:3E ;;
"spoof84")
mac=4E:53:50:4F:4F:3F ;;
"spoof85")
mac=4E:53:50:4F:4F:51 ;;
"spoof86")
mac=4E:53:50:4F:4F:52 ;;
"spoof87")
mac=4E:53:50:4F:4F:53 ;;
"spoof88")
mac=4E:53:50:4F:4F:54 ;;
"spoof89")
mac=4E:53:50:4F:4F:55 ;;
"spoof90")
mac=4E:53:50:4F:4F:56 ;;
"spoof91")
mac=4E:53:50:4F:4F:57 ;;
"spoof92")
mac=4E:53:50:4F:4F:58 ;;
"spoof93")
mac=4E:53:50:4F:4F:59 ;;
"spoof94")
mac=4E:53:50:4F:4F:5A ;;
"spoof95")
mac=4E:53:50:4F:4F:5B ;;
"spoof96")
mac=4E:53:50:4F:4F:5C ;;
"spoof97")
mac=4E:53:50:4F:4F:5D ;;
"spoof98")
mac=4E:53:50:4F:4F:5E ;;
"spoof99")
mac=4E:53:50:4F:4F:5F ;;
"spoof100")
mac=4E:53:50:4F:4F:60 ;;
"spoof101")
mac=4E:53:50:4F:4F:61 ;;
"spoof102")
mac=4E:53:50:4F:4F:62 ;;
"spoof103")
mac=4E:53:50:4F:4F:63 ;;
"spoof104")
mac=4E:53:50:4F:4F:64 ;;
"spoof105")
mac=4E:53:50:4F:4F:65 ;;
"spoof106")
mac=4E:53:50:4F:4F:66 ;;
"spoof107")
mac=4E:53:50:4F:4F:67 ;;
"spoof108")
mac=4E:53:50:4F:4F:68 ;;
"spoof109")
mac=4E:53:50:4F:4F:69 ;;
"spoof110")
mac=4E:53:50:4F:4F:6A ;;
"spoof112")
mac=4E:53:50:4F:4F:6B ;;
"spoof113")
mac=4E:53:50:4F:4F:6C ;;
"spoof114")
mac=4E:53:50:4F:4F:6D ;;
"spoof115")
mac=4E:53:50:4F:4F:6E ;;
"spoof116")
mac=4E:53:50:4F:4F:6F ;;
"spoof117")
mac=4E:53:50:4F:4F:70 ;;
"spoof118")
mac=4E:53:50:4F:4F:71 ;;
"spoof119")
mac=4E:53:50:4F:4F:72 ;;
"spoof120")
mac=4E:53:50:4F:4F:73 ;;
"spoof121")
mac=4E:53:50:4F:4F:74 ;;
"spoof122")
mac=4E:53:50:4F:4F:75 ;;
"spoof123")
mac=4E:53:50:4F:4F:76 ;;
"spoof124")
mac=4E:53:50:4F:4F:77 ;;
"spoof125")
mac=4E:53:50:4F:4F:78 ;;
"spoof126")
mac=4E:53:50:4F:4F:79 ;;
"spoof127")
mac=4E:53:50:4F:4F:7A ;;
"spoof128")
mac=4E:53:50:4F:4F:7B ;;
"spoof129")
mac=4E:53:50:4F:4F:7C ;;
"spoof130")
mac=4E:53:50:4F:4F:7D ;;
"spoof131")
mac=4E:53:50:4F:4F:7E ;;
"spoof132")
mac=4E:53:50:4F:4F:7F ;;
"spoof133")
mac=4E:53:50:4F:4F:80 ;;
"spoof134")
mac=4E:53:50:4F:4F:81 ;;
"spoof135")
mac=4E:53:50:4F:4F:82 ;;
"spoof136")
mac=4E:53:50:4F:4F:83 ;;
"spoof137")
mac=4E:53:50:4F:4F:84 ;;
"spoof138")
mac=4E:53:50:4F:4F:85 ;;
"spoof139")
mac=4E:53:50:4F:4F:86 ;;
"spoof140")
mac=4E:53:50:4F:4F:87 ;;
"spoof141")
mac=4E:53:50:4F:4F:88 ;;
"spoof142")
mac=4E:53:50:4F:4F:89 ;;
"spoof143")
mac=4E:53:50:4F:4F:8A ;;
"spoof144")
mac=4E:53:50:4F:4F:8B ;;
"spoof145")
mac=4E:53:50:4F:4F:8C ;;
"spoof146")
mac=4E:53:50:4F:4F:8D ;;
"spoof147")
mac=4E:53:50:4F:4F:8E ;;
"spoof148")
mac=4E:53:50:4F:4F:8F ;;
"spoof149")
mac=4E:53:50:4F:4F:90 ;;
"spoof150")
mac=4E:53:50:4F:4F:91 ;;
"spoof151")
mac=4E:53:50:4F:4F:92 ;;
"spoof152")
mac=4E:53:50:4F:4F:93 ;;
"spoof153")
mac=4E:53:50:4F:4F:94 ;;
"spoof154")
mac=4E:53:50:4F:4F:95 ;;
"spoof155")
mac=4E:53:50:4F:4F:96 ;;
"spoof156")
mac=4E:53:50:4F:4F:97 ;;
"spoof157")
mac=4E:53:50:4F:4F:98 ;;
"spoof158")
mac=4E:53:50:4F:4F:99 ;;
"spoof159")
mac=4E:53:50:4F:4F:9A ;;
"spoof160")
mac=4E:53:50:4F:4F:9B ;;
"spoof161")
mac=4E:53:50:4F:4F:9C ;;
"spoof162")
mac=4E:53:50:4F:4F:9D ;;
"spoof163")
mac=4E:53:50:4F:4F:9E ;;
"spoof164")
mac=4E:53:50:4F:4F:9F ;;
  esac
}

# networkmanager often leaves a lock on the wireless hardware, remove it
rfkill unblock wifi

# set up parameters
InitZone $1

# give our wifi device a static IP address in the correct range so hostapd can associate with it
#/sbin/ifconfig $zone hw ether $mac
/sbin/ifconfig $zone 192.168.23.1 up

# start dnsmasq
dnsmasq -i $zone --dhcp-range=192.168.23.50,192.168.23.150,255.255.255.0,12h

# set basic routes so that our associated devices can reach the web
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface $world -j MASQUERADE
iptables --append FORWARD --in-interface $zone -j ACCEPT

sed -i "s/bssid=.*/bssid=$mac/" hostapd.conf

hostapd hostapd.conf
