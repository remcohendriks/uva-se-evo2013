module basic::EightTry

import IO;
import List;
import String;
import ListRelation;

import basic::SeventhTry;

public void isDuplicate(tuple[list[str] linesA, list[str] linesB] toSearch) {
	int count = 0;
	int i = 0;
	int lines = 0;
	/*
	while ( i < size(toSearch.linesA) ) {
		int j = 0;
		
		while ( j < size(toSearch.linesB) ) {
			
			if (toSearch.linesA[i] == toSearch.linesB[j]) {
				int tempI = i;
				int tempJ = j;
				int tempCount = 0;
				
				try {
					while ( toSearch.linesA[tempI] == toSearch.linesB[tempJ] ) {
						//println(toSearch.linesA[tempI]);
						tempI += 1;
						tempJ += 1;
						tempCount += 1;
					}
				} catch IndexOutOfBounds(e): {
					print(".");
					//break;
				}
				
				if (tempCount > 5) {
					count += 1;
					lines += tempCount;
					i += tempCount - 1;
				}
			}
			j += 1;
		}
		i += 1;
	}
	println(count);
	println(lines);
	*/
	if([L, M] := toSearch.linesA) {
		println(<L><M>);
	}
}

public void isDuplicate2( list[str] lines ) {
	
	print("Indexes:\t\t\t\t");
	println(index(lines));
	
	println( take(6, lines) );
	
	/*
	print("Index of first occurrence of the line:\t");
	println( [indexOf(lines, x) | x <- lines] );
	
	print("Content of the indexes:\t\t\t");
	println( [lines[y] | y <- [indexOf(lines, x) | x <- lines]] );
	
	lineIndexes = [indexOf(lines, x) | x <- lines];
	println( [ x | x <- dup(lineIndexes) ] );
	*/
	/*
	print("distribution:\t\t\t\t");
	println( distribution([indexOf(lines, x) | x <- lines]) );
	
	dis = distribution([indexOf(lines, x) | x <- lines]);
	print("");
	println( reverse([x | x <- dis]) );
	*/
}

public void getDuplicates(loc projectPath) {
	list[str] lines = trimComments(trimEmptyLines(getLines(getFileList(projectPath))));
	int i = 0;
	int count = 0;
	
	
	list[tuple[int, str]] dups = [];
	
	for(line <- lines) {
		dups += <i, line>;
		i += 1;
	}
	
	isDuplicate2(lines);
}


public void isDup() {
	
	linesA = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "D", "E", "F"];
	linesB = ["D", "E", "F"];
	
	/*
	print("Indexes:\t\t\t\t");
	println(index(linesA));
	
	println( [z + 1 | x <- linesA, y <- linesB, x==y, z := 0 ] );
	
	println( [x | x <- linesA, y <- linesB, x==y ] );
	
	println( [ indexOf(linesA, z) | z <- [x | x <- linesA, y <- linesB, x==y] ] );
	
	list[str] L = [x | x <- linesA, y <- linesB, x==y];
	*/
	
	/*
	list [str] findMe = linesB;
	for ( [*L1, findMe, *L2] := linesA ) println( "<L1> <findMe> <L2>");
	*/
	
	
	//println(size(linesA));
	println("Permutations");
	println(index(linesA));
	
	int i=0;
	
	while ( i < (size(linesA)-2) ) {
		findMe = slice(linesA, i,3);
		
		for ( [*L1, findMe, *L2] := linesA ) {
		//for ( [*_, findMe, *_] := linesA ) {
			if (findMe == linesB) {
				//println( "<L1> <findMe> <L2>");
				//println( "<findMe>");
				//break;
				print(i);
				println(" TRUE");
				int j = i;
				/*
				for (j < size(linesA)) {
					linesA = delete(linesA, j);
					j += 1;
				}
				*/
				break;
			}
		}
		//println(linesA);
		i += 1;
	}
	
	
	/*
	print("Index of first occurrence of the line:\t");
	println( [indexOf(linesA, x) | x <- linesA] );
	
	print("Content of the indexes:\t\t\t");
	println( [linesA[y] | y <- [indexOf(linesA, x) | x <- linesA]] );
	
	lineIndexes = [indexOf(linesA, x) | x <- linesA];
	println( [ x | x <- dup(lineIndexes) ] );
	*/
	/*
	print("distribution:\t\t\t\t");
	println( distribution([indexOf(linesA, x) | x <- linesA]) );
	
	dis = distribution([indexOf(linesA, x) | x <- linesA]);
	print("");
	println( reverse([x | x <- dis]) );
	*/
}

public void isDup2() {
	
	linesA = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "D", "E", "F"];
	linesB = ["D", "E", "F"];

	println("Permutations");
	println(index(linesA));
	
	int i=0;
	
	while ( i < (size(linesA)-2) ) {
		findMe = slice(linesA, i,3);
		
		for ( [*_, findMe, *_] := linesA ) {
			if (findMe == linesB) {
				print(i);
				print(" TRUE ");
				println(i+size(findMe)-1);
				int j = i;
				break;
			}
		}
		i += 1;
	}
}
/*
public void getList() {
	//linesA = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "C", "D", "E", "F", "G", "H"];
	list[str] linesA = trimComments(trimEmptyLines(getLines(getFileList(|project://theHello/|))));
	linesB = [];
	tempL = [];
	int count = 0;
	int i = 0;
	
	list[str] temp = [];
	
	while ( i < (size(linesA)) ) {
		findMe = slice(linesA, i,1);
		
		for( [*L1, findMe, *L2] := linesA ) {
				//println("First loop <L1> <findMe>");
				for ( [*L3, findMe, *L4] := L2 ) {
					//println("Second loop <L3> <indexOf(linesA, findMe[0])> <findMe> <L4>");
					if ( indexOf(tempL, indexOf(linesA, findMe[0])) == -1 ) {
						//println("addin ");
						tempL += indexOf(linesA, findMe[0]);
					}
				}
		}
		//println( index(linesB) );
		//println( [head(linesB)..last(linesB)+1] );
		//println( linesB );
		if (tempL != []) {
			if ( (size([head(tempL)..last(tempL)+1]) == size(tempL)) && size(tempL) > 5 ) {
				println("YES!");
				//println(linesB);
			} else {
				println("Nooo!");
				tempL = [];
			}
		}
		i += 1;
	}

}
*/
public list[int] getListOfIndexes(list[str] linesA) {
	linesB = [];
	int count = 0;
	int i = 0;
	
	list[str] temp = [];
	
	while ( i < (size(linesA)) ) {
		findMe = slice(linesA, i,1);
		
		for( [*L1, findMe, *L2] := linesA ) {
			//println("First loop <L1> <findMe>");
			for ( [*L3, findMe, *L4] := L2 ) {
				//println("Second loop <L3> <indexOf(linesA, findMe[0])> <findMe> <L4>");
				if ( indexOf(linesB, indexOf(linesA, findMe[0])) == -1 ) {
					//println("addin ");
					linesB += indexOf(linesA, findMe[0]);
				}
			}
		}
		i += 1;
	}
	println( index(linesB) );
	println( [head(linesB)..last(linesB)+1] );
	println( linesB );
	if ( (size([head(linesB)..last(linesB)+1]) == size(linesB)) && size(linesB) > 5 ) {
		println("YES!");
		return linesB;
	} else {
		println("Nooo!");
		return linesB = [];
	}
}

public void isDuplicate3(loc projectPath) {
	
	list[str] linesA = trimComments(trimEmptyLines(getLines(getFileList(projectPath))));
	linesB = getListOfIndexes(linesA);

	println("Permutations");
	println(index(linesA));
	println(linesB);
	
	int i=0;
	
	while ( i < (size(linesA)-2) ) {
		findMe = slice(linesA, i,3);
		
		for ( [*_, findMe, *_] := linesA ) {
			if (findMe == linesB) {
				print(i);
				print(" TRUE ");
				println(i+size(findMe)-1);
				int j = i;
				break;
			}
		}
		i += 1;
	}
}


public void getList5() {
	linesA = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "C", "D", "E", "F", "G", "H"];
	//linesA = trimComments(trimEmptyLines(getLines(getFileList(|project://theHello/|))));
	linesB = [];
	found = false;

	int count = 0;
	int j = 0;
	list[str] findMe = [];
	
	findMe += pop(linesA)[0];
	linesB = pop(linesA)[1];
	
	while ( j < (size(linesA)) ) {
		int i = 0;
		
		println(findMe);
		//linesB = pop(linesA)[1];
			
		while ( i < (size(linesA)) ) {
			
			for( [*_, findMe, *_] := linesB ) {
				println("First loop <findMe>");
				found = true;
			}
			i += 1;
			if (found) { 
				println("found");
				break;
			} else {
				insertAt(findMe, size(findMe),pop(linesB)[0]);
				//linesB = pop(linesB)[1];
				//break;
			}
			//linesB = pop(linesB)[1];
		}
		j += 1;
		try {
			linesB = pop(linesB)[1];
			//println(findMe);
			println(pop(linesB)[0]);
			insertAt(findMe, size(findMe),pop(linesB)[0]);
			//linesB = pop(linesB)[1];
		} catch EmptyList(): {
			println("itsEmpty");
		}		
	}
}



public list[str] first6(int a) {
	//linesA = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "C", "D", "E", "F", "G", "H"];
	list[str] linesA = trimComments(trimEmptyLines(getLines(getFileList(|project://theHello/|))));

	int i = a;
	int b = i+3;
	list[str] find = [];
	
	while (i < b) {
		
		try {
			find += slice(linesA, i, b);
			//println(size(linesA));
			linesA = slice(linesA, b, size(linesA)-b-1);
		} catch IndexOutOfBounds(e):{
			break;
		}
		i += 1;
	}
	
	return find;
	
}

public void find(int a) {
	list[str] linesA = trimComments(trimEmptyLines(getLines(getFileList(|project://theHello/|))));
	list[str] linesB = first6(a);
	
	//println(linesB);
	for( [*_, linesB, *_] := linesA ) {
		println("First loop <linesB>");
	}
}



















