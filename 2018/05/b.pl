#!/usr/bin/perl -pl
$r=join"|",map{$_.uc$_,(uc$_).$_}a..z;
sub r{shift;while(s/$r//go){}~~y///c;}
$m=9e9;
$s=$_;
for$c(a..z){
  $_=$s;
  s/$c//gi;
  $n=r($_);
  $m=$m>$n?$n:$m;
}
$_=$m

