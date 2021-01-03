#!/usr/bin/perl
use warnings;
use strict;
use v5.10;
use Carp::Always qw/carp verbose/;
use warnings FATAL => 'all';
use constant {
  DEBUG => $ENV{AoC_DEBUG},
};

sub floor {
  my $i = shift;
  return ($i =~ y/\(//) - ($i =~ y/\)//);
}

sub basement {
  my $d = shift;
  $d =~ s/[^\(\)]//g; # clean
  my @i = split //, $d;
  my $f = 0;
  for my $i (1..@i) {
    $f += $i[$i-1] eq '(' ? 1 : -1;
    #print "$d\[$i]: $f\n";
    if ($f == -1) {
      return $i
    }
  }
  return -1;
}

print floor("(())"), " = 0\n";
print floor("()()"), " = 0\n";
print floor("((("), " = 3\n";
print floor("(()(()("), " = 3\n";
print floor("))((((("), " = 3\n";
print floor("())"), " = -1\n";
print floor("))("), " = -1\n";
print floor(")))"), " = -3\n";
print floor(")())())"), " = -3\n";
print basement(")"), " = 1\n";
print basement("()())"), " = 5\n";

my $i = <>;
chomp $i;
print "Part 1: ", floor($i), "\n";
print "Part 2: ", basement($i), "\n";
