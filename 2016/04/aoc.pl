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
  return $lines;
}

sub valid {
  my ($s) = @_;
  my ($name, $sector_id, $chksum) = ($s =~ m!^(.*)-(\d+)\[(.*)\]$!)
    or die "invalid format $s\n";
  my %c = ();
  $name =~ s/-//g;
  for my $c (split //, $name) {
    $c{$c}++;
  }
  my @sorted = sort { $c{$b} <=> $c{$a} || $a cmp $b } keys %c;
  my $testsum = join '', @sorted[0..4];
  print STDERR "$name $sector_id: $testsum eq $chksum\n" if DEBUG;
  return $testsum eq $chksum ? $sector_id : 0;
}

sub calc {
  my ($lines) = @_;
  return sum(map { valid($_) } @$lines);
}

my $test_input;
$test_input = parse_input([split/\n/, <<'EOF']);
aaaaa-bbb-z-y-x-123[abxyz]
a-b-c-d-e-f-g-h-987[abcde]
not-a-real-room-404[oarel]
totally-real-room-200[decoy]
EOF
#dd([$test_input],[qw/test_input/]);

if (TEST) {
  my $res;
  $res = calc($test_input);
  assertEq("Test 1", $res, 1514);
}

my $part1 = calc($i);
print "Part 1: ", $part1, "\n";

sub shift_cipher {
  my ($ch, $sector_id) = @_;
  return ' ' if ($ch eq '-');
  my $n = ord($ch) - ord('a');
  $n += $sector_id;
  $n %= 26;
  $n += ord('a');
  return chr($n);
}

sub decrypt {
  my ($s) = @_;
  my ($name, $sector_id, $chksum) = ($s =~ m!^(.*)-(\d+)\[(.*)\]$!)
    or die "invalid format $s\n";
  return [ (join '', map { shift_cipher($_, $sector_id) } split //, $name),
           $sector_id ];
}

sub calc2 {
  my ($lines) = @_;
  return [ grep { $_->[0] =~ /north/
                } map { decrypt($_)
                      } grep valid($_), @$lines
         ]->[0]->[1];
}

if (TEST) {
  my $res;
  $res = decrypt('qzmt-zixmtkozy-ivhz-343[fooba]');
  assertEq("Test 2", $res->[0], "very encrypted name");
  assertEq("Test 2", $res->[1], "343");
}

$i = parse_input(\@i); # reset input
print "Part 2: ", calc2($i), "\n";
