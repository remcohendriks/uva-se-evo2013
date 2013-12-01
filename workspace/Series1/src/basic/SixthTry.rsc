module basic::SixthTry

import IO;
import List;
import Tuple;
import String;
import Exception;
import ParseTree;

import util::FileSystem;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import basic::FifthTry;

public int getMcCabeFromMethod(Declaration method){
	nodes = 0;
	edges = 0;
	connected = 0;
	
	visit(method) {
		case \if(Expression condition, Statement thenBranch): { edges += 2; nodes += 1; }
	  	case \if(Expression condition, Statement thenBranch, Statement elseBranch): { edges += 2; nodes += 1; } 
	    case \case(Expression expression): { edges += 2; nodes += 1; }
	    case \defaultCase(): { edges += 2; nodes += 1; }
	    /*
	  	case \methodCall(bool isSuper, str name, list[Expression] arguments): { print("methodcall "); edges += 1; nodes += 1; }
        case \methodCall(bool isSuper, Expression receiver, str name, list[Expression] arguments): { print("methodcall "); edges += 1; nodes += 1; }
        */
        case \assert(Expression expression): { nodes += 1; edges += 2; }
        case \assert(Expression expression, Expression message): { nodes += 1; edges += 2; }
        case \while(Expression condition, Statement body): { nodes += 1; edges += 2; }
        case \foreach(Declaration parameter, Expression collection, Statement body): { nodes += 1; edges += 2; }
    	case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): { nodes += 1; edges += 2; }
    	case \for(list[Expression] initializers, list[Expression] updaters, Statement body): { nodes += 1; edges += 2; }	
    	case \do(Statement body, Expression condition): { nodes += 1; edges += 2; }	
        case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl): { nodes += 1; edges += 1; connected += 1; }
   		case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions): { nodes += 1; edges += 1; connected += 1; }
   		case \catch(Declaration exception, Statement body): { nodes += 1; edges += 2; }
   		case \return(Expression expression): { nodes += 1; connected += 1; }
   		case \return(): { nodes += 1; connected += 1; }
	}
	int cc = edges - nodes + connected;
	return cc;
}

public int cyclo(Declaration method) {
	result = 0;
	
	visit(method) {
		case \assert(Expression expression): result += 1;
		case \assert(Expression expression, Expression message): result += 1;
		case \do(Statement body, Expression condition): result += 1;
		case \foreach(Declaration parameter, Expression collection, Statement body): result += 1;
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body): result += 1;
		case \for(list[Expression] initializers, list[Expression] updaters, Statement body): result += 1;
		case \if(Expression condition, Statement thenBranch): result += 1;
		case \if(Expression condition, Statement thenBranch, Statement elseBranch): result += 2;
		case \switch(Expression expression, list[Statement] statements): result += 1;
		case \case(Expression expression): result += 1;
		case \while(Expression condition, Statement body): result += 1;
		case \catch(Declaration exception, Statement body): result += 1;
	}
	return result;
}

public void getCCstatistics(loc projectLoc) {

	M3 model = getModel(projectLoc);
	set[loc] classes = getClasses(model);
	list[tuple[int,loc,loc]] results = [];
	
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
			//mappedClasses += <trimCommentedLinesFromClass(trimEmptyLinesFromFile(class)), class>;
			set[loc] methods = getMethodsFromClass(model, class);
			
			for( method <- methods ) {
				astMethod = getMethodAST(method, model=model);
				// Get the McCabe CC from the AST Mehtod
				mcCabeCC = getMcCabeFromMethod(astMethod);
				// Store it in a List of Tuple <value, classLoc, methodLoc>
				results += <mcCabeCC,class,method>;
			}
			print("Itermediate results: ");
			println(results);
		}
	}
	
	/*
	for(fi <- result) {
		model = createM3FromFile(fi);
		methodes = methods(model);
		    
		for(method <- methodes) {
			ast = getMethodAST(method, model=model);
			cycloMaticComplexion = mccabe(ast);
			ret = <cycloMaticComplexion,fi,method>;
			allcc += ret;
			totalcc += cycloMaticComplexion;
		}
		print("\nProcessing ");
		print(fi);
	}
	*/
}



































 
 
 