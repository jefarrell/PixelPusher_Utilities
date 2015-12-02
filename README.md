# PixelPusher_Utilities
##Utility sketches for use with Heroic Robotics PixelPusher

Attemping to put a few sketches together for working with the Heroic Robotics [PixelPusher](heroicrobotics.com/products/pixelpusher).

I found documentation to be few and far between, so hopefully these can be of some use.
***
#### RGB Mixer
The RGB mixer is a simple 3-knob color mixer to show the color range on 3-channel RGB LED strips.

#### RGBW Debugger
The RGBW debugger is a debugger for working with 4-channel RGBW strips.  The PixelPusher can only speak 3-channel, but with a little trickery, you can make it speak 4-channel.
This sketch is to help determine the order of your channels.  While in theory they should be R-G-B-W, in practice many are not.
Use this sketch to step through channel by channel, pixel by pixel to determine order.
***
#### RGBW Mixer
A way to make the PixelPusher communicate with a 4-channel LED strip (RGBW).  Because the PixelPusher only communicates with 3-channel strips, there is some work to do to set the right order.  Using the RGBW debugger to find the order of your pixels is an important first step. The pixels follow a pattern which repeats every 4 pixels.
***
