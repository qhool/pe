from operator import mul
from funcs import primes

stride=reduce( mul, primes(20) )

n = stride
while True:
    is_div = True;
    for i in range(1,21):
        if n % i != 0:
            is_div = False
            break
    if is_div:
        break
    n += stride

print n
