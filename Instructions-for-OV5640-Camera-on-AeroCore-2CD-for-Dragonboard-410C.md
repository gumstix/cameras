# Instructions for OV5640 Camera on AeroCore 2CD for Dragonboard 410C

## Hardware
- COM: [Dragonboard 410C]

- Expansion Board: [AeroCore 2CD for Dragonboard 410C] Created by [Geppetto]

- Touchscreen: [OSD 5.5" AMOLED DSI Touch Display]

- Camera: [KaiLapTech OV5640-V4320]

- SD Card (minimum 4GB)

## Software

To prepare a SD card for the dragonboard, please follow the steps below:

1. Download the ddable image [HERE][Desktopimage].

2. Extract the file.
 
3. Plug the SD card in your host machine, and run:

    ``` 
    $ sudo dd if=<name of the image.sdcard> of=<location of the SD card> bs=4M && sync
    ```

4. Change ```<name of the image.sdcard>``` to the name of the image. E.g. gumstix-xfce-image-dragonboard-410c.sdcard.

    <!--- Change this part as discussed --->
5. Change `<location of the SD card>` to the name of your SD card. Run, `$ lsblk` to check, it will look something like this `/dev/sdX`

6. Once your SD card is ready, slide it in the SD card slot of the DragonBoard 410C.

**Note**: To enable SD card boot on your [AeroCore 2CD for Dragonboard 410C], 
turn on the “SD BOOT” at S6 located at the back of the board. 

## Setting up the hardware

### Connect Cameras

On the AeroCore board, there are two CSI (camera) connectors shown in the picture below as CSI0 and CSI1.

![][CSI0CSI1connection]

#### Option 1: Connect Two Cameras 
Connect the ribbon cable attachment of the OV5640 cameras to the CSI0 and CSI1 slot. 
Make sure to connect **both** OV5640 cameras with the correct orientation as shown in the image above.
There is also an arrow next to each of the connectors to indicate the direction of the camera module.

#### Option 2: Connect One Camera

To connect just one camera requires device tree changes. Below are the pre-compiled boot-dragonboard.img for each of the camera connector:

[boot-dragonboard-410c-CSI0.img]

[boot-dragonboard-410c-CSI1.img]

Put the new modified device tree into the flashed SD card.
```
$ sudo dd if=boot-dragonboard-410c-CSI#.img of=/dev/sdX7 && sync
```    
Note: `/dev/sdX7` is the boot partition of the SD card. Change "X" according to the SD card address on your host machine.

### Connect COM (DragonBoard 410C)
Snap a dragonboard-410c on the back of the board, connect and align both the high speed connector and low speed connector.

### Connect Console, Touchscreen, or HDMI
For display, you have 2 options

1. Console with Touchscreen

2. Console with HDMI

#### To use the Console
Connect the USB-B connector located at the top-left corner of the board 
(please refer to the image above for orientation of the board), labeled as "96 CONSOLE".

#### To use the Touchscreen
Connect the ribbon cable like the picture shown below.

![][touchscreenribbonconnection]

![][DSIconnection]

#### To use the HDMI
To enable the HDMI, requires a modified device tree. Below is pre-compiled boot-dragonboard.img for each camera connector options with HDMI enabled:

[boot-dragonboard-410c-CSI0CSI1-HDMI.img]

[boot-dragonboard-410c-CSI0-HDMI.img]

[boot-dragonboard-410c-CSI1-HDMI.img]

Put the new modified device tree into the flashed SD card.
```
$ sudo dd if=boot-dragonboard-410c-CSI#-HDMI.img of=/dev/sdX7 && sync
```
Note: `/dev/sdX7` is the boot partition of the SD card. Change "X" according to the SD card address on your host machine.

### Connect Power
You have two options to power up the AeroCore:

**Option 1** Connect the power connector on the AeroCore expansion board.

**Option 2** Power up the DragonBoard through the on-board power barrel.

Let's now power up the board.

## Camera Test Script
After your board boots with either the console or touchscreen/HDMI, login as `root`.

### Connect to the Internet
To proceed, you need to have internet access.

#### Ethernet
The easiest way to have Internet is through a USB to Gigabit Ethernet Adapter. Insert an Ethernet cable on the adapter.

#### WiFi
To use WiFi, run: 
```
nmcli device wifi connect <Your Network Name> password <Your Network Password>
```
Note: Change ```<Your Network Name>``` and ```<Your Network Password>``` accordingly.

You also can follow the GIF below to set up the WIFI:

![][connectwifidesktop]

### Download the Script

Download the script to test the cameras on your console:
```
$ git clone "TODO: this repo"
$ chmod 777 cam0_cam1_gstreamer_h264_stream_dragonboard.sh
```

### Run the script
Now, run the script:
```
$ ./cam0_cam1_gstreamer_h264_stream_dragonboard.sh
```

Follow the instructions in the console.

This script is an example of gstreamer code that has options to use either one of the cameras or both cameras 
with H264 encoding and UDP stream over Internet.

## Debug Instructions
### Check if one or both cameras get probed properly
Run the command below to display the entities of the GPU source.
```
$ media-ctl -p -d /dev/media1
```
If you have two cameras connected properly, it should display something that looks like this:
```
...
- entity 46: msm_vfe0_pix (2 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev9
	pad0: Sink
		[fmt:UYVY2X8/1920x1080 field:none
		 compose.bounds:(0,0)/1920x1080
		 compose:(0,0)/1920x1080]
		<- "msm_ispif0":1 []
		<- "msm_ispif1":1 []
	pad1: Source
		[fmt:UYVY2X8/1920x1080 field:none
		 crop.bounds:(0,0)/1920x1080
		 crop:(0,0)/1920x1080]
		-> "msm_vfe0_video3":0 [ENABLED,IMMUTABLE]

- entity 49: msm_vfe0_video3 (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "msm_vfe0_pix":1 [ENABLED,IMMUTABLE]

- entity 87: ov5640 1-0074 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev10
	pad0: Source
		[fmt:UYVY2X8/1920x1080 field:none
		 crop:(0,0)/1920x1080]
		-> "msm_csiphy1":0 [ENABLED,IMMUTABLE]

- entity 89: ov5640 1-0076 (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev11
	pad0: Source
		[fmt:UYVY2X8/1920x1080 field:none
		 crop:(0,0)/1920x1080]
		-> "msm_csiphy0":0 [ENABLED,IMMUTABLE]


```
Note: If you can see ```entity 87: ov5640 1-0074``` (CSI1 connector) and ```entity 89: ov5640 1-0076``` 
(CSI0 connector), it means the corresponding cameras got probed properly.

## Other Camera Test "gstreamer" Commands

### Capture one image
Set up the pipeline:
```
media-ctl -d /dev/media1 -l '"msm_csiphy0":1->"msm_csid0":0[1],"msm_csid0":1->"msm_ispif0":0[1],"msm_ispif0":1->"msm_vfe0_pix":0[1]'
```
Note: in the command below, change ```"ov5640 1-0076"``` value according to which camera you want to capture or you have connected. As mentioned in the Debug Instruction,```entity 87: ov5640 1-0074``` (CSI1 connector) and ```entity 89: ov5640 1-0076``` (CSI0 connector)
```
media-ctl -d /dev/media1 -V '"ov5640 1-0076":0[fmt:UYVY2X8/1920x1080 field:none],"msm_csiphy0":0[fmt:UYVY2X8/1920x1080 field:none],"msm_csid0":0[fmt:UYVY2X8/1920x1080 field:none],"msm_ispif0":0[fmt:UYVY2X8/1920x1080 field:none],"msm_vfe0_pix":0[fmt:UYVY2X8/1920x1080 field:none compose:(0,0)/640x480],"msm_vfe0_pix":1[fmt:UYVY1_5X8/640x480 field:none]'
```


Then run following to capture an image:
```
gst-launch-1.0 -v v4l2src device=/dev/video3 num-buffers=1 ! 'video/x-raw,format=NV12,width=640,height=480,framerate=10/1' ! jpegenc ! filesink location=image01.jpeg
```

[CSI0CSI1connection]:https://drive.google.com/uc?export=download&id=1mBTSX3BOvVuXx213ZbPycV1IvrNaF0P4
[Desktopimage]:https://gumstix-yocto.s3.amazonaws.com/2018-04-09/dragonboard-410c/morty/gumstix-xfce-image-dragonboard-410c.sdcard.xz
[touchscreenribbonconnection]:https://drive.google.com/uc?export=download&id=1MxzTuzKVY6Ow0QLZNe9Zwv8ggt1N5Oa8
[DSIconnection]:https://drive.google.com/uc?export=download&id=1UqQDlGw09q8Ule2mU_YBv40ZpUbamQrk
[OSD 5.5" AMOLED DSI Touch Display]:https://store.gumstix.com/cameras-displays-gps/displays/osd-55-dsi-display.html
[Dragonboard 410C]:https://developer.qualcomm.com/hardware/dragonboard-410c
[AeroCore 2CD for Dragonboard 410C]:https://store.gumstix.com/aerocore-2cd-for-dragonboard.html
[KaiLapTech OV5640-V4320]:https://store.gumstix.com/cameras-displays-gps/cameras/klt-ov5640.html
[connectwifidesktop]:https://drive.google.com/uc?export=download&id=1wQaEA5u9SfyQmCFenQMvm9WTe1Mk_LPE
[Geppetto]:https://geppetto.gumstix.com
[boot-dragonboard-410c-CSI0.img]:https://drive.google.com/uc?export=download&id=1XLfy2qN2aDdnGmqAiqj7r1Gb8_aI-C5E
[boot-dragonboard-410c-CSI1.img]:https://drive.google.com/uc?export=download&id=1SivOCNsRHfqXv90Z5oS1y89YAK14yRQ_
[boot-dragonboard-410c-CSI0CSI1-HDMI.img]:https://drive.google.com/uc?export=download&id=1nYiV7cwA2u6ljf0an7C1Fa9mr147_GsO
[boot-dragonboard-410c-CSI0-HDMI.img]:https://drive.google.com/uc?export=download&id=1fBFg0fQxLaYLmlPFeGX0cfEABimt64l2
[boot-dragonboard-410c-CSI1-HDMI.img]:https://drive.google.com/uc?export=download&id=1VtlLTn76o_DApByEdkY5yP8_Pff3F6SV

