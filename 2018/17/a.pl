#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../lib";
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my %clay;
  my @bb = ();
  for my $l (@$lines) {
    if ($l =~ m!x=(\d+), y=(\d+)..(\d+)!) {
      $clay{$_}->{$1} = '#' for ($2..$3);
      minmax_xy(\@bb, $1, $2);
      minmax_xy(\@bb, $1, $3);
    } elsif ($l =~ m!y=(\d+), x=(\d+)..(\d+)!) {
      $clay{$1}->{$_} = '#' for ($2..$3);
      minmax_xy(\@bb, $2, $1);
      minmax_xy(\@bb, $3, $1);
    } else {
      die "invalid input: $l\n";
    }
  }
  return { bb => \@bb, clay => \%clay, wsrc => [500, 0] };
}

sub pp {
  my ($s, $hx, $hy, $m) = @_;
  my $r = '';
  if (defined $m) {
    $r .= $m;
    if (defined $hx) {
      $r .= " $hx,$hy";
    }
    $r .= "\n";
  }
  my ($wc, $wcs);
  $r .= pretty_grid([$s->{bb}->[MINX] - 1, $s->{bb}->[MINY] - 1],
                    [$s->{bb}->[MAXX] + 1, $s->{bb}->[MAXY] + 1],
                    sub {
                      my ($x, $y) = @_;
                      my $sq;
                      if ($x == 500 && $y == $s->{bb}->[MINY] - 1) {
                        $sq = '+';
                      } elsif (exists $s->{clay}->{$y}->{$x}) {
                        $sq = $s->{clay}->{$y}->{$x};
                        $wcs++ if ($sq eq '~');
                        $wc++ if ($sq eq '~' || $sq eq '|');
                      } else {
                        $sq = '.';
                      }
                      if (defined $hx && $x == $hx &&
                          defined $hy && $y == $hy) {
                        return bold($sq);
                      } else {
                        return $sq;
                      }
                    },
                    sub { $wc = 0; $wcs = 0; ''; },
                    sub { ' '.$wc.' '.$wcs; },
                   );
  $r .= "\n";
  $r .= "Water: ".water_count($s)." ".water_count_still($s)."\n";
  return $r;
}

sub water_count {
  my ($s) = @_;
  my $c = 0;
  for my $y ($s->{bb}->[MINY]..$s->{bb}->[MAXY]) {
    for my $x ($s->{bb}->[MINX]-1..$s->{bb}->[MAXX]+1) {
      $c++ if (wet($s, $x, $y));
    }
  }
  return $c;
}

sub water_count_still {
  my ($s) = @_;
  my $c = 0;
  for my $y ($s->{bb}->[MINY]..$s->{bb}->[MAXY]) {
    for my $x ($s->{bb}->[MINX]..$s->{bb}->[MAXX]) {
      $c++ if (wet_still($s, $x, $y));
    }
  }
  return $c;
}

sub wet {
  my $sq = square(@_);
  return $sq if ($sq eq '~' || $sq eq '|');
  return '';
}

sub wet_still {
  my $sq = square(@_);
  return $sq eq '~';
}

sub clay {
  my $sq = square(@_);
  return $sq eq '#';
}

sub square {
  my ($s, $x, $y) = @_;
  if (exists $s->{clay}->{$y}->{$x}) {
    return $s->{clay}->{$y}->{$x};
  } else {
    return '.';
  }
}

sub pour {
  my ($s) = @_;
  my @todo = ($s->{wsrc});
  my %seen = ();
  while (@todo) {
    my $src = shift @todo;
    my ($sx, $sy) = @$src;
    my $y = $sy+1;
    while ($y <= $s->{bb}->[MAXY]) {
      my $sq = square($s, $sx, $y);
      #print STDERR pp($s, $sx, $y, 'checking '.$sq) if DEBUG;
      if ($sq eq '#' || $sq eq '~') {
        $y--;
        print STDERR "Found bottom at $sx, $y\n" if DEBUG;
        # bottom
        my $min_x;
        my $max_x;
        my $type = '~';
        for my $x ($sx+1 .. $s->{bb}->[MAXX]+1) {
          my $sq = square($s, $x, $y + 1);
          if ($sq eq '.' || $sq eq '|') {
            print STDERR "Found source at $x, $y\n" if DEBUG;
            if (!$seen{$x.','.$y}++) {
              push @todo, [$x, $y];
            }
            $max_x = $x;
            $type = '|';
            last;
          }
          if (clay($s,$x,$y)) {
            print STDERR "Found max at $x, $y\n" if DEBUG;
            $max_x = $x - 1;
            last;
          }
        }
        for my $x (reverse $s->{bb}->[MINX]-1 .. $sx-1) {
          my $sq = square($s, $x, $y + 1);
          if ($sq eq '.' || $sq eq '|') {
            print STDERR "Found source at $x, $y\n" if DEBUG;
            if (!$seen{$x.','.$y}++) {
              push @todo, [$x, $y];
            }
            $min_x = $x;
            $type = '|';
            last;
          }
          if (clay($s,$x,$y)) {
            print STDERR "Found min at $x, $y\n" if DEBUG;
            $min_x = $x + 1;
            last;
          }
        }
        if (defined $min_x && defined $max_x) {
          for ($min_x .. $max_x) {
            my $current_type = wet($s, $_, $y);
            if (!$current_type || $current_type ne $type) {
              $s->{clay}->{$y}->{$_} = $type;
            }
          }
        }
        $y--;
        last if ($type eq '|');
      } else {
        $s->{clay}->{$y}->{$sx} = '|';
      }
      $y++;
    }
  }
}

sub calc {
  my ($s) = @_;
  pour($s);
  print pp($s);
  return water_count($s);
}

my @test_input = split/\n/, <<'EOF';
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=1..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
EOF
my $test_input = parse_input(\@test_input);
print pp($test_input), "\n" if DEBUG;

@test_input = split/\n/, <<'EOF';
x=495, y=2..7
y=7, x=495..501
x=501, y=3..7
x=498, y=2..4
x=506, y=2..2
x=498, y=10..13
x=504, y=10..13
y=13, x=498..504
EOF
my $test_input2 = parse_input(\@test_input);
print pp($test_input2), "\n" if DEBUG;

if (TEST) {
  my $res = calc($test_input);
  print "Test 1a: $res == 57\n";
  die "failed\n" unless ($res == 57);

  $res = calc($test_input2);
  print "Test 1b: $res == 56\n";
  die "failed\n" unless ($res == 56);
}
print "Part 1: ", calc($i), "\n";

sub calc2 {
  my ($i) = @_;
  return water_count_still($i);
}

if (TEST) {
  my $res;
  $res = calc2($test_input);
  print "Test 2: $res == 29\n";
  die "failed\n" unless ($res == 29);
  $res = calc2($test_input);
  print "Test 2: $res == 29\n";
  die "failed\n" unless ($res == 29);
}
print "Part 2: ", calc2($i), "\n";
