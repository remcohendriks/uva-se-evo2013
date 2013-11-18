module basic::FirstTry

import IO;
import List;
import String;



// Get a list of files
public list[loc] getFilesFromLoc(loc path) {
	theList = listEntries(path);
	//println(theList);
	toBeReturned = [];
	
	for (int n <- [0 .. size(theList)]) {

		if (isDirectory(path + theList[n])) {
			toBeReturned = toBeReturned + getFilesFromLoc(path + theList[n]);
			//print(".");
		} 
		else if (isFile(path + theList[n])){
			if (endsWith(theList[n], ".java")) {
				toBeReturned = toBeReturned + (path + theList[n]);
			}
		}
	}
	return toBeReturned;
}
public list[loc] getFilesFromLoc() {
	return getFilesFromLoc(|project://hsqldb-2.3.1/|);
}





// Trim Empty lines from file
public list[str] trimEmptyLinesFromFile(loc file) {
	list[str] lines = readFileLines(file);
	list[str] lineListToReturn = [];
	int count = 0;
	
	for (i <- [0 .. size(lines)]) {
		//if (/\W/ := lines[i]) {
		if (/[!\w}*]/ := lines[i]) {
			//println(lines[i]);
			lineListToReturn = lineListToReturn + lines[i];
			count += 1;
		}
	}
	//println(count);
	return lineListToReturn;
}

// Count Semi Commented Lines per file, lines that contain code and comment
public int semiCommentedLinesFromFile(loc file) {
	list[str] lines = trimEmptyLinesFromFile(file);
	int count = 0;
	
	for (i <- [0 .. size(lines)]) {
		if (/.+\/{2,}/ := lines[i]) {
			count += 1;
		}
	}
	return count;
}

// Count Total lines per file
public int countTotalLinesFromFile(loc file) {
	try {
		//println(readFileLines(file));
		return size(readFileLines(file));
	}
	catch PathNotFound(e):
		println(e);
}

// Count Empty lines per file
public int countEmptyLinesFromFile(loc file) {
	return (countTotalLinesFromFile(file) - size(trimEmptyLinesFromFile(file)));
}

// Count NON Empty lines per file
public int countNonEmptyLinesFromFile(loc file) {
	return size(trimEmptyLinesFromFile(file));
}

// Count Commented lines per file
public int countCommentedLinesFromFile(loc file) {
	list[str] lines = trimEmptyLinesFromFile(file);
	int count = 0;
	
	for (i <- [0 .. size(lines)]) {

		if (contains(lines[i], "//")) {
			count += 1;
		} 
		else if ( contains(lines[i], "/*") ) {
			int tempI = i;
			int tempCount = count;
			try {
				while (!contains(lines[i], "*/")) {
					count += 1;
					i += 1;
				}
				count += 1;
				i += 1;
			}
			catch IndexOutOfBounds(e): {
				i = tempI;
				count = tempCount;
			}
		}
	}
	return count;
}

// Count LinesOfCode from file
public int countLOCFromFile(loc file) {
	//return size(trimEmptyLinesFromFile(file)) - countCommentedLinesFromFile(file) + semiCommentedLinesFromFile(file);
	return size(trimEmptyLinesFromFile(file)) - countCommentedLinesFromFile(file);
}

// Count LOCs from Project
public int countLOCFromProject(loc project) {
	list[loc] fileList = getFilesFromLoc(project);
	int count = 0;
	
	print("Number of Files: ");
	println(size(fileList));
	for (i <- [0 .. size(fileList)]) {
		count += countLOCFromFile(fileList[i]);
		
		print(i);
		print(" - ");
		print(count);
		print(" - ");
		println(fileList[i]);
	}
	return count; 
}
public int countLOCFromProject() {
	return countLOCFromProject(|project://hsqldb-2.3.1/|);
	//return countLOCFromProject(|project://smallsql0.21_src/|);
}


 

























