import java.util.ArrayList;

import processing.core.PApplet;
//import processing.event.*;
import unlekker.mb2.geo.*;
import unlekker.mb2.util.*;
//import ec.util.*;
import processing.pdf.*;  

boolean doDrawModel=false;

private UVertexList vl, vl2, vl3, vl4;
ArrayList<UVertexList> vvl;
UGeo geo;
UNav3D nav;

float maxRad=50f*UMB.PTMM;

public void setup() {
  size(600, 600, OPENGL);
  
  build();
  export();

  // set PApplet reference
//  UBase.setPApplet(this);
  UMB.setPApplet(this);
  
  // create navigation tool
  nav=new UNav3D();
}

public void draw() {
  background(0);
  stroke(255, 0, 0);
  noFill();
  translate(width/2, height/2);
  
  nav.doTransforms();
  
//  rotateX(PI/2);
  lights();

  // draw the master list
    for(UVertexList l:vvl) {
      l.draw();
    }

  // draw the model
  if (doDrawModel) {
    fill(255, 100, 0, 200);
    noStroke();
    geo.draw();
 }
}

void keyPressed() {
  if(key==' ') doDrawModel=!doDrawModel;
}

public void export() {
     println("exporting pdf!!!!!!!!!!!");
    
     int index=0;
     for(UVertexList l:vvl) {
     String filename=sketchPath("boh_test_"+String.valueOf(index)+".pdf");
    
      int pageWidth = 368;
      int pageHeight = 526;
    
    // create PGraphicsPDF canvas
      PGraphicsPDF pdf=(PGraphicsPDF)createGraphics(pageWidth+100, pageHeight+100, PDF, filename);
    
    // get pdf ready to draw
      pdf.beginDraw();
      pdf.noFill();
    
    // tell Modelbuilder to draw to our PDF
      UMB.setGraphics(pdf);

      pdf.pushMatrix();
      pdf.translate((pageWidth+10)/2, (pageHeight+10)/2);
      l.rotX(0.5*PI);
      
      //shape
      l.draw();

      //book edge
      pdf.line(-pageWidth/2, -pageHeight/2, pageWidth/2, -pageHeight/2);
      pdf.line(-pageWidth/2, pageHeight/2, pageWidth/2, pageHeight/2);
      pdf.line(-pageWidth/2, -pageHeight/2, -pageWidth/2, pageHeight/2);
      pdf.line(pageWidth/2, -pageHeight/2, pageWidth/2, pageHeight/2);
    
//binding holes
      pdf.ellipse(-pageWidth/2+20, -pageHeight/10*1, 3*UMB.PTMM,3*UMB.PTMM);
      pdf.ellipse(-pageWidth/2+20, -pageHeight/10*3, 3*UMB.PTMM,3*UMB.PTMM);
      pdf.ellipse(-pageWidth/2+20, pageHeight/10*1, 3*UMB.PTMM,3*UMB.PTMM);
      pdf.ellipse(-pageWidth/2+20, pageHeight/10*3, 3*UMB.PTMM,3*UMB.PTMM);
      pdf.popMatrix();
      
      // end draw, close and flush the PDF file
      pdf.endDraw();
      pdf.flush();
      pdf.dispose();
      
      index++;
    }
}



