#!/usr/bin/env perl
use strict;
use warnings;
use lib '.';
use Test::More;

require_ok 'a.pl';

is play(9, 25), 32,
  '9 players; last marble is worth 25 points';
is play(10, 1618), 8317,
  '10 players; last marble is worth 1618 points';
is play(13, 7999), 146373,
  '13 players; last marble is worth 7999 points';
is play(17, 1104), 2764, '17 players; last marble is worth 1104 points';
is play(21, 6111), 54718, '21 players; last marble is worth 6111 points';
is play(30, 5807), 37305, '30 players; last marble is worth 5807 points';

require_ok 'b.pl';

is play_fast(9, 25), 32,
  '9 players; last marble is worth 25 points';
is play_fast(10, 1618), 8317,
  '10 players; last marble is worth 1618 points';
is play_fast(13, 7999), 146373,
  '13 players; last marble is worth 7999 points';
is play_fast(17, 1104), 2764, '17 players; last marble is worth 1104 points';
is play_fast(21, 6111), 54718, '21 players; last marble is worth 6111 points';
is play_fast(30, 5807), 37305, '30 players; last marble is worth 5807 points';
is play_fast(468, 71843), 385820,
  '468 players; last marble is worth 71843 points';
is play_fast(468, 7184300), 3156297594,
  '468 players; last marble is worth 7184300 points';

done_testing();
