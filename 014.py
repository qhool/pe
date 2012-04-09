#!/usr/bin/env python

max_chain = 0
max_chain_start = -1
for i in range(1,10**6):
    n = i
    chain_len = 1
    while n > 1:
        if n%2 == 0:
            n = n/2
        else:
            n = 3*n + 1
        chain_len += 1
    if chain_len > max_chain:
        max_chain = chain_len
        max_chain_start = i
        print "{0} creates a {1} item chain.".format( i, chain_len )

