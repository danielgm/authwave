
class ConcentricEllipse {
  int numEllipses;
  float centerX,
    centerY,
    baseWidth,
    baseHeight,
    widthFactor,
    heightRatio,
    startIndex,
    rotation;

  ConcentricEllipse(float cx, float cy, float w, float h) {
    numEllipses = 1000;
    centerX = cx;
    centerY = cy;
    baseWidth = w;
    baseHeight = h;
    widthFactor = 1.1;
    heightRatio = 1;
    startIndex = 0;
    rotation = 0.75 * PI;
  }

  void draw(PGraphics g) {
    g.beginDraw();

    g.pushMatrix();
    g.translate(centerX, centerY);
    g.rotate(rotation);

    float currWidth = baseWidth;
    float currHeight = baseHeight;
    for (int i = 0; i < numEllipses; i++) {
      if (i >= startIndex) {
        g.ellipse(0, 0, currWidth, currHeight);
      }

      currWidth *= widthFactor;
      currHeight *= widthFactor * heightRatio;
    }

    g.popMatrix();
  }

  String toString() {
    return "center: " + centerX + ", " + centerY + "\n"
      + "base size: " + baseWidth + "x" + baseHeight + "\n"
      + "width factor: " + widthFactor + "\n"
      + "height ratio: " + heightRatio + "\n"
      + "rotation: " + rotation;

  }
}