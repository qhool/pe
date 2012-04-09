#!/usr/bin/env python
from funcs import perfect_squares
from math import sqrt

def integer_coords(r):
    rsq = r**2
    x = 0
    while x <= r:
        #print x
        slice_rsq = rsq - x**2
        ps_up = perfect_squares(x**2)
        ps_down = perfect_squares(slice_rsq,-1)
        y = ps_up.next()
        z = ps_down.next()
        while y <= z:
            if y + z == slice_rsq:
                yield (x,int(sqrt(y)),int(sqrt(z)))
                y = ps_up.next()
                z = ps_down.next()
            elif y + z < slice_rsq:
                y = ps_up.next()
            else: #y + z > slice_rsq
                z = ps_down.next()
        x += 1

tot = 0
for c in integer_coords(10**10):
    x,y,z = c
    dsq = x**2 + y**2 + z**2
    md = abs(x) + abs(y) + abs(z)
    #count permutations:
    if x == y == z:
        mult = 1
    elif x != y != z:
        mult = 6
    else:
        mult = 3
    #count negatives:
    negm = 0
    negm += 1 if x != 0 else 0
    negm += 1 if y != 0 else 0
    negm += 1 if z != 0 else 0
    mplier = mult * 2**negm
    print c, '-->', dsq, '/', md, '(', mplier, ')'
    tot += md * mplier

print "tot = ", tot
