import processing.serial.*;
Serial myPort;
int x;
int y;
int counter=0;
float currentX=0;
float currentY=0;
float startAngle=0.0;
Serial bluetooth;
float angTime;
float magTime;
int direction;
//size of paper
int pLength;
int pWidth;

//Command string that comes from the Arduino
int cmd;

//background img
PImage bg;

//if pen is down or not;
int penDown;

//tells arduino how much to move
float turnTime;
float driveTime=.2;
int dir;

//size of queue
int dataSize=1000000;
float[][] data = new float[dataSize][4];

//iterate through the queue based on new data being written in 
int writepointer = 0;
//iterate through queue based on data being read by robot
int readpointer=0;

//baseline location for buttons
int yLocation;
int xLocation;

//determines which page is currently shown
int state = 0;

//calibration angle
float vangle=0;

//the timer associated with calibrate. used to determine how long scribbler takes to make [rotations]
float time=9600;

//current Time calculated in calibration to set relative timer
float currentTime=0;

//number of rotations of scribbler used with [time] to determine calibration
int rotations=5;


//true in order to initialize each page, otherwise false
boolean setup=true;

//determines if Start button is either [START] or [STOP]
boolean goPressed=false;

//Calibration button on start Page
Button calibrate;

//Drawing button on Start page
Button drawNow;

//Start Button on Calibration page
Button go;

//Stop Button on Calibration Page
Button stop;

//Back button on Calibration page
Button back;

Button commands;
Button forward;
Button backward;
Button turnLeft;
Button turnRight;
Button penToggle;
Button lastState;
float timer;

byte test = 0;


void setup(){
  bg=loadImage("scribbles.jpg");
 // background(255);
  size(bg.width,bg.height);
  yLocation=height/4;
  xLocation=width/2;
 // bluetooth = new Serial(this, "COM17");
  bluetooth = new Serial(this, "COM25");
  vangle=(5*360)/time;
  calibrate=new Button(5,"Calibrate",xLocation, height-2*yLocation, 24);
  drawNow= new Button(30,"Begin Drawing", xLocation, height-yLocation, 24);
  go = new Button(34,"Start", xLocation,height-2*yLocation, 24);
  back = new Button(50,"Finish", xLocation,height-3*yLocation,24);
  commands = new Button(70,"Manual", xLocation, height-30,24);
  lastState = new Button(20,"Back", 40,30,24);
  timer = millis();
  //println(location);
}



void draw(){
 // println(state);
  //start page
  switch(state){
  
    
 case 0 :{
    if(setup){
      background(bg);
      setup=false;
    }
    startPage();
  }
  break;
  
  
  //calibration page
  case 1: {
    if(setup){
       time=0;
       setup=false;
    }
    background(bg);
    drawCal();
    
    
  }
  break;

  //draw page
  case 2: {
    //println(setup);
    if(setup){
    background(100);
    setup=false;
    }
   
    paint();
  }
  break;
  
  case 3:{
    if(setup){
      background(bg);
      setup=false;
    }
    
    manual();
  }
  } 
  
  //System.out.println("X: " + x + " Y: " + y + " Pen: " + penDown);
}



//draws the start page
void startPage(){
  
  textAlign(CENTER);
  textSize(24);
  String t="Welcome to Scribble";
  
  pushMatrix();
  fill(100);
  rectMode(CENTER);
  rect(xLocation,height-3*yLocation,xLocation + textWidth(t)/2, 2*(textAscent()));
  fill(0);
  text(t,xLocation, height-3*yLocation);
  popMatrix();
  textAlign(BASELINE);
  calibrate.drawButton();
  drawNow.drawButton();
  commands.drawButton();
}

void manual(){
  int xLoc=width/2;
  int yLoc=height/2;
  forward=new Button(5,"Forward",xLoc,30, 24);
  turnLeft= new Button(34,"Left",30,yLoc, 24);
  turnRight = new Button(50,"Right",width-40,yLoc,24);
  penToggle = new Button(70,"Toggle Pen", xLoc,yLoc+20,24);
 
  forward.drawButton();
  turnLeft.drawButton();
  turnRight.drawButton();
  penToggle.drawButton();
  lastState.drawButton();
  if(writepointer>=dataSize){
    writepointer=0;
  }
  if(mousePressed){
    if (millis()-timer >100){
     
             if(forward.rectOver){
                   data[writepointer][0]=0;
                   data[writepointer][1]=100;
                   data[writepointer][2]=0;
                   data[writepointer][3]=penDown;  
                  // println("FORWARD");
                   writepointer++;
                  }
              else if(turnLeft.rectOver){
                   data[writepointer][0]=100;
                   data[writepointer][1]=0;
                   data[writepointer][2]=0;
                   data[writepointer][3]=penDown;
            //      println("turnLeft"); 
                   writepointer++;
                  }
              else if(turnRight.rectOver){
                   data[writepointer][0]=100;
                   data[writepointer][1]=0;
                   data[writepointer][2]=1;
                   data[writepointer][3]=penDown;
                   writepointer++;
                  }
              timer=millis();     
    }                
}
  bluetoothEvent();
}
//draws the draw page
void paint(){
  lastState.drawButton();
  stroke(0);
  if(writepointer>=dataSize){
    writepointer=0;
  }
  if(mousePressed){
    x = mouseX;
    y = mouseY;
    
    if(counter>5){
    angTime = findAngleTime(x,y);
    if(angTime!=0){
     if(angTime<0){
       angTime=Math.abs(angTime);
       direction=0;
       }
    else direction=1;
    println("ANGLE " + angTime);
    while(angTime>100){
      data[writepointer][0]=100;
      data[writepointer][1]=0;
      data[writepointer][2]=direction;
      data[writepointer][3]=1;
      angTime-=100;
       println("BYTE " + (byte)data[writepointer][0] + " " + (byte)data[writepointer][1] + " " + (byte)data[writepointer][2] + " " + (byte)data[writepointer][3]);

      writepointer++;
      
    }
    data[writepointer][0]=angTime;
    data[writepointer][1]=0;
    data[writepointer][2]=direction;
    data[writepointer][3]=1;
     println("BYTE " + (byte)data[writepointer][0] + " " + (byte)data[writepointer][1] + " " + (byte)data[writepointer][2] + " " + (byte)data[writepointer][3]);

    writepointer++;
    }
    
    magTime = findMagTime(x,y);
    if(magTime!=0){
    println("MAGNITUDE " + magTime);
    while(magTime>100){
      data[writepointer][0]=0;
      data[writepointer][1]=100;
      data[writepointer][2]=direction;
      data[writepointer][3]=1;
      magTime-=100;
      println("BYTE " + (byte)data[writepointer][0] + " " + (byte)data[writepointer][1] + " " + (byte)data[writepointer][2] + " " + (byte)data[writepointer][3]);

      writepointer++;
      
    }
    data[writepointer][0]=0;
    data[writepointer][1]=magTime;
    data[writepointer][2]=direction;
    data[writepointer][3]=1;
      println("BYTE " + (byte)data[writepointer][0] + " " + (byte)data[writepointer][1] + " " + (byte)data[writepointer][2] + " " + (byte)data[writepointer][3]);

    writepointer++;
   
    }
   
    currentX=x;
    currentY=y;
   
    ellipse(currentX,currentY,5,5);
    counter=0;
   }
   
 //   println("X " + x + " Y " + y);
    counter++;
   // println("WRITE " + writepointer);
//println("READ " + readpointer);
   // println(data[readpointer][0] + " " + data[readpointer][1]);
    line(x,y,pmouseX,pmouseY);
    }
    
     bluetoothEvent();
      
  
//  }
}


void mouseReleased(){
  if(state==2 && !setup){
    data[writepointer][0]=0;
    data[writepointer][1]=0;
    data[writepointer][2]=0;
    data[writepointer][3]=0;
    writepointer++;
    println("MOUSECLICKED");
    println("WRITE " + writepointer);
  }
}

//determines the necessary page based on button clicks
void mousePressed(){
  switch(state){
    case 0:   if (calibrate.rectOver){
                  state=1;
                  setup=true;
                  calibrate.rectOver=false;
    }
         else if(commands.rectOver){

                   bluetooth.write(0);
                   bluetooth.write(0);
                   bluetooth.write(0);
                   bluetooth.write(0);
                   bluetooth.write(0);
                   state=3;
                   setup=true;
                   commands.rectOver=false;
                   delay(100);
    }
         else if(drawNow.rectOver){
     
                   bluetooth.write(0);
                   bluetooth.write(0);
                   bluetooth.write(0);
                   bluetooth.write(0);
                   bluetooth.write(0);
                   drawNow.rectOver=false;
                   setup=true;
                   state=2;
                   delay(100);
    }
 //   println("BUTToN PRESSED");
    break;
    case 1: if(go.rectOver){
               if(goPressed){
                 //  //bluetooth.write("HELLO");
                  bluetooth.write(2);
                  //  println("WRITING 1");
                  go = new Button(34,"Start", go.rectX,go.rectY, go.textSize);
               }
           else{
               bluetooth.write(1);
             //    println("Calibrate");
               go=new Button(3, "Stop", go.rectX, go.rectY, go.textSize);
               }
            currentTime=millis();
            goPressed=!goPressed;
      //      go.rectOver=false;
             }
            else if(back.rectOver){
                    state=0;
               // println(currentTime);
                    setup=true;
        //            back.rectOver=false;
            }    
    break;
    case 2:  if(lastState.rectOver){
                state=0;
                bluetooth.write(2);
                setup=true;
         //       lastState.rectOver=false;
                }
            
             
                
    break;
    case 3:  if(lastState.rectOver){
                state=0;
                bluetooth.write(2);
                setup=true;
          //      lastState.rectOver=false;
                }
           
              else if(penToggle.rectOver){
                   penDown=1-penDown;
                   data[writepointer][0]=0;
                   data[writepointer][1]=0;
                   data[writepointer][2]=0;
                   data[writepointer][3]=penDown;
                   writepointer++;
          
              //     penToggle.rectOver=false;
                   println("Pen TOGGLE");
            
                  }
             
    break;
    
  }
}

//draws the calibration page
void drawCal(){
  textAlign(CENTER);
   textSize(24);
  String t = "Rotate " + rotations + " times";
   pushMatrix();
  fill(100);
  rectMode(CENTER);
  rect(xLocation,height-3.5*yLocation,xLocation + textWidth(t)/2, 2*(textAscent()));
  fill(0);
  text(t,xLocation, height-3.5*yLocation);
  popMatrix();
  textAlign(BASELINE);
 go.drawButton();
 back.drawButton();
  if(goPressed){
    
    time = (millis()-currentTime)/1000;
    drawTimer(time);
    
    
    //special byte to tell arduino to calibrate
   
    //send arduino code to turn in place
  }
  else{
    drawTimer(time);
    vangle=(360*rotations)/time;
  }
    
}

//draws the Timer on the calibration page
void drawTimer(float time){
  textAlign(CENTER);
   pushMatrix();
  fill(100);
  rectMode(CENTER);
  rect(xLocation,height-yLocation,xLocation + textWidth((char)time)/2, 2*(textAscent()));
  fill(0);
  text(time,xLocation, height-yLocation);
  popMatrix();
  textAlign(BASELINE);
}



//for arduino code

float calibrate(float time){
  return rotations*360/time;
}



float findAngleTime(int x, int y){
 
 float theta = (atan(((float)y-currentY)/((float)x-currentX)))*(180/PI);
 float angle=theta-startAngle;
 
 /*if(angle<0){
   angle=Math.abs(angle);
   data[writepointer][2]=0;
 }
 else data[writepointer][2]=1;*/
 startAngle=theta;
//  println(angle*vangle);
  return angle/vangle;
}




float findMagTime(double x, double y){
 // println((sqrt(sq((float)(x-currentX))+sq((float)(y-currentY))))*driveTime);
  return (sqrt(sq((float)(x-currentX))+sq((float)(y-currentY))))/driveTime;
}


void bluetoothEvent(){
  
  if(bluetooth.available()>0){
  cmd = bluetooth.read();
  println(cmd);
  }
  
  if(cmd == 1){
   
    if(readpointer<writepointer){
    //   println("WRITE " + writepointer);
   //    println("READ " + readpointer);
       bluetooth.write(0);
       bluetooth.write((byte)data[readpointer][0]);
       bluetooth.write((byte)data[readpointer][1]);
       bluetooth.write((byte)data[readpointer][2]);
       bluetooth.write((byte)data[readpointer][3]); 
       println("BYTE " + 0 +" "+ (byte)data[readpointer][0] + " " + (byte)data[readpointer][1] + " " + (byte)data[readpointer][2] + " " + (byte)data[readpointer][3]);
       readpointer++;
       cmd=0;
     //  delay(100);
     //  println("ReadPointer ++");
    }
 
//   println("INT " + (int)data[readpointer][0] + " " + (int)data[readpointer][1] + " " + (int)data[readpointer][2] + " " + (int)data[readpointer][3]);
  }
  if(readpointer>=dataSize){
    readpointer=0;
  }
  
}





