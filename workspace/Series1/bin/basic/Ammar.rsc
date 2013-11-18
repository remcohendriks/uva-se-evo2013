module basic::Ammar

import analysis::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

int countTotalCommentedLoc() {
	model = createM3FromEclipseProject(|project://smallsql0.21_src/|); 
	file = |java+compilationUnit:///src/smallsql/tools/CommandLine.java|;
	return (0 | it + (doc.end.line - doc.begin.line + 1) | doc <- model@documentation[file]);
} 
