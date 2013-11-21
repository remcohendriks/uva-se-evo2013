module basis::sig

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

// generate M3 model
public M3 genModel(loc id) = createM3FromEclipseProject(id);

// generate Set of methods from the model
public set[loc] genMethods(M3 myM3) = methods(myM3);

// generate set of Class of from the Model
public set[loc] genClasses(M3 myM3) = classes(myM3);

// get list of Strings form Loc
public list[str] getListOfStrFromLoc(loc myLoc) = readFileLines(myLoc);

// print Source Code
public void printSourceCode(str strSourceCode) = println(strSourceCode);

// convert Set to List
public list[loc] Set2List(set[loc] mySet) = [*mySet];

// convert Set to List
public set[loc] List2Set(list[loc] myList) = {*myList};

// get list of location of units 
public list[loc] getListOfUnits(M3 myModel, str myTypeUnit) {
	
	list[loc] myListOfUnit = [];
	
	if (myTypeUnit == "method") { myListOfUnit = Set2List(genMethods(myModel));	}
	if (myTypeUnit == "class")  { myListOfUnit = Set2List(genClasses(myModel));	}
	
	myListOfUnit = [X | X <- myListOfUnit, !(/juni/ := X.path)];
	myListOfUnit = [X | X <- myListOfUnit, !(/test/ := X.path)];
	
	return myListOfUnit;
}

public int DuplicationThreshold() = 6;

public list[loc] getListOfUnitsWithJUnit(M3 myModel, str myTypeUnit) {
	
	list[loc] myListOfUnit = [];
	
	if (myTypeUnit == "method") { myListOfUnit = Set2List(genMethods(myModel));	}
	if (myTypeUnit == "class")  { myListOfUnit = Set2List(genClasses(myModel));	}
	
	return myListOfUnit;
	
}

// get Source Code
public str getSourceCode(loc locSourceCode) = readFile(locSourceCode);

// remove tabs and comments
public list[str] removeComments(list[str] myListOfStr) {

	// trim line of String and remove /t 'tabs'	
	myListOfStr = [trim(replaceAll(X, "\t","")) | X <- myListOfStr];
	
	// remove empty lines
	myListOfStr = [X | X <- myListOfStr, X != ""];
	
	int n = 0;
	
	do {
		
		if (startsWith(myListOfStr[n], "/*")) {
			// start of commenting found
			
			if (endsWith(myListOfStr[n], "*/")) {
				
				// remove commented line
				myListOfStr = delete(myListOfStr, n);
				
			}
			else {
				do {
					
					// remove commented line
					myListOfStr = delete(myListOfStr, n);
													
				} while (!contains(myListOfStr[n], "*/"));
			}
			// remove line with '*/'
			myListOfStr = delete(myListOfStr, n);
		}
		
		n = n + 1;
		
	} while (n < size(myListOfStr));
	
	myListOfStr = [X | X <- myListOfStr, !startsWith(X, "//")];
	
	return myListOfStr;
}

/*
function make a list of all the unit with there lines of code of those unit 
with more or equal lines too the threshold
*/
public lrel[loc,list[str]] getUnitsWithLines(list[loc] myListOfUnits, int myThreshold) {
							
	lrel[loc,list[str]] myListOfLocAndLine = [];
	
	list[str] myListOfStr = [];
	
	mySize = size(myListOfUnits)-1;
	
	for(int n <- [0..mySize]) {
		
		// print progress
		println("Left <(mySize - n)> | Done <n> "); 
		
		// get lines of methods and remove tabs and comments
		myListOfStr = removeComments(getListOfStrFromLoc(myListOfUnits[n]));
		
		// do for Threshold or more lines
		if (size(myListOfStr) >= myThreshold) {
		
			// add lines to grand list.
			myListOfLocAndLine = myListOfLocAndLine + <myListOfUnits[n], myListOfStr>;
		
		}	
	}
	// return the grand list
	return tail(myListOfLocAndLine);
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

// get list of String of all files in loc (project)
public list[str] getListOfStrFromProject(loc myProject) {
	
	// define variants
	list[str] myListOfStr = [];
	
	// get list of Files
	list[loc] myListOfFiles = getFilesFromLoc(myProject);
	
	// loop through all the files
	for(int n <- [0 .. (size(myListOfFiles)-1)]) { 
		//println(myListOfFiles[n]);
		myListOfStr = myListOfStr + removeEmptyStrFromList(getListOfStrFromLoc(myListOfFiles[n]));
	}
	
	// return the resutl list
	return myListOfStr;
}

// removes a string from a list of strings
public list[str] removeFromListOfStr(list[str] listOfStr, str toRemove) {
	return [ X | X <- listOfStr, X != toRemove];
}

// remove empty strings from a list of strings
public list[str] removeEmptyStrFromList(list[str] listOfStr) {
	return removeFromListOfStr(listOfStr, [""]);
}

// prints Duration to Console
public void printDuration(Duration myDuration) {
	println("Years   : <myDuration.years>");
	println("Months  : <myDuration.months>");
	println("Days    : <myDuration.days>");
	println("Hours   : <myDuration.hours>");
	println("Minutes : <myDuration.minutes>");
	println("Seconds : <myDuration.seconds>");
}

// Prints Duration to File
public void printDurationToFile(loc myFile, Duration myDuration) {
	appendToFile(myFile, "Years   : <myDuration.years>\r\n");
	appendToFile(myFile, "Months  : <myDuration.months>\r\n");
	appendToFile(myFile, "Days    : <myDuration.days>\r\n");
	appendToFile(myFile, "Hours   : <myDuration.hours>\r\n");
	appendToFile(myFile, "Minutes : <myDuration.minutes>\r\n");
	appendToFile(myFile, "Seconds : <myDuration.seconds>\r\n");
}

// generates location to Result File
public loc genResultFileLoc(str myPath, str myName) {
	myDatetime = now();
	myTimestamp = "<myDatetime.year>_<myDatetime.month>_<myDatetime.day>_<myDatetime.hour>_<myDatetime.minute>_<myDatetime.second>_";
	myFile      = |file:///<myPath><myTimestamp><"ResultsOfMetric"><myName><".txt">|;
	println(myFile);
	return myFile;
}
