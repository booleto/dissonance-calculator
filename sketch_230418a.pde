import processing.data.JSONObject;
import processing.sound.*;

AudioSample audio;
double deltatime = 1;
PFont font;
PGraphics pg;
float x;
float y;
float dissonance = 1;
float[] dissonance_vals;
int diss_idx = 0;
float fx_intensity = 0.03;
int tilesX = 50;
int tilesY = 50;
float y_mod = 0.1;
String text = "oof";


void setup() {
  font = createFont("Arial", 600);
  textFont(font);
  size(600, 600, P2D);
  pg = createGraphics(600, 600, P2D);
  
  JSONArray arr = loadJSONArray("dissonance_list.json");

  // Create an int array with the same length as the JSON array
  dissonance_vals = new float[arr.size()];

  // Copy the values from the JSON array to the int array
  for (int i = 0; i < arr.size(); i++) {
    dissonance_vals[i] = arr.getFloat(i);
  }
  
  audio = new SoundFile(this, "In-the-morning-Jazz-Glory_320kbps.mp3");
  audio.play();
  
  deltatime = audio.duration() * 1000 / dissonance_vals.length;
}

void draw() {
  background(0);
  
  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.textFont(font);
  pg.textSize(400);
  
  pg.pushMatrix();
  pg.translate(width/2, height/2 - 100);
  pg.textAlign(CENTER, CENTER);
  pg.text(text, 0, 0);
  pg.popMatrix();
  pg.endDraw();
  
  image(pg, 0, 0);
  updateDissonance();
  runFx();
}

float last_millis = 0;
void updateDissonance() {
  int current_frame = audio.positionFrame();
  diss_idx = int(audio.positionFrame() / 1024) - 1;
  if (diss_idx >= dissonance_vals.length || diss_idx < 0) {
    dissonance = 0;
    return;
  }
  dissonance = dissonance_vals[diss_idx];
  print("Progress: " + current_frame + "/" + audio.frames());
  print("\t Max segments: " + dissonance_vals.length);
  print("\t Millis: " + millis());
  print("\t Segment: " + diss_idx);
  println("\t Playtime: " + diss_idx * deltatime);
}



void runFx() {
  int tileW = int(width/tilesX);
  int tileH = int(height/tilesY);

  for (int y = 0; y < tilesY; y++) {
    for (int x = 0; x < tilesX; x++) {
      float fx = pow(dissonance * fx_intensity, 1.5);
      
      int sourcex = x * tileW + int(fx * random(-1, 1));
      int sourcey = y * tileH + int(fx * random(-1, 1) * y_mod);
      int sourcew = tileW;
      int sourceh = tileH;
      
      int destx = x * tileW;
      int desty = y * tileH;
      int destw = tileW;
      int desth = tileH;
      
      copy(pg, sourcex, sourcey, sourcew, sourceh, destx, desty, destw, desth);
    }
  }
}
