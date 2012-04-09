
def find_triple():
    for c in range(1,1000):
        for b in range(1,1000-c):
            a = 1000 - b - c
            if c**2 == a**2 + b**2:
                return (a,b,c)

(a,b,c) = find_triple()
print " {0}^2 + {1}^2 = {2}^2 ".format(a,b,c)
print " a*b*c = {0} ".format(a*b*c)
