module SigOverall

import SigBasis;
import lang::java::m3::Core;

import IO;
import Set;
import Relation;
import List;
import String;
import DateTime;
import util::Math;

public void genSummeries() {
	summeryHsqldb();
	summerySmallsql();
}

/*

import SigBasis;
m = genModel(|project://smallsql/src/smallsql/|);
Summery(m, "Small_SQL");

*/
public void Summery(M3 myModel, str myRepportName) {

	// remember the start time
	myStart = now();
	
	myPath = "Series1/data/";
	myFile = genResultFileLoc(myPath, myRepportName); 

	// extract Project
	myProject = myModel[0];

	// Print Title Repport
	writeFile(myFile, "Summery of <myRepportName> of Project\r\n");
	appendToFile(myFile,"<repeat("-", size("Summery of <myRepportName> of Project"))>-\r\n");
	appendToFile(myFile, "\r\n");
	
	// Print Name of Project under review
	appendToFile(myFile, "Project under review: <myProject>\r\n");
	appendToFile(myFile, "\r\n");	
	
	// Compute Summation Volume of Files
	myListOfUnitMetrics           = getListOfUnitMetrics(getListOfUnits(myModel, "file"), false, false, myModel);
	myFileVolume                  = ComputeVolume(myListOfUnitMetrics, "Files");
	
	// Print the metrics on Volume on the basis of the Files too myFile.
	PrintToFileVolume(myFile, myFileVolume);

	// Compute Metrics on the basis of Methods
	myListOfUnitMetrics    = getListOfUnitMetrics(getListOfUnits(myModel, "method"), false, false, myModel);
	myVolume               = ComputeVolume(myListOfUnitMetrics, "Methods");
	myUnitSize             = ComputeUnitSize(myListOfUnitMetrics, "Methods");
	myCyclomaticComplexity = ComputeCyclomaticComplexity(myListOfUnitMetrics, "Methods");
	myDuplicatedLines      = ComputeDuplicatedLines(myListOfUnitMetrics, "Methods");

	// Print the metrics on Volume on the basis of the Methods too myFile.
	PrintToFileVolume(myFile, myVolume);
	PrintToFileUnitSize(myFile, myUnitSize);
	PrintToFileCyclomaticComplexity(myFile, myCyclomaticComplexity);
	PrintToFileDuplicatedLines(myFile, myDuplicatedLines);

	// remember the end time for computing the metrics
	myEnd = now();
	myDuration = myEnd - myStart;

	// write duration to file
	appendToFile(myFile, "Time to Compute:\r\n");
	printDurationToFile(myFile, myDuration); 
	appendToFile(myFile, "\r\n");
	
	// write data result of cc to file
	appendToFile(myFile, "Method Data Results Unit Metrics of Unit Size and Cyclomatic Complexity:\r\n");
	PrintListOfUnitMetrics(myFile, myListOfUnitMetrics);	
	
	//appendToFile(myFile, "Method Data Results Unit Metrics of Duplications:\r\n");
	PrintToFileDuplications(myFile, [*myDuplicatedLines.Duplications][0], false);
	
	println(myFile);		
}

// Compute Summation Volume Metrics
public rel[str Type, int Count, int LinesOfCodeIn, int LinesOfCodeEx, str Ranking] ComputeVolume(myListOfUnitMetrics, str Type) {
	myCount            = size(myListOfUnitMetrics);
	myLinesOfCodeIn    = FromListOfUnitMetricsSumLinesOfCode(myListOfUnitMetrics, true);
	myLinesOfCodeEx    = FromListOfUnitMetricsSumLinesOfCode(myListOfUnitMetrics, false);
	myRanking          = my2rank(loc2my("Java", myLinesOfCodeEx));
	return {<Type, myCount, myLinesOfCodeIn, myLinesOfCodeEx, myRanking>};
}
public rel[str Type, list[int] Summation, int Total, str Ranking] ComputeUnitSize(myListOfUnitMetrics, str Type) {
	my_01_to_10   = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetUnitSizeExcludingComments(X) >=  0, FromUnitMetricsGetUnitSizeExcludingComments(X) <= 10], false);
	my_11_to_20   = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetUnitSizeExcludingComments(X) >= 11, FromUnitMetricsGetUnitSizeExcludingComments(X) <= 20], false);
	my_21_to_50   = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetUnitSizeExcludingComments(X) >= 21, FromUnitMetricsGetUnitSizeExcludingComments(X) <= 50], false);
	my_51_to_inv  = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetUnitSizeExcludingComments(X) >= 51, FromUnitMetricsGetUnitSizeExcludingComments(X) >= 51], false);
	mySummations  = [my_01_to_10, my_11_to_20, my_21_to_50, my_51_to_inv]; 
	myTotal       = FromListOfUnitMetricsSumLinesOfCode(myListOfUnitMetrics, false); // excluding comments
	myRanking     = summedcc2rank(mySummations, myTotal);
	return {<Type, mySummations, myTotal, myRanking>};
}
public rel[str Type, list[int] Summation, int Total, str Ranking] ComputeCyclomaticComplexity(myListOfUnitMetrics, str Type) {
	my_01_to_10   = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetCyclomaticComplexity(X) >=  0, FromUnitMetricsGetCyclomaticComplexity(X) <= 10], false);
	my_11_to_20   = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetCyclomaticComplexity(X) >= 11, FromUnitMetricsGetCyclomaticComplexity(X) <= 20], false);
	my_21_to_50   = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetCyclomaticComplexity(X) >= 21, FromUnitMetricsGetCyclomaticComplexity(X) <= 50], false);
	my_51_to_inv  = FromListOfUnitMetricsSumLinesOfCode([ X | X <- myListOfUnitMetrics, FromUnitMetricsGetCyclomaticComplexity(X) >= 51, FromUnitMetricsGetCyclomaticComplexity(X) >= 51], false);
	mySummations  = [my_01_to_10, my_11_to_20, my_21_to_50, my_51_to_inv]; 
	myTotal       = FromListOfUnitMetricsSumLinesOfCode(myListOfUnitMetrics, false); // excluding comments
	myRanking     = summedcc2rank(mySummations, myTotal);
	return {<Type, mySummations, myTotal, myRanking>};
}
public rel[str Type, lrel[loc UnitN,loc UnitM, lrel[int IdxUnitM,int IdxUnitN] Index] Duplications,rel[int Units, int Lines] NumberOf, int Total ,real Percentage ,str Ranking] ComputeDuplicatedLines(myListOfUnitMetrics, str Type) {
           
	// Compute Duplicated Lines in Classes
	myListOfUnits     = getUnitsWithLines(myListOfUnitMetrics, ThresholdDuplication());
	myDuplicatedLines = getDuplications(myListOfUnits, false);
	mySummations      = sumDuplications(myDuplicatedLines, false);
	myTotal           = FromListOfUnitMetricsSumLinesOfCode(myListOfUnitMetrics, false);
	myPercentage      = round(((0.0 + mySummations[1]) / (0.0 + myTotal) * 100), 0.001);
	myRanking         = dup2ranking(mySummations[1], myTotal);
	
	return {<Type, 
	         myDuplicatedLines,
	         {<mySummations[0], 
	           mySummations[1]>}, 
	         myTotal, 
	         myPercentage, 
	         myRanking>
	         };		
}

// Print To File the Summation of Volume metrics
public void PrintToFileVolume(myFile, myMetric) {

	appendToFile(myFile, "Metric of the basis of <[*myMetric.Type][0]>\r\n");	
	appendToFile(myFile, "Number of <[*myMetric.Type][0]>: <[*myMetric.Count][0]>\r\n");	
	appendToFile(myFile, "\r\n");

	appendToFile(myFile, "Volume of <[*myMetric.Type][0]>, Ranking: <[*myMetric.Ranking][0]>\r\n");
	appendToFile(myFile, "Number of Lines Including Comments: <[*myMetric.LinesOfCodeIn][0]>\r\n");	
	appendToFile(myFile, "Number of Lines Excluding Comments: <[*myMetric.LinesOfCodeEx][0]>\r\n");	
	appendToFile(myFile, "\r\n");

}
public void PrintToFileUnitSize(myFile, myMetric) {

	appendToFile(myFile, "Unit Size, Ranking: <[*myMetric.Ranking][0]>\r\n");
	appendToFile(myFile, " Size  | Description                 | Size of Unit in % of total LOC\r\n");
	appendToFile(myFile, "-------+-----------------------------+----------------------------------------\r\n");
	appendToFile(myFile, " <cc2rr(10)> | <rr2desc(cc2rr(10))> | <int2str([*myMetric.Summation][0][0],6)> | <round(([*myMetric.Summation][0][0] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(20)> | <rr2desc(cc2rr(20))> | <int2str([*myMetric.Summation][0][1],6)> | <round(([*myMetric.Summation][0][1] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(50)> | <rr2desc(cc2rr(50))> | <int2str([*myMetric.Summation][0][2],6)> | <round(([*myMetric.Summation][0][2] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(60)> | <rr2desc(cc2rr(60))> | <int2str([*myMetric.Summation][0][3],6)> | <round(([*myMetric.Summation][0][3] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, "-------------------------------------+----------------------------------------\r\n");
	appendToFile(myFile, "                                     | <int2str([*myMetric].Total[0],6)>  100.00% \r\n");
	appendToFile(myFile, "\r\n");	

}
public void PrintToFileCyclomaticComplexity(myFile, myMetric) {

	appendToFile(myFile, "Cyclomatic Complexity, Ranking: <[*myMetric.Ranking][0]>\r\n");
	appendToFile(myFile, " Size  | Description                 | Cyclomatic Complexity in % of total LOC\r\n");
	appendToFile(myFile, "-------+-----------------------------+----------------------------------------\r\n");
	appendToFile(myFile, " <cc2rr(10)> | <rr2desc(cc2rr(10))> | <int2str([*myMetric.Summation][0][0],6)> | <round(([*myMetric.Summation][0][0] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(20)> | <rr2desc(cc2rr(20))> | <int2str([*myMetric.Summation][0][1],6)> | <round(([*myMetric.Summation][0][1] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(50)> | <rr2desc(cc2rr(50))> | <int2str([*myMetric.Summation][0][2],6)> | <round(([*myMetric.Summation][0][2] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, " <cc2rr(60)> | <rr2desc(cc2rr(60))> | <int2str([*myMetric.Summation][0][3],6)> | <round(([*myMetric.Summation][0][3] / (0.0 + [*myMetric].Total[0])) * 100, 0.001)> %\r\n");
	appendToFile(myFile, "-------------------------------------+----------------------------------------\r\n");
	appendToFile(myFile, "                                     | <int2str([*myMetric].Total[0],6)>  100.00% \r\n");
	appendToFile(myFile, "\r\n");	

}
public void PrintToFileDuplicatedLines(myFile, myMetric) {
	appendToFile(myFile, "Duplicated Lines, Ranking: <[*myMetric.Ranking][0]>\r\n");
	appendToFile(myFile, "Number of Lines of witch are Duplications with threshold of <ThresholdDuplication()>\r\n");
	appendToFile(myFile, "<[*[*myMetric.NumberOf][0]][0].Units> <[*myMetric.Type][0]> with <[[*[*myMetric.NumberOf][0]][0].Lines]> duplicate lines (<[*myMetric.Percentage][0]>%)\r\n");
}
public void PrintListOfUnitMetrics(myFile, myListOfUnitMetrics) {
	mySize = size(myListOfUnitMetrics);
	appendToFile(myFile, "Idx;UnitSizeIncludingComments;UnitSizeExcludingComments;CyclomaticComplexity;UnitLoc\r\n");
	for (int n <- [0..mySize]) {
		myUnitLoc                   = FromUnitMetricsGetUnitLoc([*myListOfUnitMetrics][n]);
		myUnitSizeIncludingComments = FromUnitMetricsGetUnitSizeIncludingComments([*myListOfUnitMetrics][n]);
		myUnitSizeExcludingComments = FromUnitMetricsGetUnitSizeExcludingComments([*myListOfUnitMetrics][n]);
		myCyclomaticComplexity      = FromUnitMetricsGetCyclomaticComplexity([*myListOfUnitMetrics][n]);
		appendToFile(myFile, "<n>;<myUnitSizeIncludingComments>;<myUnitSizeExcludingComments>;<myCyclomaticComplexity>;<myUnitLoc>\r\n");
	}
}
/*
Function prints the number of unit and lines of code to a file.
*/
public void PrintToFileDuplications(loc myFile, lrel[loc methodN, loc methodM, lrel[int IdxUnitM, int IdxUnitN] lines] myDuplications, bool myPrintToConsole) {
	
	for (int n <- [0..(size(myDuplications))]) {
		
		if (myPrintToConsole) println("Result[<n>]:\nUnit[n]: <myDuplications[n].methodN>\nUnit[m]: <myDuplications[n].methodM> \r\n");
		else appendToFile(myFile, "Result[<n>]:\nUnit[n]: <myDuplications[n].methodN>\nUnit[m]: <myDuplications[n].methodM> \r\n");
	
		myListOfStr = getListOfStrFromLoc(myDuplications[n].methodM);
			
		for (int m <- [0..(size(myDuplications[n].lines))]) {
		
			for (int l <- [0..(size(myDuplications[n].lines[m]))]) {
		
				if (myPrintToConsole) println("Line[<m>][<l>]: <myListOfStr(l)>\r\n");
				else appendToFile(myFile, "Line[<m>][<l>]: <myListOfStr(l)>\r\n");
		
			}
		}
	}
	
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
	myFile      = |project://<myPath><myTimestamp><"ResultsOfMetric"><myName><".txt">|;
	println(myFile);
	return myFile;
}

@memo public void summerySmallsql() = Summery(genModel(|project://smallsql/|),"SMALLSQL");
@memo public void summeryHsqldb() = Summery(genModel(|project://hsqldb/hsqldb/src/|), "HSQLDB");


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
	return                     "Unknown CC Risk Range!     ";
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
