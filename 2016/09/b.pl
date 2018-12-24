#!/usr/bin/perl
use warnings;
use strict;

my @tests = split /\n/, <<'EOF';
ADVENT 6
X(8x2)(3x3)ABCY 20
(27x12)(20x12)(13x14)(7x10)(1x12)A 241920
(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN 445
EOF

for my $tc (@tests) {
  my ($in, $exp) = split /\s+/, $tc;
  my $act = decompress($in);
  die "$in => $exp not $act\n" if ($act != $exp);
}

while (<>) {
  chomp;
  print decompress($_), "\n";
}

sub decompress {
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
      $len += decompress($chars) * $repeat;
    } else {
      $len += length($in[$i]);
      $i++;
    }
  }
  return $len;
}
