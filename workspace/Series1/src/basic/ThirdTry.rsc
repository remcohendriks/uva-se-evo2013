module basic::ThirdTry

import IO;
import List;
import Set;
import String;
import Tuple;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::m3::AST;
import lang::java::m3::Core;
import util::Math;
import DateTime;

import basic::FirstTry;



// Gives me an M3 model of the Eclipse Project
public M3 getModel(loc location) {
	M3 model = createM3FromEclipseProject(location); 
	return model;
}

// Give me all the classes of the M3 model
public set[loc] getClasses(M3 model) {
	return classes(model);
}

// Get me the methods from one class
//getMethodsFromClass(getModel(|project://hsqldb/|), |java+class:///org/hsqldb/util/preprocessor/Tokenizer|);
public set[loc] getMethodsFromClass(M3 model, loc class) {
	return methods(model, class);
}

// Get me the methods that are 6+ lines in length/size
public set[loc] getXLinesMethods(set[loc] methods, int line) {
	return {e | e <- methods, countLOCFromFile(e) > line};
}

// Get me a list of the duplicate methods from a set of methods
public list[tuple[list[str], loc]] getListOfTuples(set[loc] methods) {
	list[tuple[list[str], loc]] trimmedMethods = [];
	
	for ( loc methodLoc <- methods ) {
		trimmedMethods += <trimCommentedLinesFromMethod(readFileLines(methodLoc)), methodLoc>;
	}
	//println(trimmedMethods);
	return trimmedMethods;
}

// Trim off the comments from list[str] Method
public list[str] trimCommentedLinesFromMethod( list[str] inLines ) {
	list[str] outLines = [];
	int i = 0;
	
	while ( i < size(inLines) ) {
		
		if ( contains(inLines[i], "/*") ) {
			int tempI = i;

			try {
				while ( !contains(inLines[i], "*/") ) {
					i += 1;
				}
				i += 1;
			}
			catch IndexOutOfBounds(e): {
				i = tempI;
			}
		}
		else if ( contains(inLines[i], "//") ){
			i += 1;
		}
		try {
			if (i < size(inLines)) {
				outLines += inLines[i];
				i += 1;
			}
		}
		catch IndexOutOfBounds(e): {
			println(size(inLines));
			println("index Out of bounds: " + toString(i));
			println(inLines);
			println(outLines);
		}
	}
	return outLines;
}

// Find me d+ lines of consecutive duplicates!
public list[int] doWeHaveADuplicate( tuple[tuple[list[str line] mtbfList, loc mtbfLoc] methodToBeFound, list[tuple[list[str], loc]] hive] beeHive, int d ) {
	
	list[str] findMe = beeHive.methodToBeFound.mtbfList;
	loc findMeLoc = beeHive.methodToBeFound.mtbfLoc;
	list[str] fromList = [];
	list[str] toList = [];
	int count = 0;
	int nrOfDups = 0;
	int nrOfTotalDups = 0;
	
	// for every method in the hive
	for (tuple[list[str] lines, loc location] method <- beeHive.hive) {
		
		//for every line in the method to be found
		for (int n <- [0..size(findMe)]) {
			//fromList = [];
			//toList = [];
			int r = 0;
			count = 0;
			
			// for every line in the method of the hive
			for (r < size(method.lines)) {
				
				// check if the lines are the same
				if (findMe[n] == method.lines[r]) {
					
					try {
						while ( findMe[n] == method.lines[r] ) {
							// Collecting the consecutive duplicates
							//fromList += findMe[n];
							//toList += method.lines[r];
							n += 1;
							r += 1;
							count += 1;
						}
					}
					catch IndexOutOfBounds(e): {
						break;
					}
				}
			}
			if (count >= d) {
				/*
				print("Location of Method to be found: ");
				println(beeHive.methodToBeFound.mtbfLoc);
				println("Lines of method to be found: " + fromList);
				print("Location of found duplicate: ");
				println(method.location);
				println("Lines of duplicate method found: " + toList);
				*/
				nrOfDups += 1;
				nrOfTotalDups += count;
				n = 0;
			}
		}
	}
	return [nrOfDups, nrOfTotalDups];
	// return list[tuple[list[str], loc]]
}

// Here I pass the trimmedMethods to doWeHaveADuplicate() and get a 
//public list[tuple[list[str], loc]] findDuplicates( list[tuple[list[str], loc]] trimmedMethods) {
public void findDuplicates( list[tuple[list[str], loc]] trimmedMethods) {
	shrinkingBeeHive = trimmedMethods;
	int totalMethodDups = 0;
	int totalLineDups = 0;
	int i = 0;
	
	while (i < size(trimmedMethods)) {
		
		// from the bucket of methods I pop one method from the shrinkingBeeHive and get me one tuple <popedMethod, remainingMethods>
		tuple[tuple[list[str], loc] bees, list[tuple[list[str], loc]] hive] beeHive = pop(shrinkingBeeHive);
		shrinkingBeeHive = beeHive.hive;
		
		// I check if duplicates exists in the remaining bucket
		list[int] dups = doWeHaveADuplicate(beeHive, 6);
		
		if ( dups != [0,0] ) {
			//println(dups);
			totalMethodDups += head(dups);
			totalLineDups += last(dups);
		}
		i += 1;
	}
	println("Nr. of 6+ Lines Methods with duplicates: " + toString(totalMethodDups));
	println("Nr. of Duplicate Lines: " + toString(totalLineDups));
	//return [<[""], |some://location|>];
}

// Get me a list of the duplicate methods from a model
//public list[tuple[list[str], loc]] getDuplicates(M3 myModel) {
public void getDuplicates(M3 myModel) {
	M3 model = myModel;
	set[loc] classes = getClasses(model); 
	list[tuple[list[str], loc]] mappedMethods = [];
	
	for( loc class <- classes ) {
		if ( 
			!contains(class.path, "/junit") 
			&& !contains(class.path, "/test")
			&& !contains(class.path, "/doc")
			&& !contains(class.path, "/integration")
			&& !contains(class.path, "/generated")
			&& !contains(class.path, "/sample")
			&& !contains(class.path, "/samples")
			&& !contains(class.path, "/test") 
			&& !contains(class.path, "/tests") 
			&& !contains(class.path, "/junit")
			&& !contains(class.path, "/junits")
			) {
			mappedMethods += getListOfTuples(getXLinesMethods(getMethodsFromClass(model, class), 7));
		}
	}
	//println(mappedMethods);
	findDuplicates(mappedMethods);
	//return findDuplicates(mappedMethods);
}

// Get me the statistics from a project
public void getStatistics(loc modelPath) {
	datetime begin = now();
	set[loc] xLinesMethods = {};
	set[loc] allMethods = {};
	M3 model = getModel(modelPath);
	set[loc] classes = getClasses(model);
	
	println("Start time: " + printDateTime(begin, "yyyy-MM-dd\' \'HH:mm:ss") );
	println("Nr. of Lines: " + toString(countLOCFromProject(modelPath)));
	println("Nr. of Classes: " + toString(size(classes)));
	
	// Total number of methods
	for( loc class <- classes ) {
		if ( 
			!contains(class.path, "/junit") 
			&& !contains(class.path, "/test")
			&& !contains(class.path, "/doc")
			&& !contains(class.path, "/integration")
			&& !contains(class.path, "/generated")
			&& !contains(class.path, "/sample")
			&& !contains(class.path, "/samples")
			&& !contains(class.path, "/test") 
			&& !contains(class.path, "/tests") 
			&& !contains(class.path, "/junit")
			&& !contains(class.path, "/junits")
			) {
			//println(class.path);
			allMethods += getMethodsFromClass(model, class);
		}
	}
	// Total number of methods with 7+ lines
	xLinesMethods = getXLinesMethods(allMethods, 6);
	
	println("Nr. of Methods: " + toString(size(allMethods)));
	println("Nr. of 6+ Lines Methods: " + toString(size(xLinesMethods)));
	// Can be used to print or get the duplicates as a list of tuples, see the method itself for more details 
	getDuplicates(model);
	
	datetime end = now();
	println("End time: " + printDateTime(end, "yyyy-MM-dd\' \'HH:mm:ss") );
	
	// To figure out how to calculate the time difference!!!
	// Interval($2013-11-20T14:50:09.716+01:00$, now()); 
	// createDuration($2013-11-20T14:50:09.716+01:00$, now());
	//println("End time: " + printDateTime(now(), "yyyy-MM-dd\' \'HH:mm:ss") );
}

// Run the stats in console with:
// getStatistics(|project://hsqldb/hsqldb/|);
// getStatistics(|project://smallsql/|);








