module basic::FirstFirgureTryOut

import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import vis::Figure;
import vis::Render;
import vis::KeySym;

import util::Editors;

import IO;
import String;
import Set;
import List;
import util::Math;

import SigBasis;


public M3 getModel(loc location) {
	M3 model = createM3FromEclipseProject(location); 
	return model;
}

public bool isValidPath(loc location) {
	locPath = location.path;
	bool val = false; 
	//println(locPath);
	if (
		!contains(locPath, "junit")
		&& (locPath != "/")
		&& (locPath != "/smallsql")
		&& !contains(locPath, "/doc")
		&& !contains(locPath, "/integration")
		&& !contains(locPath, "/generated")
		&& !contains(locPath, "/sample")
		&& !contains(locPath, "/samples")
		&& !contains(locPath, "/test") 
		&& !contains(locPath, "/tests") 
		&& !contains(locPath, "/junit")
		&& !contains(locPath, "/junits")
		) {
		val = true;
	}
	return val;
}

public set[loc] getPackages(M3 model) {
	set[loc] packagesLoc = {};
	
	for (l <- packages(model)) {
		if (isValidPath(l)) {
			packagesLoc += l;
		} 
	}
	return packagesLoc;
}

public set[loc] getClasses(loc location, M3 model) {
	set[loc] classesLoc = {};
	
	for (l <- classes(model)) {
		if (isValidPath(l) && contains(l.path, location.path)) {
			classesLoc += l;
		} 
	}
	return classesLoc;
}

public set[loc] getMethods(loc location, M3 model) {
	set[loc] methodsLoc = {};
	
	for (l <- methods(model)) {
		if (isValidPath(l) && contains(l.path, location.path)) {
			methodsLoc += l;
		} 
	}
	return methodsLoc;
}

public list[int] getSize(int sizeLevel) {
	list[int] size = [];
	
	switch(sizeLevel) {
		case 1: {size = [250,250];}
		case 2: {size = [150,50];}
		case 3: {size = [50,15];}
	}
	
	return size;
}

















public Figure drawBox() {
	Figure myFig = box(
					size(250,250),
					resizable(false),
					fillColor("white")
					);
	
	//render(myFig);
	
	return myFig;
}





public Figure drawMethods(set[loc] locations, M3 model, list[int] sizeLevel) {

	//list[list[Figure]] rows = [];
	list[Figure] rows = [];
	int x = head(sizeLevel);
	int y = last(sizeLevel);
	list[loc] listLoc = sort(toList(locations));
	int i = 0;
	
	while ( i < size(locations) ) {
		int j = 0;
		list[Figure] row = [];
		
		while ( j < 5 && i < size(locations) ) {
			//set[loc] methods = getMethods(head(listLoc[j..j+1]), model);
			cc = getCyclomaticComplexityWithAST(head(listLoc[i..i+1]), model);
			ccColor = color("white");
			if (cc > 10) {
				ccColor = color("orange");
			} else if (cc > 20) {
				ccColor = color("red");
			} else if (cc > 50) {
				ccColor = color("purple");
			}
			
			c = false;
			row += box(
						text(head(listLoc[i..i+1]).file + toString(cc), font("Courier"), fontColor(Color () { return c ? ccColor : color("black"); })),
						size(x,y),
						resizable(false),
						fillColor(Color () { return c ? color("black") : ccColor; }),
						onMouseEnter(void () { c = true; }), 
						onMouseExit(void () { c = false ; })
						
						,onMouseUp(bool (int butnr, map[KeyModifier,bool] modifiers) { 
									if (butnr == 1) { 
										println(head(listLoc[i..i+1]));
										//edit(head(listLoc[i..i+1]));
									}
									return true; 
								})
						);
			j += 1;
			i += 1;
		}
		
		//rows += [row];
		rows += row;
		
	}

	//return box(grid(rows, hgap(10), vgap(10)), fillColor(gray(0.75)));
	return box(pack(rows, std(gap(10))), fillColor(gray(0.75)));
}



public Figure drawClasses(set[loc] locations, M3 model, list[int] sizeLevel) {

	list[list[Figure]] rows = [];
	//list[Figure] rows = [];
	int x = head(sizeLevel);
	int y = last(sizeLevel);
	list[loc] listLoc = sort(toList(locations));
	int i = 0;
	
	while ( i < size(locations) ) {
		int j = 0;
		list[Figure] row = [];
		
		while ( j < 5 && i < size(locations) ) {
			set[loc] methods = getMethods(head(listLoc[i..i+1]), model);
			
			ccColor = color("white");
			for (m <- methods) {
				cc = getCyclomaticComplexityWithAST(m, model);
				if (cc > 10) {
					ccColor = color("orange");
				} else if (cc > 20) {
					ccColor = color("red");
				} else if (cc > 50) {
					ccColor = color("purple");
				}
			}
			c = false;
			row += box(
						text(head(listLoc[i..i+1]).file, font("Courier"), fontColor(Color () { return c ? ccColor : color("black"); })),
						size(x,y),
						resizable(false),
						fillColor(Color () { return c ? color("black") : ccColor; }),
						onMouseEnter(void () { c = true; }), 
						onMouseExit(void () { c = false ; }),
						onMouseUp(bool (int butnr, map[KeyModifier,bool] modifiers) { 
									if (butnr == 1) { 
										render(drawMethods(methods, model, getSize(3)));
										//render(box());
									}
									return true; 
								})
						);
			j += 1;
			i += 1;
		}
		
		rows += [row];
		//rows += row;
		
	}

	return box(grid(rows, hgap(10), vgap(10)), fillColor(gray(0.50)));
	//return pack(rows, std(gap(10)), fillColor(gray(0.50)));
}



public Figure drawPackages(set[loc] locations, M3 model, list[int] sizeLevel) {

	list[list[Figure]] rows = [];
	int x = head(sizeLevel);
	int y = last(sizeLevel);
	list[loc] listLoc = sort(toList(locations));
	int i = 0;
	
	while ( i < size(locations) ) {
		int j = 0;
		list[Figure] row = [];
		
		while ( j < 3 && i < size(locations) ) {
			set[loc] classes = getClasses(head(listLoc[i..i+1]), model);
			//println(classes);
			c = false;
			row += box(
						text(head(listLoc[i..i+1]).file, font("Courier"), fontColor(Color () { return c ? color("white") : color("black"); })),
						size(x,y),
						resizable(false),
						fillColor(Color () { return c ? color("black") : color("white"); }),
						onMouseEnter(void () { c = true; }), 
						onMouseExit(void () { c = false ; }),
						onMouseUp(bool (int butnr, map[KeyModifier,bool] modifiers) { 
									if (butnr == 1) { 
										render(drawClasses(classes, model, getSize(2)));
									}
									return true; 
								})
						);
			j += 1;
			i += 1;
		}
		
		rows += [row];
	}
	
	return box(grid(rows, hgap(10), vgap(10)), fillColor(gray(0.25)));
}
// model = getModel(|project://smallsql|);
// packages = getPackages(model);
// render(drawPackages(packages, model, getSize(1)));

// classes = getClasses(|java+package:///smallsql/database|, model)









