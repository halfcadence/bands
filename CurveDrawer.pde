import java.text.NumberFormat;
import java.text.DecimalFormat;
class CurveDrawer {
  NumberFormat formatter = new DecimalFormat("0.000");
  int drawingMode;
  int numModes = 2;
  
  float maxScore;
  
  float xStart, yStart, xEnd, yEnd; // start and end points
  float xMargin = 40;
  float x1,y1,x2,y2; // first and second control points
  
  float speedX, speedY; // speed of control points?
  
  float angle;
  float speed; // speed of angle
  float radius; // height of CurveDrawer
  
  float currentColor;
  float opacity;
  float c,s; // wtf?
  
  PFont font; // font for debugging
  
  float volumeScore;
  
  ArrayList<Curve> curveMemory = new ArrayList<Curve>();

  CurveDrawer(float[] seeds, float maxScore) { 
    this.maxScore = maxScore;
    neteja();
    smooth();
    
    drawingMode = 1;
    
    speedX = map(seeds[0], 0, 1, 1, 3);
    speedY = map(seeds[1], 0, 1, 1, 3);
  
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
    opacity = volumeScore <= 0.01 ? 0 : 10; // draw lighter when no music is playing, prevents nasty bands at beg and end...
    float maxConstrainedStore = maxScore / 2;
    volumeScore = constrain(volumeScore, 0, maxConstrainedStore);
    speed = map(volumeScore, 0, maxConstrainedStore, 0, .03);
    currentColor = map(volumeScore, 0, maxConstrainedStore, 0, 10);
    c = cos(angle * speedX);
    s = sin(angle);
  
    x1 = width/3+c*radius;
    y1 = height/2+s*radius;
  
    x2 = 2*width/3 + cos(angle)*radius;
    y2 = height/2 + sin(angle * speedY)*radius;
  
    noFill();
    stroke(currentColor, 50, 100, opacity);
    bezier(xStart,yStart,x1,y1,x2,y2,xEnd,yEnd);
    angle+=speed;
    
   debug();
  }
  
  void setVolumeScore(float score) {
    volumeScore = score;
  }
  
  private void neteja() {
    background(100);
  }
  private void debug() {
    // debug strings
    String sSpeed = "speed: " + formatter.format(speed);
    String sVolumeScore = "volume score: " + formatter.format(volumeScore);
    String sCurrentColor = "color: " + formatter.format(currentColor);
    String sOpacity = "opacity: " + formatter.format(opacity);
    String sSeed = "sX: " + formatter.format(speedX) + ", " + "sY:" + formatter.format(speedY);
    helper.debugText(sSeed + ", " + sVolumeScore + ", " + sCurrentColor + ", " + sOpacity + ", " + sSpeed);
  }
}