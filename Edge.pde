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

  public boolean checked;

  public Edge(String sl, String el, String s, String e, String r, String fn, String fp, int l) { 
    this.startLemmas = sl;
    this.endLemmas = el;
    this.start = s;
    this.end = e;
    this.rel = r;
    this.level = l; 
    
    this.checked = false;

    if (level < levelLimit) { 
      this.parentEdges = new int[levelLimit-level+1];
      for (int i = 0; i < levelLimit - level + 1; i++) {
        this.parentEdges[i] = resultsTracker[i];
      }
    }

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

}

