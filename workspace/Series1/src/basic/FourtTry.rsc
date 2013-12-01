module basic::FourtTry

import IO;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import basic::ThirdTry;


// get AST declaration from a method Location
// getASTFromMethodLoc(|java+method:///smallsql/database/ExpressionFunctionTruncate/getDouble()|);
// Once you have loaded the model in memory, you don't need to give the model to the AST method
public void getASTFromMethodLoc(loc location) {
	//println(getMethodASTEclipse(location, model=getModel()));
	Declaration dec = getMethodASTEclipse(location);
	visit(dec) {
		//case Statement: println("Braa!");
		//case \if(Expression condition, Statement thenBranch):{ println(condition); println(thenBranch);}
		case (Stm)`if (<Expr _>) {<Stm _>}`: println(Stm);
    	case (Stm)`if (<Expr _>) {<Stm _>} else {<Stm _>}`: println(Stm);
		case (Stm)`(<Expr _>) ? <Stm _> : <Stm _>;`: println(Stm);
	}
}



/*
M3 createM3FromEclipseProject(loc project)
http://tutor.rascal-mpl.org/Rascal/Rascal.html#/Rascal/Libraries/lang/java/jdt/m3/Core/getMethodASTEclipse/getMethodASTEclipse.html
Declaration getMethodASTEclipse(loc methodLoc, M3 model = m3(|unknown:///|));

and then start visiting the ast.
http://tutor.rascal-mpl.org/Rascal/Rascal.html#/Rascal/Libraries/lang/java/m3/AST/Declaration/Declaration.html

public void visit(t) {
	case leaf(int N): c = c + N;
}

|java+method:///smallsql/database/ExpressionFunctionRight/getBytes()|
|java+method:///smallsql/database/ExpressionFunctionLeft/getBytes()|
|java+method:///smallsql/junit/TestOperatoren/tearDown()|
|java+method:///smallsql/junit/TestFunctions/tearDown()|
|java+method:///smallsql/junit/TestDataTypes/tearDown()|
|java+method:///smallsql/junit/TestMoneyRounding/tearDown()|
|java+method:///smallsql/junit/TestOperatoren/tearDown()|
|java+method:///smallsql/junit/TestFunctions/tearDown()|
|java+method:///smallsql/junit/TestOperatoren/tearDown()|
|java+method:///smallsql/junit/TestOperatoren/runTest()|
|java+method:///smallsql/junit/TestJoins/runTest()|
|java+method:///smallsql/junit/TestFunctions/tearDown()|
|java+method:///smallsql/database/ExpressionFunctionRound/getDouble()|
|java+method:///smallsql/database/ExpressionFunctionTruncate/getDouble()|
*/





/*
			I have a set of classes
				set[loc] classes = returnClasses();

			
			From these classes I want to take one off the set
				tuple[int,set[int]] tupleClass = takeOneFrom(set[loc] classes);
				
			
			{ method | method <- returnMethodsFromClass(loc class), CONDITION }
			
			
			I want to have a set of methods that are longer then 6
					set[loc method]
			{ method | method <- return6LineMethods(set[loc method]), CONDITION }
			
			From the remaining set of classes I want to know If
					set[loc method] <- loc class <- set[loc class]
			the previous methods exist in them
					set[loc method] in set[loc method]?
					
					
					
*/
/*
|java+class:///smallsql/database/SSCallableStatement|
|java+class:///smallsql/database/IndexNode|
|java+class:///smallsql/junit/TestOrderBy|
|java+class:///smallsql/database/ExpressionFunctionLog10|
|java+class:///smallsql/database/ExpressionFunctionExp|
|java+class:///smallsql/tools/CommandLine|
|java+class:///smallsql/database/CommandSet|
|java+class:///smallsql/database/LongLongList|
|java+class:///smallsql/database/MutableFloat|
|java+class:///smallsql/database/ExpressionFunctionTruncate|
|java+class:///smallsql/database/ExpressionFunctionHour|
|java+class:///smallsql/database/IndexDescriptions|
|java+class:///smallsql/database/UnionAll|
|java+class:///smallsql/database/Logger|
|java+class:///smallsql/junit/TestGroupBy|
|java+class:///smallsql/database/ExpressionFunctionAscii|
|java+class:///smallsql/database/ExpressionFunctionRepeat|
|java+class:///smallsql/database/TableViewMap|
|java+class:///smallsql/database/ExpressionFunctionReturnFloat|
|java+class:///smallsql/database/ExpressionFunctionUCase|
|java+class:///smallsql/database/SSResultSetMetaData|
|java+class:///smallsql/junit/TestDBMetaData|
|java+class:///smallsql/database/ExpressionFunctionMod|
|java+class:///smallsql/database/LongList|
|java+class:///smallsql/database/TableViewResult|
|java+class:///smallsql/database/SSStatement|
*/