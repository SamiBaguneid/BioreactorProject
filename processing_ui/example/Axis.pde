class Axis{
  float scale;
  float shift;
  float maximum;
  float minimum;
  float interval = 1;
  float mark_const = 2;
  float mark_size = 0.01f;
  float label_offset = 0.02f;
  String label = "";
  boolean grid = true;
  
  //Side: 0 = Left, 1 = Top, 2 = Right, 3 = Bottom
  int side = 0;
  Axis(int _side){
    side = _side;
  }
  void update_max_min(float _max, float _min){
    if (_max > maximum){
      maximum = _max;
    }
    if (_min < minimum){
      minimum = _min;
    }
  }
  void calc_scale(){
    scale = maximum - minimum;
    shift = minimum;
    if (scale == 0 || maximum == -100000 && minimum == 100000){
      scale = 1;
      shift = 0;
    }
    maximum = -100000;
    minimum = 100000;
    interval = pow(10, floor(log(scale) / log(10)))/mark_const;
  }
  float round2(float x, float precision){
    return round(x / precision) * precision;
  }
  float apply_scale(float _n){
    return (_n - shift) / scale;
  }
  void draw(Graph graph){
    int start_x = side / 2 * (side + 1) % 2;
    int start_y = (1 - side / 2) * (side) % 2;
    int dir_x = side % 2;
    int dir_y = (side + 1) % 2;
    
    draw_main_line(start_x, start_y, dir_x, dir_y, graph);
    
    draw_marks(start_x, start_y, dir_x, dir_y, graph);
    
    draw_label(start_x, start_y, dir_x, dir_y, graph);
  }
  void draw_main_line(int start_x, int start_y, int dir_x, int dir_y, Graph graph){
    stroke(graph.axes_colour);
    line(graph.get_x(start_x), graph.get_y(start_y), graph.get_x(start_x + dir_x), graph.get_y(start_y + dir_y));
  }
  void draw_marks(int start_x, int start_y, int dir_x, int dir_y, Graph graph){
    fill(#000000);
    textSize(8);
    for (float i = ceil(shift / interval) * interval; i < shift + scale; i += interval){
      float _x = start_x + dir_x * apply_scale(i);
      float _y = start_y + dir_y * apply_scale(i);
      if (grid){
        line(graph.get_x(_x), graph.get_y(_y), graph.get_x(_x + dir_y), graph.get_y(_y + dir_x));
      }
      line(graph.get_x(_x), graph.get_y(_y), graph.get_x(_x - dir_y * mark_size), graph.get_y(_y - dir_x * mark_size));
      String num = str(round(100 * i) / 100f);
      text(num, graph.get_x(_x - dir_y * label_offset), graph.get_y(_y - dir_x * label_offset));
    }
  }
  void draw_label(int start_x, int start_y, int dir_x, int dir_y, Graph graph){
    text(label, graph.get_x(start_x + dir_x * 0.5f - dir_y * label_offset * 2), graph.get_y(start_y + dir_y * 0.5f - dir_x * label_offset * 2));
  }
}
