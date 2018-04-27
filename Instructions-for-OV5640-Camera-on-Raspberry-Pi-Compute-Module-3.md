# Instructions for OV5640 Camera on Raspberry Pi Compute Module 3

## Hardware
### Camera
- [KaiLapTech OV5640-V4320]
### Flasher
- [Gumstix Pi Compute FastFlash]
## Software
To prepare a SD card for the Raspberry Pi Compute Module 3, please follow the steps below:

1. Follow Instructions from raspberrypi.org [HERE][Instructions] to get ready to flash the EMMC on CM3.

Note:At Gumstix, we have a [Gumstix Pi Compute FastFlash] designed for you to flash the EMMC.

2. Download 

[Yocto Desktop Image][YoctoDesktopimage]

[Raspbian Desktop Image][RaspbianDesktopimage]

3. Extract the file 

4. Run:
```
$ sudo dd if=<name of the image.rpi-sdimg> of=<location of the SD card> bs=4M && sync
```
5. Change `<name of the image.sdcard>` to the name of the image. E.g. gumstix-xfce-image-raspberrypi-cm3.rpi-sdimg.

6. Change `<location of the SD card>` to the name of your SD card. Run, `$ lsblk` to check, it will look something like this `/dev/sdX`

This might take a while, so let's start to connect the hardware together!
## How to connect?

### Connect Camera

On this board, there are one CSI (camera) connector, connect it with one of our [KaiLapTech OV5640-V4320] sale at Gumstix.

### Connect HDMI

Connect a HDMI monitor with the HDMI port on the board.

### Connect Power
Power up the board with our [5V/3.5A US Power Adapter]

## Camera Test Script
After a successful boot up, login as "**root**".

To use the testing script, first, you need to have Internet access.
### Connect to the Internet
#### Ethernet
The  is through a USB to Gigabit Ethernet Adapter. 

### Download the Script
#### Method 1: 
Download the script to test the cameras on your console:
```
$ git clone "TODO: this repo"
$ chmod 777 cam_gstreamer_h264_stream_rpicm3.sh
```
#### Method 2:
Download the script [HERE][rpicamerascript]

### Run the script
Now, run the script as below and follow the instructions in the console:
```
$ ./cam_gstreamer_h264_stream_rpicm3.sh
```
This script is an example of gstreamer code that use OV5640 camera with H264 encoding and UDP stream over Internet.

## Other Camera Test "gstreamer" Commands
### Capture one image

Run following to capture an image:
```
gst-launch-1.0 -v v4l2src num-buffers=1 ! 'video/x-raw,width=640,height=480,format=UYVY,framerate=10/1' ! jpegenc ! filesink location=image01.jpeg

gst-launch-1.0 -v v4l2src num-buffers=1 ! 'video/x-raw,width=1920,height=1080,format=UYVY,framerate=10/1' ! jpegenc ! filesink location=image01.jpeg
```

[YoctoDesktopimage]:https://gumstix-yocto.s3.amazonaws.com/2018-04-21/raspberrypi-cm3/rocko/gumstix-xfce-image-raspberrypi-cm3.rpi-sdimg.xz
[RaspbianDesktopimage]:https://gumstix-raspbian.s3.amazonaws.com/2018-04-24/raspberrypi-cm3/rpi-4.14.y/2018-04-18-raspbian-stretch.img.xz
[KaiLapTech OV5640-V4320]:https://store.gumstix.com/cameras-displays-gps/cameras/klt-ov5640.html
[Geppetto]:https://geppetto.gumstix.com
[OV5640 CSI-2 Test Board]:https://geppetto.gumstix.com/#!/design/2077
[5V/3.5A US Power Adapter]:https://store.gumstix.com/accessories/wall-adapters/5v35a-us-power-adapter.html
[Gumstix Pi Compute FastFlash]:https://store.gumstix.com/raspberry-pi-cm-fast-flash.html
[Instructions]:https://www.raspberrypi.org/documentation/hardware/computemodule/cm-emmc-flashing.md

