require 'rational'
require 'arr_util'

def rats_for( d )
  (1..(d-1)).each { |n| yield Rational(n,d) }
end
    
def sorted_rats( max_d, first = nil, last = nil )
  min_d = max_d/2
  last ||= 1
  last_v = last.to_f
  first ||= Rational(1,max_d)
  first_v = first.to_f
  print first_v, "...", last_v, "\n"
  vals = (0..(max_d-min_d)).map { 
    |i|
    n = [1,((max_d-i)*first.numerator)/first.denominator].max
    [n,max_d-i,n.to_f/(max_d-i).to_f] 
  }

  vals.sort!{ |a,b| a[2] <=> b[2] }
  print "sorted!\n"
  prev_v = 0
  while true do
    val = vals.shift
    return if val[2] >= last_v
    if val[2] != prev_v and val[2] >= first_v then 
      yield Rational( val[0], val[1] )
    end
    prev_v = val[2]
    val = [ val[0] + 1, val[1], nil ]
    val[2] = val[0].to_f / val[1].to_f
 
    idx = vals.binary_search_by(val[2]){ |x| x[2] }
    (idx..vals.length).each do
      |idx|
      break if idx == vals.length
      break if vals[idx][2] > val[2]
    end
    vals.insert( idx, val )
  end
end
      
