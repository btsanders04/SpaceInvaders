#include <Bounce2.h>

int firePin = 10;
int reloadPin = 9;
int speakerPin = 6;
Bounce bouncer1 = Bounce();
Bounce bouncer2 = Bounce();
int fire;
int reload;

void setup () {
  pinMode(firePin, INPUT_PULLUP);
  pinMode(reloadPin, INPUT_PULLUP);
  pinMode(speakerPin, OUTPUT);
  bouncer1 .attach( firePin );
  bouncer2 .attach( reloadPin );
  bouncer1 .interval(5);
  bouncer2 .interval(5);

  Serial.begin(9600);
  //Serial.println('Y');
}


void loop () {
  bouncer1.update();
  if (bouncer1.fell() == 1){
   fire = 1;
  }
  
  bouncer2.update();
  if (bouncer2.fell() == 1){
   reload = 1;
  }
  
  if(Serial.available()>0) {
  Serial.read();
  int posx = analogRead(A0);
  int posy = analogRead(A1);
 
  //int fire = digitalRead(firePin);
  //int reload = digitalRead(reloadPin);
  Serial.print(posx);
  Serial.print(",");
  delay(1);
  Serial.print(posy);
  Serial.print(",");
  delay(1);
  Serial.print(fire); 
  Serial.print(",");
  delay(1);
  Serial.println(reload);
  if(reload == 1){
    playNote('c', 30);
    playNote('d', 30);
    playNote('e', 30);
    playNote('f', 30);
  }

  if(fire == 1){
    playNote('C', 30);
    playNote('b', 30);
    playNote('a', 30);
    playNote('g', 30);
  }
  
  fire = 0;
  reload = 0;
    }
}

void playNote(char note, int duration) {
  char names[] = { 
    'c', 'd', 'e', 'f', 'g', 'a', 'b', 'C'   };
  int tones[] = { 
    1915, 1700, 1519, 1432, 1275, 1136, 1014, 956   };

  // play the tone corresponding to the note name
  for (int i = 0; i < 8; i++) {
    if (names[i] == note) {
      playTone(tones[i], duration);
    }
  }
}

void playTone(int tone, int duration) {
  for (long i = 0; i < duration * 1000L; i += tone * 2) {
    digitalWrite(speakerPin, HIGH);
    delayMicroseconds(tone);
    digitalWrite(speakerPin, LOW);
    delayMicroseconds(tone);

  }
}




