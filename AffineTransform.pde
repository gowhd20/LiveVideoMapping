import papaya.*;

class AffineTransformation {
  int    crossIndex=-1;
  int    translateX=0, translateY=0, h=10, m=22;
  float  theta=0, scalef=1, shearXf=0, shearYf=0;
  float  deltaTheta=0.001, deltaScale=0.01, deltaShear=0.01;
  float  [] T;
  PVector [] pts, npts;

  AffineTransformation() {
    translateX = 0;
    translateY = 0;
    theta = 0;
    scalef = 1;
    shearXf = 0;
    shearYf = 0;
    deltaTheta = 0.001;
    deltaScale = 0.01;
    deltaShear = 0.01;
    h = 48;
    m = 64;
    pts = new PVector[4];
    for(int i=0; i<4; i++) pts[i]=new PVector();
    npts = new PVector[4];
    for(int i=0; i<4; i++) npts[i]=new PVector();
    T = new float [9];
    for(int i=0; i<3; i++) T[4*i]=1;
  }

  void applyAffineTransformation() {
    translate(translateX, translateY);
    rotate(theta);
    scale(scalef);  
    shearY(shearYf);
    shearX(shearXf);
  }
  
  void applyTransformationMatrix() {
    float ct = scalef*cos(theta);
    float st = scalef*sin(theta);          
    applyMatrix(  
      ct, st, 0.0, translateX,
      -st, ct, 0.0, translateY,
      0.0, 0.0, scalef, 0.0,
      0.0, 0.0, 0.0, 1.0);      
  }  

  void applyPerspectiveMatrix() {
    applyMatrix(  
      T[0], T[1], 0.0, T[2],
      T[3], T[4], 0.0, T[5],
      0.0, 0.0, 1.0, 0.0,
      T[6], T[7], 0.0, T[8]);      
  }  
  
/*
   applyMatrix(  
     ct, 0.0, st, translateX,
     0.0, scalef, 0.0, translateY,
     -st, 0.0, ct, 0.0,
     0.0, 0.0, 0.0, 1.0);      
   translate(translateX, translateY);
   rotate(theta);
   scale(scalef);  
   
   translate(50, 50, 0);
   rotateY(PI/6); 
   stroke(153);
   box(35);
   // Set rotation angles
   float ct = cos(PI/9.0);
   float st = sin(PI/9.0);          
   // Matrix for rotation around the Y axis
   applyMatrix(  ct, 0.0,  st,  0.0,
   0.0, 1.0, 0.0,  0.0,
   -st, 0.0,  ct,  0.0,
   0.0, 0.0, 0.0,  1.0);  
   stroke(255);
   box(50);
 */

  void drawRect() {  
    noFill();
    int x=200;
    strokeWeight(1);
    stroke(0, 0, 100);
    for (int i=0; i<10; i++) 
      rect(i*m, i*h, width-i*m*2, height-i*h*2);
    fill(0, 0, 100);
    text("Live Video Mapping 2013.08.17", x, height/2-40);
    text("x:"+translateX+" y:"+translateY+" theta:"+theta+" scale:"+scalef+" sx:"+shearXf+" sy:"+shearYf, x, height/2-10);
    text("xXyYtTsSqQwW d Space @ AffineTransformation", x, height/2+20);
    text("lbg@dongseo.ac.kr", x, height/2+60);
  }

  void setCross(int k) {
    pts[0].set(m*k, h*k);
    pts[1].set(width-m*k, h*k);
    pts[2].set(width-m*k, height-h*k);
    pts[3].set(m*k, height-h*k);
    npts[0].set(m*k, h*k);
    npts[1].set(width-m*k, h*k);
    npts[2].set(width-m*k, height-h*k);
    npts[3].set(m*k, height-h*k);
  }
  
  void checkCross() {
    int i, j=-1;
    for(i=0; i<4; i++) 
      if(abs(npts[i].x-mouseX)+abs(npts[i].y-mouseY)<6) j=i;
    crossIndex=j;
  }  

  void updateCross() {
    if(crossIndex>=0 && crossIndex<4)
      npts[crossIndex].set(mouseX, mouseY);
  }  
  
  void releaseCross() {
    crossIndex=-1;
  }  

  void drawCross(boolean flag) {
    if(flag) {
      strokeWeight(2);
      stroke(32, 100, 100);
      for(int i=0; i<4; i++)
        drawCross(pts[i].x, pts[i].y, 1);
    }
    if(!flag) {
      strokeWeight(3);
      stroke(120, 100, 100);
      for(int i=0; i<4; i++)
        drawCross(npts[i].x, npts[i].y, 2);
      if(crossIndex!=-1) {
        strokeWeight(5);
        drawCross(npts[crossIndex].x, npts[crossIndex].y, 4);
      }
    }      
  }
  
  void drawCross(float x, float y, int k) {
    line(x-k*m, y, x+k*m, y);
    line(x, y-k*h, x, y+k*h);
  }

 
  void decreaseTranslateX() {
    translateX--;
  }

  void increaseTranslateX() {
    translateX++;
  }

  void decreaseTranslateY() {
    translateY--;
  }

  void increaseTranslateY() {
    translateY++;
  }

  void decreaseTheta() {
    theta-=deltaTheta;
  }
  
  void increaseTheta() {
    theta+=deltaTheta;
  }

  void decreaseScale() {
    scalef-=deltaScale;
  }
  
  void increaseScale() {
    scalef+=deltaScale;
  }

  void decreaseShearX() {
    shearXf-=deltaShear;
  }
  
  void increaseShearX() {
    shearXf+=deltaShear;
  }

  void decreaseShearY() {
    shearYf-=deltaShear;
  }
  
  void increaseShearY() {
    shearYf+=deltaShear;
  }

  void calAffineTransform(boolean debug) 
  {  
    float[][] A = new float[8][9]; 
    float[][] At, AtA;  
    int numDecimals=3;
  
    for(int i=0; i<4; i++) {
      A[2*i][0]=pts[i].x;
      A[2*i][1]=pts[i].y;
      A[2*i][2]=1;
      A[2*i][3]=0;
      A[2*i][4]=0;
      A[2*i][5]=0;
      A[2*i][6]=-pts[i].x*npts[i].x;
      A[2*i][7]=-pts[i].y*npts[i].x;
      A[2*i][8]=-npts[i].x;
      
      A[2*i+1][0]=0;
      A[2*i+1][1]=0;
      A[2*i+1][2]=0;
      A[2*i+1][3]=pts[i].x;
      A[2*i+1][4]=pts[i].y;
      A[2*i+1][5]=1;
      A[2*i+1][6]=-pts[i].x*npts[i].y;
      A[2*i+1][7]=-pts[i].y*npts[i].y;
      A[2*i+1][8]=-npts[i].y;
    }  
      
    At = Mat.transpose(A); 
    AtA = Mat.multiply(At, A);
    
    Eigenvalue eigen = new Eigenvalue(AtA);
    float[][] V = Cast.doubleToFloat(eigen.getV());
    float[][] D = Cast.doubleToFloat(eigen.getD());
    for(int i=0; i<9; i++) T[i]=V[i][0]/V[8][0];
      
    if(debug) {
      println("pts");
      for(int i=0; i<4; i++) println(pts[i].x+" "+pts[i].y);
      println("npts");
      for(int i=0; i<4; i++) println(npts[i].x+" "+npts[i].y);
      println("\nA Matrix");
      Mat.print(A, numDecimals);
      println("\nAtA Matrix");
      Mat.print(AtA, numDecimals);
      println("\nEigenvector Matrix");
      Mat.print(V, numDecimals);
      println("\nEigenvalue Digonal Matrix.");
      Mat.print(D, numDecimals);
      println("\nProjective Transformation Matrix.");
      Mat.print(T, numDecimals);
    }
  }
}


