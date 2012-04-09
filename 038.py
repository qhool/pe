#!/usr/bin/env python
from funcs import permute

for p in permute( range(9,0,-1) ):
    if p[0] < 9:
        print "Fail!"
        exit()
    pd = ''.join( map(str,p) )
    print pd
    for nlen in range(2,6):
        prod = pd[:nlen]
        n = int(prod)
        for i in range(2,10):
            prod += str(n*i)
            if len(prod) >= len(pd):
                break
            if prod != pd[:len(prod)]:
                break
        if i == 2 and len(prod) > len(pd):
            break
        if prod == pd:
            print "{0} = {1} x ({2})".format(pd,n,','.join(map(str,range(1,i+1))))
            exit()
        
        
