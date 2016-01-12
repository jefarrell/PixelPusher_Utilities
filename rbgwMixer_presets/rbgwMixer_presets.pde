
// Import HeroicRobot and ControlP5
import controlP5.*;
import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;
JSONObject json;
PrintWriter output;
JSONArray values;

//PixelPusher classes and knobs
DeviceRegistry registry;
TestObserver testObserver;
ControlP5 cp5;

Knob Rknob;
Knob Gknob;
Knob Bknob;
Knob Wknob;

int radius = 100;
int counter;
int buttonCount = 10;


// Arrays for each button to store values
int[] button_1 = new int[4];
int[] button_2 = new int[4];
int[] button_3 = new int[4];
int[] button_4 = new int[4];
int[] button_5 = new int[4];
int[] button_6 = new int[4];
int[] button_7 = new int[4];
int[] button_8 = new int[4];
int[] button_9 = new int[4];
int[] button_10 = new int[4];

// Hashmap - this will store all of the button values we save
HashMap<String, int[]> m1 = new HashMap<String, int[]>();



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


// Make our hashmap
public void mapMaker() {
  m1.put("one", button_1);
  m1.put("two", button_2);
  m1.put("three", button_3);
  m1.put("four", button_4);
  m1.put("five", button_5);
  m1.put("six", button_6);
  m1.put("seven", button_7);
  m1.put("eight", button_8);
  m1.put("nine", button_9);
  m1.put("ten", button_10);
}


// Setup controlP5 knobs
void setup() {
  mapMaker();
  size(1300, 500);
  int bgColor = #3B3B3B;
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  prepareExitHandler();
  cp5 = new ControlP5(this);

  int h = height/4; 
  int spacing = 300;


  /* 
   
   MAKE KNOBS  ///////////////////////////
   
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
   
   MAKE BUTTONS  ///////////////////////////
   
   */
  color white = color(255);
  color black = color(0);
  int buttonW = 75;
  int buttonH = 30;
  int buttonY = 400;
  int bSpace = 150;
  int w = 100;

  cp5.addButton("one")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);

  cp5.addButton("two")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);

  cp5.addButton("three")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+2*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);

  cp5.addButton("four")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+3*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);

  cp5.addButton("five")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+4*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);

  cp5.addButton("six")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+5*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);


  cp5.addButton("seven")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+6*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);


  cp5.addButton("eight")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+7*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);


  cp5.addButton("nine")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+8*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);


  cp5.addButton("ten")
    .setColorCaptionLabel(black)
      .setValue(0)
        .setPosition(bSpace+9*w, buttonY)
          .setSize(buttonW, buttonH)
            .setColorBackground(white);
};



//  ControlEvent runs every time a button value changes  
//  This includes on sketch load
//  Therefore, we need some checking mechanisms
public void controlEvent(ControlEvent theEvent) {
  String controlNum = theEvent.getController().getName();
  boolean checker = controlNum.endsWith("knob");
  float buttonSwitch = cp5.getController(controlNum).getValue();

  // Negates events that happen on sketch load
  if (counter < buttonCount) {
  } else {
    // Make sure it's a button, not a knob
    if (!checker) {
      // First time the button is clicked?
      if (buttonSwitch == 0.0) {
        cp5.getController(controlNum).setBroadcast(false);
        cp5.getController(controlNum).setValue(1.0);
        cp5.getController(controlNum).setBroadcast(true);
        initialClick(controlNum);
      } else {
        // Button has been clicked before
        valueRecall(controlNum);
      };
    };
  };
  counter++;
};



//  Handle first button click
//  Change the color, then save the current values of the knobs to our hashmap
public void initialClick (String buttonNum) {
  color gray = color(125);
  cp5.getController(buttonNum).setColorBackground(gray);

  int redVal = int(cp5.getController("red_knob").getValue());
  int greenVal = int(cp5.getController("green_knob").getValue());
  int blueVal = int(cp5.getController("blue_knob").getValue());
  int whiteVal = int(cp5.getController("white_knob").getValue());

  int[] temp = m1.get(buttonNum);
  temp[0] = redVal;
  temp[1] = greenVal;
  temp[2] = blueVal;
  temp[3] = whiteVal;
}


//  If the button has already been clicked 
//  Recall the knob values that we have stored in our hashmap
public void valueRecall(String buttonNum) {
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



  //  Quick n dirty saving - easier than adding another cp5 button
  fill(255);
  if (mouseX > 1200 && mouseX < 1275 && mouseY > 25 && mouseY < 100) {
    fill(0, 116, 217);
  }
  rect(1200, 25, 75, 75);
  textSize(15);
  fill(0);
  text("Save", 1222, 70);
}

void mouseClicked() {
  if (mouseX > 1200 && mouseX < 1275 && mouseY > 25 && mouseY < 100) {
    saveJSON();
  }
}

public void saveJSON() {
  // Read color value entries in hashmap, create array of JSON objects
  values = new JSONArray();
  int i = 0;
  for (Map.Entry m : m1.entrySet ()) {
    JSONObject colorValues = new JSONObject();
    int[] gVal = (int[]) m.getValue();
    String gKey = (String) m.getKey();

    colorValues.setInt("red", gVal[0]);
    colorValues.setInt("green", gVal[1]);
    colorValues.setInt("blue", gVal[2]);
    colorValues.setInt("white", gVal[3]);
    colorValues.setString("button number", gKey);

    values.setJSONObject(i, colorValues);
    i++;
  };
  // Make a timestamp to avoid overwriting
  Calendar now = Calendar.getInstance();
  String timestamp = String.format("%1$tm%1$td%1$ty_%1$tH%1$tM%1$tS", now);

  saveJSONArray(values, "colors_" + timestamp +".json");
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

