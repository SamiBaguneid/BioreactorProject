class Plot{
  Axis x_axis;
  Axis y_axis;
  int colour = #E64A19;
  FloatList x = new FloatList();
  FloatList y = new FloatList();
  Plot(Graph graph){
    x_axis = graph.axes[1];
    y_axis = graph.axes[0];
  }
  Plot(){}
  void calc_scale(){
    if (x.size() > 0)
    x_axis.update_max_min(x.max(), x.min());
    if (y.size() > 0)
    y_axis.update_max_min(y.max(), y.min()); //<>// //<>//
  }
  void draw(Graph graph){
    for (int i = 1; i < x.size() && i < y.size(); i++){
      stroke(colour);
      float x1 = graph.get_x(x_axis.apply_scale(x.get(i)));
      float y1 = graph.get_y(y_axis.apply_scale(y.get(i)));
      float x2 = graph.get_x(x_axis.apply_scale(x.get(i - 1)));
      float y2 = graph.get_y(y_axis.apply_scale(y.get(i - 1)));
      
      line(x1, y1, x2, y2);
    }
  }
}
