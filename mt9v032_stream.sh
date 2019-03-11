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

media-ctl -r -l '"mt9v032 2-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'

media-ctl -V '"mt9v032 2-005c":0[SGRBG10 752x480], "OMAP3 ISP CCDC":2[SGRBG10 752x480], "OMAP3 ISP preview":1[YUYV2X8 752x480], "OMAP3 ISP resizer":1[YUYV2X8 752x480]'

gst-launch-1.0 -v v4l2src device=/dev/video6 ! videoconvert !rtpvrawpay ! udpsink host=$ip_addr port=6666
