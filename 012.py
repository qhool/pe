from funcs import count_divisors, primes

t = 0
i = 0

plist = primes( 10**4, 500 )

max_divs = 0
while True:
    i += 1
    t += i
    n_div =  count_divisors( t, plist )
    if n_div > max_divs:
        print "{0} has {1} divisors".format( t, n_div )
        max_divs = n_div
        if n_div > 500:
            break

print t
