import processing.serial.*;

Graph tempGraph;
Graph phGraph;
Graph motorGraph;
Graph motor2Graph;

float y = 0;
float x = 0;
void setup() {
  size(700, 700);
  tempGraph = new Graph(0, 0, width/2, height/2);
  tempGraph.setYRange(0, 1000);

  phGraph = new Graph(0, 350, width/2, height/2);
  phGraph.setYRange(-50, 50);


  motorGraph = new Graph(350, 0, width/2, height/4);
  motorGraph.setYRange(0, 100);
  
  motor2Graph = new Graph(350, 175, width/2, height/4);
  motor2Graph.setYRange(0, 100);

  surface.setResizable(true);

  for (x = 0; x < 1000; x++) {
    y++;
    float sinValue = sin(radians(y)) * 30;
    float sqrValue = (y*y)/10000;
    //println(sqrValue);
    tempGraph.addData(x, y);
    phGraph.addData(x, sinValue);
    motorGraph.addData(x, sqrValue);
    motor2Graph.addData(x, sqrValue);
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
  motor2Graph.plotAll();
}

void onWindowSizeChanged() {
  tempGraph.updateRatio();
  phGraph.updateRatio();
  motorGraph.updateRatio();
  motor2Graph.updateRatio();
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
}

void mouseClicked(){
  int no_of_options = 3;
  int bezel_height = round(20 * y_sf());
  int rect_width = round(100 * x_sf());
  int rect_height = round(35 * y_sf());
  int lowest_x = width/2;
  int lowest_y = height/2;
  int bezel_width = ((width/2)%rect_width)/(no_of_options + 1);
  if(mouseY > lowest_y + bezel_height && mouseY < lowest_y + bezel_height + rect_height){
    if(mouseX > lowest_x + bezel_width && mouseX <  lowest_x + bezel_width + rect_width){
      println(mouseX); 
    }
    if(mouseX > lowest_x + bezel_width*2 + rect_width && mouseX <  lowest_x + bezel_width*2 + rect_width*2){
      println(mouseX);
    }
    if(mouseX > lowest_x + bezel_width*3 + rect_width*2 && mouseX <  lowest_x + bezel_width*3 + rect_width*3){
      println(mouseX);
    }
  }
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
  phGraph.addData(x, sinValue);
  motorGraph.addData(x, map(mouseY, 0, height, 100, 0));
  motor2Graph.addData(x, map(mouseX, 0, width, 100, 0));
}
