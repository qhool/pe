#!/usr/bin/env python
vals = set()

for a in range(2,101):
    for b in range(2,101):
        vals.add(a**b)

print len(vals)
