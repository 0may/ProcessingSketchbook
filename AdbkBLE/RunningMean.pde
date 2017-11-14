public class RunningMean {
  
  private int bufsize;
  private double[] buffer;
  private int bufidx;
  private double mean;
  
  RunningMean(int N, double initValue) {
    
    bufsize = N;
    buffer = new double[bufsize]; 
    
    for (int n = 0; n < bufsize; n++)
      buffer[n] = initValue;
    
    mean = initValue;
  }
  
  double updateMean(double newValue) {
    mean += (newValue - buffer[bufidx])/(double)bufsize;
  
    buffer[bufidx] = newValue;
  
    bufidx = (bufidx + 1) % bufsize;
    
    return mean;
  }
  
  double getMean() {
    return mean; 
  }  
}