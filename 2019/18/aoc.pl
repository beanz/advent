#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use List::PriorityQueue;

$|=1;
my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub opt {
  my ($D) = @_;
  while (1) {
    my $changes = 0;
    for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
      for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
        if ($D->{m}->[$y]->[$x] ne ".") {
          next;
        }
        if ($D->{pos}->[X] == $x && $D->{pos}->[Y] == $y) {
          next;
        }
        my $w = 0;
        $w++ if ($D->{m}->[$y]->[$x-1] eq "#");
        $w++ if ($D->{m}->[$y]->[$x+1] eq "#");
        $w++ if ($D->{m}->[$y-1]->[$x] eq "#");
        $w++ if ($D->{m}->[$y+1]->[$x] eq "#");
        if ($w > 2) {
          $D->{m}->[$y]->[$x] = '#';
          $changes++;
        }
      }
    }
    last if (!$changes);
  }
  return;
}

sub draw {
  my ($D) = @_;
  my $s = "";
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if ($D->{pos}->[X] == $x && $D->{pos}->[Y] == $y) {
        $s .= '@';
      } else {
        $s .= $D->{m}->[$y]->[$x]
      }
    }
    $s .= "\n";
  }
  return $s;
}

sub posstr {
  my $pos = shift;
  return "[".$pos->[X].','.$pos->[Y]."]";
}

sub at {
  my ($D, $x, $y) = @_;
  return $D->{m}->[$y]->[$x] // '#';
}

sub parse_input {
  my ($lines) = @_;
  my $D = { m => [], bb => [], pos => [-1,-1], doors => 0, keys => 0 };
  $D->{bb}->[MINX] = $D->{bb}->[MINY] = 0;
  $D->{bb}->[MAXX] = length($lines->[0])-1;
  $D->{bb}->[MAXY] = @$lines-1;

  for my $y (0..@$lines-1) {
    my @r = ();
    for my $x (0..length($lines->[$y])-1) {
      my $ch = substr $lines->[$y], $x, 1;
      if ($ch eq "@") {
        $D->{pos}->[X] = $x;
        $D->{pos}->[Y] = $y;
        $ch = '.';
      } elsif ($ch =~ /[a-z]/) {
        $D->{keys}++;
      } elsif ($ch =~ /[A-Z]/) {
        $D->{doors}++;
      }
      push @r, $ch;
    }
    push @{$D->{m}}, \@r;
  }
  return $D;
}

use constant
  {
   POS => 0,
   STEPS => 1,
   NUM_KEYS => 2,
   KEYS => 3,
   PATH => 4,
   SORTEDPATH => 5,
  };

sub is_key_in_quad {
  my ($D, $key, $quad) = @_;
  if (!defined $quad) {
    return 1;
  }
  return exists $D->{qk}->{$quad}->{$key};
}

sub find_keys {
  my ($D, $pos) = @_;
  my %k;
  my %visited;
  my @search = ($pos);
  while (@search) {
    my $cur = shift @search;
    my $ch = at($D, @$cur);
    if ($ch eq '#') {
      next;
    }
    next if ($visited{$cur->[Y]}->{$cur->[X]}++);
    if ($ch =~ /[a-z]/) {
      $k{$ch}++;
    }
    for my $off (@{fourNeighbourOffsets()}) {
      push @search, [$cur->[X] + $off->[X], $cur->[Y] + $off->[Y]];
    }
  }
  return \%k;
}

sub find {
  my ($D, $pos, $quad) = @_;
  my $search = List::PriorityQueue->new();
  $search->insert([$pos, 0, 0, {}, "", ""], 0);
  #               pos, steps, num keys, keys, path, sortedpath
  my $tested = 0;
  my $todo = 1;
  my $expected_keys =
    defined $quad ? scalar keys %{$D->{qk}->{$quad}} : $D->{keys};
  print "Searching for $expected_keys keys from @$pos",
    (defined $quad ? " in quad $quad\n" : ''), "\n" if DEBUG;
  my %VISITED;
  my $min = 999999999;
  #while (@search) {
    #my $cur = shift @search;
  while (my $cur = $search->pop()) {
    print STDERR
      "Todo: $todo $tested $cur->[STEPS] $cur->[PATH]                    \r"
      if (DEBUG && ($tested%1000) == 0);
    $tested++;
    for my $off (@{fourNeighbourOffsets()}) {
      my $nx = $cur->[POS][X] + $off->[X];
      my $ny = $cur->[POS][Y] + $off->[Y];
      my $ch = at($D, $nx, $ny);
      if ($ch eq '#') {
        next;
      }
      # POS, STEPS, NUM_KEYS, KEYS, PATH, SORTEDPATH
      my $new =
        [
         [$nx, $ny],
         $cur->[STEPS]+1,
         $cur->[NUM_KEYS],
         { map { $_ => 1 } keys %{$cur->[KEYS]} },
         $cur->[PATH],
         $cur->[SORTEDPATH]
        ];
      next if ($new->[STEPS] > $min);
      if ($ch =~ /[A-Z]/) {
        if (!$new->[KEYS]->{lc $ch} && is_key_in_quad($D, (lc $ch), $quad)) {
          #print "$quad stuck at door $ch\n";
          next;
        }
      }
      if ($ch =~ /[a-z]/ && !exists $new->[KEYS]->{$ch}) {
        $new->[KEYS]->{$ch}++;
        $new->[NUM_KEYS]++;
        $new->[PATH] .= $ch;
        $new->[SORTEDPATH] = join '', sort split //, $new->[PATH];
        if ($new->[NUM_KEYS] == $expected_keys) {
          print STDERR "Found: $new->[PATH] $new->[STEPS]                      \n" if DEBUG;
          if ($min > $new->[STEPS]) {
            $min = $new->[STEPS];
          }
          next;
        }
      }
      my $vkey = $new->[POS]->[X].'!'.$new->[POS]->[Y].'!'.$new->[SORTEDPATH];
      if (exists $VISITED{$vkey} && $VISITED{$vkey} <= $new->[STEPS]) {
        next;
      }
      $VISITED{$vkey} = $new->[STEPS];
      my $remaining_keys = $expected_keys - $new->[NUM_KEYS];
      #push @search, $new;
      $search->insert($new, $remaining_keys);
      $todo++;
    }
  }
  if ($min == 999999999) {
    die "\nFailed to find any keys out of $expected_keys\n";
  }
  print "\n" if DEBUG;
  return $min;
}

sub part1 {
  my ($D) = @_;
  return find($D, $D->{pos});
}

sub part2 {
  my ($D) = @_;
  for my $off (@{fourNeighbourOffsets()}) {
    $D->{m}->[$D->{pos}->[Y] + $off->[Y]]->[$D->{pos}->[X] + $off->[X]] = '#';
  }
  my $sum = 0;
  for my $r ([-1,-1, 'A'], [1,-1,'B'], [-1,1,'C'], [1,1,'D']) {
    my ($ox, $oy, $quad) = @$r;
    my $x = $ox + $D->{pos}->[X];
    my $y = $oy + $D->{pos}->[Y];
    $D->{qk}->{$quad} = find_keys($D, [$x, $y]);
    print "Quad $quad ($x,$y) has ",
      (scalar keys %{$D->{qk}->{$quad}}), " keys: ",
      join '', keys %{$D->{qk}->{$quad}} if DEBUG;
    $sum += find($D, [$x, $y], $quad);
  }
  return $sum;
}

my $D = $i;
opt($D);
print draw($D) if DEBUG;
my $p1 = part1($D);
print "Part 1: $p1\n";
my $p2 = part2($D);
print "Part 2: $p2\n";
