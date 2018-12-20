package AoC::Helpers;
use v5.10;
use strict;
use warnings;
use Exporter qw(import);

use constant
  {
   DEBUG => $ENV{AoC_DEBUG},
   TEST => $ENV{AoC_TEST},
   X => 0,
   Y => 1,
   MIN => 0,
   MAX => 1,
   MINX => 0,
   MINY => 1,
   MAXX => 2,
   MAXY => 3,
   NUM_E => 2.71828182846,
   NUM_PI => 3.14159265359,
   SQRT_2 => 1.41421356237,
  };

use Data::Dumper;
use Storable qw/dclone/;
use List::Util qw/min max minstr maxstr sum product pairs/;

our %EXPORT_TAGS = ( 'all' => [ qw(
                                    X Y
                                    MIN MAX
                                    MINX MINY MAXX MAXY
                                    DEBUG TEST
                                    NUM_PI NUM_E SQRT_2

                                    log10

                                    dclone
                                    min max minstr maxstr sum product pairs
                                    minmax_xy

                                    bold bold_on bold_off red
                                    pretty_grid
                                    safe_exists
                                    dd
                                    visit_checker
) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our $VERSION = '0.01';

sub visit_checker {
  my %v = ();
  return sub {
    my $k = join '!', @_;
    my $res = exists $v{$k};
    $v{$k}++;
    return $res;
  };
}

sub minmax_xy {
  my ($bb, $x, $y) = @_;
  $bb->[MINX] = $x if (!defined $bb->[MINX] || $bb->[MINX] > $x);
  $bb->[MAXX] = $x if (!defined $bb->[MAXX] || $bb->[MAXX] < $x);
  $bb->[MINY] = $y if (!defined $bb->[MINY] || $bb->[MINY] > $y);
  $bb->[MAXY] = $y if (!defined $bb->[MAXY] || $bb->[MAXY] < $y);
}

sub dd {
  print STDERR Data::Dumper->Dump(@_);
}

sub log10 {
  log($_[0])/log(10);
}

sub red {
  "\033[31m".$_[0]."\033[37m";
}

sub bold {
  bold_on().$_[0].bold_off()
}

sub bold_on {
  "\033[7m"
}

sub bold_off {
  "\033[27m"
}

sub pretty_grid {
  my ($min, $max, $sq_fn, $row_start_fn, $row_end_fn, $number) = @_;
  $sq_fn //= sub { '!' };
  $row_start_fn //= sub { '' };
  $row_end_fn //= sub { '' };
  my $r = '';
  my $NX = ($min->[X] < 0 ? 1 : 0) + int(1+log10($max->[X]));
  my $NY = ($min->[Y] < 0 ? 1 : 0) + int(1+log10($max->[Y]));
  for my $y ($min->[Y] .. $max->[Y]) {
    $r .= $row_start_fn->($y);
    for my $x ($min->[X] .. $max->[X]) {
      $r .= $sq_fn->($x, $y);
    }
    $r .= sprintf " %-${NY}d", $y if ($number);
    $r .= $row_end_fn->($y);
    $r .= "\n";
  }
  if ($number) {
    for my $place (map { 10**$_ } reverse 0 .. $NX-1) {
      for my $x ($min->[X] .. $max->[X]) {
        $r .= abs($x) >= $place ? int(abs($x)/$place)%10 : ' ';
      }
      $r .= "\n";
    }
  }
  return $r;
}

sub safe_exists {
  my ($h, @k) = @_;
  for my $i (0..@k-2) {
    if (exists $h->{$k[$i]}) {
      $h = $h->{$k[$i]};
    } else {
      return;
    }
  }
  return exists $h->{$k[$#k]};
}

sub safe_value {
  my ($h, @k) = @_;
  for my $i (0..@k-2) {
    if (exists $h->{$k[$i]}) {
      $h = $h->{$k[$i]};
    } else {
      return;
    }
  }
  return $h->{$k[$#k]};
}

1;
__END__

=head1 NAME

AoC::Helpers - Perl extension to help with Advent of Code

=head1 SYNOPSIS

  use AoC::Helpers qw/:all/;
  blah blah blah

=head1 DESCRIPTION

Some simple functions to help with Advent of Code.

=head2 EXPORT

None by default.

=head1 AUTHOR

Mark Hindess, E<lt>site-github@temporalanomaly.comE<gt>

=head1 SEE ALSO

L<perl>.

=cut
