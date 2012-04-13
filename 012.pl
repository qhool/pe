#!/usr/bin/perl
use warnings;
use strict;

sub count_divisors {
  my $n = shift;
  my $ndiv = 2;
  for my $i (2..int($n/2)) {
    if( $n % $i == 0 ) {
      $ndiv++;
    }
  }
  return $ndiv;
}

my $t = 0;
my $i = 0;

my $max_divs = 0;
while ( 1 ) {
  $i++;
  $t += $i;
  my $n_div = count_divisors( $t );
  if( $n_div > $max_divs ) {
    print "$t has $n_div divisors\n";
    $max_divs = $n_div;
    if( $n_div > 200 ) {
      last;
    }
  }
}

print "$t\n";
