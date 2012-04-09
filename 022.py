#!/usr/bin/env python
import string
from operator import mul

f = open('names.txt')

names = map( string.upper, map( lambda n: n.strip('"'), f.read().split(',') ) )
names.sort()
scores = map( lambda n: sum( map( lambda c: ord(c) - ord('A') + 1, n ) ), names )
print names[0], ': ', scores[0]

print sum( map( lambda i: (i+1)*scores[i], range(len(scores)) ) )
