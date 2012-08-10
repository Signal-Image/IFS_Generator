import controlP5.*;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentAdapter;
import java.awt.Insets;
import java.awt.Rectangle;

IFS redIFS;
IFS greenIFS;
IFS blueIFS;

PImage compo;

Hist3d hist3d;

float[][] RB = new float[][] { {0,0}, {0,0} };
float[][] GB = new float[][] { {0,0}, {0,0} };
float[][] BB = new float[][] { {0,0}, {0,0} };

float[][] RA = new float[][] { {1,1}, {1,1} };
float[][] GA = new float[][] { {1,1}, {1,1} };
float[][] BA = new float[][] { {1,1}, {1,1} };

ControlP5 controlP5;
ControlWindow controlWindow;
Slider ra11, ra12, ra21, ra22, rb11, rb12, rb21, rb22;
Slider ga11, ga12, ga21, ga22, gb11, gb12, gb21, gb22;
Slider ba11, ba12, ba21, ba22, bb11, bb12, bb21, bb22;

void setup() {
  colorMode(RGB,1);

  hist3d = new Hist3d();

  size(512,512);
  init(512,512);

  /* Frame resize event manager */
  frame.setResizable(true);
  frame.addComponentListener(new ComponentAdapter() { 
   public void componentResized(ComponentEvent e) { 
     if(e.getSource()==frame) {
       Rectangle bounds = frame.getBounds();
       Insets insets = frame.getInsets();
       int w = bounds.width - insets.left - insets.right;
       int h = bounds.height - insets.top - insets.bottom;
       if((w % RB.length) != 0 || (h % RB[0].length) != 0) {
         frame.resize(bounds.width - (w % RB.length), bounds.height - (h % RB[0].length));
       } else {
         println("resize frame : " + w + " x " + h);
         init(w, h);
         redraw();
       }
     } 
   } 
  });

  /* User Interface */
  controlP5 = new ControlP5(this);  
  PFont p = createFont("Arial",12); 
  controlP5.setControlFont(p, 10);

  controlWindow = controlP5.addControlWindow("controlP5window",50,50,400,300);
  controlWindow.hideCoordinates();
  controlWindow.setBackground(color(40));
  controlWindow.setTitle("IFS Parameters");  

  ra11 = controlP5.addSlider("RA11",-1,1);
  rb11 = controlP5.addSlider("RB11",-2,2); rb11.linebreak();
  ra12 = controlP5.addSlider("RA12",-1,1);
  rb12 = controlP5.addSlider("RB12",-2,2); rb12.linebreak();
  ra21 = controlP5.addSlider("RA21",-1,1);
  rb21 = controlP5.addSlider("RB21",-2,2); rb21.linebreak();
  ra22 = controlP5.addSlider("RA22",-1,1);
  rb22 = controlP5.addSlider("RB22",-2,2); rb22.linebreak();

  ga11 = controlP5.addSlider("GA11",-1,1);
  gb11 = controlP5.addSlider("GB11",-2,2); gb11.linebreak();
  ga12 = controlP5.addSlider("GA12",-1,1);
  gb12 = controlP5.addSlider("GB12",-2,2); gb12.linebreak();
  ga21 = controlP5.addSlider("GA21",-1,1);
  gb21 = controlP5.addSlider("GB21",-2,2); gb21.linebreak();
  ga22 = controlP5.addSlider("GA22",-1,1);
  gb22 = controlP5.addSlider("GB22",-2,2); gb22.linebreak();

  ba11 = controlP5.addSlider("BA11",-1,1);
  bb11 = controlP5.addSlider("BB11",-2,2); bb11.linebreak();
  ba12 = controlP5.addSlider("BA12",-1,1);
  bb12 = controlP5.addSlider("BB12",-2,2); bb12.linebreak();
  ba21 = controlP5.addSlider("BA21",-1,1);
  bb21 = controlP5.addSlider("BB21",-2,2); bb21.linebreak();
  ba22 = controlP5.addSlider("BA22",-1,1);
  bb22 = controlP5.addSlider("BB22",-2,2); bb22.linebreak();

  for(Controller s :
    new Controller[] {ra11, ra12, ra21, ra22, rb11, rb12, rb21, rb22,
      ga11, ga12, ga21, ga22, gb11, gb12, gb21, gb22,
      ba11, ba12, ba21, ba22, bb11, bb12, bb21, bb22}) {
        s.moveTo(controlWindow);
      }

  controlP5.addButton("randomize").moveTo(controlWindow);
  controlP5.addButton("empty").moveTo(controlWindow);
  controlP5.addButton("export").moveTo(controlWindow);
  controlP5.addButton("rotate").moveTo(controlWindow);
  
  empty();
  
}

void init(int w, int h) {
  redIFS = new IFS(w, h);
  redIFS.setParameters( RA, RB);
  greenIFS = new IFS(w, h);
  greenIFS.setParameters( GA, GB);
  blueIFS = new IFS(w, h);
  blueIFS.setParameters( BA, BB);
}

void draw() {
  background(0);

  boolean stable = true;
  if(!redIFS.isStable()) {stable = false; redIFS.iterate();}
  if(!greenIFS.isStable()) {stable = false; greenIFS.iterate();}
  if(!blueIFS.isStable()) {stable = false; blueIFS.iterate();}
  if(stable) noLoop(); else loop();

  compo = compose(
    redIFS.getImage(),
    greenIFS.getImage(),
    blueIFS.getImage()
  );
  
  set(0, 0, compo);
  hist3d.setImage(compo);

}

void RA11(float n) { RA[0][0] = n; redIFS.evolve(); redraw(); }
void RA12(float n) { RA[1][0] = n; redIFS.evolve(); redraw(); }
void RA21(float n) { RA[0][1] = n; redIFS.evolve(); redraw(); }
void RA22(float n) { RA[1][1] = n; redIFS.evolve(); redraw(); }
void RB11(float n) { RB[0][0] = n; redIFS.evolve(); redraw(); }
void RB12(float n) { RB[1][0] = n; redIFS.evolve(); redraw(); }
void RB21(float n) { RB[0][1] = n; redIFS.evolve(); redraw(); }
void RB22(float n) { RB[1][1] = n; redIFS.evolve(); redraw(); }

void GA11(float n) { GA[0][0] = n; greenIFS.evolve(); redraw(); }
void GA12(float n) { GA[1][0] = n; greenIFS.evolve(); redraw(); }
void GA21(float n) { GA[0][1] = n; greenIFS.evolve(); redraw(); }
void GA22(float n) { GA[1][1] = n; greenIFS.evolve(); redraw(); }
void GB11(float n) { GB[0][0] = n; greenIFS.evolve(); redraw(); }
void GB12(float n) { GB[1][0] = n; greenIFS.evolve(); redraw(); }
void GB21(float n) { GB[0][1] = n; greenIFS.evolve(); redraw(); }
void GB22(float n) { GB[1][1] = n; greenIFS.evolve(); redraw(); }

void BA11(float n) { BA[0][0] = n; blueIFS.evolve(); redraw(); }
void BA12(float n) { BA[1][0] = n; blueIFS.evolve(); redraw(); }
void BA21(float n) { BA[0][1] = n; blueIFS.evolve(); redraw(); }
void BA22(float n) { BA[1][1] = n; blueIFS.evolve(); redraw(); }
void BB11(float n) { BB[0][0] = n; blueIFS.evolve(); redraw(); }
void BB12(float n) { BB[1][0] = n; blueIFS.evolve(); redraw(); }
void BB21(float n) { BB[0][1] = n; blueIFS.evolve(); redraw(); }
void BB22(float n) { BB[1][1] = n; blueIFS.evolve(); redraw(); }

void randomize() {
  Random r = new Random();
  for(Slider s :
    new Slider[] { ra11, ra12, ra21, ra22, 
      ga11, ga12, ga21, ga22, 
      ba11, ba12, ba21, ba22}) {
          int sign = random(2) < 1 ? -1 : 1;
          s.setValue(sign * 0.5 + (float)r.nextGaussian()*.15);
      }
  for(Slider s :
    new Slider[] { rb11, rb12, rb21, rb22,
      gb11, gb12, gb21, gb22,
      bb11, bb12, bb21, bb22}) {
          s.setValue((float)r.nextGaussian()*.3);
      }
}

void empty() {
  for(Slider s :
    new Slider[] { ra11, ra12, ra21, ra22, rb11, rb12, rb21, rb22,
      ga11, ga12, ga21, ga22, gb11, gb12, gb21, gb22,
      ba11, ba12, ba21, ba22, bb11, bb12, bb21, bb22}) {
        s.setValue(0);
      }
}

private String date() {
    String s = Integer.toString(10000*year()+100*month()+day())
    + Integer.toString(10000*hour()+100*minute()+second())
      + "-" + Integer.toString(millis());
      return s;
}

void export() {
  println("export PNG");
  compo.save("IFS-" + date() + ".png");
}

void rotate() {
  hist3d.setAutorotate(!hist3d.getAutorotate());
}



void mousePressed() {
  ra11.setValue(map(mouseX,0,width,-1,1));
  rb11.setValue(map(mouseY,0,height,-2,2));
}

PImage compose(PImage red, PImage green, PImage blue) {
  PImage tmp = createImage(red.width, red.height, RGB);
  for(int i = 0; i < red.pixels.length; i++) {
    tmp.pixels[i] = color(
      blue(red.pixels[i]),
      blue(green.pixels[i]),
      blue(blue.pixels[i])
    );
  }
  return tmp;
}

void keyPressed() {
  if(key==' ') {
    rotate();
  }
}
