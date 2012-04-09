#!/usr/bin/env python

def corners(n):
    yield 1
    r = 1
    x = 1
    while True:
        for i in range(0,4):
            x += r*2
            yield x
        r += 1
        if r >= n:
            break
d = 1001
print sum(corners((d+1)/2))
