#include <Adafruit_NeoPixel.h>
#include <Bounce2.h>
#define PIN 9
#define REED A0

// Parameter 1 = number of pixels in strip
// Parameter 2 = Arduino pin number (most are valid)
// Parameter 3 = pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
Adafruit_NeoPixel strip = Adafruit_NeoPixel(67, PIN, NEO_GRB + NEO_KHZ800);
Bounce debouncer = Bounce();
// IMPORTANT: To reduce NeoPixel burnout risk, add 1000 uF capacitor across
// pixel power leads, add 300 - 500 Ohm resistor on first pixel's data input
// and minimize distance between Arduino and first pixel.  Avoid connecting

//to hold the caculated values
int v =0;
double circ = .09; //9 cm
double rpm;
int maxRPM = 60;
int updateTime=500;
void setup(){
  strip.begin();
  pinMode(A0, INPUT_PULLUP);
  debouncer.attach(A0);
  debouncer.interval(5);
  Serial.begin(9600); 
}


void loop(){
  strip.show();
  rpm = findRevs();
//  Serial.println(rpm);
  showRpm(rpm); 
}



double findRevs(){
  double time = millis();
  double distance=circ;
  double velocity;
  int count = 0;
  while((millis()-time)<updateTime){
    debouncer.update();
    //Serial.println(debouncer.fell());
    if(debouncer.fell()) {
   //   Serial.println(1);
   //if(digitalRead(A0)==0)
      count++;
    }
  }
  Serial.println(count);
  distance = circ*count;
  velocity=distance/updateTime;
  return velocity*30000;
}


void showRpm(double x){
  for(uint16_t i =0; i<strip.numPixels()+1 ;i++){
    strip.setPixelColor(i,strip.Color(0,0,0));
  }
  uint16_t sp = map(x,0,maxRPM,0,strip.numPixels()/2);
  uint32_t green;
  uint32_t yellow;
  uint32_t red;
  green = strip.Color(0,255,0);
  red = strip.Color(255,0,0);
  yellow = strip.Color(125,125,0);
  
  for(uint16_t i=0;i<sp;i++){
    if(i<11){
      strip.setPixelColor(i, green);
      strip.setPixelColor(strip.numPixels()-i,green);
    }
    else if(i<22){
      strip.setPixelColor(i,yellow);
      strip.setPixelColor(strip.numPixels()-i,yellow);
    }
    else {
      strip.setPixelColor(i,red);
      strip.setPixelColor(strip.numPixels()-i,red);
    }
  }
}





