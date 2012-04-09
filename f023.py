from funcs import primes, get_abundant_numbers

plist = primes( 10**5 )

abunds = get_abundant_numbers( 2, 30000, plist )

def sum_of_2_abunds( n ):
    a = 0
    z = len(abunds) - 1
    while a <= z:
        cand = abunds[a] + abunds[z]
        if cand == n:
            return (abunds[a],abunds[z])
        elif cand < n:
            a += 1
        else:
            z -= 1
    return None

tot = 0
for i in range(1, 28123):
    if sum_of_2_abunds(i) == None:
       tot += i

print tot 
