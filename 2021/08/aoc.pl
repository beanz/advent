#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.10;
use lib "../../lib-perl";
no warnings 'portable';
use AoC::Helpers qw/:all/;
#use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/permutations/;
$; = $" = ',';

my $file = shift // "input.txt";
my $reader = \&read_stuff;
my $i = $reader->($file);
my $i2 = $reader->($file);


sub canon {
  join "", sort split//, $_[0]
}

my @digits = qw/abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg/;
my %digitm;
for my $j (0..@digits-1) {
  $digitm{canon($digits[$j])} = $j;
}
#dd([\%digitm],[qw/perms/]); exit;

my @n = split //, "abcdefg";
my $iter = permutations([split //, "abcdefg"]);
my @perms;
while (my $p = $iter->next) {
  push @perms, { zip(@n, @$p) };
}
#dd([\@perms],[qw/perms/]); exit;

sub read_stuff {
  my ($file) = @_;
  my @i;
  my $lines = read_lines($file);
  for my $i (0..@$lines-1) {
    my $l = $lines->[$i];
    my @s = split / \| /, $l;
    my $r =
      {
       sp => [split/ /, $s[0]], d => [split/ /,$s[1]],
       line => $l, lineno => $i,
      };
    push @i, $r;
    my %m;
    for my $w (@{$r->{sp}}) {
      my $s = join"", sort split //, $w;
      push @{$r->{sps}}, $s;
      $m{$s}++;
    }
    for my $w (@{$r->{d}}) {
      my $s = join"", sort split //, $w;
      push @{$r->{ds}}, $s;
    }
    $r->{m} = \%m;
  }
  return \@i;
}

sub calc {
  my ($in) = @_;
  my $c = 0;
  my %d = map { (length $digits[$_]) => $_ } (1, 4, 7, 8);
  for my $r (@$in) {
    for my $w (@{$r->{d}}) {
      $c++ if (exists $d{length $w});
    }
  }
  return $c;
}

sub calc2 {
  my ($in) = @_;
  my %d = map { (length $digits[$_]) => $_ } (1, 4, 7, 8);
  my $c = 0;
 LINE:
  for my $r (@$in) {
  PERM:
    for my $p (@perms) {
      my $ps = (join "", keys %$p);
      for my $w (@{$r->{sps}}) {
        #print "  $w / $ps => ";
        my $nw = join "", sort map { $p->{$_} } split //, $w;
        #print "$nw\n";
        next PERM unless (exists $digitm{$nw});
      }
      #print "F: $ps\n";
      my $n;
      for my $d (@{$r->{ds}}) {
        my $nd = join "", sort map { $p->{$_} } split //, $d;
        $n .= $digitm{$nd} // die "Invalid $d for $ps\n";
      }
      $c += $n;
      next LINE;
    }
    die "Failed to find perm for $r->{lineno}: $r->{line}\n";
  }
  return $c;
}

testPart1() if (TEST);

print "Part 1: ", calc($i), "\n";

testPart2() if (TEST);

print "Part 2: ", calc2($i2), "\n";

sub testPart1 {
  my @test_cases =
    (
     [ "test0.txt", 2 ],
     [ "test1.txt", 26 ],
     [ "test2.txt", 0 ],
     [ "input.txt", 504 ],
    );
  for my $tc (@test_cases) {
    my $res = calc($reader->($tc->[0]));
    assertEq("Test 1 [$tc->[0]]", $res, $tc->[1]);
  }
}

sub testPart2 {
  my @test_cases =
    (
     [ "test0.txt", 8394 ],
     [ "test1.txt", 61229 ],
     [ "test2.txt", 5353 ],
     [ "input.txt", 1073431 ],
    );
  for my $tc (@test_cases) {
    my $res = calc2($reader->($tc->[0]));
    assertEq("Test 2 [$tc->[0]]", $res, $tc->[1]);
  }
}
