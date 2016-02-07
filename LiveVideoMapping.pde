// very basic demonstration of the fullscreen api's capabilities
import blobDetection.*;
import pbox2d.*;
import org.jbox2d.collision.shapes.*; // jbox2d
import org.jbox2d.common.*;           // jbox2d
import org.jbox2d.dynamics.*;         // jbox2d

int     displayType=0;
int     displayInterval=3;
int     blobThreshold=128;
int     kinectWidth=640;
int     kinectHeight=480;
int     blobNumThreshold=500;
boolean backgroundDisplayFlag=true;
boolean fullScreen=true;
boolean particleColor=false;

PBox2D  box2d;
PGraphics pGraphic;
SimpleOpenNI context=null; 
BlobDetection blobDetection;
KinectDepthImage kinectDepthImage;
PerlineNoiseImage perlineNoiseImage;
AffineTransformation affineTransformation;
CreativeCoding creativeCoding;
Box2DCoding box2DCoding;

void setup() {
  if(fullScreen) size(displayWidth, displayHeight, P3D);   
  else size(1000, 600, P3D);  
  PFont myFont = createFont("Aharoni-Bold-48", 16);
  textFont(myFont);
  textAlign(LEFT, CENTER);
  smooth();

  frameRate(30);
  colorMode(HSB, 360, 100, 100);

  blobDetection = new BlobDetection(kinectWidth, kinectHeight);
  blobDetection.setPosDiscrimination(true);
  blobDetection.setThreshold(blobThreshold/255.);
  pGraphic = createGraphics(kinectWidth, kinectHeight);
  perlineNoiseImage = new PerlineNoiseImage();
  context = new SimpleOpenNI(this);
  kinectDepthImage = new KinectDepthImage();  
  creativeCoding = new CreativeCoding();
  affineTransformation = new AffineTransformation();  
  affineTransformation.setCross(12);  
  box2d = new PBox2D(this);
  box2DCoding = new Box2DCoding();
}

void draw() {
  background(0, 0, 0);
//  affineTransformation.applyAffineTransformation();
//  affineTransformation.applyTransformationMatrix();
  affineTransformation.drawCross(false);
  affineTransformation.applyPerspectiveMatrix();
  affineTransformation.drawCross(true);

  if (displayType==0) {
    affineTransformation.drawRect();
  }
  else if (displayType==1) {
    perlineNoiseImage.update();
    perlineNoiseImage.getBlob();
    if(backgroundDisplayFlag)
      perlineNoiseImage.drawBlob();
    else {
      int n = perlineNoiseImage.countBlobNumThreshold();  
      perlineNoiseImage.assignCreativeCoding(n);
      creativeCoding.draw();
    }  
  } 
  else if (displayType==2) {
    box2DCoding.add();
    if(!backgroundDisplayFlag){
      perlineNoiseImage.update();
      perlineNoiseImage.getBlob();
      int n = perlineNoiseImage.countBlobNumThreshold();  
      perlineNoiseImage.assignCreativeCoding(n);
      creativeCoding.draw();
    }  
    box2DCoding.updateSurface(backgroundDisplayFlag);
    box2DCoding.draw(backgroundDisplayFlag);
  } 
  else if (displayType==3 && kinectDepthImage.kinectFlag) {
    kinectDepthImage.update();
    kinectDepthImage.drawImage();
  }
  else if (displayType==4 && kinectDepthImage.kinectFlag) {
    kinectDepthImage.update();
    if(backgroundDisplayFlag) {
      kinectDepthImage.drawImage();
    }
    else {
      box2DCoding.add();
      kinectDepthImage.extractUser();
      kinectDepthImage.getBlob();
      int n = kinectDepthImage.countBlobNumThreshold();  
      kinectDepthImage.assignCreativeCoding(n);
      creativeCoding.draw();
      box2DCoding.updateSurface(backgroundDisplayFlag);
      box2DCoding.draw(backgroundDisplayFlag);
    }
  }
}

boolean sketchFullScreen() {
  return fullScreen;
}

void mouseMoved() {
  affineTransformation.checkCross();  
}

void mouseDragged() {
  if(mouseButton == LEFT) 
    affineTransformation.updateCross();  
}

void mouseReleased() {
  affineTransformation.releaseCross();  
}

//

void keyPressed() {
  if (key==' ') {
    affineTransformation.calAffineTransform(true);
  } 
  else if (key=='d') {
    displayType++; 
    if (displayType>4) displayType=0;
  } 
  else if (key=='v') 
    backgroundDisplayFlag=!backgroundDisplayFlag;
  else if (key=='e') {
    blobThreshold--; 
    if (blobThreshold<0) blobThreshold=0;
    blobDetection.setThreshold(blobThreshold/255.);
  } 
  else if (key=='E') {
    blobThreshold++; 
    if (blobThreshold>255) blobThreshold=255;
    blobDetection.setThreshold(blobThreshold/255.);
  } 
  else if (key=='b') 
    blobNumThreshold-=10;
  else if (key=='B') 
    blobNumThreshold+=10;
  else if (key=='p') {
    displayInterval--; 
    if(displayInterval<1) displayInterval=1;
  }
  else if (key=='P')  
    displayInterval++;
  else if (key=='a') {
    box2DCoding.addParticleNum--; 
    if(box2DCoding.addParticleNum<1) box2DCoding.addParticleNum=1;
  }
  else if (key=='A')  
    box2DCoding.addParticleNum++;    
  else if (key=='r') {
    box2DCoding.particleSize--; 
    if(box2DCoding.particleSize<1) box2DCoding.particleSize=1;
  }
  else if (key=='R')  
    box2DCoding.particleSize++;   
  else if (key=='h') {  
    box2DCoding.bodyType++;
    if(box2DCoding.bodyType==2) 
      box2DCoding.bodyType=0;
  }    
  else if (key=='f') 
    particleColor=!particleColor;
  else if (key=='m') 
    creativeCoding.minMargin--;
  else if (key=='M') 
    creativeCoding.minMargin++;
  else if (key=='c') 
    kinectDepthImage.toggleDisplayFlag();    
  else if (key=='k')
    kinectDepthImage.decreaseBlurRadius();
  else if (key=='K')
    kinectDepthImage.increaseBlurRadius();
  else if (key=='h')
    kinectDepthImage.decreaseDepthValue();
  else if (key=='H')
    kinectDepthImage.increaseDepthValue();
  else if (key=='x') 
    affineTransformation.decreaseTranslateX(); 
  else if (key=='X') 
    affineTransformation.increaseTranslateX(); 
  else if (key=='y')  
    affineTransformation.decreaseTranslateY(); 
  else if (key=='Y')  
    affineTransformation.increaseTranslateY(); 
  else if (key=='t') 
    affineTransformation.decreaseTheta(); 
  else if (key=='T') 
    affineTransformation.increaseTheta(); 
  else if (key=='s') 
    affineTransformation.decreaseScale(); 
  else if (key=='S') 
    affineTransformation.increaseScale(); 
  else if (key=='q') 
    affineTransformation.decreaseShearX(); 
  else if (key=='Q') 
    affineTransformation.increaseShearX(); 
  else if (key=='w') 
    affineTransformation.decreaseShearY(); 
  else if (key=='W') 
    affineTransformation.increaseShearY(); 
  else if (key=='g') 
    perlineNoiseImage.toggleDoubleLayer();
  else if (key=='n') 
    perlineNoiseImage.decreaseEllipseNumber();
  else if (key=='N')  
    perlineNoiseImage.increaseEllipseNumber();
  else if (key>='1'&&key<='9')
    creativeCoding.setCodeType(key-'1');  
}


