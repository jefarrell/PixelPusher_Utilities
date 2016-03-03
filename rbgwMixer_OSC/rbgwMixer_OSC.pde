// Import HeroicRobot and ControlP5
import oscP5.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;
OscP5 oscP5;

// PixelPusher classes and knobs
DeviceRegistry registry;
TestObserver testObserver;
int[] zone0 = new int[4];
int[] zone1 = new int[4];
int[] zone2 = new int[4];
int r, g, b, w;

// Setup controlP5 knobs
void setup() {
  size(400, 400);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();

  oscP5 = new OscP5(this, 5001);
  int h = height/4; 
  int spacing = 300;
}


void draw() {
  background(#000000);
  
  fill(255);
  text(zone0[0] + ", " + zone0[1]+ ", " + zone0[2]+ ", " + zone0[3], 100, 100);
  
  drawStrips(zone0);
  //drawStrips(zone1);
  //drawStrips(zone2);
}




public void oscEvent(OscMessage theOscMessage) {
  // zone will tell it which board
  // separate port for strip?
  // then get RGBW values, use those to set knob
  // probably use a global array?
  println(theOscMessage.arguments());
  for (int i = 0; i < theOscMessage.arguments().length; i++) {
    zone0[0] = (Integer) theOscMessage.arguments()[0];
    zone0[1] = (Integer) theOscMessage.arguments()[1];
    zone0[2] = (Integer) theOscMessage.arguments()[2];
    zone0[3] = (Integer) theOscMessage.arguments()[3];
    //zone1[0] = (Integer) theOscMessage.arguments()[4];
    //zone1[1] = (Integer) theOscMessage.arguments()[5];
    //zone1[2] = (Integer) theOscMessage.arguments()[6];
    //zone1[3] = (Integer) theOscMessage.arguments()[7];
    //zone2[0] = (Integer) theOscMessage.arguments()[8];
    //zone2[1] = (Integer) theOscMessage.arguments()[9];
    //zone2[2] = (Integer) theOscMessage.arguments()[10];
    //zone2[3] = (Integer) theOscMessage.arguments()[11];
  }
}


public void drawStrips(int[] pixels) {
  if (testObserver.hasStrips) {

    for (int j=0; j<pixels.length; j++) {
      r = pixels[0];
      g = pixels[1];
      b = pixels[2];
      w = pixels[3];
    }

    //println("/////////////////////////////");
    //println(r,g,b,w);
    //println("/////////////////////////////");
    
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    for (Strip strip : strips) {
      
      
      int stripLength = strip.getLength();
      
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