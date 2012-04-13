require 'rational';

def primesieve(max)
  sieve = Array.new(max/2) { |x| x*2+3 }
  print "sieve generated\n";
  primes = [2]
  sieve.each_index {
    |i|
    p = sieve[i]
    next if p == nil
    #print p," (sieve is ", sieve.length, ")\n"
    primes << p
    x = p*p
    while( x <= max )
      #print x, "\n"
      sieve[(x-3)/2] = nil
      x += 2*p
    end
  }
  return primes
end

def primefactors(primes,n)
  factors = []
  primes.each {
    |p|
    #print n, "? ", p
    break if factors.length == 0 and p*p > n
    multiplicity = 0
    while n > 1
      m = n/p
      break if m*p != n
      n = m
      multiplicity += 1
    end
    #print "^", multiplicity, "\n"
    if multiplicity > 0
      factors << [p,multiplicity]
    end
    break if n == 1
  }
  if factors.length == 0
    factors << [n,1]
  end
  return factors
end

def properdivisors(primes,n)
  factors = primefactors(primes,n)
  mps = Array.new(factors.length) {0}
  divisors = [1]
  while true
    dv = 1
    mps[0] += 1
    mps.each_index {
      |i|
      if mps[i] > factors[i][1]
        mps[i] = 0
        mps[i+1] += 1
      end
      dv *= factors[i][0]**mps[i]
    }
    break if dv == n
    #print dv, "\n"
    divisors << dv
  end
  return divisors
end

def phi(primes,n)
  return nil if n <= 0
  return 1 if n <= 2
  factors = primefactors(primes,n)
  totient = 1
  factors.each { |f|
    totient *= f[0] ** (f[1] - 1) * (f[0] - 1)
  }
  return totient
end

def phi_table(primes,n=nil)
  n ||= primes.last
  vals = (0..n).map{ |n| nil }
  pass2ok = (0..n).map{ |n| false }
  vals[0] = nil
  vals[1] = 1
  #compute for powers of primes:
  primes.each do
    |p|
    (1..(Math.log(n)/Math.log(p)).to_i).each do
      |x|
      #print "phi(",p**x,") = "
      vals[p**x] = p**(x-1)*(p-1)
      #print vals[p**x], "\n"
      pass2ok[p**x] = true
      #print "_"
    end
  end
  #and semiprimes:
  by_products = lambda do
    |start,i,depth|
    (start..(n/i)).each do
      |j|
      if pass2ok[j] and i.gcd(j) == 1 then
        if vals[i*j] == nil then
          #print "phi( ",i,"x",j," ) = ",vals[i]," x ", vals[j], " = "
          vals[i*j] = vals[i] * vals[j]
          #print vals[i*j], "\n"
        end
        if depth > 0 then
          by_products.call( j+1, i*j, depth - 1 )
        end
      end
    end
  end
        
  (1..n).each do
    |i|
    if pass2ok[i] then
      by_products.call( i+1, i, 4 )
    elsif vals[i] == nil then
      #print i, "H\n"
      vals[i] = phi(primes,i)
    end
  end
  return vals
end
  
def combine_multiplicities( primes, mults )
  n = 1
  mults.each_index { |i|
    if mults[i] > 0 then
      n *= primes[i] ** mults[i]
    end
  }
  return n
end


def multiplicities( primes, max, exclusions = nil )
  prime_logs = primes.map { |p| Math.log(p) }
  mults = primes.map { |p| 0 }
  products = primes.map { |p| 1 }
  max_mults = primes.map { |p| 0 }
  last_idx = 0
  primes.each_index { |last_idx| break if primes[last_idx] > max }

  (0..last_idx).each do |i|
    max_mults[i] = (Math.log(max)/Math.log(primes[i])).to_i
  end

  print "last_idx: ", last_idx, "\n"
  print "last_prime: ", primes[last_idx], "\n"

  start = 0
  start_prime = 2
  n = 1
  while true do 
    i = nil
    (start..last_idx).each do
      |i|
      if mults[i] >= max_mults[i]
        mults[i] = 0
      else
        mults[i] += 1
        prod = products[i+1] * primes[i] ** mults[i]
        maxprod_log = Math.log(max/prod)
        products[i] = prod
        (0..(i-1)).each do |j|
          products[j] = prod
          max_mults[j] = (maxprod_log/prime_logs[j]).to_i
        end
        break
      end
    end
    break if i == last_idx
    n = products[0]
    yield [n,mults]
  end
end

