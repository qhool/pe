from funcs import fibs
    
sum = 0     
for n in fibs(4*10**6):
    if n%2 == 0:
        sum += n

print sum
