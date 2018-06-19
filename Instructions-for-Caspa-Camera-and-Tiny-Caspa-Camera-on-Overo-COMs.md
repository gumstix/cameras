# Instructions for Caspa Camera and Tiny Caspa Camera on Overo COMs

## Hardware

### Boards
Choose either
- an [Overo COMs] with one of the [Overo Expansion Boards] OR

### Cameras
Choose one of the following:
- [Tiny Caspa 0.3MP 27-pin Camera Board] 
- [Caspa™ FS] 
- [Caspa™ VL]

## Software
Follow Instructions [HERE][Gumstix Getting Started] to get a working image based on what platform you are running.

## Connections

### Connect Camera
Connect your chosen camera using the ribbon cable provided as shown below:
[[/wiki-pics/wiki-CaspaConnection.jpg|Caspa Camera on the left, Tiny Caspa Camera on the right at Gumstix]]

#### Connect Caspa Camera (mt9v032)
The Caspa Camera (mt9v032) is set as default in Gumstix Yocto image
#### Connect Tiny Caspa Camera (ov7692)
The Tiny Caspa Camera need some modification on the device tree.

First, download the new dtb files [here](Tiny-Caspa-dtbs.zip "dtb files for Tiny caspa camera")
Then, extract it, and plug in the SD card you prepared, run:
```
# Mount the root filesystem, note change the "X" in /dev/sdX2 accroding to $ lsblk 
# where your SD card is mounted in your machine
$ sudo mount -t ext3 /dev/sdX2 /media/rootfs
$ sudo cp -rf /Tiny-Caspa-dtbs/* /media/rootfs/boot/ && sync

# Unmount your rootfs partition
$ sudo umount /media/rootfs
```

### Connect Internet
Depending on what board you are running, you have three options:

**Option 1**: Ethernet Cable Port

**Option 2**: USB to Gigabit Ethernet Adapter

**Option 3**: WiFi

To use WiFi:
1. Power up the board.
2. At console, login as `root`.
3. Run:
```
$ nano /etc/wpa_supplicant/wpa_supplicant_wlan0.conf
```
4. Edit your "`ssid(network name)`" and "`psk(network password)`" and uncomment.
5. Press `Ctrl+O` to save and `Ctrl+X` to exit.
6. If the wifi didn't come up automatically, by checking `$ ifconfig`, run:
```
$ ifconfig wlan0 down
$ ifconfig wlan0 up
```
7. To test wifi connection, run:
```
$ ping 8.8.8.8
```

## Camera Testing Scripts
Clone the repo for our Caspa camera source file, in there we have script `mt9v032_stream.sh` 
and `ov7692_stream.sh` that runs on the board, it will detect if `gstreamer` is installed or 
not, setup the pipelines and ask what IP address you want to stream to.

```
$ git clone https://github.com/gumstix/cameras.git

# Run the following if you have a Caspa camera connected
$ cd cameras
$ chmod 777 mt9v032_stream.sh
$ ./mt9v032_stream.sh

# Run the following if you have a Tiny Caspa camera connected
$ cd cameras
$ chmod 777 ov7692_stream.sh
$ ./ov7692_stream.sh
```

On the host machine, run `camera_host.sh`. Again, it will detect if `gstreamer` is installed. 
If everything is working, you will see the video in the pop-up window.

```
$ git clone https://github.com/gumstix/cameras.git
$ cd cameras
$ chmod 777 camera_host.sh
$ ./camera_host.sh
```

[Overo COMs]:https://store.gumstix.com/coms/overo-coms.html
[Overo Expansion Boards]:https://store.gumstix.com/development-boards/overo-expansion.html
[Geppetto]:https://geppetto.gumstix.com
[Tiny Caspa 0.3MP 27-pin Camera Board]:https://store.gumstix.com/cameras-displays-gps/cameras/tiny-caspa.html
[Caspa™ FS]:https://store.gumstix.com/cameras-displays-gps/cameras/caspa-fs.html
[Caspa™ VL]:https://store.gumstix.com/cameras-displays-gps/cameras/caspa-vl.html
[Poblano 43C]:https://store.gumstix.com/catalogsearch/result/?q=+poblano
[Gumstix Getting Started]:https://www.gumstix.com/support/getting-started/

