#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{04/a.pl 04/test.txt 240}],
    [qw{04/a.pl 04/input.txt 71748}],
    [qw{04/b.pl 04/test.txt 4455}],
    [qw{04/b.pl 04/input.txt 106850}],
   );
