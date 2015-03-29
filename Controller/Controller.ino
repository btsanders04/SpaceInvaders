#include <Bounce2.h>

int firePin = 9;
Bounce bouncer;

void setup () {
  bouncer = Bounce();
  pinMode(firePin, INPUT);
  bouncer .attach( firePin );
  bouncer .interval(5);
  Serial.begin(9600);
  Serial.println('Y');
}


void loop () {
 // if(Serial.available()>0) {
   int pos = analogRead(A0);
   Serial.print(pos);
   Serial.print(",");
   delay(1);
   bouncer.update();
   int fire = bouncer.read();
   Serial.println(fire);  
//  }
}
  
  
