int numParticles = 150;
Particle[] p;


void setup() {
  size(600,600);
  
  p = new Particle[numParticles];
  
  for (int i = 0; i < numParticles; i++) {

    p[i] = new Particle(random(0, width), random(0, height), color(255, 255, 255, 150));
    
  }
  
  
  
}


void draw() {
  
  clear();
  
  
  
  for (int i = 0; i < numParticles; i++) {
    
    p[i].moveTo(mouseX, mouseY, 3.0);
    
    
    p[i].moveTo(100, 100, 1.5);
    p[i].moveTo(500, 100, 2.5);
    
    p[i].update();
    
    p[i].draw();
    
  }
  
}