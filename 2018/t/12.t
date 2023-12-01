#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{12/a.pl 12/test.txt}, '20: 325'],
    [qw{12/a.pl 12/input.txt}, '50000000000: 2300000000006'],
   );
