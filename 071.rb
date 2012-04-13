require 'fracs'

last = nil
max_d = 1000000
sorted_rats( max_d, Rational( (max_d/7)*3 - 1, (max_d/7)*7 ), Rational(3,7) ) do
  |r|
  last = r
end


print last,"\n";
