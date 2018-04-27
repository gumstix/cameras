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

# get h264 encoder name
videoencoder=`gst-inspect-1.0 --plugin | grep h264enc | awk '{print $2}'`
videoencoder=${videoencoder%?};
echo $videoencoder

set +x
# Reset all entity camera links
echo "Resetting pipeline..."
media-ctl -r -d /dev/media1
# Connect CSI0 to ISP0 to RDI0
media-ctl -d /dev/media1 -l '"msm_csiphy0":1->"msm_csid0":0[1],"msm_csid0":1->"msm_ispif0":0[1],"msm_ispif0":1->"msm_vfe0_rdi0":0[1]'
# Connect CSI1 to ISP1 to RDI1
media-ctl -d /dev/media1 -l '"msm_csiphy1":1->"msm_csid1":0[1],"msm_csid1":1->"msm_ispif1":0[1],"msm_ispif1":1->"msm_vfe0_rdi1":0[1]'
echo "Done reset"
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

echo -e "Which camera you want to stream?\n Please select:\n 1. cam0 (CSI0)\n 2. cam1 (CSI1)\n 3. cam0 and cam1"
ENTERFLAG=0
while [ $ENTERFLAG -ne 1 ]
do
    read -p "The camera you chosen [1~3]: " key
	if [ $key -eq 1 ] || [ $key -eq 2 ] || [ $key -eq 3 ]
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
echo -e "Please run this command on host machine to get stream video from cam0 \n*************\n\ngst-launch-1.0 udpsrc port=4000 ! application/x-rtp,encoding-name=H264,payload=96 ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink\n\n************\n\n"
read -p "Press anykey to start streaming using cam0" anykey
# Set the pipeline format for cam0
media-ctl -d /dev/media1 -V '"ov5640 1-0076":0[fmt:UYVY2X8/640x480 field:none],"msm_csiphy0":0[fmt:UYVY2X8/640x480 field:none],"msm_csid0":0[fmt:UYVY2X8/640x480 field:none],"msm_ispif0":0[fmt:UYVY2X8/640x480 field:none],"msm_vfe0_rdi0":0[fmt:UYVY2X8/640x480 field:none]'

# Use h264 encoder to stream for cam0
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw,format=UYVY,width=640,height=480,framerate=10/1' ! videoconvert ! $videoencoder ! h264parse ! rtph264pay ! udpsink host=$ip_addr port=4000
fi
if [ $key -eq 2 ]; then
echo -e "Please run this command on host machine to get stream video from cam1 \n*************\n\ngst-launch-1.0 udpsrc port=5000 ! application/x-rtp,encoding-name=H264,payload=96 ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink\n\n************\n\n"
read -p "Press anykey to start streaming using cam1" anykey
# Set the pipeline format for cam1
media-ctl -d /dev/media1 -V '"ov5640 1-0074":0[fmt:UYVY2X8/640x480 field:none],"msm_csiphy1":0[fmt:UYVY2X8/640x480 field:none],"msm_csid1":0[fmt:UYVY2X8/640x480 field:none],"msm_ispif1":0[fmt:UYVY2X8/640x480 field:none],"msm_vfe0_rdi1":0[fmt:UYVY2X8/640x480 field:none]'

# Use h264 encoder to stream for cam1
gst-launch-1.0 v4l2src device=/dev/video1 ! 'video/x-raw,format=UYVY,width=640,height=480,framerate=10/1' ! videoconvert ! $videoencoder ! h264parse ! rtph264pay ! udpsink host=$ip_addr port=5000

fi
if [ $key -eq 3 ]; then
echo -e "Please run this command on host machine to get stream video from cam0 and cam1 \n*************\n\ngst-launch-1.0 udpsrc port=6000 ! application/x-rtp,encoding-name=H264,payload=96 ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink\n\n************\n\n"
read -p "Press anykey to start streaming using cam0 and cam1" anykey
# Set the pipeline format for cam0
media-ctl -d /dev/media1 -V '"ov5640 1-0076":0[fmt:UYVY2X8/640x480 field:none],"msm_csiphy0":0[fmt:UYVY2X8/640x480 field:none],"msm_csid0":0[fmt:UYVY2X8/640x480 field:none],"msm_ispif0":0[fmt:UYVY2X8/640x480 field:none],"msm_vfe0_rdi0":0[fmt:UYVY2X8/640x480 field:none]'
# Set the pipeline format for cam1
media-ctl -d /dev/media1 -V '"ov5640 1-0074":0[fmt:UYVY2X8/640x480 field:none],"msm_csiphy1":0[fmt:UYVY2X8/640x480 field:none],"msm_csid1":0[fmt:UYVY2X8/640x480 field:none],"msm_ispif1":0[fmt:UYVY2X8/640x480 field:none],"msm_vfe0_rdi1":0[fmt:UYVY2X8/640x480 field:none]'
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw,format=UYVY,width=640,height=480,framerate=10/1' ! textoverlay text='CAM0' halignment=left valignment=top font-desc='Sans Italic 24' ! videomixer name=mix sink_1::xpos=640 sink_1::ypos=0 sink_1::zorder=3  ! videoconvert ! $videoencoder ! h264parse ! rtph264pay ! udpsink host=$ip_addr port=6000 v4l2src device=/dev/video1 ! 'video/x-raw,format=UYVY,width=640,height=480,framerate=10/1' ! textoverlay text='CAM1' halignment=left valignment=top font-desc='Sans Italic 24' ! mix.

fi










