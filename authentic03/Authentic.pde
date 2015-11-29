
class Authentic {

  int x;
  int y;
  int width;
  int height;
  float cornerRadius;

  PGraphics drawing;
  PGraphics mask;

  PFont letterFont;
  char letter;

  PFont titleFont;
  PFont heavyFont;
  PFont regularFont;
  PFont lightFont;
  PFont smallFont;

  Authentic(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;

    cornerRadius = 12;

    init();
  }

  void init() {
    initLetter();
    initMask();
    initText();
    redraw();
  }

  private void initLetter() {
    // http://www.dafont.com/super-retro-m54.font
    letterFont = createFont("Super Retro Italic M54.ttf", 168 * height / 150);
    letter = 'E';
  }

  private void initMask() {
    mask = createGraphics(width, height, P2D);
    drawMask(mask);
  }

  private void initText() {
    titleFont = createFont("HelveticaNeue-Bold", 22 * 150 / height);
    heavyFont = createFont("Times", 20 * 150 / height);
    regularFont = createFont("Helvetica", 18 * 150 / height);
    lightFont = createFont("Helvetica-Light", 18 * 150 / height);
    smallFont = createFont("HelveticaNeue-Bold", 14 * 150 / height);
  }

  private void drawMask(PGraphics g) {
    g.beginDraw();
    g.pushStyle();
    g.fill(0);
    g.rect(0, 0, width, height);
    g.fill(255);
    g.rect(0, 0, width, height, cornerRadius);
    g.popStyle();
    g.endDraw();
  }

  void redraw() {
    initLetter();

    drawing = createGraphics(width, height, P2D);

    PGraphics g = drawing;
    drawBackground(g);
    drawCurveBlock(g);
    drawKeyboard(g);
    drawWaveBlock(g);
    drawNebula(g);
    drawText(g);
  }

  private void drawBackground(PGraphics g) {
    PGraphics bg = createGraphics(width, height, P2D);

    float x0 = 0.3 * width;
    float y0 = -0.2 * height;
    float innerRadius = 0;
    float outerRadius = width-x0;
    RadialGradient grad = new RadialGradient(x0, y0, innerRadius, x0 + 0.2 * width, y0, outerRadius);
    grad.addColorStop(0, 0xfff7b86b);
    grad.addColorStop(1, 0xfff5546b);
    grad.fillRect(bg, 0, 0, width, height, false);
    bg.mask(mask);

    g.beginDraw();
    g.pushStyle();
    g.image(bg, 0, 0);
    g.popStyle();
    g.endDraw();
  }

  private void drawCurveBlock(PGraphics g) {
    g.beginDraw();

    drawCurves(g, 0xffccccff);
    drawCurves(g, 0xffccccff);

    g.endDraw();
  }

  private void drawCurves(PGraphics g, color c) {
    float centerX = 0.3 * width;
    float centerY = -0.3 * height;
    ConcentricEllipse e0 = new ConcentricEllipse(centerX, centerY, 100, 100);
    ConcentricEllipse e1 = new ConcentricEllipse(centerX, centerY, 100, 100);
    e0.widthFactor = 1.01;
    e1.widthFactor = 1.012;
    e0.heightRatio = 1;
    e1.heightRatio = 1.03125;
    e0.rotation = 1.7671459;
    e1.rotation = 1.6444274;

    g.pushStyle();

    g.stroke(c, 64);
    g.strokeWeight(1);
    g.noFill();

    e0.draw(g);
    e1.draw(g);

    g.popStyle();
  }

  private void drawKeyboard(PGraphics g) {
    PImage keyboard = loadImage("keyboard.jpg");
    g.beginDraw();
    g.pushStyle();

    g.blendMode(ADD);
    g.tint(255, 32);
    g.image(keyboard, 0.51 * width, 0, 0.22 * width, 0.94 * height);

    g.popStyle();
    g.endDraw();
  }

  private void drawWaveBlock(PGraphics canvas) {
    drawWavyLines(canvas, 0);
    drawWavyLines(canvas, random(8, 14));
  }

  private void drawWavyLines(PGraphics canvas, float slope) {
    PGraphics g = createGraphics(width, height, P2D);

    int segmentWidth = 12;
    int segmentHeight = 2;
    float lineHeight = 4;
    int numLines = floor((height + segmentHeight + slope) / lineHeight);
    WavyLine wavyLine = new WavyLine(segmentWidth, segmentHeight);

    g.beginDraw();
    g.stroke(255);
    g.strokeWeight(0.5);
    g.noFill();
    for (int i = 0; i < numLines; i++) {
      wavyLine.draw(g, 0, i * lineHeight, width, i * lineHeight - slope);
    }
    for (int i = 0; i < numLines; i++) {
      wavyLine.draw(g, 0, i * lineHeight, width, i * lineHeight);
    }
    g.endDraw();

    PGraphics mask = createGraphics(width, height, P2D);
    mask.beginDraw();
    mask.fill(0);
    mask.rect(0, 0, width, height);
    mask.fill(255);
    mask.rect(0.46 * width, 0, 0.02 * width, 0.94 * height);
    mask.rect(0.51 * width, 0, 0.22 * width, 0.94 * height);
    mask.endDraw();
    g.mask(mask);

    canvas.beginDraw();
    canvas.pushStyle();
    canvas.tint(255, 64);
    canvas.blendMode(ADD);
    canvas.image(g, 0, 0);
    canvas.popStyle();
    canvas.endDraw();
  }

  private void drawNebula(PGraphics g) {
    PImage nebula = loadImage("monkeyhead.jpg");
    float scale = height / nebula.height;
    scale = 0.5;

    g.beginDraw();
    g.pushStyle();

    g.blendMode(ADD);
    g.tint(255, 32);
    g.image(nebula, 0.41 * width, 0, nebula.width * scale, nebula.height * scale);

    g.popStyle();
    g.endDraw();
  }

  private void drawText(PGraphics g) {
    g.beginDraw();
    g.pushStyle();
    g.fill(0x88111111);

    drawTitleText(g);
    drawFirstBarcode(g);
    drawSecondBarcode(g);
    drawProductKey(g);
    drawProofOfLicense(g);
    drawCertificateOfAuthenticity(g);
    drawXLabel(g);

    g.popStyle();
    g.endDraw();
  }

  private void drawTitleText(PGraphics g) {
    float j = 1;
    g.textFont(titleFont);

    for (int i = 0; i < 4; i++) {
      g.text("EssentialSoft Authwave 5 XT", 0.05 * width + jitter(j), 0.15 * height + jitter(j));
      g.text("OEM Software", 0.05 * width + jitter(j), 0.25 * height + jitter(j));
    }
  }

  private void drawFirstBarcode(PGraphics g) {
    float j = 1;
    String label = "FQC-" + getRandomDigits(5);

    drawBarcode(g, 0.07 * width, 0.30 * height, 0.34 * width, 0.09 * height);
    g.textFont(smallFont);

    for (int i = 0; i < 4; i++) {
      g.text(label, 0.07 * width + jitter(j), 0.45 * height + jitter(j));
    }
  }

  private void drawProductKey(PGraphics g) {
    float j = 1;
    String productKey = getRandomAlphanumeric(5) + "-" + getRandomAlphanumeric(5) + "-" + getRandomAlphanumeric(5);

    g.textFont(regularFont);

    for (int i = 0; i < 4; i++) {
      g.text("Product Key:", 0.08 * width + jitter(j), 0.61 * height + jitter(j));
      g.text(productKey, 0.08 * width + jitter(j), 0.70 * height + jitter(j));
    }
  }

  private void drawSecondBarcode(PGraphics g) {
    float j = 1;
    String label = "00" + getRandomDigits(3) + "-" + getRandomDigits(3) + "-" + getRandomDigits(3) + "-" + getRandomDigits(3);

    g.textFont(lightFont);
    drawBarcode(g, 0.07 * width, 0.73 * height, 0.34 * width, 0.09 * height);

    for (int i = 0; i < 4; i++) {
      g.text(label, 0.14 * width + jitter(j), 0.93 * height + jitter(j));
    }
  }

  private void drawBarcode(PGraphics g, float x, float y, float w, float h) {
    g.pushStyle();
    g.fill(0);
    g.noStroke();

    float currX = 0;
    float currW;
    while (currX < w) {
      currW = random(1, 3);
      g.rect(x + currX, y, currW, h);
      currX += currW + random(0.5, 2);
    }

    g.popStyle();
  }

  private void drawProofOfLicense(PGraphics g) {
    float j = 1;

    g.textFont(heavyFont);

    for (int i = 0; i < 4; i++) {
      g.text("Genuine Product", 0.55 * width + jitter(j), 0.46 * height + jitter(j));
    }
  }

  private void drawCertificateOfAuthenticity(PGraphics g) {
    float j = 1;
    g.pushMatrix();

    g.translate(0.95 * width, 0.1 * height);
    g.rotate(PI/2);

    for (int i = 0; i < 4; i++) {
      g.textFont(regularFont);
      g.text("Certificate of Authenticity", jitter(j), jitter(j));

      g.textFont(smallFont);
      g.text("Label not to be", 12 + jitter(j), 24 + jitter(j));
      g.text("sold separately", 12 + jitter(j), 40 + jitter(j));
    }

    g.popMatrix();
  }

  private void drawXLabel(PGraphics g) {
    float j = 1;
    String label = "X" + getRandomDigits(2) + "-" + getRandomDigits(5);

    for (int i = 0; i < 4; i++) {
      g.textFont(lightFont);
      g.text(label, 0.81 * width + jitter(j), 0.88 * height + jitter(j));
    }
  }

  private String getRandomDigits(int n) {
    String s = "";
    for (int i = 0; i < n; i++) {
      s += floor(random(10));
    }
    return s;
  }

  private String getRandomAlphanumeric(int n) {
    String alphabet = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String s = "";
    for (int i = 0; i < n; i++) {
      s += alphabet.charAt(floor(random(alphabet.length())));
    }
    return s;
  }

  private float jitter(float n) {
    return random(-n, n);
  }

  void draw(PGraphics g) {
    drawing.mask(mask);
    g.image(drawing, x, y);
  }
}
