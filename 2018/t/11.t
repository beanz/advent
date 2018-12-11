#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use t::Helpers;

run(
    [qw{11/a.pl 11/test-0.txt 4}],
    [qw{11/a.pl 11/test-1.txt -5}],
    [qw{11/a.pl 11/test-2.txt 0}],
    [qw{11/a.pl 11/test-3.txt 4}],
    [qw{11/a.pl 11/test-4.txt 29}],
    [qw{11/a.pl 11/test-5.txt 30}],
    [qw{11/c.pl 11/test-0.txt}, '3,5,1 4'],
    [qw{11/c.pl 11/test-1.txt}, '122,79,1 -5'],
    [qw{11/c.pl 11/test-2.txt}, '217,196,1 0'],
    [qw{11/c.pl 11/test-3.txt}, '101,153,1 4'],
    [qw{11/c.pl 11/test-4.txt}, '33,45,3 29'],
    [qw{11/c.pl 11/test-5.txt}, '21,61,3 30'],
    [qw{11/c.pl 11/test-6.txt}, '90,269,16 113'],
    [qw{11/c.pl 11/test-7.txt}, '232,251,12 119'],
    [qw{11/c.pl 11/test-8.txt}, '237,227,14 108'],
    #[qw{11/c.pl 11/input.txt}, '237,227,14 108'],
   );
