class Node {
  float x, y, dx, dy, m;
  boolean fixed;
  
  Node(float m0, float x0, float y0){
    x = x0;
    y = y0;
    dx = 0;
    dy = 0;
    m = m0;
    fixed = false;
  }
}

static int N_NODE = 8;
static Node [] n = new Node[N_NODE];

static float energy = 0;
static float k = 1;
static float q = 1;
static float l = 50;
static float alpha = 0.5;

static float dt = 1;

float limit(float val, float low, float high){
  return(max(low, min(high, val)));
}

float limitabs(float val, float rng){
  return(max(-rng, min(rng, val)));
}

Node selection;

void mousePressed(){
  float closest = 20;
  for(int i=0; i<N_NODE; i++){
    float d = dist(mouseX, mouseY, n[i].x, n[i].y);
    if(d < closest){
      selection = n[i];
      closest = d;
    }
  }
  if(selection != null){
    if(mouseButton == LEFT){
      selection.fixed = true;
    }else if(mouseButton == RIGHT){
      selection.fixed = false;
    }
  }
}

void mouseDragged(){
  if(selection != null){
    selection.x = mouseX;
    selection.y = mouseY;
  }
}

void mouseReleased(){
  selection = null;
}

void setup(){
  size(500,500);
  background(255);
  for(int i=0; i<N_NODE; i++){
    n[i] = new Node(random(10, 100), random(200, 300), random(200, 300));
  }
  for(int i=0; i<N_NODE; i++){
    ellipse(n[i].x, n[i].y, n[i].m, n[i].m);
  }
}

void draw(){
  energy = 0;
  for(int i=0; i<N_NODE; i++){
    float fx = 0;
    float fy = 0;
    if(n[i].fixed){
      break;
    }
    for(int j=0; j<N_NODE; j++){  
      if(i != j){
        float dist = sqrt(pow(n[j].x - n[i].x,2) + pow(n[j].y - n[i].y,2)); 
        float cc, ss;
        cc = (n[j].x - n[i].x)/dist;
        ss = (n[j].y - n[i].y)/dist;
        fx += q / pow(dist,2) / cc;  // coulomb's law
        fy += q / pow(dist,2) / ss;
        fx += k * limitabs(dist - l, 1000) * cc;  // Hooke's law
        fy += k * limitabs(dist - l, 1000) * ss;
      }
    }
    n[i].dx = (n[i].dx + dt * fx / n[i].m) * alpha;
    n[i].dy = (n[i].dy + dt * fy / n[i].m) * alpha;
    n[i].x += dt * n[i].dx;
    n[i].y += dt * n[i].dy;
    energy += n[i].m * (pow(n[i].dx,2) + pow(n[i].dy,2));
  }
//  println(energy);
  background(255);
  for(int i=0; i<N_NODE; i++){
    ellipse(n[i].x, n[i].y, n[i].m/2, n[i].m/2);
  }
}