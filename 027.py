#!/usr/bin/env python
from funcs import is_prime

max_num = 0
for a in range(-999,1000):
    for b in range(-999,1000):
        n = 0
        while True:
            if not is_prime( n**2 + a * n + b ):
                break
            n += 1
        if n > max_num:
            print "n^2 + {0}n + {1} produces {2} primes. a*b = {3}".format(a,b,n,a*b)
            max_num = n
