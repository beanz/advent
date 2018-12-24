#!/usr/bin/perl
use warnings;
use strict;

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
  my $act = decompress($in);
  die "$in => $out not $act\n" if ($out ne $act);
}

while (<>) {
  chomp;
  print length(decompress($_)), "\n";
}

sub decompress {
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
