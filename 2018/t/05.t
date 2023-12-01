#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use t::Helpers;
run(
    [qw{05/a.pl 05/test.txt 10}],
    [qw{05/a.pl 05/input.txt 11264}],
    [qw{05/b.pl 05/test.txt 4}],
    [qw{05/b.pl 05/input.txt 4552}],
   );
