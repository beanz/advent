#!/usr/bin/perl
use warnings;
use strict;
use Imager;

my $h = shift || 6;
my $w = shift || 25;

my @col =
  (
   Imager::Color->new(0,0,0),
   Imager::Color->new(255,255,255),
   Imager::Color->new(255,0,0,0),
  );

my $c;
{
  local $/;
  $c = <>;
}
chomp $c;
my @l =
  map { [ map { [unpack '(A)*', $_] } unpack '(A'.$w.')*', $_ ]
      } unpack '(A'.($w*$h).')*', $c;

my $prev;
my $ln = 0;
for my $l (@l) {
  my $im = Imager->new(xsize => $w, ysize => $h, channels => 4);
  for my $y (0..$h-1) {
    for my $x (0..$w-1) {
      my $c = $col[$l->[$y]->[$x]];
      $im->setpixel(x => $x, y => $y, color => $c);
    }
  }
  $im->compose(src=> $prev) if ($prev);
  $prev = $im;
}
$prev->write(file => 'image.jpg');
