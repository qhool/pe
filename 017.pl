#!/usr/bin/perl
use warnings;
use strict;

sub nw {
  my $n = shift;
  if( $n < 20 ) {
    return ('',qw(one two three four five six seven eight nine),
	    qw(ten eleven twelve thirteen fourteen fifteen),
	    qw(sixteen seventeen eighteen nineteen))[$n]
  } else {
    my $rank = int(log($n)/log(10));
    if( 10**($rank+1) == $n ) {
      $rank++;
    }
    my $dig = int($n/(10**$rank));
    my $rest = $n - $dig*(10**$rank);
    #print "n --> rank/dig/rest: $n --> $rank/$dig/$rest \n";
    if( $rank == 1 ) {
      return qw(twenty thirty forty fifty sixty seventy eighty ninety)[$dig - 2] . ' ' .
	nw( $rest );
    } elsif( $rank == 2 ) {
      return nw($dig) . ' hundred ' . nw($rest);
    } else {
      my $rank3 = int($rank/3);
      my $dig3 = int($n/(10**($rank3*3)));
      return nw($dig3) . ' ' .
	qw(thousand million billion trillion quadrillion)[$rank3 - 1] . ' ' . nw( $n - $dig3*(10**($rank3*3)) );
    }
  }
}

my $len = 0;
for my $i (1..1000) {
  my $w = nw($i);
  $w =~ s/\s//g;
  #print "$w\n";
  $len += length($w);
  if( $i > 100 and $i % 100 != 0 ) {
    $len += 3; #the "and"
  }
}
print "$len\n";
