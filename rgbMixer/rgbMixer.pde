/*
John Farrell
 Simple RBG color mixer for use with Heroic Robotics PixelPusher
 Assumes you are working with 3-channel RGB pixel strips
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
int bgColor = #3B3B3B;

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

void setup() {
  size(700, 400);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();
  cp5 = new ControlP5(this);
  int dist = 125;
  
  Rknob = cp5.addKnob("red_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(dist, height/2)
          .setRadius(50)
            .setColorBackground(#943232)
              .setColorForeground(bgColor)
                .setColorActive(#ffffff)
                  .setDragDirection(Knob.VERTICAL);

  Gknob = cp5.addKnob("green_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(dist*2, height/2)
          .setRadius(50)
            .setColorBackground(#559e83)
              .setColorForeground(bgColor)
                .setColorActive(#ffffff)
                  .setDragDirection(Knob.VERTICAL);

  Bknob = cp5.addKnob("blue_knob")
    .setRange(0, 255)
      .setValue(0)
        .setPosition(dist*3, height/2)
          .setRadius(50)
            .setColorBackground(#326194)
              .setColorForeground(bgColor)
                .setColorActive(#ffffff)
                  .setDragDirection(Knob.VERTICAL);

}

void draw() {
  background(bgColor);
  // Get values from each knob
  float r = Rknob.value();
  float g = Gknob.value();
  float b = Bknob.value();

  // Create color from 3 values
  color c = color(r, g, b);
  // Make a hex string out of it
  String hexVal = hex(c);
  textSize(50);
  fill(c);
  text(hexVal, width/2, height/5);

  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    for (Strip strip : strips) {
      // Set every pixel to the color we are mixing
      for (int i = 1; i < strip.getLength (); i++) {
        strip.setPixel(c, i);
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

