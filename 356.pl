#!/usr/bin/perl
use warnings;
use strict;
#use bigint;
use Math::BigFloat;
use Math::Complex;

Math::BigFloat->precision(-5);

#my $third = new Math::BigFloat( 1/3 );
#print $third, "\n";
#sub cbrt {
#  my $x = shift;
#  return $x**$third;
#}

sub roots {
  my ($a,$b,$c,$d) = (map { new Math::BigFloat($_) }  @_ );

  my $discrim = 18*$a*$b*$c*$d - 4*$b**3*$d + $b**2*$c**2 - 4*$a*$c**3 - 27*$a**2*$d**2;

  print "DISCRIM: ", $discrim, "\n";

  my $pos_sqr = (27*$a**2*$discrim)->broot(2);
  print $pos_sqr, "\n";
  my @sqrt_term = (cplx(0,$pos_sqr),cplx(0,-1*$pos_sqr));
  my $poly_term = cplx(2*$b**3 - 9*$a*$b*$c + 27*$a**2*$d,0);
  my @cbrt_plus;
  my @cbrt_minus;
  for my $sqr (@sqrt_term) {
    print "$sqr\n";
    push @cbrt_plus, root( 0.5*($poly_term + $sqr), 3 );
    push @cbrt_minus, root( 0.5*($poly_term - $sqr), 3 );
  }

  #print @sqrt_term, "\n";
  print join( "\n   ", @cbrt_plus ), "\n";

}


for my $n (1..30) {
  roots(1,-1*2**new Math::BigFloat($n),0,$n);
}
