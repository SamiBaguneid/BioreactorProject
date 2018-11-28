class Graph extends DrawObject{
  
  int axes_colour = #9E9E9E;
  int mark_size = 5;
  
  int border = 40;
  Axis[] axes = {new Axis(0), new Axis(3)};;
  Plot[] plots = {};
  
  Graph(int _x, int _y, int _w, int _h){
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    bckgrnd = #CFD8DC;
    hover_bckgrnd = bckgrnd;
    hover = false;
  }
  void set_plots(Plot[] _plots){
    plots = _plots;
  }
  
  void calc_scale(){
    if (plots != null){
      for (int i = 0; i < plots.length; i++){
        plots[i].calc_scale();
      }
    }
    if (axes != null){
      for (int i = 0; i < axes.length; i++){
        axes[i].calc_scale();
      }
    }
  }
  void draw_axes(){
    if (axes != null){
      for (int i = 0; i < axes.length; i++){
        axes[i].draw(this);
      }
    }
  }
  void draw_plot(){
    if (plots != null){
      for (int i = 0; i < plots.length; i++){
        plots[i].draw(this);
      }
    }
  }
  float get_x(float _x){
    return _x * (w - 2 * border) + x + border;
  }
  float get_y(float _y){
    return y + h - _y * (h - 2 * border) - border;
  }
  void draw(){
    super.draw();
    calc_scale();
    draw_axes();
    draw_plot();
  }
  int get_row_count(){
    int rows = 0;
    for (int i = 0; i < display.graph.plots.length; i++){
      if (rows < display.graph.plots[i].x.size()){
        rows = display.graph.plots[i].x.size();
      }
    }
    return rows;
  }
  String[] export_csv(){
    int row_count = get_row_count();
    String[] rows = new String[row_count];
    for (int row = 0; row < row_count; row++){
      String[] col = new String[plots.length];
      for (int i = 0; i < plots.length; i++){
        col[i] = convert_plot_row(row, plots[i]);
      }
      rows[row] = join(col, ",");
    }
    return rows;
  }
  String convert_plot_row(int row, Plot plot){
    String out = "";
    if (row < plot.x.size()){
      out += str(plot.x.get(row));
    }
    if (row < plot.y.size()){
      if (out.length() > 0){
        out += ",";
      }
      out += str(plot.y.get(row));
    }
    return out;
  }
}
