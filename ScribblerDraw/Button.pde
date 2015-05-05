
public class Button{


int rectX, rectY, textSize;      // Position and Size of square button
color rectColor;                 //color of button
color rectHighlight;             //highlight color of button
String label="";                 //name of the button written on it
boolean rectOver = false;
float buffer = textAscent()/2;
public Button(int c, String name, int x, int y, int size){
  colorMode(HSB, 100);
  rectX=x;
  rectY=y;
  rectColor=color(c,100,100);
  label=name;
  textSize=size;
  rectHighlight = color(c,100,50);
}



void drawButton() {
 
  update(mouseX, mouseY);
 // background(currentColor);
  
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(0);
  strokeWeight(2);
  textSize(textSize);
  rectMode(CENTER);
  rect(rectX, rectY, textWidth(label)+buffer, textAscent()+textDescent()+buffer);
  fill(0);
  text(label,rectX-textWidth(label)/2,rectY+textAscent()/2);
}


//updates to see if the rectangle is highlighted or not
void update(int x, int y) {
 if ( overRect(rectX-(textWidth(label)+buffer)/2, rectY-(textAscent()+textDescent()+buffer)/2,
      (textWidth(label)+buffer),(textAscent()+textDescent() + buffer)) ) {
    rectOver = true;
  } else {
    rectOver = false;
  }
  //println(label + " " + rectX + ", " + rectY + " " + rectOver);
}

//finds the dimensions of the rectangle and if the mouse is floatig within those dimensions
boolean overRect(float x, float y, float width, float height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
}
