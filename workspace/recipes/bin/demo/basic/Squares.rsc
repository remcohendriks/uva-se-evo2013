module demo::basic::Squares

// We need to import IO to be able to use println.
import IO;

// Print a table of squares
public void squares(int N) {
	println("Table of squares from 1 to <N>");
	for (int I <- [1..N+1])
		println("<I> squared = <I * I>");
}