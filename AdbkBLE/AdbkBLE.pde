/**
 * Use Arduino with Adafruit's BLE breakout and Bluefruit app to control the cube by 
 * rotating an Android phone.
 */


import processing.serial.*;

float[] quat;
float angleX;
float angleY;
float angleZ;

RunningMean angleXmean;
RunningMean angleZmean;


int i, shift;
int bytesToRead = 18;
int val = 0;     

Serial myPort;  


PImage tex1, tex2, tex3, tex4, tex5, tex6;

PShader nebula;


void setup() 
{
  
  fullScreen(P3D, 2); 
  //size(500, 500, P3D);
  //frameRate(30);

  quat = new float[4];
  
  angleX = 0.0;
  angleY = 0.0;
  angleZ = 0.0;
  background(0);   
  
  angleXmean = new RunningMean(10, angleX);
  angleZmean = new RunningMean(10, angleZ);
  
  String portName = Serial.list()[0];
  
  tex1 = loadImage("dice1.png");
  tex2 = loadImage("dice2.png");
  tex3 = loadImage("dice3.png");
  tex4 = loadImage("dice4.png");
  tex5 = loadImage("dice5.png");
  tex6 = loadImage("dice6.png");
  
  nebula = loadShader("nebula.glsl");
  //nebula.set("resolution", float(width), float(height));
  nebula.set("resolution", 300, 300);
  
  for (int n = 0; n < Serial.list().length; n++)
    println(n + ": " + Serial.list()[n]);
  
  myPort = new Serial(this, portName, 9600);
  myPort.buffer(3);
  
  myPort.clear();
}

void draw()
{
  clear();
  background(0, 60, 70);   
  fill(204);
  text("x: " + quat[0], 10, 10);
  text("y: " + quat[1], 10, 30);
  text("z: " + quat[2], 10, 50);
  text("w: " + quat[3], 10, 70); 


  float s = height/2.5;
  float s2 = s*0.5;

  translate(width/2, height/2, 0); 

  rotateX((float)angleXmean.getMean());
  rotateZ((float)angleZmean.getMean());
  
  
  stroke(255, 255, 255);
  strokeWeight(2);
 // textureMode(NORMAL);
  
  nebula.set("time", millis() / 500.0);  
 // nebula.set("mouseX", (float)mouseX);  
 // nebula.set("mouseY", (float)mouseY);
 // nebula.set("mouseX", 0);  
 // nebula.set("mouseY", 0);
  shader(nebula); 
  
  beginShape();
  //texture(tex6);
  vertex(-s2, -s2, s2, 0, 0);
  vertex(s2, -s2, s2, 1, 0);
  vertex(s2, s2, s2, 1, 1);
  vertex(-s2, s2, s2, 0, 1);
  endShape();
  
  beginShape();  
//  texture(tex1);
  vertex(s2, -s2, -s2, 0, 0);
  vertex(-s2, -s2, -s2, 1, 0);
  vertex(-s2, s2, -s2, 1, 1);
  vertex(s2, s2, -s2, 0, 1);
  endShape();
  
  beginShape();
//  texture(tex2);
  vertex(-s2, -s2, -s2, 0, 0);
  vertex(-s2, -s2, s2, 1, 0);
  vertex(-s2, s2, s2, 1, 1);
  vertex(-s2, s2, -s2, 0, 1);
  endShape();  
  
  beginShape();
 // texture(tex4);
  vertex(s2, -s2, s2, 0, 0);
  vertex(s2, -s2, -s2, 1, 0);
  vertex(s2, s2, -s2, 1, 1);
  vertex(s2, s2, s2, 0, 1);
  endShape();    
  
  beginShape();
 // texture(tex3);
  vertex(-s2, -s2, -s2, 0, 0);
  vertex(s2, -s2, -s2, 1, 0);
  vertex(s2, -s2, s2, 1, 1);
  vertex(-s2, -s2, s2, 0, 1);
  endShape();  
  
  beginShape();
 // texture(tex5);
  vertex(-s2, s2, s2, 0, 0);
  vertex(s2, s2, s2, 1, 0);
  vertex(s2, s2, -s2, 1, 1);
  vertex(-s2, s2, -s2, 0, 1);
  endShape();   
  
  
  stroke(255, 0, 0);
  noFill();
}


void serialEvent(Serial p) {
  char c;
  
  if (bytesToRead == 0) {

    angleX = quat[1];
    angleY = quat[0];
    angleZ = quat[2];
    
    angleXmean.updateMean(angleX);
    angleZmean.updateMean(angleZ);

    bytesToRead = 18;
   // myPort.clear();
  }
  
  
  while (bytesToRead == 18 && p.available() > 0) {
    
    c = p.readChar();
    print(c);
    if (c == '!') {
      bytesToRead = 17;
    }
    
    
  }
    
  
  if (bytesToRead == 17 && p.available() > 0) {
    
    c = p.readChar();
    print(c);
    
    if (c == 'Q') {
      bytesToRead = 16;
    }
    else {
      bytesToRead = 18; 
    }
  }
  
  if (bytesToRead <= 16) {
    
    while (myPort.available() > 0 && bytesToRead > 0) {
      i = (16 - bytesToRead) / 4;
      shift = ((16 - bytesToRead) % 4) * 8;
      
      if (shift == 0)
        val = 0;
        
      c = p.readChar();
      print(c);
      int k = (int)c;
      if (k < 0)
        k = 256 + k;
        
      val = val | (/*p.read()*/k << shift);
      bytesToRead--;
      
      if (shift == 24)
        quat[i] =  Float.intBitsToFloat(val);
    }
  }
  
  
}