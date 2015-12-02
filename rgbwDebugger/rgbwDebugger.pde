/*
John Farrell
 RGBW to RGB debugger for use with Heroic Robotics PixelPusher
 PixelPusher chipset only speaks 3 channels (RGB), but some strips are 4 channel(RGBW)
 Use this sketch to step through each channel per pixel, to determine LED order (Mine was GRBW)
 Sketch coming soon to demonstrate how to map between these ranges
*/
import controlP5.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;
DeviceRegistry registry;
TestObserver testObserver;
ControlP5 cp5;

// A couple counters
int LED = 0;
int i = 0;

void setup() {
  size(400, 400);
  cp5 = new ControlP5(this);
  // Button for easy stepping
  cp5.addButton("Next")
    .setValue(0)
      .setPosition(width/2-50, height/2-50)
        .setSize(100, 100);

  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();
}
void draw() {
  println("LEDdraw:::::::: " + LED + "  and i:::::::::: " + i);
}

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

// We want action based on button click event
public void controlEvent(ControlEvent theEvent) {
  // Array of R,G,B hex values
  int[] hexArray = {
    #ff0000, #00ff00, #0000ff
  };
  // When we cycle through array, move to next LED and return to beginning of array
  // ex: LED_1 = red, LED_1 = green, LED_1 = blue, LED_2 = red, LED_2 = green, etc.
  if (i % 3 == 0) {
    LED++;
    i = 0;
  }

  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    for (Strip strip : strips) {
      int stripLength = strip.getLength();
      // Reset all the pixels to off
      for (int p=0; p < stripLength; p++) {
        strip.setPixel(#000000, p);
      }
      // Set pixel to current place in LED & hex Array counters
      strip.setPixel(hexArray[i], LED);
    }
  }
  // Increment array position each button press
  i++;
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
