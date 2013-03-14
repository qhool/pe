#!/usr/bin/perl
use warnings;
use strict;


my @cypher;
{
  local $/ = undef;
  open C, "<cipher1.txt";
  my $txt = <C>;
  close C;
  @cypher = split(',',$txt);
  print @cypher, "\n";
}

print ( (107 ^ 65), "\n" );

sub bythirds {
  my $offset = shift;
  my @vals = @_;
  my @ret;
  for( my $i = $offset; $i <= $#vals; $i += 3 ) {
    push @ret, $vals[$i];
  }
  return \@ret;
}

sub key_letter_score {
  my $key = shift;
  my @vals = @_;
  my @try = map { $_ ^ $key } @vals;
  my $score = 0;
  for my $v (@try) {
    if( $v < 32 or 176 < $v ) {
      $score -= 3;
    } elsif( $v == 32 or (65 <= $v and $v <= 90)
	     or (97 <= $v and $v <= 122) ) {
      $score += 1;
    }
  }
  return $score;
}
my @thirds = map { bythirds($_, @cypher) } (0..2);

sub best_key_letters {
  my @vals = @_;
  return
    map { $_->[0] }
    sort { $b->[1] <=> $a->[1] } 
    map { [$_, key_letter_score($_,@vals)] } (97..122);
}

my @key_letters = map { [best_key_letters(@$_)] } @thirds;

print join(',', map { $_->[0] } @key_letters ), "\n";

sub use_key {
  my $key = shift;
  my $vals = shift;
  return map { $key->[$_%3] ^ $vals->[$_] } (0..$#$vals);
}

my @plain = use_key( [map {$_->[0]} @key_letters], \@cypher );
print pack( "c*", @plain ), "\n";

my $sum = 0;
map { $sum += $_ } @plain;

print "\nASCII Sum: $sum\n";

