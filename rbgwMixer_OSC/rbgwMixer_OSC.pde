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

int[] board0 = new int[4];
int[] board1 = new int[4];
int[] board2 = new int[4];
int r, g, b, w;

void setup() {
  size(400, 400);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();

  oscP5 = new OscP5(this, 5001);
}


void draw() {
 // all osc-based, hopefully we don't need draw?
}




public void oscEvent(OscMessage theOscMessage) {
  // address will tell it which board
  // all strips per board get same color
  println("/////////////////////////////");
  println(theOscMessage.arguments());
  println("/////////////////////////////");
  
  String addr = theOscMessage.addrPattern();
  
  switch(addr) {
   case "zero":
     board0[0] = (Integer) theOscMessage.arguments()[0];
     board0[1] = (Integer) theOscMessage.arguments()[1];
     board0[2] = (Integer) theOscMessage.arguments()[2];
     board0[3] = (Integer) theOscMessage.arguments()[3];
     drawStrips(board0,0);
     break;
   
   case "one":
     board1[0] = (Integer) theOscMessage.arguments()[0];
     board1[1] = (Integer) theOscMessage.arguments()[1];
     board1[2] = (Integer) theOscMessage.arguments()[2];
     board1[3] = (Integer) theOscMessage.arguments()[3];
     drawStrips(board1,1);
     break;
     
   case "two":
      board2[0] = (Integer) theOscMessage.arguments()[0];
      board2[1] = (Integer) theOscMessage.arguments()[1];
      board2[2] = (Integer) theOscMessage.arguments()[2];
      board2[3] = (Integer) theOscMessage.arguments()[3];
      drawStrips(board2,2);
      break;
    
    
  } //switch case end
  
}




public void drawStrips(int[] pixels, int board) {
  println("~~~~~~~~~~~~~~~~~~~~~~~~");
  println(pixels, board);
  println("~~~~~~~~~~~~~~~~~~~~~~~~");
  
  
  
  
  if (testObserver.hasStrips) {

    for (int j=0; j<pixels.length; j++) {
      r = pixels[0];
      g = pixels[1];
      b = pixels[2];
      w = pixels[3];
    }
    
    registry.startPushing();
    List<Strip> strips = registry.getStrips(board);
    for (Strip strip : strips) {

      int stripLength = strip.getLength();      
      for (int i=0; i<stripLength; i+=4) {
        strip.setPixel(color(g, r, b), i);
      }
      for (int i=1; i<stripLength; i+=4) {
        strip.setPixel(color(w, g, r), i);
      }
      for (int i=2; i<stripLength; i+=4) {
        strip.setPixel(color(b, w, g), i);
      }
      for (int i=3; i<stripLength; i+=4) {
        strip.setPixel(color(r, b, w), i);
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