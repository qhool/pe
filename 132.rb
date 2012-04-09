def r(n) 
  return ("1" * n).to_i
end

def r2(n)
  return (("10" * ((n-2)/2)) + "1").to_i
end

def prime_sieve(max)
  primes = [2]
  sieve = Array.new(max/2)
  (3..max).step(2) do |p|
    if sieve[(p-3)/2] == nil
      (p*p..max).step(2*p) do |n|
        sieve[(n-3)/2] = 1
      end
    end
  end
  sieve.each_index do |i|
    primes << i*2 + 3
  end
  return primes
end

def factors(n,max_num,primes)
  f = []
  nfactors = 0
  primes.each do |p|
    next if p < 13
    break if n == 1
    dm = [0,0]
    until n == 1 or dm[1] != 0 do
      #print n, ", ", p, "\n"
      dm = n.divmod( p )
      if dm[1] == 0
        n = dm[0]
        f << p
        print p,"\n"
        return f if f.size == max_num
      end
    end
  end
  return f
end

primes = prime_sieve(10**6)
#print prime_sieve(100).inspect,"\n"
  
#(1..5).each do |n|
#  x = r(10**n)
#  print "r(10^",n, "): ", factors(x,primes).inspect,  "\n"
#end
x = r2(10**9)
print "got x\n"
f = factors(x,39,primes)
print "sum: ", 11 + f.inject(:+), "\n"
