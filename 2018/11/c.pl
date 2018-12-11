#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use constant { X => 0, Y => 1 };

my $serial = <>;
chomp $serial;
my $size = <>;
my ($size_min, $size_max) = split /\s+/, $size;
my $grid_min = <>;
$grid_min = [ split /\s+/, $grid_min ];
my $grid_max = <>;
$grid_max = [ split /\s+/, $grid_max ];

my $max;
my $max_id;
my %p;
for my $y ($grid_min->[Y]..$grid_max->[Y]+$size_min) {
  for my $x ($grid_min->[X]..$grid_max->[X]+$size_min) {
    $p{$x}->{$y} = level($x, $y, $serial);
    #printf STDERR "%3d ", $p{$x}->{$y};
  }
  #print STDERR "\n";
}

#printf STDERR "%d <= y <= %d\n", $grid_min->[Y], $grid_max->[Y]-$size_min+1;
#printf STDERR "%d <= x <= %d\n", $grid_min->[X], $grid_max->[X]-$size_min+1;
for my $size ($size_min..$size_max) {
  for my $y ($grid_min->[Y] .. $grid_max->[Y]-$size+1) {

    #print STDERR "$y\r";
    for my $x ($grid_min->[X] .. $grid_max->[X]-$size+1) {
      printf STDERR "%3d, %3d %3d\r", $x, $y, $size;
      last if ($x + $size-1 > $grid_max->[X] || $y + $size-1 > $grid_max->[Y]);
      my $l = level_square($x, $y, $size);
      if (!defined $max || $max < $l) {
        $max = $l;
        $max_id = "$x,$y,$size";
        #print STDERR "\n! $max $max_id\n"
      }
    }
  }
}
print STDERR "\n";
print "$max_id $max\n";

my %hit;
#use Data::Dumper; print STDERR Data::Dumper->Dump([\%hit], [qw/hit/]);
sub key {
  join ':', @_
}


no warnings 'recursion'; # global but here as this is where it matters
sub level_square {
  my ($x, $y, $size) = @_;
  my $k = key($x, $y, $size);
  $hit{total}++;
  state %s;
  if (exists $s{$k}) {
    $hit{hit}++;
    return $s{$k};
  }
  #pp_cache(\%s, $x, $y, $size);
  my $l = 0;
  if (exists $s{key($x, $y, $size-1)}) {
    $hit{smaller_hit}++;
    #print STDERR "smaller: $x, $y, $size\n";
    #pp_square($x, $y, $size, \@p, $x, $y, $size-1);
    # right edge
    $l = level_line_y($x + $size - 1, $y, $size);
    $l += level_line_x($x, $y + $size -1, $size - 1) if ($size > 1);
    $l += $s{key($x, $y, $size-1)};
  } else {
    #print STDERR "miss: $x, $y, $size\n";
    #pp_square($x, $y, $size, \@p, $x+1, $y+1, $size-1);
    $l += level_line_x($x + 1, $y, $size - 1) if ($size > 1);
    $l += level_line_y($x, $y, $size);
    $l += level_square($x+1, $y+1, $size - 1) if ($size > 1);
  }
  $s{$k} = $l;
  return $l;
}

sub level_line_x {
  my ($x, $y, $len) = @_;
  my $k = key($x, $y, $len);
#  print STDERR "LLX: $k\n";
  $hit{line_x_total}++;
  state %s;
  if (exists $s{$k}) {
#    print STDERR "LLX: $k!\n";
    $hit{line_x_hit}++;
    return $s{$k};
  }
  my $l;
  if (exists $s{key($x+1, $y, $len-1)}) {
#    print STDERR "LLX: $k>\n";
    $hit{line_x_right_hit}++;
    $l = $p{$x}->{$y} + $s{key($x+1, $y, $len-1)};
  } else {
    $l = $p{$x}->{$y};
    $l += level_line_x($x + 1, $y, $len-1) if ($len > 1);
  }
  $s{$k} = $l;
#  print STDERR "LLX: $k = $l\n";
  return $l;
}

sub level_line_y {
  my ($x, $y, $len) = @_;
  my $k = key($x, $y, $len);
  #print STDERR "LLY: $k\n";
  $hit{line_y_total}++;
  state %s;
  if (exists $s{$k}) {
    #print STDERR "LLY: $k!\n";
    $hit{line_y_hit}++;
    return $s{$k};
  }
  my $l;
  if (exists $s{key($x, $y+1, $len-1)}) {
    #print STDERR "LLY: ${k}v\n";
    $hit{line_y_bottom_hit}++;
    $l = $p{$x}->{$y} + $s{key($x, $y+1, $len-1)};
  } else {
    $l = $p{$x}->{$y};
    $l += level_line_y($x, $y + 1, $len-1) if ($len > 1);
  }
  $s{$k} = $l;
  #print STDERR "LLY: $k = $l\n";
  return $l;
}

sub pp_cache {
  my ($s, $x, $y, $size) = @_;
  print STDERR "$x $y $size\n";
  for my $i (0..3) {
    for my $j (0..3) {
      my $n = '.';
      for my $cs (reverse 1..$size) {
        if (exists $s->{key($x + $j, $y + $i, $cs)}) {
          $n = sprintf "%x", $cs;
          last;
        }
      }
      print STDERR $n;
    }
    print STDERR "\n";
  }
}

sub pp_square {
  my ($x, $y, $size, $p, $rx, $ry, $rsize) = @_;
  print STDERR "L: ", scalar @$p, " ", (join ' ', map { $_->[0].','.$_->[1] } @$p), "\n";
  my %v = map { $_->[0].','.$_->[1] => 'X' } @$p;
  for my $i ($ry .. $ry + $rsize -1) {
    for my $j ($rx .. $rx + $rsize -1) {
      $v{$j.','.$i} = 'O';
    }
  }
  for my $i ($y .. $y+$size) {
    for my $j ($x .. $x+$size) {
      print STDERR ($v{$j.','.$i} // '.');
    }
    print STDERR "\n";
  }
}

sub level {
  my ($x, $y, $serial) = @_;
  my $r = $x + 10;
  my $p = $r * $y;
  $p += $serial;
  $p *= $r;
  my ($h) = ($p =~ /(.)..$/);
  return $h - 5;
}
