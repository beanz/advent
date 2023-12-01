#!/usr/bin/env perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my $file = shift // "input.txt";
my @i = @{read_lines($file)};

my %dep;
my %todo;
for (@i) {
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

my $s;
while (@available_work) {
  my $n = shift @available_work;
  work($n);
  $s .= $n;
}
print 'Part 1: ', $s, "\n";

my $workload = 60;
my $workers = 5;
if (@i < 10) {
  $workload = 0;
  $workers = 2;
}
print 'Part 2: ', run($workload, $workers, \@i), "\n";

sub run {
  my ($workload, $workers, $lines) = @_;

  my %dep;
  my %todo;
  my %doing;
  for (@$lines) {
    if (/Step (\S+) must be finished before step (\S+) can begin/) {
      $dep{$2}->{$1}++;
      $todo{$1}++;
      $todo{$2}++;
    }
  }

  my @available_work = grep !exists $dep{$_}, sort keys %todo;

  for my $k (keys %todo) {
    $todo{$k} = $workload+ord($k)-64;
  }

  my $do_work = sub {
    my $n = shift;
    $todo{$n}--;
    return if ($todo{$n} > 0);
    delete $todo{$n};
    for my $k (keys %dep) {
      delete $dep{$k}->{$n};
      next if (scalar keys %{$dep{$k}});
      delete $dep{$k};
      @available_work = sort @available_work, $k;
    }
    return 1;
  };

  my $t = 0;

  while (@available_work || keys %doing) {
    my @current_work = @available_work;
    for my $wn (1..$workers) {
      my $n;
      if (exists $doing{$wn}) {
        $n = $doing{$wn};
      } elsif (@current_work) {
        $n = shift @current_work;
        @available_work = grep $_ ne $n, @available_work;
      } else {
        next;
      }
      $doing{$wn} = $n;
      if ($do_work->($n)) {
        delete $doing{$wn};
      }
    }
    $t++;
  }
  return $t;
}

1;
