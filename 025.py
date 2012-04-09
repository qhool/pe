#!/usr/bin/env python
from funcs import fibs

target = 10**1000
top = target*4

n = 0
for f in fibs(top):
    n += 1
    if len(str(f).strip()) >= 1000:
        print f
        print n
        exit()
    
