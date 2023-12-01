#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{09/a.pl 09/test.txt}, "32\n8317\n146373\n2764\n54718\n37305"],
    [qw{09/a.pl 09/input-1.txt 385820}],
    [qw{09/b.pl 09/test.txt}, "32\n8317\n146373\n2764\n54718\n37305"],
    [qw{09/b.pl 09/input-2.txt 3156297594}],
   );
