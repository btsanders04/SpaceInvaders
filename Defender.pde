public class Defender{

  int xPos=100;
  int size=100;
  int yPos=height-size;
  PImage ship;
  Bullet b;
  public Defender(){
    ship = loadImage("spaceship-new.png");
  }
  
  public void updateDefender(){
    moveDefender();
     image(ship,xPos,yPos,size,size);  
     if(b!=null){
       b.updateBullet(true);
     }
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
      else if(key==' '){
        b= new Bullet(xPos+size/2,yPos);
      }
    }
  }
}
