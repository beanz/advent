#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

use constant
  {
   Z => 2,
   R => 3,
   BB => 4,
   POS => 0,
   BC => 1,
  };
my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my $i = parse_input(\@i);
#dd([$i],[qw/i/]);

sub parse_input {
  my ($lines) = @_;
  my @s;
  my $max = 0;
  my $max_id;
  my @sum;
  for my $l (@$lines) {
    unless ($l =~ m!pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)!) {
      die "Invalid input: $l\n";
    }
    my $bot = [ $1, $2, $3, $4 ];
    my $bb = bb($bot);
    push @s, [ @$bot, $bb ];
    $sum[X] += $1;
    $sum[Y] += $2;
    $sum[Z] += $3;
    if ($max < $4) {
      $max_id = (scalar @s) - 1;
      $max = $4;
    }
  }
  my @bb = ([0,0,0], [0,0,0]);
  my @size;
  for my $d (X, Y, Z) {
    $bb[MIN]->[$d] = min(map { $_->[$d] } @s);
    $bb[MAX]->[$d] = max(map { $_->[$d] } @s);
    $size[$d] = $bb[MAX]->[$d] - $bb[MIN]->[$d];
    print "Min: ", $bb[MIN]->[$d], "\n" if DEBUG;
    print "Max: ", $bb[MAX]->[$d], "\n" if DEBUG;
  }
  return { bots => \@s, max => $max_id, size => \@size,
           avg => \@sum, bb => \@bb };
}

sub inRange {
  my ($bot, $p) = @_;
  return manhattanDistance3D($p, $bot) <= $bot->[R];
}

sub calc {
  my ($i) = @_;
  my $max = $i->{bots}->[$i->{max}];
  my $c;
  for my $bot (@{$i->{bots}}) {
    $c++ if (inRange($max, $bot));
  }
  return $c;
}

sub manhattanDistance3D {
  my ($p1, $p2) = @_;
  return
    abs($p1->[X]-$p2->[X]) + abs($p1->[Y]-$p2->[Y]) + abs($p1->[Z]-$p2->[Z]);
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
EOF
#dd([$test_input],[qw/test_input/]);

if (TEST) {
  my $res;
  $res = calc($test_input);
  assertEq("Test 1", $res, 7);
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub notInRange {
  my ($p, $bots) = @_;
  my @not;
  for my $bot (@$bots) {
    push @not, $bot unless (manhattanDistance3D($bot, $p) <= $bot->[R]);
  }
  return \@not;
}

sub neighbourOffsets3D {
  [
                   [ 0, -1, -1],
    [ -1,  0, -1], [ 0,  0, -1], [ 1,  0, -1],
                   [ 0,  1, -1],
                   [ 0, -1,  0],
    [ -1,  0,  0],               [ 1,  0,  0],
                   [ 0,  1,  0],
                   [ 0, -1,  1],
    [ -1,  0,  1], [ 0,  0,  1], [ 1,  0,  1],
                   [ 0,  1,  1],
  ];
}

sub avg {
  my ($bots) = @_;
  my @sum;
  for my $b (@$bots) {
    $sum[X] += $b->[X];
    $sum[Y] += $b->[Y];
    $sum[Z] += $b->[Z];
  }
  return [int($sum[X] / @$bots), int($sum[Y] / @$bots), int($sum[Z] / @$bots)];
}

sub mid {
  my ($b1, $b2) = @_;
  return [int(($b1->[X]+$b2->[X])/2),
          int(($b1->[Y]+$b2->[Y])/2),
          int(($b1->[Z]+$b2->[Z])/2)];
}

sub bb {
  my ($b) = @_;
  my @min;
  my @max;
  for my $d (X, Y, Z) {
    push @min, $b->[$d]-$b->[R];
    push @max, $b->[$d]+$b->[R];
  }
  return [\@min, \@max];
}

sub intersection {
  my ($b1, $b2) = @_;
  my @min;
  my @max;
  for my $d (X, Y, Z) {
    return unless ($b1->[MIN]->[$d] <= $b2->[MAX]->[$d] &&
                   $b1->[MAX]->[$d] >= $b2->[MIN]->[$d]);
    push @min, max($b1->[MIN]->[$d], $b2->[MIN]->[$d]);
    push @max, min($b1->[MAX]->[$d], $b2->[MAX]->[$d]);
  }
  return [\@min, \@max];
}

sub ppp {
  my ($p) = @_;
  sprintf "%d,%d,%d", $p->[X],$p->[Y],$p->[Z];
}

sub findPointInRange {
  my ($bot, $p) = @_;
#  printf "Walking from %s to %s r%d\n", ppp($p), ppp($bot), $bot->[R];
  my $in = dclone($bot);
  my $out = dclone($p);
  while (manhattanDistance3D($in,$out) > 3) {
    my $n = mid($in, $out);
    if (inRange($bot, $n)) {
      $in = $n;
    } else {
      $out = $n;
    }
  }
  return $in;
}

sub scale {
  my ($i, $scale) = @_;
  my @b;
  for my $bot (@{$i->{bots}}) {
    my @bot;
    for my $d (X, Y, Z, R) {
      push @bot, scale_value($bot->[$d], $scale);
    }
    push @b, \@bot;
  }
  my @bb = ([0,0,0], [0,0,0]);
  my @size;
  for my $d (X, Y, Z) {
    $bb[MIN]->[$d] = min(map { $_->[$d] } @b);
    $bb[MAX]->[$d] = max(map { $_->[$d] } @b);
    print "Min: ", $bb[MIN]->[$d], "\n" if DEBUG;
    print "Max: ", $bb[MAX]->[$d], "\n" if DEBUG;
    $size[$d] = $bb[MAX]->[$d] - $bb[MIN]->[$d];
  }
  return { bots => \@b, bb => \@bb, size => \@size };
}

sub scale_value {
  my ($n, $scale) = @_;
  return round($n/$scale);
}

sub best {
  my ($i, $bb) = @_;
  my $min = @{$i->{bots}}-1;
  my @best;
  for my $z ($bb->[MIN]->[Z] ..$bb->[MAX]->[Z]) {
    for my $y ($bb->[MIN]->[Y] ..$bb->[MAX]->[Y]) {
      for my $x ($bb->[MIN]->[X] ..$bb->[MAX]->[X]) {
        my $cur = [$x, $y, $z];
        printf STDERR "Checking %s\r", ppp($cur) if DEBUG;
        my $not = notInRange($cur, $i->{bots});
        if (@$not == $min) {
          #printf STDERR "New equal best, %s, missing %d\n", ppp($cur), ~~@$not;
          push @best, [$x, $y, $z, $min];
        } elsif (@$not < $min) {
          $min = @$not;
          printf STDERR "New best, %s, missing %d\n", ppp($cur), ~~@$not
            if DEBUG;
          @best = ([$x, $y, $z, $min]);
        }
      }
    }
  }
  print STDERR "\n" if DEBUG;
  return \@best;
}

sub calc4 {
  my ($i) = @_;
  my $scale = 1;
  while ($i->{size}->[X] / $scale > 32 ||
         $i->{size}->[Y] / $scale > 32 ||
         $i->{size}->[Z] / $scale > 32) {
    $scale *= 2;
  }
  print STDERR "Scale: $scale\n" if DEBUG;
  my $scaled = scale($i, $scale);
  my $bb = dclone($scaled->{bb});
  #dd([$bb],[qw/bb/]);
  my $best;
  while (1) {
    $best = best($scaled, $bb);
    if ($scale == 1) {
      last;
    }
    $scale /= 2;
    $scaled = scale($i, $scale);
    for my $d (X, Y, Z) {
      my $min = $bb->[MIN]->[$d] = min(map { $_->[$d] } @$best)*2 - 2;
      my $max = $bb->[MAX]->[$d] = max(map { $_->[$d] } @$best)*2 + 2;
      printf "%s < %s < %s\n", $min, (['x', 'y', 'z']->[$d]), $max if DEBUG;
    }
  }
  my @best_dist = sort { $a->[1] <=> $b->[1]
                       } map { [$_, manhattanDistance3D([0,0,0],$_)]
                             } @$best;
  #dd([\@best_dist],[qw/bd/]);
  return $best_dist[0]->[1];
}

sub calc3 {
  my ($i) = @_;
  my $bb;
  my $z = 12;
  for my $n (@{$i->{bots}}) {
    if (!defined $bb) {
      $bb = $n->[BB];
    } else {
      $bb = intersection($bb, $n->[BB]);
    }
    #dd([$bb],[qw/bb/]);
  }
  my @todo = mid($bb->[0], $bb->[1]);
  @todo = [17598739,57902209,20697851];
  @todo = [19171545,57165064,21541586];
  @todo = [19966443,57759679,21341303];
  my $vc = visit_checker();
  my $max = 0;
  my $max_pos = [0,0,0];
  my $num = scalar @{$i->{bots}};
  while (@todo) {
    my $cur = shift @todo;
    next if $vc->(@$cur); # visited via shorter path
    printf STDERR "%10d\r", ~~@todo if DEBUG;
    my $not = notInRange($cur, $i->{bots});
    #printf "Testing at %s missing %d\n", ppp($cur), scalar @$not;
    my $count = $num - scalar @$not;
#    print "  Not: ", (join ' ', map { join ',', @$_ } @$not), "\n";
    if ($count > $max) {
      my $md = manhattanDistance3D($cur, [0,0,0]);
      printf "\nFound new max %d at %s (%d)\n", $count, ppp($cur), $md
        if DEBUG;
      $max = $count;
      $max_pos = $cur;
      last if ($count == @{$i->{bots}});
    }
    for my $n (@$not) {
      #printf "N: %d,%d,%d\n", $n->[X],$n->[Y],$n->[Z];
      my $np = findPointInRange($n, $cur);
      if (defined $np) {
        #printf "NP: %d,%d,%d\n", $np->[X],$np->[Y],$np->[Z];
        push @todo, $np;
      }
    }
  }
  return manhattanDistance3D($max_pos, [0,0,0]);
}


use List::MoreUtils qw/natatime/;
use List::Util qw/shuffle/;
sub calc2 {
  my ($i) = @_;
  my @todo = $i->{avg};
  @todo = [14831631,55699052,16536710];
  @todo = [14500792,56329583,17920968];
  @todo = [15874210,56610107,17942041];
  @todo = [16497856,56760482,19420517];
  @todo = [18585717,56949468,21758931];
  @todo = [18341812,57501048,20932343];
  @todo = [18341812,57501048,20932343]; # 96775203
  @todo = [19992232,58718915,22274751]; # 100985898 967
  my $not = notInRange($todo[0], $i->{bots});
  my $bb;
  for my $n (@{$i->{bots}}) {
    unless (defined $bb) {
      $bb = $n->[BB];
      next;
    }
    $bb = intersection($bb, $n->[BB]);
  }
  dd([$bb],[qw/bb/]);
  #printf "no intersection %d,%d,%d\n", $n->[X], $n->[Y], $n->[Z];
  push @todo, $bb->[0];
  push @todo, $bb->[1];
  push @todo, mid($bb->[0], $bb->[1]);
  # for my $n (@$not) {
  #   print "N $n->[X],$n->[Y],$n->[Z] $n->[R]\n";
  #   push @todo, mid($n, $todo[$#todo]);
  # }
  # for my $n (@$not) {
  #   for my $m (@$not) {
  #     my $mid = mid($n, $m);
  #     push @todo, $mid;
  #     push @todo, mid($mid, $todo[$#todo]);
  #   }
  # }
  my $vc = visit_checker();
  my $max = 0;
  my $max_pos = [0,0,0];
  my $num = scalar @{$i->{bots}};
  while (@todo) {
    my $cur = shift @todo;
    #    printf "Testing at %d,%d,%d\n", @$cur;
    printf "%10d\r", ~~@todo if DEBUG;
    next if $vc->(@$cur); # visited via shorter path
    my $not = notInRange($cur, $i->{bots});
    my $count = $num - scalar @$not;
#    print "  Not: ", (join ' ', map { join ',', @$_ } @$not), "\n";
    if ($count > $max) {
      my $md = manhattanDistance3D($cur, [0,0,0]);
      printf "\nFound new max %d at %d,%d,%d (%d)\n", $count, @$cur, $md
         if DEBUG;
      $max = $count;
      $max_pos = $cur;
      last if ($count == @{$i->{bots}});
    }
    push @todo, mid(avg($not), $cur);
     my @mix = shuffle @$not;
     my $it = natatime(int(@mix/8));
     while (my @l = $it->()) {
       push @todo, mid(avg(\@l), $cur);
       push @todo, avg(\@l);
     }
    #for my $n (@$not) {
      #push @todo, [$n->[X], $n->[Y], $n->[Z]];
      #push @todo, mid($n, $cur);
    #}
  }
  return manhattanDistance3D($max_pos, [0,0,0]);
}

if (TEST) {
  $test_input = parse_input([split/\n/, <<'EOF']);
pos=<10,12,12>, r=2
pos=<12,14,12>, r=2
pos=<16,12,12>, r=4
pos=<14,14,14>, r=6
pos=<50,50,50>, r=200
pos=<10,10,10>, r=5
EOF
  my $res;
  $res = calc2($test_input);
  assertEq("Test 2", $res, 36);
}
$i = parse_input(\@i); # reset input
print "Part 2: ", calc4($i), "\n";
