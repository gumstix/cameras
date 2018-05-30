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

clear
destdir=~/.host_ip_addr

enter_ip () {
    echo
    echo "Please enter the host IP address:"
    read ip_addr
    touch $destdir -f
    echo "$ip_addr" > $destdir
}

if hash gst-launch-1.0 2>/dev/null; then
    gname="gst-launch-1.0";
elif hash gst-launch 2>/dev/null; then
    gname="gst-launch";
else
    echo >&2 "Gstreamer not installed. Installing..."
    smart update
    yes | smart install gstreamer1.0
    yes | smart install gstreamer1.0-plugins-good
    if hash gst-launch-1.0 2>/dev/null; then
        gname="gst-launch-1.0";
    elif hash gst-launch 2>/dev/null; then
        gname="gst-launch";
    fi
fi

# echo $gname
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

echo "###############################################################"
echo
echo "Are you running Tiny Caspa Camera on"
echo "Overo COMs or Poblano?"
echo
echo "###############################################################"
echo
echo "Select 1 for Overo COMs"
echo "Select 2 for Poblano"
echo

ENTERFLAG=0
while [ $ENTERFLAG -ne 1 ]
do
    read -p "The camera you chosen [1/2]: " key
    if [ $key -eq 1 ] || [ $key -eq 2 ]
    then
        ENTERFLAG=1
    else
        echo 
        echo "### ERROR ###"
        echo "Invalid selection"
        echo
    fi
done

if [ $key -eq 1 ]; then
    echo -e """Please run this command on host machine to get stream video \n*************\n\ngst-launch-1.0 udpsrc port=6666 ! \"application/x-rtp, sampling=(string)YCbCr-4:2:2, depth=(string)8, width=(string)640, height=(string)480\" ! rtpvrawdepay ! glimagesink\n\n************\n\n"
    read -p "Press anykey to start streaming using Tiny Caspa Camera with Overo COMs" anykey
    media-ctl -r -l '"OV7692":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
    media-ctl -V '"OV7692":0[YUYV2X8 640x480], "OMAP3 ISP CCDC":1[YUYV2X8 640x480]'
    $gname -v v4l2src device=/dev/video2 ! 'video/x-raw, width=640, height=480,format=YUY2, framerate=10/1' ! videoconvert ! rtpvrawpay ! udpsink host=$ip_addr port=6666
elif [ $key -eq 2 ]; then
    echo -e """Please run this command on host machine to get stream video \n*************\n\ngst-launch-1.0 udpsrc port=6666 ! \"application/x-rtp, sampling=(string)YCbCr-4:2:2, depth=(string)8, width=(string)640, height=(string)480\" ! rtpvrawdepay ! glimagesink\n\n************\n\n"
    read -p "Press anykey to start streaming using Tiny Caspa Camera with Poblano" anykey
    $gname -v v4l2src ! videoconvert ! rtpvrawpay ! udpsink host=$ip_addr port=6666
fi
