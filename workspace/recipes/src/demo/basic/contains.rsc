module demo::basic::contains

import List;
import IO;

list[str] text = ["andra", "moi", "ennepe", "Mousa", "polutropon"];

public int count(list[str] text){
  n = 0;
  for(s <- text) {
    if(/[a]/ := s) {
      n +=1;
    }
  }
  return n;
}

public list[str] find(list[str] text){
  return
    for(s <- text)
      if(/o/ := s)
        append s;
}

public list[str] duplicates(list[str] text){
    m = {};
    return 
      for(s <- text)
        if(s in m)
           append s;
        else
           m += s;
}

public bool isPalindrome(list[str] words){
  /*
  println(size(words));
  println(size(words) mod 2);
  println(size(words) / 2);
  println(words[0..(size(words) / 2)]);
  println(reverse(words[0..(size(words) / 2)]));
  */
  return words == words[0..(size(words) / 2)] + reverse(words[0..(size(words) / 2)]);
}

