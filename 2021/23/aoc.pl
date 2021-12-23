#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
use POE::XS::Queue::Array;
$; = $" = ',';

use constant
  {
   CH => 2,
   ENERGY => 3,
  };

my %ME =
  (
   A => 1,
   B => 10,
   C => 100,
   D => 1000,
  );

my %ROOMS = ( 3 => 'A', 5 => 'B', 7 => 'C', 9 => 'D' );
my %CHROOMS = reverse %ROOMS;

my $file = shift // "input.txt";
my $lines = read_lines($file);
my $i = read_lines($file);
my $i2 = read_lines($file);

sub at {
  my ($m, $p, $x, $y) = @_;
  my $ch = $p->{$x,$y};
  defined $ch ? $ch->[CH] : $m->{$x,$y} // "";
}

sub pp {
  my ($in, $p) = @_;
  $p //= $in->{p};
  for my $y (0..$in->{h}-1) {
    for my $x (0..$in->{w}-1) {
      print at($in->{m}, $p, $x, $y);
    }
    print "\n";
  }
}

sub occupied {
  my ($m, $s, $x, $y) = @_;
  $s->{$x,$y} ? $s->{$x, $y}->[CH] : $m->{$x,$y} ne '.'
}


sub read_stuff {
  my ($in) = @_;
  my %m;
  my %p;
  for my $y (0..(@$in-1)) {
    my @l = split//,$in->[$y];
    for my $x (0..(@l-1)) {
      my $c = $l[$x];
      if ($c eq 'A' || $c eq 'B' || $c eq 'C' || $c eq 'D') {
        $p{$x,$y} = [$x, $y, $c, 0];
        $c = '.';
      }
      $m{$x,$y} = $c;
    }
  }
  return { m => \%m, p => \%p, h => ~~@$in, w => length($in->[0]) };
}

sub is_home {
  my ($in, $s, $p) = @_;
  my ($x, $y) = ($p->[X], $p->[Y]);
  #print "M: $x, $y $p->[CH]\n";
  my $ch = $p->[CH];
  my $hx = $CHROOMS{$ch};
  return 0 if ($hx != $x);
  for my $hy (reverse ($y+1)..$in->{h}-2) {
    my $och = occupied($in->{m}, $s, $hx, $hy);
    if (!$och || $ch ne $och) {
      return 0;
    }
  }
  return 1;
}

sub home {
  my ($in, $s, $p) = @_;
  my $ch = $p->[CH];
  my $hx = $CHROOMS{$ch};
  for my $y (reverse (2..$in->{h}-2)) {
    my $och = occupied($in->{m}, $s, $hx, $y);
    if (!$och) {
      return [$hx, $y];
    } elsif ($och ne $ch) {
        return 0;
      }
  }
  return 0;
}

# print @{home($i, {
#                 '3,3' => [0,0,'B'],'1,1' => [0,0,'A'],
#                 '5,3' => [0,0,'B'],'5,2' => [0,0,'B'],
#                 '7,3' => [0,0,'C'],'7,2' => [0,0,'C'],
#                 '9,3' => [0,0,'D'],'9,2' => [0,0,'D'],
#                }, [1,1,'A'])}, "\n";
# exit;

sub left {
  my ($x) = @_;
  my @r;
  for (reverse 1, 2, 4, 6, 8, 10, 11) {
    push @r, $_ if ($_ < $x);
  }
  return \@r;
}

sub right {
  my ($x) = @_;
  my @r;
  for (1, 2, 4, 6, 8, 10, 11) {
    push @r, $_ if ($_ > $x);
  }
  return \@r;
}

sub path {
  my ($p, $nx, $ny) = @_;
  my $ch = $p->[CH];
  my $x = $p->[X];
  my $y = $p->[Y];
  my @r;
  #print "$x,$y => $nx, $ny\n";
  while ($x != $nx || $y != $ny) {
    if ($nx == $x) {
      $y++;
    } elsif ($y != 1) {
      $y--;
    } elsif ($x > $nx) {
      $x--;
    } elsif ($x < $nx) {
      $x++;
    }
    push @r, [$x, $y];
    #print "  $x,$y\n";
  }
  return \@r;
}

sub clear_path {
  my ($in, $s, $path) = @_;
  for my $xy (@$path) {
    #print "CL: @{$xy} ", (occupied($in->{m}, $s, $xy->[X], $xy->[Y]) ? 'X' :'.'), "\n";
    return 0 if (occupied($in->{m}, $s, $xy->[X], $xy->[Y]))
  }
  return 1;
}

sub moves {
  my ($in, $s, $p) = @_;
  my $m = $in->{m};
  my ($x, $y) = ($p->[X], $p->[Y]);
  #print "M: $x, $y $p->[CH]\n";
  my $ch = $p->[CH];
  my $move_en = $ME{$ch};
  my $room = $ROOMS{$x};
  if (is_home($in, $s, $p)) {
    return [];
  }
  my $home = home($in, $s, $p);
  if ($home) {
    my ($nx, $ny) = @$home;
    # if we can go home then do that
    my $path = path($p, $nx, $ny);
    if (clear_path($in, $s, $path)) {
      return [[$nx, $ny, $ch, $move_en*@{$path}]];
    }
  } elsif ($y == 1) {
    # we can move from row 1 if we can't go home
    return [];
  }
  my @p;
  for my $nx (@{left($x)}) {
    my $path = path($p, $nx, 1);
    if (clear_path($in, $s, $path)) {
      push @p, [$nx, 1, $ch, $move_en*@{$path}];
    } else {
      last; # if this path wasn't clear longer one wont be either
    }
  }
  for my $nx (@{right($x)}) {
    my $path = path($p, $nx, 1);
    if (clear_path($in, $s, $path)) {
      push @p, [$nx, 1, $ch, $move_en*@{$path}];
    } else {
      last; # if this path wasn't clear longer one wont be either
    }
  }
  return \@p;
}

sub not_home {
  my ($in, $p) = @_;
  my $needed = 4*($in->{h}-3);
  for my $x (sort keys %ROOMS) {
    my $ch = $ROOMS{$x};
    for my $y (reverse (2..$in->{h}-2)) {
      #print "$x,$y: ", ($p->{$x,$y} ? $p->{$x,$y}->[CH] : '.'), "\n";
      unless ($p->{$x,$y} && $p->{$x,$y}->[CH] eq $ch) {
        last;
      }
      $needed--;
    }
  }
  #print $needed, "\n";
  $needed
}


sub done {
  my ($i, $p) = @_;
  not_home($i, $p) == 0 ? 1 : 0;
}

sub vk {
  join "!", sort map {
    $_[0]->{$_}->[X].','.$_[0]->{$_}->[Y].','.$_[0]->{$_}->[CH]
  } keys %{$_[0]}
}

sub calc {
  my ($lines) = @_;
  my $in = read_stuff($lines);
  my $search = POE::XS::Queue::Array->new();
  $search->enqueue(0, { %{$in->{p}} });
  my %visited;
  while (1) {
    print "Q: ", $search->get_item_count(), "\r" if DEBUG;
    my $halt = $search->get_item_count() == 0;
    my ($energy, $queue_id, $cur) = $search->dequeue_next();
    if ($halt) {
      dd([$cur],[qw/cur/]);
      die "search failed\n";
    }
    if (DEBUG > 2) {
      pp($in, $cur);
      select undef,undef,undef, 0.5;
    }
    if (done($in, $cur)) {
      print "\n" if DEBUG;
      return $energy;
    }
    my $vk = vk($cur);
    next if (exists $visited{$vk});
    $visited{$vk}++;
    for my $xy (keys %$cur) {
      my $p = $cur->{$xy};
      my $moves = moves($in, $cur, $p);
      next unless (@$moves);
      print "moves for @{$p}: ", (scalar @$moves), "\n" if (DEBUG > 1);
      for my $m (@$moves) {
        print "  move to @{$m}\n" if (DEBUG > 1);
        my $n = {%$cur};
        delete $n->{$xy};
        $n->{$m->[X],$m->[Y]} = $m;
        $search->enqueue($energy + $m->[ENERGY], $n);
      }
    }
  }
}

sub calc2 {
  my ($in) = @_;
  splice @$in, 3, 0, '  #D#C#B#A#', '  #D#B#A#C#';
  return calc($in);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test0.txt", 8010 ],
     [ "test1.txt", 12521 ],
     [ "input.txt", 18282 ],
    );
  for my $tc (@test_cases) {
    my $lines = read_lines($tc->[0]);
    my $res = calc($lines);
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test0.txt", 32016 ],
     [ "test1.txt", 44169 ],
     [ "test2.txt", 42824 ],
     [ "input.txt", 50132 ],
    );
  for my $tc (@test_cases) {
    my $lines = read_lines($tc->[0]);
    my $i = read_stuff($lines);
    my $res = calc2($i);
    assertEq("Test 2 [$tc->[0] x $tc->[1]]", $res, $tc->[2]);
  }
}
