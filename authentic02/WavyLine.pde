
class WavyLine {
  float segmentWidth;
  float segmentHeight;

  WavyLine(float segmentWidth, float segmentHeight) {
    this.segmentWidth = segmentWidth;
    this.segmentHeight = segmentHeight;
  }

  void draw(PGraphics g, float x0, float y0, float x1, float y1) {
    PVector p0 = new PVector(x0, y0);
    PVector p1 = new PVector(x1, y1);
    float dx = x1 - x0;
    float dy = y1 - y0;
    float dist = sqrt(dx * dx + dy * dy);
    int numSegments = ceil(dist / segmentWidth);

    float dwx = segmentWidth   *   dx / dist;
    float dwy = segmentWidth   *   dy / dist;
    float dhx = segmentHeight / 2   *   dy / dist;
    float dhy = segmentHeight / 2   *   dx / dist;

    float currX = x0;
    float currY = y0;
    float midX;
    float midY;
    float nextX;
    float nextY;

    for (int i = 0; i < numSegments; i++) {
      midX = currX + dwx / 2;
      midY = currY + dwy / 2;
      nextX = currX + dwx;
      nextY = currY + dwy;

      if (i % 2 == 0) {
        g.bezier(
            currX + dhx, currY + dhy,
            midX + dhx, midY + dhy,
            midX - dhx, midY - dhy,
            nextX - dhx, nextY - dhy);
      }
      else {
        g.bezier(
            currX - dhx, currY - dhy,
            midX - dhx, midY - dhy,
            midX + dhx, midY + dhy,
            nextX + dhx, nextY + dhy);
      }

      currX = nextX;
      currY = nextY;
    }
  }
}
