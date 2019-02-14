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
# Reset all entity camera links
echo "Resetting pipeline..."
# Below doesn't work... sad
if [ -b /dev/media0 ];then
	echo "Media device does not exist. Has the camera system been connected correctly?"
	exit 1
fi
media-ctl -r -d /dev/media0
# Connect CSI0 to ISP0 to RDI0
media-ctl -d /dev/media0 -l '"msm_csiphy0":1->"msm_csid0":0[1],"msm_csid0":1->"msm_ispif0":0[1],"msm_ispif0":1->"msm_vfe0_rdi0":0[1]'
# Connect CSI1 to ISP1 to RDI1
media-ctl -d /dev/media0 -l '"msm_csiphy1":1->"msm_csid1":0[1],"msm_csid1":1->"msm_ispif1":0[1],"msm_ispif1":1->"msm_vfe0_rdi1":0[1]'
echo "Done reset"

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
read -p "Press anykey to start streaming using cam0" anykey
# Set the pipeline format for cam0
media-ctl -d /dev/media0 -V '"ov5640 4-003b":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csiphy0":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csid0":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_ispif0":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_vfe0_rdi0":0[fmt:UYVY8_2X8/1920x1080 field:none]'

# Use h264 encoder to stream for cam0
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw,format=UYVY,width=1920,height=1080,framerate=10/1' ! glimagesink
fi

if [ $key -eq 2 ]; then
read -p "Press anykey to start streaming using cam1" anykey
# Set the pipeline format for cam1
media-ctl -d /dev/media0 -V '"ov5640 4-003a":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csiphy1":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csid1":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_ispif1":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_vfe0_rdi1":0[fmt:UYVY8_2X8/1920x1080 field:none]'

# Use h264 encoder to stream for cam1
gst-launch-1.0 v4l2src device=/dev/video1 ! 'video/x-raw,format=UYVY,width=1920,height=1080,framerate=10/1' ! glimagesink

fi

if [ $key -eq 3 ]; then
read -p "Press anykey to start streaming using cam0 and cam1" anykey
# Set the pipeline format for cam0
media-ctl -d /dev/media0 -V '"ov5640 4-003b":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csiphy0":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csid0":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_ispif0":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_vfe0_rdi0":0[fmt:UYVY8_2X8/1920x1080 field:none]'
# Set the pipeline format for cam1
media-ctl -d /dev/media0 -V '"ov5640 4-003a":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csiphy1":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_csid1":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_ispif1":0[fmt:UYVY8_2X8/1920x1080 field:none],"msm_vfe0_rdi1":0[fmt:UYVY8_2X8/1920x1080 field:none]'

# Use h264 encoder to stream for cam0 and cam1
gst-launch-1.0 v4l2src device=/dev/video0 ! 'video/x-raw,format=UYVY,width=1920,height=1080,framerate=10/1' ! textoverlay text='CAM0' halignment=left valignment=top font-desc='Sans Italic 24' ! videomixer name=mix sink_1::xpos=0 sink_1::ypos=1080 sink_1::zorder=3  ! glimagesink v4l2src device=/dev/video1 ! 'video/x-raw,format=UYVY,width=1920,height=1080,framerate=10/1' ! textoverlay text='CAM1' halignment=left valignment=top font-desc='Sans Italic 24' ! mix.

fi
