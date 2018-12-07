use strict;
use warnings;
package t::Helpers;
use base qw/Exporter/;
our @EXPORT = qw/run/;
use Test::More;

sub run_one {
  my ($script, $input) = @_;
  open my $fh, "-|", $^X, $script, $input or return "error $!";
  my $c;
  {
    local $/;
    $c = <$fh>;
  }
  chomp $c;
  close $fh;
  return $c;
}

sub run {
  for (@_) {
    my ($script, $input, $res) = @$_;
    is(run_one($script, $input), $res, $script.' '.$input);
  }
  done_testing();
}

1;
