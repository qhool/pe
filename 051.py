#!/usr/bin/env python
from math import log10, ceil
import funcs
import string

max_set = 0
for p in funcs.primes_generator():
    strp = str(p)
    #print strp
    for d in set( strp ):
        primeset = []
        digits = range(10)
        if strp[-1] == d:
            digits = range(1,10,2)
        for d2 in digits:
            if d == d2:
                continue
            p2 = string.replace( strp, d, str(d2) )
            if p2[0] == '0':
                continue
            p2 = int(p2)
            if funcs.is_prime( p2 ):
                primeset.append(p2)
        if len(primeset) > max_set:
            max_set = len(primeset)
            print "{0} {1} ---> {2}".format( max_set, p, primeset )
            if max_set >= 8:
                exit()
