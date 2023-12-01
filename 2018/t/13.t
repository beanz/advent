#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{13/a.pl 13/test-0.txt}, "Crash at 0,3\nLast cart at 0,6"],
    [qw{13/a.pl 13/test-1.txt}, "Crash at 7,3\nNo last cart"],
    [qw{13/a.pl 13/test-2.txt},
     "Crash at 2,0\n".
     "Crash at 2,4\n".
     "Crash at 6,4\n".
     "Crash at 2,4\n".
     "Last cart at 6,4"],
    [qw{13/a.pl 13/input.txt},
     "Crash at 116,91\n".
     "Crash at 30,122\n".
     "Crash at 91,80\n".
     "Crash at 32,64\n".
     "Crash at 67,107\n".
     "Crash at 70,67\n".
     "Crash at 55,5\n".
     "Crash at 69,21\n".
     "Last cart at 8,23"],
   );
