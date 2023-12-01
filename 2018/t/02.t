#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{02/a.pl 02/test-1.txt 12}],
    [qw{02/a.pl 02/input.txt 9633}],
    [qw{02/b.pl 02/test-2.txt fgij}],
    [qw{02/b.pl 02/input.txt lujnogabetpmsydyfcovzixaw}],
   );
