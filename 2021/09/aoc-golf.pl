#!/usr/bin/perl -0n
use warnings;
use strict;
my$u=undef;
my$w=index($_, "\n");
my$h=(y/\n/\n/);
s/^/'9'x($w+3)/e;
s/\n$/'9'x($w+3)/e;
s/\n/99/g;
my $nw=$w+1;
my $c;
my @s;
for my$ch(0..8){
  while(s/$ch/_/){
    $c+=1+$ch;
    while(s/_\K[^9_]/_/||s/[^9_](?=_)/_/||s/_.{$nw}\K[^9_]/_/||
      s/[^9_](?=.{$nw}_)/_/) {
      p();
    }
    push@s,~~s/_/9/g;
  }
}
p();
@s=sort{$a<=>$b}@s;
print"Part 1: $c\nPart 2: ",$s[-3]*$s[-2]*$s[-1],"\n";
sub p{
  $ENV{A}&&print"\033[H\033[2J",map{"$_\n"}unpack("(A".($w+2).")*")and select$u,$u,$u,0.1;
}
__END__
A=1 perl -0ne '$w=index($_, "\n");$h=(y/\n/\n/);s/^/'9'x($w+3)/e;s/\n$/'9'x($w+3)/e;s/\n/99/g;$nw=$w+1;$c;@s;for $ch(0..8){while(s/$ch/_/){$c+=1+$ch;while(s/_\K[^9_]/_/||s/[^9_](?=_)/_/||s/_.{$nw}\K[^9_]/_/||s/[^9_](?=.{$nw}_)/_/) {p();}push@s,~~s/_/9/g;}}p();@s=sort{$a<=>$b}@s;print"Part 1: $c\nPart 2: ",$s[-3]*$s[-2]*$s[-1],"\n";sub p{$ENV{A}&&print"\033[H\033[2J",map{"$_\n"}unpack("(A".($w+2).")*")and select$u,$u,$u,0.1;}'

