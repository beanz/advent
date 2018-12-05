#!/usr/bin/perl -l

@a=<>;
chomp @a;
for my$i(0..$#a){
  for my$j($i..$#a){
    $c="";
    $d=0;
    for my$k(0..length($a[$i])-1){
      if(substr($a[$i],$k,1) eq substr($a[$j],$k,1)){
        $c.=substr($a[$i],$k,1)
      } else {
        $d++
      }
    }
    print $c if ($d==1);
  }
}
