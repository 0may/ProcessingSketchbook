
import processing.serial.*;
import cc.arduino.*;
import processing.sound.*;

Arduino arduino;
int sensorPin = 0;

// Radius der gezeichneten Kreise
float radiusMin = 10.0;
float radiusMax = 150.0;
float radius = 0.0;

int sensorMin = 600;
int sensorMax = 800;

String message0 = "Come closer";
String message1 = "Don't touch!!";

int msg0max;
int msg1max;
int msgSize;

int sbufferSize = 10;
float[] sbuffer;
int sbufferIdx = 0;
float smean = 1.0;

float sThresh = 0.8;
float nearSoundThresh = 0.6;
float farSoundThresh = 0.9;

SoundFile soundfile;

SoundFile[] farSounds;
SoundFile[] nearSounds;
int farSoundIdx = 0;
int nearSoundIdx = 0;

int remainingPlayTime = 0;

int lastTime = -1;


// Funktion zum Einstellen von Werten am Anfang des Programms
void setup()
{
  
  // Fenstergröße
  //size(640, 360);
  fullScreen(P2D, 2);
  
  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(sensorPin, Arduino.INPUT);

  
  // Ellipsen und Kreise werden durch Mittelpunkt und Radius beschrieben
  ellipseMode(RADIUS);
  
  // Schwarzer Hintergurnd
  background(0,0,0);
  
  // keine Ränder zeichnen
  noStroke();
  
  fill(0,255,0);
  
  msg0max = (int)(0.2*height);
  msg1max = (int)(0.35*height);
  
  msgSize = msg0max;
  
  sbuffer = new float[sbufferSize];
  for (int i = 0; i < sbufferSize; i++) 
    sbuffer[i] = smean;
    
  nearSounds = new SoundFile[3];
  nearSounds[0] = new SoundFile(this, "nichtanfassen.wav");
  nearSounds[1] = new SoundFile(this, "fingerweg.wav");
  nearSounds[2] = new SoundFile(this, "robotnoise2.wav");
  
  farSounds = new SoundFile[2];
  farSounds[0] = new SoundFile(this, "gutentag.wav");
  farSounds[1] = new SoundFile(this, "weiterhelfen.wav");
}

// Funktion zum Zeichnen. Wird jedes Frame aufgerufen.
void draw() 
{
    // Inhalte aus letztem Frame entfernen
  clear();
  
  
  int sensorValue = arduino.analogRead(sensorPin);
  
  if (sensorValue <= 0) {
    return;
  }
    
  if (sensorValue < sensorMin)
    sensorMin = sensorValue;
    
  if (sensorValue > sensorMax)
    sensorMax = sensorValue;
  
  float s = 1.0;
  
  if (sensorMax != sensorMin)
    s = (sensorValue - sensorMin) / (float)(sensorMax - sensorMin);

  
  s = runningMeanS(s);
 // println("v=" + sensorValue + " vMin=" + sensorMin + " vMax=" + sensorMax + " s=" + s);
  
  int currentTime = millis();
  
  if (remainingPlayTime > 0) {
    remainingPlayTime -= currentTime-lastTime; 
  }
  

  drawBar(s);
  
  
  if (s > sThresh) {
 //   fill(0,200,255);
 //   textSize((int)((s - sThresh)/(1.0-sThresh) * msg0max));
 //   text(message0, width/2 - textWidth(message0)/2, height/2 + (textAscent())/2); 
    
    if (s < farSoundThresh && farSoundIdx < farSounds.length && remainingPlayTime <= 0) {
      // soundfile = new SoundFile(this, farSounds[farSoundIdx++]);
       farSounds[farSoundIdx].play();
       remainingPlayTime = (int)(farSounds[farSoundIdx].duration()*1000.0 + 0.5);
       farSoundIdx++;
    }
    
  }
  else if (s < sThresh) {
 //   fill(255,0,0);
 //   textSize((int)((sThresh - s)/sThresh * msg1max));
 //   text(message1, width/2 - textWidth(message1)/2, height/2 + (textAscent())/2); 
    
    if (s < nearSoundThresh && nearSoundIdx < nearSounds.length && remainingPlayTime <= 0) {  
       nearSounds[nearSoundIdx].play();
       remainingPlayTime = (int)(nearSounds[nearSoundIdx].duration()*1000.0 + 0.5);
       nearSoundIdx++;
    }
  }

  lastTime = currentTime;

  delay(10);
}


float runningMeanS(float s) {
  
  smean += (s - sbuffer[sbufferIdx])/(float)sbufferSize;
  
  sbuffer[sbufferIdx] = s;
  
  sbufferIdx = (sbufferIdx + 1) % sbufferSize;
  
  return smean;
}


void drawBar(float s) {
  
  int cx = width/2;
  int rx = width/3;
  int nx = (int)((sThresh - nearSoundThresh)/sThresh*rx);
  int fx = (int)((farSoundThresh - sThresh)/(1.0-sThresh)*rx);
  
  rectMode(CORNER);
  noStroke();
  if (s >= sThresh) {
    fill(0,200,50);
    rect(cx, height/2-15, (s - sThresh)/(1.0-sThresh)*rx, 30);
  }
  else {
    if (s <= nearSoundThresh)
      fill(255,0,0);
    else
      fill(255,(s - nearSoundThresh)/(sThresh-nearSoundThresh)*255, 0);
      
    rect(cx - (sThresh - s)/sThresh*rx, height/2-15, (sThresh - s)/sThresh*rx, 30);
  }
  
  noFill();
  
  stroke(255,255,255,150);
  line(cx-nx, height/2-20, cx-nx, height/2+20);
  line(cx+fx, height/2-20, cx+fx, height/2+20);
  
  stroke(255,255,255); 
  line(cx, height/2-30, cx, height/2+30);
  
  rectMode(RADIUS);
  rect(cx, height/2, rx, 15);
  
  
//  fill(255,255,255);
//  textSize(20);
//  text("comfort zone", width/2 - textWidth("comfort zone")/2, height/2 - 40);  
  
  
  
  
}