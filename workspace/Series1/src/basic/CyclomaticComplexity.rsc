module Metrics::CyclomaticComplexity

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import basis::sig;
import Ranking::CyclomaticComplexity;
import Metrics::Volume;

import IO;
import Set;
import List;
import String;
import DateTime;
import util::Math;


// list of parameters for cyclomatische complexity
public list[str] listCCparam() {
	// http://www.leepoint.net/notes-java/principles_and_practices/complexity/complexity-java-method.html
	return ["return",
	        "if", "else", "case", "default",
	        "for", "while", "do-while", "break", "continue", 
	        "&&", "||", "?", ":", 
	        "catch", "finally", "throw", 
	        "start()"];
}

// count string in a list of strings
public int countStringInString(str myExpressionString, str mySearchstring) {
	int mySize = size(findAll(myExpressionString, mySearchstring));
	if ((mySearchstring == "return") && (mySize > 1)) mySize = mySize - 1;
	return mySize;
}

public int CC(str myExperssionString) {
	list[str] myCCparam = listCCparam();
	int myCounter = 1;
	
	for(int n <- [0 .. (size(myCCparam)-1)]) { 
		myCounter = myCounter + countStringInString(myExperssionString, myCCparam[n]);
	}
	//println(myExperssionString);
	return myCounter;	
}

public int methodCC(loc myLocMethod) {
	return CC(getSourceCode(myLocMethod));
}

public rel[int idx, loc method, int cc] getListOfMethodsCC(list[loc] myListOfMethods) {

	rel[int, loc, int] myListOfMethodCC = {};
	int myCC     = 1;
	loc myMethod = myListOfMethods[0];
	
	for(int n <- [0 .. (size(myListOfMethods)-1)]) { 
	
		myCC     = methodCC(myListOfMethods[n]);
		myMethod = myListOfMethods[n];
		
		myListOfMethodCC = myListOfMethodCC + {<n, myMethod, myCC>};
		
		// print result for progress 
		println("Index: <n> | CC: <myCC> | method loc: <myMethod>");
		
	}
	
	return myListOfMethodCC;
	
}

public list[int] getSummationsOfCC(rel[int, loc, int] myListOfMethodCC) {

	rel[loc mt, int cc] myRec = {};
	list[int]             myListRec = [];
	
	int myCC             = 0;
	str myRiskRange      = "";
	str myRiskEvaluation = "";
	
	int myIdx = 0;
	list[int] mySum = [0,0,0,0];
	real myTot = 0.0;
	
	
	for (int n <- [0 .. (size(myListOfMethodCC)-1)]) { 
	
		myRec = myListOfMethodCC[n];
		myListRec = [*myRec.cc];
		myMethode = [*myRec.mt];
		
		myCC             = myListRec[0];
		myRiskRange      = cc2rr(myCC);
		
		if (myRiskRange ==  "1-10") myIdx = 0;
		if (myRiskRange == "11-20") myIdx = 1;
		if (myRiskRange == "21-50") myIdx = 2;
		if (myRiskRange == "\> 50") myIdx = 3;
		
		mySum[myIdx] = mySum[myIdx] + CountLinesOfCodeFromSourceCode(getSourceCode(myMethode[0]));
		myTot = 0.0  + mySum[0] + mySum[1] + mySum[2] + mySum[3];
		
		// print result for progress 
		println("CC: <myCC>");
		println("Index: 1 |  1-10 | LOC: <round((mySum[0] / myTot) * 100, 0.01)> %");
		println("Index: 2 | 11-10 | LOC: <round((mySum[1] / myTot) * 100, 0.01)> %");
		println("Index: 3 | 21-10 | LOC: <round((mySum[2] / myTot) * 100, 0.01)> %");
		println("Index: 4 |  \> 50 | LOC: <round((mySum[3] / myTot) * 100, 0.01)> %");
		
		
	}
	
	return mySum;
	
}

// summery
public void summeryCyclomaticComplexity(M3 myModel) {

	myStart = now();
	myProject = myModel[0];
	
	list[loc]          myListOfMethods     = Set2List(genMethods(myModel));
	rel[int, loc, int] myListOfCCperMethod = getListOfMethodsCC(myListOfMethods);
	list[int]          mySummationsOfCC    = getSummationsOfCC(myListOfCCperMethod); 
	int                myTotal             = 0.0  + mySummationsOfCC[0] + 
	                                                mySummationsOfCC[1] + 
	                                                mySummationsOfCC[2] + 
	                                                mySummationsOfCC[3];
	myEnd = now();
	myDuration = myEnd - myStart;
	
	println("Summery of Cyclomatic Complexity of Project");
	
	println("Project : <myProject>");

	println("Cyclomatic Complexity: <myCC>");
	println("  1-10 | LOC: <round((mySummationsOfCC[0] / myTot) * 100, 0.01)> %");
	println(" 11-10 | LOC: <round((mySummationsOfCC[1] / myTot) * 100, 0.01)> %");
	println(" 21-10 | LOC: <round((mySummationsOfCC[2] / myTot) * 100, 0.01)> %");
	println("  \> 50 | LOC: <round((mySummationsOfCC[3] / myTot) * 100, 0.01)> %");
		
	println("Time passes:");
	printDuration(myDuration); 

}


/*
 *  function cc2rr: convers cc = Cyclomatic Complexity too rr = Risk Range          
 *  inputs:                                                                  
 *  - int CC  : integer greater the zero                               
 *  output:                                                                  
 *  - str :
 */
 public str cc2rr(int CC) {
	if (CC <  1) return "Elegal input foor CC";
	if (CC < 11) return  "1-10";
	if (CC < 21) return "11-20";
	if (CC < 51) return "21-50";
	if (CC > 50) return "\< 50";
	return "Unknown CC!";	
}

/*
 *  function rr2desc: convers rr = Risk Range too desc = description          
 *  inputs:                                                                  
 *  - int CC  : integer greater the zero                               
 *  output:                                                                  
 *  - str :
 */
public str rr2desc(str rr) {
	if (rr ==  "1-10") return "simple, without much risk";
	if (rr == "11-20") return "more complex, moderate risk";
	if (rr == "21-50") return "complex, high risk";
	if (rr == "\> 50") return "untestable, very high risk";
	return "Unknown CC Risk Range!";
}
