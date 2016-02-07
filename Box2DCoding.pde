class Box2DCoding {
  float t=0, dt=0.05;
  ArrayList<Particle> particles;
  Surface surface;
  int  addParticleNum=1;
  int  particleSize=4;
  int  bodyType=1;

  Box2DCoding() {
    box2d.createWorld();
    box2d.setGravity(0, -50);
    particles = new ArrayList<Particle>();
  }

  void add() {
    float sz = random(particleSize,2*particleSize);
    for(int i=0; i<addParticleNum; i++)
      particles.add(new Particle(width/2,30,sz,bodyType));
  }
  
  void updateSurface(boolean flag) {
    if(surface != null) surface.destroyBody();
    if(flag) surface = new Surface(noise(t));
    else surface = new Surface();
    surface.display();
  }    

  void draw(boolean flag) {
    t+=dt;
    box2d.step();
    stroke(100);
    strokeWeight(1);
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      if (p.done()) particles.remove(i);
      else p.display();
    }
    if(flag) {
      fill(0, 0, 100);
      text("addParticleNum:"+addParticleNum+" particleSize:"+particleSize+" bodyType:"+bodyType+" displayInterval:"+displayInterval, 30, 30);
      text("aArRpP h f v d Space @ Box2DCoding", 30, 60);
    }  
  }  
}
