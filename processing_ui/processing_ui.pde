import processing.serial.*;

SerialInterface serialInterface = new SerialInterface();


void setup(){
  size(700, 700);
  surface.setResizable(true);
  serialInterface.Start(this);
}



void draw(){
  canvas_background();
  options();
  user_input();
}



void options(){
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
  for(int i = 0; i < no_of_options; i++){
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



void canvas_background(){
  background(0);
  stroke(255);
  line(width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  
}



void user_input(){
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





float x_sf(){
  return (float)width/700;
}




float y_sf(){
  return (float)height/700;
}
