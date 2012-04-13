require 'primes'
#                  _______                      _______ 
#                   |   |     1        n      n  |   |    1      ___  p
# since phi(n) = n  |   | 1 - -  ==> ------ = -  |   | ------- = | | ___
#                   |   |     p      phi(n)   n  |   | 1 - 1/p   p|n p-1
#                   (p|n)                        (p|n)
# since n/(n-1) --> 1 as n --> infinity, n/phi(n) is maximized when
# n has as many distinct prime factors as possible, and they are as small 
# as possible

max = 200
primes = primesieve(max)

n = 1
primes.each { |p|
  break if n*p > 1000000
  n *= p
}
print n, "\n"
