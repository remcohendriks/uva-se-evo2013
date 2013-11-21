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

	// make a ranking on basis of Class, Method of File
	myManYearsClasses = loc2my("java", myLOCoboClasses); 
	myManYearsMethods = loc2my("java", myLOCoboMethods); 
	myManYearsFiles   = loc2my("java", myLOCoboFiles); 

	// make a ranking on basis of Class, Method of File
	myRankingClasses = my2rank(myManYearsClasses); 
	myRankingMethods = my2rank(myManYearsMethods); 
	myRankingFiles   = my2rank(myManYearsFiles); 

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
	appendToFile(myFile, "- Files  : <myLOCoboFiles>\r\n"); 
	appendToFile(myFile, "\r\n");

	appendToFile(myFile, "Man Year for\r\n"); 
	appendToFile(myFile, "- Classes: <myManYearsClasses>\r\n");
	appendToFile(myFile, "- Methods: <myManYearsMethods>\r\n"); 
	appendToFile(myFile, "- Files  : <myManYearsFiles>\r\n"); 
	appendToFile(myFile, "\r\n");

	appendToFile(myFile, "Ranking for\r\n"); 
	appendToFile(myFile, "- Classes: <myRankingClasses>\r\n");
	appendToFile(myFile, "- Methods: <myRankingMethods>\r\n"); 
	appendToFile(myFile, "- Files  : <myRankingFiles>\r\n"); 
	appendToFile(myFile, "\r\n");	
	
	// write duration to file
	appendToFile(myFile, "Time to Compute:\r\n");
	printDurationToFile(myFile, myDuration); 
	appendToFile(myFile, "\r\n");

}

/*
 *  function loc2my: convers loc = Lines Of Code too my = Man Years          
 *  inputs:                                                                  
 *  - str language : Java/Cobol/PL/SQL                                       
 *  - int LOC      : integer greater then zero                                   
 *  output:                                                                  
 *  - str
 */
public str loc2my (str language, int LOC) {

	int KLOC = (LOC / 1000);

	if ( (language != "Java" )
	&&   (language != "Cobol" )
	&&   (language != "Cobol" ) ) return "input language must be eider Java, Cobol or PL\\SQL";

	if ( KLOC < 1 ) return "input parameter LOC must be greater then 0";
	
	if ( ( (KLOC <   66) && (language == "Java") )
	||   ( (KLOC <  131) && (language == "Cobol") )  
	||   ( (KLOC <   46) && (language == "PL/SQL") ) ) return "0 - 8";
	
	if ( ( (KLOC <  246) && (language == "Java") )
	||   ( (KLOC <  491) && (language == "Cobol") )  
	||   ( (KLOC <  173) && (language == "PL/SQL") ) ) return "8 - 30";
	
	if ( ( (KLOC <  665) && (language == "Java") )
	||   ( (KLOC < 1310) && (language == "Cobol") )  
	||   ( (KLOC <  461) && (language == "PL/SQL") ) ) return "30 - 80";
	
	if ( ( (KLOC < 1310) && (language == "Java") )
	||   ( (KLOC < 2621) && (language == "Cobol") )  
	||   ( (KLOC <  922) && (language == "PL/SQL") ) ) return "80 - 160";
	
	if ( ( (KLOC > 1310) && (language == "Java") )
	||   ( (KLOC > 2621) && (language == "Cobol") )  
	||   ( (KLOC >  922) && (language == "PL/SQL") ) ) return "\> 160";
	
	return "No conversion could be made!";
}

/*
 *  function my2Rank: convers my = Man Years too Ranking          
 *  inputs:                                                                  
 *  - str MY  : valid output from loc2my                               
 *  output:                                                                  
 *  - str
 */
public str my2rank(str MY) {
	if (MY == "0 - 8")    return "++"; 
	if (MY == "8 - 30")   return "+"; 
	if (MY == "30 - 80")  return "o"; 
	if (MY == "80 - 160") return "-"; 
	if (MY == "\> 160")   return "--";
	return "No conversion could be made!";
}
