#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use IntCode;
use Carp::Always qw/carp verbose/;

$|=1;
my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  return [split /,/, $lines->[0]];
}

sub draw {
  my ($D) = @_;
  my $s = "";
  for my $y ($D->{bb}->[MINY] .. $D->{bb}->[MAXY]) {
    for my $x ($D->{bb}->[MINX] .. $D->{bb}->[MAXX]) {
      if ($x == $D->{pos}->[X] && $y == $D->{pos}->[Y]) {
        $s .= 'D';
      } elsif ($D->{oxy} && $x == $D->{oxy}->[X] && $y == $D->{oxy}->[Y]) {
        $s .= 'O';
      } elsif ($x == 0 && $y == 0) {
        $s .= 'S';
      } else {
        $s .= $D->{wall}->{hk($x,$y)} ? '#' : '.';
      }
    }
    $s .= "\n";
  }
  return $s;
}

sub dirstr {
  my $dir = shift;
  return ['', 'N', 'S', 'W', 'E']->[$dir];
}

sub dirnum {
  my $dirstr = shift;
  return { N => 1, S => 2, W => 3, E => 4 }->{$dirstr};
}

sub posstr {
  my $pos = shift;
  return "[".$pos->[X].','.$pos->[Y]."]";
}

sub find_maze {
  my ($prog) = @_;
  my $D =
    {
     pos => [0,0],
     bb => [],
     wall => {}, # walls
     s => { hk(0,0) => 0, }, # steps
     v => {},
     dist => 0,
    };
  minmax_xy($D->{bb}, @{$D->{pos}});
  my $ic = IntCode->new($prog, []);
  my $count = 0;
  my $prev = "";
  while (!$ic->{done}) {
    my $rc = $ic->run();
    if ($rc == 2) {
      my $min;
      for my $dir (1 .. 4) {
        my $dirstr = dirstr($dir);
        my $diroff = compassOffset($dirstr);
        my $nx = $D->{pos}->[X] + $diroff->[X];
        my $ny = $D->{pos}->[Y] + $diroff->[Y];
        next if (exists $D->{wall}->{hk($nx,$ny)});
        my $v = $D->{v}->{hk($nx,$ny)} // 0;
        if (!defined $min || $v < $min) {
          $min = $v;
          $D->{dir} = $dir
        }
      }
      push @{$ic->{i}}, $D->{dir};
      next;
    }
    if (@{$ic->{o}} == 1) {
      my $res = shift @{$ic->{o}};
      my $dirstr = dirstr($D->{dir});
      my $diroff = compassOffset($dirstr);
      my $nx = $D->{pos}->[X] + $diroff->[X];
      my $ny = $D->{pos}->[Y] + $diroff->[Y];
      minmax_xy($D->{bb}, $nx, $ny);
      $D->{v}->{hk($nx,$ny)}++;
      if ($res == 2) {
        $D->{oxy}->[X] = $nx;
        $D->{oxy}->[Y] = $ny;
        $D->{pos}->[X] = $nx;
        $D->{pos}->[Y] = $ny;
      } elsif ($res == 0) {
        $D->{wall}->{hk($nx,$ny)} = '#';
        #print "Failed to move ", $dirstr, "(", $D->{dir}, ")\n";
      } elsif ($res == 1) {
        #print "Moved $dirstr from ", posstr($D->{pos}), " to ";
        $D->{pos}->[X] = $nx;
        $D->{pos}->[Y] = $ny;
        $count++;
        my $n = draw($D);
        if (DEBUG) {
          print mcursor(0,0);
          print $n, "\n";
          print "Count: $count\n";
        }
        if (($count%1000) == 0) {
          $n =~ s/D/./;
          if ($n eq $prev) {
            if (DEBUG) {
              print mcursor(0,0);
              print $n, "\n";
            }
            return $n;
          }
          $prev = $n;
        }
      }
    }
  }
  return;
}

print clear() if DEBUG;
my $maze = find_maze($i);

my $c = 0;
my $l = index($maze, "\n");
$_ = $maze;
print clear() if DEBUG;
while (s/(?:\.(?=S))|(?:(?<=S)\.)|(?:\.(?=.{$l}S))|(?:(?<=S.{$l})\.)/s/gs) {
  $c++;
  if (DEBUG) {
    print mcursor(0,0);
    print "minute: $c\n";
    print $_,"\n";
  }
  s/s/S/g;
  select undef, undef, undef, 0.05 if DEBUG;
  last if (/SO|OS|O.{$l}S|S.{$l}O/);
}
print "Part 1: ", ($c + 1), "\n";

$_ = $maze;
s/S/./; # remove start point
$c = 0;
print clear() if DEBUG;
while (s/(?:\.(?=O))|(?:(?<=O)\.)|(?:\.(?=.{$l}O))|(?:(?<=O.{$l})\.)/o/gs) {
  $c++;
  if (DEBUG) {
    print mcursor(0,0);
    print "minute: $c\n";
    print $_,"\n";
  }
  s/o/O/g;
  select undef, undef, undef, 0.05 if DEBUG;
}
print "Part 2: ", $c, "\n";
