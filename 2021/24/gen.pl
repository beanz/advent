#!/usr/bin/perl
use warnings;
use strict;

use constant ( DEBUG => $ENV{DEBUG} );
my %inst =
  (
   inp => sub {
     my ($a, $b) = @_;
     print "  \$$a = shift \@\$inp;\n";
   },
   add => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a += $b;\n";
     } else {
       print "  \$$a += \$$b;\n";
     }
   },
   mul => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a *= $b;\n";
     } else {
       print "  \$$a *= \$$b;\n";
     }
   },
   div => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a = int(\$$a / $b);\n";
     } else {
       print "  \$$a = int(\$$a / \$$b);\n";
     }
   },
   mod => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a %= $b;\n";
     } else {
       print "  \$$a %= \$$b;\n";
     }
   },
   eql => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a = \$$a == $b ? 1 : 0;\n";
     } else {
       print "  \$$a = \$$a == \$$b ? 1 : 0;\n";
     }
   },
   neq => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a = \$$a == $b ? 0 : 1;\n";
     } else {
       print "  \$$a = \$$a == \$$b ? 0 : 1;\n";
     }
   },
   set => sub {
     my ($a, $b) = @_;
     if ($b =~ /\d/) {
       print "  \$$a = $b;\n";
     } else {
       print "  \$$a = \$$b;\n";
     }
   },
  );

print <<'EOF';
#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
$; = $" = ',';
my $model = shift // 99999999999999;
my @inp = split //, $model;
my $r = prog();
print "\n$r\n";

sub prog {
  my $x = 0;
  my $y = 0;
  my $z = 0;
  return inp0($z, 0);
}
EOF

my $reverse = ~~@ARGV ? '' : 'reverse ';

my $prog;
{
  undef $/;
  $prog = <STDIN>;
}

$prog =~ s!div ([wxyz]) 1\n!!sg;
$prog =~ s!mul ([wxyz]) 0\nadd \1 (\w+)!set $1 $2!sg;
$prog =~ s!eql ([wxyz]) (\w+)\neql \1 0!neq $1 $2!sg;

#print "$prog"; exit;
my @subs = split /inp w\n/, $prog;
print STDERR scalar @subs, "\n";
my $pre = shift @subs;
print STDERR "Pre:\n$pre\nEnd\n\n";

for my $i (0..@subs-1) {
  my $sub = $subs[$i];
  print '
sub inp'.$i.' {
  my ($zi, $ans) = @_;
  state %cache;
  return $cache{$zi} if (exists $cache{$zi});
';
  if ($i == 5) {
    print 'print STDERR "$ans.........\r";'."\n";
  }
  print '
  for my $wi ('.$reverse.'1 .. $inp['.$i.']) {
    my $w = $wi;
    my $x;
    my $y;
    my $z = $zi;
    # prog
';
  for (split /\n/, $sub) {
    chomp;
    my ($inst, @a) = split / /;
    print STDERR "# $inst @a\n";
    my ($a, $b) = @a;
    $inst{$inst}->($a, $b);
  }
  if ($i+1 == @subs) {
    print '
    return $ans*10+$wi if ($z == 0);
  }
  $cache{$zi} = undef;
  return
}
';
  } else {
    print '
    my $r = inp'.($i+1).'($z, $ans*10+$wi);
    return $r if (defined $r);
  }
  $cache{$zi} = undef;
  return;
}
';
  }
}
exit;

