class IFS {
  private int w,h;  // width, height
  private int sx,sy;
  private int sw,sh;
  private float[][] v;

  private float[][] b;
  private float[][] a;

  private boolean stable;
  
  IFS(int w_, int h_) {
    w = w_;
    h = h_;
    v = new float[h][w];
  }
  
  void setParameters(float[][] a_, float[][] b_) {
    b = b_;
    a = a_;
    sx = a.length;
    sy = b[0].length;
    sw = w / sx;
    sh = h / sy;
    stable = false;
  }
  
  void iterate() {
    int x,y;
    boolean s = true;
    float tmp;
    for(int i = 0; i < h; i++) {
      for(int j = 0; j < w; j++) {
        x = j / sw;
        y = i / sh;
        tmp = v[(i%sh)*sy][(j%sw)*sx]*a[x][y] +b[x][y];
        if(tmp != v[i][j]) {
          v[i][j] = tmp;
          s = false;
        }
      }
    }
    stable = s;
  }
  
  boolean isStable() {
    return stable;
  }
  
  void evolve() {
    stable = false;
  }
  
  PImage getImage() {
    float max = max(1,maxVal());
    float min = minVal();
    PImage img = createImage(w,h,ALPHA);
    for(int i = 0; i < h; i++) {
      for(int j = 0; j < w; j++) {
        img.pixels[i*w+j] = (int)(map(v[i][j],min,max,0,255));
      }
    }
    return img;
  }
  
  float minVal() {
    float t = MAX_FLOAT;
    for(float[] v_ : v) {
      for(float a : v_) {
        t = min(a,t);
      }
    }
    return t;
  }

  float maxVal() {
    float t = -MAX_FLOAT;
    for(float[] v_ : v) {
      for(float a : v_) {
        t = max(a,t);
      }
    }
    return t;
  }
}
