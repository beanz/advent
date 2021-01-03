#!/usr/bin/perl
use warnings FATAL => 'all';
use strict;
use v5.20;
use lib "../../lib-perl";
use AoC::Helpers qw/:all/;
use Carp::Always qw/carp verbose/;

my @i = <>;
chomp @i;

my $i = parse_input(\@i);

sub parse_input {
  my ($lines) = @_;
  my %r;
  for my $l (@$lines) {
    my ($n, $v) = split /: /, $l;
    $n = 'HP' if ($n eq 'Hit Points');
    $r{$n} = $v;
  }
  return
    {
     boss => \%r,
     turn => 0,
     player => { HP => 50, MANA => 500, Armor => 0 },
    };
}

sub attack_damage {
  my ($damage, $armor) = @_;
  return max(1, $damage-$armor);
}

my %effects =
  (
   "Magic Missile" =>
   {
    cost => 53,
    instant => sub {
      my ($game) = @_;
      $game->{boss}->{HP} -= 4;
      print STDERR "Player casts Magic Missile, dealing 4 damage.\n" if DEBUG;
    }
   },
   "Drain" =>
   {
    cost => 73,
    instant => sub {
      my ($game) = @_;
      print STDERR "Player casts Drain, dealing 2 damage, ".
        "and healing 2 hit points.\n" if DEBUG;
      $game->{boss}->{HP} -= 2;
      $game->{player}->{HP} += 2;
    },
   },
   "Shield" =>
   {
    cost => 113,
    turn => sub {
      my ($game) = @_;
      if ($game->{turn} == $game->{effects}->{Shield}) {
        print STDERR
          "Shield's timer is now 0.\n".
          "Shield wears off, decreasing armor by 7\n" if DEBUG;
        delete $game->{effects}->{Shield};
        $game->{player}->{Armor} -= 7;
      } else {
        print STDERR "Shield's timer is now ",
          ($game->{effects}->{Shield}-$game->{turn}), ".\n" if DEBUG;
      }
    },
    instant => sub {
      my ($game) = @_;
      print STDERR "Player casts Shield, increasing armor by 7.\n" if DEBUG;
      $game->{effects}->{Shield} = $game->{turn}+6;
      $game->{player}->{Armor} += 7;
    },
   },
   "Poison" =>
   {
    cost => 173,
    instant => sub {
      my ($game) = @_;
      $game->{effects}->{Poison} = $game->{turn} + 6;
      print STDERR "Player casts Poison.\n" if DEBUG;
    },
    turn => sub {
      my ($game) = @_;
      $game->{boss}->{HP} -= 3;
      if ($game->{boss}->{HP} <= 0) {
        print STDERR "Poison deals 3 damage. ".
          "This kills the boss, and the player wins.\n" if DEBUG;
      } else {
        print STDERR "Poison deals 3 damage; its timer is now ",
          ($game->{effects}->{Poison}-$game->{turn}), ".\n" if DEBUG;
      }
    },
    turn_end => sub {
      my ($game) = @_;
      if ($game->{turn} == $game->{effects}->{Poison}) {
        delete $game->{effects}->{Poison};
        print STDERR "Poison wears off.\n" if DEBUG;
      }
    },
   },
   "Recharge" =>
   {
    cost => 229,
    instant => sub {
      my ($game) = @_;
      print STDERR "Player casts Recharge." if DEBUG;
      $game->{effects}->{Recharge} = $game->{turn} + 5;
    },
    turn => sub {
      my ($game) = @_;
      $game->{player}->{MANA} += 101;
      print STDERR "Recharge provides 101 mana; its timer is now ",
        ($game->{effects}->{Recharge}-$game->{turn}), ".\n" if DEBUG;
      if ($game->{turn} == $game->{effects}->{Recharge}) {
        delete $game->{effects}->{Recharge};
        print STDERR "Recharge wears off.\n" if DEBUG;
      }
    },
   },
  );

sub play_turn {
  my ($game, $who, $effect) = @_;
  $game->{turn}++;
  printf STDERR
    "-- %s turn --\n".
    "- Player has %d hit points, %d armor, %d mana\n".
    "- Boss has %d hit points\n",
    ucfirst $who,
    $game->{player}->{HP}, $game->{player}->{Armor}, $game->{player}->{MANA},
    $game->{boss}->{HP} if DEBUG;

  for my $eff (keys %{$game->{effects}}) {
    if (exists $effects{$eff}->{turn}) {
      $effects{$eff}->{turn}->($game);
    }
    if ($game->{boss}->{HP} <= 0) {
      $game->{winner} = 'player';
      return;
    }
  }

  if ($who eq 'boss') {
    # Boss
    my $damage = attack_damage($game->{boss}->{Damage},
                               $game->{player}->{Armor});
    my $hp = $game->{player}->{HP} -= $damage;
    print STDERR "Boss attacks for $damage damage!\n" if DEBUG;
    if ($game->{player}->{HP} <= 0) {
      $game->{winner} = 'boss';
      return;
    }
  } else {
    # Wizard
    if (exists $effects{$effect}) {
      $game->{player}->{MANA} -= $effects{$effect}->{cost};
      $effects{$effect}->{instant}->($game);
    } else {
      warn "invalid effect? $effect\n";
    }
  }

  for my $eff (keys %{$game->{effects}}) {
    if (exists $effects{$eff}->{turn_end}) {
      $effects{$eff}->{turn_end}->($game);
    }
  }
  print STDERR "\n" if DEBUG;
  return 1;
}

use constant { GAME => 0, MANA => 1, SPELLS => 2 };

sub play_all_the_games {
  my ($g, $difficulty) = @_;
  $difficulty //= 0;
  my $least_mana;
  my @todo = ([$g, 0, []]);
  my $tested = 0;
  while (@todo) {
    my $state;
    print STDERR ~~@todo, " $tested  \r" if (DEBUG && ($tested%100) == 0);
    $state = shift @todo;
    $tested++;
    if (defined $least_mana && $state->[MANA] > $least_mana) {
      next;
    }
    assertGreaterThan('player alive', $state->[GAME]->{player}->{HP}, 0);
    assertGreaterThan('boss alive', $state->[GAME]->{boss}->{HP}, 0);

    $state->[GAME]->{player}->{HP} -= $difficulty;
    next if ($state->[GAME]->{player}->{HP} <= 0);

    #dd([$state],[qw/state/]);
    for my $effect (sort { $effects{$a}->{cost} <=> $effects{$b}->{cost}
                         } keys %effects) {
      # Need mana to cast the spell
      next if ($effects{$effect}->{cost} > $state->[GAME]->{player}->{MANA});

      # You cannot cast a spell that would start an effect which is
      # already active. However, effects can be started on the same
      # turn they end.
      next if (exists $state->[GAME]->{effects}->{$effect} &&
               $state->[GAME]->{effects}->{$effect} != $state->[GAME]->{turn}+1);

      #print STDERR "Cast $effect\n";
      my $nstate = dclone($state);
      play_turn($nstate->[GAME], 'player', $effect);
      my $short = $effect;
      $short =~ s/[^A-Z]//g;
      push @{$nstate->[SPELLS]}, $short;
      $nstate->[MANA] += $effects{$effect}->{cost};
      if ($nstate->[GAME]->{winner}) {
        if ($nstate->[GAME]->{winner} eq 'player') {
          if (!defined $least_mana || $nstate->[MANA] < $least_mana) {
            $least_mana = $nstate->[MANA];
            #print STDERR "New best $least_mana\n";
            #print STDERR "@{$nstate->[SPELLS]}\n";
          }
        }
        next;
      }
      play_turn($nstate->[GAME], 'boss');
      if ($nstate->[GAME]->{winner}) {
        if ($nstate->[GAME]->{winner} eq 'player') {
          if (!defined $least_mana || $nstate->[MANA] < $least_mana) {
            $least_mana = $nstate->[MANA];
            #print STDERR "New best $least_mana\n";
            #print STDERR "@{$nstate->[SPELLS]}\n";
          }
        }
        next;
      }
      push @todo, $nstate;
    }
    print STDERR "Todo: ", scalar(@todo), "\n" if DEBUG;
  }
  die "No win found\n" unless (defined $least_mana);
  return $least_mana;
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
Hit Points: 13
Damage: 8
EOF
#dd([$test_input],[qw/test_input/]);
$test_input->{player} = { HP => 10, MANA => 250, Armor => 0 };

if (TEST) {
  my $game;
  $game = dclone($test_input);
  play_turn($game, 'player', 'Poison');
  assertEq("boss HP", 13, $game->{boss}->{HP});
  assertEq("player HP", 10, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 77, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("boss HP", 10, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 77, $game->{player}->{MANA});
  play_turn($game, 'player', 'Magic Missile');
  assertEq("boss HP", 3, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 24, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("winner", "player", $game->{winner});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 24, $game->{player}->{MANA});

  $game = dclone($test_input);
  $game->{boss}->{HP} = 14;
  play_turn($game, 'player', 'Recharge');
  assertEq("boss HP", 14, $game->{boss}->{HP});
  assertEq("player HP", 10, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 21, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("boss HP", 14, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 122, $game->{player}->{MANA});

  play_turn($game, 'player', 'Shield');
  assertEq("boss HP", 14, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 7, $game->{player}->{Armor});
  assertEq("player MANA", 110, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("boss HP", 14, $game->{boss}->{HP});
  assertEq("player HP", 1, $game->{player}->{HP});
  assertEq("player Armor", 7, $game->{player}->{Armor});
  assertEq("player MANA", 211, $game->{player}->{MANA});

  play_turn($game, 'player', 'Drain');
  assertEq("boss HP", 12, $game->{boss}->{HP});
  assertEq("player HP", 3, $game->{player}->{HP});
  assertEq("player Armor", 7, $game->{player}->{Armor});
  assertEq("player MANA", 239, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("boss HP", 12, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 7, $game->{player}->{Armor});
  assertEq("player MANA", 340, $game->{player}->{MANA});

  play_turn($game, 'player', 'Poison');
  assertEq("boss HP", 12, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 7, $game->{player}->{Armor});
  assertEq("player MANA", 167, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("boss HP", 9, $game->{boss}->{HP});
  assertEq("player HP", 1, $game->{player}->{HP});
  assertEq("player Armor", 7, $game->{player}->{Armor});
  assertEq("player MANA", 167, $game->{player}->{MANA});

  play_turn($game, 'player', 'Magic Missile');
  assertEq("boss HP", 2, $game->{boss}->{HP});
  assertEq("player HP", 1, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 114, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("winner", "player", $game->{winner});
  assertEq("player HP", 1, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 114, $game->{player}->{MANA});

  $game = dclone($test_input);
  $game->{boss}->{HP} = 20;
  play_turn($game, 'player', 'Poison');
  assertEq("boss HP", 20, $game->{boss}->{HP});
  assertEq("player HP", 10, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 77, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("boss HP", 17, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 77, $game->{player}->{MANA});
  play_turn($game, 'player', 'Magic Missile');
  assertEq("boss HP", 10, $game->{boss}->{HP});
  assertEq("player HP", 2, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 24, $game->{player}->{MANA});
  play_turn($game, 'boss');
  assertEq("winner", "boss", $game->{winner});
  assertEq("player HP", -6, $game->{player}->{HP});
  assertEq("player Armor", 0, $game->{player}->{Armor});
  assertEq("player MANA", 24, $game->{player}->{MANA});
  # $game = dclone($i);
  # play_turn($game, 'player', 'Poison');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Recharge');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Magic Missile');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Magic Missile');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Poison');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Recharge');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Magic Missile');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Magic Missile');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Poison');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Magic Missile');
  # play_turn($game, 'boss');
  # play_turn($game, 'player', 'Magic Missile');
  # play_turn($game, 'boss');
}


my $game = dclone($i);
my $part1 = play_all_the_games($game);
print "Part 1: ", $part1, "\n";

$game = dclone($i);
print "Part 2: ", play_all_the_games($game, 1), "\n";
