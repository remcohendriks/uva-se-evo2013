module SigBasis

// imports
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import IO;
import Set;
import Relation;
import List;
import String;
import DateTime;
import util::Math;

// |project://smallsql/|
// |project://hsqldb/|



/*
function getUnitMetrics computes
- Lines of Code with comments
- Linse of Code without comments
- UnitSizeWithComments
- UnitSizeWithoutComments
- CyclomaticComplexity

pre-condition:
- myUnitLoc     must point to file, class or method from a M3 model
- myPrintResult must be filled with true or false

*/
public rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] 
	getUnitMetrics(loc myUnitLoc, bool myPrintResult, myModel) {

	//println(myUnitLoc);

	// get lines of Code from the Unit
	list[str] myLinesOfCode = getListOfStrFromLoc(myUnitLoc);
	
	// compute Unit Size
	rel[int IncludingComments, int ExcludingComments] myUnitSize = {<size(myLinesOfCode), size(removeComments(myLinesOfCode))>};
	
	// Compute Cyclomatic Complexity
	int myCyclomaticComplexity = 1;
	if (isMethod(myUnitLoc) == true) {
		//int myCyclomaticComplexity = getCyclomaticComplexity(getSourceCode(myUnitLoc)); 
		myCyclomaticComplexity = getCyclomaticComplexityWithAST(myUnitLoc, myModel); 
	}
		
	// print result
	if (myPrintResult) {
		println("getUnitMetrics | Results for <myUnitLoc>");
		println("getUnitMetrics | Unit Size:");
		println("getUnitMetrics | - Including Comments: <[*myUnitSize.IncludingComments][0]>");
		println("getUnitMetrics | - Excluding Comments: <[*myUnitSize.ExcludingComments][0]>");
		println("getUnitMetrics | Cyclomatic Complexity: <myCyclomaticComplexity>");
		println("getUnitMetrics | Lines Of Code:");
		for (int n <- [0..([*myUnitSize.IncludingComments][0])]) {
			println("getUnitMetrics | Lines[<int2str(n, 5)>] : <myLinesOfCode[n]>");
		}
	}
	
	// combine results
	return {<myUnitLoc, myLinesOfCode, myUnitSize, myCyclomaticComplexity>};	
}

/* 
Function FromUnitMetricsGetUnitLoc
*/
public loc FromUnitMetricsGetUnitLoc(rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] myUnitMetric) {

	return [*myUnitMetric].UnitLoc[0];
}  
/* 
Function FromUnitMetricsGetUnitSizeIncludingComments
*/
public list[str] FromUnitMetricsGetLinesOfCode(rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] myUnitMetric) {

	return [*myUnitMetric].LinesOfCode[0];
}           
/* 
Function FromUnitMetricsGetUnitSizeIncludingComments
*/
public int FromUnitMetricsGetUnitSizeIncludingComments(rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] myUnitMetric) {

	return [*[*myUnitMetric.UnitSize][0]][0].IncludingComments;
} 
/* 
Function FromUnitMetricsGetUnitSizeExcludingComments
*/
public int FromUnitMetricsGetUnitSizeExcludingComments(rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] myUnitMetric) {

	return [*[*myUnitMetric.UnitSize][0]][0].ExcludingComments;
} 
/* 
Function FromUnitMetricsGetCyclomaticComplexity
*/
public int FromUnitMetricsGetCyclomaticComplexity(rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] myUnitMetric) {

	return [*myUnitMetric.CyclomaticComplexity][0];
}


/*
Function getListOfUnitMetrics computes
- list of Unit Metric as in getUnitMetrics

pre-condition:
- myListOfUnits   must be filled with loc to Files, Classes or Methods from a M3 model
- myPrintResults  must be filled with true or false, if true the result of getUnitMetric is printed else not
- myPrintProgress must be filled with true or false, if true the progres of looping thought the listOfUnits is printed else not

post-condition
- list of getUnitMetrics

*/
public list[rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity]] 
	getListOfUnitMetrics(list[loc] myListOfUnits, 
	                     bool myPrintResult,
	                     bool myPrintProgress,
	                     M3 myModel) {

	list[rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity]] myListOfUnitMetrics = [];
	
	int myListOfUnitsSize = size(myListOfUnits);
           
	for (int n <- [0..myListOfUnitsSize]) {
	
		// build myListOfUnitMetrics
		myListOfUnitMetrics = myListOfUnitMetrics + getUnitMetrics(myListOfUnits[n], myPrintResult, myModel);
		
		// show progress
		if (myPrintProgress) {println("getListOfUnitMetrics | Completed: <n+1> ToDo: <(myListOfUnitsSize - n- 1)>"); }
	}
	
	return myListOfUnitMetrics;
}
public int FromListOfUnitMetricsSumLinesOfCode(list[rel[loc UnitLoc, 
                                                    list[str] LinesOfCode,
                                                    rel[int IncludingComments, 
                                                        int ExcludingComments] UnitSize,
                                                    int CyclomaticComplexity]] myListOfUnitMetric, 
                                               bool IncludingComments) {
                                              
    if (IncludingComments) return (0 | it + e | int e <- [ FromUnitMetricsGetUnitSizeIncludingComments(X) | X <- myListOfUnitMetric]);                                                              
	else                   return (0 | it + e | int e <- [ FromUnitMetricsGetUnitSizeExcludingComments(X) | X <- myListOfUnitMetric]);
	
}

public int getCyclomaticComplexity(str myExperssionString) {

	// http://www.leepoint.net/notes-java/principles_and_practices/complexity/complexity-java-method.html
	list[str] myCCparam = ["return",
	        "if", "else", "case", "default",
	        "for", "while", "do-while", "break", "continue", 
	        "&&", "||", "?", ":", 
	        "catch", "finally", "throw", 
	        "start()"];
	        
	int myCounter = 1;
	int mySize    = 0;
	
	for(int n <- [0 .. (size(myCCparam))]) { 
	
		mySize = size(findAll(myExperssionString, myCCparam[n]));
		
		if ((myCCparam[n] == "return") && (mySize >= 1)) mySize = mySize - 1;	
		
		myCounter = myCounter + mySize;
	}

	return myCounter;	
}
/*
public int getCyclomaticComplexityWithAST(loc myUnitLoc, M3 myModel) {
	
	myAST = getMethodASTEclipse(myUnitLoc, model=myModel);

	myNodes = 0;
	myEdges = 0;
	myConnected = 0;
	
	visit(myAST) {
		case \if(Expression condition, Statement thenBranch):                                                            { myEdges += 2; myNodes += 1; }
	  	case \if(Expression condition, Statement thenBranch, Statement elseBranch):                                      { myEdges += 2; myNodes += 1; } 
	    case \case(Expression expression):                                                                               { myEdges += 2; myNodes += 1; }
	    case \defaultCase():                                                                                             { myEdges += 2; myNodes += 1; }//
		case \assert(Expression expression):                                                                             { myNodes += 1; myEdges += 2; }//
        case \assert(Expression expression, Expression message):                                                         { myNodes += 1; myEdges += 2; }//
        case \while(Expression condition, Statement body):                                                               { myNodes += 1; myEdges += 2; }
        case \foreach(Declaration parameter, Expression collection, Statement body):                                     { myNodes += 1; myEdges += 2; }
    	case \for(list[Expression] initializers, list[Expression] updaters, Statement body):                             { myNodes += 1; myEdges += 2; }	
    	case \do(Statement body, Expression condition):                                                                  { myNodes += 1; myEdges += 2; }//	
   		case \catch(Declaration exception, Statement body):                                                              { myNodes += 1; myEdges += 2; }
   		case \return(Expression expression):   	                                                                         { myNodes += 1; myConnected += 1; }//
   		case \return():    	                                                                                             { myNodes += 1; myConnected += 1; }//
   		case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions):                 { myNodes += 1; myEdges += 1; myConnected += 1; }//
        case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):       { myNodes += 1; myEdges += 2; }
    	case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): { myNodes += 1; myEdges += 1; myConnected += 1; }//
    	
    	case \conditional(Expression expression, Expression thenBranch, Expression elseBranch):                          { myNodes += 1; myEdges += 2; }//
    	case \conditional(Expression expression, Expression thenBranch, Expression elseBranch):                          { myNodes += 1; myEdges += 2; }//
    	
    	case \methodCall(bool isSuper, str name, list[Expression] arguments):                                            { myNodes += 1; myEdges += 1; }//
    	case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments):					     { myNodes += 1; myEdges += 1; }//
    	//case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments):					     { myNodes += 1; myEdges += 1; }	
	}
	
	return 1 + (myEdges - myNodes + myConnected);
		
}
*/

public int getCyclomaticComplexityWithAST(loc myUnitLoc, M3 myModel) {
	
	myAST = getMethodASTEclipse(myUnitLoc, model=myModel);

	int cc = 0;
	
	visit(myAST) {
		case \if(_,_):			cc += 1;
	  	case \if(_,_,_):		cc += 1; 
	    case \case(_):			cc += 1;
        case \while(_,_):		cc += 1;
        case \foreach(_,_,_):	cc += 1;
    	case \for(_,_,_):		cc += 1;
    	case \for(_,_,_,_):		cc += 1;	
  		case \catch(_,_):		cc += 1;
	}
	
	return cc = 1 + cc;
		
}

/*
function make a list of all the unit with there lines of code of those unit 
with more or equal lines too the threshold
*/
public lrel[loc,list[str]] 
       getUnitsWithLines(list[rel[loc UnitLoc, 
                              list[str] LinesOfCode,
                              rel[int IncludingComments, 
                                  int ExcludingComments] UnitSize,
                              int CyclomaticComplexity]] myListOfUnits, 
                         int myThreshold) {
	return [ <FromUnitMetricsGetUnitLoc(X),removeComments(FromUnitMetricsGetLinesOfCode(X))> | X <- myListOfUnits, FromUnitMetricsGetUnitSizeExcludingComments(X) >= myThreshold];
}

// Theshold for Duplication
public int ThresholdDuplication() = 6;

/*
testing: testing(Lines, Search);
list[str] myLines  = ["C", "D", "B", "C", "F", "B", "C", "D", "E", "F"];
list[str] mySearch = ["A", "B", "C", "D", "E"];
*/
public void test_findDupsLines() {
	
	list[str] Lines  = ["C", "D", "B", "C", "E", "B", "C", "D", "E", "F"];
	list[str] Search = ["A", "B", "C", "D", "E"];
	int       Threshold = 4;
	
	
	println("Found1    : <getDuplicatedLines(Lines, Search, Threshold)>");
	println("Found2    : <getDuplicatedLines2(Lines, Search, Threshold)>");
	println("Threshold : <Threshold>");
	println("Lines     : <Lines>");
	println("Search    : <Search>");
	
}

bool voorgaande(rel[int, int] myItem, myLines, mySearch) {

	if ((myIdxLines >= myMaxLines) || (myIdxSearch >= myMaxSearch)) return false; 

	return (myLines[myIdxLines] == mySearch[myIdxSearch] && myLines[myIdxLines+1] == mySearch[myIdxSearch+1]);

}
bool vorigegaande(list[str] myLines, list[str] MySearch, int myIdxLines, int myIdxSearch) { 
	return (myLines[myIdxLines] == mySearch[myIdxSearch] && myLines[myIdxLines-1] == mySearch[myIdxSearch-1]); 
}

//public lrel[int IdxUnitM, int IdxUnitN] getDuplicatedLines(list[str] myLines, list[str] mySearch, int myThreshold) {
public lrel[int IdxUnitM, int IdxUnitN] getDuplicatedLines(lrel[int IdxUnitM, int IdxUnitN] myIndexOfLines, int myIndexOfLinesSize, int myThreshold) {

	lrel[int IdxUnitM, int IdxUnitN] myResult = []; 
	lrel[int IdxUnitM, int IdxUnitN] myReturn = [];
	
	//lrel[int IdxUnitM, int IdxUnitN] myIndexOfLines = [ <L, S> | L <- [0..size(myLines)], S <- [0..size(mySearch)], mySearch[S] == myLines[L], myLines[L] != "" ];
	
	int IdxBegin = 0;
	//int myIndexOfLinesSize = size(myIndexOfLines);
	//if (myIndexOfLinesSize >= myThreshold) {
	
		for (int n <- [0..myIndexOfLinesSize]) {
			
			//println(myIndexOfLines[n]);
			if (n == IdxBegin) { myResult = [myIndexOfLines[n]]; } 
			
			// chekc of last line index is 1 smaller. 
			else if (myIndexOfLines[n].IdxUnitN == (myIndexOfLines[n-1].IdxUnitN + 1)) {
				myResult += myIndexOfLines[n];
			} 
			
			// detect end of hole list
			if ((n+1) == myIndexOfLinesSize) {
				if (size(myResult) >= myThreshold) {myReturn += myResult; } 
			} // end of block			
			else if (((myIndexOfLines[(n+1)].IdxUnitN -1) - (myIndexOfLines[n].IdxUnitN) != 0) ) {
				if (size(myResult) >= myThreshold) {myReturn += myResult; } 
				myResult = [];
				IdxBegin = n + 1;
			} 
		}
	//}
	return myReturn;
}

/*
function find duplication in unit lines of code
*/
public lrel[loc UnitN, loc UnitM, lrel[int IdxUnitM, int IdxUnitN] Index ] getDuplications(lrel[loc unit,list[str] lines] myList, bool myPrintProgress) {

	// define local parameters
	int                            myListSize  = size(myList) - 1;
 	               lrel[int IdxUnitM, int IdxUnitN]  myTemp      = [];
	lrel[loc UnitN, loc UnitM, lrel[int IdxUnitM, int IdxUnitN] Index] myEndResult = [];
	
	lrel[int IdxUnitM, int IdxUnitN] myIndexOfLines = [];
	PrintCounter = 0;
	
	// for ever n-th Unit do
	for (int n <- [0..myListSize]) {
	
		// make bucket list
		myBucket = [ X |  X <- [(n+1)..myListSize], size(myList[n].lines & myList[X].lines) >= ThresholdDuplication() ];  
		myBucketSize = size(myBucket);
		
		// for ever m-th Unit do
		//for (int m <- [(n+1)..myListSize]) {
		for (int m <- [0..myBucketSize]) {
			
			// show progress
			if (myPrintProgress) {
				PrintCounter += 1;
				if (PrintCounter >= 100) { 
					PrintCounter = 0; println("getDuplications | Completed: <n+1> ToDo: <(myListSize - n)> (scanning bucket <m> of <myBucketSize> done)"); 
				}
			}
			
			// check for overlapping lines, not nessasary next to onother.
			myIndexOfLines = [ <L, S> | L <- [0..size(myList[myBucket[m]].lines)], 
			                            S <- [0..size(myList[n].lines)], 
			                            myList[n].lines[S] == myList[myBucket[m]].lines[L], 
			                            myList[myBucket[m]].lines[L] != "" ];
			                            
			myIndexOfLinesSize = size(myIndexOfLines);
			if ( size(myIndexOfLines) >= ThresholdDuplication()) {
			//if ( size(myList[n].lines & myList[myBucket[m]].lines) >= ThresholdDuplication() ) {
			
				// computed list of list of strings of then duplications
				//myTemp = getDuplicatedLines(myList[myBucket[m]].lines, myList[n].lines, ThresholdDuplication());
				myTemp = getDuplicatedLines(myIndexOfLines, myIndexOfLinesSize, ThresholdDuplication());
				
				// empty the found line so no duplicate, duplicate match is found
				for (int t <- [0..(size(myTemp))]) { myList[myBucket[m]].lines[myTemp[t][0]] = ""; }
				
				// If Temp. result is not empty then add to the myEndResult
				if (myTemp != []) myEndResult += <myList[n].unit, myList[myBucket[m]].unit, myTemp>;
				
			}
		}
	}
	
	// return the End Result
	return myEndResult;
	
}


/*
Function computes the number of unit and lines of code that are duplications
*/
public list[int] sumDuplications(lrel[loc UnitN, loc UnitM, lrel[int IdxUnitM, int IdxUnitN] Index ] myDuplications, 
                                 bool myPrintProgress) {
	
	set[loc]  myUnitSet   = {};
	int       myLineCount = 0;
	
	for (int n <- [0..(size(myDuplications))]) {
	
		// add Unit N and Unit M to the set of Units to 
		myUnitSet = myUnitSet + {myDuplications[n].UnitN} + {myDuplications[n].UnitM};
	
		// display Unit N and Unit M
		if (myPrintProgress) { println("Result[<n>]:\nUnit[n]: <myDuplications[n].UnitN>\nUnit[m]: <myDuplications[n].UnitM> ");	}
		
		// sum results
		myLineCount += size(myDuplications[n].Index);
	}
	
	// return the size of the set of units and the count of the lines.
	return [size(myUnitSet), myLineCount];
}
public list[int] sumDuplications2(lrel[loc UnitN, loc UnitM, list[list[int]] Index] myDuplications, 
                                 bool myPrintProgress) {
	
	set[loc]  myUnitSet   = {};
	int       myLineCount = 0;
	
	for (int n <- [0..(size(myDuplications))]) {
	
		// add Unit N and Unit M to the set of Units to 
		myUnitSet = myUnitSet + {myDuplications[n].UnitN} + {myDuplications[n].UnitM};
	
		// display Unit N and Unit M
		if (myPrintProgress) { println("Result[<n>]:\nUnit[n]: <myDuplications[n].UnitN>\nUnit[m]: <myDuplications[n].UnitM> ");	}
		
		// sum results
		myLineCount += size(myDuplications[n].Index);
	}
	
	// return the size of the set of units and the count of the lines.
	return [size(myUnitSet), myLineCount];
}

// generate M3 model
public M3 genModel(loc id) = createM3FromEclipseProject(id);

// get list of location of units filtered on test or junit
public list[loc] getListOfUnits(M3 myModel, str myUnitType) {
	return [X | X <- getListOfUnitsWithTestCases(myModel, myUnitType), !(/junit/ := X.path), !(/test/ := X.path)];
}

// get list of location of units, 
public list[loc] getListOfUnitsWithTestCases(M3 myModel, str myUnitType) {
	list[loc] myListOfUnit = [];
	if (myUnitType == "method") { myListOfUnit = [*methods(myModel)]; }
	if (myUnitType == "class")  { myListOfUnit = [*classes(myModel)]; }
	if (myUnitType == "file")   { myListOfUnit = getFilesFromLoc(myModel[0]); }
	return myListOfUnit;
}

// Get a list of files
public list[loc] getFilesFromLoc(loc myPath) {
	
	// stevan Pavlicic heeft dit bedacht
	myList = listEntries(myPath);
	
	// get files form myPath
	myListOfLoc = [(myPath + X) | X <- myList, isFile(myPath + X), endsWith(X, ".java")];

	// get files from myPath if directory 
	myListOfLoc = myListOfLoc + ([] | it + getFilesFromLoc(myPath + e) | str e <- myList);

	// remove junit / test files from list of loc
	myListOfLoc = [X | X <- myListOfLoc, !(/junit/ := X.path)];
	myListOfLoc = [X | X <- myListOfLoc, !(/test/ := X.path)];
	
	return myListOfLoc;

}

// get list of Strings form Loc
public list[str] getListOfStrFromLoc(loc myLoc) = readFileLines(myLoc);

// remove tabs and comments
public list[str] removeComments(list[str] myListOfStr) {
	
	int n = 0;
	
	do {
		// removing comment block
		if (startsWith(myListOfStr[n], "/*")) { // start of commenting found
			if (endsWith(myListOfStr[n], "*/")) { // remove commented line
				myListOfStr = delete(myListOfStr, n);
			}
			else {
				do {// remove lines of comment block
					myListOfStr = delete(myListOfStr, n);
				} while (!contains(myListOfStr[n], "*/"));
			}
			myListOfStr = delete(myListOfStr, n); // remove line with '*/'
		} 
		// increment n
		n = n + 1;
	} while (n < size(myListOfStr));

	// trim line of String and remove /t 'tabs'	
	myListOfStr = [trim(replaceAll(X, "\t","")) | X <- myListOfStr];
	
	// remove empty lines
	myListOfStr = [X | X <- myListOfStr, X != ""];
	
	// remove commented lines
	myListOfStr = [X | X <- myListOfStr, !startsWith(X, "//")];
	
	// remove } lines
	myListOfStr = [X | X <- myListOfStr, !startsWith(X, "}")];
	
	return myListOfStr;
}

// get Source Code
public str getSourceCode(loc locSourceCode) = readFile(locSourceCode);

// format int 2 str by adding number of blacks
public str int2str(int myInt, int myPositions) {
	if (myInt < 0 || myInt > 99999 || myPositions < 1 || myPositions > 10) {
		return "myInt must be betweeen 0 and 99999, myPositions must be between 1 and 10";
	}
	if (myInt >=0 && myInt <=      9) return repeat(" ", (myPositions-1)) + "<myInt>";
	if (myInt >=0 && myInt <=     99) return repeat(" ", (myPositions-2)) + "<myInt>";
	if (myInt >=0 && myInt <=    999) return repeat(" ", (myPositions-3)) + "<myInt>";
	if (myInt >=0 && myInt <=   9999) return repeat(" ", (myPositions-4)) + "<myInt>";
	if (myInt >=0 && myInt <=  99999) return repeat(" ", (myPositions-5)) + "<myInt>";
	if (myInt >=0 && myInt <= 999999) return repeat(" ", (myPositions-6)) + "<myInt>";
	return "myInt must be betweeen 0 and 999999, myPositions must be between 1 and 10";
}

// repeat a str for n times
public str repeat(str myStr, int myRepeat) {
	str myRepeatedStr = "";
	for (int n <- [1..myRepeat]) {
		myRepeatedStr = myRepeatedStr + myStr;
	}
	return myRepeatedStr;
}
