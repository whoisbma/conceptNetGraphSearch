final int edgeLimit = 5;
final int levelLimit = 10;
final String path = "http://conceptnet5.media.mit.edu/data/5.2";

final String REL_IS_A = "/r/IsA";
//final String REL_USED_FOR = "/r/UsedFor";

//final String TARGET = "/c/en/person";
final String TARGET = "money";

String[] alreadyChecked = new String[0];



Edge[] edges;
JSONObject json;


int[] resultsTracker = new int[levelLimit];
//String[] resultsTrackerString = new String[levelLimit];


ArrayList<Edge> successEdges;

void setup() { 
  size(400, 400);
  background(#EEEEEE);
  frameRate(30);
  successEdges = new ArrayList<Edge>(); 

  Edge[] personGroup = getPersonGroup(0, 10, 10);

  int whichPerson = (int)random(personGroup.length);
  println("Chosen person is " + personGroup[whichPerson].finalName);
  String chosenStart = personGroup[whichPerson].finalPath;
  println(chosenStart);

  recurseCheck(levelLimit, chosenStart);

  println("number of checks = " + alreadyChecked.length);
//  for (int i = 0; i < alreadyChecked.length; i++) {
//    print(alreadyChecked[i]+ " -- ");
//  }

  //CHECK SUCCESSES
  print("\n");
  println("number of successes = " + successEdges.size());
  for (int i = 0; i < successEdges.size (); i++) {
    Edge thisEdge = successEdges.get(i);
    if (thisEdge.parentEdges != null) {
      println("edge tracking length: " + thisEdge.parentEdges.length);
      //      for (int j = 0; j < thisEdge.parentEdges.length; j++) {
      //        Edge[] tempEdge = getSomeEdgeOf(false, "", "", chosenStart, 1, thisEdge.parentEdges[j], 1);
      //        if (tempEdge[0] != null) {
      //          //print(tempEdge[0].finalName + " -- ");
      //        }
      //          //print(thisEdge.parentEdges[j] + " -> ");
      //      }
      println("final edge name: " + thisEdge.finalName);
      //      //println();
    }
  }
} 

public void recurseCheck(int level, String conceptPath) { 
  Edge[] results = getSomeEdgeOf(false, "", "", conceptPath, edgeLimit, 0, level);
  if (results != null) {
    for (int i = 0; i < results.length; i++) {
      int l = levelLimit - level;
      resultsTracker[l] = i;

      for (int j = 0; j < alreadyChecked.length; j++) {
        if (alreadyChecked[j].equals(results[i].finalPath)) {
          //println("already checked " + results[i].finalPath);
          results[i].checked = true;
        }
        if (results[i].finalPath.length() > 38) { //cull large concepts
          results[i].checked = true;
        }
      }

      if (results[i].checked == false && results[i].finalPath.contains("c/en/")) { 
        //println("checked false");

        //add to already checked
        String[] newChecked = new String[alreadyChecked.length+1];
        for (int j = 0; j < alreadyChecked.length; j++) {
          newChecked[j] = alreadyChecked[j];
        }

        newChecked[newChecked.length-1] = results[i].finalPath;
        alreadyChecked = new String[newChecked.length];
        alreadyChecked = newChecked;

        if (results[i].finalPath.contains(TARGET)) {
          //if (results[i].parentEdges.length == levelLimit) {   //IMPORTANT!!! last level only?
            successEdges.add(results[i]);
            println("SUCCESS at " + results[i].finalName);
          //}
        } else { 
          println("not found at " + results[i].finalName);
        }
      }
    }

    if (level > 1) {
      level--;
      for (int i = 0; i < results.length; i++) {
        if (results[i].checked == false) {
          recurseCheck(level, results[i].finalPath);
        }
      }
    }
  }
}

public Edge[] getSomeEdgeOf(boolean relTrue, String pathRel, String startOrEnd, String otherObject, int limitNum, int offsetNum, int level) { 
  try { 
    json = loadJSONObject(getPath(otherObject, relTrue, pathRel, startOrEnd, limitNum, offsetNum));
  } 
  catch (NullPointerException e) {
    e.printStackTrace();
    return null;
  } 
  JSONArray jsonEdges = json.getJSONArray("edges");
  JSONObject edge;
  String startLemmas, endLemmas, start, end, rel;
  String finalName = "";
  String finalPath = "";
  Edge[] theseEdges = new Edge[jsonEdges.size()];

  for (int i = 0; i < theseEdges.length; i++) {
    edge = jsonEdges.getJSONObject(i);
    startLemmas = edge.getString("startLemmas");
    endLemmas = edge.getString("endLemmas");
    start = edge.getString("start");
    end = edge.getString("end");
    rel = edge.getString("rel"); 

    //get name and path
    if (end.contains(otherObject)) { 
      String splitString[] = split(start, "/");
      finalName = splitString[3];
      finalPath = start;
    } else if (start.contains(otherObject)) {
      String splitString[] = split(end, "/");
      finalName = splitString[3];
      finalPath = end;
    } else {
      finalName = "???";
      finalPath = "???";
    }

    theseEdges[i] = new Edge(startLemmas, endLemmas, start, end, rel, finalName, finalPath, level);
    //    println("edge number " + i + ":" + "\n" +
    //        "\t" + "start = " + start + "\n" + 
    //        "\t" + "end = " + end + "\n" + 
    //        "\t" + "finalPath = " + finalPath + "\n" + 
    //        "\t" + "finalName = " + finalName + "\n" + 
    //        "\t" + "relation = " + rel + "\n" + 
    //        "\t" + "level = " + level);
  }
  return theseEdges;
} 

public Edge[] getPersonGroup(int tot1, int tot2, int tot3) { 
  Edge[] personGroup1 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person/n", tot1, 0, 1);
  Edge[] personGroup2 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/person", tot2, 0, 1);
  Edge[] personGroup3 = getSomeEdgeOf(true, REL_IS_A, "end", "/c/en/human", tot3, 0, 1);
  //  println("- GROUP 1 -");
  //  listEdgeNames(personGroup1);
  //  println("- GROUP 2 -");
  //  listEdgeNames(personGroup2);
  //  println("- GROUP 3 -");
  //  listEdgeNames(personGroup3);

  Edge[] personSubTotal = (Edge[])concat(personGroup1, personGroup2);
  Edge[] personTotal = (Edge[])concat(personSubTotal, personGroup3);
  //  println("- TOTAL -");
  //  listEdgeNames(personTotal);
  return personTotal;
} 

public String getPath(String searchObject, boolean relTrue, String relString, String startOrEnd, int limitNum, int offsetNum) { 
  String newPath = "";
  // relation search, single query
  if (relTrue && offsetNum > 0) {//offsetTrue) {
    newPath = path + "/search?rel=" + relString + "&" + startOrEnd + "=" + searchObject + "&limit=" + limitNum + "&offset=" + offsetNum + "&filter=/c/en";
  } 
  //relation search, normal (limited) query
  if (relTrue && offsetNum == 0) {//!offsetTrue) { 
    newPath = path + "/search?rel=" + relString + "&" + startOrEnd + "=" + searchObject + "&limit=" + limitNum + "&filter=/c/en";
  } 
  // no relation search, normal (limited) query
  if (!relTrue && offsetNum == 0) {//!offsetTrue) {
    newPath = path + searchObject + "?limit=" + limitNum + "&filter=/c/en";
  }
  // no relation search, single query
  if (!relTrue && offsetNum > 0) {//offsetTrue) {
    newPath = path + searchObject + "?limit=" + limitNum + "&offset=" + offsetNum + "&filter=/c/en";
  } 
  //println("calculated path is " + newPath); 
  //println(newPath);
  return newPath;
} 

