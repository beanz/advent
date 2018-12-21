#!/usr/bin/perl
use warnings;
use strict;

my ($r0, $r1, $r2, $r3, $r4x, $r5) = (0, 0, 0, 0, 0, 0);
sub d {
  #print "[$r0 $r1 $r2 $r3 ".(caller)[2]." $r5]\n";
}

my %seen;
my $previous;
#line 0
d;      $r5 = 123;                                # seti 123 0 5
d; L1:  $r5 = $r5 & 456;                          # bani 5 456 5
d;      $r5 = $r5 == 72 ? 1 : 0;                  # eqri 5 72 5
d;      if ($r5) { goto L5 };                     # addr 5 4 4
d;      goto L1;                                  # seti 0 0 4
d; L5:  $r5 = 0;                                  # seti 0 6 5
d; L6:  $r1 = $r5 | 65536;                        # bori 5 65536 1
d;      $r5 = 4591209;                            # seti 4591209 6 5
d; L8:  $r3 = $r1 & 255;                          # bani 1 255 3
d;      $r5 = $r5 + $r3;                          # addr 5 3 5
d;      $r5 = $r5 & 16777215;                     # bani 5 16777215 5
d;      $r5 = $r5 * 65899;                        # muli 5 65899 5
d;      $r5 = $r5 & 16777215;                     # bani 5 16777215 5
d;      $r3 = 256 > $r1 ? 1 : 0;                  # gtir 256 1 3
d;      if ($r3) { goto L16 };                    # addr 3 4 4
d;      goto L17;                                 # addi 4 1 4
d; L16: goto L28;                                 # seti 27 7 4
d; L17: $r3 = 0;                                  # seti 0 0 3
d; L18: $r2 = $r3 + 1;                            # addi 3 1 2
d;      $r2 = $r2 * 256;                          # muli 2 256 2
d;      $r2 = $r2 > $r1 ? 1 : 0;                  # gtrr 2 1 2
d;      if ($r2) { goto L23 };                    # addr 2 4 4
d;      goto L24;                                 # addi 4 1 4
d; L23: goto L26;                                 # seti 25 4 4
d; L24: $r3 = $r3 + 1;                            # addi 3 1 3
d;      goto L18;                                 # seti 17 0 4
d; L26: $r1 = $r3;                                # setr 3 4 1
d;      goto L8;                                  # seti 7 2 4
d; L28: $r3 = $r5 == $r0 ? 1 : 0;                 # eqrr 5 0 3
        if (!defined $previous) {
          print "Part 1: $r5\n";
        } elsif (exists $seen{$r5}) {
          print "Part 2: $previous\n";
          exit;
        }
        $seen{$r5}++;
        print STDERR "$r5\n";
        $previous = $r5;
# line 29
d;      if ($r3) { goto L31 }                     # addr 3 4 4
d;      goto L6;                                  # seti 5 1 4
d; L31: exit(0);
