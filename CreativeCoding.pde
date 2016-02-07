class CreativeCoding {

  float p=0;
  int   i, j, k, codeType=1, numContour=0, minMargin=200;
  ArrayList<PVector> [] contour;
  
  CreativeCoding() {
  }

  void clear() {
    for(i=0; i<numContour; i++)
      contour[i].clear();  
    numContour=0;  
  }

  void create(int numContour) {
    contour = (ArrayList<PVector>[])new ArrayList[numContour];
    for(i=0; i<numContour; i++)
      contour[i] = new ArrayList<PVector>();
    this.numContour=numContour;  
  }
  
  void add(int i, int x, int y) {
    if(y<height-minMargin)
      contour[i].add(new PVector(x, y));  
  }
  
  void setCodeType(int codeType) {
    this.codeType=codeType+1;
  }
  
  void draw() {
    if(codeType==1) draw1();
    else if(codeType==2) draw2();
    else if(codeType==3) draw3();
    else if(codeType==4) draw4();
    else if(codeType==5) draw5();
    else if(codeType==6) draw6();
    else if(codeType==7) draw7();
    else if(codeType==8) draw8();
    else if(codeType==9) draw9();
    fill(0, 0, 100);
    stroke(0,0,100);
    strokeWeight(2);
    line(0,height-minMargin,width,height-minMargin); 
    text("codeType:"+codeType+" minMargin:"+minMargin+" displayInterval:"+displayInterval, 30, 30);
    text("123456789 mM pP f h v d Space @ CreativeCoding", 30, 60);
  }
  
  void draw1() {
    p+=0.002;
    strokeWeight(1);
    stroke(0, 0, 100);
    fill(noise(p)*360, 100, 100);
    for (i=0; i<numContour; i++) {
      for (j=0; j<contour[i].size(); j++) {
        PVector v = contour[i].get(j);
        ellipse(v.x, v.y, displayInterval, displayInterval);
      }
    }  
  }

  void draw2() {
    strokeWeight(displayInterval);
    for (i=0; i<numContour; i++) {
      int l=contour[i].size()-1;
      for (j=0; j<l; j++) {
        stroke(360.*j/l, 100, 100);
        PVector v1 = contour[i].get(j);
        PVector v2 = contour[i].get(j+1);
        line(v1.x, v1.y, v2.x, v2.y);
      }
    }  
  }
  
  void draw3() {
    p+=0.002;
    strokeWeight(2);
    for (i=0; i<numContour; i++) {
      int l=contour[i].size()-1;
      for (j=0; j<l; j++) {
        stroke(360.*j/l, 100, 100);
        PVector v1 = contour[i].get(j);
        PVector v2 = contour[i].get(j+1);
        float dx=v2.x-v1.x;
        float dy=v2.y-v1.y;
        line(v1.x, v1.y, v1.x-dy*3, v1.y+dx*3);
      }
    }  
  }
  
  void draw4() {
    int n=displayInterval/2+1;
    for (i=0; i<numContour; i++) {
      for(k=0; k<n; k++) {
        int l=contour[i].size()-1;
        noFill();
        strokeWeight(n-k+1);
        stroke(0, 0, 100-k*70/n);
        beginShape();
        for (j=0; j<l; j++) {
          PVector v1 = contour[i].get(j);
          PVector v2 = contour[i].get(j+1);
          float dx=v2.x-v1.x;
          float dy=v2.y-v1.y;
          vertex(v1.x-dy*k, v1.y+dx*k);
        }
        endShape(CLOSE);
      }  
    }  
  }

  void draw5() {
    int n=displayInterval/2+1;
    for (i=0; i<numContour; i++) {
      int l=contour[i].size();
      noFill();
      strokeWeight(2);
      stroke(0, 0, 100);
      beginShape(LINES);
      for (j=0; j<l; j++) {
        PVector v1 = contour[i].get(j);
        PVector v2 = contour[i].get((j+n)%l);
        vertex(v1.x, v1.y);
        vertex(v2.x, v2.y);
      }
      endShape();
    }  
  }

  void draw6() {
  }
  
  void draw7() {
  }
  
  void draw8() {
  }
  
  void draw9() {
  }
}

