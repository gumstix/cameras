# Instructions for OV5640 Camera on Zircon

## Hardware
- COM: [Zircon] - Intel Joule Replacement
- Expansion Board: [Expansion Board Selection at Gumstix] built by [Geppetto]
- Camera: [KaiLapTech OV5640-V4320]


## Software
To prepare a image for Zircon, at Gumstix, we offer a **ddable desktop image**:

Download the image [here][Desktopimage].

### Method 1: Prepare a SD Card
To prepare an SD card for the Zircon, please follow the steps below:

1. Extract the image you just downloaded.
 
2. Plug an 4GB SD card in your host machine.

3. Run:
    
    ```
    $ sudo dd if=<name of the image.sdcard> of=<location of the SD card> bs=4M && sync
    ```

4. Change ```<name of the image.sdcard>```. E.g. : gumstix-xfce-image-imx6dqscm-1gb-zircon.sdcard

5. Change ```<location of the SD card>``` according to your machine. It will look something like this `/dev/sdX`.

6. Once your SD card is ready, slide the it into the SD card slot.

7. To boot up with SD card, connect USB into "**CONSOLE**".

8. Open a new terminal on host machine, run:
    ```
    $ sudo screen /dev/ttyUSB0 115200
    ```

9. Power up the board, stop the u-boot by pressing any keyboard button on your host machine, and run:
    ```
    $ setenv mmcdev 0
    $ setenv mmcroot /dev/mmcblk1p2 rootwait rw
    $ boot
    ```

### Method 2: Flash the on-board EMMC on Zircon
To boot with the on-board eMMC:

1. Connect USB into both "**CONSOLE**" and "**Type-C port**"

2. Open a new terminal on host machine, run:
    ```
    $ sudo screen /dev/ttyUSB0 115200
    ```
3. Power up the board. 

4. Stop the u-boot by pressing any keyboard button on your host machine, and run:
    ```
    $ ums 0 mmc 2
    ```
5. You should see a spinning line like this "|" "\\" "/", and now you should have a `/dev/sdX` drive on your computer.

6. Extract the image file you [downloaded](Desktopimage) from the previous step and run:
    ```
    $ sudo dd if=<name of the image.sdcard> of=<location of the SD card> bs=4M && sync
    ```
7. Change `<name of the image.sdcard>` accordingly, ex: gumstix-xfce-image-imx6dqscm-1gb-zircon.sdcard

8. Change `<location of the SD card>` according to your machine. It looks something like this `/dev/sdX`.

9. This will take a while but it'll finish. When the dd command is done, press "Ctrl+C".

10. Finally, boot up the board with EMMC, run in u-boot:
   
    ```
    $ run mmcboot
    ```
    
## Setting up the hardware

### Connect Camera

On this board, there is one CSI (camera) connector as shown below. 
Connect it to the [OV5640][KaiLapTech OV5640-V4320] camera module available at Gumstix.

![][CSIconnection]

## Camera Test Script
After connecting the camera and a successful boot up, login as `root`.

### Connect to the Internet
To proceed, you need to have internet access.

#### Ethernet
The one way to have Internet is through a USB to Gigabit Ethernet Adapter.

#### WiFi
To use WiFi, run: 
```
nmcli device wifi connect <Your Network Name> password <Your Network Password>
```

Note: Change ```<Your Network Name>``` and ```<Your Network Password>``` accordingly.

You also can follow the GIF below to set up the WIFI:

![][connectwifidesktop]

### Download the Script
```
$ wget https://raw.githubusercontent.com/gumstix/cameras/master/cam_gstreamer_h264_stream_imx6scm.sh
```

### Run the script
Now, run the script:
```
$ chmod a+x cam_gstreamer_h264_stream_imx6scm.sh
$ ./cam_gstreamer_h264_stream_imx6scm.sh
```
Follow the instructions in the console.

This script is an example of gstreamer code that use OV5640 camera with H264 encoding and UDP stream over Internet.

## Other Camera Test "gstreamer" Commands
### Capture one image

Run following to capture an image:
```
gst-launch-1.0 -v imxv4l2videosrc num-buffers=1 imx-capture-mode=5 device=/dev/video1 ! 'video/x-raw,width=1920,height=1080,format=I420,framerate=15/1' ! jpegenc ! filesink location=image01.jpeg
```

[CSIconnection]:wiki-pics/wiki-CSIconnection-zircon.jpg
[connectwifidesktop]:wiki-pics/wiki-connectwifi-desktop.gif

[Desktopimage]:https://drive.google.com/uc?export=download&id=1oP1155Lys49jUnnBL2BguQYLzvhjwpDd
[KaiLapTech OV5640-V4320]:https://store.gumstix.com/klt-ov5640.html
[Geppetto]:https://geppetto.gumstix.com
[OV5640 CSI-2 Test Board]:https://geppetto.gumstix.com/#!/design/2077
[5V/3.5A US Power Adapter]:https://store.gumstix.com/accessories/wall-adapters/5v35a-us-power-adapter.html
[Zircon]:https://store.gumstix.com/zircon.html
[Expansion Board Selection at Gumstix]:https://store.gumstix.com/development-boards/intel-joule-module.html

