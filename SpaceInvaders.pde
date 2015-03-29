import processing.serial.*;
Serial myPort;

PImage bg;
Alien a;
Defender d;

void setup(){
  bg = loadImage("space-background.jpg");  
  size(bg.width,bg.height);
 // myPort = new Serial(this, "COM17");
  a = new Alien(50,10);
  d = new Defender();
}


void draw(){
  
  image(bg,0,0,width,height);
  a.updateAlien();
  d.updateDefender();
}





/*void serialEvent(Serial thePort) {
int xdata = thePort.read();
x = (int) map(xdata,0,255,0,width);

}
*/
void mousePressed(){
  
 // loaded=true;
  
}
