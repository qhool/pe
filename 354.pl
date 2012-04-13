#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;
use bigint;

my $x_dist = sqrt(3)/2;
my $y_dist = 3/4;

my $xd = 3;
my $yd = 9;

sub dist_squared_denom {
  my $x_n = shift;
  my $y_n = shift;
  #print "XN,YN : $x_n , $y_n\n";
  if( ($x_n+$y_n)%2 != 0 ) {
    return undef;
  } else {
    return $x_n**2 * $xd + $y_n**2 * $yd;
  }
}

sub spiral {
  my $x = 0;
  my $y = 0;

  my $stop = 200;

  my @sides_plus = ([0,1],[-1,0],[0,-1],[1,0]);
  my $side = 0;
  #my $new_loop = 1;

  my @dsds;
  my $max_dsd_prn = 0;
  my @dsd_counts;
  my %meta_counts;
  while( 1 ) {
    #print "$side / XY : $x,$y\n";
    my $dsd = dist_squared_denom( $x, $y );
    if( defined $dsd ) {
      #print "$x,$y = ", $dsd/4, "\n";
      $dsd_counts[$dsd]++;
    }
    if( abs($x) == abs($y) and abs($x) > 0 ) {
      $side = ($side + 1)%4;
    }
    if( $y == 0 and $x >= 0 ) {
      $x++;
      #$new_loop = 1;
      my $fake_dsd = $x**2 * 3 - 1;
      for my $n ($max_dsd_prn+1..$fake_dsd) {
	if( defined( $dsd_counts[$n] ) ) {
	  print "$dsd_counts[$n] cells at distance sqrt(", $n/4, ")\n" ;
	  $max_dsd_prn = $n;
	  $meta_counts{$dsd_counts[$n]}++;
	}
      }
      if( $fake_dsd >= $stop ) {
	last;
      }

    } 
      #$new_loop = 0;
    $x += $sides_plus[$side]->[0];
    $y += $sides_plus[$side]->[1];
  }
  print Data::Dumper::Dumper( \%meta_counts );

  if( exists $meta_counts{450} ) {
    print "ANSWER: $meta_counts{450}\n"
  }
}


spiral()
