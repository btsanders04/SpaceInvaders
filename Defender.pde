public class Defender{

  int xPos=100;
  int size=100;
  int yPos=height-size;
  PImage ship;
  boolean killed=false;
  int round = 0;
  int capacity=0;
  Bullet[] bullets= new Bullet[10];
  //Bullet b;
  public Defender(){
    ship = loadImage("spaceship-new.png");
  }
  
  public void updateDefender(){
   if(a!=null){
    if(a.b!=null){
    if(isCollision(xPos+size/2,yPos+size/2,a.b.xPos,a.b.yPos)){
      killed=true;
      a.b = null;
      }
    }
  }
     moveDefender();
       image(ship,xPos,yPos,size,size); 
       System.out.println("NEW");
       for(Bullet b: bullets){
        if(b!=null){
          if(bulletOnScreen(b)){ 
           b.updateBullet(true);
          }
          else b=null;
        }
        System.out.println(b);
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
      else if(key==' ' && keyReleased){
        if(capacity<bullets.length/2){
        bullets[round]=new Bullet(xPos+size/2,yPos);
        capacity++;
        round++;
   //     System.out.println(round);
        keyReleased=false;
        }
      }
      else if(key=='r' && keyReleased){
        reload();
        capacity=0;
        keyReleased=false;
        }
      }
     
    }
  
  
  
  private void reload(){
    for(int i=0; i<bullets.length;i++){
      if(bullets[i]==null){
        round=i;
        break;
      }
    }
    System.out.println(round);
  }
  
}
