#!/usr/bin/perl
use strict;
use warnings;
use v5.20;
$;=',';
my ($mx,$Mx,$My) = (10**10, -10**10, -10**10);
my %m;
while (<>) {
  my @n = m!(\d+)!g;
  my ($x, $y) = (shift @n, shift @n);
  $m{$x,$y} = '#'; 
  while(@n) {
    my ($nx, $ny) = (shift @n, shift @n);
    while ($x != $nx || $y != $ny) {
      if ($x < $nx) { $x++ } elsif ($x > $nx) { $x--; }
      if ($y < $ny) { $y++ } elsif ($y > $ny) { $y--; }
      $m{$x,$y} = '#';
      $mx = $x if ($mx > $x);
      $Mx = $x if ($Mx < $x);
      $My = $y if ($My < $y);
    }
  }
}
$_ = ("_" x (500-$mx+$My))."+".("_" x ($Mx-500+$My))."\n";
my $w = 1+$Mx-$mx+$My*2;
my $wm = $w-1;
my $wM = $w+1;
for my $y (0..$My+1) {
  for my $x ($mx-$My..$Mx+$My) {
    $_.= $m{$x,$y}//".";
  }
  $_.="\n";
}
my $E = $My-1;
my $c = 0;
my $p1;
while (s/\+.{$w}\K\./o/s) {
  $c++;
  while (s/o(.{$w})\./.$1o/s || s/o(.{$wm})\./.$1o/s || s/o(.{$wM})\./.$1o/s) { };
  if (!defined $p1 && (/^.{$E}o/m || /o.{$E}$/m)) {
    $p1 = $c-1;
    print STDERR "$p1\n";
  }
  #say "\033[3J\033[H\033[2J", $_;
  #select undef, undef, undef, 0.5;
}
say "Part 1: $p1\nPart 2: $c";
