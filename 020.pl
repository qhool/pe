#!/usr/bin/perl
use warnings;
use strict;
use Data::Dumper;

sub sumd {
  my $n = shift;
  my $s = 0;
  for my $d (split('',$n)) {
    $s += $d;
  }
  return $s;
}

my @digits;
for my $i (2..99) {
  push @digits, ( grep { $_ != 0 and $_ != 1 and $_ != 2 and $_ != 5 } split('',$i) );
}

my %dc;

for my $d (@digits) {
  $dc{$d} += 1;
}

my $deq = 1;
for my $d (@digits) {
  $deq *= $d;
}

#print "deq=$deq\n";

#print Data::Dumper::Dumper( \%dc );

my %reln;
for my $n (1..100) {
  my $sd = sumd($n);
  my $s2d = sumd(3*$n);
  $reln{$sd} = $s2d;
}

print Data::Dumper::Dumper( \%reln );
