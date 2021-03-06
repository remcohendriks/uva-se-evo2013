module basic::CyclomaticComplexity

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import basic::sig;
import basic::Volume;

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
	if ((mySearchstring == "return") && (mySize >= 1)) mySize = mySize - 1;
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

public rel[int idx, loc method, int cc] getListOfUnitCC(list[loc] myListOfMethods) {

	rel[int, loc, int] myListOfMethodCC = {};
	int myCC     = 1;
	loc myMethod = myListOfMethods[0];
	
	for(int n <- [0 .. (size(myListOfMethods)-1)]) { 
	
		myCC     = CC(getSourceCode(myListOfMethods[n]));
		myMethod = myListOfMethods[n];
		
		myListOfMethodCC = myListOfMethodCC + {<n, myMethod, myCC>};
		
		// print result for progress 
		//println("Index: <n> | CC: <myCC>");
		
	}
	
	return myListOfMethodCC;
	
}

public void printCCofUnitToFile(loc myFile, rel[int idx, loc method, int cc] UnitCC) {

	rel[loc mt, int cc] myRec = {};
	list[int]           myListRec = [];
	
	for(int n <- [0 .. (size(UnitCC)-1)]) { 

		myRec = UnitCC[n];
		myListRec = [*myRec.cc];
		myMethode = [*myRec.mt];
			
		// print result for progress 
		appendToFile(myFile, "Index: <n> | CC: <myListRec[0]> | method loc: <myMethode[0]>\r\n");
		
	}
}

public list[int] getSummationsOfCC(rel[int idx, loc method, int cc] myListOfMethodCC) {

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
		
		if (myRiskRange == " 1-10")  myIdx = 0;
		if (myRiskRange == "11-20")  myIdx = 1;
		if (myRiskRange == "21-50")  myIdx = 2;
		if (myRiskRange == " \> 50") myIdx = 3;
		
		mySum[myIdx] = mySum[myIdx] + size(removeComments(getListOfStrFromLoc(myMethode[0])));
		myTot = 0.0  + mySum[0] + mySum[1] + mySum[2] + mySum[3];
		
		// print result for progress 
		//println("CC: <myCC>");
		//println("Index: 1 |  1-10 | LOC: <round((mySum[0] / myTot) * 100, 0.01)> %");
		//println("Index: 2 | 11-10 | LOC: <round((mySum[1] / myTot) * 100, 0.01)> %");
		//println("Index: 3 | 21-10 | LOC: <round((mySum[2] / myTot) * 100, 0.01)> %");
		//println("Index: 4 |  \> 50 | LOC: <round((mySum[3] / myTot) * 100, 0.01)> %");
		
		
	}
	
	return mySum;
	
}

/* 
function: Summery of Complexity

Examples:
import Metrics::CyclomaticComplexity;
import basis::sig;
m = genModel(|project://smallsql/|);
summeryCyclomaticComplexity(m, "method");
summeryCyclomaticComplexity(genModel(|project://hsqldb/|), "method");
  
*/ 
public void summeryCyclomaticComplexity(M3 myModel, str myUnitType) {

	myStart = now();

	myPath = "F:/01_Series/Workbench/Series1/data/";
	myName = "CycolmaticComplexity";
	myFile = genResultFileLoc(myPath, myName); 

	writeFile(myFile, "Summery of <myName> of Project\r\n");
	appendToFile(myFile, "------------------------------------------\r\n");

	myProject = myModel[0];
	
	list[loc]          myListOfUnits     = getListOfUnits(myModel, myUnitType);
	rel[int, loc, int] myListOfCCperUnit = getListOfUnitCC(myListOfUnits);
	list[int]          mySummationsOfCC  = getSummationsOfCC(myListOfCCperUnit); 
	int                myTotal           = mySummationsOfCC[0] + mySummationsOfCC[1] + mySummationsOfCC[2] + mySummationsOfCC[3];
	//int                myTotal           = CountLinesOfCodeFromM3(myModel, myUnitType);
	str                myRanking         = summedcc2rank(mySummationsOfCC, myTotal);
	
	myEnd = now();
	myDuration = myEnd - myStart;
	
	appendToFile(myFile, "Project : <myProject>\r\n");
	appendToFile(myFile, "\r\n");	
	
	appendToFile(myFile, "Cyclomatic Complexity: <myRanking>\r\n");
	appendToFile(myFile, "  CC   | Description                 | Cyclomatic Complexity in % of total LOC\r\n");
	appendToFile(myFile, " <cc2rr(10)> | <rr2desc(cc2rr(10))> | <mySummationsOfCC[0]> <round((mySummationsOfCC[0] / (0.0 + myTotal)) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(20)> | <rr2desc(cc2rr(20))> | <mySummationsOfCC[1]> <round((mySummationsOfCC[1] / (0.0 + myTotal)) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(50)> | <rr2desc(cc2rr(50))> | <mySummationsOfCC[2]> <round((mySummationsOfCC[2] / (0.0 + myTotal)) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(60)> | <rr2desc(cc2rr(60))> | <mySummationsOfCC[3]> <round((mySummationsOfCC[3] / (0.0 + myTotal)) * 100, 0.001)> %\r\n");
	appendToFile(myFile, "\r\n");	
		
	// write duration to file
	appendToFile(myFile, "Time to Compute:\r\n");
	printDurationToFile(myFile, myDuration); 
	appendToFile(myFile, "\r\n");
	
	// write data result of cc to file
	appendToFile(myFile, "Data Results:\r\n");
	printCCofUnitToFile(myFile, myListOfCCperUnit);
	

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
	if (CC < 11) return " 1-10";
	if (CC < 21) return "11-20";
	if (CC < 51) return "21-50";
	if (CC > 50) return " \> 50";
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
	if (rr == " 1-10")  return "simple, without much risk  ";
	if (rr == "11-20")  return "more complex, moderate risk";
	if (rr == "21-50")  return "complex, high risk         ";
	if (rr == " \> 50") return "untestable, very high risk ";
	return                    "Unknown CC Risk Range!     ";
}

public str summedcc2rank(list[int] mySummedCC, int myTotalLOC) {
    str myRanking = ""; 
	real myTotal = 0.0 + myTotalLOC;
 	real myModarate  = ((0.0 + mySummedCC[1]) / myTotal);
 	real myHigh      = ((0.0 + mySummedCC[2]) / myTotal);
 	real myVeryHigh  = ((0.0 + mySummedCC[3]) / myTotal);
 	
	
 	if ( (myModarate <= 0.25) && (myHigh <= 0.00) && (myVeryHigh <= 0.00) ) myRanking = "++";
 	else if ( (myModarate <= 0.30) && (myHigh <= 0.05) && (myVeryHigh <= 0.00) ) myRanking = "+";
 	else if ( (myModarate <= 0.40) && (myHigh <= 0.10) && (myVeryHigh <= 0.00) ) myRanking = "o";
 	else if ( (myModarate <= 0.50) && (myHigh <= 0.15) && (myVeryHigh <= 0.05) ) myRanking = "-";
 	else myRanking = "--";
 	
 	println("moderate (<mySummedCC[1]>): <myModarate> | High (<mySummedCC[2]>): <myHigh> | Very High (<mySummedCC[3]>): <myVeryHigh> | Ranking: <myRanking>");
	
	return myRanking;
}
