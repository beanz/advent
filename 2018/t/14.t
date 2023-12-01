#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{14/a.pl 14/test-0a.txt 5158916779}],
    [qw{14/a.pl 14/test-1a.txt 0124515891}],
    [qw{14/a.pl 14/test-2a.txt 9251071085}],
    [qw{14/a.pl 14/test-3a.txt 5941429882}],
    [qw{14/a.pl 14/input.txt 5371393113}],
    [qw{14/b.pl 14/test-0b.txt 9}],
    [qw{14/b.pl 14/test-1b.txt 5}],
    [qw{14/b.pl 14/test-2b.txt 18}],
    [qw{14/b.pl 14/test-3b.txt 2018}],
    [qw{14/b.pl 14/input.txt 20286858}],
   );
