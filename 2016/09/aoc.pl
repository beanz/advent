#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @tests = split /\n/, <<'EOF';
ADVENT ADVENT
A(2x2)BCD(2x2)EFG ABCBCDEFEFG
A(1x5)BC ABBBBBC
(3x3)XYZ XYZXYZXYZ
(6x1)(1x3)A (1x3)A
X(8x2)(3x3)ABCY X(3x3)ABC(3x3)ABCY
EOF

for my $tc (@tests) {
  my ($in, $out) = split /\s+/, $tc;
  my $act = decompress1($in);
  die "$in => $out not $act\n" if ($out ne $act);
}

my @i = <>;
chomp @i;

print "Part 1: ", length(decompress1($i[0])), "\n";

sub decompress1 {
  my ($in) = @_;
  my $new = "";
  my @in = split//, $in;
  my $i = 0;
  while ($i < @in) {
    if ($in[$i] eq '(') {
      $i++;
      my $spec = '';
      while ($in[$i] ne ')' && $i < @in) {
        $spec .= $in[$i];
        $i++;
      }
      $i++;
      my ($count, $repeat) = split /x/, $spec;
      my $chars = '';
      for (1..$count) {
        $chars .= $in[$i++];
      }
      $new .= $chars for (1..$repeat);
    } else {
      $new .= $in[$i];
      $i++;
    }
  }
  return $new;
}

@tests = split /\n/, <<'EOF';
ADVENT 6
X(8x2)(3x3)ABCY 20
(27x12)(20x12)(13x14)(7x10)(1x12)A 241920
(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN 445
EOF

for my $tc (@tests) {
  my ($in, $exp) = split /\s+/, $tc;
  my $act = decompress2($in);
  die "$in => $exp not $act\n" if ($act != $exp);
}

print "Part 2: ", decompress2($i[0]), "\n";

sub decompress2 {
  my ($in) = @_;
  my $len = 0;
  my @in = split//, $in;
  my $i = 0;
  while ($i < @in) {
    if ($in[$i] eq '(') {
      $i++;
      my $spec = '';
      while ($in[$i] ne ')' && $i < @in) {
        $spec .= $in[$i];
        $i++;
      }
      $i++;
      my ($count, $repeat) = split /x/, $spec;
      my $chars = '';
      for (1..$count) {
        $chars .= $in[$i++];
      }
      $len += decompress2($chars) * $repeat;
    } else {
      $len += length($in[$i]);
      $i++;
    }
  }
  return $len;
}
