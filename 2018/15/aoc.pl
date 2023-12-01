#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use constant {
  P => 2,
};

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

sub k {
  sprintf '%03d:%03d', reverse @_;
}

sub pp {
  my ($s, $hx, $hy, $m) = @_;
  my $r = '';
  state $bold = `tput smso`;
  state $off = `tput rmso`;
  if (defined $m) {
    $r .= $m;
    if (defined $hx) {
      $r .= " $hx,$hy";
    }
    $r .= "\n";
  }
  my %c = ( G => 0, E => 0, GHP => 0, EHP => 0 );
  for my $y (0..$s->{h}-1) {
    my @hp;
    for my $x (0..$s->{w}-1) {
      my $k = k($x, $y);
      my $sq;
      if (exists $s->{p}->{$k}) {
        $sq = $s->{p}->{$k}->{type};
        push @hp, $s->{p}->{$k}->{hp};
        $c{$sq}++;
        $c{$sq.'HP'} += $s->{p}->{$k}->{hp};
      } else {
        $sq = $s->{m}->{$k};
      }
      if (defined $hx && $x == $hx && defined $hy && $y == $hy) {
        $r .= $bold.$sq.$off;
      } else {
        $r .= $sq;
      }
    }
    $r .= ' '.$y;
    $r .= " @hp";
    $r .= "\n";
  }
  $r .= ($s->{round}//0)." E=".$c{E}."/".$c{EHP}." G=".$c{G}."/".$c{GHP}."\n";
  $r
}

sub enemy {
  my ($p) = @_;
  if ($p->{type} eq 'G') {
    return 'E';
  } else {
    return 'G';
  }
}

sub best_target {
  my ($s, $p, $x, $y) = @_;
  my $best;
  for my $o ([0,-1], [-1,0], [1,0], [0,1]) {
    my $enemy = enemy($p);
    my $k = k($x+$o->[X], $y+$o->[Y]);
    next unless (exists $s->{p}->{$k} && $s->{p}->{$k}->{type} eq $enemy);
    if (!defined $best || $best->[2]->{hp} > $s->{p}->{$k}->{hp}) {
      $best = [$x+$o->[X], $y+$o->[Y], $s->{p}->{$k}];
    }
  }
  return $best;
}

sub attack {
  my ($s, $p, $target, $x, $y) = @_;
  printf STDERR "%s at %d,%d attacks %d,%d\n",
    $p->{type}, $x, $y, $target->[X], $target->[Y] if DEBUG;
  $target->[P]->{hp} -= $p->{pwr};
  if ($target->[P]->{hp} <= 0) {
    print STDERR "player died\n" if DEBUG;
    $s->{alive}->{$target->[P]->{type}}--;
    delete $s->{p}->{k($target->[X], $target->[Y])};
  }
}

sub occupied {
  my ($s, $k) = @_;
  if ($s->{m}->{$k} eq '#') {
    return '#';
  } elsif (exists $s->{p}->{$k}) {
    return $s->{p}->{$k}->{type};
  } else {
    return;
  }
}

sub empty_adjacent {
  my ($s, $x, $y) = @_;
  my @r;
  for my $n (map { [ $x+$_->[X], $y+$_->[Y] ] } [0,-1], [-1,0], [1,0], [0,1]) {
    push @r, $n unless (occupied($s, k(@$n)));
  }
  return \@r;
}

sub move_player {
  my ($s, $p, $x, $y) = @_;
  my @p = map { [ $_ ] } @{empty_adjacent($s, $x, $y)};
  my %v;
  my %f;
  while (@p) {
    my @n;
    while (@p) {
      my $path = shift @p;
      my $pos = $path->[-1];
      my $pos_key = k(@$pos);
      next if ($v{$pos_key});
      $v{$pos_key}++;
      my $best = best_target($s, $p, @$pos);
      if (defined $best) {
        print STDERR pp($s, $pos->[X], $pos->[Y],
                        'close candidate? '.(scalar @$path)) if DEBUG;
        $f{$pos_key} = $path;
        next;
      }
      push @n,
        map { [ @$path, $_ ] } @{empty_adjacent($s, $pos->[X], $pos->[Y])};
    }
    @p = @n;
    if (keys %f) {
      last;
    }
  }
  if (keys %f) {
    my $path = $f{(sort keys %f)[0]};
    print STDERR pp($s, $path->[-1]->[X], $path->[-1]->[Y],
                    'closest candidate') if DEBUG;
    return shift @$path;
  }

  print STDERR "No move\n" if DEBUG;
  return;
}

sub move {
  my ($s, $p, $x, $y) = @_;
  my $target = best_target($s, $p, $x, $y);
  if ($target) {
    attack($s, $p, $target, $x, $y);
    return;
  }
  my $np = move_player($s, $p, $x, $y);
  return unless (defined $np);
  $s->{p}->{k(@$np)} = delete $s->{p}->{k($x,$y)};
  ($x, $y) = @$np;
  print STDERR pp($s, $x, $y, 'moved') if DEBUG;
  $target = best_target($s, $p, $x, $y);
  if ($target) {
    attack($s, $p, $target, $x, $y);
  }
  return;
}

sub read_grid {
  my ($i, $elf_attack) = @_;
  my %m;
  my %p;
  my %s = ( h => scalar@$i, w => length($i->[0]) );
  for my $y (0..$s{h}-1) {
    for my $x (0..$s{w}-1) {
      my $c = substr $i->[$y], $x, 1;
      if ($c eq '#' || $c eq '.') {
        $m{k($x,$y)} = $c;
      } elsif ($c eq 'E' || $c eq 'G') {
        $s{alive}->{$c}++;
        $m{k($x,$y)} = '.';
        $p{k($x,$y)} = { type => $c, hp => 200, pwr => 3 };
        if (defined $elf_attack && $c eq 'E') {
          $p{k($x,$y)}->{pwr} = $elf_attack;
        }
      }
    }
  }
  $s{m} = \%m; $s{p} = \%p;
  return \%s;
}

sub calc {
  my ($i, $elf_attack) = @_;
  my $s = read_grid($i, $elf_attack);
  print STDERR pp($s) if DEBUG;
  my $round = 1;
  my $all_elves = $s->{alive}->{E};
  while (1) {
    $s->{round} = $round;
    my @pk = sort keys %{$s->{p}};
    for my $k (@pk) {
      unless (exists $s->{p}->{$k}) {
        # dead
        print STDERR "Dead $k\n" if DEBUG;
        next;
      }
      if (defined $elf_attack) {
        if ($s->{alive}->{E} != $all_elves) {
          return undef;
        }
      }
      if ($s->{alive}->{E} == 0 || $s->{alive}->{G} == 0) {
        # end
        my $hp = sum(map { $s->{p}->{$_}->{hp} } keys %{$s->{p}});
        print pp($s, undef, undef, "End: HP=$hp Round=$round\n") if DEBUG;
        return $hp*($round-1);
      }
      my ($x, $y) = map { 0+$_ } reverse split /:/, $k;
      print STDERR "Moving $k\n" if DEBUG;
      move($s, $s->{p}->{$k}, $x, $y);
    }
    print STDERR pp($s, undef, undef, 'end of round '.$round) if DEBUG;
    $round++;
  }
  return;
}

my @tests;
my @test_input;

@test_input = split/\n/, <<'EOF';
#####
#GEG#
#####
EOF
chomp @test_input;
push @tests, [[@test_input], 9933, 920, 10];

@test_input = split/\n/, <<'EOF';
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
EOF
chomp @test_input;
push @tests, [[@test_input], 27730, 4988, 15];

@test_input = split/\n/, <<'EOF';
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
EOF
chomp @test_input;
push @tests, [[@test_input], 36334, 29064, 4];

@test_input = split/\n/, <<'EOF';
#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######
EOF
chomp @test_input;
push @tests, [[@test_input], 39514, 31284, 4];

@test_input = split/\n/, <<'EOF';
#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######
EOF
chomp @test_input;
push @tests, [[@test_input], 27755, 3478, 15];

@test_input = split/\n/, <<'EOF';
#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######
EOF
chomp @test_input;
push @tests, [[@test_input], 28944, 6474, 12];

@test_input = split/\n/, <<'EOF';
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
EOF
chomp @test_input;
push @tests, [[@test_input], 18740, 1140, 34];

if (TEST) {

  my @move_tests;

  push @move_tests, [<<'EOF', 4, 1, 3, 1];
#######
#E..G.#
#...#.#
#.G.#G#
#######
EOF

  push @move_tests, [<<'EOF', 2, 1, 3, 1];
#######
#.E...#
#.....#
#...G.#
#######
EOF

  push @move_tests, [<<'EOF', 2, 1, 1, 1];
#######
#.G...#
#....E#
#E....#
#######
EOF

  push @move_tests, [<<'EOF', 4, 5, 5, 5];
#########
#......G#
#..#.##.#
#..G....#
#.#####.#
#...E...#
#########
EOF

  push @move_tests, [<<'EOF', 5, 2, 4, 2];
###########
#.G.#....G#
###..E#####
###########
EOF

  for my $test (@move_tests) {
    my ($i, $x, $y, $nx, $ny) = @$test;
    my $g = read_grid([split/\n/, $i]);
    my $np = move_player($g, $g->{p}->{k($x, $y)}, $x, $y);
    print "Move test: @$np == $nx $ny";
    die "failed\n" unless ($np->[X] == $nx && $np->[Y] == $ny);
  }

  for my $test (@tests) {
    my $res = calc($test->[0]);
    print "Test 1: ", $res, " == ",$test->[1],"\n";
    die "failed\n" unless ($res == $test->[1]);
  }
}

my $res = calc(\@i);
print "Part 1: $res\n";
die "failed\n" unless ($res == 220480);

sub calc2 {
  my ($i) = @_;
  my $elf_attack = 3;
  my $res;
  do {
    $elf_attack++;
    $res = calc($i, $elf_attack);
  } while (!defined $res);
  return [$res, $elf_attack];
}

if (TEST) {
  for my $test (@tests) {
    my $res = calc2($test->[0]);
    print "Test 2: ", $res->[0], " == ",$test->[2],"\n";
    print "        ", $res->[1], " == ",$test->[3],"\n";
    die "failed\n"
      unless ($res->[0] == $test->[2] && $res->[1] == $test->[3]);
  }
}
$res = calc2(\@i);
print "Part 2: $res->[0]\n";
die "failed\n" unless ($res->[0] == 53576 && $res->[1] == 20);
