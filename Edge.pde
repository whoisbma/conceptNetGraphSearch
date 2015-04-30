class Edge { 
  public String startLemmas;
  public String endLemmas;
  public String start; 
  public String end;
  public String rel;
  public String finalName = "";
  public String finalPath = "";

  public int level; 
  public int parentEdges[]; 
  public String parentEdgeStrings[];
  public String parentEdgeRelStrings[];

  public boolean checked;
  public boolean success;

  public Edge(String sl, String el, String s, String e, String r, String fn, String fp, int l) { 
    this.startLemmas = sl;
    this.endLemmas = el;
    this.start = s;
    this.end = e;
    this.rel = r;
    this.level = l; 

    this.checked = false;
    this.success = false; 

    //fix underscores
    if (fn.contains("_")) {
      String[] splitted = split(fn, "_");
      for (int i = 0; i < splitted.length; i++) {
        if (i != splitted.length - 1) {
          this.finalName += splitted[i] + " ";
        } else {
          this.finalName += splitted[i];
        }
      }
    } else { 
      this.finalName = fn;
    }
    this.finalPath = fp;


  }
  
  void updateParents() {
    if (this.level < levelLimit) { 
      this.parentEdgeStrings = new String[levelLimit-this.level + 1];
      this.parentEdges = new int[levelLimit-this.level + 1];
      this.parentEdgeRelStrings = new String[levelLimit-this.level + 1];
      for (int i = 0; i < levelLimit - level + 1; i++) {
        this.parentEdges[i] = resultsTracker[i];
        this.parentEdgeStrings[i] = resultsTrackerString[i];
        this.parentEdgeRelStrings[i] = resultsTrackerRelString[i];
      }      
    } 
  }
}

