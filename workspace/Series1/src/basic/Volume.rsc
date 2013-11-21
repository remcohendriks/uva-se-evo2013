module Metrics::Volume

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;


import IO;
import Set;
import List;
import String;
import DateTime;
import basis::sig;

// count all the lines of code of all the units / files
public int CountNumberOfLines(list[loc] myListOfLoc) {
	return (0 | it + e | int e <- [size(removeComments(getListOfStrFromLoc(X))) | X <- myListOfLoc]);
}

// get total coutn  lines of code in a project on the basis of classes or methods
public int CountLinesOfCodeFromM3(M3 myModel, str UnitType) {
	return CountNumberOfLines(getListOfUnits(myModel, UnitType));
}

// get total count of lines of code in a project on the basis of files
public int CountLinesOfCodeFromProjectLoc(loc myProject) {
	return CountNumberOfLines(getFilesFromLoc(myProject));
}

/* 
function: Summery of Volume

Examples:
import basis::sig;
m = genModel(|project://smallsql/|);
summeryVolume(m);
summeryVolume(genModel(|project://hsqldb/|));
  
*/  
public void summeryVolume(M3 myModel) {

	myStart = now();

	myPath = "F:/01_Series/Workbench/Series1/data/";
	myName = "Volume";
	myFile = genResultFileLoc(myPath, myName); 

	writeFile(myFile, "Summery of <myName> of Project\r\n");
	appendToFile(myFile, "----------------------------\r\n");

	myProject       = myModel[0];

	myCountOfClasses = size(genClasses(myModel));
	myCountOfMethods = size(genMethods(myModel));
	myCountOfFiles   = size(getFilesFromLoc(myModel[0]));
	
	// count lines of code on bases of Class, Method of File
	myLOCoboClasses = CountLinesOfCodeFromM3(myModel, "class");
	myLOCoboMethods = CountLinesOfCodeFromM3(myModel, "method");
	myLOCoboFiles   = CountLinesOfCodeFromProjectLoc(myModel[0]);

	myEnd = now();
	myDuration = myEnd - myStart;
	
	appendToFile(myFile, "\r\n");
	appendToFile(myFile, "Project  : <myProject>\r\n");
	appendToFile(myFile, "\r\n");

	appendToFile(myFile, "Number of\r\n");
	appendToFile(myFile, "- Classes: <myCountOfClasses>\r\n");
	appendToFile(myFile, "- Methods: <myCountOfMethods>\r\n");
	appendToFile(myFile, "- Files  : <myLOCoboFiles>\r\n");
	appendToFile(myFile, "\r\n");
	
	appendToFile(myFile, "Lines of Code for\r\n"); 
	appendToFile(myFile, "- Classes: <myLOCoboClasses>\r\n");
	appendToFile(myFile, "- Methods: <myLOCoboMethods>\r\n"); 
	appendToFile(myFile, "- Methods: <myLOCoboFiles>\r\n"); 
	appendToFile(myFile, "\r\n");
	
	// write duration to file
	appendToFile(myFile, "Time to Compute:\r\n");
	printDurationToFile(myFile, myDuration); 
	appendToFile(myFile, "\r\n");

}
