#!/usr/bin/perl -0l

$|=1;
$_ = <>;
my $c = 0;
my $l = index($_, "\n");
print `tput clear`;
while (s/(?:\.(?=S))|(?:(?<=S)\.)|(?:\.(?=.{$l}S))|(?:(?<=S.{$l})\.)/s/gs) {
  $c++;
  print `tput cup 0 0`;
  print "minute: $c\n";
  print $_,"\n";
  s/s/S/g;
  select undef, undef, undef, 0.05;
  last if (/SO|OS|O.{$l}S|S.{$l}O/);
}
print "part1: ", ($c + 1), "\n";
