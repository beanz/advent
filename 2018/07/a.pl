#!/usr/bin/perl
use warnings;
use strict;
my $j = <>;
$j = <>;
my %dep;
my %todo;
while (<>) {
  if (/Step (\S+) must be finished before step (\S+) can begin/) {
    $dep{$2}->{$1}++;
    $todo{$1}++;
    $todo{$2}++;
  }
}

my @available_work = grep !exists $dep{$_}, sort keys %todo;

sub work {
  my $n = shift;
  for my $k (keys %dep) {
    delete $dep{$k}->{$n};
    next if (scalar keys %{$dep{$k}});
    delete $dep{$k};
    @available_work = sort @available_work, $k;
  }
}

while (@available_work) {
  my $n = shift @available_work;
  work($n);
  print "$n";
}
print "\n";
