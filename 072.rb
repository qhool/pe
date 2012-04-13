require 'primes'


max = 1000000
primes = primesieve(max)
phis = phi_table(primes,max)



#phis.each_index { |i|
#  if phis[i] != phi(primes,i)
#    print i, ": ", phis[i], " != ", phi(primes,i), "\n"
#  end
#}
phis.shift
phis.shift
print phis.reduce(:+), "\n"
