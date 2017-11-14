import processing.video.*;

Capture videoCapture;

int winWidth = 600;
int winHeight = 800;

int frameWidth = 640;
int frameHeight = 480;

int dispWidth;
int dispHeight = 1000;

int border = 30;
color borderColor = color(0, 0, 0);

void captureEvent(Capture videoCapture) {
  videoCapture.read();
}

void setup() {  
  size(600, 800);
  
  dispWidth = (int)(frameWidth * dispHeight/(double)frameHeight + 0.5);
  
  fill(borderColor);
  stroke(borderColor);
  
  videoCapture = new Capture(this, frameWidth, frameHeight);
  videoCapture.start();
}

void draw() {  
  image(videoCapture, -(dispWidth-400)/2, 0, dispWidth, dispHeight);
  filter(GRAY);
  
  rect(0, 0, winWidth, border);
  rect(0, winHeight-border, winWidth, border);
  rect(0, border, border, winHeight-2*border);
  rect(winWidth-border, border, border, winHeight-2*border);
}