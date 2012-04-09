#!/usr/bin/env python

def cycle(n):
    states = {}
    d0 = 10
    d = 0
    num = 0
    digits = []
    repeat = None
    while True:
        state = (d0,n)
        if states.has_key(state):
            #encountered this state before, now we've repeated
            repeat = states[state]
            break
        else:
            states[state] = num
        d = int(d0/n)
        digits.append(d)
        num += 1
        d = d0 - d*n
        if d == 0:
            return 0, '0.' + ''.join(map(str,digits))
        d0 = d * 10
    return num - repeat, '0.' + ''.join(map(str,digits[0:repeat])) +\
           '(' + ''.join(map(str,digits[repeat:])) + ')'

max_cycle = 0
num_max = 0
i_max = 0
for i in range(1,1000):
    cyc, num = cycle(i)
    if cyc > max_cycle:
        print num
        max_cycle = cyc
        num_max = num
        i_max = i
print """
  1
----- = {1}
{0: ^5d}

Cycle of {2}""".format( i_max, num_max, max_cycle)

