#!/usr/bin/env raku
use lib '../../lib-raku';
use AoC;

my $input = slurp(@*ARGS[0] // "input.txt");

RunTests(sub { calc(@_) }) if %*ENV{"AoC_TEST"};

say "Part 1: ", .[0], "\nPart 2: ", .[1] given calc($input);

sub calc ($in) {
  my @chunks = $in.split("\n\n").map: {.lines};
  my %r = (@chunks[0].map: {
    my ($name, $rest) = .split('{');
    my @chk = $rest.substr(0, $rest.chars-1).split(',');
    $name => |@chk
  });
  my @p = @chunks[1].map: {
    my %s = .substr(1,.chars-2).split(',').map: { |.split('=') };
    %s;
  };
  my $p1 = 0;
  for @p -> $p {
    $p1 += solve(%r, $p, 'in');
  }
  ($p1, solve2(%r))
}

sub solve(%r, $p, $state) {
  if $state eq 'A' {
    return $p.values.sum;
  }
  if $state eq 'R' {
    return 0;
  }
  die "invalid $state" unless %r{$state}:exists;
  for %r{$state} -> $chk {
    my ($k, $op, $v, $nxt) = $chk.match(/^(.)('<'|'>')(\d+)':'(.*)$/).values;
    unless ($k.defined) {
      return solve(%r, $p, $chk);
    }
    if $op eq '<' {
      if $p.{$k} < $v {
        return solve(%r, $p, $nxt);
      }
    } else {
      if $p.{$k} > $v {
        return solve(%r, $p, $nxt);
      }
    }
  }
  return -1;
}

sub solve2(%r) {
  my $c = 0;
  my @todo = [
    ['in', |{x => (1,4000), m => (1,4000), a => (1,4000), s => (1,4000)}],
  ];
  while @todo {
    my ($state, %ranges) = @todo.shift;
    if $state eq 'A' {
      my $p = [*] %ranges.values.map({ .[1]-.[0]+1 });
      $c += $p;
      next;
    }
    if $state eq 'R' {
      next;
    }
    die "invalid $state" unless %r{$state}:exists;
    for %r{$state} -> $chk {
      my ($k, $op, $v, $nxt) = $chk.match(/^(.)('<'|'>')(\d+)':'(.*)$/).values.map: ~*;
      unless ($k.defined) {
        @todo.push(["$chk", |%ranges]);
        next;
      }
      my @R = split_ranges($k, $op, $v, %ranges);
      my %true_ranges = @R[0];
      my %false_ranges = @R[1];
      @todo.push(["$nxt", |%true_ranges]);
      %ranges = %false_ranges;
    }
  }
  return $c;
}

sub split_ranges($k, $op, $v, %ranges) {
  my %tr;
  my %fr;
  for %ranges.kv -> $k2, @v {
    %tr{$k2} = (@v[0], @v[1]);
    %fr{$k2} = (@v[0], @v[1]);
  }
  my $lo = %ranges{$k}.[0];
  my $hi = %ranges{$k}.[1];
  if $op eq '>' {
    %tr{$k} = (($lo max ($v + 1)), $hi);
    %fr{$k} = ($lo, ($hi min (0+$v)));
  } else {
    %tr{$k} = ($lo, ($hi min ($v - 1)));
    %fr{$k} = (($lo max (0+$v)), $hi);
  }
  return (%tr, %fr);
}
