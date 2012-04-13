require 'fracs'

n = 0
sorted_rats( 12000, Rational(1,3), Rational(1,2) ) do
  |r|
  #print r, "\n"
  n += 1
end


print n - 1,"\n";
