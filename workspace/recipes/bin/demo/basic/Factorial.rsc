module demo::basic::Factorial

//This implementation uses a conditional expression to distinguish cases.
public int fac(int N) = N <= 0 ? 1 : N * fac(N-1);

// Does the same but uses pattern dispatch
public int fac2(0) = 1;
public default int fac2(int N) = N * fac2(N-1);

// Imperative implementation
public int fac3(int N) {
	if (N == 0) 
		return 1;
	return N * fac3(N-1);
}