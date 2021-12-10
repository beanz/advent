#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;
use Algorithm::Combinatorics qw/combinations/;
use constant
  {
   COST => 0,
   DAMAGE => 1,
   ARMOR => 2,
   NAME => 3,
  };

my $i = read_lines(shift//"input.txt");

sub parse_input {
  my ($in) = @_;
  my %r;
  for my $l (@$in) {
    my ($n, $v) = split /: /, $l;
    $n =~ s/[^A-Z]//g;
    $r{$n} = $v;
  }
  return \%r;
}

my $boss = parse_input($i);
dd([$boss],[qw/boss/]) if DEBUG;

my $shop_data = <<'EOF';
Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3
EOF
sub parse_shop {
  my ($i) = @_;
  my %s;
  $s{All}->{"nothing"} = [ 0, 0, 0, 'nothing' ];
  for my $s (split /\n\n/, $i) {
    my @l = split /\n/, $s;
    my $t = shift @l; $t =~ s/:.*//;
    for my $l (@l) {
      die unless ($l =~ m!^(.*?)\s+(\d+)\s+(\d+)\s+(\d+)!);
      my ($name, $cost, $damage, $armor) = ((lc$1), $2, $3, $4);
      $name =~ s/\s+//;
      $s{$t}->{$name} = $s{All}->{$name} = [ $cost, $damage, $armor, $name ];
    }
    $s{$t}->{nothing} = $s{All}->{nothing} unless ($t eq 'Weapons');
  }
  return \%s;
}
my $shop = parse_shop($shop_data);
#dd([$shop],[qw/shop/]) if DEBUG;

sub attack {
  my ($damage, $armor) = @_;
  return max(1, $damage-$armor);
}

sub timeToDeath {
  my ($hp, $armor, $damage) = @_;
  return ceil($hp/attack($damage, $armor));
}

sub battle {
  my ($boss, $player) = @_;
  return
    (timeToDeath($boss->{HP}, $boss->{A}, $player->{D}) <=
     timeToDeath($player->{HP}, $player->{A}, $boss->{D})) ? 'WIN' : 'LOSE';
}

sub total_stats {
  my ($shop, $items) = @_;
  return [ sum(map { $shop->{All}->{$_}->[COST] } @$items),
           sum(map { $shop->{All}->{$_}->[DAMAGE] } @$items),
           sum(map { $shop->{All}->{$_}->[ARMOR] } @$items) ];
}

sub calc {
  my ($shop, $boss, $hp) = @_;
  my $min = 10000000;
  for my $armor (keys %{$shop->{Armor}}) {
    for my $weapon (keys %{$shop->{Weapons}}) {
      # extra none to allow choosing no rings
      for my $rings (combinations(['nothing', keys %{$shop->{Rings}}], 2)) {
        my @items = ($weapon,$armor,@$rings);
        my $stats = total_stats($shop, \@items);
        my $res = battle({%$boss},
                         { HP=>$hp, A=>$stats->[ARMOR], D=>$stats->[DAMAGE] });
        if ($res eq 'WIN') {
          $min = min($min,$stats->[COST]);
        }
      }
    }
  }
  return $min;
}

if (TEST) {
  my $res;
  $res = attack(8, 3);
  print "Test 1 attack D=8 A=3: $res == 5\n";
  die "failed\n" unless ($res == 5);
  $res = attack(8, 300);
  print "Test 1 attack D=8 A=300: $res == 1\n";
  die "failed\n" unless ($res == 1);

  $res = battle({ HP => 12, D => 7, A => 2 },
                { HP => 8, D => 5, A => 5 });
  print "Test 1 battle: $res == WIN\n";
  die "failed\n" unless ($res eq 'WIN');
  $res = battle({ HP => 12, D => 7, A => 2 },
                { HP => 8, D => 4, A => 5 });
  print "Test 1 battle: $res == LOSE\n";
  die "failed\n" unless ($res eq 'LOSE');
}

print "Part 1: ", calc($shop, {%$boss}, 100), "\n";

sub calc2 {
  my ($shop, $boss, $hp) = @_;
  my $max = -10000000;
  for my $armor (keys %{$shop->{Armor}}) {
    for my $weapon (keys %{$shop->{Weapons}}) {
      # extra none to allow choosing no rings
      for my $rings (combinations(['nothing', keys %{$shop->{Rings}}], 2)) {
        my @items = ($weapon,$armor,@$rings);
        my $stats = total_stats($shop, \@items);
        my $res = battle({%$boss},
                         { HP=>$hp, A=>$stats->[ARMOR], D=>$stats->[DAMAGE] });
        if ($res eq 'LOSE') {
          $max = max($max,$stats->[COST]);
        }
      }
    }
  }
  return $max;
}

print "Part 2: ", calc2($shop, {%$boss}, 100), "\n";
