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
echo "###############################################################"
echo
echo "This script will launch Gstreamer to play video streamed from "
echo "Caspa(MT9V032) or Tiny Caspa(OV7692) Camera"
echo
echo "###############################################################"
echo
echo "Select 1 for Caspa(MT9V032)"
echo "Select 2 for Tiny Caspa(OV7692)"
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

if hash gst-launch-1.0 2>/dev/null; then
    gname="gst-launch-1.0";
elif hash gst-launch 2>/dev/null; then
    gname="gst-launch";
else
    echo >&2 "Gstreamer not installed. Installing..."
    sudo apt-get update
    sudo apt-get install gstreamer1.0
    sudo apt-get install gstreamer1.0-plugins-good
    if hash gst-launch-1.0 2>/dev/null; then
        gname="gst-launch-1.0";
    elif hash gst-launch 2>/dev/null; then
        gname="gst-launch";
    fi
fi

# echo $gname
if [ $key -eq 1 ]; then
    $gname -v udpsrc port=6666 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)RAW, sampling=(string)YCbCr-4:2:2, depth=(string)8, width=(string)752, height=(string)480, colorimetry=(string)SMPTE240M, payload=(int)96" ! rtpvrawdepay ! videoconvert ! xvimagesink
elif [ $key -eq 2 ]; then
    $gname -v udpsrc port=6666 ! "application/x-rtp, sampling=(string)YCbCr-4:2:2, depth=(string)8, width=(string)640, height=(string)480" ! rtpvrawdepay ! glimagesink
fi