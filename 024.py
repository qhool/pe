from math import factorial

tot = 0
n = 9
nperm = 0
digits = range(10)
final = []
while n > 0:
    if tot + factorial(n) < 10**6:
        #print n
        tot += factorial(n)
        nperm += 1
    else:
        final.append( digits.pop(nperm) )
        nperm = 0
        n -= 1
#
print ''.join(map(str, final + digits)) #add any remaining digits

