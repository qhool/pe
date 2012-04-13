require 'primes'
#   n      ___  p
# ------ = | | ___
# phi(n)   p|n p-1
#         
# n/phi(n) is minimized with a few and as large distinct prime factors
# as possible

def pmult(primes,mults)
  n = 1
  mults.each_index { |i|
    if mults[i] > 0 then
      n *= primes[i] ** mults[i]
    end
  }
  return n
end

def rdigi(n)
  n.to_s.split('').sort.join('')
end

primes = primesieve(20000).select { |x| x>2000 }
print "Primelist generated\n"
#primes = [3,5,7,11,13,7919]

#primes = []
#while primes_orig.length > 1 do
#  primes << primes_orig.pop
#  primes << primes_orig.shift
#end
#primes << primes_orig.pop

multiples = [0]

max = 10000000
prev_ratio = 1
n = 1
min_ratio = 100
best_val = nil
while true do
  multiples[0] += 1
  n *= primes[0]
  #next if multiples.reduce(:+) == 1 #no prime numbers

  multiples.each_index { |i|
    break if n < max
    break if i+1 == primes.length
    multiples[i] = 0
    if multiples.length == i+1 then
      multiples << 1
    else
      multiples[i+1] += 1
    end
    n = pmult(primes,multiples)
  }
  break if n > max
  #phi = n
  #print n, "\n"
  #break if n == 4999867
  #next
  phi = 1
  multiples.each_index { |i|
    if multiples[i] > 0 then
      #phi *= (primes[i] - 1)
      #phi /= primes[i]
      phi *= (primes[i] - 1) * ( primes[i] ** (multiples[i] - 1) )
    end
  }
  ratio = n.to_f/phi.to_f
  #print ratio, "\n"
  #if ratio < prev_ratio then
  #  print "X"
  #  #exit
  #else
  #  print "."
  #end
  #prev_ratio = ratio
  if rdigi( n ) == rdigi( phi ) then
    print n, " (ratio = ", ratio, ")"
    if ratio < min_ratio then
      min_ratio = ratio
      best_val = n  
      print " <---- Current Best"
    end
    print "\n"
  end
end
