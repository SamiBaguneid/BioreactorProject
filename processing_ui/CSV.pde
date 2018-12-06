class CSV{
  PrintWriter stream;
  String nl = "\n";
  int dataCount = 0;
  int flushDataLimit = 10;
  void makeFile(){
    stream = createWriter("log/" 
    + String.valueOf(year()) + "-" 
    + String.valueOf(month()) + "-" 
    + String.valueOf(day()) + " "
    + String.valueOf(hour()) + "-"
    + String.valueOf(minute()) + "-"
    + String.valueOf(second())
    + ".csv"
    );
    stream.print("Time (ms),Motor Speed,PH,Temperature" + nl);
  }
  void addData(int sensor, int time, float val){
    stream.print(time);
    stream.print(",");
    for (int i = 0; i < sensor; i++){
      stream.print(",");
    }
    stream.print(val);
    for (int i = sensor; i < 2; i++){
      stream.print(",");
    }
    stream.print(nl);
    if (dataCount++ > flushDataLimit){
      flushData();
      dataCount = 0;
    }
  }
  void flushData(){
    stream.flush();
  }
  void closeFile(){
    stream.close();
  }
}
