import processing.serial.*;

Graph tempGraph;
Graph phGraph;
Graph motorGraph;
//Graph motor2Graph;

float y = 0;
float x = 0;
void setup() {
  size(700, 700);
  tempGraph = new Graph(0, 0, width/2, height/2);
  tempGraph.setYRange(19, 106);

  phGraph = new Graph(0, 350, width/2, height/2);
  phGraph.setYRange(-50, 50);

  motorGraph = new Graph(350, 0, width/2, height/2);
  motorGraph.setYRange(-115, 115);
  
  //motor2Graph = new Graph(350, 175, width/2, height/4);
  //motor2Graph.setYRange(0, 100);

  surface.setResizable(true);

  for (x = 0; x < 1000; x++) {
    y++;
    float sinValue = sin(radians(y)) * 30;
    float sqrValue = (y*y)/10000;
    //println(sqrValue);
    tempGraph.addData(x, y);
    phGraph.addData(x, sinValue);
    motorGraph.addData(x, sqrValue);
    //motor2Graph.addData(x, sqrValue);
  }
}

void draw() {

  canvas_background();
  options();
  user_input();
  onWindowSizeChanged();

  tempGraph.plotAll();
  phGraph.plotAll();
  motorGraph.plotAll();
  //motor2Graph.plotAll();
  
  // Temperature graph Axis
  for (int i = 1; i <= 5; i++){
    stroke(255);
    float yLength = 75;
    float yPos = yLength*i + 25 - yLength;
    float xRatio = (float)width/700;
    float yRatio = (float)height/700;
    line((float)(15*xRatio),(float)(yPos*yRatio),(float)(25*xRatio),(float)(yPos*yRatio));
    if (i == 1) {
      line((float)(25*xRatio),(float)(25*yRatio),(float)(25*xRatio),(float)(325*yRatio));
    }
    if (i == 5) {
      line((float)(15*xRatio),(float)(yPos*yRatio),(float)(350*xRatio),(float)(yPos*yRatio));
    }
    //stroke(160);
    //line((float)(25*xRatio),(float)(yPos*yRatio),(float)(350*xRatio),(float)(yPos*yRatio));
    float textSize = 12*yRatio;
    // Limits minimum text size so it is still readable
    if (textSize < 10) {
      textSize = 10;
    }
    textSize(textSize);
    fill(255);
    int temp = 100;
    text(temp/i, 5*xRatio, (yPos - 1)*yRatio);
    text("Temperature", 5*xRatio, 10*yRatio);
    text("Time", 320*xRatio, 337*yRatio);
  }
  
  // pH graph Axis
  for (int i = 1; i <= 5; i++){
    stroke(255);
    float yLength = 75;
    float yPos = yLength*i + 25 - yLength;
    float xRatio = (float)width/700;
    float yRatio = (float)height/700;
    line((float)(365*xRatio),(float)(yPos*yRatio),(float)(375*xRatio),(float)(yPos*yRatio));
    if (i == 1) {
      line((float)(375*xRatio),(float)(25*yRatio),(float)(375*xRatio),(float)(325*yRatio));
    }
    //if (i == 5) {
    //  stroke(255);
    //  line((float)(365*xRatio),(float)(yPos*yRatio),(float)(700*xRatio),(float)(yPos*yRatio));
    //}
    stroke(128);
    line((float)(375*xRatio),(float)(yPos*yRatio),(float)(700*xRatio),(float)(yPos*yRatio));
    if (i == 5) {
      stroke(255);
      line((float)(365*xRatio),(float)(yPos*yRatio),(float)(700*xRatio),(float)(yPos*yRatio));
    }
    float textSize = 12*yRatio;
    // Limits minimum text size so it is still readable
    if (textSize < 10) {
      textSize = 10;
    }
    textSize(textSize);
    fill(255);
    int temp = 100;
    text(temp/i, 355*xRatio, (yPos - 1)*yRatio);
    text("pH", 360*xRatio, 10*yRatio);
    text("Time", 670*xRatio, 337*yRatio);
  }
  
  // Motor graph Axis
  for (int i = 1; i <= 5; i++){
    stroke(255);
    float yLength = 75;
    float yPos = yLength*i + 375 - yLength;
    float xRatio = (float)width/700;
    float yRatio = (float)height/700;
    line((float)(15*xRatio),(float)(yPos*yRatio),(float)(25*xRatio),(float)(yPos*yRatio));
    if (i == 1) {
      line((float)(25*xRatio),(float)(375*yRatio),(float)(25*xRatio),(float)(675*yRatio));
    }
    if (i == 5) {
      line((float)(15*xRatio),(float)(yPos*yRatio),(float)(350*xRatio),(float)(yPos*yRatio));
    }
    float textSize = 12*yRatio;
    // Limits minimum text size so it is still readable
    if (textSize < 10) {
      textSize = 10;
    }
    textSize(textSize);
    fill(255);
    int temp = 100;
    text(temp/i, 5*xRatio, (yPos - 1)*yRatio);
    text("Motor", 5*xRatio, 360*yRatio);
    text("Time", 320*xRatio, 687*yRatio);
  }
}

void onWindowSizeChanged() {
  tempGraph.updateRatio();
  phGraph.updateRatio();
  motorGraph.updateRatio();
  //motor2Graph.updateRatio();
}

void options() {
  int no_of_options = 3;
  String[] options = {"Temp", "pH", "Motor"};
  int bezel_height = round(20 * y_sf());
  int rect_width = round(100 * x_sf());
  int rect_height = round(35 * y_sf());
  int text_x_bezel = round(10 * x_sf());
  int text_y_bezel = round(10 * y_sf());
  int lowest_x = width/2;
  int lowest_y = height/2;
  int bezel_width = ((width/2)%rect_width)/(no_of_options + 1);
  textSize(25 * (x_sf() + y_sf())/2); //change this, this sucks
  for (int i = 0; i < no_of_options; i++) {
    int options_x = lowest_x + bezel_width*(i +1) + rect_width*i;
    int options_y = bezel_height + lowest_y;
    int text_x = options_x + text_x_bezel;
    int text_y = options_y + rect_height - text_y_bezel;
    fill(255);
    rect(options_x, options_y, rect_width, rect_height);
    fill(0);
    text(options[i], text_x, text_y);
  }
}

void canvas_background() {
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
}

void user_input() {
  int lowest_x = width/2;
  int lowest_y = height/2;
  int box_width = round(80 * x_sf());
  int x_bezel = round(18 * x_sf());
  int y_bezel = round(150 * y_sf());
  rect(lowest_x + x_bezel, lowest_y + y_bezel, box_width, box_width);
  rect(lowest_x + x_bezel*2 + box_width, lowest_y + y_bezel, box_width, box_width);
  fill(255);
  rect(lowest_x + x_bezel*3 + box_width*2, lowest_y + y_bezel + box_width - 20, 20, 20);
  fill(0);
  rect(lowest_x + x_bezel*4 + box_width*2 + 20, lowest_y + y_bezel, box_width, box_width);
  stroke(255);
}

float x_sf() {
  return (float)width/700;
}

float y_sf() {
  return (float)height/700;
}  

void mouseMoved() {
  y++;
  float sinValue = sin(radians(y)) * 30;
  tempGraph.addData(x, (y % 75)+25);
  phGraph.addData(x, sinValue);
  motorGraph.addData(x, map(mouseY, 0, height, -100, 100));
  //motor2Graph.addData(x, map(mouseX, 0, width, 90, 15));
}
