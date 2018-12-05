#!/usr/bin/perl -l

@a = <>;
chomp @a;
my $guard;
for (sort @a) {
  if (/#(\d+)/) {
    $g = $1;
  } elsif (/(\d\d)\]\s+falls/) {
    $s = $1;
  } elsif (/(\d\d)\]\s+wakes/) {
    $g{$g}->{c} += $1-$s;
    if ($g{$g}->{c} > $g{$guard}->{c}) {
      $guard = $g;
    }
    for $m($s..$1-1) {
      $g{$g}->{m}->{$m}++;
      if ($g{$g}->{m}->{$m} > $g{$g}->{m}->{$g{$g}->{maxm}}) {
        $g{$g}->{maxm} = $m;
      }
    }
  }
}

print $guard * $g{$guard}->{maxm};
