#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/combinations_with_repetition/;

my @i = @{read_lines(shift//"input.txt")};

my $line_re =
  qr/(.*): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/;

sub attribute_score {
  my ($ingredients, $keys, $recipe, $attr) = @_;
  #print STDERR "@$keys @$recipe $attr:";
  my $score = 0;
  for my $i (0..@$keys-1) {
    my $ingredient = $keys->[$i];
    my $num = $recipe->[$i];
    #print STDERR
    #  "  $ingredient: $num * ", $ingredients->{$ingredient}->{$attr}, "\n";
    $score += $num * $ingredients->{$ingredient}->{$attr};
  }
  $score = 0 if ($score < 0);
  #print STDERR "  $score\n";
  return $score;
}

sub all_recipes {
  my ($k, $num) = @_;
  if (@$k == 1) {
    return [[$num]];
  } else {
    my @r = @$k;
    my $i = shift @r;
    my @res;
    for my $n (0..$num) {
      my $s = all_recipes([@r], $num-$n);
      for my $e (@$s) {
        push @res, [$n, @$e];
      }
    }
    return \@res;
  }
}

sub calc {
  my ($i, $cal) = @_;
  my %i;
  for my $l (@$i) {
    next unless ($l =~ $line_re);
    $i{$1} = { capacity => 0+$2, durability => 0+$3,
               flavor => 0+$4, texture => 0+$5, calories => $6 };
  }
  my $max = -10000000;
  my @k = sort keys %i;
  my @c = @{all_recipes(\@k, 100)};
  #@c = ([44, 56]);
  for my $i (0..$#c) {
    my $recipe = $c[$i];
    print STDERR "$i of $#c\r" if DEBUG;
    my %s;
    next if (defined $cal &&
             attribute_score(\%i, \@k, $recipe, 'calories') != $cal);
    my $score = 1;
    for my $attr (qw/capacity durability flavor texture/) {
      $score *= attribute_score(\%i, \@k, $recipe, $attr);
    }
    if ($score > $max) {
      print STDERR "\nN: @$recipe $score > $max\n" if DEBUG;
      $max = $score;
    }
  }
  print STDERR "\n" if DEBUG;
  return $max;
}

my @test_input = split/\n/, <<'EOF';
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
EOF
chomp @test_input;

if (TEST) {
  assertEq("Test 1", calc(\@test_input), 62842880);
}
print "Part 1: ", calc(\@i), "\n";

if (TEST) {
  assertEq("Test 2", calc(\@test_input, 500), 57600000);
}
print "Part 2: ", calc(\@i, 500), "\n";
