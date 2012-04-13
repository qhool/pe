#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;
use bigint;

my $xd = 3;
my $yd = 9;

my @perfect_squares;
my %perfects;

sub extend_perfects {
  my $max = shift;
  $max = sqrt($max);
  my $min = 1;
  if( @perfect_squares > 0 ) {
    $min = sqrt($perfect_squares[$#perfect_squares]) + 1;
  }

  for my $i ($min..$max) {
    my $p = $i**2;
    #print "PERFECT $i: $p\n";
    push( @perfect_squares, $p );
    $perfects{$p} = '';
  }
}

sub count_ways {
  my $n = shift;

  my $ways = 0;
  if( $n%3 != 0 ) {
    return 0;
  }
  #print "N: $n \n";
  my $m = $n/3;
  my $max_x = $m;
  my $max_y = sqrt( $m / 3 );
  extend_perfects( $m );
  #print "MAX: $max\n";
  for( my $y = 0; $y <= $max_y; $y++ ) {
    #print "Y: $y\n";
    my $xsq = $m - 3 * $y**2;
    #print "x^2 = $xsq\n";
    #my $x = sqrt($xsq);
    if( exists $perfects{$xsq} ) { #$x**2 == $xsq ) {
      my $x = sqrt( $xsq );
      if( ($x + $y)%2 == 0 ) {
	#print "$x, $y\n";
	if( $x == 0 or $y == 0 ) {
	  $ways += 2;
	} else {
	  $ways += 4;
	}
      }
    }
  }
  return $ways;
}

my %metacounts;
#for my $i (1..57) {
my $end = 5*10**11;
my $i = 1;
while( 1 ) {
  #next if $i%3 != 0;
  my $nways = count_ways($i*12);

#for my $i (3000000..3000012) {
#  my $nways = count_ways($i*12);

  if( $nways > 0 ) {
    print "$nways cells at distance sqrt(", $i*3, ")\n";
    $metacounts{$nways}++
  }
  if( sqrt($i*3) > $end ) {
    last;
  }
  $i++;
}

#print Data::Dumper::Dumper( \%perfects );
#print count_ways( 12000000 ), "\n";

print Data::Dumper::Dumper( \%metacounts );

print $metacounts{450}
