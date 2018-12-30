#!/usr/bin/perl -ln
my $c=0;
$c+=$1 if (/^(.).*\1$/);
$c+=$1 while (s/(.)\1/\1/);
print $c;
