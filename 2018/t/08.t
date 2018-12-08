#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{08/a.pl 08/test.txt 138}],
    [qw{08/a.pl 08/input.txt 42798}],
    [qw{08/b.pl 08/test.txt 66}],
    [qw{08/b.pl 08/input.txt 23798}],
   );
