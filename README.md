# PixelPusher_Utilities
##Utility sketches for use with Heroic Robotics PixelPusher

Attemping to put a few sketches together for working with the Heroic Robotics [PixelPusher](heroicrobotics.com/products/pixelpusher).

I found documentation to be few and far between, so hopefully these can be of some use.

#### RGB Mixer
The RGB mixer is a simple 3-knob color mixer to show the color range on 3-channel RGB LED strips.

#### RGBW Stepper
The RGBW stepper is a debugger for working with 4-channel RGBW strips.  The PixelPusher can only speak 3-channel, but with a little trickery, you can make it speak 4-channel.
This sketch is to help determine the order of your channels.  While in theory they should be R-G-B-W, in practice many are not.
Use this sketch to step through channel by channel, pixel by pixel to determine order.

More coming soon.
