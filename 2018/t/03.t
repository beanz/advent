#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{03/a.pl 03/test.txt 4}],
    [qw{03/a.pl 03/input.txt 106501}],
    [qw{03/b.pl 03/test.txt 3}],
    [qw{03/b.pl 03/input.txt 632}],
   );
