import processing.serial.*;
Serial myPort;

PImage bg;
int xcolBox;
int ycolBox;
int xdata=0;
int ydata=0;
int fireButt=0;
int reloadButt=0;
//Alien a;
int startAlien;
Defender d;
boolean keyReleased = true;
boolean stillAlive=false;;
int armadaSize;
Alien[] armada;
boolean startScreen=true;
boolean gameOver=false;
int grabData=100;

void setup(){
//  println(Serial.list());
  myPort = new Serial(this,Serial.list()[2],9600);
  bg = loadImage("space-background.jpg");  
  size(bg.width,bg.height);
  
//  a = new Alien(50,10);
  ycolBox=30;
  xcolBox=40;
  startAlien=30;
 
  armadaSize=10;
  armada = new Alien[armadaSize];
  setupArmada();
  d = new Defender();
  delay(1000);
}


void draw(){

  serialFun();
  image(bg,0, 0,width,height);
  if(startScreen){
    runStartUp();
  }
  else if(gameOver){
    runGameOver();
  }
  else{
    stillAlive=false;
    for(int i=0; i<armada.length;i++){
    if(armada[i]!=null){
      //println("ALIVE");
      stillAlive=true;
      if(armada[i].killed){
        
        if(armada[i].b==null){
          armada[i]=null;
          //println("A is null");
        }
        else{
          armada[i].shoot();
        }
      }
      else{
      armada[i].updateAlien();
      }
    }
    }
    if(d!=null){
      d.updateDefender();
   
    }
    //else{
    //  gameOver();
   // }
   if(!stillAlive){
     runGameOver();
   }
  }
}

public void setupArmada(){
  for(int i=0;i<armadaSize;i++){
    armada[i]=new Alien(startAlien,20);
    startAlien+=100;
  }
}


public boolean isCollision(int xShip, int yShip, int xBul, int yBul){
    if(Math.abs(xShip-xBul)<=xcolBox){
      if(Math.abs(yShip-yBul)<=ycolBox){
      //  collisionCin();
        //b.destroyBullet();
        return true;
      }
    }
    return false;
  }

public void keyReleased(){
  keyReleased=true;
}

public boolean bulletOnScreen(Bullet b){
      if(b.yPos>=0 && b.yPos <= bg.height){
        return true;
      }
    return false;
  }
  
public void runStartUp(){
  if(fireButt==1){
  //  System.out.println(fireButt);
    startScreen=false;
  }
  textSize(50);
  text("Welcome to Invaders of Space", width/4,height/3); 
  textSize(30);
  text("Press 'SPACE' to begin your conquest", width/3, height/2);
  
  
}  

public void runGameOver(){
    image(bg,0,0,width,height);
    textSize(50);
    text("GAME OVER", width/3,height/4);
    textSize(30);
    text("Final Score: " + d.kills, width/3,height/3);
    text("Press 'SPACE' to begin a new conquest", width/3, height/2);
  if(fireButt==1){
    gameOver=false;
    keyReleased=false;
     bg = loadImage("space-background.jpg");  
  size(bg.width,bg.height);
  
//  a = new Alien(50,10);
  ycolBox=30;
  xcolBox=40;
  startAlien=30;
 
  armadaSize=10;
  armada = new Alien[armadaSize];
  setupArmada();
  d = new Defender();
  delay(1000);
  }
}

  
/*
void serialEvent(Serial thePort) {
  try{
  String input = thePort.readString();
  String[] numbers = split(input, ',');
  float[] value = float(numbers);
  xdata = (int)value[0];
  ydata = (int)value[1];
  fireButt=(int)value[2];
  reloadButt=(int)value[3]; 
  }
  catch (Exception e) {
    println("Initialization exception");
  }
}*/

void serialFun(){
  
 /*
  if(myPort.available()>0){
  String input = myPort.readString();
  String[] numbers = split(input, ',');
  float[] value = float(numbers);
  xdata = (int)value[0];
  ydata = (int)value[1];
  fireButt=(int)value[2];
  reloadButt=(int)value[3]; 
  */
  myPort.write(0);
if(myPort.available() >=4){
  ydata=myPort.read();
  xdata=myPort.read();
  fireButt=myPort.read();
  reloadButt=myPort.read();
}
// println(xdata + " : " + ydata + " : " + fireButt + " : " + reloadButt);
/*  myPort.write(1);
  delay(5);
  xdata = myPort.read();
  myPort.write(2);
  delay(5);
  ydata = myPort.read();
  myPort.write(3);
  delay(5);
  fireButt = myPort.read();
  myPort.write(4);
  delay(5);
  reloadButt = myPort.read();
  }*/
}


