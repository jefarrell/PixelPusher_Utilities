
// Import HeroicRobot and ControlP5
import controlP5.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

// PixelPusher classes and knobs
//DeviceRegistry registry;
//TestObserver testObserver;
ControlP5 cp5;
Knob Rknob;
Knob Gknob;
Knob Bknob;
Knob Wknob;
int bgColor = #3B3B3B;
int radius = 100;
int counter;
int buttonCount = 2;

int[] button_1 = new int[4];
int[] button_2 = new int[4];
int[] button_3 = new int[4];

HashMap<String, int[]> m1 = new HashMap<String, int[]>();




/*
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
 */


public void mapMaker() {
  m1.put("one", button_1);
  m1.put("two", button_2);
}

// Setup controlP5 knobs
void setup() {
  mapMaker();
  size(1300, 500);
  //  registry = new DeviceRegistry();
  //  testObserver = new TestObserver();
  //  registry.addObserver(testObserver);
  //  prepareExitHandler();
  cp5 = new ControlP5(this);

  int h = height/4; 
  int spacing = 300;


  /* 
   
   MAKE KNOBS
   
   */

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


  /* 
   
   MAKE BUTTONS
   
   */
  color white = color(255);
  color black = color(0);

  cp5.addButton("one")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(100, 450)
          .setSize(100, 30)
            .setColorBackground(white);

  cp5.addButton("two")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(300, 450)
          .setSize(100, 30)
            .setColorBackground(white);
}


//  An event that runs every time a button value changes  
///  This includes on sketch load
///  Therefore, we need some checking mechanisms
/////  First, a counter to negate the control events on sketch load
/////  Then, we want to discount events from the color knobs
public void controlEvent(ControlEvent theEvent) {
  String controlNum = theEvent.getController().getName();
  boolean checker = controlNum.endsWith("knob");
  if (counter < buttonCount) {
  } else {
    if (!checker) {
      float buttonSwitch = cp5.getController(controlNum).getValue();
      println("before: " + cp5.getController(controlNum).getValue());
      if (buttonSwitch == 0.0) {
        cp5.getController(controlNum).setBroadcast(false);
        cp5.getController(controlNum).setValue(1.0);
        cp5.getController(controlNum).setBroadcast(true);
      };
      println("after: " + theEvent.getController().getValue());
      buttonClick(controlNum);
    }
  }
  counter++;
}



//  Handle button clicks
//  First, the button click needs to save the current values
///  Then, more clicks on that same button need to recall those values
public void buttonClick (String buttonNum) {
  println("clicked button " + buttonNum);
  int redVal = int(cp5.getController("red_knob").getValue());
  int greenVal = int(cp5.getController("green_knob").getValue());
  int blueVal = int(cp5.getController("blue_knob").getValue());
  int whiteVal = int(cp5.getController("white_knob").getValue());

  int[] temp = m1.get(buttonNum);
  temp[0] = redVal;
  temp[1] = greenVal;
  temp[2] = blueVal;
  temp[3] = whiteVal;

  println("button 1: " + button_1[0], button_1[1], button_1[2], button_1[3]);
  println("button 2: " + button_2[0], button_2[1], button_2[2], button_2[3]);
  
  
  
  float buttonSwitch = cp5.getController(buttonNum).getValue();

  color gray = color(125);
  if (buttonSwitch == 1.0) {
    cp5.getController(buttonNum).setColorBackground(gray);
    println("buttonSwitch: " + buttonSwitch);
  }
  
  
}




//  Set knobs to values stored in each button
public void valueSet(String buttonNum) {
  int vals[] = m1.get(buttonNum);
  cp5.getController("red_knob").setValue(vals[0]);
  cp5.getController("green_knob").setValue(vals[1]);
  cp5.getController("blue_knob").setValue(vals[2]);
  cp5.getController("white_knob").setValue(vals[3]);
}







void draw() {
  background(#000000);
  // Get the values from our 4 knobs
  int r = int(Rknob.value());
  int g = int(Gknob.value());
  int b = int(Bknob.value());
  int w = int(Wknob.value());

  // Display slider Values
  textSize(50);
  fill(r, 0, 0, 150);
  text(r, Rknob.getPosition()[0]+radius/2, 75);
  fill(0, g, 0, 150);
  text(g, Gknob.getPosition()[0]+radius/2, 75);
  fill(0, 0, b, 150);
  text(b, Bknob.getPosition()[0]+radius/2, 75);
  fill(w, 150);
  text(w, Wknob.getPosition()[0]+radius/2, 75);


  /*

   
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


  /*
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
   
   */
}



/*

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
 
 
 */
