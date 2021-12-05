#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

sub lxy {
  my ($l, $x, $y) = @_;
  if ($y >= @$l || $y < 0 ||
      $x >= length($l->[0]) || $x < 0) {
    return '#';
  } else {
    return substr $l->[$y], $x, 1;
  }
}

sub add_portal {
  my ($D, $name, $exitAx, $exitAy, $entranceAx, $entranceAy) = @_;
  if ($name eq 'AA' || $name eq 'ZZ') {
    print "found $name at $exitAx,$exitAy\n" if DEBUG;
    $D->{$name} = [$exitAx, $exitAy];
    $D->{m}->{hk($entranceAx,$entranceAy)} = '#';
    return;
  }
  my $level;
  if ($exitAy == ($D->{bb}->[MINY]+2) ||
      $exitAy == ($D->{bb}->[MAXY]-2) ||
      $exitAx == ($D->{bb}->[MINX]+2) ||
      $exitAx == ($D->{bb}->[MAXX]-2)) {
    $level = -1;
    print "found outer portal $name $exitAx,$exitAy\n" if DEBUG;
  } else {
    $level = 1;
    print "found inner portal $name $exitAx,$exitAy\n" if DEBUG;
  }
  my $rec = $D->{rp}->{$name};
  if (defined $rec) {
    my ($exitBx, $exitBy, $entranceBx, $entranceBy) = @$rec;
    print "  $exitAx, $exitAy => $exitBx,$exitBy\n" if DEBUG;
    print "  $exitBx, $exitBy => $exitAx,$exitAy\n" if DEBUG;
    $D->{p}->{hk($exitAx,$exitAy)} = [$exitBx, $exitBy, $name, $level];
    $D->{p}->{hk($exitBx,$exitBy)} = [$exitAx, $exitAy, $name, -1*$level];
    $D->{m}->{hk($entranceAx,$entranceAy)} = '#';
    $D->{m}->{hk($entranceBx,$entranceBy)} = '#';
    delete $D->{rp}->{$name};
  } else {
    $D->{rp}->{$name} = [$exitAx,$exitAy,$entranceAx,$entranceAy];
  }
}

sub optimaze {
  my ($D) = @_;
  #print `tput clear`.draw($D);
  my $changes = 1;
  while ($changes) {
    #select undef, undef, undef, 1;
    $changes = 0;
    for my $y ($D->{bb}->[MINY]+2 .. $D->{bb}->[MAXY]-2) {
      for my $x ($D->{bb}->[MINX]+2 .. $D->{bb}->[MAXX]-2) {
        my $hk = hk($x,$y);
        if ($D->{p}->{$hk} || $D->{m}->{$hk} ||
            ($x == $D->{'AA'}->[X] && $y == $D->{'AA'}->[Y]) ||
            ($x == $D->{'ZZ'}->[X] && $y == $D->{'ZZ'}->[Y])) {
          next;
        }
        my $w = 0;
        $w++ if ($D->{m}->{hk($x,$y-1)});
        $w++ if ($D->{m}->{hk($x-1,$y)});
        $w++ if ($D->{m}->{hk($x+1,$y)});
        $w++ if ($D->{m}->{hk($x,$y+1)});
        if ($w > 2) {
          $D->{m}->{$hk} = 1;
          $changes++;
        }
      }
    }
    #print `tput cup 0 0`.draw($D);
  }
}

sub parse_input {
  my ($lines) = @_;
  my $D = {m => {}, bb => [], p => {} };
  $D->{bb}->[MINX] = $D->{bb}->[MINY] = 0;
  $D->{bb}->[MAXX] = length($lines->[0])-1;
  $D->{bb}->[MAXY] = @$lines-1;
  for my $y (0.. @$lines-1) {
    for my $x (0..length($lines->[$y])-1) {
      if (lxy($lines,$x,$y-2) =~ /[A-Z]/ &&
          lxy($lines,$x,$y-1) =~ /[A-Z]/ &&
          lxy($lines,$x,$y) eq '.') {
        # top portal
        my $name = lxy($lines,$x,$y-2).lxy($lines,$x,$y-1);
        add_portal($D, $name, $x, $y, $x, $y-1);
      } elsif (lxy($lines,$x,$y) eq '.' &&
               lxy($lines,$x,$y+1) =~ /[A-Z]/ &&
               lxy($lines,$x,$y+2) =~ /[A-Z]/) {
        # bottom portal
        my $name = lxy($lines,$x,$y+1).lxy($lines,$x,$y+2);
        add_portal($D, $name, $x, $y, $x, $y+1);
      } elsif (lxy($lines,$x-2,$y) =~ /[A-Z]/ &&
               lxy($lines,$x-1,$y) =~ /[A-Z]/ &&
               lxy($lines,$x,$y) eq '.') {
        # left portal
        my $name = lxy($lines,$x-2,$y).lxy($lines,$x-1,$y);
        add_portal($D, $name, $x, $y, $x-1, $y);
      } elsif (lxy($lines,$x,$y) eq '.' &&
               lxy($lines,$x+1,$y) =~ /[A-Z]/ &&
               lxy($lines,$x+2,$y) =~ /[A-Z]/) {
        # right portal
        my $name = lxy($lines,$x+1,$y).lxy($lines,$x+2,$y);
        add_portal($D, $name, $x, $y, $x+1, $y);
      } elsif (lxy($lines,$x,$y) eq '#') {
        $D->{m}->{hk($x,$y)} = '#';
      }
    }
  }
  optimaze($D);
  return $D;
}

sub draw {
  my ($D, $pos) = @_;
  my $s = "";#`tput cup 0 0`;
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if (defined $pos && $x == $pos->[X] && $y == $pos->[Y]) {
        $s .= '@';
      } elsif ($x == $D->{'AA'}->[X] && $y == $D->{'AA'}->[Y]) {
        $s .= 'S';
      } elsif ($x == $D->{'ZZ'}->[X] && $y == $D->{'ZZ'}->[Y]) {
        $s .= 'E';
      } elsif ($D->{p}->{hk($x,$y)}) {
        $s .= '~';
      } elsif ($D->{m}->{hk($x,$y)}) {
        $s .= '#';
      } else {
        $s .= '.';
      }
    }
    $s .= "\n";
  }
  return $s;
}

sub calc {
  my ($D) = @_;
  my @search = ([$D->{'AA'}, 0, []]);
  my %visited;
  while (@search) {
    my $cur = shift @search;
    my ($pos, $steps, $path) = @$cur;
    my $vkey = hk(@$pos);
    if (exists $visited{$vkey}) {
      next;
    }
    $visited{$vkey}++;
    if (exists $D->{m}->{hk($pos->[X],$pos->[Y])}) {
      next;
    }
    print "Trying @$pos ($steps @$path)\n" if DEBUG;
    if ($pos->[X] == $D->{'ZZ'}->[X] &&
        $pos->[Y] == $D->{'ZZ'}->[Y]) {
      return $steps;
    }
    my $portal = $D->{p}->{hk($pos->[X],$pos->[Y])};
    if (defined $portal) {
      # portal
      my ($nx, $ny, $name) = @$portal;
      print "found $name to $nx,$ny\n" if DEBUG;
      push @search, [[$nx,$ny], $steps+1, [@$path, $name]];
    }
    for my $off (@{fourNeighbourOffsets()}) {
      my $nx = $pos->[X] + $off->[X];
      my $ny = $pos->[Y] + $off->[Y];
      #next unless ($off->[Y] == 1);
      push @search, [[$nx, $ny], $steps+1, [@$path]];
    }
  }
  return -1;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1a.txt", 23 ],
     [ "test1b.txt", 58 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(parse_input(read_lines($tc->[0])));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

my $D = parse_input(\@i);
my $part1 = calc($D);
print "Part 1: ", $part1, "\n";

sub calc2 {
  my ($D) = @_;
  my @search = ([$D->{'AA'}, 0, 0, []]);
  my %visited;
  while (@search) {
    my $cur = shift @search;
    my ($pos, $level, $steps, $path) = @$cur;
    my $vkey = hk(@$pos, $level);
    if (exists $visited{$vkey}) {
      next;
    }
    $visited{$vkey}++;
    if (exists $D->{m}->{hk($pos->[X],$pos->[Y])}) {
      next;
    }
    #print `tput cup 0 0`;
    print "Trying $pos->[X],$pos->[Y] @ $level ($steps [@$path])\n" if DEBUG;
    #print draw($D, $pos);
    #select undef, undef, undef, 0.5;
    if ($pos->[X] == $D->{'ZZ'}->[X] &&
        $pos->[Y] == $D->{'ZZ'}->[Y] && $level == 0) {
      print "Path: @$path\n" if DEBUG;
      return $steps;
    }
    my $portal = $D->{p}->{hk($pos->[X],$pos->[Y])};
    if (defined $portal) {
      # portal
      my ($nx, $ny, $name, $level_diff) = @$portal;
      my $nlevel = $level + $level_diff;
      print "  found $name to $nx,$ny, level $nlevel\n" if DEBUG;
      if ($nlevel >= 0) {
        push @search, [[$nx,$ny], $nlevel, $steps+1, [@$path, $name]];
      }
    }
    for my $off (@{fourNeighbourOffsets()}) {
      my $nx = $pos->[X] + $off->[X];
      my $ny = $pos->[Y] + $off->[Y];
      #next unless ($off->[Y] == 1);
      push @search, [[$nx, $ny], $level, $steps+1, [@$path]];
    }
  }
  return -1;
}

if (TEST) {
  my @test_cases =
    (
     [ "test1a.txt", 26 ],
     [ "test2a.txt", 396 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(parse_input(read_lines($tc->[0])));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

print "Part 2: ", calc2($D), "\n";
