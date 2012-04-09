from funcs import primes
from math import sqrt

num = 600851475143

for p in primes( int(sqrt(num)+2) )[::-1]:
    if num%p == 0:
        print p
        break
