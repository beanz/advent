#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

use Carp::Always qw/carp verbose/;

#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);

use constant {
  UP => 0,
  DOWN => 1,
  LEFT => 2,
  RIGHT => 3,

  FACE => 0,
  DIR => 1,
};

sub read_stuff {
  my $file = shift;
  my $in = read_guess($file);
  my %m = (
    pos => [0, 0],
    dir => [1, 0],
    m => [map {[split //, $_]} @{$in->[0]}],
    walk => $in->[1]->[0]
  );
  $m{h} = scalar @{$m{m}};
  $m{w} = max(map {scalar @$_} @{$m{m}});
  for my $y (0 .. $m{h} - 1) {
    while (scalar @{$m{m}->[$y]} < $m{w}) {
      push @{$m{m}->[$y]}, ' ';
    }
  }
  while ($m{m}->[0]->[$m{pos}->[X]] ne '.') {$m{pos}->[X]++}
  if ($m{h} == 12) {
    $m{dim} = 4;
    $m{face} = [[2, 0], [0, 1], [1, 1], [2, 1], [2, 2], [3, 2]];
    $m{nface} = [

      # UP         DOWN       LEFT       RIGHT  < how we exit
      [[1, DOWN], [3, DOWN], [2, DOWN], [5, LEFT]],
      [[0, DOWN], [4, UP], [5, UP], [2, RIGHT]],
      [[0, RIGHT], [4, RIGHT], [1, LEFT], [3, RIGHT]],
      [[0, UP], [4, DOWN], [2, LEFT], [5, DOWN]],
      [[3, UP], [1, UP], [2, UP], [5, RIGHT]],
      [[3, LEFT], [1, RIGHT], [4, LEFT], [0, LEFT]],
    ];
  } else {
    $m{dim} = 50;
    $m{face} = [[1, 0], [2, 0], [1, 1], [0, 2], [1, 2], [0, 3]];
    $m{nface} = [

      # UP      DOWN     LEFT     RIGHT  < how we exit
      [[5, RIGHT], [2, DOWN], [3, RIGHT], [1, RIGHT]],
      [[5, UP], [2, LEFT], [0, LEFT], [4, LEFT]],
      [[0, UP], [4, DOWN], [3, DOWN], [1, UP]],
      [[2, RIGHT], [5, DOWN], [0, RIGHT], [4, RIGHT]],
      [[2, UP], [5, LEFT], [3, LEFT], [1, LEFT]],
      [[3, UP], [1, DOWN], [0, DOWN], [4, UP]],
    ];
  }
  $m{rface} = {};
  for my $i (0 .. 5) {
    my ($fx, $fy) = @{$m{face}->[$i]};
    $m{rface}->{$fx, $fy} = $i;
  }
  sanity($m{nface});
  return \%m;
}

sub sanity {
  my ($nf) = @_;
  my %s;
  for my $f (0 .. 5) {
    for my $d (UP, DOWN, LEFT, RIGHT) {
      my ($nf, $nd) = @{$nf->[$f]->[$d]};
      die "$f $d => $nf $nd\n" if (exists $s{$nf, $nd});
      $s{$nf, $nd}++;
    }
  }
}

sub pdir {
  my ($d) = @_;
  if ($d->[X] == 1) {
    return ">";
  }
  if ($d->[X] == -1) {
    return "<";
  }
  if ($d->[Y] == 1) {
    return "v";
  }
  if ($d->[Y] == -1) {
    return "^";
  }
}

sub facing {
  my ($d) = @_;
  if ($d->[Y] == -1) {
    return 3;
  }
  if ($d->[Y] == 1) {
    return 1;
  }
  if ($d->[X] == -1) {
    return 2;
  }
  if ($d->[X] == 1) {
    return 0;
  }
}

sub off2dir {
  my ($d) = @_;
  if ($d->[Y] == -1) {
    return UP;
  }
  if ($d->[Y] == 1) {
    return DOWN;
  }
  if ($d->[X] == -1) {
    return LEFT;
  }
  if ($d->[X] == 1) {
    return RIGHT;
  }
}

sub dir2off {
  my ($dir) = shift;
  return [[0, -1], [0, 1], [-1, 0], [1, 0]]->[$dir];
}

sub pp {
  my ($m, $ex, $ey) = @_;
  for my $y (0 .. $m->{h} - 1) {
    for my $x (0 .. (scalar @{$m->{m}->[$y]}) - 1) {
      if (defined $ex && defined $ey && $x == $ex && $y == $ey) {
        print "?";
        next;
      }
      if ($x == $m->{pos}->[X] && $y == $m->{pos}->[Y]) {
        print pdir($m->{dir});
        next;
      }
      print $m->{m}->[$y]->[$x];
    }
    print "\n";
  }
  print "$m->{walk}\n" if (length($m->{walk}) < 80);
}

sub move {
  my ($in) = @_;
  my $nx = ($in->{pos}->[X] + $in->{dir}->[X]) % $in->{w};
  my $ny = ($in->{pos}->[Y] + $in->{dir}->[Y]) % $in->{h};
  while ($in->{m}->[$ny]->[$nx] eq ' ') {
    $nx = ($nx + $in->{dir}->[X]) % $in->{w};
    $ny = ($ny + $in->{dir}->[Y]) % $in->{h};
  }
  if ($in->{m}->[$ny]->[$nx] eq '.') {
    $in->{pos}->[X] = $nx;
    $in->{pos}->[Y] = $ny;
    return;
  }
  return 1;
}

sub solve {
  my ($in, $fn) = @_;
  while ($in->{walk} ne "") {
    if ($in->{walk} =~ s/^(\d+)//) {
      my $n = $1;
      for (0 .. $n - 1) {
        my $blocked = $fn->($in);
        if ($ENV{A}) {
          pp($in);
          select undef, undef, undef, 0.5;
        }
        last if ($blocked);
      }
    } else {
      my $turn = substr $in->{walk}, 0, 1, '';
      my ($dx, $dy) = @{$in->{dir}};
      if ($turn eq "R") {
        $in->{dir} = [-$dy, $dx];
      } elsif ($turn eq "L") {
        $in->{dir} = [$dy, -$dx];
      } else {
        $in->{pos} = [2, 4];
      }
      if ($ENV{A}) {
        pp($in);
        select undef, undef, undef, 0.5;
      }
    }
  }
  return 1000 * ($in->{pos}->[Y] + 1) + 4 * ($in->{pos}->[X] + 1) +
    facing($in->{dir});
}

sub calc {
  solve($_[0], \&move);
}

sub calc2 {
  solve($_[0], \&move2);
}

sub wrap {
  my ($in, $x, $y, $old, $new) = @_;
  if ($old == $new) {
    if ($old == UP) {
      return ($x, $in->{dim} - 1);
    } elsif ($old == DOWN) {
      return ($x, 0);
    } elsif ($old == LEFT) {
      return ($in->{dim} - 1, $y);
    } else {
      return (0, $y);
    }
  }
  if ($old == UP && $new == RIGHT) {
    return (0, $x);
  }
  if ($old == DOWN && $new == UP) {
    return ($in->{dim} - 1 - $x, $in->{dim} - 1);
  }
  if ($old == RIGHT && $new == DOWN) {
    return ($in->{dim} - 1 - $y, 0);
  }
  if ($old == DOWN && $new == LEFT) {
    return ($in->{dim} - 1, $x);
  }
  if ($old == LEFT && $new == DOWN) {
    return ($y, 0);
  }
  if ($old == LEFT && $new == RIGHT) {
    return (0, $in->{dim} - 1 - $y);
  }
  if ($old == RIGHT && $new == LEFT) {
    return ($in->{dim} - 1, $in->{dim} - 1 - $y);
  }
  if ($old == RIGHT && $new == UP) {
    return ($y, $in->{dim} - 1);
  }
  die;
}

sub move2 {
  my ($in) = @_;
  my ($cx, $cy, $f) = face($in, @{$in->{pos}});

  #print "move2 $cx,$cy $f\n";
  my $ncx = $cx + $in->{dir}->[X];
  my $ncy = $cy + $in->{dir}->[Y];
  my $ndir = $in->{dir};
  my $dir;
  if ($ncy < 0) {
    ($f, $dir) = @{$in->{nface}->[$f]->[UP]};

    #print "up $ncx,$ncy $in->{dim} @{$ndir} $dir $f\n";
    ($ncx, $ncy) = wrap($in, $ncx, $ncy, off2dir($ndir), $dir);

    #print "UP $ncx,$ncy $in->{dim} @{$ndir} $dir\n";
    $ndir = dir2off($dir);

    #print "$ncx,$ncy $dir => @{$ndir}\n";
  }
  if ($ncy == $in->{dim}) {
    ($f, $dir) = @{$in->{nface}->[$f]->[DOWN]};

    #print "down $ncx,$ncy $in->{dim} @{$ndir} $dir $f\n";
    ($ncx, $ncy) = wrap($in, $ncx, $ncy, off2dir($ndir), $dir);

    #print "DOWN $ncx,$ncy $in->{dim} @{$ndir} $dir\n";
    $ndir = dir2off($dir);

    #print "$ncx,$ncy $dir => @{$ndir}\n";
  }
  if ($ncx < 0) {
    ($f, $dir) = @{$in->{nface}->[$f]->[LEFT]};

    #print "left $ncx,$ncy $in->{dim} @{$ndir} $dir $f\n";
    ($ncx, $ncy) = wrap($in, $ncx, $ncy, off2dir($ndir), $dir);

    #print "LEFT $ncx,$ncy $in->{dim} @{$ndir} $dir\n";
    $ndir = dir2off($dir);

    #print "$ncx,$ncy $dir => @{$ndir}\n";
  }
  if ($ncx == $in->{dim}) {
    ($f, $dir) = @{$in->{nface}->[$f]->[RIGHT]};

    #print "right $ncx,$ncy $in->{dim} @{$ndir} $dir $f\n";
    ($ncx, $ncy) = wrap($in, $ncx, $ncy, off2dir($ndir), $dir);

    #print "RIGHT $ncx,$ncy $in->{dim} @{$ndir} $dir\n";
    $ndir = dir2off($dir);

    #print "$ncx,$ncy $f $dir => @{$ndir}\n";
  }
  my ($nx, $ny) = flat($in, $ncx, $ncy, $f);

  #print "$nx,$ny\n";
  if ($in->{m}->[$ny]->[$nx] eq '.') {
    $in->{pos}->[X] = $nx;
    $in->{pos}->[Y] = $ny;
    $in->{dir} = $ndir;
    return;
  }
  return 1;
}

sub face {
  my ($in, $x, $y) = @_;
  my $cx = int($x / $in->{dim});
  my $cy = int($y / $in->{dim});
  $x %= $in->{dim};
  $y %= $in->{dim};
  return $x, $y, $in->{rface}->{$cx, $cy};
}

sub flat {
  my ($in, $x, $y, $f) = @_;
  my ($cx, $cy) = @{$in->{face}->[$f]};
  return ($cx * $in->{dim} + $x, $cy * $in->{dim} + $y);
}

sub dir_idx {
  my ($d) = @_;
  if ($d->[Y] == -1) {
    return 0;
  }
  if ($d->[Y] == 1) {
    return 1;
  }
  if ($d->[X] == -1) {
    return 2;
  }
  if ($d->[X] == 1) {
    return 3;
  }
  die;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases = (["test1.txt", 6032], ["input.txt", 181128],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases = (["test1.txt", 5031], ["input.txt", 52311],);
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
