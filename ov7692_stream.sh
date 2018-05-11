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

modprobe omap3-isp

media-ctl -r -l '"OV7692":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'

media-ctl -V '"OV7692":0[SGRBG8 640x480], "OMAP3 ISP CCDC":2[SGRBG8 640x480], "OMAP3 ISP preview":1[UYVY 640x480], "OMAP3 ISP resizer":1[UYVY 640x480]'

$gname -v v4l2src device=/dev/video6 ! rtpvrawpay ! udpsink host=$ip_addr port=6666
