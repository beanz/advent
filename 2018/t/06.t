#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{06/a.pl 06/test.txt 17}],
    [qw{06/a.pl 06/input.txt 6047}],
    [qw{06/b.pl 06/test.txt 16}],
    [qw{06/b.pl 06/input.txt 46320}],
   );
