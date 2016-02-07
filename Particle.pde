// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  float c;
  int  type;

  Particle(float x, float y, float r_, int type_) {
    r = r_;
    c = random(0,355);
    type = type_;
    // This function puts the particle in the Box2d world
    makeBody(x,y,r);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  void makeBody(float x, float y, float r) {
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = BodyType.DYNAMIC;
    if(type==0) {
      // Make the body's shape a circle
      CircleShape cs = new CircleShape();
      cs.m_radius = box2d.scalarPixelsToWorld(r);      
      FixtureDef fd = new FixtureDef();
      fd.shape = cs;
      fd.density = 1;
      fd.friction = 1.2;
      fd.restitution = 0.7;
      body = box2d.world.createBody(bd);
      body.createFixture(fd);
    }
    else if(type==1) {
      PolygonShape sd = new PolygonShape();
      Vec2[] vertices = new Vec2[4];
      vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-10, 16));
      vertices[1] = box2d.vectorPixelsToWorld(new Vec2(8, 0));
      vertices[2] = box2d.vectorPixelsToWorld(new Vec2(10, -7));
      vertices[3] = box2d.vectorPixelsToWorld(new Vec2(-5, -5));
      sd.set(vertices, vertices.length);
      body = box2d.createBody(bd);
      body.createFixture(sd, 1.0);
    }      
    body.setLinearVelocity(new Vec2(random(-10f,10f),random(-10f,10f)));
    body.setAngularVelocity(random(-1,1));
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    if(particleColor) fill(c,100,100);
    else fill(200);
    if(type==0) {
      ellipse(0,0,r*2,r*2);
      line(0,0,r,0);
    }
    else if(type==1) {
      Fixture f = body.getFixtureList();
      PolygonShape ps = (PolygonShape) f.getShape();
      beginShape();
      for (int i = 0; i < ps.getVertexCount(); i++) {
        Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
        vertex(v.x, v.y);
      }
      endShape(CLOSE);
    }  
    popMatrix();
  }
}


