#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{01/a.pl 01/test.txt 3}],
    [qw{01/a.pl 01/input.txt 505}],
    [qw{01/b.pl 01/test.txt 2}],
    [qw{01/b.pl 01/input.txt 72330}],
   );
