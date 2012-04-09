require 'root'

def dsum(n)
  x = SquareRootExpansion.new(n)
  tot = 0
  i = 0
  x.to_i.to_s.split('').each { |d|
    tot += d.to_i
    i += 1
  }
  x.each { |d|
    tot += d
    i += 1
    break if i >= 100
  }
  if i < 100 then
    return 0
  else 
    return tot
  end
end
  

#x = SquareRootExpansion.new(2)
#print x.to_i, "."

#10.times do
#  print x.next_digit, "\n"
#end

#i = 0
#tot = 0
#.each { |d|
#  i += 1
#  break if i >= 100
#  print d
#  tot += d
#}
#print "\n"
print ( (1..100).map { |n| dsum(n) } ).reduce (:+), "\n"
