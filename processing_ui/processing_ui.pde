import processing.serial.*;

SerialInterface serialInterface = new SerialInterface();
CSV csv = new CSV();

Graph tempGraph;
Graph phGraph;
Graph motorGraph;
String input = "0.0";
int inputMode = 0;

float[] targets = {700.0, 5.0, 30.0};

void setup(){
  size(700, 700);
  
  motorGraph = new Graph(0, 0, width/2, height/2);
  motorGraph.setXRange(0, 10);
  motorGraph.setYRange(0, 2000);
  
  phGraph = new Graph(width/2, 0, width/2, height/2);
  phGraph.setXRange(0, 10);
  phGraph.setYRange(0, 7);
  
  tempGraph = new Graph(0, height/2, width / 2, height / 2);
  tempGraph.setXRange(0, 10);
  tempGraph.setYRange(20, 40);
  

  
  surface.setResizable(true);
  serialInterface.Start(this);
  csv.makeFile();
  input = str(targets[inputMode]);
}

void draw(){
  canvas_background();
  options();
  user_input();
  onWindowSizeChanged();
  tempGraph.plotAll();
  phGraph.plotAll();
  motorGraph.plotAll();
  serialInterface.receiveMessage();
  //tempGraph.addData((float) millis() / 1000, random(0,40));
}
void keyPressed(){
  char[] acceptedKeys = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', RETURN, ENTER, BACKSPACE};
  if (contains(acceptedKeys, key)){
    if (key == RETURN || key == ENTER){
      if (!Float.isNaN(float(input))){
        targets[inputMode] = float(input);
        input = str(targets[inputMode]);
        serialInterface.SetConstant(inputMode, targets[inputMode]);
      }
    }else if (key == BACKSPACE){
      if (input.length() > 0){
        input = input.substring(0, input.length() - 1);
      }
    }else{
      input += key;
    }
  }
  println(input);
}
boolean contains(char[] cs, char c){
  for (int i = 0; i < cs.length; i++){
    if (cs[i] == c){
      return true;
    }
  }
  return false;
}
void options(){
  int no_of_options = 3;
  String[] options = {"Motor", "   PH", "Temp"};
  int bezel_height = round(20 * y_sf());
  int rect_width = round(100 * x_sf());
  int rect_height = round(35 * y_sf());
  int text_x_bezel = round(10 * x_sf());
  int text_y_bezel = round(10 * y_sf());
  int lowest_x = width/2;
  int lowest_y = height/2;
  int bezel_width = ((width/2)%rect_width)/(no_of_options + 1);
  textSize(25 * (x_sf() + y_sf())/2); //change this, this sucks
  for(int i = 0; i < no_of_options; i++){
    int options_x = lowest_x + bezel_width*(i +1) + rect_width*i;
    int options_y = bezel_height + lowest_y;
    int text_x = options_x + text_x_bezel;
    int text_y = options_y + rect_height - text_y_bezel;
    if (inputMode == i){
      fill(#64B5F6);
    }else{
      fill(255);
    }
    rect(options_x, options_y, rect_width, rect_height);
    fill(0);
    text(options[i], text_x, text_y);
  }
}



void canvas_background(){
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  
}
void onWindowSizeChanged() {
  tempGraph.updateRatio();
  phGraph.updateRatio();
  motorGraph.updateRatio();
}


void user_input(){
  int lowest_x = width/2;
  int lowest_y = height/2;
  int box_width = round(80 * x_sf());
  int x_bezel = round(18 * x_sf());
  int y_bezel = round(150 * y_sf());
  if (targets[inputMode] == float(input)){
    fill(#43A047);
  }else{
    fill(#D32F2F);
  }
  rect(lowest_x + x_bezel, lowest_y + y_bezel, width/2 - x_bezel*2, box_width);
  fill(#FFFFFF);
  text(input, lowest_x + x_bezel + 20, lowest_y + y_bezel + 2 * box_width / 3);
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
      inputMode = 0;
      input = str(targets[inputMode]);
    }
    if(mouseX > lowest_x + bezel_width*2 + rect_width && mouseX <  lowest_x + bezel_width*2 + rect_width*2){
      inputMode = 1;
      input = str(targets[inputMode]);
    }
    if(mouseX > lowest_x + bezel_width*3 + rect_width*2 && mouseX <  lowest_x + bezel_width*3 + rect_width*3){
      inputMode = 2;
      input = str(targets[inputMode]);
    }
  }
}

float x_sf(){
  return (float)width/700;
}
float y_sf(){
  return (float)height/700;
}
