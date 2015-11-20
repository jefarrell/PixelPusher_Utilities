
void setup() {
int result[] = translation(3, 2  );
}


// Place a Pixel and Channel in RGBW, find RGB Equivalent
int[] translation(int pixel, int channel) {
  int rgbw = 4; //pixels per channel RGBW
  int rgb = 3; //pixels per channel RGB
  
  int a = pixel * rgbw;
  int b = rgbw - channel;
  int t = a - b;

  int remainder = t % rgb;
  println(" r::::::: " + remainder);
  
  if (remainder > 0) {
    int c = (t / rgb) + 1;
    println("pixel: " + c + ", channel (r): " + remainder);
    return new int[]{c,remainder};
  } else {
    int c = t / rgb;
    println("pixel: " + c + ", channel (y): " + rgb);
    return new int[]{c,rgb};
  }
}


