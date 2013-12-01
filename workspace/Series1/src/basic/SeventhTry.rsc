module basic::SeventhTry

import IO;
import List;
import String;

// getFileList(|project://smallsql/|);
public list[loc] getFileList( loc projectPath ) {
	list[str] pathList = listEntries(projectPath);
	list[loc] fileList = [];
	
	for ( int n <- [0 .. size(pathList)] ) {
		tPath = projectPath + pathList[n];

		if (contains(tPath.path, "/src")
			&& !contains(tPath.path, "/junit") 
			&& !contains(tPath.path, "/test")
			&& !contains(tPath.path, "/doc")
			&& !contains(tPath.path, "/integration")
			&& !contains(tPath.path, "/generated")
			&& !contains(tPath.path, "/sample")
			&& !contains(tPath.path, "/samples")
			&& !contains(tPath.path, "/test") 
			&& !contains(tPath.path, "/tests") 
			&& !contains(tPath.path, "/junit")
			&& !contains(tPath.path, "/junits")
		) {
			if ( isDirectory(tPath) ) {
				
				fileList += getFileList(tPath);
			} 
			else if ( isFile(tPath) ){
				if ( endsWith(tPath.path, ".java") ) {
					fileList += tPath;
				}
			}
		}
	}
	return fileList;
}

public list[str] getLines(list[loc] fileList) {
	list[str] lines = [];
	
	for ( file <- fileList ) {
		lines += readFileLines(file);
	}
	return lines;
}
/*
public list[str] trimLines(list[str] lines) {
	list[str] outLines = [];
	
	for( line <- lines ) {
		outLines += trim(line);
	}
	return outLines;
}
*/

public list[str] trimEmptyLines(list[str] lines) {
	list[str] outLines = [];
	
	for( line <- lines ) {
		if ( /(\W)?/ := line) {
			outLines += trim(line);
			//println(line);
		}
	}
	return outLines;
}

public list[str] trimComments(list[str] lines) {
	list[str] outLines = [];
	int i = 0;
	
	while( i < size(lines) ) {
		if ( (/^(\/\/)(.*)/ := lines[i]) ) {
			//outLines += lines[i];
			i += 1;
		} else if ( (/(\/\*)(.*)(\*\/)/ := lines[i]) ) {
			//outLines += lines[i];
			//println(lines[i]);
			i += 1;
		} else if ( (/(\/\*)/ := lines[i]) ) {
			//outLines += lines[i];
			//println(lines[i]);
			i += 1;
			int j = i;
			
			try {
				while( j < size(lines) ) {
					if ( !(/(\*\/)/ := lines[j]) ) {
						//outLines += lines[i];
						//println(lines[j]);
						j += 1;
						break;
					}
					j += 1;
				}
				j += 1;
				i = j;
				//outLines += lines[i];
				//println(lines[i]);
			} catch IndexOutOfBounds(e): {
				i += 1;
			}
		} else {
			//println(lines[i]);
			outLines += lines[i];
			i += 1;
		}
	}
	return outLines;
}

public int getLOCFromProject(loc projectPath) {
	int count = 0;
	
	count = size(trimComments(trimEmptyLines(getLines(getFileList(projectPath)))));
	
	return count;
}


