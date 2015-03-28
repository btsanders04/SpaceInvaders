import processing.serial.*;
Serial myPort;

PImage bg;
PImage ship;
int shipSize=50;
int x;
boolean loaded;
void setup(){
  bg = loadImage("space-background.jpg");
  ship = loadImage("spaceship-new.png");
  size(bg.width,bg.height);
  myPort = new Serial(this, "COM17");
  
}


void draw(){
  
  image(bg,0,0,width,height);
  image(ship,x,height-shipSize,shipSize,shipSize);  
  println(x);
  if(loaded){
  drawBullet();
  }
}


void serialEvent(Serial thePort) {
int xdata = thePort.read();
x = (int) map(xdata,0,255,0,width);

}

void mousePressed(){
  
  loaded=true;
  
}

void drawBullet(){
  int bulletx=x+ship.width/2;
  int dy = height-shipSize;
  fill(255,0,0);
  strokeWeight(5);
  line(bulletx,dy,bulletx,dy+10);
  
}
