module basic::Duplication

// imports
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import basic::sig;
import basic::Volume;

import IO;
import Set;
import Relation;
import List;
import String;
import DateTime;
import util::Math;

/*
testing: testing(Lines, Search);
list[str] myLines  = ["C", "D", "B", "C", "F", "B", "C", "D", "E", "F"];
list[str] mySearch = ["A", "B", "C", "D", "E"];
*/
public void test_findDupsLines() {
	
	list[str] Lines  = ["C", "D", "B", "C", "F", "B", "C", "D", "E", "F"];
	list[str] Search = ["A", "B", "C", "D", "E"];
	int       Threshold = 2;
	
	println("Found1 : <findDupsLines(Lines, Search, Threshold)>");
	//println("Found2 : <findDupsLines2(Lines, Search, Threshold)>");
	println("Expect: <[["B","C"],["B","C","D","E"],["C", "D"]]>");
	println("Threshold : <Threshold>");
	println("Lines     : <Lines>");
	println("Search    : <Search>");
	
}
public list[list[str]] findDupsLines(list[str] myLines, list[str] mySearch, int myThreshold) {
			
	int myCount = 0;
	int IdxLines = 0;
	int MaxLines = size(myLines);
	
	int IdxBegin  = 0;
	int IdxSearch = 0;
	int MaxSearch = size(mySearch);
	
	list[list[str]] myResult = [];
	list[str]       temp = [];
	
	do {	
		
		// init IdxLines and  IdxSearch;
		IdxSearch = IdxBegin;
		IdxLines = 0;
		
		do {
			// print lines that are compared
		    //println("mySearch[<IdxSearch>] = <mySearch[IdxSearch]>, myLines[<IdxLines>] = <myLines[IdxLines]> myLines: <myLines> Temp: <temp> Count: <myCount> Result: <result>");

		    // check if line are equal
			if (mySearch[(IdxSearch)] == myLines[IdxLines]) {
		    
		    	// remember what was found
		    	temp = temp + mySearch[(IdxSearch)]; 	
		    	
		    	// increment Counter
		    	myCount = myCount + 1;
		    	
		    	// make line blank so there will be no match on it.
		    	myLines[(IdxLines)] = ""; 
		    	
		    	// increment Indexes of myLines and mySearch
				IdxSearch = IdxSearch + 1;
				IdxLines = IdxLines + 1;
				
			}
			else {
			
				// remember temp found if greater or equal too threshold and reset Counter
				if ((temp != []) && (myCount >= myThreshold)) myResult = myResult + [temp]; 
				temp = [];
				myCount = 0;
				
				// initialize IdxSearch to start from the top again
				IdxSearch = IdxBegin;
						
				// increament IdxLines 
				IdxLines = IdxLines + 1;         
			}
			
		} while ( ( IdxLines < MaxLines ) && ( IdxSearch < MaxSearch ) );

		// remember temp found if greater or equal too threshold and reset Counter
		if ((temp != []) && (myCount >= myThreshold)) myResult = myResult + [temp]; 
		temp = [];
		myCount = 0; 
		IdxBegin = IdxBegin + 1;  
		
	} while ( ( IdxBegin < MaxSearch ) && ( size(mySearch & myLines) >= myThreshold ) );

	// return Result
	return myResult;

}

/*
function find duplication in unit lines of code
*/
public lrel[loc, loc, list[list[str]]] getDuplications(lrel[loc unit,list[str] lines] myList) {

	// define local parameters
	int                             myListSize  = size(myList) - 1;
	list[list[str]]                 myTemp      = [];
	lrel[loc, loc, list[list[str]]] myEndResult = [];
	
	// for ever n-th Unit do
	for (int n <- [0..myListSize]) {
		
		// show progress
		println("Left: <myListSize - n> Done: <n>");
		
		// for ever m-th Unit do
		for (int m <- [(n+1)..myListSize]) {
			
			// check for overlapping lines, not nessasary next to onother.
			if ( size(myList[n].lines & myList[m].lines) >= ThresholdDuplication() ) {
			
				// computed list of list of strings of then duplications
				myTemp = findDupsLines(myList[m].lines, myList[n].lines, ThresholdDuplication());
				
				// If Temp. result is not empty then add to the myEndResult
				if (myTemp != []) myEndResult = myEndResult + <myList[n].unit, myList[m].unit, myTemp>;
				
			}
		}
	}
	
	// return the End Result
	return myEndResult;
}

/*
Function computes the number of unit and lines of code.
*/
public list[int] sumAbsolute(lrel[loc methodN, loc methodM, list[list[str]] lines] myDuplications, bool myDisplay) {
	
	set[loc]  myUnitSet   = {};
	int       myLineCount = 0;
	
	for (int n <- [0..(size(myDuplications))]) {
	
		// add Unit N and Unit M to the set of Units to 
		myUnitSet = myUnitSet + {myDuplications[n].methodN} + {myDuplications[n].methodM};
	
		// display Unit N and Unit M
		if (myDisplay) { println("Result[<n>]:\nUnit[n]: <myDuplications[n].methodN>\nUnit[m]: <myDuplications[n].methodM> ");	}
		
		for (int m <- [0..(size(myDuplications[n].lines))]) {
	
			// display lines of duplicated code
			if (myDisplay) { for (int l <- [0..(size(myDuplications[n].lines[m])-1)]) {	println("Line[<m>][<l>]: <myDuplications[n].lines[m][l]>");	} }

			// sum results
			myLineCount = myLineCount + size(myDuplications[n].lines[m]);
	
		}
	}
	
	// return the size of the set of units and the count of the lines.
	return [size(myUnitSet), myLineCount];
}

/*
Function prints the number of unit and lines of code to a file.
*/
public void sumAbsoluteToFile(loc myFile, lrel[loc methodN, loc methodM, list[list[str]] lines] myDuplications) {
	for (int n <- [0..(size(myDuplications))]) {
		appendToFile(myFile, "Result[<n>]:\nUnit[n]: <myDuplications[n].methodN>\nUnit[m]: <myDuplications[n].methodM> \r\n");
		for (int m <- [0..(size(myDuplications[n].lines))]) {
			for (int l <- [0..(size(myDuplications[n].lines[m])-1)]) {
				appendToFile(myFile, "Line[<m>][<l>]: <myDuplications[n].lines[m][l]>\r\n");
			}
		}
	}
}

/* 
function: Summery of Duplications

Examples:
import basis::sig;
m = genModel(|project://smallsql/|);
summeryDuplication(m, "method");
summeryDuplication(genModel(|project://hsqldb/|), "method");
  
*/  
public void summeryDuplication(M3 myModel, str myUintType) {

	myStart = now();

	myPath = "F:/01_Series/Workbench/Series1/data/";
	myName = "Duplication";
	myFile = genResultFileLoc(myPath, myName); 

	writeFile(myFile, "Summery of <myName> of Project\r\n");
	appendToFile(myFile, "---------------------------------\r\n");

	myProject    = myModel[0];

	myLOU           = getListOfUnits(myModel, myUintType);
	myLOLOS         = getUnitsWithLines(myLOU, ThresholdDuplication());
	myDupOfUnits    = getDuplications(myLOLOS);
	myResultMethods = sumAbsolute(myDupOfUnits, false);
	myLOC           = CountLinesOfCodeFromM3(myModel, myUintType);
	myPercentage    = round(((0.0 + myResultMethods[1]) / (0.0 + myLOC) * 100), 0.001);
	myRanking       = dup2ranking(myResultMethods[1], myLOC);
	myEnd = now();
	myDuration = myEnd - myStart;
	
	appendToFile(myFile, "\r\n");
	appendToFile(myFile, "Project  : <myProject>\r\n");
	appendToFile(myFile, "Unit Type: <myUintType>\r\n");
	appendToFile(myFile, "\r\n");
	appendToFile(myFile, "Number of Lines of witch are Duplications with threshold of <ThresholdDuplication()>\r\n");
	appendToFile(myFile, "<myResultMethods[0]> methods with <myResultMethods[1]> duplicate lines (<myPercentage>%)\r\n");
	appendToFile(myFile, "Ranking: <myRanking> \r\n");
	
	// write duration to file
	appendToFile(myFile, "Time to Compute:\r\n");
	printDurationToFile(myFile, myDuration); 
	appendToFile(myFile, "\r\n");
	
	// write data result of duplications to file
	appendToFile(myFile, "Data Results:\r\n");
	sumAbsoluteToFile(myFile, myDupOfUnits);
	
	println(myFile);
	
}


/*

import basis::sig;
import List;

m = genModel(|project://smallsql/|);
tlom = [|java+method:///smallsql/database/ExpressionFunctionAbs/getString()|,
        |java+method:///smallsql/database/ExpressionFunctionFloor/getString()|,
        |java+method:///smallsql/database/MutableNumeric/sub(smallsql.database.MutableNumeric)|,
        |java+method:///smallsql/database/MutableNumeric/add(smallsql.database.MutableNumeric)|,
        |java+method:///smallsql/database/CommandSelect/deleteRow(smallsql.database.SSConnection)|,
        |java+method:///smallsql/database/Command/execute(smallsql.database.SSConnection,smallsql.database.SSStatement)|,
        |java+method:///smallsql/database/Index/addValues(long,smallsql.database.Expressions)|,
        |java+method:///smallsql/database/Index/findRows(smallsql.database.IndexNode,smallsql.database.Expression,boolean,java.util.ArrayList)|,
        |java+method:///smallsql/database/ExpressionFunctionReturnP1/getObject()|,
        |java+method:///smallsql/database/ExpressionArithmetic/getNumeric()|];
louwl = getUnitsWithLines(tlom, 6);
duplication = getDuplications(louwl);
result = sumAbsolute(duplication);

m = genModel(|project://smallsql/|);
louwl = getUnitsWithLines(getListOfUnits(m, "method"), 6);
size(louwl);
duplication = getDuplications(louwl);
result = sumAbsolute(duplication, true);

m = genModel(|project://hsqldb/|);
lou = getListOfUnits(m, "method");
louwl = getUnitsWithLines(lou, 6);
size(louwl);

duplication = getDuplications(louwl);
result = sumAbsolute(duplication);

*/  

public  str dup2ranking(int myDuplication, int myTotalLOC) {

	str myRanking = "";
	
	real myPercentage = round((0.0 + myDuplication) / myTotalLOC, 0.001);
	println(myPercentage);
	
	if (myPercentage <= 0.03) myRanking = "++";
	else if (myPercentage <= 0.05) myRanking = "+";
	else if (myPercentage <= 0.10) myRanking = "o";
	else if (myPercentage <= 0.20) myRanking = "-";
	else myRanking = "--";
	return myRanking;
}
