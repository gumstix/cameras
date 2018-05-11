#!/bin/bash
# * Copyright (C) 2018 Gumstix, Inc. - https://www.gumstix.com/
# *
# * This program is free software; you can redistribute it and/or modify
# * it under the terms of the GNU General Public License version 2 or
# * (at your option) any later version as published by the Free Software
# * Foundation.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU General Public License for more details.

set +x

destdir=~/.host_ip_addr
enter_ip () {
    echo
    echo "Please enter the host IP address:"
    read ip_addr
    touch $destdir -f
    echo "$ip_addr" > $destdir
}

if [ -f "$destdir" ]; then
    echo
    echo "The IP address you entered last time:"
    cat $destdir
    echo
    read -s -n1 -r -p "Press Space/Enter to use it, or any other key to enter a new IP..." key
    if [ "$key" = '' ]; then
        echo
        ip_addr=$(<$destdir)
    else
        enter_ip
    fi
else
    enter_ip
fi

echo -e "\nWhich resolution you want to stream?\nPlease select:
0. VGA_640_480
1. QVGA_320_240
2. NTSC_720_480
3. PAL_720_576
4. 720P_1280_720
5. 1080P_1920_1080 (currently not supported)
6. QSXGA_2592_1944 (currently not supported)
7. QCIF_176_144
8. XGA_1024_768\n"
ENTERFLAG=0
while [ $ENTERFLAG -ne 1 ]
do
    read -p "The camera you chosen [0~8]: " key
	if [ $key -ge 0 -a $key -le 8 ]
	then
		ENTERFLAG=1
	else
        echo 
		echo "### ERROR ###"
        echo "Invalid selection"
        echo
	fi
done

echo -e "Please run this command on host machine to get stream video from cam1 \n*************\n
gst-launch-1.0 udpsrc port=5000 ! application/x-rtp,encoding-name=H264,payload=96 ! rtph264depay ! h264parse ! avdec_h264 ! videoflip method=5 ! autovideosink
\n************\n"
read -p "Press anykey to start streaming at select resolution" anykey

gst-launch-1.0 -v imxv4l2videosrc imx-capture-mode=$key device=/dev/video1 ! imxvpuenc_h264 ! rtph264pay ! udpsink host=$ip_addr port=5000













