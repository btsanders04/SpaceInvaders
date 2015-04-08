
int x;
int y;
boolean penDown;
void setup(){
  background(255);
  size(800,800);
}

void draw(){
  stroke(0);
  if(mousePressed){
    x = mouseX;
    y = mouseY;
    penDown=true;
    line(x,y,pmouseX,pmouseY);
  }
  else penDown=false;
  
  System.out.println("X: " + x + " Y: " + y + " Pen: " + penDown);
}
