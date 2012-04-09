#!/usr/bin/env python
from funcs import get_divisors

acs = set()
amicables = set()
for n in range(1,10001):
    dsum = sum(get_divisors(n,in_order=True)[:-1])
    if dsum != n:
        acs.add( tuple([n,dsum]) )
        if (dsum,n) in acs:
            amicables.add(n)
            amicables.add(dsum)

print amicables
print sum(amicables)

