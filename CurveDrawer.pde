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
  
  float hue;
  float opacity;
  float c,s; // wtf?
  
  PFont font; // font for debugging
  
  float volumeScore;
  
  ArrayList<Curve> curveMemory;

  CurveDrawer(float[] seeds, float maxScore) { 
    this.maxScore = maxScore;
    neteja();    
    drawingMode = 0;
    speedX = map(seeds[0], 0, 1, 1, 3);
    speedY = map(seeds[1], 0, 1, 1, 3);
  
    angle=0.0;
    speed=0.005;
    radius=300.0;
    xStart = xMargin;
    yStart = height/2;
    xEnd = width - xMargin;
    yEnd = height/2;
    
    volumeScore = 0;
    
    curveMemory = new ArrayList<Curve>();
  }
  void update() {
    opacity = volumeScore <= 0.01 ? 0 : 10; // draw lighter when no music is playing, prevents nasty bands at beg and end...
    float maxConstrainedStore = maxScore / 2;
    volumeScore = constrain(volumeScore, 0, maxConstrainedStore);
    speed = map(volumeScore, 0, maxConstrainedStore, 0, .03);
    hue = map(volumeScore, 0, maxConstrainedStore, 0, 10);
    c = cos(angle * speedX);
    s = sin(angle);
  
    x1 = width/3+c*radius;
    y1 = height/2+s*radius;
  
    x2 = 2*width/3 + cos(angle)*radius;
    y2 = height/2 + sin(angle * speedY)*radius;
    
    setBackground(hue);
    curveMemory.add(new Curve(xStart,yStart, x1, y1, x2, y2, xEnd, yEnd, hue, opacity));

    for (Curve curve: curveMemory) {
      noFill();
      float nostalgicHue = curve.getHue();
      float nostalgicOpacity = curve.getOpacity();
      findStroke(nostalgicHue, nostalgicOpacity);
      float[] bez = curve.getBezier();
      bezier(bez[0], bez[1], bez[2], bez[3], bez[4], bez[5], bez[6], bez[7]);
    }
    
    angle+=speed;
    debug();
  }
  
  void seed(float[] seeds, float maxScore) {
    speedX = map(seeds[0], 0, 1, 1, 3);
    speedY = map(seeds[1], 0, 1, 1, 3);
    this.maxScore = maxScore;
  }
  
  void removeCurrentCurve() {
    curveMemory.clear();
    angle = 0;
    speed = 0.005; // actually make a refresh method? 
  }
  
  void setBackground(float hue) {
    switch (drawingMode) {
      case 0:
        background(100);
        float maxConstrainedStore = maxScore / 2;
        volumeScore = constrain(volumeScore, 0, maxConstrainedStore);
        float alpha = map(volumeScore, 0, maxConstrainedStore, 30,0);
        fill(hue, 40, 95, alpha);
        fill(100);
        rect(0,0,width,height);
        break;
      case 1:
        background(0);
        break;
      default:
        background(100);
        break;
    }
  }
  
  void findStroke(float hue, float opacity) {
    switch (drawingMode) {
      case 0:
        stroke(hue, 60, 95, opacity);
        stroke(0,10);
        break;
      case 1:
        stroke(100, 0, 100, 10);
        break;
      default:
        background(100);
        break;
    }
  }
  void modeCycle() {
    drawingMode = ++drawingMode % numModes;
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
    String shue = "color: " + formatter.format(hue);
    String sOpacity = "opacity: " + formatter.format(opacity);
    String sSeed = "sX: " + formatter.format(speedX) + ", " + "sY:" + formatter.format(speedY);
    helper.debugText(sSeed + ", " + sVolumeScore + ", " + shue + ", " + sOpacity + ", " + sSpeed);
  }
}