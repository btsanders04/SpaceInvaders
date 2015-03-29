public class Bullet {

  int xPos;
  int yPos;
  
  public Bullet(int x, int y){
    xPos=x;
    yPos=y;
  }
  
  
  public void updateBullet(){
    int dy =10;
    yPos+=dy;
    
  }
  

}
