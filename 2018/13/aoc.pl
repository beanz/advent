#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my %c = ();
my @t = ();
my $y = 0;
my %r = ( '>' => '-', '<' => '-', '^' => '|', 'v' => '|' );
my %v = ( '>' => [1,0], '<' => [-1,0], '^' => [0,-1], 'v' => [0,1] );
for (@i) {
  chomp;
  while (m/([<>^v])/g) {
    my $x = pos($_) - 1;
    substr $_, $x, 1, $r{$1};
    $c{key($x,$y)} = [$1, 0, ''];
    #print STDERR "[$x,$y,$1]\n";
  }
  push @t, $_;
  $y++;
}

sub key {
  my ($x, $y) = @_;
  sprintf "%05d,%05d", $y, $x;
}

sub track {
  my ($t, $x, $y) = @_;
  substr $t[$y], $x, 1
}

sub move {
  my ($t, $c, $x, $y) = @_;
  my $d = $c->{key($x,$y)}->[0];
  #print STDERR "M: $x, $y $d\n";
  my $nx = $x + $v{$d}->[0];
  my $ny = $y + $v{$d}->[1];
  my $nt = track($t, $nx, $ny);
  #print STDERR "M: $x, $y $d $nt\n";
  my $nd;
  my $mc = $c->{key($x,$y)}->[1];
  if ($nt eq '+') {
    if ($mc == 0) {
      $nd = { '^' => '<', '>' => '^', 'v' => '>', '<' => 'v' }->{$d}
    } elsif ($mc == 1) {
      $nd = $d;
    } else {
      $nd = { '^' => '>', '>' => 'v', 'v' => '<', '<' => '^' }->{$d}
    }
    #print STDERR "T: $mc $d $nd\n";
    $mc++;
  } else {
    $nd =
      {
       '>\\' => 'v',
       '^\\' => '<',
       '<\\' => '^',
       'v\\' => '>',
       '</' => 'v',
       '^/' => '>',
       '>/' => '^',
     'v/' => '<',
      }->{$d.$nt} // $d;
  }
  return [$nx, $ny, $nd, $mc%3, key($x,$y)];
}

sub check_end {
  my ($c) = @_;
  my @k = sort keys %$c;
  if (@k == 0) {
    print "Part 2: No last cart\n";
    exit;
  } elsif (@k == 1) {
    my @part2 = reverse map { $_+0 } split /,/, $k[0];
    printf "Part 2: %d,%d\n", @part2;
    exit;
  }
}

my $t = 1;
my $part1;
while (1) {
  print STDERR "T: $t\n" if DEBUG;
  my @todo = sort keys %c;
  while (@todo) {
    my $xy = shift @todo;
    next if (!exists $c{$xy});
    my ($y, $x) = map { $_+0 } split /,/, $xy;
    my ($nx, $ny, $nd, $nm) = @{move(\@t, \%c, $x, $y)};
    print STDERR "Moving $x, $y => $nx, $ny\n" if DEBUG;
    delete $c{$xy};
    my $nxy = key($nx, $ny);
    if (exists $c{$nxy}) {
      print "Crash at $nx,$ny\n" if DEBUG;
      unless (defined $part1) {
        $part1 = "$nx,$ny";
        print 'Part 1: ', $part1, "\n";
      }
      delete $c{$nxy};
      next;
    }
    $c{$nxy} = [$nd, $nm];
    #pp(\@t, \%c);
  }
  #pp(\@t, \%c);
  $t++;
  check_end(\%c);
}

sub pp {
  state $red = `tput setaf 1`;
  state $white = `tput setaf 7`;
  my ($t, $c, $ox, $oy) = @_;
  my ($min_x, $max_x, $min_y, $max_y) =
    (0, (length $t->[0])-1, 0, @$t-1);
  if (defined $ox) {
    $min_x = max($ox-2, $min_x);
    $max_x = min($ox+2, $max_x);
    $min_y = max($oy-2, $min_y);
    $max_y = min($oy+2, $max_y);
  }
  for my $y ($min_y .. $max_y) {
    for my $x ($min_x .. $max_x) {
      if (exists $c->{key($x,$y)}) {
        print STDERR $red, $c->{key($x,$y)}->[0], $white;
      } else {
        print STDERR track($t, $x, $y);
      }
    }
    print STDERR "\n";
  }
  print STDERR "\n";
}
