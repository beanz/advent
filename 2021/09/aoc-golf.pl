#!/usr/bin/env perl -0n
use warnings;
use strict;
my$u=undef;
my$w=index($_, "\n");
s/\n/9/g;
my $n=$w+1;
my $c;
my @s;
for my$ch(0..8){
  while(s/$ch/_/){
    $c+=1+$ch;
    while(s/_\K[^9_]/_/||s/[^9_](?=_)/_/||s/_.{$w}\K[^9_]/_/||
      s/[^9_](?=.{$w}_)/_/) {
      p();
    }
    push@s,~~s/_/9/g;
  }
}
p();
@s=sort{$a<=>$b}@s;
print"Part 1: $c\nPart 2: ",$s[-3]*$s[-2]*$s[-1],"\n";
sub p{
  $ENV{A}&&print"\033[H\033[2J",map{"$_\n"}unpack("(A$n)*")and select$u,$u,$u,0.5;
}
__END__
perl -0ne '$u=undef;$w=index($_, "\n");s/\n/9/g;$n=$w+1;$c;@s;for $ch(0..8){while(s/$ch/_/){$c+=1+$ch;while(s/_\K[^9_]/_/||s/[^9_](?=_)/_/||s/_.{$w}\K[^9_]/_/||s/[^9_](?=.{$w}_)/_/) {p();}push@s,~~s/_/9/g;}}p();@s=sort{$a<=>$b}@s;print"Part 1: $c\nPart 2: ",$s[-3]*$s[-2]*$s[-1],"\n";sub p{$ENV{A}&&print"\033[H\033[2J",map{"$_\n"}unpack("(A$n)*")and select$u,$u,$u,0.5;}' <input.txt
