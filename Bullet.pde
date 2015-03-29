public class Bullet {

  int xPos;
  int yPos;
  
  public Bullet(int x, int y){
    xPos=x;
    yPos=y;
  }
  
  
  public void updateBullet(boolean isD){
    int dy =10;
    if(isD){
    yPos-=dy;
    }
    else 
    yPos+=dy;
    stroke(255,0,0);
    strokeWeight(3);
    line(xPos,yPos,xPos,yPos+dy);
  }
  
    

}
