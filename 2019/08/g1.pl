#!/usr/bin/env perl -pln
$_=[sort{$a->[1]<=>$b->[1]}map{[$_=>(y/0/0/)]}unpack"(A150)*"]->[0]->[0];$_=(y/1/ /)*(y/2/#/);
