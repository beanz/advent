#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use Carp::Always qw/carp verbose/;

$| = 1;
$_ = <>;
my @i = split /,/;

my $part2_addr = $i[4];
print "Part 2 is at $part2_addr\n";
my @data;
for my $offset (6, 17, 64, 75, 98, 109) {
  my $addr = $part2_addr + $offset;
  my $inst = $i[$addr];
  if ($inst == 21101) {
    push @data, $i[$addr + 1] + $i[$addr + 2];
  } elsif ($inst == 21102) {
    push @data, $i[$addr + 1] * $i[$addr + 2];

  } else {
    die "unexpected instruction $inst\n" if ($inst != 21101);
  }
}
my %h;
plot(0, 0, 1, $data[0], \%h);
plot(20, 0, 1, $data[1], \%h);
plot(41, 3, -1, $data[2], \%h);
plot(21, 3, -1, $data[3], \%h);
plot(0, 4, 1, $data[4], \%h);
plot(20, 4, 1, $data[5], \%h);

for my $y (0 .. 5) {
  for my $x (0 .. 42) {
    print $h{"$x,$y"} // '.';
  }
  print "\n";
}
print "@data\n";

sub plot {
  my ($x, $y, $dx, $data, $h) = @_;
  my $bit = 2**39;
  while ($bit != 0) {
    $x += $dx;
    $h{"$x,$y"} = '#' if ($data & $bit);
    print "setting at $x,$y\n";
    $bit >>= 1;
    $y+= $dx;
    $h{"$x,$y"} = '#' if ($data & $bit);
    print "setting at $x,$y\n";
    $bit >>= 1;
    $x += $dx;
    $h{"$x,$y"} = '#' if ($data & $bit);
    print "setting at $x,$y\n";
    $bit >>= 1;
    $y-=$dx;
    $h{"$x,$y"} = '#' if ($data & $bit);
    $bit >>= 1;
    print "setting at $x,$y\n";
  }
}

