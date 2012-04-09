from __future__ import division
from math import sqrt
import operator

def product(t):
    return reduce( operator.mul, t )

def fibs(max):
    f0 = 0
    f = 1
    while f <= max:
        yield f
        (f0,f) = (f,f + f0)

def in_sorted_list( t, n ):
    if len(t) < 1:
        return False
    a = 0
    b = len(t) - 1
    while t[a] < n and t[b] > n and b - a > 1:
        c = a + int((b-a)/2)
        if c == a:
            c += 1
        if t[c] <= n:
            a = c
        else:
            b = c
    if t[a] == n or t[b] == n:
        return True
    else:
        return False


primes_list = [2,3]
def primes_generator():
    for p in primes_list:
        yield p
    n = primes_list[-1]
    while True:
        n += 2
        isprime = True
        for p in primes_list:
            if p**2 > n:
                break
            if n%p == 0:
                isprime = False
                break
        if isprime:
            primes_list.append(n)
            yield n
            
def primes(max,max_count=None):
    primes = []
    for p in primes_generator():
        primes.append(p)
        if p >= max or ( max_count != None and len(primes) >= max_count):
            break
    return primes

def is_prime(n):
    if type(n) != int:
        raise ValueError( "only integers are prime" )
    if primes_list[-1] < n:
        for p in primes_generator():
            if p > n:
                break
    return in_sorted_list(primes_list,n)

def is_palindrome( n ):
    s = str(n)
    if s == s[::-1]:
        return True
    else:
        return False


def prime_factors( n, primes_list = None ):
    max_p = int(n/2)
    if primes_list == None:
        primes_list = primes( max_p )
    factors = []
    i = 0;
    multiplicity = 0;
    while True:
        if n % primes_list[i] == 0:
            multiplicity += 1
            n /= primes_list[i]
        else:
            if multiplicity > 0:
                factors.append( tuple([primes_list[i], multiplicity]) )
                multiplicity = 0
            i += 1
            if i >= len(primes_list) or primes_list[i] > max_p:
                break
    if n > 1 and len(factors) == 0:
        #n is prime:
        factors.append( tuple([n,1]) )
    return factors


def count_divisors( n, primes_list = None, pf_out = None ):
    pf = prime_factors( n, primes_list )
    if pf_out != None:
        pf_out.extend(pf)
    return reduce( operator.mul, map( lambda x: x[1] + 1, pf ), 1 )

def get_divisors( n, primes_list = None, in_order = True ):
    if n == 1:
        return [1]
    pf = []
    n_divisors = count_divisors( n, primes_list, pf )

    #print "NDivs: ", n_divisors

    #this is like counting in a system where each digit has its own base
    npf = len(pf)
    pf_select = [0] * npf

    #print "PF: ", pf
 
    divisors = []
    for i in range(n_divisors):
        #multiply together the primes in pf, with the powers in pf_select:
        div = reduce( operator.mul, 
                      map( lambda i: pf[i][0]**pf_select[i], range(npf) ), 1 )
        divisors.append(div)
        #print "Div: ", div

        pf_select[0] += 1
        for j in range(npf):
            if pf_select[j] > pf[j][1]:
                pf_select[j] = 0
                if j == npf - 1:
                    pf_select = []
                else:
                    pf_select[j+1] += 1
                
    if in_order:
        return sorted(divisors)
    else:
        return divisors
            
def is_abundant( n, primes_list = None ):
    divs = get_divisors( n, primes_list, in_order = False )
    divs.pop()
    if sum(divs) > n:
        return True
    else:
        return False

def get_abundant_numbers( min, max, primes_list = None ):
    ret = []
    for i in range(min,max+1):
        if is_abundant( i, primes_list ):
            ret.append( i )
    return ret


def perfect_squares(start=None,stride=1,start_sqrt=None):
    if start != None:
        i = int(sqrt(start))
    elif start_sqrt != None:
        i = start_sqrt
    else:
        i = 1
    while True:
        yield int(i**2)
        i+=stride

def permute(t):
    if len(t) <= 1:
        yield t
    elif len(t) == 2:
        yield t
        yield t[::-1]
    else:
        for i in range(len(t)):
            for p in permute( t[0:i] + t[i+1:] ):
                yield [t[i]] + p

def select_sublist(t,n):
    n = n % 2 ** (len(t))
    ret = []
    for i in range(len(t)):
        if (n >> i)%2 == 1:
            ret.append( t[i] )
    return ret
