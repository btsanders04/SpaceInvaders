public class Defender{

  int xPos=100;
  int size=100;
  PImage ship;
  public Defender(){
    ship = loadImage("spaceship-new.png");
  }
  
  public void updateDefender(){
    moveDefender();
     image(ship,xPos,height-size,size,size);  
  }
  
  public void moveDefender(){
    if(keyPressed){
      if(key=='a' && xPos >=0)
      {
        xPos-=5;
      }
      else if(key=='d' && xPos <= bg.width){
        xPos+=5;
      }
    }
  }
}
