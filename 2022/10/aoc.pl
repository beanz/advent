#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;

#use Carp::Always qw/carp verbose/;
#use Algorithm::Combinatorics qw/permutations combinations/;
$; = $" = ',';

my $file = shift // "input.txt";

#my $reader = \&read_stuff;
my $reader = \&read_guess;
my $i = $reader->($file);

sub proc {
  my ($pr) = @_;
  for my $inst (@{$pr->{in}}) {
    push @{$pr->{sig}}, $pr->{sig}->[-1];
    if ($inst->[0] eq "addx") {
      push @{$pr->{sig}}, $pr->{sig}->[-1] + $inst->[1];
    }
  }
}

sub calc {
  my ($in) = @_;
  my $pr = {
    sig => [1],
    rec => ["init"],
    in => $in,
  };
  while (@{$pr->{sig}} < 240) {
    proc($pr);
  }
  my $p1;
  for (20, 60, 100, 140, 180, 220) {
    $p1 += $_ * $pr->{sig}->[$_ - 1];
  }
  my $p2 = "";
  for my $i (0 .. 239) {
    my $v = $pr->{sig}->[$i];
    my $n = $i % 40;
    if ($v >= $n - 1 && $v <= $n + 1) {
      $p2 .= "#";
    } else {
      $p2 .= " ";
    }
    if ($i % 40 == 39) {
      $p2 .= "\n";
    }
  }
  return [$p1, $p2];
}

testParts() if (TEST);

my $r = calc($i);
print "Part 1: $r->[0]\nPart 2:\n$r->[1]\n";

sub testParts {
  my $to = q{##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
###   ###   ###   ###   ###   ###   ### 
####    ####    ####    ####    ####    
#####     #####     #####     #####     
######      ######      ######      ####
#######       #######       #######     
};
  my $io = q{###  #  # #    #  #   ##  ##  ####  ##  
#  # #  # #    #  #    # #  #    # #  # 
#  # #### #    ####    # #      #  #  # 
###  #  # #    #  #    # # ##  #   #### 
#    #  # #    #  # #  # #  # #    #  # 
#    #  # #### #  #  ##   ### #### #  # 
};
  my @test_cases = (["test1.txt", 13140, $to], ["input.txt", 15360, $io],);
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res->[0], $tc->[1]);
    assertEq("Test 1 [$tc->[0]]", $res->[1], $tc->[2]);
  }
}
