import processing.opengl.*;

int dataNum = 0;
int drawRate = 21;

JSONArray pitches;
JSONArray rolls;

float pitch =0;
float roll =0;

float[][] trail;

int index = 0;

int startTimer;
 
void setup(){
size(1500, 1000, OPENGL);
smooth();
pitches = loadJSONArray("pitch.json");
rolls = loadJSONArray("roll.json");
trail = new float[rolls.size()][3];
startTimer = millis();
}
 
void draw(){
  if ((millis() - startTimer) > drawRate) {
    background(0);
    lights();
    noStroke();
    
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateY(roll);
    rotateX(pitch); 
    pitch = radians(pitches.getFloat(index));
    roll = radians(rolls.getFloat(index));
    translate(0, 60, 0);
    box(10,600,10);
    popMatrix();
    
    float[] endOfNeedle = {0.0, 360.0, 0.0};
    endOfNeedle = rotatePointAboutXAxis(endOfNeedle, pitch);
    endOfNeedle = rotatePointAboutYAxis(endOfNeedle, roll);
    endOfNeedle[0] += width/2;
    endOfNeedle[1] += height/2;
    trail[index] = endOfNeedle;
    
    for (int i=0; i<=index; i++) {
      stroke(0,255,0);
      point(trail[i][0], trail[i][1], trail[i][2]);
    }

    if (index < pitches.size()-1) {
      index = (index + 1);
    }

    startTimer = millis();
  }
}

float cameraYrotation = 0;
void keyPressed() {
  if (key == 'a') {
    cameraYrotation += 0.1;
  } else if (key =='d') {
    cameraYrotation -= 0.1;
  }
  float[] cameraCenter = {width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0)};
  cameraCenter[0] -= width/2;
  cameraCenter[1] -= height/2;
  cameraCenter = rotatePointAboutYAxis(cameraCenter, cameraYrotation);
  cameraCenter[0] += width/2;
  cameraCenter[1] += height/2;
  camera(cameraCenter[0], cameraCenter[1], cameraCenter[2], width/2.0, height/2.0, 0, 0, 1, 0);
}

float[] rotatePointAboutXAxis(float[] P, float radians) {
  float[][] Xrotate = {
  {1.0, 0.0, 0.0},
  {0.0, cos(radians), -sin(radians)},
  {0.0, sin(radians), cos(radians)}
  };
  return rotateAboutAxis(Xrotate, P);
}

float[] rotatePointAboutYAxis(float[] P, float radians) {
  float[][] Yrotate = {
  {cos(radians), 0.0, sin(radians)},
  {0.0, 1.0, 0.0},
  {-sin(radians), 0, cos(radians)}
  };
  return rotateAboutAxis(Yrotate, P);
}

float[] rotatePointAboutZAxis(float[] P, float radians) {
  float[][] Zrotate = {
  {cos(radians), -sin(radians), 0.0},
  {sin(radians), cos(radians), 0.0},
  {0.0, 0, 1.0}
  };
  return rotateAboutAxis(Zrotate, P);
}

float[] rotateAboutAxis(float[][] rotationMatrix, float[] P) {
  float[] R = new float[3];
  for (int r=0; r < R.length; r++) {
     for (int i=0; i < P.length; i++) {
       R[r] += rotationMatrix[r][i] * P[i];
     }
  }
  return R;
}

