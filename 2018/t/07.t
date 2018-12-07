#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{07/a.pl 07/test.txt CABDFE}],
    [qw{07/a.pl 07/input.txt BETUFNVADWGPLRJOHMXKZQCISY}],
    [qw{07/b.pl 07/test.txt 15}],
    [qw{07/b.pl 07/input.txt 848}],
   );
