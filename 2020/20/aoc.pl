#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
$; = $" = ',';

my $file = shift // "input.txt";
my $monster_file = $file;
$monster_file =~ s![^/]*\.txt!monster.txt!;

my $i = read_tiles($file);
my $i2 = read_tiles($file);

sub read_tiles {
  my $file = shift;
  my %t;
  my %e;
  for my $ch (@{read_chunks($file)}) {
    #print $ch,"\n";
    my @lines = split /\n/, $ch;
    my $first = shift @lines;
    #print $first,"\n";
    my ($n) = ($first =~ /Tile (\d+):/) or die "Invalid tile: $ch\n";
    my $t = $t{$n} = Tile->new($n, \@lines);
    for my $edge (qw/top bottom left right/) {
      $e{canon($t->$edge)}->{$n} = 1;
    }
  }
  my %k;
  for my $t (values %t) {
    my $c = 0;
    for my $edge (qw/top bottom left right/) {
      $c++ if (keys %{$e{canon($t->$edge)}} > 1);
    }
    if ($c == 4) {
      push @{$k{middle}}, $t->num;
    } elsif ($c == 3) {
      push @{$k{edge}}, $t->num;
    } elsif ($c == 2) {
      push @{$k{corner}}, $t->num;
    } else {
      print STDERR "Discarding $t->num as it can't fit\n";
      delete $t{$t->num};
      for my $edge (qw/top bottom left right/) {
        delete $e{canon($t->$edge)}->{$t->num}
      }
    }
  }
  return [\%t, \%e, \%k];
}

{
  package Tile;
  use constant
    {
     NUM => 0, LINES => 1, ORIENT => 2
    };
  sub new {
    my ($pkg, $num, $lines) = @_;
    bless [$num, $lines, ''], $pkg;
  }
  sub num {
    $_[0]->[NUM];
  }
  sub lines {
    $_[0]->[LINES];
  }
  sub iline {
    #$_[0]->[LINES]->[$_[1]];
    substr $_[0]->[LINES]->[$_[1]], 1, -1;
  }
  sub top {
    $_[0]->[LINES]->[0];
  }
  sub bottom {
    $_[0]->[LINES]->[@{$_[0]->[LINES]}-1];
  }
  sub left {
    join '', map { substr $_, 0, 1 } @{$_[0]->[LINES]};
  }
  sub right {
    join '', map { substr $_, -1, 1 } @{$_[0]->[LINES]};
  }
  sub all {
    my ($self) = @_;
    my $r1 = $self->rotate();
    my $r2 = $r1->rotate();
    my $r3 = $r2->rotate();
    my $flip = $self->flip;
    my $fr1 = $flip->rotate();
    my $fr2 = $fr1->rotate();
    my $fr3 = $fr2->rotate();
    [$self, $r1, $r2, $r3, $flip, $fr1, $fr2, $fr3];
  }
  sub flip {
    bless
      [$_[0]->[NUM], [(reverse @{$_[0]->[LINES]})], $_[0]->[ORIENT].'f'], ref $_[0];
  }
  sub rotate {
    my ($self) = @_;
    bless
      [$self->[NUM], main::rotate_lines($self->[LINES]), $self->[ORIENT].'r'],
      ref $self;
  }
  sub str {
    join "\n", @{$_[0]->[LINES]}
  }
  1;
}

sub canon {
  return minstr($_[0], scalar reverse $_[0]);
}

sub calc {
  my ($in) = @_;
  my ($tiles, $edges, $kind) = @$in;
  my $p = 1;
  for my $n (@{$kind->{'corner'}}) {
    $p *= $n;
  }
  return $p;
}

sub find_tile {
  my ($in, $t, $dir) = @_;
  my ($tiles, $edges, $kind) = @$in;
  my $opp =
    {
     'left' => 'right', 'top' => 'bottom',
     'right' => 'left', 'bottom' => 'top',
    }->{$dir};
  my $edge = $t->$dir;
  my $next = (grep { $_ != $t->num } keys %{$edges->{canon($edge)}})[0]
    or return;
  for my $tt (@{$tiles->{$next}->all()}) {
    if ($tt->$opp eq $edge) {
      return $tt;
    }
  }
  die "Failed to find next tile from ", $t->num, " $dir\n";
}

sub image {
  my ($in) = @_;
  my ($tiles, $edges, $kind) = @$in;
  my @res;
  my $i = 0;
  my $top_left = shift @{$kind->{'corner'}}; # pick a corner to start
  print "T: $top_left\n" if DEBUG;
  my $t = $tiles->{$top_left};
  $t = $t->rotate while ((keys %{$edges->{canon($t->right)}}) != 2 or
                         (keys %{$edges->{canon($t->bottom)}}) != 2);
  my $pt = $t;
  push @{$res[$i]}, $t;
  while (1) {
    $t = find_tile($in, $pt, 'right');
    unless (defined $t) {
      $t = $res[$i]->[0];
      $i++;
      $t = find_tile($in, $t, 'bottom');
      unless (defined $t) {
        last;
      }
    }
    print "T: ", $t->num, "\n" if DEBUG;
    push @{$res[$i]}, $t;
    $pt = $t;
  }
  my $s = "";
  for my $line (@res) {
    for my $i (1..(length $line->[0]->top)-2) {
      for my $t (@$line) {
        $s .= $t->iline($i);
      }
      $s .= "\n";
    }
  }
  return $s;
}

sub calc2 {
  my ($in) = @_;
  my ($tiles, $edges, $kind) = @$in;
  my $image = image($in);
  my $lines = [split /\n/, $image];
  my $h = @$lines;
  my $w = length $lines->[0];
  my $monster = read_lines($monster_file);
  my $mchars = sum(map { ~~y/#// } @$monster);
  my $mh = @$monster;
  my $mw = max map { length $_ } @$monster;
  if (DEBUG) {
    print "$w x $h\n";
    print "$mw x $mh  ${mchars} chars\n";
  }
  if (DEBUG > 1) {
    print join "\n", @$lines, "\n";
  }
  for my $i (0..7) {
    for my $r (0..$h-1-$mh) {
      for my $c (0..$w-1-$mw) {
        my $matched = 0;
        for my $mr (0..$mh-1) {
          for my $mc (0..$mw-1) {
            my $mch = substr $monster->[$mr], $mc, 1;
            next if ($mch ne '#');
            if ((substr $lines->[$r+$mr], $c+$mc, 1) eq '#') {
              $matched++;
            }
          }
        }
        next unless ($matched == $mchars);
        for my $mr (0..$mh-1) {
          for my $mc (0..$mw-1) {
            my $mch = substr $monster->[$mr], $mc, 1;
            next if ($mch ne '#');
            substr $lines->[$r+$mr], $c+$mc, 1, 'O';
          }
        }
      }
    }
    if ($i == 3) {
      $lines = [reverse @$lines];
    } else {
      $lines = rotate_lines($lines);
    }
  }
  $image = (join "\n", @$lines)."\n";
  return ~~($image =~ y/#//);
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test1.txt", 20899048083289 ],
    );
  for my $tc (@test_cases) {
    my $res = calc(read_tiles($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test1.txt", 273 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2(read_tiles($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
