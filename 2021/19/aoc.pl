#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $in = $reader->($file);
my $in2 = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  my @s = ();
  for my $ch (@$in) {
    my @l = split /\n/, $ch;
    my $n = shift @l;
    my $r = { name => $n, beacons => [ map { [ split /,/, $_ ] } @l] };
    push @s, $r;
  }
  return \@s;
}

# https://www.euclideanspace.com/maths/algebra/matrix/transforms/examples/index.htm
my @RS =
  (
   sub { [ $_[0]->[X], $_[0]->[Y], $_[0]->[Z]] },
   sub { [ $_[0]->[X], $_[0]->[Z], -$_[0]->[Y]] },
   sub { [ $_[0]->[X], -$_[0]->[Y], -$_[0]->[Z]] },
   sub { [ $_[0]->[X], -$_[0]->[Z], $_[0]->[Y]] },
   sub { [ $_[0]->[Y], -$_[0]->[X], $_[0]->[Z]] },
   sub { [ $_[0]->[Y], $_[0]->[Z], $_[0]->[X]] },
   sub { [ $_[0]->[Y], $_[0]->[X], -$_[0]->[Z]] },
   sub { [ $_[0]->[Y], -$_[0]->[Z], -$_[0]->[X]] },
   sub { [ -$_[0]->[X], -$_[0]->[Y], $_[0]->[Z]] },
   sub { [ -$_[0]->[X], -$_[0]->[Z], -$_[0]->[Y]] },
   sub { [ -$_[0]->[X], $_[0]->[Y], -$_[0]->[Z]] },
   sub { [ -$_[0]->[X], $_[0]->[Z], $_[0]->[Y]] },
   sub { [ -$_[0]->[Y], $_[0]->[X], $_[0]->[Z]] },
   sub { [ -$_[0]->[Y], -$_[0]->[Z], $_[0]->[X]] },
   sub { [ -$_[0]->[Y], -$_[0]->[X], -$_[0]->[Z]] },
   sub { [ -$_[0]->[Y], $_[0]->[Z], -$_[0]->[X]] },
   sub { [ $_[0]->[Z], $_[0]->[Y], -$_[0]->[X]] },
   sub { [ $_[0]->[Z], $_[0]->[X], $_[0]->[Y]] },
   sub { [ $_[0]->[Z], -$_[0]->[Y], $_[0]->[X]] },
   sub { [ $_[0]->[Z], -$_[0]->[X], -$_[0]->[Y]] },
   sub { [ -$_[0]->[Z], -$_[0]->[Y], -$_[0]->[X]] },
   sub { [ -$_[0]->[Z], -$_[0]->[X], $_[0]->[Y]] },
   sub { [ -$_[0]->[Z], $_[0]->[Y], $_[0]->[X]] },
   sub { [ -$_[0]->[Z], $_[0]->[X], -$_[0]->[Y]] },
  );

sub rotate {
  my ($p, $ri) = @_;
  return $RS[$ri]->($p);
}

#for my $ri (0..@RS-1) {
#  my $r = rotate([1,2,3], $ri);
#  print "@$r\n";
#}

for my $j (1..@$in-1) {
  for my $ri (0..@RS-1) {
    for my $b (@{$in->[$j]->{beacons}}) {
      push @{$in->[$j]->{rotated_beacons}->[$ri]}, rotate($b, $ri);
    }
  }
}

my %s;
$s{m}->{0,0,0} = 0;
push @{$s{l}}, [0,0,0];
my %b;
for my $bi (0..@{$in->[0]->{beacons}}-1) {
  my $b = $in->[0]->{beacons}->[$bi];
  $b{m}->{$b->[X],$b->[Y],$b->[Z]} = [0,$bi];
  push @{$b{l}}, $b;
}

sub align {
  my ($in, $beacons, $scanners, $scanner_i) = @_;
  print "Trying to align ", $in->[$scanner_i]->{name}, "\n" if DEBUG;
  for my $kbi (0..@{$beacons->{l}}-1) {
    my $known_beacon = $beacons->{l}->[$kbi];
    for my $bi (0..@{$in->[$scanner_i]->{beacons}}-1) {
      my $beacon = $in->[$scanner_i]->{beacons}->[$bi];
      print "  assuming [$kbi] @{$known_beacon} == [$bi] @{$beacon}\n" if (DEBUG > 1);
      for my $ri (0..@RS-1) {
        my $rbeacon = $in->[$scanner_i]->{rotated_beacons}->[$ri]->[$bi];
        print "trying rotation $ri *> @$rbeacon\n" if (DEBUG > 1);
        my $transform = [map { $known_beacon->[$_] - $rbeacon->[$_] } X, Y, Z];
        print "transform: @$transform\n" if (DEBUG > 1);
        my $c = 0;
        my @new = ();
        for my $obi (0..@{$in->[$scanner_i]->{beacons}}-1) {
          next if ($obi == $bi);
          my $robeacon = $in->[$scanner_i]->{rotated_beacons}->[$ri]->[$obi];
          #print "  trying other beacon [$obi] @{$robeacon}\n";
          my $trobeacon = [map { $robeacon->[$_] + $transform->[$_] } X, Y, Z];
          print "   @{$in->[$scanner_i]->{beacons}->[$obi]} *> @$robeacon +> @$trobeacon\n" if (DEBUG > 1);
          if (exists $beacons->{m}->{"@{$trobeacon}"}) {
            $c++;
          } else {
            push @new, $trobeacon;
          }
        }
        if ($c >= 11) {
          print "    found $c rotation $ri @{$transform}\n" if DEBUG;
          push @{$scanners->{l}}, $transform;
          for my $b (@new) {
            print "adding @$b to known set\n" if DEBUG;
            $beacons->{m}->{$b->[X],$b->[Y],$b->[Z]} = [0,$bi];
            push @{$beacons->{l}}, $b;
          }
          return 1;
        }
      }
    }
  }
  return 0;
}

my @todo = (1..@$in-1);
while (@todo) {
  my $try = shift @todo;
  if (!align($in, \%b, \%s, $try)) {
    push @todo, $try; # try again
  }
}
print "Part 1: ", scalar @{$b{l}}, "\n";
my $max;
for my $i (0..@{$s{l}}-1) {
  for my $j ($i+1..@{$s{l}}-1) {
    my $md = sum(map { abs($s{l}->[$i]->[$_] - $s{l}->[$j]->[$_]) } X, Y, Z);
    if (!defined $max || $md > $max) {
      $max = $md;
    }
  }
}
print "Part 2: ", $max, "\n";

exit;
