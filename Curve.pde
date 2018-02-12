class Curve {
  int drawingMode;
  int numModes = 2;
  
  float xStart, yStart, xEnd, yEnd; // start and end points
  float xMargin = 40;
  float x1,y1,x2,y2; // first and second control points
  
  float speedX, speedY; // speed of control points?
  
  float angle;
  float speed; // speed of angle
  float radius; // height of curve
  
  float currentColor = 10;
  
  float c,s; // wtf?
  
  PFont font; // font for debugging
  
  float volumeScore;
  Curve() { 
    neteja();
    smooth();
    
    drawingMode = 1;
    
    font = createFont("Circular Std",16,true); // STEP 2 Create Font

    speedX = .5;
    speedY = .2;
  
    angle=0.0;
    speed=0.01;
    radius=300.0;
    xStart = xMargin;
    yStart = height/2;
    xEnd = width - xMargin;
    yEnd = height/2;
    
    volumeScore = 0;
  }
  void update() { 
    debug();
    c = cos(angle * speedX);
    s = sin(angle);
  
    x1 = width/3+c*radius;
    y1 = height/2+s*radius;
  
    x2 = 2*width/3 + cos(angle)*radius;
    y2 = height/2 + sin(angle * speedY)*radius;
  
    noFill();
    stroke(currentColor, 50, 100, 10);
    bezier(xStart,yStart,x1,y1,x2,y2,xEnd,yEnd);
    
    angle+=speed;
  }
  void setVolumeScore(float score) {
    volumeScore = score;
  }
  private void neteja() {
    background(100);
  }
  private void debug() {
    // debug strings
    // String sStartEnd = ("xStart: " + xStart + ", xEnd: " + xEnd + ", yStart: " + yStart + " yEnd: " + yEnd);
    String sSpeed = "speed: " + speed;
    String sCurrentColor = "color: " + currentColor;
    
    helper.debugText(sSpeed + ", " + sCurrentColor);
  }
}