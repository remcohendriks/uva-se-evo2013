module basic::SecondTry

import ParseTree;
import IO;
import List;
import Message;
import Modifier;
import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import analysis::m3::Core;

public rel[loc src, loc name] countMethodesFromFile(loc file) {
	//println(createM3FromEclipseFile(file));
	
	// M3 CORE
		// ...
		//return createM3FromEclipseFile(file)@containment;
		
		// !!!-> Gives back the location of varaibales, methods, contructors, etc. The loc value contains the start and end lines of these values!!!!
		//return createM3FromEclipseFile(file)@declarations;
		
		// !!!-> Gives back the location of comments in the file. The loc value contains the start and end lines of these comments...!
		return createM3FromEclipseFile(file)@documentation;
		
		// Gets a list of relations from the file, for example a list of methods called within this file. Or fileds, variables or classes
		//return createM3FromEclipseFile(file)@uses;
	
	// M3 CORE Java Specific
		// If the class extends another class, returns the java+class path and the java+class path of the class that is beeing extended
		//return createM3FromEclipseFile(file)@extends;
		
		// ...
		//return createM3FromEclipseFile(file)@fieldAccess;
		
		// If the class implements an interface, returns the java+class path and the java+class path of the interface that is beeing implemented
		//return createM3FromEclipseFile(file)@implements;
		// ...
		
		//return createM3FromEclipseFile(file)@methodInvocation;
		// ...
		
		//return createM3FromEclipseFile(file)@methodOverrides;
		
		// ...
		//return createM3FromEclipseFile(file)@typeDependency;
}

// ...
public list[Message messages] messagesFromFile(loc file) {
	return createM3FromEclipseFile(file)@messages;
}

// ...
public rel[loc definition, Modifier modifier] modifierFromFile(loc file) {
	return createM3FromEclipseFile(file)@modifiers;
}

// ...
public rel[str simpleName, loc qualifiedName] namesFromFile(loc file) {
	return createM3FromEclipseFile(file)@names;
}

// ...
public rel[loc name, TypeSymbol typ] typesFromFile(loc file) {
	return createM3FromEclipseFile(file)@types;
}























