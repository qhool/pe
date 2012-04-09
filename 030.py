#!/usr/bin/env python

n = 2
tot = 0
p = 5
while True:
    n2 = sum( map(lambda d: int(d)**p,str(n)) )
    if n == n2:
        tot += n
        print n, ", sum = ", tot
    n += 1
