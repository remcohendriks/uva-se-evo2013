module demo::basic::Bubble

import List;
import IO;

// Variations on Bubble sort
// Sort1: uses list indexing and a for-loop
public list[int] sort1(list[int] Numbers) {
	for(int I <- [0..size(Numbers)-2]) {
		if(Numbers[I] > Numbers[I+1]) {
			<Numbers[I], Numbers[I+1]> = <Numbers[I+1], Numbers[I]>;
			return sort1(Numbers);
		}
	}
	return Numbers;
}

// Sort2: uses list matching and switch
public list[int] sort2(list[int] Numbers) {
	switch(Numbers){
		case[list[int] Nums1, int P, int Q, list[int] Nums2]:
			if(P > Q) {
				return sort2(Nums1 + [Q, P] + Nums2);
			} else {
				fail;
			}
		default: return Numbers;
	}
}

// Sort3: