#returns a list of array refs to all possible subsequences of the arguments
sub subsequences {
  my $base = (ref($_[0]) eq 'ARRAY')?shift:[];
  return $base unless @_;
  #subsequences consist of subsequences of the tail of the list of args
  #with or without the first item on the list
  return (subsequences([@$base,shift],@_),
	  subsequences([@$base], @_));
}

#returns all values which can be produced by arithmetic combinations
#of the arguments
sub arith_combos {
  my @nums = @_;
  my @combs;

  return @nums if 1 == @nums;

  #subs for each arithmetic operator, plus reversed versions of the
  #non-commutative ones
  my @ops = ( sub { my ($a,$b) = @_; $a + $b },
	      sub { my ($a,$b) = @_; $a * $b },
	      sub { my ($a,$b) = @_; $a - $b },
	      sub { my ($a,$b) = @_; $b - $a },
	      sub { my ($a,$b) = @_; ($b == 0)?0:($a / $b) },
	      sub { my ($a,$b) = @_; ($a == 0)?0:($b / $a) } );

  for my $i (0..$#nums) {
    for my $val (arith_combos( @nums[0..$i-1],
			       @nums[$i+1..$#nums] )) {
      for my $op (@ops) {
	push @combs, $op->( $nums[$i], $val );
      }
    }
  }
  return @combs;
}

#unique values from input, in ascending numerial order
sub uniq_sort {
  return sort { $a <=> $b } keys(%{{map {$_=>1} @_}});
}

#length of longest consecutive run of positive integers 1..n
sub consecutive_run {
  my @numbers = uniq_sort(@_);
  my $i;
  for( $i = 0; $i <= $#numbers; $i++ ) {
    last if $numbers[$i] != $i + 1;
  }
  return $i;
}

my $max_run = 0;
my @best_seq;
for my $ss (grep { 4 == @$_ } subsequences((1..9)) ) {
  my $run = consecutive_run( grep { $_ > 0 && int($_) == $_ } 
			     arith_combos( @$ss ) );
  print "@$ss  $run\n";
  if( $run > $max_run ) {
    $max_run = $run;
    @best_seq = @$ss;
  }
}
print "Best is @best_seq, with $max_run.\n";
