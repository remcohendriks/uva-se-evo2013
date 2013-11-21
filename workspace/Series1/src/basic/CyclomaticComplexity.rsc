module basis::CyclomaticComplexity

/*
 *  function cc2rr: convers cc = Cyclomatic Complexity too rr = Risk Range          
 *  inputs:                                                                  
 *  - int CC  : integer greater the zero                               
 *  output:                                                                  
 *  - str :
 */
 public str cc2rr(int CC) {
	if (CC <  1) return "Elegal input foor CC";
	if (CC < 11) return  "1-10";
	if (CC < 21) return "11-20";
	if (CC < 51) return "21-50";
	if (CC > 50) return "\< 50";
	return "Unknown CC!";	
}

/*
 *  function rr2desc: convers rr = Risk Range too desc = description          
 *  inputs:                                                                  
 *  - int CC  : integer greater the zero                               
 *  output:                                                                  
 *  - str :
 */
public str rr2desc(str rr) {
	if (rr ==  "1-10") return "simple, without much risk";
	if (rr == "11-20") return "more complex, moderate risk";
	if (rr == "21-50") return "complex, high risk";
	if (rr == "\> 50") return "untestable, very high risk";
	return "Unknown CC Risk Range!";
}
