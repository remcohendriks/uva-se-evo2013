module basic::FifthTry

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
import basic::Sig;


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

// Trim off the comments from list[str] Method
public list[str] trimCommentedLinesFromClass( list[str] inLines ) {
	list[str] outLines = [];
	int i = 0;
	
	//println(size(inLines));
	while ( i < size(inLines) ) {
		
		if ( contains(inLines[i], "/*") ) {
			int tempI = i;
			//println(inLines[i]);
			i += 1;
			
			try {
				while ( !contains(inLines[i], "*/") ) {
					i += 1;
					//println(inLines[i]);
				}
				//i += 1;
			}
			catch IndexOutOfBounds(e): {
				//println("index out of bounds!");
				i = tempI;
			}
		}
		else if ( contains(inLines[i], "//") || contains(inLines[i], "*/") ){
			i += 1;
		} else {
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
			//i += 1;
		}
	}
	return outLines;
}


// 
/*
public list[tuple[list[str], loc]] getListOfTuples(set[loc] classes) {
	list[tuple[list[str], loc]] trimmedClasses = [];
	
	for ( loc classLoc <- classes ) {
		trimmedClasses += <trimCommentedLinesFromClass(readFileLines(classLoc)), classLoc>;
	}
	//println(trimmedMethods);
	return trimmedClasses;
}
*/

// Find me d+ lines of consecutive duplicates!
public list[int] doWeHaveADuplicate( tuple[tuple[list[str line] mtbfList, loc mtbfLoc] methodToBeFound, list[tuple[list[str], loc]] hive] beeHive, int d ) {
	
	list[str] findMe = beeHive.methodToBeFound.mtbfList;
	loc findMeLoc = beeHive.methodToBeFound.mtbfLoc;
	list[str] fromList = [];
	list[str] toList = [];
	list[tuple[list[str] lines, loc location] class] found = [];
	int count = 0;
	int nrOfDups = 0;
	int nrOfTotalDups = 0;
	
	print("Code to be found: ");
	println(findMe);
	print("Size of the code to be found: ");
	println(size(findMe));
	print("Size of the hive: ");
	println(size(beeHive.hive));
	/*
	// for every class in the hive
	for (tuple[list[str] lines, loc location] class <- beeHive.hive) {
		int n = 0;
		//println(class.lines);
		//println(findMe);
		//for every line in the class to be found
		while ( n < size(findMe)) {
			//fromList = [];
			//toList = [];
			int r = 0;
			count = 0;
			//println(findMe[n]);
			//println(n);
			
			// for every line in the class of the hive
			while (r < size(class.lines)) {
				
				//	print(r);
				//	println(class.lines[r]);
				//	print(n);
				//	println(findMe[n]);
				
				// check if the lines are the same
				if (findMe[n] == class.lines[r]) {
					//println(class.lines[r]);
					try {
						while ( findMe[n] == class.lines[r] ) {
							// Collecting the consecutive duplicates
							//fromList += findMe[n];
							toList += class.lines[r];
							n += 1;
							r += 1;
							count += 1;
						}
					}
					catch IndexOutOfBounds(e): {
						break;
					}
				} else {
					r += 1;
				}
			}
			if (count >= d) {
				//println(findMeLoc);
				//println(class.location);
				//println(count);
				nrOfDups += 1;
				nrOfTotalDups += count;
				//n = 0;
				//r += 1;

				//	found += <toList, class.location>;
				//	class.lines = class.lines - toList;
				//	toList = [];
				//	println(found);

				//println("6+    dups: " + toString(nrOfDups));
				//println("total dups: " + toString(nrOfTotalDups));
			} else {
				n += 1;
			}
		}
	}
	*/
	//println(found);
	return [nrOfDups, nrOfTotalDups];
	// return list[tuple[list[str], loc]]
}


// Here I pass the trimmedClasses to doWeHaveADuplicate() and get a 
//public list[tuple[list[str], loc]] findDuplicates( list[tuple[list[str], loc]] trimmedMethods) {
public list[int] findDuplicates( list[tuple[list[str], loc]] trimmedClasses ) {
	shrinkingBeeHive = trimmedClasses;
	int totalMethodDups = 0;
	int totalLineDups = 0;
	int i = 0;

	while (i < size(trimmedClasses)) {
		
		// from the bucket of classes I pop one class from the shrinkingBeeHive and get me one tuple <popedClass, remainingClasses>
		tuple[tuple[list[str], loc] bees, list[tuple[list[str], loc]] hive] beeHive = pop(shrinkingBeeHive);
		shrinkingBeeHive = beeHive.hive;
		
		//	print("Size of the beeHive: ");
		//	println(size(shrinkingBeeHive));
		
		
		// I check if duplicates exists in the remaining bucket
		list[int] dups = doWeHaveADuplicate(beeHive, 6);
		
		if ( dups != [0,0] ) {
			//println(dups);
			totalMethodDups += head(dups);
			totalLineDups += last(dups);
			//println("6+    dups: " + toString(totalMethodDups));
			//println("total dups: " + toString(totalLineDups));
		}
		
		i += 1;
	}
	return [totalMethodDups, totalLineDups];
}

// Get me a list of the duplicate methods from a model
//public list[tuple[list[str], loc]] getDuplicates(M3 myModel) {
public list[int] getDuplicates(M3 myModel) {
	M3 model = myModel;
	set[loc] classes = getClasses(model); 
	list[tuple[list[str], loc]] mappedClasses = [];
	
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
			println(class);
			
			mappedClasses += <trimCommentedLinesFromClass(trimEmptyLinesFromFile(class)), class>;
		}
	}
	//println(mappedClasses);
	return findDuplicates(mappedClasses);
	//return findDuplicates(mappedClasses);
}

// Get me the statistics from a project
public void getStatistics(loc modelPath) {
	datetime begin = now();
	set[loc] xLinesMethods = {};
	set[loc] allMethods = {};
	M3 model = getModel(modelPath);
	
	set[loc] classes = getClasses(model);
	
	println( "Start time:\t\t\t" + printDateTime(begin, "yyyy-MM-dd\' \'HH:mm:ss") );
	
	int locs = countLOCFromProject(modelPath);
	
	println( "Nr. of Lines:\t\t\t" + toString(locs) + "\t\t\t" + getSIGlocs(locs) );
	println( "Nr. of Classes:\t\t\t" + toString(size(classes)) );
	
	// Total number of methods
	/*
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
	xLinesMethods = getXLinesMethods(allMethods, 5);
	
	println("Nr. of Methods:\t\t" + toString(size(allMethods)));
	println("Nr. of 6+ Lines Methods:\t" + toString(size(xLinesMethods)));
	*/
	
	// Can be used to print or get the duplicates as a list of tuples, see the method itself for more details 
	list[int] dups = getDuplicates(model);
	int headDups = head(dups);
	int tailDups = tail(dups);
	
	println( "Nr. of 6+ Lines duplicates:\t" + toString(headDups) );
	println( "Nr. of Duplicate Lines:\t\t\t" + toString(tailDups) + "\t\t\t" + getSIGdups(tailDups, locs) );
	
	datetime end = now();
	println( "End time: " + printDateTime(end, "yyyy-MM-dd\' \'HH:mm:ss") );
	
	// To figure out how to calculate the time difference!!!
	// Interval($2013-11-20T14:50:09.716+01:00$, now()); 
	// createDuration($2013-11-20T14:50:09.716+01:00$, now());
	//println("End time: " + printDateTime(now(), "yyyy-MM-dd\' \'HH:mm:ss") );
}











