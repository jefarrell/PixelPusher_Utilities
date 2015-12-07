/*
John Farrell
 RGBW color mixer for use with Heroic Robotics PixelPusher
 Works to spoof the PixelPusher to work with 4-channel LEDs instead of 3-channel
 The pattern of the LEDs is most important - check out the RGBW debugger sketch to find out
 My LED strip was G-R-B-W, so adjust accordingly
 */

// Import HeroicRobot and ControlP5
import controlP5.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

// PixelPusher classes and knobs
DeviceRegistry registry;
TestObserver testObserver;
ControlP5 cp5;
Knob Rknob;
Knob Gknob;
Knob Bknob;
Knob Wknob;
int bgColor = #3B3B3B;
int radius = 100;

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
    println("Registry changed!");
    if (updatedDevice != null) {
      println("Device change: " + updatedDevice);
    }
    this.hasStrips = true;
  }
}

// Setup controlP5 knobs
void setup() {
  size(1300, 400);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();
  cp5 = new ControlP5(this);

  int h = height/4; 
  int spacing = 300;

  Rknob = cp5.addKnob("red_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(radius, h)
          .setRadius(radius)
            .setColorBackground(#943232)
              .setLabelVisible(false)
                .setColorForeground(#000000)
                  .setColorActive(#ffffff)
                    .setDragDirection(Knob.VERTICAL);

  Gknob = cp5.addKnob("green_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(radius+spacing, h)
          .setRadius(radius)
            .setColorBackground(#559e83)
              .setLabelVisible(false)
                .setColorForeground(#000000)
                  .setColorActive(#ffffff)
                    .setDragDirection(Knob.VERTICAL);

  Bknob = cp5.addKnob("blue_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(radius+2*spacing, h)
          .setRadius(radius)
            .setColorBackground(#326194)
              .setLabelVisible(false)
                .setColorForeground(#000000)
                  .setColorActive(#ffffff)
                    .setDragDirection(Knob.VERTICAL);

  Wknob = cp5.addKnob("white_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(radius+3*spacing, h)
          .setRadius(radius)
            .setColorBackground(#ffffff)
              .setLabelVisible(false)
                .setColorForeground(#000000)
                  .setColorActive(#C9C9C9)
                    .setDragDirection(Knob.VERTICAL);
}


void draw() {
  background(#000000);
  // Get the values from our 4 knobs
  int r = int(Rknob.value());
  int g = int(Gknob.value());
  int b = int(Bknob.value());
  int w = int(Wknob.value());
  
  // Display UI Values
  textSize(50);
  fill(r, 0, 0, 150);
  text(r, Rknob.getPosition()[0]+radius/2, 75);
  fill(0, g, 0, 150);
  text(g, Gknob.getPosition()[0]+radius/2, 75);
  fill(0, 0, b, 150);
  text(b, Bknob.getPosition()[0]+radius/2, 75);
  fill(w, 150);
  text(w, Wknob.getPosition()[0]+radius/2, 75);

  // If we have strips
  //// Start pushing pixels
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    for (Strip strip : strips) {
      int stripLength = strip.getLength();
      /* 
         // PATTERN - most important part to figure out
         // The pattern resets every 4 LEDs
         // 4 channels to 3 channels, 12 steps = 4 pixels
         strip.setPixel(color(r,g,b),0);
         strip.setPixel(color(g,w,r),1);
         strip.setPixel(color(w,b,g),2);
         strip.setPixel(color(b,r,w),3);
      */

      // This is inelegant, but it works for now.  Working to clean up
      for (int i=0; i<stripLength; i+=4) {
        strip.setPixel(color(r, g, b), i);
      }
      for (int i=1; i<stripLength; i+=4) {
        strip.setPixel(color(g, w, r), i);
      }
      for (int i=2; i<stripLength; i+=4) {
        strip.setPixel(color(w, b, g), i);
      }
      for (int i=3; i<stripLength; i+=4) {
        strip.setPixel(color(b, r, w), i);
      }
    }
  }
}

private void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run () {
      System.out.println("Shutdown hook running");
      List<Strip> strips = registry.getStrips();
      for (Strip strip : strips) {
        for (int i=0; i<strip.getLength (); i++)
          strip.setPixel(#000000, i);
      }
      for (int i=0; i<100000; i++)
        Thread.yield();
    }
  }
  ));
}

