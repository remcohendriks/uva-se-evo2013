module SigVisual

import SigBasis;
import lang::java::m3::Core;

import vis::Figure;
import vis::Render;
import vis::KeySym;

import IO;
import Set;
import Relation;
import List;

public list[rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity]]
       getTestData(M3 myModel) {
       
	return getListOfUnitMetrics(getListOfUnits(myModel, "method"), false, false, myModel);

}       

public void block(list[rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity]] myListOfUnitMetrics) {

	blocks = [ makeBox(X) | X <- myListOfUnitMetrics ];
	
	render(pack(blocks, std(gap(2))));

}

public Figure makeBox(rel[loc UnitLoc, 
           list[str] LinesOfCode,
           rel[int IncludingComments, 
               int ExcludingComments] UnitSize,
           int CyclomaticComplexity] UnitMetrics) {
	
	int y = 0; y = FromUnitMetricsGetUnitSizeExcludingComments(UnitMetrics);
	int x = 0; x = FromUnitMetricsGetCyclomaticComplexity(UnitMetrics);
	
	s = "";
	slc = listOfstr2str(FromUnitMetricsGetLinesOfCode(UnitMetrics));
	
	int old_x = 0;
	int old_y = 0;
	
	
	
	return box(text(str () { return s; }, fontSize(8)),
	           fillColor("red"),
	           hresizable(false), hsize(num() { return x; }),
	           vresizable(false), vsize(num() { return y; }),
	           onMouseDown(bool (int butnr, map[KeyModifier,bool] modifiers) {
	           		if (s == "") {
	           			s = "UnitSize: <y> \n Complexity: <x>";
	           			old_x = x; x = 100;
	           			old_y = y; y = 200;
	           		}
	           		else {
	           			s = "";
	           			y = old_y;
	           			x = old_x;
					}
					return true;
			   })
	          );
}

public str listOfstr2str(list[str] myListOfStr) {

	//println(lc);
	str slc = "";
	for (int i <- [0..(size(myListOfStr))]) {
		if (i == 0) {
			slc = myListOfStr[i];
		}
		else {
			slc += "\n" + myListOfStr[i];
		}
	} 
	return slc;
	
}
