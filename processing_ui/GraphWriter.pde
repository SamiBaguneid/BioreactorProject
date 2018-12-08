class GraphWriter {

  int gWidth = 100;
  int gHeight = 50;
  int gX = 0;
  int gY = 50;
  float yMin = 0;
  float yMax = 350;
  float xMin = 0;
  float xMax = 350;
  int dataSize = 0;

  ArrayList<Float> valueList;
  ArrayList<Float> timeList;

  GraphWriter(int gX, int gY, int gWidth, int gHeight) {
    this.gX = gX;
    this.gY = gY;
    this.gWidth = gWidth;
    this.gHeight = gHeight;
    this.dataSize = this.gWidth*2;
    this.valueList = new ArrayList<Float>(this.dataSize);
    this.timeList = new ArrayList<Float>(this.dataSize);
    for (int i = 0; i< this.valueList.size(); i++){
      this.valueList.add(float(0));
      this.timeList.add(float(0));
    }
  }

  void setYRange(int min, int max) {
    this.yMin = min;
    this.yMax = max;
  }

  void setXRange(float min, float max) {
    this.xMin = min;
    this.xMax = max;
  }

  void setProps(int gX, int gY, int gWidth, int gHeight) {
    this.gX = gX;
    this.gY = gY;
    this.gWidth = gWidth;
    this.gHeight = gHeight;
  }

  void addData(float x, float y) {
    if (this.valueList.size() == this.dataSize) {
      this.valueList.remove(0);
    }
    this.valueList.add(y);
    this.timeList.add(x);
  }

  void writeOne() {
    stroke(127, 34, 255);
    int lastIndex = valueList.size()-1;
    float value = this.valueList.get(lastIndex);
    float time = this.timeList.get(lastIndex);
    point(time, value);
  }

  void writeAll() {
    stroke(#FFFFFF);
    for (int index = 0; index < valueList.size(); index++) { 
      float yValue = this.valueList.get(index);
      float xValue = this.timeList.get(index);
      float xPos = map(xValue, this.xMin, this.xMax, this.gX, this.gX + this.gWidth);
      //float xPos = map(xValue, 0, valueList.size(), this.gX, this.gX + this.gWidth);
      float yPos = map(yValue, this.yMin, this.yMax, this.gY + this.gHeight, this.gY );
      
      if (xPos > this.gX + 25 * width /700){
        point(xPos, yPos);
      }
    }
  }

  void writeBackground() {
    noStroke();
    // Dark blue
    //color c = #030F1F;
    // Black
    color c = #000000;
    fill(c);
    rect(this.gX, this.gY, this.gWidth, this.gHeight);
  }
}
