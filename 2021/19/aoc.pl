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
my $g = $reader->($file);

sub read_stuff {
  my $file = shift;
  my $in = read_chunks($file);
  my @s = ();
  for my $ch (@$in) {
    my @l = split /\n/, $ch;
    my $n = shift @l;
    my $r = {
             name => $n, beacons => [ map { [ split /,/, $_ ] } @l],
             pos => undef,
            };
    for my $b (@{$r->{beacons}}) {
      $r->{bm}->{"@$b"} = 1;
    }
    for my $i (0..@{$r->{beacons}}-1) {
      for my $j (0..@{$r->{beacons}}-1) {
        $r->{dist}->{manhattan($r->{beacons}->[$i],
                               $r->{beacons}->[$j])}++;
      }
    }
    push @s, $r;
  }
  $s[0]->{pos} = [0,0,0];
  return
    {
     done => [0],
     todo => [1..@s-1],
     scanners => \@s,
     bm => { %{$s[0]->{bm}} },
     tried => {},
    };
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

sub manhattan {
  sum(map { abs($_[0]->[$_] - $_[1]->[$_]) } X, Y, Z)
}

sub count_intersection {
  my ($a, $b) = @_;
  my $c = 0;
  for my $k (keys %$a) {
    $c += min($a->{$k}, $b->{$k}) if (exists $b->{$k});
  }
  return $c;
}

sub align {
  my ($g, $scanner_i) = @_;
  my $unknown = $g->{scanners}->[$scanner_i];
  for my $ksi (@{$g->{done}}) {
    my $known = $g->{scanners}->[$ksi];
    my $beacons = $known->{beacons};
    next if (exists $g->{tried}->{$ksi,$scanner_i});
    $g->{tried}->{$ksi,$scanner_i}++;
    print "Trying to align ", $unknown->{name}, " with $ksi\n" if DEBUG;
    next unless (count_intersection($unknown->{dist}, $known->{dist}) > 60);
    for my $kbi (0..@{$beacons}-1) {
      my $known_beacon = $beacons->[$kbi];
      for my $bi (0..@{$unknown->{beacons}}-1) {
        my $beacon = $unknown->{beacons}->[$bi];
        print "  assuming [$kbi] @{$known_beacon} == [$bi] @{$beacon}\n"
          if (DEBUG > 1);
        for my $ri (0..@RS-1) {
          my $rbeacon = $unknown->{rotated_beacons}->[$ri]->[$bi];
          print "trying rotation $ri *> @$rbeacon\n" if (DEBUG > 1);
          my $transform = [map { $known_beacon->[$_] - $rbeacon->[$_] } X, Y, Z];
          print "transform: @$transform\n" if (DEBUG > 2);
          my $c = 0;
          my @new = ();
          for my $obi (0..@{$unknown->{beacons}}-1) {
            next if ($obi == $bi);
            my $robeacon = $unknown->{rotated_beacons}->[$ri]->[$obi];

            #print "  trying other beacon [$obi] @{$robeacon}\n";
            my $trobeacon = [map { $robeacon->[$_] + $transform->[$_] } X, Y, Z];
            print "   @{$unknown->{beacons}->[$obi]} *> @$robeacon +> @$trobeacon", (exists $known->{bm}->{"@{$trobeacon}"} ? " *" : ""),"\n" if (DEBUG > 2);
            if (exists $known->{bm}->{"@{$trobeacon}"}) {
              $c++;
            }
            push @new, $trobeacon;
          }
          if ($c >= 10) { # TOFIX should be 11?
            print "    found $c rotation $ri @{$transform}\n" if DEBUG;
            print "fixed ", $scanner_i, " with $ksi\n" if DEBUG;
            $unknown->{pos} = $transform;
            for my $b (@new) {
              print "adding @$b to known set\n" if DEBUG;
              $g->{bm}->{$b->[X],$b->[Y],$b->[Z]} = [0,$bi];
            }
            $unknown->{beacons} = [@new];
            $unknown->{bm} = {};
            $unknown->{bm}->{"@$_"}++ for (@new);
            push @{$g->{done}}, $scanner_i;
            return 1;
          }
        }
      }
    }
  }
  return 0;
}

sub update_rotations {
  my ($g, $i) = @_;
  for my $ri (0..@RS-1) {
    for my $b (@{$g->{scanners}->[$i]->{beacons}}) {
      push @{$g->{scanners}->[$i]->{rotated_beacons}->[$ri]}, rotate($b, $ri);
    }
  }
}

for my $j (@{$g->{todo}}) {
  update_rotations($g, $j);
}

while (@{$g->{todo}}) {
  my $before = @{$g->{todo}};
  my @n;
  for my $try (@{$g->{todo}}) {
    if (!align($g, $try)) {
      push @n, $try; # try again
    }
  }
  $g->{todo} = [@n];
  if ($before == @n) {
    print "No progress. Done: @{$g->{done}}   Todo: @{$g->{todo}}\n";
    exit 1;
  }
}

print "Part 1: ", scalar keys %{$g->{bm}}, "\n";
my $max;
for my $i (0..@{$g->{scanners}}-1) {
  for my $j ($i+1..@{$g->{scanners}}-1) {
    my $md = sum(map { abs($g->{scanners}->[$i]->{pos}->[$_] -
                          $g->{scanners}->[$j]->{pos}->[$_]) } X, Y, Z);
    if (!defined $max || $md > $max) {
      $max = $md;
    }
  }
}
print "Part 2: ", $max, "\n";

exit;
