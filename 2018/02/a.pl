#!/usr/bin/perl -ln

$_=join"",sort split//;s/(.)\1{3,}//g;
$c3++ if (s/(.)\1\1//g);
$c2++ if(s/(.)\1//g);

END {
  print $c2*$c3;
}

