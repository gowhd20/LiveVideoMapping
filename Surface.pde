// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// An uneven surface boundary

class Surface {
  // We'll keep track of all of the surface points
  Body body;
  ArrayList<Vec2> surface;

  Surface(float theta) {
    surface = new ArrayList<Vec2>();
    for (float x = width-100; x > 100; x -= 5) {
      surface.add(new Vec2(x, map(cos(theta), -1, 1, 480, 580)));
      theta += 0.06;
    }

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) 
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    
    ChainShape chain = new ChainShape();
    chain.createChain(vertices,vertices.length);
    
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    body = box2d.createBody(bd);
    body.createFixture(chain,1);
  }

  Surface() {
    int k=0, maxsize=0;
    if(creativeCoding.numContour<=0) return;
      
    for (int i=0; i<creativeCoding.numContour; i++) {
      if(maxsize<creativeCoding.contour[i].size()) {
        maxsize=creativeCoding.contour[i].size();
        k=i;
      }
    }  

    if(creativeCoding.contour[k].size()<=0) return;
    
    surface = new ArrayList<Vec2>();
    for (int j=0; j<creativeCoding.contour[k].size(); j++) {
      PVector v = creativeCoding.contour[k].get(j);
      surface.add(new Vec2(v.x,v.y));
    }

    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) 
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    
    ChainShape chain = new ChainShape();
    chain.createChain(vertices,vertices.length);

    BodyDef bd = new BodyDef();
    bd.position.set(0.0f,0.0f);
    body = box2d.createBody(bd);
    body.createFixture(chain,1);
  }

  void display() {
    Vec2 v;
    if(surface==null) return;
    if(surface.size()<=1) return;
    strokeWeight(10);
    stroke(0,0,100);
    v = surface.get(0); 
    point(v.x, v.y);
    v = surface.get(surface.size()-1); 
    point(v.x, v.y);
    strokeWeight(5);
    noFill();
    beginShape();
    for (int i=0; i<surface.size(); i++) {
      v = surface.get(i); 
      stroke(360.*i/surface.size(),100,100);
      vertex(v.x,v.y);
    }
    endShape();
  }

  void destroyBody() {
    if(body != null)
      box2d.destroyBody(body);
  }
}


