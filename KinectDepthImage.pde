import SimpleOpenNI.*;

class KinectDepthImage {
  PImage  pImage; 
  boolean kinectFlag=false;
  boolean displayFlag=false;
  boolean backgroundFlag=false;

  int blurRadius=2;
  int minDistance=50; // 50cm 
  int maxDistance=5000;//3.0m
  int depthValue=20;
   
  KinectDepthImage() {
    if(context==null) return;
    if(context.enableDepth() == false || context.enableRGB() == false) {
      println("Can't open the depthMap, maybe the camera is not connected!"); 
      return;
    }
    kinectFlag=true;
    context.setMirror(false);
//    context.alternativeViewPointDepthToImage();
    context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  }
  
  void update() {
    context.update();
  }

  void drawImage() {
    if(displayFlag) drawRGBImage();
    else drawDepthImage();
    fill(0,100,100);
    text("blurRadius:"+blurRadius, 30, 30);
    text("kK c d Space @ KinectDepthImage", 30, 60);
  }
  
  void drawDepthImage() {
    pImage = context.depthImage().get();
    fastblur(pImage, blurRadius);
    image(pImage, 0, 0, width, height);  
  }
  
  void drawRGBImage() {
    pImage = context.rgbImage().get();
    image(pImage, 0, 0, width, height);  
  }

  void extractUser()
  {
    pImage = context.depthImage().get();
    fastblur(pImage, blurRadius);
    pImage = ExtractUser(pImage);
  }

  void getBlob() {
    blobDetection.computeBlobs(pImage.pixels);
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
        strokeWeight(3);
        stroke(i*36, 100, 100);
        for (int m=0; m<b.getEdgeNb(); m+=displayInterval) {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(eA.x*width, eA.y*height, eB.x*width, eB.y*height);
        }
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
    float dt=0.5;
    Blob b;
    EdgeVertex eA, eB;
    creativeCoding.clear();
    creativeCoding.create(n);
    n=0; 
    for (int i=0 ; i<blobDetection.getBlobNb() ; i++) {
      if ((b=blobDetection.getBlob(i))!=null && b.getEdgeNb()>blobNumThreshold) {
        if ((eA = b.getEdgeVertexA(0)) !=null)
            creativeCoding.add(n, (int)((1-eA.x)*width/2+width/4), (int)((1+eA.y)*height/2));
        for (int m=1; m<b.getEdgeNb(); m+=displayInterval) {
          if ((eB = b.getEdgeVertexA(m)) !=null) {
            if((eA.x-eB.x)*(eA.x-eB.x)+(eA.y-eB.y)*(eA.y-eB.y)<dt) {
              creativeCoding.add(n, (int)((1-eB.x)*width/2+width/4), (int)((1+eB.y)*height/2));
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
    if(backgroundDisplayFlag) image(pImage, 0, 0, width, height);  
    drawBlobEdges(backgroundDisplayFlag);
    fill(0);
    text("blob:"+blobDetection.getBlobNb()+" blurRadius:"+blurRadius+" blobThreshold:"+blobThreshold+
      " blobNumThreshold:"+blobNumThreshold+" displayInterval:"+displayInterval, 30, 30);
    if(backgroundFlag) text("kKeEbBpP v m d Space Background @ KinectDepthImage", 30, 60);
    else text("kKeEbBpP v m d Space @ KinectDepthImage", 30, 60);
  }
  
  PImage ExtractUser(PImage InputImage) {
    int[] userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
    PImage Result = InputImage; //createImage(pImage.width, pImage.height, pImage.format);
    Result.loadPixels(); // read pixels
  
    //  change all human detected pixel in kinect view
    for (int i=0; i<userMap.length; i++) 
      if (userMap[i]==0) Result.pixels[i]= color(0);  // black color pixel
      else Result.pixels[i]=color(255);               // Human color pixel
/*  
    // only user pixel in pre set distace have color
    depthValues = context.depthMap();  // input depth pixel value  
    for (int pic = 0; pic<depthValues.length; pic++) {
      if (Result.pixels[pic] != color(0)) {
        if (depthValues[pic] > minDistance && depthValues[pic] < maxDistance) {
          // Result.pixels[pic] = color(0, 255, 0);
        }
        else { 
          Result.pixels[pic] = color(0);
        }
      }
    }  
*/    
    Result.updatePixels();  
    return Result;
  }  

  void increaseDepthValue() {
    depthValue++;
  }
  
  void decreaseDepthValue() {
    depthValue--;
  }
  
  void increaseBlurRadius() {
    blurRadius++;
  }
  
  void decreaseBlurRadius() {
    blurRadius--;
    if(blurRadius<0) blurRadius=0;
  }
  
  void toggleDisplayFlag() {
    displayFlag=!displayFlag;
  }
  
  ArrayList<Integer> FliterUsers() {
    ArrayList<Integer> usersCount = new ArrayList<Integer>();  
    int[] userList = context.getUsers(); // count user
    PVector pos = new PVector(); // initialize X,Y,X variable
  
    for (int i=0; i<userList.length;i++) {
      context.getCoM(userList[i], pos); // get user center point  
      if (pos.z>minDistance && pos.z<maxDistance) {
        usersCount.add(userList[i]);
      }
    }
    return usersCount;
  }

  // Super Fast Blur v1.1
  // by Mario Klingemann 
  // <http://incubator.quasimondo.com>
  // ==================================================
  void fastblur(PImage img, int radius)
  {
    if(radius<1) return;
    int w=img.width;
    int h=img.height;
    int wm=w-1;
    int hm=h-1;
    int wh=w*h;
    int div=radius+radius+1;
    int r[]=new int[wh];
    int g[]=new int[wh];
    int b[]=new int[wh];
    int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
    int vmin[] = new int[max(w,h)];
    int vmax[] = new int[max(w,h)];
    int[] pix=img.pixels;
    int dv[]=new int[256*div];
    for(i=0;i<256*div;i++){
      dv[i]=(i/div);
    }
    yw=yi=0;
    for(y=0; y<h; y++) {
      rsum=gsum=bsum=0;
      for(i=-radius; i<=radius; i++) {
        p=pix[yi+min(wm,max(i,0))];
        rsum+=(p & 0xff0000)>>16;
        gsum+=(p & 0x00ff00)>>8;
        bsum+= p & 0x0000ff;
      }
      for(x=0; x<w; x++) {
        r[yi]=dv[rsum];
        g[yi]=dv[gsum];
        b[yi]=dv[bsum];
        if(y==0){
          vmin[x]=min(x+radius+1,wm);
          vmax[x]=max(x-radius,0);
        }
        p1=pix[yw+vmin[x]];
        p2=pix[yw+vmax[x]];
        rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
        gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
        bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
        yi++;
      }
      yw+=w;
    }
  
    for(x=0; x<w; x++){
      rsum=gsum=bsum=0;
      yp=-radius*w;
      for(i=-radius; i<=radius; i++){
        yi=max(0,yp)+x;
        rsum+=r[yi];
        gsum+=g[yi];
        bsum+=b[yi];
        yp+=w;
      }
      yi=x;
      for (y=0;y<h;y++){
        pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
        if(x==0){
          vmin[y]=min(y+radius+1,hm)*w;
          vmax[y]=max(y-radius,0)*w;
        }
        p1=x+vmin[y];
        p2=x+vmax[y];
        rsum+=r[p1]-r[p2];
        gsum+=g[p1]-g[p2];
        bsum+=b[p1]-b[p2];
        yi+=w;
      }
    }
  }    
}
