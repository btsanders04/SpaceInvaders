import processing.serial.*;
Serial myPort;
int x;
int y;
boolean penDown;
int dataSize=10000;
byte[][] data = new byte[dataSize][3];
int writepointer = 0;
int readpointer=0;
void setup(){
  background(255);
  size(800,800);
  myPort = new Serial(this, "COM17");
}

void draw(){
  stroke(0);
  if(writepointer>=dataSize){
    writepointer=0;
  }
  if(mousePressed){
    x = mouseX;
    y = mouseY;
    penDown=true;
    data[writepointer][0]=(byte)(x/8);
    data[writepointer][1]=(byte)(y/8);
    if(penDown){
    data[writepointer][2]=1;
    }
    else data[writepointer][2]=0;
    println(data[writepointer][0] + " " + data[writepointer][1] + " " +  data[writepointer][2] + " " 
    + findAngle(data[writepointer][0], data[writepointer][1]));
    writepointer++;
    line(x,y,pmouseX,pmouseY);
  
  }
  else penDown=false;
  
  //System.out.println("X: " + x + " Y: " + y + " Pen: " + penDown);
}

float currentX=0;
float currentY=0;
double startAngle=0.0;

double findAngle(byte x, byte y){
 
 double theta = (atan(((float)y-currentY)/((float)x-currentX)))*(180/PI);
 double angle=theta-startAngle;
//  startAngle=theta;
  return angle;
}

void serialEvent(Serial thePort){
  thePort.read();
  if(readpointer>=dataSize){
    readpointer=0;
  }
   for(int i=0; i<3; i++){
     myPort.write(data[readpointer][i]);
   }
   readpointer++;
}
