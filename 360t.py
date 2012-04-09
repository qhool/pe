#!/usr/bin/env python
from math import sqrt
from funcs import primes_generator

def can_sqsum(n):
    max_p = int(n/2)
    max_p_if_prime = int(sqrt(n))
    primes = primes_generator()
    p = primes.next()
    mult = 0
    is_prime = True
    while True:
        if n % p == 0:
            mult += 1
            print n, "/", p
            n /= p
            if n == 1:
                break
        else:
            if mult > 0:
                if p % 4 == 3 and mult % 2 == 1:
                    return False
                is_prime = False
            p = primes.next()
            #print p
            mult = 0
            if p > max_p or (is_prime and p > max_p_if_prime):
                break
    return True


r = 10**10
rsq = r**2
print "pre-gen-primes"
max_p = r/2
for p in primes_generator():
    if p >= max_p:
        break
    print p
print "done"

    
i = 0
while i < r:
    slice_rsq = rsq - i**2
    if sqrt(slice_rsq) % 1 == 0:
        print slice_rsq
        if can_sqsum( slice_rsq ):
            print "  Yes"
    i+=1
