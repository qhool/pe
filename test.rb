require 'primes'
require 'arr_util'

t = (1..10000).map{ |i| i }

#print t.binary_search_by(1000){ |x| x }

print "tlen: ", t.length, "\n"

#t.shuffle!
#t.sort!

t1 = Time.new()

tot_idx = 0
tot_r = 0
niter = 4000
(1..niter).each {
  |i|
  #r = 9995 
  r = i*t.length/niter #rand(9999)
  tot_r += r
  #idx = t.find_index{ |x| x > r }
  idx = t.binary_search_by(r){ |x| x }
  #print r, " at ", idx, "\n"
  idx ||= t.length
  tot_idx += idx
}

print " Avg r: ", tot_r.to_f/niter.to_f, "\n"
print " Avg idx: ", tot_idx.to_f/niter.to_f, "\n";
t2 = Time.new()

print "time: ", t2 - t1, "\n";
