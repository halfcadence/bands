import java.text.NumberFormat;
import java.text.DecimalFormat;
class CurveDrawer {
  NumberFormat formatter = new DecimalFormat("0.000");
  int drawingMode;
  final int numModes = 2;
  boolean paused;
  boolean debug;
  int pausedBGOpacity;
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
  
  float backgroundColor;
  
  ArrayList<Curve> curveMemory;

  CurveDrawer(float[] seeds, float maxScore) {
    drawingMode = 0;
    paused = true;
    debug = false;
    pausedBGOpacity = 0;
    defaultVariables(); // reset variable defaults
    refreshBackground();
    seed(seeds, maxScore); // seed drawer with seeds for speedX and speedY, maxScore to scale speed
    
    // size of drawing
    xStart = xMargin;
    yStart = height/2;
    xEnd = width - xMargin;
    yEnd = height/2;
    
    curveMemory = new ArrayList<Curve>();
  }
  void update() {
    refreshBackground();
    if (paused) {
      return;
    }
    opacity = volumeScore <= 0.01 ? 0 : 10; // draw lighter when no music is playing, prevents nasty bands at beg and end
    float maxConstrainedStore = maxScore / 2;
    volumeScore = constrain(volumeScore, 0, maxConstrainedStore);
    speed = map(volumeScore, 0, maxConstrainedStore, 0, .03);
    c = cos(angle * speedX);
    s = sin(angle);
  
    x1 = width/3+c*radius;
    y1 = height/2+s*radius;
  
    x2 = 2*width/3 + cos(angle)*radius;
    y2 = height/2 + sin(angle * speedY)*radius;
    
    curveMemory.add(new Curve(xStart,yStart, x1, y1, x2, y2, xEnd, yEnd, hue, opacity));

    for (Curve curve: curveMemory) {
      float nostalgicHue = curve.getHue();
      float nostalgicOpacity = curve.getOpacity();
      
      noFill();
      findStroke(nostalgicHue, nostalgicOpacity);
      
      float[] bez = curve.getBezier();
      bezier(bez[0], bez[1], bez[2], bez[3], bez[4], bez[5], bez[6], bez[7]);
    }
    
    angle+=speed;
    debug();
    
    drawSmoothUnpausingShit();
  }
  
  // slowly draw back when not paused?
  private void drawSmoothUnpausingShit() {
    if (!paused && pausedBGOpacity > 0) {
      pausedBGOpacity -= 10;
      fill(backgroundColor, pausedBGOpacity);
      rect(0,0,width,height);
      return;
    }
  }
  
  void pause() {
    paused = !paused;
  }
  
  void seed(float[] seeds, float maxScore) {
    speedX = map(seeds[0], 0, 1, 1, 3);
    speedY = map(seeds[1], 0, 1, 1, 3);
    this.maxScore = maxScore;
  }
  
  void removeCurrentCurve() {
    curveMemory.clear();
    defaultVariables();
  }
  
  void defaultVariables() {
    angle = 0;
    speed = 0.005;
    radius= 300.0;
    
    volumeScore = 0;
    hue = 0;
    opacity = 10;
  }
  
  void toggleDebug() {
    debug = !debug;
  }
  void refreshBackground() {
    // slowly erase when paused
    if (paused) {
      if (pausedBGOpacity < 100) {
        pausedBGOpacity += 3;
        fill(backgroundColor, pausedBGOpacity);
        rect(0,0,width,height);
        if (debug) helper.debugText("Paused");
        if (drawingMode == 0) {
          helper.drawTitle(0);
        } else {
          helper.drawTitle(100);
        }
      }
      return;
    }

    switch (drawingMode) {
      case 0:
        if (backgroundColor < 100) {
          backgroundColor+= 10;
        }
        background(backgroundColor);
        break;
      case 1:
        if (backgroundColor > 0) {
          backgroundColor -= 10;
        }
        background(backgroundColor);
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
  
  private void debug() {
    if (!debug)
      return;
      
    // debug strings
    String sSpeed = "speed: " + formatter.format(speed);
    String sVolumeScore = "volume score: " + formatter.format(volumeScore);
    String sSeed = "sX: " + formatter.format(speedX) + ", " + "sY:" + formatter.format(speedY);
    helper.debugText(sSeed + ", " + sVolumeScore + ", " + sSpeed);
  }
}