
class Graph {

  GraphWriter graphWriter;
  int sWidth = width;
  int sHeight = height;
  int gWidth;
  int gHeight;
  int gX;
  int gY;

  Graph(int gX, int gY, int gWidth, int gHeight) {
    this.gWidth = gWidth;
    this.gHeight = gHeight;
    this.gX = gX;
    this.gY = gY;
    this.graphWriter = new GraphWriter(gX, gY, gWidth, gHeight);
    //this.graphWriter.setXRange(0, gWidth);
    this.graphWriter.setYRange(0, gHeight);
    this.graphWriter.writeBackground();
  }

  void addData(float x, float y) {
    this.graphWriter.addData(x, y);
  }

  void plotOne(float x, float y) {
    this.graphWriter.addData(x, y);
    this.graphWriter.writeOne();
  }

  void plotAll() {
    this.graphWriter.writeBackground();
    this.graphWriter.writeAll();
  }

  void updateRatio() {
    float xRatio = float(width)/float(this.sWidth);
    float yRatio = float(height)/float(this.sHeight);
    int gX = int(this.gX * xRatio);
    int gY = int(this.gY * yRatio);
    int gWidth = int(this.gWidth * xRatio);
    int gHeight = int(this.gHeight * yRatio);
    this.graphWriter.setProps(gX, gY, gWidth, gHeight);
    this.graphWriter.writeBackground();
    this.graphWriter.writeAll();
  }

  //long millis = System.currentTimeMillis() % 1000;

  void setYRange(int min, int max) {
    this.graphWriter.setYRange(min, max);
  }

  void setXRange(int min, int max) {
    this.graphWriter.setXRange(min, max);
  }
  
}
