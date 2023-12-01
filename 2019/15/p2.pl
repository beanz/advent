#!/usr/bin/env perl -0l

$|=1;
$_ = <>;
s/S/./; # remove start point
my $c = 0;
my $l = index($_, "\n");
print `tput clear`;
while (s/(?:\.(?=O))|(?:(?<=O)\.)|(?:\.(?=.{$l}O))|(?:(?<=O.{$l})\.)/o/gs) {
  $c++;
  print `tput cup 0 0`;
  print "minute: $c\n";
  print $_,"\n";
  s/o/O/g;
  select undef, undef, undef, 0.05;
}
print "part2: $c\n";
