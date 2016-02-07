class PerlineNoiseImage {

  boolean  doubleLayer=false;
  int    ellipseNumber=5;
  float  p=0, q=0, dp=0.0075, dq=0.015;
 
  PerlineNoiseImage() {
  }
  
  void update() {
    float x, y, r1, r2, g;
    pGraphic.beginDraw();
    pGraphic.background(255);
    pGraphic.noStroke();
    for (int i=0; i<ellipseNumber; i++) {
      x=noise(p+i)*pGraphic.width;
      y=(noise(p+i+1)+1)*pGraphic.height/2-60;
      r1=60+noise(q+i)*240;
      r2=60+noise(q+i+1)*120;
      g=noise(p+i)*200;
      pGraphic.fill(g);
      pGraphic.ellipse(x, y, r1, r2);
      if(doubleLayer) {
        g-=noise(p+i+1)*10;
        x+=noise(p+i)*10;
        y+=noise(p+i+1)*10;
        r1-=30+noise(p+i)*50;
        r2-=20+noise(p+i+1)*40;
        pGraphic.fill(g);
        pGraphic.ellipse(x, y, r1, r2);
      }
    }
    pGraphic.endDraw();
    p+=dp;
    q+=dq;
  }
  
  void getBlob() {
    blobDetection.computeBlobs(pGraphic.pixels);
  }
  
  int countBlobNumThreshold() {
    int  n=0;
    Blob b;
    for(int i=0; i<blobDetection.getBlobNb(); i++) 
      if ((b=blobDetection.getBlob(i))!=null && b.getEdgeNb()>blobNumThreshold) n++;
    return n;  
  }

  void drawBlobEdges(boolean drawBox) {
    Blob b;
    EdgeVertex eA, eB;
    float  dx, dy, d=2.;
    noFill();
    for (int i=0 ; i<blobDetection.getBlobNb() ; i++) {
      if ((b=blobDetection.getBlob(i))!=null && b.getEdgeNb()>blobNumThreshold) {
        strokeWeight(4);
        stroke(120+i*30, 100, 100);
        beginShape();
        for (int m=0; m<b.getEdgeNb(); m+=displayInterval) {
          if ((eA = b.getEdgeVertexA(m)) !=null)
            vertex(eA.x*width, eA.y*height);
        }
        endShape();
        if (drawBox) {
          strokeWeight(1);
          stroke(239, 100, 100);
          rect(b.xMin*width, b.yMin*height, b.w*width, b.h*height);
          text("<"+i+","+b.getEdgeNb()+">", (b.xMin+b.w/2)*width, (b.yMin+b.h/2)*height);
        }
      }
    }
  }
  
  void assignCreativeCoding(int n) {
    float dt=0.001;
    Blob b;
    EdgeVertex eA, eB;
    creativeCoding.clear();
    creativeCoding.create(n);
    n=0; 
    for (int i=0 ; i<blobDetection.getBlobNb() ; i++) {
      if ((b=blobDetection.getBlob(i))!=null && b.getEdgeNb()>blobNumThreshold) {
        if ((eA = b.getEdgeVertexA(0)) !=null) {
          creativeCoding.add(n, (int)(eA.x*width), (int)(eA.y*height));
        }
        for (int m=displayInterval; m<b.getEdgeNb(); m+=displayInterval) {
          if ((eB = b.getEdgeVertexA(m)) !=null) {
            if(((eA.x-eB.x)*(eA.x-eB.x)+(eA.y-eB.y)*(eA.y-eB.y))<dt) {
              creativeCoding.add(n, (int)(eB.x*width), (int)(eB.y*height));
              eA = eB;
            }  
            else println((eA.x-eB.x)*(eA.x-eB.x)+(eA.y-eB.y)*(eA.y-eB.y));
          }
        }
        n++;  
      }
    }
  }

  void drawBlob() {
    if(backgroundDisplayFlag) image(pGraphic, 0, 0, width, height);
    drawBlobEdges(backgroundDisplayFlag);
    fill(0);
    text("blob:"+blobDetection.getBlobNb()+" n:"+ellipseNumber+" blobThreshold:"+blobThreshold+
      " blobNumThreshold:"+blobNumThreshold+" displayInterval:"+displayInterval, 30, 30);
    if(doubleLayer) text("nNeEbBpP v g d Space doubleLayer @ PerlineNoiseImage", 30, 60);
    else text("nNeEbBpP v g d Space black:0 white:255 @ PerlineNoiseImage", 30, 60);
  }
  
  void decreaseEllipseNumber() {
    ellipseNumber--;
  }
  
  void increaseEllipseNumber() {
    ellipseNumber++;
  }

  void toggleDoubleLayer() {
    doubleLayer=!doubleLayer;
  }
}

