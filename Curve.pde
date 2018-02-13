class Curve {
  float xStart, yStart, xEnd, yEnd; // start and end points
  float x1,y1,x2,y2; // first and second control points
  float hue;
  float opacity;
  
  Curve(float xStart, float yStart, float x1, float y1, float x2, float y2, float xEnd, float yEnd, float hue, float opacity) {
    this.xStart = xStart;
    this.yStart = yStart;
    this.xEnd = xEnd;
    this.yEnd = yEnd;
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.hue = hue;
    this.opacity = opacity;
  }
  
  float[] getBezier() {
    float[] bezier = {xStart, yStart, x1, y1, x2, y2, xEnd, yEnd};
    return bezier;
  }
  
  float getHue() {
    return hue;
  }
  
  float getOpacity() {
    return opacity;
  }
}