Welcome to the cameras wiki!

My first commit will include this command for safe keeping:


`gst-launch-1.0 v4l2src device=/dev/video3 ! 'video/x-raw,format=NV12,width=640,height=480,framerate=10/1' ! videoconvert ! v4l2video5h264enc ! filesink location=file.mkv`

This works for OV5640 cameras with Dragonboard 410c using AutoBSP device trees for streaming H.264 video at 1080p.  We will be adding more descriptive instructions for various platforms very soon.