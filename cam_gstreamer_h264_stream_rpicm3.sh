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
1. VGA_640_480
2. 720P_1280_720
3. 1080P_1920_1080\n"
ENTERFLAG=0
while [ $ENTERFLAG -ne 1 ]
do
    read -p "The camera you chosen [1~3]: " key
	if [ $key -ge 1 -a $key -le 3 ]
	then
		ENTERFLAG=1
	else
        echo 
		echo "### ERROR ###"
        echo "Invalid selection"
        echo
	fi
done
width=0
height=0
if [ $key -eq 1 ]; then
	width=640
	height=480
fi
if [ $key -eq 2 ]; then
	width=1280
	height=720
fi
if [ $key -eq 3 ]; then
	width=1920
	height=1080
fi

echo -e "Please run this command on host machine to get stream video from camera \n*************\n
gst-launch-1.0 udpsrc port=5000 ! application/x-rtp,clock-rate=90000,encoding-name=H263-1998,payload=96 ! rtph263pdepay ! h263parse ! avdec_h263 ! videoflip method=5 ! autovideosink sync=false
\n************\n"
read -p "Press anykey to start streaming at select resolution "$width"x"$height anykey

gst-launch-1.0 -v v4l2src ! 'video/x-raw,width='$width',height='$height',format=UYVY,framerate=15/1' ! videoconvert ! avenc_h263p ! h263parse ! rtph263ppay ! udpsink host=$ip_addr port=5000
