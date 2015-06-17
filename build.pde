
void build() {  
  vvl=new ArrayList<UVertexList>();

  UVertexList vl=new UVertexList();
  UVertexList vl2=new UVertexList();
  UVertexList vl3=new UVertexList();
  UVertexList vl4=new UVertexList();

  
  // create 3 circular vertex lists and fill them random 
  // radial offset vertices
  int n=600;
  float r=1; // radius multiplier
  
  for(int i=0; i<n; i++) {
    float deg=map(i,0,n,0,TWO_PI);
    
    // dampen r with fraction of last value
    r=noise(map(i, 0, n, 0, 1*PI)); 
    vl.add(new UVertex(r,0).rotY(deg)); 
    
    r=noise(map(i, 0, n, 0, 1*PI)); 
    vl2.add(new UVertex(r,0).rotY(deg)); 
    
    r=noise(map(i, 0, n, 0, 4*PI)); 
    vl3.add(new UVertex(r,0).rotY(deg)); 
    
    r=noise(map(i, 0, n, 0, 9*PI)); 
    vl4.add(new UVertex(r,0).rotY(deg)); 
    
  }

  float w=18; //w scales the radius of each list
  vl.scale(1*w);
  vl2.scale(3*w);  
  vl3.scale(8*w);
  vl4.scale(9*w);
  
  float h=80; //h simulates the thickness of paper
  vl2.translate(0,h,0);
  vl3.translate(0,2*h,0);
  vl4.translate(0,3*h,0);

  
  //rotate vl2 and vl3 for a cheap "twist" effect
  vl2.rotY(0.2*PI);
  vl3.rotY(0.3*PI);
  vl4.rotY(0.4*PI);

  
  // fill ArrayList vvl with interpolated versions of
  // the three vertex lists
  n=10; // # of interpolated edges
  
  // interpolate vl to vl2
  for(int i=0; i<n; i++) {
    float t=map(i,0,n,0,1);
    
    // optional: use a shaper to modify t
    //t=(1-sin(sq(1-t)*HALF_PI))*0.9+t*0.1;
    UVertexList tmp=vl.lerp(t,vl,vl2);
    // close the tmp vertex list and add it to vvl 
    vvl.add(tmp.close());
    vl.log(vvl.get(vvl.size()-1).str());
    
    tmp=vl2.lerp(t,vl2,vl3);
    vvl.add(tmp.close());
    vl2.log(vvl.get(vvl.size()-1).str());
    
    tmp=vl3.lerp(t,vl3,vl4);
    vvl.add(tmp.close());
    vl3.log(vvl.get(vvl.size()-1).str());

  }
  


  geo=new UGeo().quadstrip(vvl);
  
  // get centroid to center arraylist
  UVertex c=geo.bb().centroid;
  
  // center model and arraylist
  geo.center();  
  for(UVertexList tmp : vvl) tmp.translateNeg(c);

}
