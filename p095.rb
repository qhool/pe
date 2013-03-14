require 'primes'
require 'ruby-prof'
      
def pdivsum(primes,n) 
  #return ((1..(n-1)).select { |i| (n/i)*i == n }).reduce(0, :+)
  return properdivisors(primes,n).reduce (:+)
end

def amicable_chain(nums,primes,n)
  chain = [n]
  amic = 0
  prev = n
  while( n != amic )
    amic = pdivsum(primes,prev)
    break if amic < 2
    break if amic == prev
    break if amic > 1000000
    break if amic < n
    break if nums[amic] == nil
    if chain.include?( amic )
      chain << amic
      return [ chain.take_while { |x| x != amic },
               chain.drop_while { |x| x != amic } ]
    end
    chain << amic
    prev = amic
  end
  return [chain]
end
    
primes = primesieve(500000)
#primes.each { |p| print p, "\n" }
#print "----\n"
#primefactors(primes,220).each { |pf| print pf.join(":"), "\n" }
print properdivisors(primes,220).join(","),"\n"
print pdivsum(primes,220),"\n"
#exit(0)


nums = Array.new(10000) { |x| x if x > 10 }

max_chain_len = 0
max_chain_min = nil

RubyProf.start()

nums.each_index {
  |i|
  next if nums[i] == nil
  n = nums[i]
  chains = amicable_chain(nums,primes,n)
  chains.each {
    |chain|
    if( chain.length > 1 )
      #print n, " --> ", chain.join(',') , "\n"
      chain.each { |x| nums[x] = nil }
      if( chain.last() == chain.first() )
        #print n, "--> length: ", chain.length, " ; min_val = ", chain.min, "\n"
        if( chain.length > max_chain_len )
          max_chain_len = chain.length
          max_chain_min = chain.min
          print n, "--> length: ", max_chain_len, " ; min_val = ", max_chain_min, "\n"
        end
      end
    end
  }
}
result = RubyProf.stop()
printer = RubyProf::FlatPrinterWithLineNumbers.new(result)
printer.print( STDOUT, {} )


print max_chain_min, "\n";
