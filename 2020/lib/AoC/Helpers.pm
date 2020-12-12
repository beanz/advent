package AoC::Helpers;
use v5.10;
use strict;
use warnings;
use Exporter qw(import);

use constant
  {
   DEBUG => $ENV{AoC_DEBUG}//0,
   TEST => $ENV{AoC_TEST}//0,
   VISUAL => $ENV{AoC_VISUAL}//0,
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
use List::MoreUtils qw/zip pairwise/;
use POSIX qw/ceil floor round/;

our %EXPORT_TAGS = ( 'all' => [ qw(
                                    X Y
                                    MIN MAX
                                    MINX MINY MAXX MAXY
                                    DEBUG VISUAL TEST
                                    NUM_PI NUM_E SQRT_2

                                    log10
                                    ceil floor round

                                    dclone
                                    min max minstr maxstr sum product pairs
                                    zip pairwise
                                    minmax_xy

                                    assert assertEq
                                    assertGT assertGreaterThan

                                    bold bold_on bold_off
                                    red cyan yellow green blue magenta
                                    clear goto
                                    pretty_grid
                                    safe_exists
                                    safe_value
                                    dd
                                    visit_checker

                                    hk kh
                                    eightNeighbourOffsets
                                    fourNeighbourOffsets
                                    offsetCompass offsetKey
                                    manhattanDistance
                                    offsetCW
                                    offsetCCW
                                    offsetOpposite
                                    compassOffset
                                    compassOpposite

                                    read_lines
                                    read_lists
                                    read_listy_records
                                    read_chunks
                                    read_chunky_records
) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our $VERSION = '0.01';

sub hk {
  join '!', @_;
}

sub kh {
  [split /!/, $_[0]];
}

sub eightNeighbourOffsets {
  [
   [ -1, -1], [ 0, -1], [ 1, -1],
   [ -1,  0],           [ 1,  0],
   [ -1,  1], [ 0,  1], [ 1,  1],
  ];
}

sub fourNeighbourOffsets {
  [
               [ 0, -1],
    [ -1,  0],           [ 1,  0],
               [ 0,  1],
  ];
}

sub manhattanDistance {
  my ($p1, $p2) = @_;
  return abs($p1->[X]-$p2->[X]) + abs($p1->[Y]-$p2->[Y]);
}

sub offsetCompass {
  offsetKey(@_);
}

sub offsetKey {
  if ($_[0] == -1) {
    if ($_[1] == -1) {
      return 'NW';
    } elsif ($_[1] == 0) {
      return 'W';
    } elsif ($_[1] == 1) {
      return 'SW';
    } else {
      die "Invalid Y offset $_[1]\n";
    }
  } elsif ($_[0] == 0) {
    if ($_[1] == -1) {
      return 'N';
    } elsif ($_[1] == 1) {
      return 'S';
    } else {
      die "Invalid Y offset $_[1]\n";
    }
  } elsif ($_[0] == 1) {
    if ($_[1] == -1) {
      return "NE";
    } elsif ($_[1] == 0) {
      return "E";
    } elsif ($_[1] == 1) {
      return "SE";
    } else {
      die "Invalid Y offset $_[1]\n";
    }
  } else {
    die "Invalid X offset $_[0]\n";
  }
}

sub offsetCW {
  {
    '0!-1' => [  1,  0 ],
    '1!0'  => [  0,  1 ],
    '0!1'  => [ -1,  0 ],
   '-1!0'  => [  0, -1 ],
  }->{hk(@_)} // die "Invalid offset: @_\n";
}

sub offsetCCW {
    offsetCW(@{offsetCW(@{offsetCW(@_)})})
}

sub offsetOpposite {
    [ $_[0]*-1, $_[1]*-1 ]
}

sub compassOffset {
  {
    'N'  => [  0, -1],
    'NE' => [  1, -1],
    'E'  => [  1,  0],
    'SE' => [  1,  1],
    'S'  => [  0,  1],
    'SW' => [ -1,  1],
    'W'  => [ -1,  0],
    'NW' => [ -1, -1],
  }->{$_[0]}
}

sub compassOpposite {
  {
    'N'  => 'S',
    'NE' => 'SW',
    'E'  => 'W',
    'SE' => 'NW',
    'S'  => 'N',
    'SW' => 'NE',
    'W'  => 'E',
    'NW' => 'SE',
  }->{$_[0]}
}

sub assert {
  my ($msg, $exp) = @_;
  die "assert failed: $msg\n" unless ($exp);
  print STDERR "$msg was true\n" if (DEBUG || TEST == 2);
}

sub assertEq {
  my ($msg, $act, $exp) = @_;
  die "failed $msg: expected $exp but was $act\n" unless ($exp eq $act);
  print STDERR "$msg: $act was equal to $exp\n" if (DEBUG || TEST == 2);
}

sub assertGreaterThan {
  my ($msg, $act, $min) = @_;
  die "failed $msg: expected $act > $min\n" unless ($act > $min);
  print STDERR "$msg: $act was greater than $min\n" if (DEBUG || TEST == 2);
}
sub assertGT { assertGreaterThan(@_); }

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

sub cyan {
  "\033[36m".$_[0]."\033[37m";
}

sub yellow {
  "\033[33m".$_[0]."\033[37m";
}

sub blue {
  "\033[34m".$_[0]."\033[37m";
}

sub green {
  "\033[32m".$_[0]."\033[37m";
}

sub magenta {
  "\033[35m".$_[0]."\033[37m";
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

sub clear {
  "\033[3J\033[H\033[2J"
}

sub goto {
  sprintf "\033".'[%d;%dH', $_[0]+1, $_[1]+1;
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

sub read_lines {
  my $file = shift;
  open my $fh, '<', $file or die "Failed to open $file: $!\n";
  my @c = <$fh>;
  chomp @c;
  return \@c;
}

sub read_lists {
  my ($file, $rs, $fs) = @_;
  $rs //= "\n";
  $fs //= qr/\s+/;
  open my $fh, '<', $file or die "Failed to open $file: $!\n";
  local $/ = $rs;
  my @c = <$fh>;
  chomp @c;
  return [ map { [ split $fs, $_ ] } @c ];
}

sub read_listy_records {
  my ($file, $rs, $fs, $fn) = @_;
  $rs //= "\n";
  $fs //= qr/\s+/;
  my $c = read_lists($file, $rs, $fs);
  return [ map { { zip @$fn, @$_ } } @$c ];
}

sub read_chunks {
  my ($file, $rs) = @_;
  $rs //= "\n\n";
  open my $fh, '<', $file or die "Failed to open $file: $!\n";
  local $/ = $rs;
  my @c = <$fh>;
  chomp(@c);
  return \@c;
}

sub read_chunky_records {
  my ($file, $rs, $fs, $kvs) = @_;
  $rs //= "\n\n";
  $fs //= qr/\s+/;
  $kvs //= qr/:/;
  my $c = read_chunks($file, $rs);
  return [ map { { map { split $kvs, $_ } split $fs, $_ } } @$c ];
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
